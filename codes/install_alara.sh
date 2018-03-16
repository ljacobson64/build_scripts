#!/bin/bash

set -e

build_prefix=${build_dir}/ALARA
install_prefix=${install_dir}/ALARA

rm -rf ${build_prefix}
mkdir -p ${build_prefix}/bld
cd ${build_prefix}
git clone https://github.com/svalinn/ALARA -b master --single-branch
ln -s ALARA src
cd ALARA
autoreconf -fi
cd ../bld

config_string=
config_string+=" --prefix=${install_prefix}"
config_string+=" CC=${CC} CXX=${CXX} FC=${FC}"

../src/configure ${config_string}
make -j${jobs}
${SUDO} make install