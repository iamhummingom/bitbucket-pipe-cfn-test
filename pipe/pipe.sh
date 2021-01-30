#!/usr/bin/env bash
#
# This pipe is to lint and test AWS cloudformation script, using taskcat.
#
# Required globals:
#   AWS_ACCESS_KEY_ID
#   AWS_SECRET_ACCESS_KEY
#   AWS_DEFAULT_REGION
#   TEMPLATE

SCRIPT_PATH=$(dirname "$0")
echo 'Starting aws cloudformation lint and test.'

AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID:?'AWS_ACCESS_KEY_ID variable missing.'}
AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY:?'AWS_SECRET_ACCESS_KEY variable missing.'}
AWS_DEFAULT_REGION=${AWS_DEFAULT_REGION:?'AWS_DEFAULT_REGION variable missing.'}
TEMPLATE=${TEMPLATE:?'TEMPLATE variable missing.'}
echo 'environment variables are set.'

envsubst < "${SCRIPT_PATH}"/taskcat.tpl.yml > .taskcat.yml
echo 'taskcat config is created.'

taskcat lint
echo 'taskcat lint is finished.'
taskcat test run
echo 'taskcat run is finished.'

