This repository contains the cuda for engineers template code for the flashlight app, modified with a simple GLUI front end, and modified to use CMake.

To run, you will need the NVIDIA CUDA Toolkit and an appropriate (CUDA-compatible) compiler for your OS.

GLUI 2.36 (http://glui.sourceforge.net/) source tweaked using the first change suggested [here][https://masdel.wordpress.com/2010/06/13/installing-glui-using-vc-on-windows/] is included, with a CMake build of its own.

Windows binaries (maybe only VS 2013 binaries), libraries, and headers for FreeGLUT (http://www.transmissionzero.co.uk/software/freeglut-devel/), and GLEW (glew.sourceforge.net) are also included for your convenience. Those files are covered by the license agreements of their respective projects.

##To Build
First, build GLUI, unless your platform has a package already present for it. Use CMake on (libs/glui/CMakeLists.txt) to create a build environment for GLUI in libs/glui/bin and compile. If on Windows, be sure to build both debug and release variants.

Next, create a build environment for flashlight using CMake (flashlight/CMakeLists.txt). It should automatically find the GLUI libraries, and if on Windows can retrieve FreeGLUT and GLEW from the included copies as well.

##Errata
Tweaks by Ben Weiss; original source by Duane Storti and Mete Yyurtoglu.

Original readme:

This repository contains the source code for the projects from [CUDA for Engineers][cudaoforengineers].

Linux/OS X Makefiles and Visual Studio 2013 project files are included with each project. In order to build the projects, [CUDA Toolkit 7.5][cudatoolkit] or above must be present on your system. 

[cudaoforengineers]: http://www.cudaforengineers.com
[cudatoolkit]: https://developer.nvidia.com/cuda-toolkit
