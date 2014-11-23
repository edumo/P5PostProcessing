import processing.core.PGraphics;

public interface RenderPass {

	public abstract void init(PostP5Manager p5Manager);

	public abstract void process(PGraphics src, PGraphics target);

	public abstract boolean needDepth();

}