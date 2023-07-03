#!/usr/bin/env bats

# ~/.vkpr/bats/bin/bats vkpr-test/teste/teste.bats

export DETIK_CLIENT_NAMESPACE="vkpr"
load '../.bats/common.bats'

setup() {
  load "$VKPR_HOME/bats/bats-support/load"
  load "$VKPR_HOME/bats/bats-assert/load"
  load "$VKPR_HOME/bats/bats-detik/load"
  load "$VKPR_HOME/bats/bats-file/load"
}

setup_file() {
  touch $PWD/vkpr.yaml

  [ "$VKPR_TEST_SKIP_ALL" == "true" ] && echo "common_setup: skipping common_setup due to VKPR_TEST_SKIP_ALL=true" >&3 && return
  _common_setup "1" "false" "1"

  if [ "$VKPR_TEST_SKIP_DEPLOY_ACTIONS" == "true" ]; then
    echo "common_setup: skipping common_setup due to VKPR_TEST_SKIP_DEPLOY_ACTIONS=true" >&3
    return
  else
    echo "setup: installing kong..." >&3
    rit vkpr kong install --mode="standard" --default
  fi
}

teardown_file() {
  if [ "$VKPR_TEST_SKIP_ALL" == "true" ]; then
    echo "common_setup: skipping common_setup due to VKPR_TEST_SKIP_ALL=true" >&3
    return
  fi

  if [ "$VKPR_TEST_SKIP_DEPLOY_ACTIONS" == "true" ]; then
    echo "common_setup: skipping common_setup due to VKPR_TEST_SKIP_DEPLOY_ACTIONS=true" >&3
  else
    echo "Uninstall kong" >&3
    rit vkpr kong remove
  fi

  _common_teardown
}

teardown() {
  $VKPR_YQ -i "del(.global) | del(.kong)" $PWD/vkpr.yaml
}


@test "teste" {
  export RESPONSE=teste

  run echo $RESPONSE
  assert_output "teste"
  assert_success
}
