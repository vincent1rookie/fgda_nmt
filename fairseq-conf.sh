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
OUTPUT=/home/ubuntu/data-bin/
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
GPU=1
# number of GPU's to use
NUM_GPU=0
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

## you should also have x2x available in your environment. X2X specifies the path for X2X project.
#X2X=/home/vincentzyxu/mt_opus
#
## fairseq-finetune
## If you want to finetune from certain checkpoints, it should be in ${RESTORE_BASE}/${ARCH}/${SRC}${TGT}/checkpoint_best.pt
#RESTORE_BASE=/dockerdata/vincentzyxu/checkpoints/fairseq/base
#
## for bert_fused models, please check the original paper: https://arxiv.org/abs/2002.06823 before use.
## Specify the BERT you want ot use, refer to :https://huggingface.co/models for all avaliable pretrained models
#BERT_PATH='bert-base-uncased'
## output dimension of the bert encoder
#BERT_OUT_DIM=768
#ENCODER_EMBED_DIM=768   # this ENCODER_EMBED_DIM used in bert-fused model only, if you want to change base model, refer to fairseq/models/
## weights of bert attention in each encoder/decoder layer
## for each transformer blocks, before fc layers, the output = BERT_RATIO * (output of bert attention) + (1-BERT_RATIO) * (output of self-attention layer)
#BERT_RATIO=0.5
## whether to use trained model to initialize the corresponding part in bert-fused NMT
#WARMUP_FROM_NMT=False
## whether to finetune the BERT encoder
#FINETUNE_BERT=False
#BERT_RESTORE_FILE=/dockerdata/vincentzyxu/checkpoints/fairseq/bert_fused/transformer/dezh/checkpoint_best.p
#

