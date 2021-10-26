#!/bin/bash

cd /silicoin-blockchain

. ./activate

if [[ $(sit keys show | wc -l) -lt 5 ]]; then
    if [[ ${keys} == "generate" ]]; then
      echo "to use your own keys pass them as a text file -v /path/to/keyfile:/path/in/container and -e keys=\"/path/in/container\""
      sit init && sit keys generate
    elif [[ ${keys} == "copy" ]]; then
      if [[ -z ${ca} ]]; then
        echo "A path to a copy of the farmer peer's ssl/ca required."
        exit
      else
      sit init -c ${ca}
      fi
    elif [[ ${keys} == "type" ]]; then
      sit init
      echo "Call from docker shell: sit keys add"
      echo "Restart the container after mnemonic input"
    else
      sit init && sit keys add -f ${keys}
    fi
    
    sed -i 's/localhost/127.0.0.1/g' ~/.sit/mainnet/config/config.yaml
else
    for p in ${plots_dir//:/ }; do
        mkdir -p ${p}
        if [[ ! "$(ls -A $p)" ]]; then
            echo "Plots directory '${p}' appears to be empty, try mounting a plot directory with the docker -v command"
        fi
        sit plots add -d ${p}
    done

    if [[ ${farmer} == 'true' ]]; then
      sit start farmer-only
    elif [[ ${harvester} == 'true' ]]; then
      if [[ -z ${farmer_address} || -z ${farmer_port} || -z ${ca} ]]; then
        echo "A farmer peer address, port, and ca path are required."
        exit
      else
        sit configure --set-farmer-peer ${farmer_address}:${farmer_port}
        sit start harvester
      fi
    else
      sit start farmer
    fi
fi

finish () {
    echo "$(date): Shutting down sit"
    sit stop all
    exit 0
}

trap finish SIGTERM SIGINT SIGQUIT

sleep infinity &
wait $!
