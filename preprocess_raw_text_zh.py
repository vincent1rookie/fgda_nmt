import jieba_fast as jieba
from tqdm import tqdm
import os
import gc


ood_train = '/home/ubuntu/data/en-zh/UNv1.0.en-zh'
ood_outpath = '/home/ubuntu/data/un_zhen'
da_path = '/home/ubuntu/data/steam_info_zhen'
mixed_path = '/home/ubuntu/data/mixed_zhen'
src = 'zh'
tgt = 'en'



# if not os.path.exists(ood_outpath):
#     os.makedirs(ood_outpath)
#
# if not os.path.exists(mixed_path):
#     os.makedirs(mixed_path)
#
# src_list, tgt_list = list(), list()
# with open(ood_train+'.'+src, 'r', encoding='utf-8') as f:
#     temp = f.readline().strip()
#     while temp:
#         src_list.append(temp)
#         temp = f.readline().strip()
#
# with open(ood_train+'.'+tgt, 'r', encoding='utf-8') as f:
#     temp = f.readline().strip()
#     while temp:
#         tgt_list.append(temp)
#         temp = f.readline().strip()
# print(len(src_list))
# src_write = list()
# tgt_write = list()
# combine = zip(tgt_list, src_list)
# combine = set(combine)
# for en, zh in tqdm(combine):
#     # zh = list(jieba.cut(zh))
#     len_zh = len(zh.split(' '))
#     len_en = len(en.split(' '))
#     if len_zh >= 150 or len_en >= 150 or float(len_zh/len_en)>1.3 or float(len_zh/len_en)<1/1.3:
#         continue
#     else:
#         src_write.append(zh)
#         tgt_write.append(en)
# print(len(tgt_write))
#
# with open(ood_outpath+'/train.'+tgt, 'w', encoding='utf-8') as f:
#     f.writelines([item + '\n' for item in tgt_write])
# with open(ood_outpath+'/train.'+src, 'w', encoding='utf-8') as f:
#     f.writelines([item + '\n' for item in src_write])
#
# del src_write, tgt_write, src_list, tgt_list, combine

with open(da_path+'/train.'+tgt, 'r', encoding='utf-8') as f:
    tgt_da = [item.strip() for item in f.readlines()]

with open(da_path+'/train.'+src, 'r', encoding='utf-8') as f:
    src_da = [item.strip() for item in f.readlines()]

with open(da_path+'/train.da', 'r', encoding='utf-8') as f:
    da = [item.strip() for item in f.readlines()]

with open(ood_outpath+'/train.'+tgt, 'r', encoding='utf-8') as f:
    tgt_od = [item.strip() for item in f.readlines()]

with open(ood_outpath+'/train.'+src, 'r', encoding='utf-8') as f:
    src_od = [item.strip() for item in f.readlines()]

da_od = ['-1' for _ in range(len(src_od))]
combine_list = list(zip(src_od, tgt_od, da_od))
import random
random.seed(11747)
sp = random.sample(combine_list, k=4000000)

combine_da = list(zip(src_da, tgt_da, da))
sp_da = random.choices(combine_da, k=4000000)
out = sp+sp_da
random.shuffle(out)
#
with open(mixed_path+'/train.'+src, 'w', encoding='utf-8') as f:
    f.writelines([item[0] + '\n' for item in sp])
with open(mixed_path+'/train.'+tgt, 'w', encoding='utf-8') as f:
    f.writelines([item[1] + '\n' for item in sp])

with open(mixed_path+'/train.'+src, 'w', encoding='utf-8') as f:
    f.writelines([item[0] + '\n' for item in out])
with open(mixed_path+'/train.'+tgt, 'w', encoding='utf-8') as f:
    f.writelines([item[1] + '\n' for item in out])
with open(mixed_path+'/train.da', 'w', encoding='utf-8') as f:
    f.writelines([item[2] + '\n' for item in out])


# with open('/home/ubuntu/data/un_zhen/valid.zh', 'r') as f:
#     zh_da = [item.strip() for item in f.readlines()]
#
# with open('/home/ubuntu/data/un_zhen/valid.zh', 'w') as f:
#     f.writelines([' '.join(jieba.cut(item)) + '\n' for item in zh_da])