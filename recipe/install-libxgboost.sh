#!/bin/bash

. activate "${BUILD_PREFIX}"

LIBDIR=${PREFIX}/lib
INCDIR=${PREFIX}/include
BINDIR=${PREFIX}/bin
SODIR=${LIBDIR}
XGBOOSTDSO=libxgboost.so
EXEEXT=

mkdir -p ${LIBDIR} ${INCDIR}/xgboost ${BINDIR} || true
cp -f ${SRC_DIR}/lib/*.a ${LIBDIR}/
cp ${SRC_DIR}/xgboost${EXEEXT} ${BINDIR}/
cp ${SRC_DIR}/lib/${XGBOOSTDSO} ${SODIR}/
cp -Rf ${SRC_DIR}/include/xgboost ${INCDIR}/
cp -Rf ${SRC_DIR}/rabit/include/rabit ${INCDIR}/xgboost/
cp -f ${SRC_DIR}/src/c_api/*.h ${INCDIR}/xgboost/
