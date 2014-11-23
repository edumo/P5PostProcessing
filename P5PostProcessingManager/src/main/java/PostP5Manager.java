import java.util.ArrayList;
import java.util.List;

import processing.core.PApplet;
import processing.core.PGraphics;
import processing.core.PImage;
import processing.core.PVector;
import processing.opengl.PShader;
import remixlab.proscene.Scene;

public class PostP5Manager {

	PApplet parent;

	PShader depthShader;
	PGraphics depthPGraphics;

	PGraphics[] pingPong;

	Scene scene;

	List<RenderPass> effects = new ArrayList<RenderPass>();

	public void init(PApplet parent, Scene scene, PGraphics srcPGraphics) {

		pingPong = new PGraphics[2];

		this.parent = parent;
		pingPong[0] = srcPGraphics;
		PGraphics pongPgraphics = parent.createGraphics(srcPGraphics.width,
				srcPGraphics.height, PApplet.OPENGL);
		pingPong[1] = pongPgraphics;

		this.scene = scene;

		depthShader = parent.loadShader("depth.glsl");
		depthShader.set("maxDepth", scene.radius() * 2);
		depthPGraphics = parent.createGraphics(parent.width, parent.height,
				PApplet.P3D);
		depthPGraphics.shader(depthShader);

	}

	public PGraphics getDepthPGraphics() {
		return depthPGraphics;
	}

	protected PGraphics updateDepth() {

		// 2. Draw into depth buffer
		depthPGraphics.beginDraw();
		depthPGraphics.background(0);
		scene.drawModels(depthPGraphics);
		depthPGraphics.endDraw();

		return depthPGraphics;
	}

	public void add(RenderPass renderPass) {
		renderPass.init(this);
		effects.add(renderPass);
	}

	public PGraphics process() {

		boolean writeFirst = false;
		boolean depthDone = false;
		for (RenderPass effect : effects) {

			if (effect.needDepth() && !depthDone) {
				updateDepth();
				depthDone = true;
			}

			if (writeFirst)
				effect.process(pingPong[0], pingPong[1]);
			else
				effect.process(pingPong[1], pingPong[0]);

			writeFirst = !writeFirst;
		}

		if (writeFirst)
			return pingPong[0];
		else
			return pingPong[1];

	}
}
