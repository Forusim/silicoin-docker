#!/bin/bash

cd /silicoin-blockchain

. ./activate

if [[ $(silicoin keys show | wc -l) -lt 5 ]]; then
    if [[ ${keys} == "generate" ]]; then
      echo "to use your own keys pass them as a text file -v /path/to/keyfile:/path/in/container and -e keys=\"/path/in/container\""
      silicoin init && silicoin keys generate
    elif [[ ${keys} == "copy" ]]; then
      if [[ -z ${ca} ]]; then
        echo "A path to a copy of the farmer peer's ssl/ca required."
        exit
      else
      silicoin init -c ${ca}
      fi
    elif [[ ${keys} == "type" ]]; then
      silicoin init
      echo "Call from docker shell: silicoin keys add"
      echo "Restart the container after mnemonic input"
    else
      silicoin init && silicoin keys add -f ${keys}
    fi
else
    for p in ${plots_dir//:/ }; do
        mkdir -p ${p}
        if [[ ! "$(ls -A $p)" ]]; then
            echo "Plots directory '${p}' appears to be empty, try mounting a plot directory with the docker -v command"
        fi
        silicoin plots add -d ${p}
    done

    sed -i 's/localhost/127.0.0.1/g' ~/.silicoin/mainnet/config/config.yaml

    if [[ ${farmer} == 'true' ]]; then
      silicoin start farmer-only
    elif [[ ${harvester} == 'true' ]]; then
      if [[ -z ${farmer_address} || -z ${farmer_port} || -z ${ca} ]]; then
        echo "A farmer peer address, port, and ca path are required."
        exit
      else
        silicoin configure --set-farmer-peer ${farmer_address}:${farmer_port}
        silicoin start harvester
      fi
    else
      silicoin start farmer
    fi
fi

while true; do sleep 30; done;
