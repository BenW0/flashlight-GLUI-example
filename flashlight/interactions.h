#ifndef INTERACTIONS_H
#define INTERACTIONS_H

// Include GLUI header file, with special magic code:
#define GLUI_NO_LIB_PRAGMA
#include <GL/glui.h>

#define W 600
#define H 600
#define DELTA 5 // pixel increment for arrow keys
#define TITLE_STRING "flashlight: distance image display app"

float2 loc1 = {W/2, H/2};
float2 loc2 = { W / 2, H / 2 };
float2 loc3 = { W / 2, H / 2 };
float size3 = 1.f;
bool dragMode = true; // mouse tracking mode


// GLUI Variables
GLUI *Glui;				// the mother GLUI object
int main_window_id;		// Window number of our main window so we can switch between the GUI window and the main window
int chk_kernel = 1;		// Do Kernel? check box live variable
float trans_loc2[2] = { W / 2, H / 2 };	// Translation live variable
int radio_size3 = 1;	// which option for size is selected?

GLUI_StaticText *x2readout;		// StaticText control so we can change the displayed values for Loc 2.		
GLUI_StaticText *y2readout;


void keyboard(unsigned char key, int x, int y) {
  if (key == 'a') dragMode = !dragMode; //toggle tracking mode
  if (key == 27) exit(0);
  glutPostRedisplay();
}

void mouseMove(int x, int y) {
  if (dragMode) return;
  loc1.x = (float)x;
  loc1.y = (float)y;
  // inform GLUI of the changes
  Glui->sync_live();
  glutPostRedisplay();
}

void mouseDrag(int x, int y) {
  if (!dragMode) return;
  loc1.x = (float)x;
  loc1.y = (float)y;
  // inform GLUI of the changes
  Glui->sync_live();
  glutPostRedisplay();
}

void handleSpecialKeypress(int key, int x, int y) {
  if (key == GLUT_KEY_LEFT)  loc1.x -= (float)DELTA;
  if (key == GLUT_KEY_RIGHT) loc1.x += (float)DELTA;
  if (key == GLUT_KEY_UP)    loc1.y -= (float)DELTA;
  if (key == GLUT_KEY_DOWN)  loc1.y += (float)DELTA;
  // inform GLUI of the changes
  Glui->sync_live();
  glutPostRedisplay();
}

void printInstructions() {
  printf("flashlight interactions\n");
  printf("a: toggle mouse tracking mode\n");
  printf("arrow keys: move ref location\n");
  printf("esc: close graphics window\n");
}



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


#endif