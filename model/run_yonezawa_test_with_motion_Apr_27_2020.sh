#!/bin/sh
target=
model=
port=8097
# nvidia-smi 参照(0-3). カンマ区切りだが最初のidしか使ってくれない模様。
gpuid=1
continue_train=

usage_exit() {
        echo "Usage: $0 [-m pix2pix | cycle_gan] [-t target] [-p port] [-g gpuid] " 1>&2
        exit 1
}

while getopts t:g:m:p:h OPT
do
    case $OPT in
        t)  target=$OPTARG
            ;;
        m)  model=$OPTARG
            ;;
        g)  gpuid=$OPTARG
            ;;
        p)  port=$OPTARG
            ;;
        h)  usage_exit
            ;;
        \?) usage_exit
            ;;
    esac
done

shift $((OPTIND - 1))

#model=cycle_gan

#datasets="/data1/datasets/dynamic-converted/datasets_portal/"
#datasets="/data1/datasets/dynamic-converted/datasets_late/"
#datasets="/data1/datasets/dynamic-converted/datasets_arterial/"
#datasets="/data1/datasets/Subtraction-GAN/test_final/test1/"
#datasets="/data1/datasets/Subtraction-GAN/test_final/test2/"
datasets="/media/dl-box/hd-lxu3-ai-study/Images/complete_Apr_27_2020/test_with_motion/"

epoch=latest

target=DLSA
#epoch=15
#epoch=60

model=pix2pix

if [ '!' -d "$datasets" ]; then
  usage_exit
fi

if [ "$model" '!=' 'pix2pix' -a "$model" '!=' 'cycle_gan' ]; then
  usage_exit
fi

(
cd pytorch-CycleGAN-and-pix2pix
#model=pix2pix
# nvidia-smi 参照(0-3). カンマ区切りだが最初のidしか使ってくれない模様。
# 全件テスト
num_test=$(ls -1 "$datasets/test" | wc -l)
# direction は AtoB(default)
# train
python test.py --dataroot "$datasets" --gpu_ids "$gpuid" --name "${model}_${target}" --model "$model" --epoch "$epoch" --num_test "$num_test" 

)
