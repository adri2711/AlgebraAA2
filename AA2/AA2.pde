final int particleNum = 10;
Particle[] particle = new Particle[particleNum];

static float deltaTime = 0.001;
static float kFriction = -2;
static float kElastic = -1;
static PVector gravity = new PVector(0, -9.81);
static boolean eulerSolver = true;

void setup() {
  size(1080,720,P3D); 
  frameRate(30);
}

void draw() {
  background(255);
  lights();
  DrawAxis();
  
  ParticleLoop();
}

void DrawAxis() {
  push();
  strokeWeight(1);
  stroke(50);
  rotateX(radians(-35.26));
  rotateY(radians(45));
  translate(0,71,764);
  textSize(8);
  fill(0);
  line(1000,0,0,-1000,0,0);
  text("x",20,0,0);
  line(0,1000,0,0,-1000,0);
  text("y",0,20,0);
  line(0,0,1000,0,0,-1000); 
  text("z",0,0,20);

  pop();
}

void ParticleLoop() {
  
 
}
