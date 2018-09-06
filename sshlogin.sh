#!/bin/bash
dir_current=$(cd $(dirname $0); pwd)
################################################# ssh command line login helper ########################################
function helper() {
    cmd=$0
	echo "usage: $cmd --name=name --action=action"
	echo "--name the login ssh name"
	echo "--action login, copy, default is login"
	exit
}

#get args
for arg
do
    case "$arg" in
        --name=*)
		    name=`echo "$arg" | sed -e 's/^[^=]*=//'`
		    ;;
		--action=*)
		    action=`echo "$arg" | sed -e 's/^[^=]*=//'`
		    ;;
		*)
		    helper
		    ;;
    esac
done

#check jq command is installed?
command -v "jq" > /dev/null
if [[ $? -ne 0 ]]; then
    echo "please install jq command first."
    exit
fi

if [[ ${name} == "" ]]; then
    echo "Invalid parameter name or name can't be empty".
    helper
fi

#get ssh setting
#json file
#  {
#      "id_rsa_pub": "~/.ssh/id_rsa.pub",
#      "ssh": {
#          "name": {
#              "host": "",
#              "username": "",
#              "password": "",
#              "port": 22,
#              "description": ""
#          }
#      }
#  }
function get_conf() {
    jq -r ".$1" ${dir_current}/sshlogin.json
}

if [[ `get_conf ssh.${name}` == "null" ]]; then
    echo "the name not exist in the ssh config, name=${name}".
    exit
fi

ssh_host=`get_conf ssh.${name}.host`
ssh_username=`get_conf ssh.${name}.username`
ssh_password=`get_conf ssh.${name}.password`
ssh_port=`get_conf ssh.${name}.port`

if [[ ${action} == "copy" ]]; then
    ssh-copy-id -i `get_conf id_rsa_pub` -p ${ssh_port} ${ssh_username}@${ssh_host}
else
    ssh -p ${ssh_port} ${ssh_username}@${ssh_host}
fi