public class GlowManager {

  PShader blur, glowShader;
  PGraphics pass1, pass2;
  PGraphics glowCanvas;

  float ratioGlow;

  public void initGlow(PApplet parent, PGraphics graphics, float ratioGlow) {

    blur = parent.loadShader("glow/blur.glsl");
    blur.set("blurSize", 19);
    blur.set("sigma", 7.0f);

    this.ratioGlow = ratioGlow;

    glowShader = parent.loadShader("glow/glow.glsl");

    pass1 = parent.createGraphics((int) (graphics.width * ratioGlow),
        (int) (graphics.height * ratioGlow), PApplet.OPENGL);
    pass1.noSmooth();

    pass2 = parent.createGraphics((int) (graphics.width * ratioGlow),
        (int) (graphics.height * ratioGlow), PApplet.OPENGL);
    pass2.noSmooth();

    glowCanvas = parent.createGraphics(graphics.width, graphics.height,
        PApplet.OPENGL);
  }

  public PGraphics dowGlow(PGraphics canvas) {


    // Applying the blur shader along the vertical direction
    blur.set("horizontalPass", 0);
    pass1.beginDraw();
    pass1.image(canvas, 0, 0, pass1.width, pass1.height);
    pass1.filter(blur);
    pass1.endDraw();

    // Applying the blur shader along the horizontal direction
    blur.set("horizontalPass", 1);
    pass2.beginDraw();
    pass2.image(pass1, 0, 0);
    pass2.filter(blur);
    pass2.endDraw();

    // glowShader.set("Sample0", src);
    glowShader.set("Sample1", canvas);

    glowCanvas.beginDraw();
    glowCanvas.background(0);
    glowCanvas.image(pass2, 0, 0, glowCanvas.width, glowCanvas.height);
    glowCanvas.shader(glowShader);
    glowCanvas.endDraw();

    return glowCanvas;
  }
}
