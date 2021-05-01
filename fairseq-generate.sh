#!/usr/bin/env bash

. fairseq-conf.sh
export PYTHONPATH=${X2X}:$PYTHONPATH

for SRC in "${SRCS[@]}"; do
    echo "Decoding ${TEST_PREFIX}${SRC}${TGT}.${SRC}"
    data_dir=${OUTPUT}/${TASK}/${DATA_PREFIX}${SRC}${TGT}/data-bin
    train_dir=${TRAIN}/${DATA_PREFIX}${SRC}${TGT}
    mkdir -p ${train_dir}/translation
    checkpoints=$(ls ${train_dir} |grep .pt)
#    checkpoints=(checkpoint_best.pt)
    for ckpt in ${checkpoints}; do
	    echo "evaluating ${ckpt}"
	    PYTHONIOENCODING=utf-8 CUDA_VISIBLE_DEVICES=${GPU} fairseq-generate ${data_dir} \
		 --path ${train_dir}/${ckpt} \
		 --task ${TASK} \
		 --log-format simple \
		 --batch-size ${DECODE_BATCH} --beam ${BEAM_SIZE} --min-len 0\
		 --remove-bpe sentencepiece \
                 --skip-invalid-size-inputs-valid-test \
		 --results-path ${train_dir}/translation \
		 --scoring sacrebleu

		 tail -n 1 ${train_dir}/translation/generate-test.txt
		 mv ${train_dir}/translation/generate-test.txt ${train_dir}/translation/generate-test-${ckpt}.txt

##	    echo "Reformatting decoded files..."
#	    python -m scripts.parse_generate \
#	    --inputs=${train_dir}/translation/generate-test.txt \
#	    --outputs=${train_dir}/translation/${TEST_PREFIX}${SRC}${TGT}_${ckpt}.${TGT}
#
#	#    rm ${train_dir}/translation/generate-test.txt
##
#      fairseq-score -s ${train_dir}/translation/${TEST_PREFIX}${SRC}${TGT}_${ckpt}.${TGT} \
#       -r ${data_dir}/test.${TGT}
    done
done

