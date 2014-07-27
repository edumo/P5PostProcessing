/**
  
  DOF example based on https://github.com/neilmendoza/ofxPostProcessing
  
  Move your mouse in X to change de focus distance
  
**/

import remixlab.bias.event.*;
import remixlab.bias.event.shortcut.*;
import remixlab.bias.agent.profile.*;
import remixlab.bias.agent.*;
import remixlab.dandelion.agent.*;
import remixlab.proscene.*;
import remixlab.dandelion.core.*;
import remixlab.dandelion.constraint.*;
import remixlab.fpstiming.*;
import remixlab.util.*;
import remixlab.dandelion.geom.*;
import remixlab.bias.core.*;
  
  DofManager dof;

  Scene scene;
  Scene sceneDepth;
  
  boolean renderDepth = false;

  public void setup() {
    size(800, 400, P2D);
    dof = new DofManager();
    
    dof.setup(this, width, height);

    scene = new Scene(this, dof.getSrc());
    scene.setRadius(1000);
    sceneDepth = new Scene(this, dof.getDepth());
    sceneDepth.setRadius(1000);
    sceneDepth.setCamera(scene.camera());
    sceneDepth.disableMouseAgent();
    sceneDepth.disableKeyboardAgent();

   }

  public void draw() {
    background(0);

    drawGeometry(dof.getSrc(), scene, true);
    drawGeometry(dof.getDepth(), sceneDepth, false);

    dof.draw();

    dof.setMaxDepth(2000);
    dof.setFocus(map(mouseX, 0, width, -0.5f, 1.5f));
    dof.setMaxBlur(0.015);
    dof.setAperture( 0.02f);
    

    if(!renderDepth)
      image(dof.getDest(), 0, 0);
    else
      image(dof.getDepth(), 0, 0);
    //image(dof.getSrc(), width / 2, 0);
  }

  private void drawGeometry(PGraphics pg, Scene scene, boolean lights) {
    pg.beginDraw();
    scene.beginDraw();
    //
    pg.background(0);
    pg.fill(150);
    pg.noStroke();
    if (lights)
      pg.lights();
    pg.pushMatrix();
    for (int i = 0; i < 20; i++) {
      pg.translate(10, 10, 100);
      pg.sphere(50);
    }
    pg.popMatrix();
    scene.endDraw();
    pg.endDraw();
  }
  
  void keyPressed(){
   renderDepth = !renderDepth; 
  }

