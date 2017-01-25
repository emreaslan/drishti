#!/bin/bash

set -e

[ -n ${ANDROID_SDK_ROOT} ] && unset ANDROID_SDK_ROOT
[ -n ${ANDROID_SDK_ROOT} ] && unset ANDROID_HOME
echo $ANDROID_SDK_ROOT

. ${DRISHTISDK}/bin/drishti-password.sh

IOS_IDENTITY="iPhone Developer: David Hirvonen (7YLQXWH6FK)"

HUNTER_CONFIGURATION_TYPES=Release
DRISHTI_BUILD_ACF=OFF
DRISHTI_BUILD_FACE=OFF
DRISHTI_BUILD_HCI=OFF
DRISHTI_BUILD_OGLES_GPGPU=OFF
DRISHTI_BUILD_EXAMPLES=ON
DRISHTI_BUILD_REGRESSION_FIXED_POINT=ON
DRISHTI_BUILD_REGRESSION_SIMD=ON
DRISHTI_BUILD_TESTS=ON
DRISHTI_BUILD_MIN_SIZE=ON
DRISHTI_BUILD_CONFIG=Release ##

DRISHTI_DISABLE_DSYM=OFF # release builds include dsym output

# Current release is pba.z format only
DRISHTI_SERIALIZE_WITH_BOOST=ON
DRISHTI_SERIALIZE_WITH_CEREAL=OFF
DRISHTI_SERIALIZE_WITH_CVMATIO=OFF

CPACK_TYPE=TGZ

DRISHTI_BUILD_ARGS_BASE=\
(
    "DRISHTI_BUILD_EXAMPLES=${DRISHTI_BUILD_EXAMPLES} "
    "DRISHTI_BUILD_TESTS=${DRISHTI_BUILD_TESTS} "
    "DRISHTI_BUILD_FACE=${DRISHTI_BUILD_FACE} "
    "DRISHTI_BUILD_ACF=${DRISHTI_BUILD_ACF} "
    "DRISHTI_BUILD_HCI=${DRISHTI_BUILD_HCI} "
    "DRISHTI_BUILD_OGLES_GPGPU=${DRISHTI_BUILD_OGLES_GPGPU} "
    "DRISHTI_BUILD_REGRESSION_FIXED_POINT=${DRISHTI_BUILD_REGRESSION_FIXED_POINT} "
    "DRISHTI_BUILD_REGRESSION_SIMD=${DRISHTI_BUILD_REGRESSION_SIMD} "
    "DRISHTI_SERIALIZE_WITH_BOOST=${DRISHTI_SERIALIZE_WITH_BOOST} "
    "DRISHTI_SERIALIZE_WITH_CEREAL=${DRISHTI_SERIALIZE_WITH_CEREAL} "
    "DRISHTI_SERIALIZE_WITH_CVMATIO=${DRISHTI_SERIALIZE_WITH_CVMATIO} "        
)

DRISHTI_BUILD_ARGS=( "HUNTER_CONFIGURATION_TYPES=Release" "${DRISHTI_BUILD_ARGS_BASE[@]}")
DRISHTI_BUILD_ARGS_DEBUG=( "HUNTER_CONFIGURATION_TYPES=Debug" "${DRISHTI_BUILD_ARGS_BASE[@]}")

DRISHTI_BUILD_HIDE=\
(
    "CMAKE_VISIBILITY_INLINES_HIDDEN=ON"
    "CMAKE_CXX_VISIBILITY_PRESET=hidden"
    "CMAKE_XCODE_ATTRIBUTE_GCC_INLINES_ARE_PRIVATE_EXTERN=YES"
    "CMAKE_XCODE_ATTRIBUTE_GCC_SYMBOLS_PRIVATE_EXTERN=YES"
)

DRISHTI_POLLY_ARGS=\
(
    "--config=${DRISHTI_BUILD_CONFIG}"    
)

function rename_tab
{
  echo -ne "\033]0;$1:$2\007"
}
