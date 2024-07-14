#!/bin/bash

# Downgrade Python packages to the versions available on December 1, 2023
pip install torch==2.1.0
pip install torchaudio==2.1.0
pip install torchvision==0.17.1
pip install torchtext==0.17.1
pip install bigframes==0.24.0
pip install google-cloud-aiplatform==1.42.1
pip install regex==2023.12.25
pip install pymc==5.7.2
pip install tornado==6.3.2
pip install spacy==3.6.1
pip install beautifulsoup4==4.11.2
pip install tensorflow-probability==0.22.0
pip install google-cloud-language==2.9.1
pip install transformers==4.35.2
pip install pyarrow==10.0.1
pip install sentencepiece==0.1.99
pip install polars==0.17.3
pip install gdown==4.6.6
pip install tensorflow-hub==0.15.0
pip install flax==0.7.5
pip install huggingface-hub==0.19.4

# Fix possible issues with Hugging Face model downloads freezing
pip install huggingface-hub==0.19.4

# Install NVIDIA CUDA Toolkit
sudo apt install -y nvidia-cuda-toolkit

# Check CUDA version
nvcc --version

# Add local bin to PATH
export PATH=$PATH:/home/drew/.local/bin

# Reload shell configuration
source ~/.bashrc

# Remove and reinstall TTS repository
sudo rm -rf TTS/  # delete repo to be able to reinstall if needed
sudo git clone --branch xtts_demo -q https://github.com/coqui-ai/TTS.git
sudo pip install --use-deprecated=legacy-resolver -q -e TTS
sudo pip install --use-deprecated=legacy-resolver -q -r TTS/TTS/demos/xtts_ft_demo/requirements.txt
sudo pip install -q typing_extensions==4.8 numpy==1.26.2

# Install newer versions of torch and torchaudio
pip install torch==2.3.0
pip install torchaudio==2.3.0

# Run the TTS demo
python3 TTS/TTS/demos/xtts_ft_demo/xtts_demo.py --batch_size 2 --num_epochs 6
