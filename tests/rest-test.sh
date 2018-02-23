#!/usr/bin/env bash

dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source $dir/common.sh

#
# TODO: Add assertion library to this
# TODO: Use jq to test the response, eg.
#
# {{{
# elements=`echo $(rest-read element) | jq -r '.[]'`
# for element in $elements; do
#   echo $element
# done
# }}}
#

#
# Test Element CRUD
#
function test_element {
  echo "Element tests"
  rest-create element
  rest-update element 'test' '{"test":"test"}'
  rest-read element
  rest-delete element 'test'
  echo -e "\n"
}

#
# Test Image CRUD
#
function test_image {
  echo "Image tests"
  rest-create image
  rest-update image 'test' '{"test":"test"}'
  rest-read image
  rest-delete image 'test'
  echo -e "\n"
}

#
# Test Job CRUD
#
function test_job {
  echo "Job tests"
  rest-create job
  rest-update job 'test' '{"test":"test"}'
  rest-read job
  rest-delete job 'test'
  echo -e "\n"
}

#
# Test Pipeline CRUD
#
function test_pipeline {
  echo "Pipeline tests"
  rest-create pipeline
  rest-update pipeline 'test' '{"test":"test"}'
  rest-read pipeline
  rest-delete pipeline 'test'
  echo -e "\n"
}

#
# Run tests
#

#test_element
#test_image
test_job
#test_pipeline
