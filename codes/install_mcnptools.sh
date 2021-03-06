#!/bin/bash

set -e

build_prefix=${build_dir}/MCNPTOOLS-${mcnptools_version}
install_prefix=${native_dir}/MCNPTOOLS-${mcnptools_version}

rm -rfv ${build_prefix}
mkdir -pv ${build_prefix}/bld
cd ${build_prefix}
unzip ${dist_dir}/mcnp/mcnptools-${mcnptools_version}.zip
ln -sv Source/libmcnptools src
cd bld

cmake_string=
cmake_string+=" -DCMAKE_C_COMPILER=${CC}"
cmake_string+=" -DCMAKE_CXX_COMPILER=${CXX}"
cmake_string+=" -DCMAKE_INSTALL_PREFIX=${install_prefix}"

${CMAKE} ../src ${cmake_string}
make -j${num_cpus}
${sudo_cmd_native} make -j${num_cpus} install

cd ../Source/python

python2 setup.py build
${sudo_cmd_native} mkdir -pv ${install_prefix}/lib/python2.7/site-packages
PYTHONPATH=${install_prefix}/lib/python2.7/site-packages
${sudo_cmd_native} PYTHONPATH=${PYTHONPATH} python2 setup.py install --prefix=${install_prefix}

python3 setup.py build
${sudo_cmd_native} mkdir -pv ${install_prefix}/lib/python3.8/site-packages
PYTHONPATH=${install_prefix}/lib/python3.8/site-packages
${sudo_cmd_native} PYTHONPATH=${PYTHONPATH} python3 setup.py install --prefix=${install_prefix}
