import os
import glob
import torch
import shutil

def find_latest_best_model(folder_path):
    search_path = os.path.join(folder_path, '**', 'best_model.pth')
    files = glob.glob(search_path, recursive=True)
    latest_file = max(files, key=os.path.getctime, default=None)
    return latest_file

model_path = find_latest_best_model("/tmp/xtts_ft/run/training/")
checkpoint = torch.load(model_path, map_location=torch.device("cpu"))
del checkpoint["optimizer"]
for key in list(checkpoint["model"].keys()):
    if "dvae" in key:
        del checkpoint["model"][key]
torch.save(checkpoint, "model.pth")

model_dir = os.path.dirname(model_path)

# Create the 'model' directory if it doesn't exist
output_dir = 'model'
if not os.path.exists(output_dir):
    os.makedirs(output_dir)

# Copy files to the 'model' directory
shutil.copy(os.path.join(model_dir, 'config.json'), os.path.join(output_dir, 'config.json'))
shutil.copy(os.path.join(model_dir, 'vocab.json'), os.path.join(output_dir, 'vocab.json_'))
shutil.copy('model.pth', os.path.join(output_dir, 'model.pth'))

print("Files saved in 'model' directory: config.json, vocab.json, model.pth")
