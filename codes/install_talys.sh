#!/bin/bash

set -e

build_prefix=${build_dir}/talys-${talys_version}
install_prefix=${install_dir}/talys-${talys_version}

rm -rf ${build_prefix}
mkdir -p ${build_prefix}/bld
cd ${build_prefix}
tarball_code=talys${talys_version}_code.tar.gz
tarball_data=talys${talys_version}_data.tar.gz
tar -xzvf ${dist_dir}/talys/${tarball_code}
ln -s talys/source src

talyspath=`echo ${install_prefix}/ | sed 's/\//\\\\\//g'`
cd talys/source
sed -i "s/ home='.*'/ home='${talyspath}'/; s/60/80/" machine.f
sed -i "s/60 path/80 path/" talys.cmb
sed -i "s/90/110/" fissionpar.f
echo "project(talys Fortran)"                   >> CMakeLists.txt
echo "cmake_minimum_required(VERSION 2.8)"      >> CMakeLists.txt
echo "set(CMAKE_BUILD_TYPE Release)"            >> CMakeLists.txt
echo "set(CMAKE_Fortran_FLAGS_RELEASE \"-O1\")" >> CMakeLists.txt
echo "file(GLOB SRC_FILES \"*.f\")"             >> CMakeLists.txt
echo "add_executable(talys \${SRC_FILES})"      >> CMakeLists.txt
echo "install(TARGETS talys DESTINATION bin)"   >> CMakeLists.txt
cd ../../bld

cmake_string=
cmake_string+=" -DCMAKE_BUILD_TYPE=Release"
cmake_string+=" -DCMAKE_Fortran_COMPILER=${FC}"
cmake_string+=" -DCMAKE_INSTALL_PREFIX=${install_prefix}"
if [ -n "${compiler_lib_dirs}" ]; then
  cmake_string+=" -DCMAKE_INSTALL_RPATH=${compiler_lib_dirs}"
fi

cmake ../src ${cmake_string}
make -j${jobs}
${sudo_cmd} make install

cd ${install_prefix}
if [ "${compiler}" == "native" ]; then
  ${sudo_cmd} tar -xzvf ${dist_dir}/talys/${tarball_data}
else
  ${sudo_cmd} ln -snf ${native_dir}/talys-${talys_version}/talys .
fi