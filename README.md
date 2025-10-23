PS C:\Scripts\batch_trainer> aws batch describe-job-queues --region us-east-1
{
    "jobQueues": [
        {
            "jobQueueName": "trainer-job-queue",
            "jobQueueArn": "arn:aws:batch:us-east-1:224553687012:job-queue/trainer-job-queue",
            "state": "ENABLED",
            "status": "VALID",
            "statusReason": "JobQueue Healthy",
            "priority": 1,
            "computeEnvironmentOrder": [
                {
                    "order": 1,
                    "computeEnvironment": "arn:aws:batch:us-east-1:224553687012:compute-environment/TrainerComputeEnvironmentGPU"
                }
            ],
            "tags": {},
            "jobStateTimeLimitActions": []
        },
        {
            "jobQueueName": "JobQueue-rivR3vgrh6ipJHfa",
            "jobQueueArn": "arn:aws:batch:us-east-1:224553687012:job-queue/JobQueue-rivR3vgrh6ipJHfa",
            "state": "ENABLED",
            "status": "VALID",
            "statusReason": "JobQueue Healthy",
            "priority": 1,
            "computeEnvironmentOrder": [
                {
                    "order": 1,
                    "computeEnvironment": "arn:aws:batch:us-east-1:224553687012:compute-environment/ComputeEnvironment-CvKLJBQdefogayVQ"
                }
            ],
            "tags": {},
            "jobStateTimeLimitActions": []
        }
    ]
}
PS C:\Scripts\batch_trainer> aws batch describe-compute-environments --region us-east-1
{
    "computeEnvironments": [
        {
            "computeEnvironmentName": "ComputeEnvironment-S2GHcgfanPkxYl8i",
            "computeEnvironmentArn": "arn:aws:batch:us-east-1:224553687012:compute-environment/ComputeEnvironment-S2GHcgfanPkxYl8i",
            "ecsClusterArn": "arn:aws:ecs:us-east-1:224553687012:cluster/AWSBatch-ComputeEnvironment-S2GHcgfanPkxYl8i-fa1784f0-7df7-36e0-aa62-3a28e0a0592d",
            "tags": {},
            "type": "MANAGED",
            "state": "ENABLED",
            "status": "VALID",
            "statusReason": "ComputeEnvironment Healthy",
            "computeResources": {
                "type": "EC2",
                "minvCpus": 0,
                "maxvCpus": 16,
                "desiredvCpus": 0,
                "instanceTypes": [
                    "g4dn.xlarge"
                ],
                "subnets": [
                    "subnet-0331df914ec812ebf",
                    "subnet-043e7b8b4ec32dca7"
                ],
                "securityGroupIds": [
                    "sg-0c3badad55e3f85bb"
                ],
                "instanceRole": "arn:aws:iam::224553687012:instance-profile/BatchInstanceProfile",
                "tags": {},
                "ec2Configuration": [
                    {
                        "imageType": "ECS_AL2_NVIDIA"
                    }
                ]
            },
            "serviceRole": "arn:aws:iam::224553687012:role/aws-service-role/batch.amazonaws.com/AWSServiceRoleForBatch",
            "containerOrchestrationType": "ECS",
            "uuid": "2131c132-5f30-393a-bf59-29b142ceec06"
        },
        {
            "computeEnvironmentName": "ComputeEnvironment-CvKLJBQdefogayVQ",
            "computeEnvironmentArn": "arn:aws:batch:us-east-1:224553687012:compute-environment/ComputeEnvironment-CvKLJBQdefogayVQ",
            "ecsClusterArn": "arn:aws:ecs:us-east-1:224553687012:cluster/ComputeEnvironment-CvKLJBQdefogayVQ_Batch_963f211a-355f-3851-ad92-2e026ab4817a",
            "tags": {},
            "type": "MANAGED",
            "state": "ENABLED",
            "status": "VALID",
            "statusReason": "ComputeEnvironment Healthy",
            "computeResources": {
                "type": "EC2",
                "minvCpus": 0,
                "maxvCpus": 16,
                "desiredvCpus": 0,
                "instanceTypes": [
                    "optimal"
                ],
                "subnets": [
                    "subnet-0331df914ec812ebf",
                    "subnet-043e7b8b4ec32dca7"
                ],
                "securityGroupIds": [
                    "sg-0c3badad55e3f85bb"
                ],
                "instanceRole": "arn:aws:iam::224553687012:instance-profile/BatchInstanceProfile",
                "tags": {
                    "Environment": "Test"
                },
                "launchTemplate": {
                    "launchTemplateId": "lt-0630ba3426c1d908b",
                    "overrides": []
                },
                "ec2Configuration": [
                    {
                        "imageType": "ECS_AL2"
                    }
                ]
            },
            "serviceRole": "arn:aws:iam::224553687012:role/BatchServiceRole",
            "containerOrchestrationType": "ECS",
            "uuid": "f97d1887-cf56-3459-bbdc-03c8a79811b1"
        },
        {
            "computeEnvironmentName": "TrainerComputeEnvironmentGPU",
            "computeEnvironmentArn": "arn:aws:batch:us-east-1:224553687012:compute-environment/TrainerComputeEnvironmentGPU",
            "ecsClusterArn": "arn:aws:ecs:us-east-1:224553687012:cluster/AWSBatch-TrainerComputeEnvironmentGPU-9c1d9423-cfbe-3df2-8da0-bbcb1e97183e",
            "tags": {},
            "type": "MANAGED",
            "state": "ENABLED",
            "status": "VALID",
            "statusReason": "ComputeEnvironment Healthy",
            "computeResources": {
                "type": "EC2",
                "minvCpus": 0,
                "maxvCpus": 16,
                "desiredvCpus": 0,
                "instanceTypes": [
                    "g4dn.xlarge"
                ],
                "subnets": [
                    "subnet-0331df914ec812ebf",
                    "subnet-043e7b8b4ec32dca7"
                ],
                "securityGroupIds": [
                    "sg-0c3badad55e3f85bb"
                ],
                "instanceRole": "arn:aws:iam::224553687012:instance-profile/BatchInstanceProfile",
                "tags": {},
                "ec2Configuration": [
                    {
                        "imageType": "ECS_AL2_NVIDIA"
                    }
                ]
            },
            "serviceRole": "arn:aws:iam::224553687012:role/aws-service-role/batch.amazonaws.com/AWSServiceRoleForBatch",
            "containerOrchestrationType": "ECS",
            "uuid": "719febae-7a3e-3eae-96d8-7853fe190609"
        }
    ]
}
PS C:\Scripts\batch_trainer> aws ecs describe-clusters --clusters <your-cluster-name> --region us-east-1
At line:1 char:38
+ aws ecs describe-clusters --clusters <your-cluster-name> --region us- ...
+                                      ~
The '<' operator is reserved for future use.
    + CategoryInfo          : ParserError: (:) [], ParentContainsErrorRecordException
    + FullyQualifiedErrorId : RedirectionNotSupported

PS C:\Scripts\batch_trainer> aws ecs describe-clusters --clusters TrainerComputeEnvironmentGPU --region us-east-1
{
    "clusters": [],
    "failures": [
        {
            "arn": "arn:aws:ecs:us-east-1:224553687012:cluster/TrainerComputeEnvironmentGPU",
            "reason": "MISSING"
        }
    ]
}
PS C:\Scripts\batch_trainer> aws ecs describe-clusters --region us-east-1
{
    "clusters": [],
    "failures": [
        {
            "arn": "arn:aws:ecs:us-east-1:224553687012:cluster/default",
            "reason": "MISSING"
        }
    ]
}
PS C:\Scripts\batch_trainer> aws batch describe-job-definitions --status ACTIVE --region us-east-1
{
    "jobDefinitions": [
        {
            "jobDefinitionName": "trainer-job-definition",
            "jobDefinitionArn": "arn:aws:batch:us-east-1:224553687012:job-definition/trainer-job-definition:7",
            "revision": 7,
            "status": "ACTIVE",
            "type": "container",
            "parameters": {},
            "containerProperties": {
                "image": "224553687012.dkr.ecr.us-east-1.amazonaws.com/clgihq-trainer:latest",
                "command": [],
                "volumes": [],
                "environment": [
                    {
                        "name": "S3_BUCKET",
                        "value": "clgihq-audio"
                    },
                    {
                        "name": "MODES",
                        "value": "basic,intermediate,advanced"
                    },
                    {
                        "name": "MODEL_OUTPUT",
                        "value": "models/model.onnx"
                    },
                    {
                        "name": "INSTRUMENTS",
                        "value": "piano,organ,guitar,drums"
                    }
                ],
                "mountPoints": [],
                "ulimits": [],
                "resourceRequirements": [
                    {
                        "value": "4",
                        "type": "VCPU"
                    },
                    {
                        "value": "16000",
                        "type": "MEMORY"
                    },
                    {
                        "value": "1",
                        "type": "GPU"
                    }
                ],
                "secrets": []
            },
            "tags": {},
            "containerOrchestrationType": "ECS"
        },
        {
            "jobDefinitionName": "trainer-job-definition",
            "jobDefinitionArn": "arn:aws:batch:us-east-1:224553687012:job-definition/trainer-job-definition:6",
            "revision": 6,
            "status": "ACTIVE",
            "type": "container",
            "parameters": {},
            "retryStrategy": {
                "attempts": 3,
                "evaluateOnExit": []
            },
            "containerProperties": {
                "image": "224553687012.dkr.ecr.us-east-1.amazonaws.com/clgihq-trainer:latest",
                "vcpus": 4,
                "memory": 16000,
                "command": [],
                "volumes": [],
                "environment": [
                    {
                        "name": "S3_BUCKET",
                        "value": "clgihq-audio"
                    }
                ],
                "mountPoints": [],
                "ulimits": [],
                "resourceRequirements": [
                    {
                        "value": "1",
                        "type": "GPU"
                    }
                ],
                "secrets": []
            },
            "tags": {
                "aws:cloudformation:stack-id": "arn:aws:cloudformation:us-east-1:224553687012:stack/TrainerPipeline/1b7de370-aea4-11f0-9138-0e2bf2b23eef",
                "aws:cloudformation:stack-name": "TrainerPipeline",
                "aws:cloudformation:logical-id": "JobDefinition"
            },
            "propagateTags": false,
            "containerOrchestrationType": "ECS"
        },
        {
            "jobDefinitionName": "clgihq-trainer",
            "jobDefinitionArn": "arn:aws:batch:us-east-1:224553687012:job-definition/clgihq-trainer:4",
            "revision": 4,
            "status": "ACTIVE",
            "type": "container",
            "parameters": {},
            "containerProperties": {
                "image": "224553687012.dkr.ecr.us-east-1.amazonaws.com/clgihq-labeler:latest",
                "command": [
                    "python",
                    "/app/trainer.py"
                ],
                "volumes": [],
                "environment": [],
                "mountPoints": [],
                "ulimits": [],
                "resourceRequirements": [
                    {
                        "value": "4",
                        "type": "VCPU"
                    },
                    {
                        "value": "4096",
                        "type": "MEMORY"
                    }
                ],
                "secrets": []
            },
            "tags": {},
            "platformCapabilities": [
                "EC2"
            ],
            "containerOrchestrationType": "ECS"
        },
        {
            "jobDefinitionName": "clgihq-trainer",
            "jobDefinitionArn": "arn:aws:batch:us-east-1:224553687012:job-definition/clgihq-trainer:3",
            "revision": 3,
            "status": "ACTIVE",
            "type": "container",
            "parameters": {},
            "containerProperties": {
                "image": "224553687012.dkr.ecr.us-east-1.amazonaws.com/clgihq-labeler:latest",
                "command": [
                    "python",
                    "/app/labeler.py"
                ],
                "volumes": [],
                "environment": [],
                "mountPoints": [],
                "ulimits": [],
                "resourceRequirements": [
                    {
                        "value": "4",
                        "type": "VCPU"
                    },
                    {
                        "value": "4096",
                        "type": "MEMORY"
                    }
                ],
                "secrets": []
            },
            "tags": {},
            "platformCapabilities": [
                "EC2"
            ],
            "containerOrchestrationType": "ECS"
        },
        {
            "jobDefinitionName": "clgihq-trainer",
            "jobDefinitionArn": "arn:aws:batch:us-east-1:224553687012:job-definition/clgihq-trainer:2",
            "revision": 2,
            "status": "ACTIVE",
            "type": "container",
            "parameters": {},
            "containerProperties": {
                "image": "224553687012.dkr.ecr.us-east-1.amazonaws.com/clgihq-labeler:latest",
                "command": [
                    "echo",
                    "hello world"
                ],
                "volumes": [],
                "environment": [],
                "mountPoints": [],
                "ulimits": [],
                "resourceRequirements": [
                    {
                        "value": "4",
                        "type": "VCPU"
                    },
                    {
                        "value": "4096",
                        "type": "MEMORY"
                    }
                ],
                "secrets": []
            },
            "tags": {},
            "platformCapabilities": [
                "EC2"
            ],
            "containerOrchestrationType": "ECS"
        },
        {
            "jobDefinitionName": "clgihq-labeler",
            "jobDefinitionArn": "arn:aws:batch:us-east-1:224553687012:job-definition/clgihq-labeler:17",
            "revision": 17,
            "status": "ACTIVE",
            "type": "container",
            "parameters": {},
            "retryStrategy": {
                "attempts": 3,
                "evaluateOnExit": []
            },
            "containerProperties": {
                "image": "224553687012.dkr.ecr.us-east-1.amazonaws.com/clgihq-labeler:latest",
                "vcpus": 1,
                "memory": 512,
                "command": [
                    "python",
                    "/app/labeler.py"
                ],
                "jobRoleArn": "arn:aws:iam::224553687012:role/BatchJobRole",
                "volumes": [],
                "environment": [
                    {
                        "name": "S3_BUCKET",
                        "value": "clgihq-audio"
                    },
                    {
                        "name": "INPUT_S3_URI",
                        "value": "s3://clgihq-audio/data/raw_audio/chunk_10.5.25_Sunday_Morning_Service_F-7obzRm74U_000.wav"
                    },
                    {
                        "name": "OUTPUT_S3_URI",
                        "value": "s3://clgihq-audio/data/annotations/chunk_10.5.25_Sunday_Morning_Service_F-7obzRm74U_000.json"
                    }
                ],
                "mountPoints": [],
                "ulimits": [],
                "resourceRequirements": [],
                "logConfiguration": {
                    "logDriver": "awslogs",
                    "options": {
                        "awslogs-group": "/aws/batch/job",
                        "awslogs-region": "us-east-1",
                        "awslogs-stream-prefix": "clgihq-labeler"
                    },
                    "secretOptions": []
                },
                "secrets": []
            },
            "timeout": {
                "attemptDurationSeconds": 7200
            },
            "tags": {
                "aws:cloudformation:stack-name": "clgi-batch-setup",
                "Environment": "Test",
                "aws:cloudformation:logical-id": "JobDefinition",
                "aws:cloudformation:stack-id": "arn:aws:cloudformation:us-east-1:224553687012:stack/clgi-batch-setup/a261fc20-ae07-11f0-8ed6-0affcc3e3ad3"
            },
            "propagateTags": false,
            "containerOrchestrationType": "ECS"
        },
        {
            "jobDefinitionName": "clgihq-labeler",
            "jobDefinitionArn": "arn:aws:batch:us-east-1:224553687012:job-definition/clgihq-labeler:16",
            "revision": 16,
            "status": "ACTIVE",
            "type": "container",
            "parameters": {},
            "retryStrategy": {
                "attempts": 3,
                "evaluateOnExit": []
            },
            "containerProperties": {
                "image": "224553687012.dkr.ecr.us-east-1.amazonaws.com/clgihq-labeler:latest",
                "vcpus": 1,
                "memory": 512,
                "command": [
                    "python",
                    "/app/labeler.py"
                ],
                "jobRoleArn": "arn:aws:iam::224553687012:role/BatchJobRole",
                "volumes": [],
                "environment": [
                    {
                        "name": "S3_BUCKET",
                        "value": "clgihq-audio"
                    },
                    {
                        "name": "INPUT_S3_URI",
                        "value": "s3://clgihq-audio/data/raw_audio/chunk_10.5.25_Sunday_Morning_Service_F-7obzRm74U_000.wav"
                    },
                    {
                        "name": "OUTPUT_S3_URI",
                        "value": "s3://clgihq-audio/data/annotations/chunk_10.5.25_Sunday_Morning_Service_F-7obzRm74U_000.json"
                    }
                ],
                "mountPoints": [],
                "ulimits": [],
                "resourceRequirements": [],
                "logConfiguration": {
                    "logDriver": "awslogs",
                    "options": {
                        "awslogs-group": "/aws/batch/job",
                        "awslogs-region": "us-east-1",
                        "awslogs-stream-prefix": "clgihq-labeler"
                    },
                    "secretOptions": []
                },
                "secrets": []
            },
            "timeout": {
                "attemptDurationSeconds": 7200
            },
            "tags": {
                "aws:cloudformation:stack-name": "clgi-batch-setup",
                "Environment": "Test",
                "aws:cloudformation:logical-id": "JobDefinition",
                "aws:cloudformation:stack-id": "arn:aws:cloudformation:us-east-1:224553687012:stack/clgi-batch-setup/60df0b90-aded-11f0-9711-120eac0d52e1"
            },
            "propagateTags": false,
            "containerOrchestrationType": "ECS"
        },
        {
            "jobDefinitionName": "clgihq-labeler",
            "jobDefinitionArn": "arn:aws:batch:us-east-1:224553687012:job-definition/clgihq-labeler:15",
            "revision": 15,
            "status": "ACTIVE",
            "type": "container",
            "parameters": {},
            "retryStrategy": {
                "attempts": 3,
                "evaluateOnExit": []
            },
            "containerProperties": {
                "image": "224553687012.dkr.ecr.us-east-1.amazonaws.com/clgihq-labeler:latest",
                "vcpus": 1,
                "memory": 512,
                "command": [
                    "python",
                    "/app/labeler.py"
                ],
                "jobRoleArn": "arn:aws:iam::224553687012:role/BatchJobRole",
                "volumes": [],
                "environment": [
                    {
                        "name": "S3_BUCKET",
                        "value": "clgihq-audio"
                    },
                    {
                        "name": "INPUT_S3_URI",
                        "value": "s3://clgihq-audio/data/raw_audio/chunk_10.5.25_Sunday_Morning_Service_F-7obzRm74U_000.wav"
                    },
                    {
                        "name": "OUTPUT_S3_URI",
                        "value": "s3://clgihq-audio/data/annotations/chunk_10.5.25_Sunday_Morning_Service_F-7obzRm74U_000.json"
                    }
                ],
                "mountPoints": [],
                "ulimits": [],
                "resourceRequirements": [],
                "logConfiguration": {
                    "logDriver": "awslogs",
                    "options": {
                        "awslogs-group": "/aws/batch/job",
                        "awslogs-region": "us-east-1",
                        "awslogs-stream-prefix": "clgihq-labeler"
                    },
                    "secretOptions": []
                },
                "secrets": []
            },
            "timeout": {
                "attemptDurationSeconds": 7200
            },
            "tags": {
                "aws:cloudformation:stack-name": "clgi-batch-setup",
                "Environment": "Test",
                "aws:cloudformation:logical-id": "JobDefinition",
                "aws:cloudformation:stack-id": "arn:aws:cloudformation:us-east-1:224553687012:stack/clgi-batch-setup/7dfd5f20-addd-11f0-9ae4-0affff362327"
            },
            "propagateTags": false,
            "containerOrchestrationType": "ECS"
        },
        {
            "jobDefinitionName": "clgihq-labeler",
            "jobDefinitionArn": "arn:aws:batch:us-east-1:224553687012:job-definition/clgihq-labeler:14",
            "revision": 14,
            "status": "ACTIVE",
            "type": "container",
            "parameters": {},
            "retryStrategy": {
                "attempts": 3,
                "evaluateOnExit": []
            },
            "containerProperties": {
                "image": "224553687012.dkr.ecr.us-east-1.amazonaws.com/clgihq-labeler:latest",
                "vcpus": 1,
                "memory": 512,
                "command": [
                    "python",
                    "/app/labeler.py"
                ],
                "jobRoleArn": "arn:aws:iam::224553687012:role/BatchJobRole",
                "volumes": [],
                "environment": [],
                "mountPoints": [],
                "ulimits": [],
                "resourceRequirements": [],
                "logConfiguration": {
                    "logDriver": "awslogs",
                    "options": {
                        "awslogs-group": "/aws/batch/job",
                        "awslogs-region": "us-east-1",
                        "awslogs-stream-prefix": "clgihq-labeler"
                    },
                    "secretOptions": []
                },
                "secrets": []
            },
            "timeout": {
                "attemptDurationSeconds": 7200
            },
            "tags": {
                "aws:cloudformation:stack-name": "clgi-batch-setup",
                "Environment": "Test",
                "aws:cloudformation:logical-id": "JobDefinition",
                "aws:cloudformation:stack-id": "arn:aws:cloudformation:us-east-1:224553687012:stack/clgi-batch-setup/97deb120-adc2-11f0-9c8e-0e013b9c06e7"
            },
            "propagateTags": false,
            "containerOrchestrationType": "ECS"
        },
        {
            "jobDefinitionName": "clgihq-labeler",
            "jobDefinitionArn": "arn:aws:batch:us-east-1:224553687012:job-definition/clgihq-labeler:13",
            "revision": 13,
            "status": "ACTIVE",
            "type": "container",
            "parameters": {},
            "retryStrategy": {
                "attempts": 3,
                "evaluateOnExit": []
            },
            "containerProperties": {
                "image": "224553687012.dkr.ecr.us-east-1.amazonaws.com/clgihq-labeler:latest",
                "vcpus": 1,
                "memory": 512,
                "command": [
                    "python",
                    "/app/labeler.py"
                ],
                "jobRoleArn": "arn:aws:iam::224553687012:role/BatchJobRole",
                "volumes": [],
                "environment": [],
                "mountPoints": [],
                "ulimits": [],
                "resourceRequirements": [],
                "logConfiguration": {
                    "logDriver": "awslogs",
                    "options": {
                        "awslogs-group": "/aws/batch/job",
                        "awslogs-region": "us-east-1",
                        "awslogs-stream-prefix": "clgihq-labeler"
                    },
                    "secretOptions": []
                },
                "secrets": []
            },
            "timeout": {
                "attemptDurationSeconds": 7200
            },
            "tags": {
                "aws:cloudformation:stack-name": "clgi-batch-setup",
                "Environment": "Test",
                "aws:cloudformation:logical-id": "JobDefinition",
                "aws:cloudformation:stack-id": "arn:aws:cloudformation:us-east-1:224553687012:stack/clgi-batch-setup/54020c90-adbd-11f0-affb-0affe1af10e1"
            },
            "propagateTags": false,
            "containerOrchestrationType": "ECS"
        },
        {
            "jobDefinitionName": "clgihq-labeler",
            "jobDefinitionArn": "arn:aws:batch:us-east-1:224553687012:job-definition/clgihq-labeler:12",
            "revision": 12,
            "status": "ACTIVE",
            "type": "container",
            "parameters": {},
            "containerProperties": {
                "image": "224553687012.dkr.ecr.us-east-1.amazonaws.com/clgihq-labeler:latest",
                "command": [
                    "python",
                    "/app/labeler.py"
                ],
                "jobRoleArn": "arn:aws:iam::224553687012:role/BatchEcsTaskExecutionRole",
                "executionRoleArn": "arn:aws:iam::224553687012:role/BatchEcsTaskExecutionRole",
                "volumes": [],
                "environment": [],
                "mountPoints": [],
                "privileged": true,
                "ulimits": [],
                "resourceRequirements": [
                    {
                        "value": "2",
                        "type": "VCPU"
                    },
                    {
                        "value": "2048",
                        "type": "MEMORY"
                    }
                ],
                "logConfiguration": {
                    "logDriver": "awslogs",
                    "options": {
                        "awslogs-group": "/aws/batch/job",
                        "awslogs-region": "us-east-1",
                        "awslogs-stream-prefix": "clgihq-labeler"
                    },
                    "secretOptions": []
                },
                "secrets": [],
                "enableExecuteCommand": true
            },
            "timeout": {
                "attemptDurationSeconds": 1500
            },
            "tags": {},
            "platformCapabilities": [
                "EC2"
            ],
            "containerOrchestrationType": "ECS"
        },
        {
            "jobDefinitionName": "clgihq-labeler",
            "jobDefinitionArn": "arn:aws:batch:us-east-1:224553687012:job-definition/clgihq-labeler:11",
            "revision": 11,
            "status": "ACTIVE",
            "type": "container",
            "parameters": {},
            "containerProperties": {
                "image": "224553687012.dkr.ecr.us-east-1.amazonaws.com/clgihq-labeler:latest",
                "command": [
                    "python",
                    "/app/labeler.py"
                ],
                "jobRoleArn": "arn:aws:iam::224553687012:role/BatchEcsTaskExecutionRole",
                "executionRoleArn": "arn:aws:iam::224553687012:role/BatchEcsTaskExecutionRole",
                "volumes": [],
                "environment": [],
                "mountPoints": [],
                "privileged": true,
                "ulimits": [],
                "resourceRequirements": [
                    {
                        "value": "2",
                        "type": "VCPU"
                    },
                    {
                        "value": "2048",
                        "type": "MEMORY"
                    }
                ],
                "logConfiguration": {
                    "logDriver": "awslogs",
                    "options": {
                        "awslogs-group": "/aws/batch/job",
                        "awslogs-region": "us-east-1",
                        "awslogs-stream-prefix": "clgihq-labeler"
                    },
                    "secretOptions": []
                },
                "secrets": []
            },
            "timeout": {
                "attemptDurationSeconds": 1500
            },
            "tags": {},
            "platformCapabilities": [
                "EC2"
            ],
            "containerOrchestrationType": "ECS"
        },
        {
            "jobDefinitionName": "clgihq-labeler",
            "jobDefinitionArn": "arn:aws:batch:us-east-1:224553687012:job-definition/clgihq-labeler:10",
            "revision": 10,
            "status": "ACTIVE",
            "type": "container",
            "parameters": {},
            "containerProperties": {
                "image": "224553687012.dkr.ecr.us-east-1.amazonaws.com/clgihq-labeler:latest",
                "command": [
                    "python",
                    "/app/labeler.py"
                ],
                "jobRoleArn": "arn:aws:iam::224553687012:role/BatchEcsTaskExecutionRole",
                "executionRoleArn": "arn:aws:iam::224553687012:role/BatchEcsTaskExecutionRole",
                "volumes": [],
                "environment": [],
                "mountPoints": [],
                "ulimits": [],
                "resourceRequirements": [
                    {
                        "value": "2",
                        "type": "VCPU"
                    },
                    {
                        "value": "2048",
                        "type": "MEMORY"
                    }
                ],
                "logConfiguration": {
                    "logDriver": "awslogs",
                    "options": {
                        "awslogs-group": "/aws/batch/job",
                        "awslogs-region": "us-east-1",
                        "awslogs-stream-prefix": "clgihq-labeler"
                    },
                    "secretOptions": []
                },
                "secrets": []
            },
            "tags": {},
            "platformCapabilities": [
                "EC2"
            ],
            "containerOrchestrationType": "ECS"
        },
        {
            "jobDefinitionName": "clgihq-labeler",
            "jobDefinitionArn": "arn:aws:batch:us-east-1:224553687012:job-definition/clgihq-labeler:9",
            "revision": 9,
            "status": "ACTIVE",
            "type": "container",
            "parameters": {},
            "retryStrategy": {
                "attempts": 3,
                "evaluateOnExit": []
            },
            "containerProperties": {
                "image": "224553687012.dkr.ecr.us-east-1.amazonaws.com/clgihq-labeler:latest",
                "vcpus": 1,
                "memory": 512,
                "command": [
                    "python",
                    "/app/labeler.py"
                ],
                "jobRoleArn": "arn:aws:iam::224553687012:role/BatchJobRole",
                "executionRoleArn": "arn:aws:iam::224553687012:role/BatchEcsTaskExecutionRole",
                "volumes": [],
                "environment": [],
                "mountPoints": [],
                "ulimits": [],
                "resourceRequirements": [],
                "logConfiguration": {
                    "logDriver": "awslogs",
                    "options": {
                        "awslogs-group": "/aws/batch/job",
                        "awslogs-region": "us-east-1",
                        "awslogs-stream-prefix": "clgihq-labeler"
                    },
                    "secretOptions": []
                },
                "secrets": [],
                "enableExecuteCommand": true
            },
            "timeout": {
                "attemptDurationSeconds": 7200
            },
            "tags": {
                "Environment": "Test",
                "cloudformation:logical-id": "JobDefinition",
                "cloudformation:stack-id": "arn:aws:cloudformation:us-east-1:224553687012:stack/clgi-batch-setup/75837c90-ac83-11f0-899a-0afffd86e00f",
                "cloudformation:stack-name": "clgi-batch-setup"
            },
            "propagateTags": false,
            "containerOrchestrationType": "ECS"
        },
        {
            "jobDefinitionName": "clgihq-labeler",
            "jobDefinitionArn": "arn:aws:batch:us-east-1:224553687012:job-definition/clgihq-labeler:3",
            "revision": 3,
            "status": "ACTIVE",
            "type": "container",
            "parameters": {},
            "containerProperties": {
                "image": "224553687012.dkr.ecr.us-east-1.amazonaws.com/clgihq-labeler:latest",
                "command": [
                    "echo",
                    "hello world"
                ],
                "jobRoleArn": "arn:aws:iam::224553687012:role/BatchEcsTaskExecutionRole",
                "executionRoleArn": "arn:aws:iam::224553687012:role/BatchEcsTaskExecutionRole",
                "volumes": [],
                "environment": [],
                "mountPoints": [],
                "ulimits": [],
                "resourceRequirements": [
                    {
                        "value": "2",
                        "type": "VCPU"
                    },
                    {
                        "value": "2048",
                        "type": "MEMORY"
                    }
                ],
                "logConfiguration": {
                    "logDriver": "awslogs",
                    "options": {
                        "awslogs-group": "/aws/batch/job",
                        "awslogs-region": "us-east-1",
                        "awslogs-stream-prefix": "clgihq-labeler"
                    },
                    "secretOptions": []
                },
                "secrets": []
            },
            "tags": {},
            "platformCapabilities": [
                "EC2"
            ],
            "containerOrchestrationType": "ECS"
        },
        {
            "jobDefinitionName": "clgihq-labeler",
            "jobDefinitionArn": "arn:aws:batch:us-east-1:224553687012:job-definition/clgihq-labeler:2",
            "revision": 2,
            "status": "ACTIVE",
            "type": "container",
            "parameters": {},
            "containerProperties": {
                "image": "224553687012.dkr.ecr.us-east-1.amazonaws.com/clgihq-labeler:latest",
                "command": [
                    "echo",
                    "hello world"
                ],
                "jobRoleArn": "arn:aws:iam::224553687012:role/BatchEcsTaskExecutionRole",
                "executionRoleArn": "arn:aws:iam::224553687012:role/BatchEcsTaskExecutionRole",
                "volumes": [],
                "environment": [],
                "mountPoints": [],
                "ulimits": [],
                "resourceRequirements": [
                    {
                        "value": "2",
                        "type": "VCPU"
                    },
                    {
                        "value": "2048",
                        "type": "MEMORY"
                    }
                ],
                "secrets": []
            },
            "tags": {},
            "platformCapabilities": [
                "EC2"
            ],
            "containerOrchestrationType": "ECS"
        },
        {
            "jobDefinitionName": "clgi-batch-setup-job-definition",
            "jobDefinitionArn": "arn:aws:batch:us-east-1:224553687012:job-definition/clgi-batch-setup-job-definition:5",
            "revision": 5,
            "status": "ACTIVE",
            "type": "container",
            "parameters": {},
            "containerProperties": {
                "image": "224553687012.dkr.ecr.us-east-1.amazonaws.com/clgihq-labeler:latest",
                "vcpus": 1,
                "memory": 1024,
                "command": [
                    "python",
                    "/app/labeler.py"
                ],
                "jobRoleArn": "arn:aws:iam::224553687012:role/BatchJobRole",
                "executionRoleArn": "arn:aws:iam::224553687012:role/BatchJobRole",
                "volumes": [],
                "environment": [],
                "mountPoints": [],
                "ulimits": [],
                "resourceRequirements": [],
                "logConfiguration": {
                    "logDriver": "awslogs",
                    "options": {
                        "awslogs-group": "/aws/batch/job",
                        "awslogs-region": "us-east-1",
                        "awslogs-stream-prefix": "clgi-batch-setup-labeler"
                    },
                    "secretOptions": []
                },
                "secrets": [],
                "enableExecuteCommand": true
            },
            "tags": {},
            "containerOrchestrationType": "ECS"
        },
        {
            "jobDefinitionName": "clgi-batch-setup-job-definition",
            "jobDefinitionArn": "arn:aws:batch:us-east-1:224553687012:job-definition/clgi-batch-setup-job-definition:4",
            "revision": 4,
            "status": "ACTIVE",
            "type": "container",
            "parameters": {},
            "containerProperties": {
                "image": "224553687012.dkr.ecr.us-east-1.amazonaws.com/clgihq-labeler:latest",
                "vcpus": 1,
                "memory": 1024,
                "command": [
                    "python",
                    "/app/labeler.py"
                ],
                "jobRoleArn": "arn:aws:iam::224553687012:role/BatchJobRole",
                "executionRoleArn": "arn:aws:iam::224553687012:role/BatchJobRole",
                "volumes": [],
                "environment": [
                    {
                        "name": "INPUT_S3_URI",
                        "value": "input_s3_uri"
                    },
                    {
                        "name": "S3_BUCKET",
                        "value": "bucket"
                    },
                    {
                        "name": "OUTPUT_S3_URI",
                        "value": "output_s3_uri"
                    }
                ],
                "mountPoints": [],
                "ulimits": [],
                "resourceRequirements": [],
                "logConfiguration": {
                    "logDriver": "awslogs",
                    "options": {
                        "awslogs-group": "/aws/batch/job",
                        "awslogs-region": "us-east-1",
                        "awslogs-stream-prefix": "clgi-batch-setup-labeler"
                    },
                    "secretOptions": []
                },
                "secrets": [],
                "enableExecuteCommand": true
            },
            "tags": {},
            "containerOrchestrationType": "ECS"
        },
        {
            "jobDefinitionName": "clgi-batch-setup-job-definition",
            "jobDefinitionArn": "arn:aws:batch:us-east-1:224553687012:job-definition/clgi-batch-setup-job-definition:3",
            "revision": 3,
            "status": "ACTIVE",
            "type": "container",
            "parameters": {},
            "containerProperties": {
                "image": "224553687012.dkr.ecr.us-east-1.amazonaws.com/clgihq-labeler:latest",
                "vcpus": 1,
                "memory": 1024,
                "command": [
                    "python",
                    "/app/labeler.py"
                ],
                "jobRoleArn": "arn:aws:iam::224553687012:role/BatchJobRole",
                "executionRoleArn": "arn:aws:iam::224553687012:role/BatchJobRole",
                "volumes": [],
                "environment": [],
                "mountPoints": [],
                "ulimits": [],
                "resourceRequirements": [],
                "logConfiguration": {
                    "logDriver": "awslogs",
                    "options": {
                        "awslogs-group": "/aws/batch/job",
                        "awslogs-region": "us-east-1",
                        "awslogs-stream-prefix": "clgi-batch-setup-labeler"
                    },
                    "secretOptions": []
                },
                "secrets": [],
                "enableExecuteCommand": true
            },
            "tags": {},
            "containerOrchestrationType": "ECS"
        },
        {
            "jobDefinitionName": "clgi-batch-setup-job-definition",
            "jobDefinitionArn": "arn:aws:batch:us-east-1:224553687012:job-definition/clgi-batch-setup-job-definition:2",
            "revision": 2,
            "status": "ACTIVE",
            "type": "container",
            "parameters": {},
            "containerProperties": {
                "image": "224553687012.dkr.ecr.us-east-1.amazonaws.com/clgihq-labeler:latest",
                "vcpus": 1,
                "memory": 1024,
                "command": [
                    "python",
                    "/app/labeler.py"
                ],
                "volumes": [],
                "environment": [],
                "mountPoints": [],
                "ulimits": [],
                "resourceRequirements": [],
                "logConfiguration": {
                    "logDriver": "awslogs",
                    "options": {
                        "awslogs-group": "/aws/batch/job",
                        "awslogs-region": "us-east-1",
                        "awslogs-stream-prefix": "clgi-batch-setup-labeler"
                    },
                    "secretOptions": []
                },
                "secrets": []
            },
            "tags": {},
            "containerOrchestrationType": "ECS"
        },
        {
            "jobDefinitionName": "clgi-batch-setup-job-definition",
            "jobDefinitionArn": "arn:aws:batch:us-east-1:224553687012:job-definition/clgi-batch-setup-job-definition:1",
            "revision": 1,
            "status": "ACTIVE",
            "type": "container",
            "parameters": {},
            "retryStrategy": {
                "attempts": 3,
                "evaluateOnExit": []
            },
            "containerProperties": {
                "image": "224553687012.dkr.ecr.us-east-1.amazonaws.com/clgihq-labeler:latest",
                "vcpus": 1,
                "memory": 512,
                "command": [
                    "python",
                    "/app/labeler.py"
                ],
                "jobRoleArn": "arn:aws:iam::224553687012:role/BatchJobRole",
                "volumes": [],
                "environment": [],
                "mountPoints": [],
                "ulimits": [],
                "resourceRequirements": [],
                "logConfiguration": {
                    "logDriver": "awslogs",
                    "options": {
                        "awslogs-group": "/aws/batch/job",
                        "awslogs-region": "us-east-1",
                        "awslogs-stream-prefix": "clgi-batch-setup-labeler"
                    },
                    "secretOptions": []
                },
                "secrets": []
            },
            "timeout": {
                "attemptDurationSeconds": 7200
            },
            "tags": {
                "aws:cloudformation:stack-name": "clgi-batch-setup",
                "Environment": "Test",
                "aws:cloudformation:logical-id": "JobDefinition",
                "aws:cloudformation:stack-id": "arn:aws:cloudformation:us-east-1:224553687012:stack/clgi-batch-setup/adbb1e80-ad6c-11f0-967d-0eca3f60207f"
            },
            "propagateTags": false,
            "containerOrchestrationType": "ECS"
        }
    ]
}
PS C:\Scripts\batch_trainer> aws autoscaling describe-auto-scaling-groups --region us-east-1
{
    "AutoScalingGroups": [
        {
            "AutoScalingGroupName": "ComputeEnvironment-CvKLJBQdefogayVQ-asg-92be90d0-d718-3bba-878c-9f0be8f476e1",
            "AutoScalingGroupARN": "arn:aws:autoscaling:us-east-1:224553687012:autoScalingGroup:f3376edf-e749-4258-805f-41335930d2d2:autoScalingGroupName/ComputeEnvironment-CvKLJBQdefogayVQ-asg-92be90d0-d718-3bba-878c-9f0be8f476e1",
            "LaunchTemplate": {
                "LaunchTemplateId": "lt-00c47fb61c721d81d",
                "LaunchTemplateName": "Batch-lt-92be90d0-d718-3bba-878c-9f0be8f476e1",
                "Version": "1"
            },
            "MinSize": 0,
            "MaxSize": 3,
            "DesiredCapacity": 0,
            "DefaultCooldown": 300,
            "AvailabilityZones": [
                "us-east-1a",
                "us-east-1b"
            ],
            "LoadBalancerNames": [],
            "TargetGroupARNs": [],
            "HealthCheckType": "EC2",
            "HealthCheckGracePeriod": 0,
            "Instances": [],
            "CreatedTime": "2025-10-20T22:56:41.960Z",
            "SuspendedProcesses": [
                {
                    "ProcessName": "AZRebalance",
                    "SuspensionReason": "User suspended at 2025-10-20T22:56:42Z"
                }
            ],
            "VPCZoneIdentifier": "subnet-0331df914ec812ebf,subnet-043e7b8b4ec32dca7",
            "EnabledMetrics": [],
            "Tags": [
                {
                    "ResourceId": "ComputeEnvironment-CvKLJBQdefogayVQ-asg-92be90d0-d718-3bba-878c-9f0be8f476e1",
                    "ResourceType": "auto-scaling-group",
                    "Key": "Environment",
                    "Value": "Test",
                    "PropagateAtLaunch": true
                }
            ],
            "TerminationPolicies": [
                "Default"
            ],
            "NewInstancesProtectedFromScaleIn": true,
            "ServiceLinkedRoleARN": "arn:aws:iam::224553687012:role/aws-service-role/autoscaling.amazonaws.com/AWSServiceRoleForAutoScaling",
            "TrafficSources": [],
            "AvailabilityZoneDistribution": {
                "CapacityDistributionStrategy": "balanced-best-effort"
            },
            "CapacityReservationSpecification": {
                "CapacityReservationPreference": "default"
            }
        },
        {
            "AutoScalingGroupName": "ComputeEnvironment-CvKLJBQdefogayVQ-asg-a141c4b1-8267-355c-8fb1-da66e04158c6",
            "AutoScalingGroupARN": "arn:aws:autoscaling:us-east-1:224553687012:autoScalingGroup:ec51f4a9-73b5-403f-b5ef-193db2edc72d:autoScalingGroupName/ComputeEnvironment-CvKLJBQdefogayVQ-asg-a141c4b1-8267-355c-8fb1-da66e04158c6",
            "LaunchTemplate": {
                "LaunchTemplateId": "lt-0c9f3c3e1ddca581c",
                "LaunchTemplateName": "Batch-lt-a141c4b1-8267-355c-8fb1-da66e04158c6",
                "Version": "1"
            },
            "MinSize": 0,
            "MaxSize": 1,
            "DesiredCapacity": 0,
            "DefaultCooldown": 300,
            "AvailabilityZones": [
                "us-east-1a",
                "us-east-1b"
            ],
            "LoadBalancerNames": [],
            "TargetGroupARNs": [],
            "HealthCheckType": "EC2",
            "HealthCheckGracePeriod": 0,
            "Instances": [],
            "CreatedTime": "2025-10-21T06:37:36.609Z",
            "SuspendedProcesses": [
                {
                    "ProcessName": "AZRebalance",
                    "SuspensionReason": "User suspended at 2025-10-21T06:37:36Z"
                }
            ],
            "VPCZoneIdentifier": "subnet-0331df914ec812ebf,subnet-043e7b8b4ec32dca7",
            "EnabledMetrics": [],
            "Tags": [
                {
                    "ResourceId": "ComputeEnvironment-CvKLJBQdefogayVQ-asg-a141c4b1-8267-355c-8fb1-da66e04158c6",
                    "ResourceType": "auto-scaling-group",
                    "Key": "Environment",
                    "Value": "Test",
                    "PropagateAtLaunch": true
                }
            ],
            "TerminationPolicies": [
                "Default"
            ],
            "NewInstancesProtectedFromScaleIn": true,
            "ServiceLinkedRoleARN": "arn:aws:iam::224553687012:role/aws-service-role/autoscaling.amazonaws.com/AWSServiceRoleForAutoScaling",
            "TrafficSources": [],
            "AvailabilityZoneDistribution": {
                "CapacityDistributionStrategy": "balanced-best-effort"
            },
            "CapacityReservationSpecification": {
                "CapacityReservationPreference": "default"
            }
        },
        {
            "AutoScalingGroupName": "ComputeEnvironment-CvKLJBQdefogayVQ-asg-bbab14e2-d667-37c3-97e6-d76d6d60389a",
            "AutoScalingGroupARN": "arn:aws:autoscaling:us-east-1:224553687012:autoScalingGroup:cbb40d79-363f-41a2-b7e7-63952023ff7b:autoScalingGroupName/ComputeEnvironment-CvKLJBQdefogayVQ-asg-bbab14e2-d667-37c3-97e6-d76d6d60389a",
            "LaunchTemplate": {
                "LaunchTemplateId": "lt-0eec1e803d1db5ed7",
                "LaunchTemplateName": "Batch-lt-bbab14e2-d667-37c3-97e6-d76d6d60389a",
                "Version": "1"
            },
            "MinSize": 0,
            "MaxSize": 1,
            "DesiredCapacity": 0,
            "DefaultCooldown": 300,
            "AvailabilityZones": [
                "us-east-1a",
                "us-east-1b"
            ],
            "LoadBalancerNames": [],
            "TargetGroupARNs": [],
            "HealthCheckType": "EC2",
            "HealthCheckGracePeriod": 0,
            "Instances": [],
            "CreatedTime": "2025-10-21T06:37:36.715Z",
            "SuspendedProcesses": [
                {
                    "ProcessName": "AZRebalance",
                    "SuspensionReason": "User suspended at 2025-10-21T06:37:36Z"
                }
            ],
            "VPCZoneIdentifier": "subnet-0331df914ec812ebf,subnet-043e7b8b4ec32dca7",
            "EnabledMetrics": [],
            "Tags": [
                {
                    "ResourceId": "ComputeEnvironment-CvKLJBQdefogayVQ-asg-bbab14e2-d667-37c3-97e6-d76d6d60389a",
                    "ResourceType": "auto-scaling-group",
                    "Key": "Environment",
                    "Value": "Test",
                    "PropagateAtLaunch": true
                }
            ],
            "TerminationPolicies": [
                "Default"
            ],
            "NewInstancesProtectedFromScaleIn": true,
            "ServiceLinkedRoleARN": "arn:aws:iam::224553687012:role/aws-service-role/autoscaling.amazonaws.com/AWSServiceRoleForAutoScaling",
            "TrafficSources": [],
            "AvailabilityZoneDistribution": {
                "CapacityDistributionStrategy": "balanced-best-effort"
            },
            "CapacityReservationSpecification": {
                "CapacityReservationPreference": "default"
            }
        }
    ]
}
PS C:\Scripts\batch_trainer> aws batch list-jobs --job-queue <your-job-queue-name> --job-status RUNNABLE --region us-east-1
At line:1 char:33
+ aws batch list-jobs --job-queue <your-job-queue-name> --job-status RU ...
+                                 ~
The '<' operator is reserved for future use.
    + CategoryInfo          : ParserError: (:) [], ParentContainsErrorRecordException
    + FullyQualifiedErrorId : RedirectionNotSupported

PS C:\Scripts\batch_trainer> aws batch list-jobs --job-queue trainer-job-queue --job-status RUNNABLE --region us-east-1
{
    "jobSummaryList": [
        {
            "jobArn": "arn:aws:batch:us-east-1:224553687012:job/cf6cccc3-4a00-4c65-a0aa-851636ea2b84",
            "jobId": "cf6cccc3-4a00-4c65-a0aa-851636ea2b84",
            "jobName": "test-trainer",
            "createdAt": 1761182376803,
            "status": "RUNNABLE",
            "statusReason": "MISCONFIGURATION:JOB_RESOURCE_REQUIREMENT - The job resource requirement (vCPU/memory/GPU) is higher than that can be met by the CE(s) attached to the job queue."
        }
    ]
}
PS C:\Scripts\batch_trainer> aws batch describe-jobs --jobs <job-id> --region us-east-1
At line:1 char:32
+ aws batch describe-jobs --jobs <job-id> --region us-east-1
+                                ~
The '<' operator is reserved for future use.
    + CategoryInfo          : ParserError: (:) [], ParentContainsErrorRecordException
    + FullyQualifiedErrorId : RedirectionNotSupported

PS C:\Scripts\batch_trainer> aws batch describe-jobs --jobs cf6cccc3-4a00-4c65-a0aa-851636ea2b84 --region us-east-1
{
    "jobs": [
        {
            "jobArn": "arn:aws:batch:us-east-1:224553687012:job/cf6cccc3-4a00-4c65-a0aa-851636ea2b84",
            "jobName": "test-trainer",
            "jobId": "cf6cccc3-4a00-4c65-a0aa-851636ea2b84",
            "jobQueue": "arn:aws:batch:us-east-1:224553687012:job-queue/trainer-job-queue",
            "status": "RUNNABLE",
            "attempts": [],
            "statusReason": "MISCONFIGURATION:JOB_RESOURCE_REQUIREMENT - The job resource requirement (vCPU/memory/GPU) is higher than that can be met by the CE(s) attached to the job queue.",
            "createdAt": 1761182376803,
            "dependsOn": [],
            "jobDefinition": "arn:aws:batch:us-east-1:224553687012:job-definition/trainer-job-definition:7",
            "parameters": {},
            "container": {
                "image": "224553687012.dkr.ecr.us-east-1.amazonaws.com/clgihq-trainer:latest",
                "command": [],
                "volumes": [],
                "environment": [
                    {
                        "name": "S3_BUCKET",
                        "value": "clgihq-audio"
                    },
                    {
                        "name": "MODES",
                        "value": "basic,intermediate,advanced"
                    },
                    {
                        "name": "MODEL_OUTPUT",
                        "value": "models/model.onnx"
                    },
                    {
                        "name": "INSTRUMENTS",
                        "value": "piano,organ,guitar,drums"
                    }
                ],
                "mountPoints": [],
                "ulimits": [],
                "networkInterfaces": [],
                "resourceRequirements": [
                    {
                        "value": "4",
                        "type": "VCPU"
                    },
                    {
                        "value": "16000",
                        "type": "MEMORY"
                    },
                    {
                        "value": "1",
                        "type": "GPU"
                    }
                ],
                "secrets": []
            },
            "tags": {},
            "platformCapabilities": [],
            "eksAttempts": []
        }
    ]
}
PS C:\Scripts\batch_trainer>
