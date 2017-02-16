This repository contains the cuda for engineers template code for the flashlight app, modified with a simple GLUI front end, and modified to use CMake.

To run, you will need the NVIDIA CUDA Toolkit and an appropriate (CUDA-compatible) compiler for your OS.

[GLUI 2.36](http://glui.sourceforge.net/) source tweaked using the first change suggested [here](https://masdel.wordpress.com/2010/06/13/installing-glui-using-vc-on-windows/) is included, with a CMake build of its own.

Windows binaries (maybe only VS 2013 binaries), libraries, and headers for [FreeGLUT](http://www.transmissionzero.co.uk/software/freeglut-devel/), and [GLEW](glew.sourceforge.net) are also included for your convenience. Those files are covered by the license agreements of their respective projects.

##Installation and Compilation on Windows

###Build Tools
Building the included code requires [CMake](cmake.org) as well as a copy of Visual Studio and compatible NVIDIA CUDA Toolkit installation.

###Acquiring the Code
Download a ZIP of this source code from GitHub and unpack it somewhere convenient. If you wish to continue using git, you may git clone this repository,
but note that this is the cmake_build branch.

###Compiling GLUI: Automatically
By default, GLUI will be automatically built when CMake is run on the flashlight CMakeLists.txt (see the Building Flashlight section below).
If for some reason you wish to disable this behavior, follow the instructions in the next section to compile manually.

###Compiling GLUI: Manually
Run CMake-GUI and point the Source folder to flashlight-GLUI\libs\GLUI and the build folder to flashlight-GLUI\libs\GLUI\bin. Use the Configure and 
Generate buttons to build the solution for your compiler (I strongly recommend using x64 compilation). When it completes, open the new 
Visual Studio project and build it in both Release and Debug configurations. Now GLUI libraries are built for your platform and you may continue below.

To keep these libraries from being rebuilt when CMake is run on the Flashlight target, edit flashlight-GLUI-example\flashlight\CMakeLists.txt and change the line
`set(GLUI_DONT_BUILD FALSE)` to `set(GLUI_DONT_BUILD TRUE)`.

###Building Flashlight
Open CMake-GUI and point the Source folder to `flashlight-GLUI-example\flashlight\` and the build folder to `flashlight-GLUI-example\flashlight\bin`.
Use Configure and Generate buttons to generate a solution for the flashlight project. Unless you disabled automatic building of GLUI, the GLUI library
will be built the first time you click Configure. This will take a minute...be patient.

CMake should automatically find and build the GLUI libraries, and if on Windows it can retrieve FreeGLUT and GLEW from the included binaries as well.

Open the Visual Studio project that was created and build as normal.

##Installation and Compilation on Ubuntu

###Build Tools
install git - `sudo apt-get install git` (already on Ubuntu)

install cmake - `sudo apt-get install cmake` (already on Ubuntu) and `sudo apt-get install cmake-curses-gui`

###Libraries
`sudo apt-get install freeglut3-dev`

`sudo apt-get install libglew-dev`

`sudo apt-get install libxi-dev`

`sudo apt-get install libxmu-dev`

`sudo apt-get install libglew1.13`

###Code
* switch to the directory you want to work in
* clone this repository - `git clone https://github.com/BenW0/flashlight-GLUI-example.git`
* switch to cmake_build branch - `git checkout cmake_build`

###Compiling GLUI: Automatically
By default, GLUI will be automatically built when CMake is run on the flashlight CMakeLists.txt (see the Building Flashlight section below).
If for some reason you wish to disable this behavior, follow the instructions in the next section to compile manually.

###Compiling GLUI: Manually
GLUI isn't available on most platforms as a package, so we'll build it from source using a CMakeList I put together for it.

* Configure the glui library using CMake - `cd libs/glui && mkdir bin && ccmake ../`
 * Press "c" to configure. Hopefully no errors occur
 * Press "Enter" on the `CMAKE_BUILD_TYPE` field and type Release to specify a release build
 * Press "g" to generate the build file
* Build the project - `make`. Afterwards there should be a `libglui64.a` file in libs/glui/bin

Now we have the static library for GLUI and can use it to build the Flashlight application.

To keep these libraries from being rebuilt when CMake is run on the Flashlight target, edit flashlight-GLUI-example/flashlight/CMakeLists.txt and change the line
`set(GLUI_DONT_BUILD FALSE)` to `set(GLUI_DONT_BUILD TRUE)`.

###Building Flashlight
We will switch to the flashlight project folder, create a "bin" folder to hold our build instructions and binaries,
and use CMake to populate the build instructions.
~~~
cd flashlight-GLUI-example/flashlight
mkdir bin && cd bin
ccmake ../
~~~

The CMake screen should appear. Press "c" to configure. As before, we want to specify the build type. Press "Enter" on the `CMAKE_BUILD_TYPE` field and type Debug or Release, as you wish.

Press "g" to generate the makefile and exit.

Now we'll run make to compile the source into an executable, linked with GLEW, GLUT, and GLUI.

~~~
make
~~~

If it worked, an executable file should appear.

## Working with Eclipse
References: [official wiki](https://cmake.org/Wiki/Eclipse_CDT4_Generator), [tip I needed](http://stackoverflow.com/questions/11645575/importing-a-cmake-project-into-eclipse-cdt)

First, Eclipse doesn't like your CMake Project Name and Binary Name to be the same, so in the first few lines of CMakeLists.txt, change either the project() or set(EXE_NAME ...) calls so they are not the same.

Build a CMake project for Eclipse using

~~~
path/to/flashlight$ cmake -G "Eclipse CDT4 - Unix Makefiles" .
~~~

Note two things: First, Eclipse really wants its project files to be at the root of the source tree, so we *don't* use a bin subfolder this time. Second, the indication that this worked is the presence of *hidden* ".project" and ".cproject" files in the working directory; use `ls -a` to check whether they were created.

Now, open Eclipse and go to File->Import. You want General->Existing Projects Into Workspace. On the next screen, navigate to the source directory and *important* Uncheck the Copy Projects Into Workspace checkbox (otherwise, building within Eclipse fails).

This seems to work with Eclipse NSight Edition version 8.

##Errata
Tweaks by Ben Weiss; original source by Duane Storti and Mete Yyurtoglu.

[cudaoforengineers]: http://www.cudaforengineers.com
[cudatoolkit]: https://developer.nvidia.com/cuda-toolkit
