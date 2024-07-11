#!/bin/bash

# Update and Upgrade Ubuntu
sudo apt-get update && sudo apt-get upgrade -y

# Install Python3 and Pip
sudo apt-get install python3-pip python3-dev -y

# Optionally install virtualenv or use venv
sudo pip3 install virtualenv

# Create a virtual environment
virtualenv venv
source venv/bin/activate

# Install PyTorch and other dependencies
pip install torch==2.3.0 torchaudio==2.3.0 torchvision==0.17.1 torchtext==0.17.1
pip install bigframes==0.24.0 google-cloud-aiplatform==1.42.1 regex==2023.12.25 pymc==5.7.2
pip install tornado==6.3.2 spacy==3.6.1 beautifulsoup4==4.11.2 tensorflow-probability==0.22.0
pip install google-cloud-language==2.9.1 transformers==4.35.2 pyarrow==10.0.1 sentencepiece==0.1.99
pip install gdown==4.6.6 tensorflow-hub==0.15.0 flax==0.7.5 huggingface-hub==0.19.4

# Clone the TTS repository
git clone --branch xtts_demo https://github.com/coqui-ai/TTS.git
cd TTS
pip install --use-deprecated=legacy-resolver -e .
pip install --use-deprecated=legacy-resolver -r demos/xtts_ft_demo/requirements.txt
