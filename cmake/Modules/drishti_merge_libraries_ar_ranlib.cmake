include(CMakeParseArguments) # cmake_parse_arguments

function(drishti_merge_libraries_ar_ranlib)
  set(optional)
  set(one LIBRARIES_LIST FINAL WORKING_DIR)
  set(multiple ALL_DEPENDENCIES)

  # Introduce:
  # * x_LIBRARIES_LIST
  # * x_FINAL
  # * x_ALL_DEPENDENCIES
  # * x_WORKING_DIR
  cmake_parse_arguments(x "${optional}" "${one}" "${multiple}" "${ARGV}")

  string(COMPARE NOTEQUAL "${x_UNPARSED_ARGUMENTS}" "" has_unparsed)
  if(has_unparsed)
    message(FATAL_ERROR "Unparsed arguments: ${x_UNPARSED_ARGUMENTS}")
  endif()

  if(NOT TARGET "${x_FINAL}")
    message(FATAL_ERROR "Target doesn't exist: ${x_FINAL}")
  endif()

  string(COMPARE EQUAL "${x_WORKING_DIR}" "" is_empty)
  if(is_empty)
    message(FATAL_ERROR "WORKING_DIR empty")
  endif()

  set(append_commands "")
  foreach(x ${x_ALL_DEPENDENCIES})
    # Skip system framework dependencies
    # TODO: static pseudo-frameworks should be handled (rare use case)
    if("${x}" MATCHES "-framework")
      continue()
    endif()    
    get_target_property(_target_type "${x}" TYPE)
    if(_target_type STREQUAL "INTERFACE_LIBRARY")
      continue()
    endif()    
    if(TARGET ${x})
      set(lib "$<TARGET_FILE:${x}>")
    else()
      set(lib "${x}")
    endif()
    list(
        APPEND
        append_commands
        COMMAND
        "${CMAKE_COMMAND}"
        "-DLIBRARIES_LIST=${x_LIBRARIES_LIST}"
        "-DLIBRARY=${lib}"
        -P "${DRISHTI_MERGE_LIBRARIES_DIR}/script/append.cmake"
    )
  endforeach()

  add_custom_command(
      TARGET "${x_FINAL}"
      POST_BUILD
      COMMAND "${CMAKE_COMMAND}" -E remove_directory "${x_WORKING_DIR}"
      ${append_commands}
      COMMAND
          "${CMAKE_COMMAND}"
          "-DLIBRARIES_LIST=${x_LIBRARIES_LIST}"
          "-DWORKING_DIR=${x_WORKING_DIR}"
          "-DCMAKE_AR=${CMAKE_AR}"
          "-DCMAKE_RANLIB=${CMAKE_RANLIB}"
          "-DFINAL_LIBRARY=$<TARGET_FILE:${x_FINAL}>"
          -P "${DRISHTI_MERGE_LIBRARIES_DIR}/script/create_by_ar_ranlib.cmake"
      COMMENT "Creating library '${x_FINAL}'"
  )
endfunction()
