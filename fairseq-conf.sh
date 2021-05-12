#!/bin/bash

export PYTHONPATH=${X2X}:$PYTHONPATH
# specify the TMPDIR for caches
export TMPDIR=/dockerdata/vincentzyxu/trash
export PYTHONIOENCODING=utf-8

# task: default translation, or translation_da
TASK=translation_da
# ARCH: the model used, default if transformer_da, which is our proposed model
ARCH=transformer_da3
PWD=/home/ubuntu/fgda_nmt

# min and max sentencepiece tokens for the corpus
TRAIN_MINLEN=1  # remove sentences with <1 BPE token in spm encoding
TRAIN_MAXLEN=512  # remove sentences with >200 BPE tokens in spm encoding
# BPE size if we need to train a new spm model, otherwise can be ignored
BPESIZE=32000
# For bilingual translation only , specify the source languages
SRC="ru"
SRCS=(${SRC})
TGT="en"
# complete data_dir is ${DATA}/${DATA_PREFIX}${SRC}${TGT}, for train, valid and test
DATA=${PWD}/data
DATA_PREFIX=mixed_
DA_MAPPING=${PWD}/data/graph/${SRC}/mapping.json
GRAPH_EMBEDDING=${PWD}/data/graph/${SRC}/embeds_loop.npy
PATIENCE=20

# the output directory for the processed data: the bpe files will be in ${OUTPUT}/${SRC}${TGT}, the fairseq binary
# files will be in ${OUTPUT}/${SRC}${TGT}/data-bin
OUTPUT=${PWD}/data-bin
# number of works in processing the data
NUM_WORKER=1

# The base path to store checkpoints, the complete path is ${TRAIN_BASE}/${TASK}/${ARCH}/${SUFFIX}/${DATA_PREFIX}${SRC}${TGT}
TRAIN_BASE=${PWD}/checkpoints
SUFFIX=test3
TRAIN=${TRAIN_BASE}/${TASK}/${ARCH}/${SUFFIX}
# if warmup from pre-trained model, the use `WARMUP_FILE` to specify the checkpoint path
#WARMUP_FILE=${TRAIN_BASE}/translation/transformer_da/steam_info_zhen/checkpoint_best.pt
WARMUP_FILE=${TRAIN_BASE}/translation/transformer/test0/un_${SRC}en/checkpoint_best.pt
# print log interval for each LOG_INTERVAL steps
LOG_INTERVAL=100
# save checkpoints for each SAVE_INTERVAL steps
SAVE_INTERVAL=1000
# number of checkpoints to keep
KEEP_CKPT=5
# which devices are available
GPU=0
# number of GPU's to use
NUM_GPU=1
#for distributed training. Specify the address and port.

# If you want to train multiple models at the same time, you should specify different ports
MASTER_ADDR=127.0.0.8
PORT=29508
# training parameters
MAX_STEP=300000
MAX_LENGTH=200
# In the original fairseq, batch size means the maximum sentences in one batch,
# but here, BATCH_SIZE means maximum non-padding tokens in one batch, the same as t2t
#BATCH_SIZE=12258
BATCH_SIZE=4096
LR=5e-4
LR_SCHEDULE=inverse_sqrt
# the default criterion for translation task is cross-entropy, an alternative could be `cross_entropy_with_coverage`,
# which incorporates coverage mechanism
CRITERION=cross_entropy

# in fairseq-generate, We use bleu_hook in t2t to make the performance of models of 2 frameworks comparable.
BEAM_SIZE=5
DECODE_BATCH=128



