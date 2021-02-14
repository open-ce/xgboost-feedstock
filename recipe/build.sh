#!/bin/bash
# *****************************************************************
# (C) Copyright IBM Corp. 2018, 2021. All Rights Reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
# *****************************************************************
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
    cmake \
        -DCMAKE_INSTALL_PREFIX=${PREFIX} \
        -DCMAKE_CUDA_COMPILER=${CUDA_HOME}/bin/nvcc -DCMAKE_CUDA_HOST_COMPILER=${CXX} \
        -DCMAKE_INCLUDE_PATH=$PREFIX/include \
        -DUSE_CUDA=ON \
        -DUSE_NCCL=ON \
        ..
fi

make -j${CPU_COUNT} ${VERBOSE_CM}
