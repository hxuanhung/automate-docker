#!/bin/sh

SCRIPT_PATH=$(cd "$(dirname "$0")"; pwd);

sendPr(){
  git push origin ${source_branch}
  node ${SCRIPT_PATH}/gitlab.js --action sendPr --title "${TITLE}" --target "${target_branch}" --source "${source_branch}" --assignedTo "${assignee_id}"
}

usage(){
  echo "Usage: automate-docker [command] [options]"
  echo "Arguments:
    build                                 command: send pull request
    -T | --title [title]                    merge request title
    -s | --source_branch [source_branch]    source branch name
    -t | --target_branch [target_branch]    target branch name
    -a | --assignee_id [assignee_id]        id of assigned user
    -h | --help if show help"
}

while [ "$1" != "" ]; do
    case $1 in
        build)                  action='build'
						                    ;;
        -u | --username)        shift
                                username=$1
                                ;;
        -p | --password)        shift
                                password=$1
                                ;;
        -s | --server)          shift
                                server=$1
                                ;;
        # if it's -h or --help, call function usage to show the help text
        -h | --help )           usage
                                ;;
    esac
    shift
done

if [ "${action}" = 'build' ];
then
  echo $username $password $server
fi
