#!/bin/bash

set -x

cd /data

if ! [[ "$EULA" = "false" ]] || grep -i true eula.txt; then
	echo "eula=true" > eula.txt
else
	echo "You must accept the EULA by in the container settings."
	exit 9
fi

if ! [[ -f 'Monifactory-Beta.0.11.5-server.zip' ]]; then
	rm -fr config kubejs libraries mods Server*.zip forge*.jar
	curl -Lo 'Server-0.11.5.zip' 'https://github.com/ThePansmith/Monifactory/releases/download/0.11.5/Monifactory-Beta.0.11.5-server.zip' 
	ln -s /data /data/overrides
	unzip -u -o 'Server-0.11.5.zip' -d /data
	rm /data/overrides
	# java -jar $(ls forge-*-installer.jar) --installServer
fi

if [[ -n "$MOTD" ]]; then
    sed -i "/motd\s*=/ c motd=$MOTD" /data/server.properties
fi
if [[ -n "$LEVEL" ]]; then
    sed -i "/level-name\s*=/ c level-name=$LEVEL" /data/server.properties
fi
if [[ -n "$OPS" ]]; then
    echo $OPS | awk -v RS=, '{print}' > ops.txt
fi
if [[ -n "$ALLOWLIST" ]]; then
    echo $ALLOWLIST | awk -v RS=, '{print}' > white-list.txt
fi

sed -i 's/server-port.*/server-port=25565/g' server.properties

sed -i "s/-Xms4G -Xmx4G/$JVM_OPTS/" variables.txt

curl -Lo '/data/start.sh' 'https://raw.githubusercontent.com/therealbungus/docker-monifactory/refs/heads/master/start.sh'
curl -Lo '/data/variables.txt' 'https://raw.githubusercontent.com/therealbungus/docker-monifactory/refs/heads/master/variables.txt'
chmod +x /data/start.sh
/data/start.sh