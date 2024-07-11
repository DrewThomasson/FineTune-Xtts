#!/bin/bash

# Define the directories containing the models and data
MODEL_DIR="/tmp/xtts_ft/run/training"
DATA_DIR="/tmp/xtts_ft/dataset"

# Function to remove contents of a directory
wipe_directory() {
    if [ -d "$1" ]; then
        echo "Removing files from $1..."
        rm -rf "$1"/*
        echo "Files removed successfully from $1."
    else
        echo "Directory $1 does not exist. No files were removed."
    fi
}

# Remove model files
wipe_directory "$MODEL_DIR"

# Remove training data
wipe_directory "$DATA_DIR"
