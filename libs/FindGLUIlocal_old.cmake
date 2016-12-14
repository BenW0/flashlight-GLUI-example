#.rst:
# FindGLUI
# --------
#
# Find the OpenGL User Interface (GLUI), which is probably in the "glui" subdirectory.
#
#
# Result Variables
# ^^^^^^^^^^^^^^^^
#
# This module defines the following variables:
#
# ::
#
#   GLUI_INCLUDE_DIRS - include directories for GLUI
#   GLUI_LIBRARIES - libraries to link against GLUI
#   GLUE_DEBUG_LIBRARIES - libraries to link against GLUI in debug mode
#   GLUI_FOUND - true if GLUI has been found and can be used

# TODO:
#  Check that this works on Linux, both locally compiled and using packages.

#=============================================================================
# Copyright 2012 Benjamin Eikel
# Copyright 2016 Ryan Pavlik
# Copyright 2016 Ben Weiss
#
# Adapted from FindGLEW.
#
# Distributed under the OSI-approved BSD License (the "License");
# see below.
#
# This software is distributed WITHOUT ANY WARRANTY; without even the
# implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
# See the License for more information.
#=============================================================================
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions
# are met:
#
# * Redistributions of source code must retain the above copyright
#   notice, this list of conditions and the following disclaimer.
#
# * Redistributions in binary form must reproduce the above copyright
#   notice, this list of conditions and the following disclaimer in the
#   documentation and/or other materials provided with the distribution.
#
# * Neither the names of Kitware, Inc., the Insight Software Consortium,
#   nor the names of their contributors may be used to endorse or promote
#   products derived from this software without specific prior written
#   permission.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
# "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
# LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
# A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
# HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
# SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
# LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
# DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
# THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
# (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
# OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
#=============================================================================

find_path(GLUI_INCLUDE_DIR GL/glui.h ${CMAKE_CURRENT_LIST_DIR}/glui/bin/include)
if(WIN32)
  # TODO how to make this exclude arm?
  if(CMAKE_SIZEOF_VOID_P EQUAL 4)
    set(GLUI_ARCH Win32)
  else()
    set(GLUI_ARCH x64)
  endif()
  set(GLUI_EXTRA_SUFFIXES lib/Release/${GLUI_ARCH} bin/Release/${GLUI_ARCH} Release msvc/lib)
	set(GLUI_DEBUG_SUFFIXES lib/Debug/${GLUI_ARCH} bin/Debug/${GLUI_ARCH} Debug msvc/lib)
  
  if(GLUI_INCLUDE_DIR)
    get_filename_component(GLUI_LIB_ROOT_CANDIDATE "${GLUI_INCLUDE_DIR}/.." ABSOLUTE)
  endif()

endif()


find_library(GLUI_LIBRARY
  NAMES GLUI glui32 glui64
  PATH_SUFFIXES lib64 ${GLUI_EXTRA_SUFFIXES}
  HINTS "${GLUI_LIB_ROOT_CANDIDATE}")

find_library(GLUI_DEBUG_LIBRARY
	NAMES GLUId glui32d glui64d
	PATH_SUFFIXES lib64 ${GLUI_DEBUG_SUFFIXES}
	HINTS "${GLUI_LIB_ROOT_CANDIDATE}")

# TODO: Eventually, this should support DLL builds too...
#if(WIN32 AND GLUI_LIBRARY AND NOT GLUI_LIBRARY MATCHES ".*s.lib")
#  get_filename_component(GLUI_LIB_DIR "${GLUI_LIBRARY}" DIRECTORY)
#  get_filename_component(GLUI_BIN_ROOT_CANDIDATE1 "${GLUI_LIB_DIR}/.." ABSOLUTE)
#  get_filename_component(GLUI_BIN_ROOT_CANDIDATE2 "${GLUI_LIB_DIR}/../../.." ABSOLUTE)
#  find_file(GLUI_RUNTIME_LIBRARY
#    NAMES glui32.dll
#    PATH_SUFFIXES bin ${GLUI_EXTRA_SUFFIXES}
#    HINTS
#    "${GLUI_BIN_ROOT_CANDIDATE1}"
#    "${GLUI_BIN_ROOT_CANDIDATE2}")
#endif()

set(GLUI_INCLUDE_DIRS ${GLUI_INCLUDE_DIR})
set(GLUI_LIBRARIES ${GLUI_LIBRARY})
set(GLUI_DEBUG_LIBRARIES ${GLUI_DEBUG_LIBRARY})

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(GLUI
                                  REQUIRED_VARS GLUI_INCLUDE_DIR GLUI_LIBRARY)

# Add a warning if we couldn't find the debug library
if(NOT EXISTS GLUI_DEBUG_LIBRARY)
	message(WARNING "Could not find GLUI Debug library.")
endif()

# TODO: Add support for imported targets...
# if(GLUI_FOUND AND NOT TARGET GLUI::GLUI)
  # if(WIN32 AND GLEW_LIBRARY MATCHES ".*s.lib")
    # # Windows, known static library.
    # add_library(GLEW::GLEW STATIC IMPORTED)
    # set_target_properties(GLEW::GLEW PROPERTIES
      # IMPORTED_LOCATION "${GLEW_LIBRARY}"
      # PROPERTY INTERFACE_COMPILE_DEFINITIONS GLEW_STATIC)

  # elseif(WIN32 AND GLEW_RUNTIME_LIBRARY)
    # # Windows, known dynamic library and we have both pieces
    # # TODO might be different for mingw
    # add_library(GLEW::GLEW SHARED IMPORTED)
    # set_target_properties(GLEW::GLEW PROPERTIES
      # IMPORTED_LOCATION "${GLEW_RUNTIME_LIBRARY}"
      # IMPORTED_IMPLIB "${GLEW_LIBRARY}")
  # else()

    # # Anything else - previous behavior.
    # add_library(GLEW::GLEW UNKNOWN IMPORTED)
    # set_target_properties(GLEW::GLEW PROPERTIES
      # IMPORTED_LOCATION "${GLEW_LIBRARY}")
  # endif()

  # set_target_properties(GLEW::GLEW PROPERTIES
    # INTERFACE_INCLUDE_DIRECTORIES "${GLEW_INCLUDE_DIRS}")

# endif()

mark_as_advanced(GLUI_INCLUDE_DIR GLUI_LIBRARY)# GLEW_RUNTIME_LIBRARY)
