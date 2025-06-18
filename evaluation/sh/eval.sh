set -ex

PROMPT_TYPE=$1
MODEL_PATH=$2
OUTPUT_DIR=./${MODEL_NAME}/math_eval
N_SAMPLING=${3:-1}
TOP_P=${4:-1}

SPLIT="test"
NUM_TEST_SAMPLE=-1

# English open datasets
DATA_NAME="gsm8k,math500,minerva_math,olympiadbench"
TOKENIZERS_PARALLELISM=false \
python3 -u math_eval.py \
    --model_name_or_path ${MODEL_PATH} \
    --data_name ${DATA_NAME} \
    --output_dir ${OUTPUT_DIR} \
    --split ${SPLIT} \
    --prompt_type ${PROMPT_TYPE} \
    --num_test_sample ${NUM_TEST_SAMPLE} \
    --seed 0 \
    --temperature 0 \
    --n_sampling ${N_SAMPLING} \
    --top_p ${TOP_P} \
    --start 0 \
    --end -1 \
    --use_vllm \
    --save_outputs \
    --overwrite \

# English competition datasets
DATA_NAME="aime24,aime25,amc23"
TOKENIZERS_PARALLELISM=false \
python3 -u math_eval.py \
    --model_name_or_path ${MODEL_PATH} \
    --data_name ${DATA_NAME} \
    --output_dir ${OUTPUT_DIR} \
    --split ${SPLIT} \
    --prompt_type ${PROMPT_TYPE} \
    --num_test_sample ${NUM_TEST_SAMPLE} \
    --seed 0 \
    --temperature 0 \
    --n_sampling ${N_SAMPLING} \
    --top_p ${TOP_P} \
    --start 0 \
    --end -1 \
    --use_vllm \
    --save_outputs \
    --overwrite \
