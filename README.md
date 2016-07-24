This repository contains the cuda for engineers template code for the flashlight app, modified with a simple GLUI front end.

To run, you will need the NVIDIA CUDA Toolkit and Visual Studio 2013. Compilation on linux and OS X is also possible with the provided makefile.

I built GLUI from source using the first change suggested [here][https://masdel.wordpress.com/2010/06/13/installing-glui-using-vc-on-windows/] using Visual Studio 2013.

Binaries, libraries, and headers for FreeGLUT (http://www.transmissionzero.co.uk/software/freeglut-devel/), and GLUI (http://glui.sourceforge.net/) are also included for your convenience. Those files are covered by the license agreements of their respective projects.

Tweaks by Ben Weiss; original source by Duane Storti and Mete Yyurtoglu.

Original readme:

This repository contains the source code for the projects from [CUDA for Engineers][cudaoforengineers].

Linux/OS X Makefiles and Visual Studio 2013 project files are included with each project. In order to build the projects, [CUDA Toolkit 7.5][cudatoolkit] or above must be present on your system. 

[cudaoforengineers]: http://www.cudaforengineers.com
[cudatoolkit]: https://developer.nvidia.com/cuda-toolkit
