#!/bin/bash

set -e

build_prefix=${build_dir}/openmpi-${openmpi_version}
install_prefix=${install_dir}/openmpi-${openmpi_version}

rm -rf ${build_prefix}
mkdir -p ${build_prefix}/bld
cd ${build_prefix}
tarball=openmpi-${openmpi_version}.tar.gz
if   [ "${openmpi_version:3:1}" == "." ]; then openmpi_version_major=${openmpi_version::3}
elif [ "${openmpi_version:4:1}" == "." ]; then openmpi_version_major=${openmpi_version::4}
fi
url=http://www.open-mpi.org/software/ompi/v${openmpi_version_major}/downloads/${tarball}
if [ ! -f ${dist_dir}/openmpi/${tarball} ]; then wget ${url} -P ${dist_dir}/openmpi/; fi
tar -xzvf ${dist_dir}/openmpi/${tarball}
ln -s openmpi-${openmpi_version} src
cd bld

config_string=
if [ "${slurm_support}" == "true" ]; then
  config_string+=" --with-slurm"
  config_string+=" --with-pmi"
fi
config_string+=" --prefix=${install_prefix}"
config_string+=" CC=${CC} CXX=${CXX} FC=${FC}"

../src/configure ${config_string}
make -j${jobs}
${SUDO} make install