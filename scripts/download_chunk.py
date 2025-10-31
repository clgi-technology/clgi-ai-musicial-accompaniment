import yt_dlp
import subprocess
import os
import sys
from datetime import datetime

# Sources: YouTube, Internet Archive, Free Music Archive, StockMusic
SOURCE_CONFIG = {
    'youtube': {
        'extractor': 'youtube',
        'format': 'best[height<=720]',
        'cookies': 'cookies.txt'
    },
    'archive': {
        'extractor': 'archive.org',
        'format': 'best'
    },
    'stockmusic': {
        'extractor': 'stockmusicsite',
        'format': 'best'
    }
}

def chunk_audio(input_file, output_dir, chunk_size=30):
    """Chunk audio to 30s segments"""
    import librosa
    import soundfile as sf

    y, sr = librosa.load(input_file, sr=16000)
    duration = len(y) / sr

    for i in range(0, int(duration), chunk_size):
        start_sample = int(i * sr)
        end_sample = int((i + chunk_size) * sr)
        chunk = y[start_sample:end_sample]

        chunk_file = f"{output_dir}/chunk_{i:03d}.wav"
        sf.write(chunk_file, chunk, sr)
        print(f"Created {chunk_file}")

def download_source(source, urls):
    ydl_opts = {
        'format': SOURCE_CONFIG[source]['format'],
        'outtmpl': 'raw_audio/%(id)s.%(ext)s',
        'writeinfojson': True
    }

    if source == 'youtube':
        ydl_opts['cookiesfrombrowser'] = ('chrome', None, None)

    with yt_dlp.YoutubeDL(ydl_opts) as ydl:
        for url in urls:
            ydl.download([url])

if __name__ == '__main__':
    source = sys.argv[1] if len(sys.argv) > 1 else 'youtube'
    urls_file = sys.argv[2] if len(sys.argv) > 2 else 'urls.txt'

    with open(urls_file) as f:
        urls = [line.strip() for line in f if line.strip()]

    download_source(source, urls)

    # Chunk all downloaded files
    for file in os.listdir('raw_audio'):
        if file.endswith('.mp4') or file.endswith('.webm'):
            chunk_audio(f'raw_audio/{file}', 'raw_audio', 30)
            os.remove(f'raw_audio/{file}')
