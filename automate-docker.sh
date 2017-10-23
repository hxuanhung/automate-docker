#!/bin/sh

SCRIPT_PATH=$(cd "$(dirname "$0")"; pwd);

build(){
  node ${SCRIPT_PATH}/docker.js --action build --dev ${dev} --imageName "${imageName}"
}
push(){
  node ${SCRIPT_PATH}/docker.js --action push -f "${file}" --imageName "${imageName}" -s "${server}" -u username -p password
}

usage(){
  echo "Usage: automate-docker [command] [options]"
  #NOTE: Indent using space to avoid breaking format in command line
  echo "Arguments:
    build                                 command: build Docker image
    -d | --dev                            image name as dev
    -n | --imageName [imagename]          image name as [imagename]

    push                                  command: push to Docker registry
    -u | --username [imagename]           hub username
    -p | --password [password]            hub password
    -s | --server [server]                hub server
    -f | --file [dockerfile]              hub dockerfile
    -n | --imageName [imagename]          image name as [imagename]

    -h | --help if show help"
}

while [ "$1" != "" ]; do
    case $1 in
        build)                  action='build'
                                ;;
        -d | --dev)        			shift # past argument
                                shift # past value
                                dev=true
                                ;;
        -n | --imageName)       shift
                                imageName=$1
                                ;;
    esac
    case $1 in
        push)                   action='push'
                                ;;
        -u | --username)        shift
                                username=$1
                                ;;
        -p | --password)        shift
                                password=$1
                                ;;
        -f | --file)            shift
                                file=$1
                                ;;
        -s | --server)          shift
                                server=$1
                                ;;
        -h | --help )           usage
                                ;;
    esac
    shift
done

if [ "${action}" = 'build' ];
then
  echo $dev $imageName
	build
elif [ "${action}" = 'push' ];
then
  echo $username $password $file $server
	push
fi
