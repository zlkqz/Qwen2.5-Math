set -ex


export CUDA_VISIBLE_DEVICES='0,1,2,3,4,5,6,7'

PROMPT_TYPE='qwen25-math-cot'
MODEL_PATH='/ceph_home/zhangkaiqi2024/saved_models/deepmath_qwen3_4B_in_distribution_ref_model_reference_replace_hard_clip_0.01-10/global_step_180/actor/huggingface'
EXP_NAME='deepmath_qwen3_4B_in_distribution_ref_model_reference_replace_hard_clip_0.01-10_step_180'
OUTPUT_DIR=./math_eval_results/${EXP_NAME}

SPLIT="test"
NUM_TEST_SAMPLE=-1

# English open datasets
DATA_NAME="math500,minerva_math,olympiadbench"
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
    --n_sampling 1 \
    --top_p 1 \
    --start 0 \
    --end -1 \
    --use_vllm \
    --save_outputs \

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
    --n_sampling 32 \
    --top_p 1 \
    --start 0 \
    --end -1 \
    --use_vllm \
    --save_outputs \
