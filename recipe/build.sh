# *****************************************************************
#
# Licensed Materials - Property of IBM
#
# (C) Copyright IBM Corp. 2018, 2020. All Rights Reserved.
#
# US Government Users Restricted Rights - Use, duplication or
# disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
#
# *****************************************************************
#!/bin/bash

set -ex

# Patching the submodule here to fix build error in conda environment
cd ${SRC_DIR}/dmlc-core
git apply ${RECIPE_DIR}/0003-Conda-Build-fixed.patch
cd ..

mkdir -p build
cd build

if [[ $build_type == "cpu" ]]
then
    cmake \
        -DCMAKE_INSTALL_PREFIX=${PREFIX} \
        ..
elif [[ $build_type == "cuda" ]]
then
    export CUDAHOSTCXX=$CXX
    export CUDA_HOME=/usr/local/cuda
    cmake \
        -DCMAKE_INSTALL_PREFIX=${PREFIX} \
        -DCMAKE_CUDA_COMPILER=${CUDA_HOME}/bin/nvcc -DCMAKE_CUDA_HOST_COMPILER=${CXX} \
        -DCMAKE_INCLUDE_PATH=$PREFIX/include \
        -DUSE_CUDA=ON \
        -DUSE_NCCL=ON \
        ..
fi

make -j${CPU_COUNT} ${VERBOSE_CM}
