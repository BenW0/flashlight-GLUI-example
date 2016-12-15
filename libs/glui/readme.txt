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

Note that the source in glui-2.36 differs
slightly from the version on SourceForge. Specifically,
changes suggested [here][https://masdel.wordpress.com/2010/06/13/installing-glui-using-vc-on-windows/] 
have been made.