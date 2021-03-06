#!/bin/bash

set -e

install_prefix=${install_dir}/fluka-${fluka_version}

${sudo_cmd_install} rm -rfv ${install_prefix}
${sudo_cmd_install} mkdir -pv ${install_prefix}/bin
cd ${install_prefix}/bin
tarball=fluka${fluka_version}-linux-gfor64bitAA.tar.gz
${sudo_cmd_install} tar -xzvf ${dist_dir}/fluka/${tarball}

if [ ! -z "${gcc_dir}" ]; then PATH=${gcc_dir}/bin:${PATH}; fi

export FLUFOR=$(basename $FC)
export FLUPRO=${PWD}
if [ -z "${sudo_cmd_install}" ]; then
  ${sudo_cmd_install} make
else
  ${sudo_cmd_install} --preserve-env=FLUFOR,FLUPRO make
fi
