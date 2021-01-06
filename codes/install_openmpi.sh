#!/bin/bash

set -e

build_prefix=${build_dir}/openmpi-${openmpi_version}
install_prefix=${install_dir}/openmpi-${openmpi_version}

rm -rfv ${build_prefix}
mkdir -pv ${build_prefix}/bld
cd ${build_prefix}
tarball=openmpi-${openmpi_version}.tar.gz
openmpi_version_major=$(echo ${openmpi_version} | cut -f1,2 -d'.')
url=http://www.open-mpi.org/software/ompi/v${openmpi_version_major}/downloads/${tarball}
if [ ! -f ${dist_dir}/openmpi/${tarball} ]; then wget ${url} -P ${dist_dir}/openmpi/; fi
tar -xzvf ${dist_dir}/openmpi/${tarball}
ln -sv openmpi-${openmpi_version} src
cd bld

config_string=
config_string+=" --disable-dlopen"
config_string+=" --enable-shared"
config_string+=" --enable-static"
config_string+=" --enable-mpi-cxx"
config_string+=" --enable-mpi-fortran"
if [ "${system_has_java}" == "true" ]; then
  config_string+=" --enable-mpi-java"
  config_string+=" --with-jdk-dir=${native_dir}/jdk"
fi
config_string+=" --with-pmi"
config_string+=" --with-pmix"
config_string+=" --with-slurm"
config_string+=" --prefix=${install_prefix}"
config_string+=" CC=${CC} CXX=${CXX} FC=${FC}"
if [ -n "${compiler_rpath_dirs}" ]; then
  config_string+=" LDFLAGS=-Wl,-rpath,${compiler_rpath_dirs}"
fi

../src/configure ${config_string}
make -j${num_cpus}
${sudo_cmd_install} make -j${num_cpus} install
