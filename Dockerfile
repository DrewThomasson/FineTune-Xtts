# Use an official CUDA base image with Ubuntu 20.04
FROM nvidia/cuda:11.8.0-cudnn8-devel-ubuntu20.04

# Set environment variables
ENV LD_LIBRARY_PATH=/usr/local/cuda/lib64:$LD_LIBRARY_PATH
ENV LD_LIBRARY_PATH=/usr/local/cuda/extras/CUPTI/lib64:$LD_LIBRARY_PATH
ENV PATH=/usr/local/cuda/bin:$PATH
ENV DEBIAN_FRONTEND=noninteractive

# Set timezone to UTC to avoid tzdata prompt
ENV TZ=Etc/UTC

# Install necessary packages
RUN apt-get update && apt-get install -y --no-install-recommends \
    wget \
    curl \
    git \
    software-properties-common \
    python3-software-properties \
    python3-apt \
    && add-apt-repository ppa:deadsnakes/ppa \
    && apt-get install -y python3.10 python3.10-dev python3.10-distutils tzdata \
    && rm -rf /var/lib/apt/lists/*

# Update alternatives to use Python 3.10
RUN update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.10 1 \
    && update-alternatives --install /usr/bin/python python /usr/bin/python3.10 1 \
    && curl https://bootstrap.pypa.io/get-pip.py | python3.10

# Set pip3.10 as default
RUN ln -s /usr/bin/pip3 /usr/bin/pip

# Fix possible issues with Hugging Face model downloads freezing
RUN pip install huggingface-hub==0.19.4

# Reinstall TTS repository
RUN rm -rf /workspace/TTS/ && git clone --branch xtts_demo -q https://github.com/coqui-ai/TTS.git /workspace/TTS
WORKDIR /workspace/TTS

# Install dependencies
RUN pip install --use-deprecated=legacy-resolver -q -e . \
    && pip install --use-deprecated=legacy-resolver -q -r TTS/demos/xtts_ft_demo/requirements.txt \
    && pip install -q typing_extensions==4.8 numpy==1.26.2

# Upgrade torch and torchaudio
RUN pip install torch==2.3.0 \
    && pip install torchaudio==2.3.0

# Install faster-whisper
RUN pip install faster-whisper==0.5.1

# Ensure correct version of tokenizers and transformers
RUN pip install --upgrade transformers tokenizers==0.19.0

# Download the Whisper model
RUN python3 -c "from faster_whisper import WhisperModel; model = WhisperModel('large-v2', device='cpu')"

# Create the /tmp/xtts_ft directory
RUN mkdir -p /tmp/xtts_ft

# Run your Python script
CMD ["python3", "TTS/demos/xtts_ft_demo/xtts_demo.py", "--batch_size", "2", "--num_epochs", "6"]
