#!/bin/bash

set -e

build_prefix=${build_dir}/geany-${geany_version}
install_prefix=${native_dir}/geany-${geany_version}

rm -rfv ${build_prefix}
mkdir -pv ${build_prefix}/bld
cd ${build_prefix}
tarball=geany-${geany_version}.tar.gz
url=http://download.geany.org/${tarball}
if [ ! -f ${dist_dir}/misc/${tarball} ]; then wget ${url} -P ${dist_dir}/misc/; fi
tar -xzvf ${dist_dir}/misc/${tarball}
ln -sv geany-${geany_version} src
cd bld

config_string=
config_string+=" --prefix=${install_prefix}"
config_string+=" CC=${CC} CXX=${CXX} FC=${FC}"
if [ -n "${compiler_lib_dirs}" ]; then
  config_string+=" LDFLAGS=-Wl,-rpath,${compiler_lib_dirs}"
fi

if [ "${geany_needs_intltool}" == "true" ]; then
  PATH=${native_dir}/intltool-${intltool_version}/bin:${PATH}
fi

../src/configure ${config_string}
make -j${num_cpus}
${sudo_cmd_native} make -j${num_cpus} install
