#!/usr/bin/env bash

. fairseq-conf.sh

for SRC in "${SRCS[@]}"; do
    train_dir=${TRAIN}/${SRC}${TGT}
    data_dir=${OUTPUT}/${SRC}${TGT}/data-bin
    mkdir -p ${train_dir}/logs
    export CUDA_VISIBLE_DEVICES=${GPU} 
    python -m torch.distributed.launch --nproc_per_node ${NUM_GPU} --master_addr ${MASTER_ADDR} --master_port ${PORT} $(which fairseq-train) ${data_dir} \
        --source-lang ${SRC} --target-lang ${TGT} --task ${TASK}\
        --max-update=${MAX_STEP} \
        --optimizer=adam \
        --bpe=sentencepiece \
        --max-tokens=${BATCH_SIZE} \
        --adam-betas='(0.9, 0.997)' \
        --adam-eps='1e-09'  \
        --log-interval=${LOG_INTERVAL}  --no-progress-bar \
        --keep-interval-updates=${KEEP_CKPT} --keep-last-epochs=10 \
        --ddp-backend=no_c10d \
        --lr-scheduler=${LR_SCHEDULE} \
        --lr=${LR} \
        --arch=${ARCH} \
        --save-dir=${train_dir}  \
        --distributed-no-spawn \
        --num-workers=${NUM_WORKER} \
        --save-interval-updates=${SAVE_INTERVAL} \
        --eval-bleu \
        --eval-bleu-args '{"beam": 5, "max_len_a": 1.2, "max_len_b": 10}' \
        --best-checkpoint-metric bleu --maximize-best-checkpoint-metric \
	--tensorboard-logdir ${train_dir}/logs
done
