# Use an official CUDA base image with Ubuntu 20.04
FROM nvidia/cuda:11.8.0-cudnn8-devel-ubuntu20.04

# Set environment variables
ENV LD_LIBRARY_PATH /usr/local/cuda/lib64:$LD_LIBRARY_PATH
ENV LD_LIBRARY_PATH /usr/local/cuda/extras/CUPTI/lib64:$LD_LIBRARY_PATH
ENV PATH /usr/local/cuda/bin:$PATH

# Install necessary packages
RUN apt-get update && apt-get install -y --no-install-recommends \
    wget \
    curl \
    git \
    python3-pip \
    python3-dev \
    && rm -rf /var/lib/apt/lists/*

# Downgrade Python packages to the versions available on December 1, 2023
RUN pip3 install torch==2.1.0 \
    torchaudio==2.1.0 \
    torchvision==0.17.1 \
    torchtext==0.17.1 \
    bigframes==0.24.0 \
    google-cloud-aiplatform==1.42.1 \
    regex==2023.12.25 \
    pymc==5.7.2 \
    tornado==6.3.2 \
    spacy==3.6.1 \
    beautifulsoup4==4.11.2 \
    tensorflow-probability==0.22.0 \
    google-cloud-language==2.9.1 \
    transformers==4.35.2 \
    pyarrow==10.0.1 \
    sentencepiece==0.1.99 \
    polars==0.17.3 \
    gdown==4.6.6 \
    tensorflow-hub==0.15.0 \
    flax==0.7.5 \
    huggingface-hub==0.19.4

# Fix possible issues with Hugging Face model downloads freezing
RUN pip3 install huggingface-hub==0.19.4

# Reinstall TTS repository
RUN rm -rf /workspace/TTS/ && git clone --branch xtts_demo -q https://github.com/coqui-ai/TTS.git /workspace/TTS
WORKDIR /workspace/TTS
RUN pip3 install --use-deprecated=legacy-resolver -q -e . \
    && pip3 install --use-deprecated=legacy-resolver -q -r TTS/TTS/demos/xtts_ft_demo/requirements.txt \
    && pip3 install -q typing_extensions==4.8 numpy==1.26.2

# Upgrade torch and torchaudio
RUN pip3 install torch==2.3.0 \
    && pip3 install torchaudio==2.3.0

# Uninstall existing CUDA packages (if any)
RUN apt-get --purge remove "*cublas*" "cuda*" "nsight*" "nvidia*" -y \
    && apt-get autoremove -y \
    && apt-get autoclean -y

# Add the NVIDIA GPG key and CUDA repository
RUN wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2204/x86_64/cuda-ubuntu2204.pin \
    && mv cuda-ubuntu2204.pin /etc/apt/preferences.d/cuda-repository-pin-600 \
    && apt-key adv --fetch-keys https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2204/x86_64/7fa2af80.pub \
    && add-apt-repository "deb https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2204/x86_64/ /" \
    && apt-get update \
    && apt-get -y install cuda-11-8

# Download and install cuDNN package
RUN wget https://developer.download.nvidia.com/compute/cudnn/9.2.1/local_installers/cudnn-local-repo-ubuntu2204-9.2.1_1.0-1_amd64.deb \
    && dpkg -i cudnn-local-repo-ubuntu2204-9.2.1_1.0-1_amd64.deb \
    && cp /var/cudnn-local-repo-ubuntu2204-9.2.1/cudnn-*-keyring.gpg /usr/share/keyrings/ \
    && apt-get update \
    && apt-get -y install libcudnn8 libcudnn8-dev

# Extract cuDNN tar file (assuming you have downloaded cudnn-11.8-linux-x64-v8.x.x.x.tgz)
# ADD cudnn-11.8-linux-x64-v8.x.x.x.tgz /tmp
# RUN tar -xzvf /tmp/cudnn-11.8-linux-x64-v8.x.x.x.tgz -C /tmp

# Copy cuDNN files to CUDA directories
# RUN cp /tmp/cuda/include/cudnn*.h /usr/local/cuda/include \
#     && cp /tmp/cuda/lib64/libcudnn* /usr/local/cuda/lib64 \
#     && chmod a+r /usr/local/cuda/include/cudnn*.h /usr/local/cuda/lib64/libcudnn*

# Verify cuDNN installation
RUN ls /usr/local/cuda/include/cudnn*.h \
    && ls /usr/local/cuda/lib64/libcudnn*

# Run your Python script
CMD ["python3", "TTS/TTS/demos/xtts_ft_demo/xtts_demo.py", "--batch_size", "2", "--num_epochs", "6"]
