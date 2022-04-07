int ROW_NUM = 30;
int COL_NUM = 30;
Particle[][] particle = new Particle[COL_NUM][ROW_NUM];
float SPACING = 10.0f;  //space between nodes
float TILT = 0.75f;      //tilt of the cloth
float MASS = 1f;

float DELTA_T_EULER = 0.05f;
float DELTA_T_VERLET = 0.03f;
float K_FRICTION = -2.0f;
float K_ELASTIC = -50.0f;
float K_STRETCH = 1.0f;
float K_SHEAR = 0.6f;
PVector GRAVITY = new PVector(0, -9.81);
boolean EULER_SOLVER = true;

void setup() {
  size(1080, 720, P3D); 
  frameRate(60);

  //ChangeSolverMode();
  SetupParticles();
}

void draw() {
  background(0);
  lights();
  //DrawAxis();

  ParticleLoop();
}

void ChangeSolverMode() {
  EULER_SOLVER = !EULER_SOLVER;
  if (!EULER_SOLVER) { 
    K_FRICTION *= 100;
    K_ELASTIC *= 5;
  }
  else {
    K_FRICTION /= 100;
    K_ELASTIC /= 5;
  }
}

void SetupParticles() {
  for (int r = 0; r < ROW_NUM; r++) {

    for (int c = 0; c < COL_NUM; c++) {

      if ((r == 0 && c == 0) || r == 0 && c == COL_NUM-1) {
        particle[c][r] = new Particle(c, r, MASS, true, color(250));
      } else {
        particle[c][r] = new Particle(c, r, MASS, false, color(250-(c+r*5)));
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
        particle[c][r].CalculateAdjacentForce(particle[c][r+1], K_STRETCH);
      }     

      //Forces above
      if (r > 0) {
        particle[c][r].CalculateAdjacentForce(particle[c][r-1], K_STRETCH);
      }   

      //Forces right
      if (c < COL_NUM - 1) {
        particle[c][r].CalculateAdjacentForce(particle[c+1][r], K_STRETCH);
      }    
      //Forces left
      if (c > 0) {
        particle[c][r].CalculateAdjacentForce(particle[c-1][r], K_STRETCH);
      }

      //Forces bottom right
      if (c < COL_NUM - 1 && r < ROW_NUM - 1) {
        particle[c][r].CalculateAdjacentForce(particle[c+1][r+1], K_SHEAR);
      }     
      //Forces top right
      if (c < COL_NUM - 1 && r > 0) {
        particle[c][r].CalculateAdjacentForce(particle[c+1][r-1], K_SHEAR);
      }    
      //Forces bottom left
      if (c > 0 && r < ROW_NUM - 1) {
        particle[c][r].CalculateAdjacentForce(particle[c-1][r+1], K_SHEAR);
      }    
      //Forces top left
      if (c > 0 && r > 0) {
        particle[c][r].CalculateAdjacentForce(particle[c-1][r-1], K_SHEAR);
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
      //particle[c][r].DrawParticle();
      if (c > 0 && r > 0) {
        particle[c][r].DrawFabric(particle[c-1][r],particle[c-1][r-1],particle[c][r-1]);
      }
    }
  }
  //print("end of cycle\n");
}

void ShiftPerspective() {
  rotateX(radians(-35.26));
  rotateY(radians(45));
  translate(width/10, 0, width/2);
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
