import processing.core.*;
import processing.data.*;
import processing.event.*;
import processing.opengl.*;
import remixlab.proscene.*;

import java.util.HashMap;
import java.util.ArrayList;
import java.io.File;
import java.io.BufferedReader;
import java.io.PrintWriter;
import java.io.InputStream;
import java.io.OutputStream;
import java.io.IOException;

public class DOF extends PApplet {

	Scene scene;
	int cols[];
	float posns[];
	InteractiveModelFrame[] models;
	int mode = 2;

	PostP5Manager postP5Manager;

	RenderPass effectDOF;

	public void setup() {
		size(350, 350, P3D);
		colorMode(HSB, 255);
		cols = new int[100];
		posns = new float[300];

		for (int i = 0; i < 100; i++) {
			posns[3 * i] = random(-1000, 1000);
			posns[3 * i + 1] = random(-1000, 1000);
			posns[3 * i + 2] = random(-1000, 1000);
			cols[i] = color(random(255), random(255), random(255));
		}

		postP5Manager = new PostP5Manager();
		
		PGraphics srcPGraphics = createGraphics(width, height, PApplet.OPENGL);

		scene = new Scene(this, srcPGraphics);
		//first problem, scene has a dependency with Pgraphics, 
		//postp5 has a dependency with scene and Pgraphics
		//maybe the solution is moving this constructors to postp5manager.init
		//but better if the Scene construction is here,
		postP5Manager.init(this, scene, srcPGraphics);

		models = new InteractiveModelFrame[100];

		for (int i = 0; i < models.length; i++) {
			models[i] = new InteractiveModelFrame(scene, boxShape());
			models[i].translate(posns[3 * i], posns[3 * i + 1],
					posns[3 * i + 2]);
			models[i].shape().setFill(cols[i]);
		}

		scene.setRadius(1000);
		scene.showAll();

		postP5Manager.add(new SimpleRGBPass());
		postP5Manager.add(new EffectDOF());

		frameRate(1000);
	}

	public void draw() {

		for (int i = 0; i < models.length; i++)
			models[i].shape().setFill(
					scene.grabsAnyAgentInput(models[i]) ? color(0, 255, 255)
							: cols[i]);

		image(postP5Manager.process(), 0, 0);
	}

	public PShape boxShape() {
		return createShape(BOX, 60);
	}

	static public void main(String[] passedArgs) {
		String[] appletArgs = new String[] { "DOF" };
		if (passedArgs != null) {
			PApplet.main(concat(appletArgs, passedArgs));
		} else {
			PApplet.main(appletArgs);
		}
	}
}
