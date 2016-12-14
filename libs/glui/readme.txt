This folder contains the source code for glui 
(in directory glui-2.36) along with a CMakeLists 
file which contains the appropriate build rules.

To use glui, use CMake to generate build files
for the build system of your choice in ./bin
(it will warn you if you aren't in the right folder),
then include GLUIlocal.cmake in the parent folder
in your project. It should be able to find the 
compilation results and include them in your new
project.

Note that the source in glui-2.36 seems to differ
slightly from the version on SourceForge. Specifically,
there is a block of template code moved outside a class
in src/include/GL/glui.h which keeps MSVC happy. I didn
not make this change; I must have found a different source
a few years ago...