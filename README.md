This repo is forked from facebooks fairseq. to install the repo, run, 
```angular2html
git clone https://github.com/vincent1rookie/fgda_nmt.git
cd fgda_nmt
pip install -e .
pip install sentencepiece
```

To run the code, first check `fairseq.conf.sh`, which includes all configurations you need to do. You can check comments there.

If you want to run our proposed methods, you should edit `TASK` to `translation_da`, and edit `ARCH` to `transformer_da`
(for Domain-Aware Encoder) or `transformer_da` (for Domain-Aware Decoder)

Then, you should process data. Assume you already have two files `xxxx.src` for source sentences, 
`xxxx.tgt` for target sentences, and `xxxx.da` for domain indexes of each sentence. 

After you finish configurations, run the below code for data processing

```angular2html
bash fairseq-data.sh
```

Then run the below code for model training

```angular2html
bash fairseq-train.sh
```

Then run the below code for inference on the test set

```angular2html
bash fairseq-generate.sh
```

We provide two logs for our implementations