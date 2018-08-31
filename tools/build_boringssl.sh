#! /usr/bin/env bash

COMMIT_ID=$1
ANDROID_API_LEVEL=$2

BUILD_ANDROID=${3:-1}
BUILD_IOS=${4:-1}

BUILD_DIR=tools/build
ANDROID_OUTPUT_DIR=../../android-libs
IOS_OUTPUT_DIR=../../ios-libs

rm -rf ${BUILD_DIR}
mkdir -p ${BUILD_DIR}
cd ${BUILD_DIR}

git clone git@github.com:google/boringssl.git
cd ./boringssl
git checkout ${COMMIT_ID}


if [ ${BUILD_ANDROID} = 1 ]; then
    echo ""
    echo "Building Android binaries..."

    # build Android binaries
    for BORINGSSL_TARGET_PLATFORM in armeabi-v7a x86 x86_64 arm64-v8a
    do

        mkdir build
        cd build
        mkdir -p ${ANDROID_OUTPUT_DIR}/${BORINGSSL_TARGET_PLATFORM}

        echo "building ${BORINGSSL_TARGET_PLATFORM}..."

        cmake -DANDROID_ABI=${BORINGSSL_TARGET_PLATFORM} \
 -DCMAKE_TOOLCHAIN_FILE=${ANDROID_NDK}/build/cmake/android.toolchain.cmake \
 -DANDROID_NATIVE_API_LEVEL=${ANDROID_API_LEVEL} \
 -DBUILD_SHARED_LIBS=1 \
 -GNinja ..

        ninja

        mv ./crypto/libcrypto.so ${ANDROID_OUTPUT_DIR}/${BORINGSSL_TARGET_PLATFORM}

        cd ..
        rm -rf build

    done
fi

if [ ${BUILD_IOS} = 1 ]; then
    echo ""
    echo "Building iOS binaries..."
    # build iOS binaries
    for BORINGSSL_TARGET_PLATFORM in armv7 armv7s arm64
    do
        mkdir build
        cd build
        mkdir -p ${IOS_OUTPUT_DIR}/${BORINGSSL_TARGET_PLATFORM}

        echo "building ${BORINGSSL_TARGET_PLATFORM}..."

        cmake -DCMAKE_OSX_SYSROOT=iphoneos \
-DCMAKE_OSX_ARCHITECTURES=${BORINGSSL_TARGET_PLATFORM} \
-GNinja ..

        ninja

        mv ./crypto/libcrypto.a ${IOS_OUTPUT_DIR}/${BORINGSSL_TARGET_PLATFORM}

        cd ..
        rm -rf build
    done

    # build iPhone Simulator binaries
    for BORINGSSL_TARGET_PLATFORM in i386 x86_64
    do
        mkdir build
        cd build
        mkdir -p ${IOS_OUTPUT_DIR}/${BORINGSSL_TARGET_PLATFORM}

        echo "building ${BORINGSSL_TARGET_PLATFORM}..."

        cmake -DCMAKE_OSX_SYSROOT=iphonesimulator \
-DCMAKE_OSX_ARCHITECTURES=${BORINGSSL_TARGET_PLATFORM} \
-GNinja ..

        ninja

        mv ./crypto/libcrypto.a ${IOS_OUTPUT_DIR}/${BORINGSSL_TARGET_PLATFORM}

        cd ..
        rm -rf build
    done
fi
