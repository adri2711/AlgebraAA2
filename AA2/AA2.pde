int ROW_NUM = 10;
int COL_NUM = 15;
Particle[][] particle = new Particle[COL_NUM][ROW_NUM];
float SPACING = 20.0f;  //space between nodes
float TILT = 60f;      //tilt of the cloth

float DELTA_T = 0.05f;
float K_FRICTION = -3.0f;
float K_ELASTIC = -10.0f;
PVector GRAVITY = new PVector(0, -9.81);
boolean EULER_SOLVER = true;

void setup() {
  size(1080, 720, P3D); 
  frameRate(120);

  SetupParticles();
}

void draw() {
  background(0);
  lights();
  DrawAxis();

  ParticleLoop();
}


void SetupParticles() {
  for (int r = 0; r < ROW_NUM; r++) {

    for (int c = 0; c < COL_NUM; c++) {

      if ((r == 0 && c == 0) || r == 0 && c == COL_NUM-1) {
        particle[c][r] = new Particle(c, r, 1.0f, true, color(255));
      } else {
        particle[c][r] = new Particle(c, r, 1.0f, false, color(255));
      }
    }
  }
}


void ParticleLoop() {

  for (int c = 0; c < COL_NUM; c++) {

    for (int r = 0; r < ROW_NUM; r++) {

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

      //particle[c][r].Debug();
    }
  }


  for (int c = 0; c < COL_NUM; c++) {

    for (int r = 0; r < ROW_NUM; r++) {

      if (!particle[c][r].IsFixed()) {
        //Update velocity, acceleration and position
        particle[c][r].Update();
      }

      //Draw particle
      particle[c][r].Draw();
    }
  }
  //print("end of cycle\n");
}

void ShiftPerspective() {
  rotateX(radians(-35.26));
  rotateY(radians(45));
  translate(width/10, height/8, width/2);
}

void DrawAxis() {
  push();
  strokeWeight(1);
  stroke(255);
  ShiftPerspective();
  textSize(50);
  fill(255);
  line(1000, 0, 0, -1000, 0, 0);
  text("x", 1000, 0, 0);
  line(0, 1000, 0, 0, -1000, 0);
  text("y", 0, 1000, 0);
  line(0, 0, 1000, 0, 0, -1000); 
  text("z", 0, 0, 1000);

  pop();
}
