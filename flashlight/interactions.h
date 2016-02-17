#ifndef INTERACTIONS_H
#define INTERACTIONS_H

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

#endif