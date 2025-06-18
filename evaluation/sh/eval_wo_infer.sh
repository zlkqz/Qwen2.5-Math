PROMPT_TYPE="qwen25-math-cot"

DATA_NAME="gsm8k,math,minerva_math,olympiadbench,aime24,aime25,amc23"
python3 -u evaluate.py --data_name $DATA_NAME \
                        --prompt_type $PROMPT_TYPE \
                        --file_path \