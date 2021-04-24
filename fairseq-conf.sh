#!/bin/bash

export PYTHONPATH=${X2X}:$PYTHONPATH
# specify the TMPDIR for caches
export TMPDIR=/dockerdata/vincentzyxu/trash
export PYTHONIOENCODING=utf-8

# task: default translation, if using bert fused models, then bert_fused_translation
TASK=translation_da
# ARCH: the model used, default if transformer_da, which is our proposed model
ARCH=transformer_da

# min and max sentencepiece tokens for the corpus
TRAIN_MINLEN=1  # remove sentences with <1 BPE token in spm encoding
TRAIN_MAXLEN=256  # remove sentences with >200 BPE tokens in spm encoding
# BPE size if we need to train a new spm model, otherwise can be ignored
BPESIZE=40000
# complete data_dir is ${DATA}/${DATA_PREFIX}${SRC}${TGT}, for train, valid and test
DATA=/home/ubuntu/data
DATA_PREFIX=steam_info_
DA_MAPPING=/home/ubuntu/data/mapping_en.json
GRAPH_EMBEDDING=/home/ubuntu/data/embeds_en.npy

# the output directory for the processed data: the bpe files will be in ${OUTPUT}/${SRC}${TGT}, the fairseq binary
# files will be in ${OUTPUT}/${SRC}${TGT}/data-bin
OUTPUT=/home/ubuntu/data-bin
# number of works in processing the data
NUM_WORKER=1
# For bilingual translation only , specify the source languages
SRCS=("en")
TGT="zh"


# The base path to store checkpoints, the complete path is ${TRAIN_BASE}/${ARCH}/${SRC}${TGT}/
TRAIN_BASE=/home/ubuntu/checkpoints
TRAIN=${TRAIN_BASE}/${TASK}/${ARCH}
# print log interval for each LOG_INTERVAL steps
LOG_INTERVAL=100
# save checkpoints for each SAVE_INTERVAL steps
SAVE_INTERVAL=1000
# number of checkpoints to keep
KEEP_CKPT=3
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
BATCH_SIZE=4096
LR=5e-4
LR_SCHEDULE=inverse_sqrt
# the default criterion for translation task is cross-entropy, an alternative could be `cross_entropy_with_coverage`,
# which incorporates coverage mechanism
CRITERION=cross_entropy

# in fairseq-generate, We use bleu_hook in t2t to make the performance of models of 2 frameworks comparable.
BEAM_SIZE=5
DECODE_BATCH=128



