#!/bin/bash

set -e

build_prefix=${build_dir}/gcc-${gcc_version}
install_prefix=${install_dir}/gcc-${gcc_version}

rm -rf ${build_prefix}
mkdir -p ${build_prefix}/bld
cd ${build_prefix}
tarball=gcc-${gcc_version}.tar.gz
url=https://ftp.gnu.org/gnu/gcc/gcc-${gcc_version}/${tarball}
if [ ! -f ${dist_dir}/gcc/${tarball} ]; then wget ${url} -P ${dist_dir}/gcc/; fi
tar -xzvf ${dist_dir}/gcc/${tarball}
ln -s gcc-${gcc_version} src
cd gcc-${gcc_version}

gmp_tarball=gmp-${gmp_version}.tar.xz
mpfr_tarball=mpfr-${mpfr_version}.tar.gz
mpc_tarball=mpc-${mpc_version}.tar.gz
isl_tarball=isl-${isl_version}.tar.gz
gmp_url=https://ftp.gnu.org/gnu/gmp/${gmp_tarball}
mpfr_url=https://ftp.gnu.org/gnu/mpfr/${mpfr_tarball}
mpc_url=https://ftp.gnu.org/gnu/mpc/${mpc_tarball}
isl_url=http://isl.gforge.inria.fr/${isl_tarball}
if [ ! -f ${dist_dir}/misc/${gmp_tarball}  ]; then wget ${gmp_url}  -P ${dist_dir}/misc/; fi
if [ ! -f ${dist_dir}/misc/${mpfr_tarball} ]; then wget ${mpfr_url} -P ${dist_dir}/misc/; fi
if [ ! -f ${dist_dir}/misc/${mpc_tarball}  ]; then wget ${mpc_url}  -P ${dist_dir}/misc/; fi
if [ ! -f ${dist_dir}/misc/${isl_tarball}  ]; then wget ${isl_url}  -P ${dist_dir}/misc/; fi
tar -xJvf ${dist_dir}/misc/${gmp_tarball}
tar -xzvf ${dist_dir}/misc/${mpfr_tarball}
tar -xzvf ${dist_dir}/misc/${mpc_tarball}
tar -xzvf ${dist_dir}/misc/${isl_tarball}
ln -s gmp-${gmp_version}   gmp
ln -s mpfr-${mpfr_version} mpfr
ln -s mpc-${mpc_version}   mpc
ln -s isl-${isl_version}   isl

cd ../bld

config_string=
config_string+=" --enable-languages=c,c++,fortran"
config_string+=" --prefix=${install_prefix}"

../src/configure ${config_string}
make -j${jobs}
${SUDO} make install