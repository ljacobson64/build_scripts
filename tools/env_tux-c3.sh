#!/bin/bash

source versions.sh

# Important directories
export dist_dir=/groupspace/cnerg/users/jacobson/dist
export build_dir=/local.hd/cnergg/jacobson/build/${compiler}
export install_dir=/groupspace/cnerg/users/jacobson/opt/${compiler}
export native_dir=/groupspace/cnerg/users/jacobson/opt/native
export gcc_dir=${native_dir}/gcc-${gcc_version}
export intel_dir=/groupspace/cnerg/users/jacobson/intel
export mcnp_exe=/groupspace/cnerg/users/jacobson/MCNP/bin/mcnp5
export DATAPATH=/groupspace/cnerg/users/jacobson/MCNP/MCNP_DATA
export scale_data_dir=/groupspace/cnerg/users/jacobson/SCALE/data
export lapack_dir=/usr/lib

# Miscellaneous environment variables used by install scripts
export jobs=`grep -c processor /proc/cpuinfo`
export sudo_cmd=
export slurm_support=false
export geany_needs_intltool=true
export geant4_libdir=lib
export native_python=true
export native_setuptools=true
export native_pythonpacks=false
export native_exnihilo_packs=false

# Specify location of CMake
export PATH=/groupspace/cnerg/users/jacobson/opt/cmake/bin:${PATH}
export CMAKE=/groupspace/cnerg/users/jacobson/opt/cmake/bin/cmake

# Specify path to intel compiler
if   [ "${compiler}" == "intel-13" ]; then intel_dir=${intel_dir}/13.1.3.192
elif [ "${compiler}" == "intel-14" ]; then intel_dir=${intel_dir}/14.0.6.214
elif [ "${compiler}" == "intel-15" ]; then intel_dir=${intel_dir}/15.0.7.235
elif [ "${compiler}" == "intel-16" ]; then intel_dir=${intel_dir}/16.0.8.266
elif [ "${compiler}" == "intel-17" ]; then intel_dir=${intel_dir}/17.0.8.262
elif [ "${compiler}" == "intel-18" ]; then intel_dir=${intel_dir}/18.0.5.274
elif [ "${compiler}" == "custom"   ]; then intel_dir=${intel_dir}/18.0.5.274
fi

# Specify paths to compilers
if [ "${compiler}" == "native" ]; then
  export CC=/usr/bin/gcc
  export CXX=/usr/bin/g++
  export FC=/usr/bin/gfortran
  export compiler_lib_dirs=
elif [ "${compiler}" == "gcc-7" ]; then
  export CC=${gcc_dir}/bin/gcc
  export CXX=${gcc_dir}/bin/g++
  export FC=${gcc_dir}/bin/gfortran
  export compiler_lib_dirs=${gcc_dir}/lib64
elif [[ "${compiler}" == "intel-"* ]]; then
  export CC=${intel_dir}/bin/icc
  export CXX=${intel_dir}/bin/icpc
  export FC=${intel_dir}/bin/ifort
  export compiler_lib_dirs=${intel_dir}/lib/intel64
elif [ "${compiler}" == "custom" ]; then
  export CC=${gcc_dir}/bin/gcc
  export CXX=${gcc_dir}/bin/g++
  export FC=${intel_dir}/bin/ifort
  export compiler_lib_dirs=${intel_dir}/lib/intel64
fi

# Control which versions of MCNP/DAGMC are built
if [ "${compiler}" == "native" ]; then
  export install_mcnpx27=true
  export install_fludag=false
  export install_daggeant4=true
elif [ "${compiler}" == "gcc-7" ]; then
  export install_mcnpx27=true
  export install_fludag=true
  export install_daggeant4=true
elif [[ "${compiler}" == "intel-"* ]]; then
  export install_mcnpx27=true
  export install_fludag=false
  export install_daggeant4=false
elif [ "${compiler}" == "custom" ]; then
  export install_mcnpx27=true
  export install_fludag=false
  export install_daggeant4=false
fi

# Set additional path environment variables
export LD_LIBRARY_PATH=
export LIBRARY_PATH=${compiler_lib_dirs}
