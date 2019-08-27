#!/usr/bin/env bash
set -e

market=$1
model="tdm_mock"

cp ~/.ssh/id_rsa id_rsa
sudo docker build --no-cache -t ${model} .
rm -f id_rsa

docker_server=""
if [ ${market} == "sgsg" ] || [ ${market} == "inin" ]; then
    docker_server="video-register.singa.op-mobile.opera.com"
elif [ ${market} == "afaf" ]; then
    docker_server="video-register.ams.op-mobile.opera.com"
fi
echo "Docker server ${docker_server}"

sudo docker tag tdm_mock ${docker_server}/${model} && \
sudo docker push ${docker_server}/${model}
echo "Done !!!"

