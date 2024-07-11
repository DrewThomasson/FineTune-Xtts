#!/bin/bash

# Assuming the virtual environment is already activated
source venv/bin/activate

# Navigate to the TTS directory if not already there
cd TTS

# Run the main TTS demo script
python TTS/demos/xtts_ft_demo/xtts_demo.py --batch_size 2 --num_epochs 6
