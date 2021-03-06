#!/bin/bash

set -e

build_prefix=${build_dir}/mpich-${mpich_version}
install_prefix=${install_dir}/mpich-${mpich_version}

rm -rfv ${build_prefix}
mkdir -pv ${build_prefix}/bld
cd ${build_prefix}
tarball=mpich-${mpich_version}.tar.gz
url=http://www.mpich.org/static/downloads/${mpich_version}/${tarball}
if [ ! -f ${dist_dir}/mpich/${tarball} ]; then wget ${url} -P ${dist_dir}/mpich/; fi
tar -xzvf ${dist_dir}/mpich/${tarball}
ln -sv mpich-${mpich_version} src
cd bld

config_string=
LIBS=
if [ "${slurm_support}" == "true" ]; then
  config_string+=" --with-slurm=/usr"
fi
config_string+=" --prefix=${install_prefix}"
config_string+=" CC=${CC} CXX=${CXX} FC=${FC} LIBS=${LIBS}"
if [ -n "${compiler_lib_dirs}" ]; then
  config_string+=" LDFLAGS=-Wl,-rpath,${compiler_lib_dirs}"
fi

../src/configure ${config_string}
make -j${num_cpus}
${sudo_cmd_install} make -j${num_cpus} install
