#!/bin/bash

set -e

build_prefix=${build_dir}/geant4-${geant4_version}
install_prefix=${install_dir}/geant4-${geant4_version}

rm -rf ${build_prefix}
mkdir -p ${build_prefix}/bld
cd ${build_prefix}
tarball=geant4.${geant4_version}.tar.gz
url=http://geant4.cern.ch/support/source/${tarball}
if [ ! -f ${dist_dir}/geant4/${tarball} ]; then wget ${url} -P ${dist_dir}/geant4/; fi
tar -xzvf ${dist_dir}/geant4/${tarball}
ln -s geant4.${geant4_version} src
cd bld

cmake_string=
cmake_string+=" -DBUILD_STATIC_LIBS=ON"
cmake_string+=" -DGEANT4_USE_SYSTEM_EXPAT=OFF"
cmake_string+=" -DCMAKE_INSTALL_RPATH=${install_prefix}/lib"
cmake_string+=" -DCMAKE_BUILD_TYPE=Release"
cmake_string+=" -DCMAKE_C_COMPILER=${CC}"
cmake_string+=" -DCMAKE_CXX_COMPILER=${CXX}"
cmake_string+=" -DCMAKE_INSTALL_PREFIX=${install_prefix}"

cmake ../src ${cmake_string}
make -j${jobs}
${SUDO} make install