import re
import argparse
import pdb

def parse(texts):
    result = []
    pattern = '^H-(\d+)\t-?\d+\..+\t(.+)'
    for text in texts:
        match = re.match(pattern, text)
        result.append((int(match.group(1)), match.group(2))) if re.match(pattern, text) is not None else None
    return result

def main():
    parser = argparse.ArgumentParser(description='Parse the fairseq-generated translation file')
    parser.add_argument('--inputs', type=str, help='the file location')
    parser.add_argument('--outputs', type=str, help='the file location')
    args = parser.parse_args()
    with open(args.inputs, 'r', encoding='utf-8') as f:
        texts = f.readlines()
    result = sorted(parse(texts), key=lambda x: x[0])
    with open(args.outputs, 'w', encoding='utf-8') as f:
        f.writelines([r[1]+'\n' for r in result])

if __name__ == "__main__":
    main()



