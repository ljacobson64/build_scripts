#!/bin/bash

set -e

build_prefix=${build_dir}/lapack-${lapack_version}
install_prefix=${install_dir}/lapack-${lapack_version}

rm -rf ${build_prefix}
mkdir -p ${build_prefix}/bld
cd ${build_prefix}
tarball=lapack-${lapack_version}.tar.gz
url=http://www.netlib.org/lapack/${tarball}
if [ ! -f ${dist_dir}/misc/${tarball} ]; then wget ${url} -P ${dist_dir}/misc/; fi
tar -xzvf ${dist_dir}/misc/${tarball}
ln -s lapack-${lapack_version} src
cd bld

cmake_string=
cmake_string+=" -DCMAKE_BUILD_TYPE=Release"
cmake_string+=" -DCMAKE_Fortran_COMPILER=${FC}"
cmake_string+=" -DCMAKE_INSTALL_PREFIX=${install_prefix}"
cmake_string_static=${cmake_string}
cmake_string_shared=${cmake_string}
cmake_string_static+=" -DBUILD_SHARED_LIBS=OFF"
cmake_string_shared+=" -DBUILD_SHARED_LIBS=ON"

cmake ../src ${cmake_string_static}
make -j${jobs}
${SUDO} make install
cd ..; rm -rf bld; mkdir -p bld; cd bld
cmake ../src ${cmake_string_shared}
make -j${jobs}
${SUDO} make install