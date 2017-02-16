
# Minimum version of CMake required.
cmake_minimum_required(VERSION 2.8)

# Set the name of your project. Change the next two lines to match your current project name.
project(GLUI)
set(LIB_NAME glui)

set(GLUI_SRC_DIR "${CMAKE_CURRENT_SOURCE_DIR}/glui-2.36")

# Check for 32-bit build...user may not want this
if(WIN32 AND CMAKE_SIZEOF_VOID_P EQUAL 4)
	message(WARNING "You are creating a 32-bit project. You probably want x64 on Windows. Just FYI...")
  set(LIB_NAME ${LIB_NAME}32)
else()
  set(LIB_NAME ${LIB_NAME}64)
endif()

# Check that the destination directory is ./bin...
get_filename_component(BINARY_DIR_SHOULDBE ${CMAKE_CURRENT_SOURCE_DIR}/bin ABSOLUTE)
if(NOT CMAKE_BINARY_DIR STREQUAL BINARY_DIR_SHOULDBE)
	message(WARNING "Build directory is not ./bin. This will keep FindGsLUI from working in other projects.")
endif()

# Include some scripts we will need to configure CUDA and find local copies of GLUT
set(MY_CMAKE_SCRIPTS ${CMAKE_CURRENT_SOURCE_DIR}/..)
list(APPEND CMAKE_MODULE_PATH "${MY_CMAKE_SCRIPTS}")


## Try to find the OpenGL, GLUT and GLEW Libraries. 
# First use the default CMake finder in case they are
# installed on the system, then fall back on local copies (Windows only)
find_package(OpenGL REQUIRED)
find_package(GLUT QUIET)
if(NOT GLUT_FOUND)
	find_package(GLUTlocal REQUIRED)
endif()

## Collect all the sources in the src folder.
# Note that header files don't *need* to be included
# here, but if we don't, they will not show up in
# the Visual Studio explorer.
file(GLOB SOURCES 
	${GLUI_SRC_DIR}/src/*.cpp
	${GLUI_SRC_DIR}/src/*.c 
	${GLUI_SRC_DIR}/src/*.h 
	${GLUI_SRC_DIR}/src/*.hpp)

# Create the executable from all available sources
set(CMAKE_DEBUG_POSTFIX d)
add_library(${LIB_NAME} STATIC ${SOURCES})

# Add  some glui declares
target_compile_definitions(${LIB_NAME} PRIVATE GLUI_BUILDING_LIB GLUI_NO_LIB_PRAGMA)

# include the local "include" folder
include_directories("${GLUI_SRC_DIR}/src/include")

# link with OpenGL
include_directories(${OPENGL_INCLUDE_DIR})
target_link_libraries(${LIB_NAME} ${OPENGL_LIBRARIES})

# link with GLUT
include_directories(${GLUT_INCLUDE_DIR})
target_link_libraries(${LIB_NAME} ${GLUT_LIBRARIES}) 

# Copy the include folder over to the output.
file(COPY "${GLUI_SRC_DIR}/src/include" DESTINATION "${CMAKE_BINARY_DIR}")