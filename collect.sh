#!/bin/bash

# Define the directory to store the dataset and model
DEST_DIR="$HOME/XTTS_Results"
mkdir -p $DEST_DIR

# Copy dataset
cp -r /tmp/xtts_ft/dataset $DEST_DIR

# Find the latest best model and copy it
MODEL_DIR="/tmp/xtts_ft/run/training"
LATEST_MODEL=$(find $MODEL_DIR -name 'best_model.pth' | sort -n | tail -1)
cp $LATEST_MODEL $DEST_DIR

# Copy additional necessary files
cp $MODEL_DIR/config.json $DEST_DIR
cp $MODEL_DIR/vocab.json $DEST_DIR
