# - Try to find GLUI (GL User Interface)
# Requires OpenGL and GLUT, which it will try to load.
#
#	GLUI_INCLUDE_DIR, where to find GL/glui.h (or GLUI/glui.h on mac)
#	GLUI_LIBRARY, the libraries to link against
#	GLUI_FOUND, If false, do not try to use GLUI.
#
# Plural versions refer to this library and its dependencies, and
# are recommended to be used instead, unless you have a good reason.
#
# Useful configuration variables you might want to add to your cache:
#   GLUI_ROOT_DIR - A directory prefix to search
#                  (usually a path that contains include/ as a subdirectory)
#   GLUI_DONT_BUILD - Disables trying to build the library from local
#                     source if present and not already built.
#
# Original Author:
# 2009-2010 Ryan Pavlik <rpavlik@iastate.edu> <abiryan@ryand.net>
# http://academic.cleardefinition.com
# Iowa State University HCI Graduate Program/VRAC
#
# Copyright Iowa State University 2009-2010.
# Distributed under the Boost Software License, Version 1.0.
# (See accompanying file LICENSE_1_0.txt or copy at
# http://www.boost.org/LICENSE_1_0.txt)
#
# Modified by Ben to find the local version of GLUI.

if(GLUI_FIND_QUIETLY)
	if(NOT OPENGL_FOUND)
		find_package(OpenGL QUIET)
	endif()
	if(NOT GLUT_FOUND)
		find_package(GLUT QUIET)
	endif()
else()
	if(NOT OPENGL_FOUND)
		find_package(OpenGL)
	endif()
	if(NOT GLUT_FOUND)
		find_package(GLUT)
	endif()
endif()

set(GLUI_LOCAL_ROOT ${CMAKE_CURRENT_LIST_DIR}/glui)
set(GLUI_ROOT_PATHS ${GLUI_ROOT_DIR} ${GLUI_LOCAL_ROOT}/bin)

if(OPENGL_FOUND AND GLUT_FOUND)
  # Check to see if the glui library is hosted locally and needs to be built
  if(NOT GLUI_DONT_BUILD AND EXISTS ${GLUI_LOCAL_ROOT}/CMakeLists.txt)
    # Go generate and build the local copy of the code
    # This is probably against lots of CMake rules, but I'm trying to make_directory
    # things as easy as possible for my users...
    message(STATUS "Calling CMake on local GLUI library...")
    if(WIN32)
      execute_process(
          COMMAND ${CMAKE_COMMAND} -G "${CMAKE_GENERATOR}" ../
          WORKING_DIRECTORY ${GLUI_LOCAL_ROOT}/bin)
      message(STATUS "Compiling GLUI Debug library...")
      execute_process(
          COMMAND ${CMAKE_COMMAND} --build . --config DEBUG
          WORKING_DIRECTORY ${GLUI_LOCAL_ROOT}/bin
          OUTPUT_FILE ${GLUI_LOCAL_ROOT}/bin/debug_build.log
          ERROR_FILE ${GLUI_LOCAL_ROOT}/bin/debug_build.log
          RESULT_VARIABLE GLUI_DEBUG_BUILD_RESULT)
      if(GLUI_DEBUG_BUILD_RESULT EQUAL 0)
        message(STATUS "Compiling GLUI Debug library succeded.")
      else()
        message(WARNING "Compiling GLUI Debug library failed. See ${GLUI_LOCAL_ROOT}/bin/debug_build.log for details")
      endif()
      
      message(STATUS "Compiling GLUI Release library...")
      execute_process(
          COMMAND ${CMAKE_COMMAND} --build . --config RELEASE
          WORKING_DIRECTORY ${GLUI_LOCAL_ROOT}/bin
          OUTPUT_FILE ${GLUI_LOCAL_ROOT}/bin/release_build.log
          ERROR_FILE ${GLUI_LOCAL_ROOT}/bin/release_build.log
          RESULT_VARIABLE GLUI_RELEASE_BUILD_RESULT)
      if(GLUI_RELEASE_BUILD_RESULT EQUAL 0)
        message(STATUS "Compiling GLUI Release library succeded.")
      else()
        message(WARNING "Compiling GLUI Release library failed. See ${GLUI_LOCAL_ROOT}/bin/release_build.log for details")
      endif()
    else()
      #TODO: Test this section!
      execute_process(
          COMMAND ${CMAKE_COMMAND} -G "${CMAKE_GENERATOR}" ../
          WORKING_DIRECTORY ${GLUI_LOCAL_ROOT}/bin)
      
      message(STATUS "Compiling GLUI Release library...")
      execute_process(
          COMMAND ${CMAKE_COMMAND} --build . --config RELEASE
          WORKING_DIRECTORY ${GLUI_LOCAL_ROOT}/bin
          OUTPUT_FILE ${GLUI_LOCAL_ROOT}/bin/release_build.log
          ERROR_FILE ${GLUI_LOCAL_ROOT}/bin/release_build.log
          RESULT_VARIABLE GLUI_RELEASE_BUILD_RESULT)
      if(GLUI_RELEASE_BUILD_RESULT EQUAL 0)
        message(STATUS "Compiling GLUI Release library succeded.")
      else()
        message(WARNING "Compiling GLUI Release library failed. See ${GLUI_LOCAL_ROOT}/bin/release_build.log for details")
      endif()
    endif()
  endif()
  
  
	if(WIN32)
		find_path(GLUI_INCLUDE_DIR
			NAMES
			GL/glui.h
			HINTS
			${GLUI_ROOT_PATHS}
			PATH_SUFFIXES
			include
			DOC
			"GLUI include directory")
		find_library(GLUI_LIBRARY
			NAMES
			glui32
			glui64
			HINTS
			${GLUI_ROOT_PATHS}
			${OPENGL_LIBRARY_DIR}
			${OPENGL_INCLUDE_DIR}/../lib
			PATH_SUFFIXES
			lib64
			lib/Release/${GLUI_ARCH}
			bin/Release/${GLUI_ARCH}
			Release
			msvc/lib
			DOC
			"GLUI library")
		find_library(GLUI_DEBUG_LIBRARY
			NAMES
			glui32d
			glui64d
			HINTS
			${GLUI_ROOT_PATHS}
			${OPENGL_LIBRARY_DIR}
			${OPENGL_INCLUDE_DIR}/../lib
			PATH_SUFFIXES
			lib64
			lib/Debug/${GLUI_ARCH}
			bin/Debug/${GLUI_ARCH}
			Debug
			msvc/lib
			DOC
			"GLUI debug library")
		# If we couldn't find the "d.lib" file, find a normal-name file in a Debug folder.
		find_library(GLUI_DEBUG_LIBRARY
			NAMES
			glui32
			glui64
			HINTS
			${GLUI_ROOT_PATHS}
			PATH_SUFFIXES
			lib64
			lib/Debug/${GLUI_ARCH}
			bin/Debug/${GLUI_ARCH}
			Debug
			DOC
			"GLUI debug library")
	else()
		find_library(GLUI_LIBRARY
			NAMES
			GLUI
			glui
			glui32
			PATHS
			${GLUI_ROOT_PATHS}
			/usr/openwin/lib
			HINTS
			${OPENGL_LIBRARY_DIR}
			${OPENGL_INCLUDE_DIR}/..
			PATH_SUFFIXES
			lib64
			lib
			DOC
			"GLUI library")

		if(APPLE)
			find_path(GLUI_INCLUDE_DIR
				GLUI/glui.h
				HINTS
				${OPENGL_INCLUDE_DIR}
				${GLUI_ROOT_PATHS}
				PATH_SUFFIXES
				include
				DOC
				"GLUI include directory")
		else()
			find_path(GLUI_INCLUDE_DIR
				GL/glui.h
				PATHS
				/usr
				/usr/openwin/share
				/usr/openwin
				/opt/graphics/OpenGL
				/opt/graphics/OpenGL/contrib/libglui
				${GLUI_ROOT_PATHS}
				PATH_SUFFIXES
				include
				DOC
				"GLUI include directory")
		endif()
	endif()
endif()

# handle the QUIETLY and REQUIRED arguments and set xxx_FOUND to TRUE if
# all listed variables are TRUE
include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(GLUI
	DEFAULT_MSG
	GLUI_INCLUDE_DIR
	GLUI_LIBRARY
	GLUT_FOUND
	OPENGL_FOUND)

if(GLUI_FOUND)
	if(WIN32 AND GLUI_DEBUG_LIBRARY)
		set(GLUI_LIBRARIES
			optimized
			${GLUI_LIBRARY}
			debug
			${GLUI_DEBUG_LIBRARY})
	else()
		set(GLUI_LIBRARIES
			${GLUI_LIBRARY})
	endif()
	set(GLUI_INCLUDE_DIRS
		${GLUI_INCLUDE_DIR})
endif()

if(GLUI_LIBRARY AND GLUI_INCLUDE_DIR)
	mark_as_advanced(GLUI_INCLUDE_DIR GLUI_LIBRARY GLUI_DEBUG_LIBRARY)
endif()
