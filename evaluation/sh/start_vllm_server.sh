#!/bin/bash
set -e

# ============ 基础配置 ============
# MODEL="Qwen/Qwen3-4B"
MODEL=${MODEL:-'/ceph_home/zhangkaiqi2024/saved_models/deepmath_qwen3_4B_in_distribution_ref_model_reference_replace_hard_clip_0.01-10/global_step_180/actor/huggingface'}
# MODEL='/ceph_home/arknet/hf_models/Qwen/Qwen3-4B'
HOST="0.0.0.0"
PORT=23167
SERVED_NAME="openai"

# ============ GPU 配置 ============
export CUDA_VISIBLE_DEVICES=0,1,2,3,4,5,6,7
TP_SIZE=1
DP_SIZE=8

# ============ 启动服务 ============
vllm serve ${MODEL} \
    --served-model-name ${SERVED_NAME} \
    --host ${HOST} \
    --port ${PORT} \
    --tensor-parallel-size ${TP_SIZE} \
    --data-parallel-size ${DP_SIZE} \
    --gpu-memory-utilization 0.9 \
    --max-model-len 32768 \
    --max_num_batched_tokens 65536 \
    --reasoning-parser deepseek_r1 \
    --trust-remote-code