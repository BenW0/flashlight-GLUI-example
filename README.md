This repository contains the cuda for engineers template code for the flashlight app, modified with a simple GLUI front end, and modified to use CMake.

To run, you will need the NVIDIA CUDA Toolkit and an appropriate (CUDA-compatible) compiler for your OS.

GLUI 2.36 (http://glui.sourceforge.net/) source tweaked using the first change suggested [here][https://masdel.wordpress.com/2010/06/13/installing-glui-using-vc-on-windows/] is included, with a CMake build of its own.

Windows binaries (maybe only VS 2013 binaries), libraries, and headers for FreeGLUT (http://www.transmissionzero.co.uk/software/freeglut-devel/), and GLEW (glew.sourceforge.net) are also included for your convenience. Those files are covered by the license agreements of their respective projects.

##To Build
First, build GLUI, unless your platform has a package already present for it. Use CMake on (libs/glui/CMakeLists.txt) to create a build environment for GLUI in libs/glui/bin and compile. If on Windows, be sure to build both debug and release variants.

Next, create a build environment for flashlight using CMake (flashlight/CMakeLists.txt). It should automatically find the GLUI libraries, and if on Windows can retrieve FreeGLUT and GLEW from the included copies as well.

##Installation and Compilation on Ubuntu

###Build Tools
install git - `sudo apt-get install git` (already on Ubuntu)
install cmake - `sudo apt-get install cmake` (already on Ubuntu) and sudo apt-get install `cmake-curses-gui`

###Libraries
`sudo apt-get install freeglut3-dev`
`sudo apt-get install libglew-dev`
`sudo apt-get install libxi-dev`
`sudo apt-get install libxmu-dev`
`sudo apt-get install libglew1.13`

###Code
switch to the directory you want to work in
clone the repo - `git clone 
switch to cmake_build branch

###GLUI
*configure the glui library - cd libs/glui && mkdir bin && ccmake ../
**Press "c" to configure. Hopefully no errors occur
**Press "Enter" on the CMAKE_BUILD_TYPE field and type Release to specify a release build
**Press "g" to generate the build file
*Build the project - `make`. Afterwards there should be a libglui32.a file in libs/glui/bin

###Flashlight
cd flashlight-GLUI-example/flashlight
mkdir bin && cd bin


## Working with Eclipse
References: [official wiki](https://cmake.org/Wiki/Eclipse_CDT4_Generator), [tip I needed](http://stackoverflow.com/questions/11645575/importing-a-cmake-project-into-eclipse-cdt)

First, Eclipse doesn't like your CMake Project Name and Binary Name to be the same, so in the first few lines of CMakeLists.txt, change either the project() or set(EXE_NAME ...) calls so they are not the same.

Build a CMake project for Eclipse using

~~~
/.../flashlight$ cmake -G "Eclipse CDT4 - Unix Makefiles" .
~~~

Note two things: First, Eclipse really wants its project files to be at the root of the source tree, so we *don't* use a bin subfolder this time. Second, the indication that this worked is the presence of *hidden* ".project" and ".cproject" files in the working directory; use `ls -a` to check whether they were created.

Now, open Eclipse and go to File->Import. You want General->Existing Projects Into Workspace. On the next screen, navigate to the source directory and *important* Uncheck the Copy Projects Into Workspace checkbox (otherwise, building within Eclipse fails).

This seems to work with Eclipse NSight Edition version 8.

##Errata
Tweaks by Ben Weiss; original source by Duane Storti and Mete Yyurtoglu.

Original readme:

This repository contains the source code for the projects from [CUDA for Engineers][cudaoforengineers].

Linux/OS X Makefiles and Visual Studio 2013 project files are included with each project. In order to build the projects, [CUDA Toolkit 7.5][cudatoolkit] or above must be present on your system. 

[cudaoforengineers]: http://www.cudaforengineers.com
[cudatoolkit]: https://developer.nvidia.com/cuda-toolkit
