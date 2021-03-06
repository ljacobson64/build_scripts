#!/bin/bash

set -e

build_prefix=${build_dir}/opencascade-${opencascade_version}
install_prefix=${install_dir}/opencascade-${opencascade_version}

rm -rfv ${build_prefix}
mkdir -pv ${build_prefix}/bld
cd ${build_prefix}
tarball=opencascade-${opencascade_version}.tgz
tar -xzvf ${dist_dir}/misc/${tarball}
ln -sv opencascade-${opencascade_version} src
cd bld

cmake_string=
cmake_string+=" -DCMAKE_BUILD_TYPE=Release"
cmake_string+=" -DCMAKE_C_COMPILER=${CC}"
cmake_string+=" -DCMAKE_CXX_COMPILER=${CXX}"
cmake_string+=" -DCMAKE_INSTALL_PREFIX=${install_prefix}"
if [ -n "${compiler_lib_dirs}" ]; then
  cmake_string+=" -DCMAKE_INSTALL_RPATH=${compiler_lib_dirs}:${install_prefix}/lib"
else
  cmake_string+=" -DCMAKE_INSTALL_RPATH=${install_prefix}/lib"
fi

${CMAKE} ../src ${cmake_string}
make -j${num_cpus}
${sudo_cmd_install} make -j${num_cpus} install
