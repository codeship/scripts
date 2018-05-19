#!/usr/bin/env bats

setup() {
  export FFMPEG_VERSION="4.0"
}

cleanup() {
  rm -f "${HOME}/bin/ff"*
  rm -rf "${HOME}/ffmpeg"
  rm -rf "${HOME}/cache/ffmpeg-${FFMPEG_VERSION}"
  rm -f "${HOME}/cache/ffmpeg-${FFMPEG_VERSION}.tar.gz"
  unset FFMPEG_VERSION
}

@test "[ffmpeg.sh] Script runs" {
  ./packages/ffmpeg.sh
}

@test "[ffmpeg.sh] Download cached" {
  [ -f "${HOME}/cache/ffmpeg-${FFMPEG_VERSION}.tar.gz" ]
}

@test "[ffmpeg.sh] Compiled version cached" {
  [ -d "${HOME}/cache/ffmpeg-${FFMPEG_VERSION}" ]
}

@test "[ffmpeg.sh] Verify version" {
  run ffmpeg -version
  [[ "$output" =~ "ffmpeg version ${FFMPEG_VERSION}" ]]
  cleanup
}
