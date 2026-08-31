#!/bin/bash

#SBATCH -o job.%j.out
#SBATCH -e job.%j.err
#SBATCH --qos=normal
#SBATCH -J math_eval
#SBATCH --gres=gpu:8
#SBATCH --cpus-per-task=8
#SBATCH --mem=512G
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1

set -e

echo "Current Work Dir: $(pwd)"

EVAL_DIR=/ceph_home/zhangkaiqi2024/luxinyu_data/Search-R1/Qwen2.5-Math/evaluation
CONTAINER_NAME=verl_zhangkaiqi2024

# 在此指定即可覆盖 sh/start_vllm_server.sh 的 MODEL 和 sh/eval_api.sh 的 EXP_NAME，
# 留空（不指定）则沿用两个脚本各自的默认值。
# 也可以在 sbatch 提交时通过 `sbatch --export=ALL,MODEL=...,EXP_NAME=... submit.sbatch` 指定。
MODEL=${MODEL:-/ceph_home/zhangkaiqi2024/saved_models/deepmath_qwen3_4B_in_distribution_ref_model_reference_replace_hard_clip_0.01-10/global_step_180/actor/huggingface}
EXP_NAME=${EXP_NAME:-deepmath_qwen3_4B_in_distribution_ref_model_reference_replace_hard_clip_0.01-10_step_180}

# 注意：export 只能让变量传递给在“同一个 shell”里直接执行的子进程（例如下面的
# `bash sh/eval_api.sh`），无法自动传进 `docker exec` 里的新进程 —— 那边需要显式用
# `-e` 传递，因此 MODEL 单独通过 docker exec -e 传给容器，EXP_NAME 走 export 传给宿主机上的 eval_api.sh。
export EXP_NAME

# 启动 docker 容器
docker start ${CONTAINER_NAME}

# 在容器中 cd 到评估目录，并以后台（detached）方式启动 vllm server；
# docker exec -d 会在容器内启动进程后立即返回（相当于启动后退出容器），
# server 进程继续在容器内后台运行，不受当前 exec 会话结束的影响。
DOCKER_EXEC_ENV=()
if [ -n "${MODEL}" ]; then
    DOCKER_EXEC_ENV+=(-e "MODEL=${MODEL}")
fi

# docker exec -d 不会转发容器内进程的 stdout/stderr，因此显式重定向到日志文件，
# 方便 server 启动失败时排查（sleep 300 期间不会有任何输出提示）。
docker exec -d "${DOCKER_EXEC_ENV[@]}" ${CONTAINER_NAME} \
    /bin/bash -c "cd ${EVAL_DIR} && /bin/bash sh/start_vllm_server.sh > ${EVAL_DIR}/vllm_server.log 2>&1"

# 等待 vllm server 启动完成
sleep 300

source ~/miniconda3/bin/activate math_eval

cd ${EVAL_DIR}
/bin/bash sh/eval_api.sh

# 评估结束后关闭 server 所在的容器
docker stop ${CONTAINER_NAME}
