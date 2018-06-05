#!/usr/bin/env bats

load '/usr/local/lib/bats/load.bash'

# Uncomment the following to get more detail on failures of stubs
# export NPROC_STUB_DEBUG=/dev/tty
# export DOCKER_STUB_DEBUG=/dev/tty
# export GIT_STUB_DEBUG=/dev/tty
# export BUILDKITE_AGENT_STUB_DEBUG=/dev/tty

@test "Runs the bundle update via Docker" {
  stub nproc ": echo 17"
  stub docker \
    "pull ruby:slim : echo pulled image" \
    "run --interactive --tty --rm --volume /plugin:/bundle_update --workdir /bundle_update ruby:slim bundle update --jobs=17 : echo bundle updated"
  stub git "diff-index --quiet HEAD -- Gemfile.lock : exit 1"
  stub buildkite-agent "meta-data set bundle-update-plugin-changes true : echo meta-data set"

  run $PWD/hooks/command

  assert_success
  assert_output --partial "pulled image"
  assert_output --partial "bundle updated"
  unstub nproc
  unstub docker
  unstub git
  unstub buildkite-agent
}

@test "Sets buildkite metadata when changes are found" {
  stub nproc ": echo 17"
  stub docker \
    "pull ruby:slim : echo pulled image" \
    "run --interactive --tty --rm --volume /plugin:/bundle_update --workdir /bundle_update ruby:slim bundle update --jobs=17 : echo bundle updated"
  stub git "diff-index --quiet HEAD -- Gemfile.lock : exit 1"
  stub buildkite-agent "meta-data set bundle-update-plugin-changes true : echo meta-data set"

  run $PWD/hooks/command

  assert_success
  assert_output --partial "meta-data set"
  unstub nproc
  unstub docker
  unstub git
  unstub buildkite-agent
}

@test "Does not buildkite metadata when no changes are found" {
  stub nproc ": echo 17"
  stub docker \
    "pull ruby:slim : echo pulled image" \
    "run --interactive --tty --rm --volume /plugin:/bundle_update --workdir /bundle_update ruby:slim bundle update --jobs=17 : echo bundle updated"
  stub git "diff-index --quiet HEAD -- Gemfile.lock : exit 0"
  stub buildkite-agent "meta-data set bundle-update-plugin-changes true : echo meta-data set"

  run $PWD/hooks/command

  assert_success
  refute_output --partial "meta-data set"
  unstub nproc
  unstub docker
  unstub git
}

@test "Supports the image option" {
  export BUILDKITE_PLUGIN_BUNDLE_UPDATE_IMAGE=my-image

  stub nproc ": echo 17"
  stub docker \
    "pull my-image : echo pulled image" \
    "run --interactive --tty --rm --volume /plugin:/bundle_update --workdir /bundle_update my-image bundle update --jobs=17 : echo bundle updated"
  stub git "diff-index --quiet HEAD -- Gemfile.lock : exit 1"
  stub buildkite-agent "meta-data set bundle-update-plugin-changes true : echo meta-data set"

  run $PWD/hooks/command

  assert_success
  assert_output --partial "pulled image"
  assert_output --partial "bundle updated"
  unstub nproc
  unstub docker
  unstub git
  unstub buildkite-agent
}