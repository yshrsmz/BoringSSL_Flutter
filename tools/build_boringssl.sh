#! /usr/bin/env bash

COMMIT_ID=$1
ANDROID_API_LEVEL=$2

BUILD_DIR=tools/build
OUTPUT_DIR=../../android-libs

rm -rf ${BUILD_DIR}
mkdir -p ${BUILD_DIR}
cd ${BUILD_DIR}

git clone git@github.com:google/boringssl.git
cd ./boringssl
git checkout ${COMMIT_ID}

for BORINGSSL_TARGET_PLATFORM in armeabi-v7a x86 x86_64 arm64-v8a
do

    mkdir build
    cd build
    mkdir -p ${OUTPUT_DIR}/${BORINGSSL_TARGET_PLATFORM}

    echo "building ${BORINGSSL_TARGET_PLATFORM}..."

    cmake -DANDROID_ABI=${BORINGSSL_TARGET_PLATFORM} \
 -DCMAKE_TOOLCHAIN_FILE=${ANDROID_NDK}/build/cmake/android.toolchain.cmake \
 -DANDROID_NATIVE_API_LEVEL=${ANDROID_API_LEVEL} \
 -DBUILD_SHARED_LIBS=1 \
 -GNinja ..

    ninja

    mv ./crypto/libcrypto.so ${OUTPUT_DIR}/${BORINGSSL_TARGET_PLATFORM}

    cd ..
    rm -rf build

done
