import processing.core.PApplet;
import processing.core.PGraphics;
import processing.opengl.PShader;

public class EffectDOF implements RenderPass {

	PShader dofShader;

	PostP5Manager p5Manager;

	/*
	 * (non-Javadoc)
	 * 
	 * @see RenderPass#init(PostP5Manager)
	 */
	@Override
	public void init(PostP5Manager p5Manager) {

		this.p5Manager = p5Manager;

		dofShader = p5Manager.parent.loadShader("dof.glsl");
		dofShader.set("aspect", p5Manager.parent.width
				/ (float) p5Manager.parent.height);
		dofShader.set("maxBlur", 0.015f);
		dofShader.set("aperture", 0.02f);

	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see RenderPass#process(processing.core.PGraphics,
	 * processing.core.PGraphics)
	 */
	@Override
	public void process(PGraphics src, PGraphics target) {
		// 3. Draw destination buffer
		target.beginDraw();
		target.shader(dofShader);

		// target.background(0);
		dofShader.set("focus", PApplet.map(p5Manager.parent.mouseX, 0,
				p5Manager.parent.width, -0.5f, 1.5f));
		dofShader.set("tDepth", p5Manager.getDepthPGraphics());

		target.image(src, 0, 0);
		target.endDraw();

	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see RenderPass#needDepth()
	 */
	public boolean needDepth() {
		return true;
	}
}
