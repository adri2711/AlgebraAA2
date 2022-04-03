int ROW_NUM = 10;
int COL_NUM = 10;
Particle[][] particle = new Particle[ROW_NUM][COL_NUM];
int SPACING = 30;

float DELTA_T = 0.001;
float K_FRICTION = -2;
float K_ELASTIC = -1;
PVector GRAVITY = new PVector(0, -9.81);
boolean EULER_SOLVER = true;

void setup() {
  size(1080, 720, P3D); 
  frameRate(30);
  
  SetupParticles();
}

void draw() {
  background(0);
  lights();
//  DrawAxis();

  ParticleLoop();
}


void SetupParticles() {
  for (int r = 0; r < ROW_NUM; r++) {

    for (int c = 0; c < COL_NUM; c++) {
      
      if ((r == 0 && c == 0) || r == 0 && c == COL_NUM-1) {
        particle[c][r] = new Particle(c, r, 1.0f, true, color(255));
      }
      else {
        particle[c][r] = new Particle(c, r, 1.0f, false, color(255));        
      }
    }
  }
}


void ParticleLoop() {

  for (int r = 0; r < ROW_NUM; r++) {

    for (int c = 0; c < COL_NUM; c++) {

      //Init force to 0
      particle[c][r].SetForce(new PVector(0, 0, 0));

      //Forces below
      if (r < ROW_NUM - 1) {
        particle[c][r].CalculateAdjacentForce(particle[c][r+1]);
      }     
      //Forces above
      if (r > 0) {
        particle[c][r].CalculateAdjacentForce(particle[c][r-1]);
      }    
      //Forces right
      if (c < COL_NUM - 1) {
        particle[c][r].CalculateAdjacentForce(particle[c+1][r]);
      }    
      //Forces left
      if (c > 0) {
        particle[c][r].CalculateAdjacentForce(particle[c-1][r]);
      }

      //Forces bottom right
      if (c < COL_NUM - 1 && r < ROW_NUM - 1) {
        particle[c][r].CalculateAdjacentForce(particle[c+1][r+1]);
      }     
      //Forces top right
      if (c < COL_NUM - 1 && r > 0) {
        particle[c][r].CalculateAdjacentForce(particle[c+1][r-1]);
      }    
      //Forces bottom left
      if (c > 0 && r < ROW_NUM - 1) {
        particle[c][r].CalculateAdjacentForce(particle[c-1][r+1]);
      }    
      //Forces top left
      if (c > 0 && r > 0) {
        particle[c][r].CalculateAdjacentForce(particle[c-1][r-1]);
      }

      //Gravity
      particle[c][r].CalculateGravity();

      //Update velocity, acceleration and position
      particle[c][r].Update();
      
      //Draw particle
      particle[c][r].Draw();
    }
  }
}

void DrawAxis() {
  push();
  strokeWeight(1);
  stroke(255);
  rotateX(radians(-35.26));
  rotateY(radians(45));
  translate(0, 71, 764);
  textSize(8);
  fill(255);
  line(1000, 0, 0, -1000, 0, 0);
  text("x", 20, 0, 0);
  line(0, 1000, 0, 0, -1000, 0);
  text("y", 0, 20, 0);
  line(0, 0, 1000, 0, 0, -1000); 
  text("z", 0, 0, 20);

  pop();
}
