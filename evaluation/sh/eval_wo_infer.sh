PROMPT_TYPE="qwen25-math-cot"

DATA_NAMES="gsm8k,math500,minerva_math,olympiadbench,aime24,aime25,amc23"
for DATA_NAME in ${DATA_NAMES//,/ }
do
    python3 -u evaluate.py --data_name $DATA_NAME \
                            --prompt_type $PROMPT_TYPE \
                            --base_file_dir "/mnt/data1/luxinyu2021/Search-R1/results/Qwen2.5-Math/math_eval";
done