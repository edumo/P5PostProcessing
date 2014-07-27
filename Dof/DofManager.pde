public class DofManager {

  PShader depthShader;
  PShader dof;
  PGraphics src, dest;
  PGraphics depth;

  float maxDepth = 255;
  float focus;
  float maxBlur;
  float aperture;

  public void setup(PApplet parent,  int w, int h) {
  
    depthShader = parent.loadShader("dof/colorfrag.glsl",
        "dof/colorvert.glsl");
    depthShader.set("maxDepth", maxDepth);

    dof = parent.loadShader("dof/dof.glsl");
    dof.set("aspect", width / (float) height);

    src = parent.createGraphics(w, h, PApplet.OPENGL);
    dest = parent.createGraphics(w, h, PApplet.OPENGL);
    depth = parent.createGraphics(w, h, PApplet.OPENGL);
    depth.smooth(8);
    depth.shader(depthShader);
  }

  public PShader getDepthShader() {
    return depthShader;
  }

  public void setDepthShader(PShader depthShader) {
    this.depthShader = depthShader;
  }

  public PShader getDof() {
    return dof;
  }

  public void setDof(PShader dof) {
    this.dof = dof;
  }

  public PGraphics getSrc() {
    return src;
  }

  public void setSrc(PGraphics src) {
    this.src = src;
  }

  public PGraphics getDest() {
    return dest;
  }

  public void setDest(PGraphics dest) {
    this.dest = dest;
  }

  public PGraphics getDepth() {
    return depth;
  }

  public void setDepth(PGraphics depth) {
    this.depth = depth;
  }

  public float getMaxDepth() {
    return maxDepth;
  }

  public void setMaxDepth(float maxDepth) {
    this.maxDepth = maxDepth;
  }

  public float getFocus() {
    return focus;
  }

  public void setFocus(float focus) {
    this.focus = focus;
  }
  
  public float getMaxBlur() {
    return maxBlur;
  }

  public void setMaxBlur(float maxBlur) {
    this.maxBlur = maxBlur;
  }
  
  public float getAperture() {
    return aperture;
  }

  public void setAperture(float aperture) {
    this.aperture = aperture;
  }
  
 

  public void draw() {
    
    depthShader.set("maxDepth", maxDepth); 
    
    dest.beginDraw();
    dof.set("tDepth", depth);
    dest.shader(dof);

    dof.set("maxBlur", maxBlur);
    dof.set("focus", focus);
    dof.set("aperture", aperture);

    dest.image(src, 0, 0);
    dest.endDraw();
  }

}

