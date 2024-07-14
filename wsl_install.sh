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

# Install NVIDIA CUDA toolkit
sudo apt install -y nvidia-cuda-toolkit

# Verify CUDA installation
nvcc --version

# Add local bin to PATH
export PATH=$PATH:/home/drew/.local/bin

# Reload shell configuration
source ~/.bashrc

# Reinstall TTS repository
sudo rm -rf TTS/
sudo git clone --branch xtts_demo -q https://github.com/coqui-ai/TTS.git
sudo pip install --use-deprecated=legacy-resolver -q -e TTS
sudo pip install --use-deprecated=legacy-resolver -q -r TTS/TTS/demos/xtts_ft_demo/requirements.txt
sudo pip install -q typing_extensions==4.8 numpy==1.26.2

# Upgrade torch and torchaudio
pip install torch==2.3.0
pip install torchaudio==2.3.0

# This came up with an error, the next steps are to fix it
python3 TTS/TTS/demos/xtts_ft_demo/xtts_demo.py --batch_size 2 --num_epochs 6

# Uninstall existing CUDA packages
sudo apt-get --purge remove "*cublas*" "cuda*" "nsight*" "nvidia*"
sudo apt-get autoremove
sudo apt-get autoclean

# Add the NVIDIA GPG key and CUDA repository
wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2204/x86_64/cuda-ubuntu2204.pin
sudo mv cuda-ubuntu2204.pin /etc/apt/preferences.d/cuda-repository-pin-600
sudo apt-key adv --fetch-keys https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2204/x86_64/7fa2af80.pub
sudo add-apt-repository "deb https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2204/x86_64/ /"
sudo apt-get update
sudo apt-get -y install cuda-11-8

# Download and install cuDNN package
wget https://developer.download.nvidia.com/compute/cudnn/9.2.1/local_installers/cudnn-local-repo-ubuntu2204-9.2.1_1.0-1_amd64.deb
sudo dpkg -i cudnn-local-repo-ubuntu2204-9.2.1_1.0-1_amd64.deb

# Extract cuDNN tar file (assume you have downloaded cudnn-11.8-linux-x64-v8.x.x.x.tgz)
tar -xzvf ~/cudnn-11.8-linux-x64-v8.x.x.x.tgz

# Copy cuDNN files to CUDA directories
sudo cp cuda/include/cudnn*.h /usr/local/cuda/include
sudo cp cuda/lib64/libcudnn* /usr/local/cuda/lib64
sudo chmod a+r /usr/local/cuda/include/cudnn*.h /usr/local/cuda/lib64/libcudnn*

# Update environment variables
echo 'export LD_LIBRARY_PATH=/usr/local/cuda/lib64:$LD_LIBRARY_PATH' >> ~/.bashrc
echo 'export LD_LIBRARY_PATH=/usr/local/cuda/extras/CUPTI/lib64:$LD_LIBRARY_PATH' >> ~/.bashrc
echo 'export PATH=/usr/local/cuda/bin:$PATH' >> ~/.bashrc
source ~/.bashrc

# Verify cuDNN installation
ls /usr/local/cuda/include/cudnn*.h
ls /usr/local/cuda/lib64/libcudnn*

# Still errors
python3 TTS/TTS/demos/xtts_ft_demo/xtts_demo.py --batch_size 2 --num_epochs 6

# Uninstall existing CUDA packages
sudo apt-get --purge remove "*cublas*" "cuda*" "nsight*" "nvidia*"
sudo apt-get autoremove
sudo apt-get autoclean

# Add the NVIDIA GPG key and CUDA repository
sudo apt-key adv --fetch-keys https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2204/x86_64/3bf863cc.pub
sudo add-apt-repository "deb https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2204/x86_64/ /"
sudo apt-get update

# Install CUDA 11.8
sudo apt-get -y install cuda-11-8

# Download and install cuDNN package
wget https://developer.download.nvidia.com/compute/cudnn/9.2.1/local_installers/cudnn-local-repo-ubuntu2204-9.2.1_1.0-1_amd64.deb
sudo dpkg -i cudnn-local-repo-ubuntu2204-9.2.1_1.0-1_amd64.deb
sudo cp /var/cudnn-local-repo-ubuntu2204-9.2.1/cudnn-*-keyring.gpg /usr/share/keyrings/
sudo apt-get update
sudo apt-get -y install libcudnn8 libcudnn8-dev

# Extract cuDNN tar file
tar -xzvf ~/cudnn-11.8-linux-x64-v8.x.x.x.tgz

# Copy cuDNN files to CUDA directories
sudo cp cuda/include/cudnn*.h /usr/local/cuda/include
sudo cp cuda/lib64/libcudnn* /usr/local/cuda/lib64
sudo chmod a+r /usr/local/cuda/include/cudnn*.h /usr/local/cuda/lib64/libcudnn*

# Update environment variables
echo 'export LD_LIBRARY_PATH=/usr/local/cuda/lib64:$LD_LIBRARY_PATH' >> ~/.bashrc
echo 'export LD_LIBRARY_PATH=/usr/local/cuda/extras/CUPTI/lib64:$LD_LIBRARY_PATH' >> ~/.bashrc
echo 'export PATH=/usr/local/cuda/bin:$PATH' >> ~/.bashrc
source ~/.bashrc

# Verify cuDNN installation
ls /usr/local/cuda/include/cudnn*.h
ls /usr/local/cuda/lib64/libcudnn*

# Run your Python script
# Yay now it finally runs :))))
python3 TTS/TTS/demos/xtts_ft_demo/xtts_demo.py --batch_size 2 --num_epochs 6
