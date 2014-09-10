PShader depthShader, depthShaderunpack;
float angle = 0.0;
PGraphics canvas1;
PGraphics canvas2;

boolean depthRender = true;

void setup() {

  // Set screen size and renderer
  size(600, 480, P3D);
  // Load shader
  depthShader = loadShader("frag.glsl", "vert.glsl");
  depthShaderunpack = loadShader("unpack.glsl");
  //depthShader.set("near", 40.0); // Standard: 0.0
  //depthShader.set("far", 60.0); // Standard: 100.0
  //depthShader.set("nearColor", 1.0, 0.0, 0.0, 1.0); // Standard: white
  //depthShader.set("farColor", 0.0, 0.0, 1.0, 1.0); // Standard: black

  canvas1 = createGraphics(width, height, OPENGL);
  canvas2 = createGraphics(width, height, OPENGL);
}


void draw() {

  // Fill background and set camera
  canvas1.beginDraw();
  canvas1.noStroke();
  canvas1.background(#000000);
  canvas1.camera(0.0, 0.0, 50.0, 0.0, 0.0, 0.0, 0.0, 1.0, 0.0);

  // Bind shader
  canvas1.shader(depthShader);

  // Calculate angle
  angle += 0.01;

  // Render "sky"-cube
  canvas1.pushMatrix();
  canvas1.rotate(angle, 0.0, 1.0, 0.0);
  canvas1.box(100.0);
  canvas1.popMatrix();

  // Render cubes
  canvas1.pushMatrix();
  canvas1.translate(-30.0, 20.0, -50.0);
  canvas1.rotate(angle, 1.0, 1.0, 1.0);
  canvas1.box(25.0);
  canvas1. popMatrix();
  canvas1. pushMatrix();
  canvas1.translate(30.0, -20.0, -50.0);
  canvas1.rotate(angle, 1.0, 1.0, 1.0);
  canvas1.box(25.0);
  canvas1.popMatrix();

  // Render spheres
  canvas1. pushMatrix();
  canvas1.translate(-30.0, -20.0, -50.0);
  canvas1.rotate(angle, 1.0, 1.0, 1.0);
  canvas1.sphere(20.0);
  canvas1. popMatrix();
  canvas1. pushMatrix();
  canvas1. translate(30.0, 20.0, -50.0);
  canvas1. rotate(angle, 1.0, 1.0, 1.0);
  canvas1.sphere(20.0);
  canvas1. popMatrix();

  canvas1.endDraw();

  canvas2.beginDraw();
  canvas2.shader(depthShaderunpack );
  canvas2.image(canvas1, 0, 0);
  canvas2.endDraw();

  if (depthRender)
    image(canvas2, 0, 0);
  else
    image(canvas1, 0, 0);
}

void keyPressed() {
  depthRender = !depthRender;
}
