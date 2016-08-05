function(check_platforms)
  set(is_android ${ANDROID}) 
  set(is_apple ${APPLE})
  set(is_msvc ${MSVC})
  set(is_ios ${IOS})
  string(COMPARE EQUAL "${CMAKE_SYSTEM_NAME}" "Linux" is_linux)
  string(COMPARE EQUAL "${CMAKE_GENERATOR}" "Xcode" is_xcode)
  message("-- system --")
  message("  is_msvc: ${is_msvc}")
  message("  is_apple: ${is_apple}")
  message("  is_android: ${is_android}")
  message("  is_ios: ${is_ios}")
  message("  is_linux: ${is_linux}")
  message("  is_xcode: ${is_xcode}")
endfunction()
