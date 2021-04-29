#!/bin/bash

. fairseq-conf.sh

SPM_SCRIPTS=$PWD/scripts
SPM_TRAIN=$SPM_SCRIPTS/spm_train.py
SPM_ENCODE=$SPM_SCRIPTS/spm_encode.py

# encode train/valid
for SRC in "${SRCS[@]}"; do
    spm_model=${DATA}/${DATA_PREFIX}${SRC}${TGT}/spm
    data_dir=${DATA}/${DATA_PREFIX}${SRC}${TGT}
    output_dir=${OUTPUT}/${TASK}/${DATA_PREFIX}${SRC}${TGT}

    if [ ! -f ${spm_model}.model ]; then
        echo "${spm_model}.model does not exist"
        echo "sentencepiece model not found, train bpe from scratch"
        # learn BPE with sentencepiece
        TRAIN_FILES=$(for SRC in "${SRCS[@]}"; do echo ${data_dir}/train.${SRC}; echo ${data_dir}/train.${TGT}; done | tr "\n" ",")
        #echo "learning joint BPE over ${TRAIN_FILES}..."
        python "$SPM_TRAIN" \
        --input=${TRAIN_FILES} \
        --model_prefix=${spm_model} \
        --vocab_size=${BPESIZE} \
        --character_coverage=0.995 \
        --model_type=bpe \
        --train_extremely_large_corpus=true \
        --input_sentence_size=5000000 \
        --shuffle_input_sentence=true
    fi
    echo "Preprocessing $SRC $TGT"
    echo "encoding train corpus with learned BPE..."
#    mkdir -p ${output_dir}
#    python "$SPM_ENCODE" \
#        --model ${spm_model}.model \
#        --output_format=piece \
#        --inputs ${data_dir}/train.${SRC} ${data_dir}/train.${TGT} \
#        --outputs ${output_dir}/train.bpe.${SRC} ${output_dir}/train.bpe.${TGT} \
#        --min-len ${TRAIN_MINLEN} --max-len ${TRAIN_MAXLEN}
#
#    echo "encoding valid corpus with learned BPE..."
#
#    python "$SPM_ENCODE" \
#        --model ${spm_model}.model \
#        --output_format=piece \
#        --inputs ${data_dir}/valid.${SRC} ${data_dir}/valid.${TGT} \
#        --outputs ${output_dir}/valid.bpe.${SRC} ${output_dir}/valid.bpe.${TGT}
#
#    echo "encoding test corpus with learned BPE..."
#
#    python "$SPM_ENCODE" \
#        --model ${spm_model}.model \
#        --output_format=piece \
#        --inputs ${data_dir}/test.${SRC} ${data_dir}/test.${TGT} \
#        --outputs ${output_dir}/test.bpe.${SRC} ${output_dir}/test.bpe.${TGT}

    cut -f1 ${spm_model}.vocab | tail -n +4 | sed "s/$/ 100/g" > ${output_dir}/fairseq.vocab

#    cp ${data_dir}/train.da ${output_dir}/train.bpe.da.${SRC}
#    cp ${data_dir}/valid.da ${output_dir}/valid.bpe.da.${SRC}
#    cp ${data_dir}/test.da ${output_dir}/test.bpe.da.${SRC}

    python -m fairseq_cli.preprocess --source-lang ${SRC} --target-lang ${TGT} \
        --task ${TASK} \
        --trainpref ${output_dir}/train.bpe --validpref ${output_dir}/valid.bpe --testpref ${output_dir}/test.bpe \
        --srcdict ${output_dir}/fairseq.vocab --joined-dictionary \
        --destdir ${output_dir}/data-bin \
        --workers ${NUM_WORKER} --bpe sentencepiece \
        --da-mapping ${DA_MAPPING}

#    rm ${output_dir}/*.bpe.*
done
