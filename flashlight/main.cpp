#include "kernel.h"
#include <stdio.h>
#include <stdlib.h>
#ifdef _WIN32
#define WINDOWS_LEAN_AND_MEAN
#define NOMINMAX
#include <windows.h>
#endif
#ifdef __APPLE__
#include <GLUT/glut.h>
#else
#include <GL/glew.h>
#include <GL/freeglut.h>
#endif
#include <cuda_runtime.h>
#include <cuda_gl_interop.h>

// Include GLUI header file, with special magic code:
#define GLUI_NO_LIB_PRAGMA
#include <GL/glui.h>

// Master GLUI class
// We need this object in interactions.h, so define it before
GLUI *Glui;				// the mother GLUI object

#include "interactions.h"

// GLUI Variables
int main_window_id;		// Window number of our main window so we can switch between the GUI window and the main window
int chk_kernel = 1;		// Do Kernel? check box live variable
float trans_loc2[2] = { W / 2, H / 2 };	// Translation live variable
int radio_size3 = 1;	// which option for size is selected?

GLUI_StaticText *x2readout;		// StaticText control so we can change the displayed values for Loc 2.		
GLUI_StaticText *y2readout;

// texture and pixel objects
GLuint pbo = 0; // OpenGL pixel buffer object
GLuint tex = 0; // OpenGL texture object
struct cudaGraphicsResource *cuda_pbo_resource;


// called when the XY translation control is changed
void transLoc2(int control_id)
{
	// set the center point location for the kernel call
	loc2.x = trans_loc2[0];
	loc2.y = W - trans_loc2[1];

	// update the StaticTexts
	char buf[300];
	sprintf(buf, "X Location: %.1f", loc2.x);
	x2readout->set_text(buf);

	sprintf(buf, "Y Location: %.1f", loc2.y);
	y2readout->set_text(buf);
}

// called when the radio button changes
void radioSize3(int control_id)
{
	size3 = 2.0f / (float)(radio_size3 + 1);
}

// Callback executed when the Reset button is clicked
void btnReset(int control_id)
{
	chk_kernel = 1;
	loc1.x = W / 2;
	loc1.y = H / 2;
	loc2.x = W / 2;
	loc2.y = H / 2;
	loc3.x = W / 2;
	loc3.y = H / 2;
	size3 = 1.f;

	// update GLUI variables
	trans_loc2[0] = loc2.x;
	trans_loc2[1] = loc2.y;
	radio_size3 = 1;

	// update the UI
	Glui->sync_live();
	//transLoc2(0);		// updates the static texts
}


// Initialize GLUI interface window
void initGLUI(void)
{
	// Start GLUI
	glutInitWindowPosition(W + 50, 0);
	Glui = GLUI_Master.create_glui("UI Window");

	// Add your controls here...
	// NOTE: the number 42 is arbitrary and means this argument isn't being used for our purposes.
	Glui->add_checkbox("Execute Kernel", &chk_kernel);

	GLUI_Panel *panel;
	panel = Glui->add_panel("Red Dot");

	GLUI_Spinner *spin;
	spin = Glui->add_spinner_to_panel(panel, "X Position", GLUI_SPINNER_FLOAT, &loc1.x);
	spin->set_float_limits(0.f, W);

	spin = Glui->add_spinner_to_panel(panel, "Y Position", GLUI_SPINNER_FLOAT, &loc1.y);
	spin->set_float_limits(0.f, H);

	panel = Glui->add_panel("Green Dot");
	Glui->add_translation_to_panel(panel, "2D Manipulator", GLUI_TRANSLATION_XY, trans_loc2, 42, transLoc2);

	Glui->add_column_to_panel(panel, 0);		// don't draw bar

	x2readout = Glui->add_statictext_to_panel(panel, "X Location: ");		// save these classes for later access
	y2readout = Glui->add_statictext_to_panel(panel, "Y Location: ");

	panel = Glui->add_panel("Blue Dot");
	Glui->add_translation_to_panel(panel, "X", GLUI_TRANSLATION_X, &loc3.x);
	Glui->add_column_to_panel(panel, 0);		// don't draw bar
	Glui->add_translation_to_panel(panel, "Y", GLUI_TRANSLATION_Y, &loc3.y);
	Glui->add_column_to_panel(panel, 0);

	GLUI_RadioGroup *group;
	group = Glui->add_radiogroup_to_panel(panel, &radio_size3, 42, radioSize3);		// don't show the panel
	Glui->add_radiobutton_to_group(group, "Small");
	Glui->add_radiobutton_to_group(group, "Medium");
	Glui->add_radiobutton_to_group(group, "Large");
	
	
	Glui->add_button("Reset", 42, btnReset);
	Glui->add_button("Quit", 0, exit);

	// Tell GLUI about the main window
	Glui->set_main_gfx_window(main_window_id);
}



void idle()
{
	// Make sure the main graphics window is active
	glutSetWindow(main_window_id);
	// Refresh screen if no input from user
	glutPostRedisplay();
}

void render() {
  uchar4 *d_out = 0;
  cudaGraphicsMapResources(1, &cuda_pbo_resource, 0);
  cudaGraphicsResourceGetMappedPointer((void **)&d_out, NULL,
                                       cuda_pbo_resource);
  if (1 == chk_kernel)
	kernelLauncher(d_out, W, H, loc1, loc2, loc3, size3);
  cudaGraphicsUnmapResources(1, &cuda_pbo_resource, 0);
}

void drawTexture() {
  glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, W, H, 0, GL_RGBA,
               GL_UNSIGNED_BYTE, NULL);
  glEnable(GL_TEXTURE_2D);
  glBegin(GL_QUADS);
  glTexCoord2f(0.0f, 0.0f); glVertex2f(0, 0);
  glTexCoord2f(0.0f, 1.0f); glVertex2f(0, H);
  glTexCoord2f(1.0f, 1.0f); glVertex2f(W, H);
  glTexCoord2f(1.0f, 0.0f); glVertex2f(W, 0);
  glEnd();
  glDisable(GL_TEXTURE_2D);
}

void display() {
  render();
  drawTexture();
  glutSwapBuffers();
}

void initGLUT(int *argc, char **argv) {
  glutInit(argc, argv);
  glutInitDisplayMode(GLUT_RGBA | GLUT_DOUBLE);
  glutInitWindowSize(W, H);
  main_window_id = glutCreateWindow(TITLE_STRING); 		// have to save the main window ID for later use
#ifndef __APPLE__
  glewInit();
#endif
}

void initPixelBuffer() {
  glGenBuffers(1, &pbo);
  glBindBuffer(GL_PIXEL_UNPACK_BUFFER, pbo);
  glBufferData(GL_PIXEL_UNPACK_BUFFER, 4 * W*H*sizeof(GLubyte), 0,
               GL_STREAM_DRAW);
  glGenTextures(1, &tex);
  glBindTexture(GL_TEXTURE_2D, tex);
  glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_NEAREST);
  cudaGraphicsGLRegisterBuffer(&cuda_pbo_resource, pbo,
  cudaGraphicsMapFlagsWriteDiscard);
}

void exitfunc() {
  if (pbo) {
    cudaGraphicsUnregisterResource(cuda_pbo_resource);
    glDeleteBuffers(1, &pbo);
    glDeleteTextures(1, &tex);
  }
}

int main(int argc, char** argv) {
  printInstructions();
  initGLUT(&argc, argv);

  // Initialize GLUI
  initGLUI();

  gluOrtho2D(0, W, H, 0);
  glutKeyboardFunc(keyboard);
  glutSpecialFunc(handleSpecialKeypress);
  glutPassiveMotionFunc(mouseMove);
  glutMotionFunc(mouseDrag);
  glutDisplayFunc(display);

  // DO NOT set the glutIdleFunc when using GLUI. Tell GLUI instead.
  //glutIdleFunc(idle);
  GLUI_Master.set_glutIdleFunc(idle);

  initPixelBuffer();
  glutMainLoop();
  atexit(exitfunc);
  return 0;
}