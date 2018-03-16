#!/bin/bash

set -e

build_prefix=${build_dir}/binutils-${binutils_version}
install_prefix=${install_dir}/binutils-${binutils_version}

rm -rf ${build_prefix}
mkdir -p ${build_prefix}/bld
cd ${build_prefix}
tarball=binutils-${binutils_version}.tar.gz
url=https://ftp.gnu.org/gnu/binutils/${tarball}
if [ ! -f ${dist_dir}/misc/${tarball} ]; then wget ${url} -P ${dist_dir}/misc/; fi
tar -xzvf ${dist_dir}/misc/${tarball}
ln -s binutils-${binutils_version} src
cd bld

config_string=
config_string+=" --prefix=${install_prefix}"
config_string+=" CC=${CC} CXX=${CXX} FC=${FC}"

../src/configure ${config_string}
make -j${jobs}
${SUDO} make install