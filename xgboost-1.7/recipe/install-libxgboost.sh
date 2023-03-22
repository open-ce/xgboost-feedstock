#!/bin/bash
# *****************************************************************
# (C) Copyright IBM Corp. 2018, 2022. All Rights Reserved.
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

. activate "${BUILD_PREFIX}"

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
    export CXXFLAGS="${CXXFLAGS} -std=c++14"
    cmake \
        -DCMAKE_INSTALL_PREFIX=${PREFIX} \
        -DCMAKE_CUDA_COMPILER=${CUDA_HOME}/bin/nvcc -DCMAKE_CUDA_HOST_COMPILER=${CXX} \
        -DCMAKE_INCLUDE_PATH=$PREFIX/include \
        -DUSE_CUDA=ON \
        -DUSE_NCCL=ON \
        -DCMAKE_CUDA_FLAGS="${CMAKE_CUDA_FLAGS} -std=c++14" \
        ..
fi
make -j${CPU_COUNT} ${VERBOSE_CM}

LIBDIR=${PREFIX}/lib
INCDIR=${PREFIX}/include
BINDIR=${PREFIX}/bin
SODIR=${LIBDIR}
XGBOOSTDSO=libxgboost.so
EXEEXT=

mkdir -p ${LIBDIR} ${INCDIR}/xgboost ${BINDIR} || true
cp ${SRC_DIR}/xgboost${EXEEXT} ${BINDIR}/
cp ${SRC_DIR}/lib/${XGBOOSTDSO} ${SODIR}/
cp -Rf ${SRC_DIR}/include/xgboost ${INCDIR}/
cp -Rf ${SRC_DIR}/rabit/include/rabit ${INCDIR}/xgboost/
cp -f ${SRC_DIR}/src/c_api/*.h ${INCDIR}/xgboost/
