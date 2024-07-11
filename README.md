# FineTune-Xtts
personal stuff for fine tuning a xtts file

### I have also included a google colab that works at this moment

Named  `XTTS_FT.ipynb`

### Usage Instructions:
1. **Install Script**: Run this first to set up everything. You can do this by saving the script as `install.sh` and then running:
   ```bash
   chmod +x install.sh
   ./install.sh
   ```
2. **Run Script**: After installation, use this to run your TTS demo. Save it as `run.sh` and run:
   ```bash
   chmod +x run.sh
   ./run.sh
   ```
3. **Collect Script**: To gather the outputs into a central location. Save it as `collect.sh` and run:
   ```bash
   chmod +x collect.sh
   ./collect.sh
   ```
4. **Wipe Script**: To wipe all models and training data run:
   ```bash
   chmod +x wipe_models_and_data.sh
   ./wipe_models_and_data.sh
   ```

Make sure each script is executable (`chmod +x`) before running. These scripts are comprehensive and designed to be robust for your setup. Adjust paths and versions as needed based on actual deployment specifics and environment.

python TTS/TTS/demos/xtts_ft_demo/xtts_demo.py --batch_size 2 --num_epochs 6


you get the model with `get_model.py`
