# found variable?
#include_directories(${GTEST_INCLUDE_DIRS})

add_executable(test-drishti test-EyeSegmenter.cpp test-drishti.cpp)
target_link_libraries(test-drishti drishti ${OpenCV_LIBS} GTest::main)

enable_testing()
add_test(NAME DrishtiTest COMMAND test-drishti
  "${CMAKE_SOURCE_DIR}/assets/drishti_eye_full_npd_eix.pba.z"
  "${CMAKE_SOURCE_DIR}/assets/images/2318-eye.png"
  "${CMAKE_SOURCE_DIR}/assets/images/2318-eye.json"
  )

set_property(TARGET test-drishti PROPERTY FOLDER "app/tests")

