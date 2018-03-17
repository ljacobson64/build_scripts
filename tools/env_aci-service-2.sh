#!/bin/bash

source versions.sh

export dist_dir=/home/ljjacobson/dist
export build_dir=/scratch/local/ljjacobson/build/${compiler}
export install_dir=/home/group/dagmc/opt/${compiler}
export native_dir=/home/group/dagmc/opt/native
export gcc_dir=${native_dir}/gcc-${gcc_version}
export intel_dir=/opt/intel-2016/compilers_and_libraries_2016.2.181/linux
export python_dir=/home/group/dagmc/local
export mcnp_exe=/home/group/dagmc/MCNP/MCNP_CODE/bin/mcnp5
export DATAPATH=/home/group/dagmc/MCNP/MCNP_DATA

export jobs=`grep -c processor /proc/cpuinfo`
export sudo_cmd=
export slurm_support=true
export geany_needs_intltool=true

export LD_LIBRARY_PATH=
export PYTHONPATH=${python_dir}/lib/python2.7/site-packages

export install_mcnpx27=true
export install_fludag=true
export install_daggeant4=true

if [ "${compiler}" == "native" ]; then
  export CC=/usr/lib64/ccache/gcc
  export CXX=/usr/lib64/ccache/g++
  export FC=/usr/bin/gfortran
  export compiler_lib_dirs=

  export install_fludag=false
  export install_daggeant4=false
elif [ "${compiler}" == "gcc-7" ]; then
  export CC=${gcc_dir}/bin/gcc
  export CXX=${gcc_dir}/bin/g++
  export FC=${gcc_dir}/bin/gfortran
  export compiler_lib_dirs=${gcc_dir}/lib64
elif [ "${compiler}" == "intel-16" ]; then
  export CC=${intel_dir}/bin/intel64/icc
  export CXX=${intel_dir}/bin/intel64/icpc
  export FC=${intel_dir}/bin/intel64/ifort
  export compiler_lib_dirs=${intel_dir}/compiler/lib/intel64

  export install_mcnpx27=false
  export install_fludag=false
  export install_daggeant4=false
elif [ "${compiler}" == "custom" ]; then
  export CC=${gcc_dir}/bin/gcc
  export CXX=${gcc_dir}/bin/g++
  export FC=${intel_dir}/bin/intel64/ifort
  export compiler_lib_dirs=${gcc_dir}/lib64:${intel_dir}/compiler/lib/intel64

  export install_fludag=false
  export install_daggeant4=false
fi

export LIBRARY_PATH=${compiler_lib_dirs}
