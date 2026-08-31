set -ex

# 需要先另起一个 OpenAI 兼容 server，将模型注册为 ${MODEL_NAME}，例如: vllm serve <model_path> --served-model-name ${MODEL_NAME} --port 8000

MODEL_NAME='openai'
API_BASE_URL='http://localhost:23167/v1'
PROMPT_TYPE='qwen25-math-cot'
EXP_NAME=${EXP_NAME:-'deepmath_qwen3_4B_in_distribution_ref_model_reference_replace_hard_clip_0.01-10_step_180'}
# EXP_NAME='Qwen3-4b-no-think_2'
OUTPUT_DIR=./math_eval_results/${EXP_NAME}

SPLIT="test"
NUM_TEST_SAMPLE=-1

# English open datasets
DATA_NAME="math500,minerva_math,olympiadbench"
# DATA_NAME="math500"
TOKENIZERS_PARALLELISM=false \
python3 -u math_eval.py \
    --model_name ${MODEL_NAME} \
    --data_name ${DATA_NAME} \
    --output_dir ${OUTPUT_DIR} \
    --split ${SPLIT} \
    --prompt_type ${PROMPT_TYPE} \
    --num_test_sample ${NUM_TEST_SAMPLE} \
    --seed 0 \
    --temperature 0 \
    --n_sampling 1 \
    --top_p 1 \
    --start 0 \
    --end -1 \
    --use_api \
    --api_base_url ${API_BASE_URL} \
    --save_outputs \
    --api_concurrency 256 \
    --max_tokens_per_call 12288

# English competition datasets
DATA_NAME="aime24,aime25,amc23"
# DATA_NAME="aime24"
TOKENIZERS_PARALLELISM=false \
python3 -u math_eval.py \
    --model_name ${MODEL_NAME} \
    --data_name ${DATA_NAME} \
    --output_dir ${OUTPUT_DIR} \
    --split ${SPLIT} \
    --prompt_type ${PROMPT_TYPE} \
    --num_test_sample ${NUM_TEST_SAMPLE} \
    --seed 0 \
    --temperature 0.6 \
    --n_sampling 32 \
    --top_p 0.95 \
    --start 0 \
    --end -1 \
    --use_api \
    --api_base_url ${API_BASE_URL} \
    --save_outputs \
    --api_concurrency 128 \
    --max_tokens_per_call 12288

