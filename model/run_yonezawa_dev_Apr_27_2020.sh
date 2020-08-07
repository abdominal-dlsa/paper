#!/bin/sh

target=
model=
port=8095
# nvidia-smi 参照(0-3). カンマ区切りだが最初のidしか使ってくれない模様。
gpuid=1
continue_train=

usage_exit() {
        echo "Usage: $0 [-m pix2pix | cycle_gan] [-t target] [-p port] [-g gpuid] [-c]" 1>&2
        exit 1
}

while getopts t:g:p:m:hc OPT
do
    case $OPT in
        t)  target=$OPTARG
            ;;
        m)  model=$OPTARG
            ;;
        p)  port=$OPTARG
            ;;
        g)  gpuid=$OPTARG
            ;;
        c)  continue_train=1
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
#絶対パスで。
datasets="/media/dl-box/hd-lxu3-ai-study/Images/complete_Apr_27_2020/"

if [ '!' -d "$datasets" ]; then
  usage_exit
fi

if [ "$model" '!=' 'pix2pix' -a "$model" '!=' 'cycle_gan' ]; then
  usage_exit
fi

(
cd pytorch-CycleGAN-and-pix2pix
# direction は AtoB(default)
# train
opts=""
if [ "$continue_train" '!=' '' ]; then
   opts="$opts --continue_train"
fi
python train.py $opts --dataroot "$datasets" --gpu_ids "$gpuid" --name "${model}_${target}" --model "$model" --display_port "$port"
)
