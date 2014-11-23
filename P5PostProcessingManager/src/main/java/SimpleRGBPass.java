import processing.core.PGraphics;


public class SimpleRGBPass implements RenderPass {

	PostP5Manager p5Manager;
	
	@Override
	public void init(PostP5Manager p5Manager) {
		this.p5Manager = p5Manager;
	}

	@Override
	public void process(PGraphics src, PGraphics target) {
		target.beginDraw();
		p5Manager.scene.beginDraw();
		target.background(0);
		p5Manager.scene.drawModels(target);
		p5Manager.scene.endDraw();
		target.endDraw();
	}

	@Override
	public boolean needDepth() {
		return false;
	}
}
