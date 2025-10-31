# 🎵 Real-Time AI Music Pipeline (Windows + ONNX Runtime + Cantabile)

A **practical, low-jitter, real-time architecture** for live AI accompaniment or vocal harmonization —  
running entirely on Windows using **ASIO + ONNX Runtime + Cantabile (or any VST host).**

---

## 🧩 Overview

| Component | Role | Runs On |
|------------|------|---------|
| **Audio Callback** | Captures mic input, runs tiny pitch detector, pushes frames | ASIO / CoreAudio |
| **Inference Worker(s)** | Consume audio frames, run ONNX model for chords/MIDI | CPU or GPU |
| **MIDI Scheduler** | Sends time-stamped events to virtual MIDI port | Background Thread |
| **Cantabile (VST Host)** | Receives MIDI → Plays instruments / accompaniment | Windows DAW |

---

## 🔧 Block Diagram (Textual)

```
Mic (ADC) → [ASIO Low-Latency Callback]
├─→ Direct Hardware Monitor (Dry Vocal)
└─→ Audio Callback (64 samples @ 48 kHz)
├─→ Lightweight Pitch Detector → Immediate Pitch Estimate
└─→ Push Audio Frames + Pitch Metadata → Lock-Free FIFO → Inference Worker(s)

Inference Worker(s)
├─→ Accumulate Sliding Context → Preprocess → ONNX Runtime (CUDA/TensorRT/CPU)
└─→ Predict Chords / MIDI / Control Messages

MIDI Output
├─→ Send Timestamped MIDI → Virtual MIDI Port
└─→ Cantabile Receives → VSTi → Audio Out → Speakers / Headphones

```


---

## ⚙️ Key Design Principles

- Keep the **audio callback tiny** — only capture + cheap pitch detection + enqueue.  
- Do **all heavy neural inference off the audio thread.**  
- **Timestamp** MIDI messages for exact host alignment.  
- **Warm up** ONNX sessions and lock GPU clocks to avoid kernel jitter.  
- Use **ring buffers / lock-free queues** and pin threads to dedicated cores.

---

## 🕒 Timing & Buffer Parameters (Baseline)

| Parameter | Value | Purpose |
|------------|--------|---------|
| **Sample rate** | 48 kHz | Standard pro audio |
| **Buffer size** | 64 samples (1.333 ms) | ASIO block size |
| **Audio callback work** | ≤ 0.5 ms | Must remain real-time safe |
| **Inference cadence** | 256–512 samples (5–10 ms) | Batch inference window |
| **End-to-end latency target** | ≤ 15 ms | Mic → VST output |

### 🔢 Latency Budget Example

| Stage | Typical | Notes |
|--------|----------|-------|
| Interface ADC + Driver | 3–6 ms | RME/ASIO recommended |
| Audio Callback + Pitch | 0.5–2 ms | YIN or small NN |
| Model Inference | 3–8 ms | ONNX Runtime (CPU/GPU) |
| VST Synth | 1–2 ms | Cantabile buffer |
| **Total** | **≈ 8–18 ms** | Tune < 15 ms target |

---

## 🧵 Threading & Dataflow

### 🎚️ Audio Thread / Callback
- Real-time safe (no alloc/lock/syscalls).
- Copies frames → ring buffer, computes pitch, enqueues.

### ⚙️ Inference Thread(s)
- Worker(s) pinned to dedicated cores.
- Pull frames + pitch → preprocess → ONNX Runtime → produce MIDI.

### 🎹 MIDI Scheduler
- Outputs time-stamped MIDI to **loopMIDI** port.
- Optionally compensates host buffer offset.

### 🎛️ Cantabile
- Receives MIDI → routes to VST instruments → plays output.

---

## 💻 Pseudocode Sketch

```c
// Constants
SAMPLE_RATE = 48000
BUFFER_SIZE = 64
INFER_FRAME_ACCUM = 256

// AUDIO CALLBACK
function audioCallback(inputBuffer):
    ringBufferAudio.push(inputBuffer)
    pitch = cheapPitchDetect(inputBuffer)
    ringBufferPitch.push({timestamp: now(), pitch})
    return

// INFERENCE WORKER
while running:
    if ringBufferAudio.hasAtLeast(INFER_FRAME_ACCUM):
        frames = ringBufferAudio.pop(INFER_FRAME_ACCUM)
        input = preprocess(frames)
        modelOutput = onnxSession.run(input)
        midiEvents = convertOutputToMidi(modelOutput, timestamp=now())
        for e in midiEvents: midiQueue.push(e)
    sleep(short)

// MIDI SCHEDULER
while running:
    if midiQueue.pop(event):
        sendMidiToVirtualPort(event)
    sleep(short)
```

## ⚡ ONNX Runtime / GPU Tips

Create one long-lived ONNX session at startup; never recreate per-frame.

Use CUDAExecutionProvider (+ TensorRT EP optional).

Warm-up: run dummy inference to allocate memory & compile kernels.

Batch inputs (5–10 ms of audio) to reduce kernel-launch overhead.

Set GPU power mode → “Prefer Maximum Performance”.

Quantize models (INT8) where possible for deterministic low-latency.

## 🧠 Jitter / Glitch Mitigation

Pin threads (use SetThreadAffinityMask / Process Lasso).

Run audio callback at REALTIME priority.

Disable background Windows services (Wi-Fi, BT, updates).

Monitor DPC latency with LatencyMon.

Provide direct vocal monitoring to avoid performer latency.

Keep 10–20 % CPU headroom.

## 🧪 Validation Checklist

✅ Measure interface round-trip latency (no NN).

✅ Add pitch detector → ensure < 0.5 ms in callback.

✅ Add model inference (warm-up done).

✅ Send MIDI to Cantabile → verify timing consistency.

✅ Stress test under load → ensure no dropouts.

## 🚨 Failure Recovery
Issue	Cause	Mitigation
Inference spike	GPU stall or thread pre-empt	Skip cycle / repeat last chord
DPC spike	Faulty driver	Update / disable offending device
GPU timeout	Kernel launch freeze	Timeout + fallback to CPU model

## 🧰 Minimal Requirements

Audio interface: low-latency ASIO (RME preferred).

Virtual MIDI: loopMIDI
.

Host: Cantabile or any VST host.

Runtime: ONNX Runtime (CPU or CUDA EP).

Language stack: C++ (JUCE or PortAudio + RtMidi) or Rust.

Lock-free queues: e.g. moodycamel::ConcurrentQueue.

## 🧩 Real-Time Implementation Skeleton

Complete C++ sources provided in this repository:

main.cpp — Audio callback → Inference → MIDI

model_inference.* — ONNX Runtime wrapper

pitch_yin.* — Lightweight YIN pitch detector

ring_buffer.h — Lock-free ring buffer

CMakeLists.txt — Visual Studio build config

See: Visual Studio Build Guide

## 🏗️ Visual Studio / Build Instructions (Windows)

### 1. Install:

Visual Studio 2022 (Desktop C++)

CMake ≥ 3.15

PortAudio + RtMidi

ONNX Runtime (CPU or CUDA EP)

loopMIDI + Cantabile

### 2. Configure build:

```
cmake .. -G "Visual Studio 17 2022" -A x64 ^
  -DPORTAUDIO_INCLUDE_DIR="C:/portaudio/include" ^
  -DPORTAUDIO_LIBRARY="C:/portaudio/lib" ^
  -DRTMIDI_INCLUDE_DIR="C:/rtmidi/include" ^
  -DRTMIDI_LIBRARY="C:/rtmidi/lib" ^
  -DONNXRUNTIME_INCLUDE_DIR="C:/onnxruntime/include" ^
  -DONNXRUNTIME_LIBRARY="C:/onnxruntime/lib/onnxruntime.lib"
```

### 3. Build:

```
cmake --build . --config Release
```

### 4. Run:
```
.\Release\realtime_ai_music.exe model.onnx --cuda

```

## 🎯 The Vision

“Let the AI play behind the voice of the saints.”

A fully deterministic, sub-15 ms live AI accompaniment chain —
from microphone to VST harmony — that you can run, measure, and perform with on a Windows machine.

Built with:

C++ 17 / ONNX Runtime

PortAudio + RtMidi

Cantabile VST Host

GPU (CUDA/TensorRT) or CPU fallback

Real-time-safe design, lock-free threading, warm-up strategy

