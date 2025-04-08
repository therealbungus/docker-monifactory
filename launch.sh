#!/bin/bash

set -x

cd /data

if ! [[ "$EULA" = "false" ]] || grep -i true eula.txt; then
	echo "eula=true" > eula.txt
else
	echo "You must accept the EULA by in the container settings."
	exit 9
fi

if ! [[ -f 'Server-0.12.1.zip' ]]; then
	rm -fr config config-overrides defaultconfigs kubejs mods Server*.zip forge*.jar
	curl -Lo '/data/forge-1.20.1-47.3.7-installer.jar' 'https://maven.minecraftforge.net/net/minecraftforge/forge/1.20.1-47.3.7/forge-1.20.1-47.3.7-installer.jar'
	java -jar forge-1.20.1-47.3.7-installer.jar --installServer
	curl -Lo 'Server-0.12.1.zip' 'https://github.com/ThePansmith/Monifactory/releases/download/0.12.1/Monifactory-Beta.0.12.1-server.zip' 
	ln -s /data /data/overrides
	unzip -u -o 'Server-0.12.1.zip' -d /data
	rm /data/overrides
	curl -Lo '/data/pack-mode-switcher.sh' 'https://raw.githubusercontent.com/ThePansmith/Monifactory/refs/heads/main/pack-mode-switcher.sh'
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

sed -i "s/# -Xmx4G/$JVM_OPTS/" user_jvm_args.txt

chmod +x /data/pack-mode-switcher.sh
chmod +x /data/run.sh
/data/run.sh