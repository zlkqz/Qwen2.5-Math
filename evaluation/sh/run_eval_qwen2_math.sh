# Evaluate Qwen2.5-Math-Instruct
PROMPT_TYPE="qwen25-math-cot"

# Qwen2.5-Math-1.5B-Instruct
export CUDA_VISIBLE_DEVICES="0"
export MODEL_NAME=Qwen2.5-3B-Instruct
MODEL_PATH="/mnt/ceph_home/luxinyu2021/pretrained_models/Qwen2.5-3B-Instruct/"
bash sh/eval.sh $PROMPT_TYPE $MODEL_PATH