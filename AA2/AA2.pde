//Cloth attributes
int ROW_NUM = 20;
int COL_NUM = 20;
Particle[][] particle = new Particle[COL_NUM][ROW_NUM];
float SPACING = 20.0f;  //space between nodes
float TILT = 0.75f;     //tilt of the cloth
int VIEW = 0;           //front or back view (0/1)
float MASS = 1f;
//Simulation
float DELTA_T_EULER = 0.03f;
float DELTA_T_RK = 0.04f;
float K_FRICTION = -2.0f;
float K_ELASTIC = -30.0f;
float K_STRETCH = 1.0f;
float K_SHEAR = 0.6f;
PVector GRAVITY = new PVector(0, -9.81);
boolean EULER_SOLVER = true;
//Voxels
float VOXEL_SIZE = 30.0f;
int VOXEL_NUM = 27;
Voxel[] voxel = new Voxel[VOXEL_NUM];
//UI
int gameStage;
int solversButtonsDiameter = 120;
int playButtonDiameter = 170;
String buttonSelected;
PVector eulerButtonPos;
PVector verletButtonPos;
Slider elasticSlider;
Slider frictionSlider;
Slider massSlider;


void setup() {
  size(1080, 720, P3D); 
  frameRate(90);

  SetupVoxels();
  SetupParticles();
  SetupUI();
}


void draw() {
  background(0);
  lights();
  //DrawAxis();

  if (gameStage == 0) {
    Start();
  }
  else if (gameStage == 1) {
  VoxelLoop();
  ParticleLoop();
  }
}


void ChangeSolverMode() {
  EULER_SOLVER = !EULER_SOLVER;
}


////////////////////////    Setup    ////////////////////////

void SetupUI() {
  eulerButtonPos = new PVector(width / 3, height - height / 5);
  verletButtonPos = new PVector(width - (eulerButtonPos.x), height - height / 5);
  
  elasticSlider = new Slider(-100, -1, 100 , new PVector(width / 5, height / 2 - 20));
  elasticSlider.SetPoint(new Point(elasticSlider.GetSliderPosition().copy(), elasticSlider.GetSliderRadius()));
  
  frictionSlider = new Slider(-2, -0.1f, 100 , new PVector(width / 2, height / 2 - 20));
  frictionSlider.SetPoint(new Point(frictionSlider.GetSliderPosition().copy(), frictionSlider.GetSliderRadius()));
  
  massSlider = new Slider(0.01f, 1, 100 , new PVector(width - width / 5, height / 2 - 20));
  massSlider.SetPoint(new Point(massSlider.GetSliderPosition().copy(), massSlider.GetSliderRadius()));
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


void SetupVoxels() {
  int n = 0;
  float xCenter = (COL_NUM * SPACING)/2;
  float yCenter = (COL_NUM * SPACING)/1.5;
  float zCenter = (COL_NUM * SPACING)/5;
  
  for (int i = 1; i <= 2; i++) {
    for (int j = -1; j <= 1; j++) {
      for (int k = -1; k <= 1; k++) {
      
        PVector vpos = new PVector(xCenter + i * VOXEL_SIZE, yCenter + j * VOXEL_SIZE, zCenter + k * VOXEL_SIZE);
        voxel[n] = new Voxel(vpos, VOXEL_SIZE, color(240,240,255));
        n++;
      
      }
    }
  }
  
  for (int i = -2; i <= 0; i++) {
    for (int j = 1; j <= 1; j++) {
      for (int k = -1; k <= 1; k++) {
      
        PVector vpos = new PVector(xCenter + i * VOXEL_SIZE, yCenter + j * VOXEL_SIZE, zCenter + k * VOXEL_SIZE);
        voxel[n] = new Voxel(vpos, VOXEL_SIZE, color(240,240,255));
        n++;
      
      }
    }
  }
}


////////////////////////    Loops    ////////////////////////

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

      //Voxel collision
      boolean collide = false;
      for (int i = 0; i < VOXEL_NUM && !collide; i++) {
        
        if (PVector.dist(particle[c][r].GetPos(), voxel[i].GetPos()) <= VOXEL_SIZE) {
          
          PVector colVector = voxel[i].CalculateCollisionVector(particle[c][r]);  //returns (0,0,0) if collision did not happen
          if (colVector.x != 0 || colVector.y != 0 || colVector.z != 0) {
            
            particle[c][r].CalculateCollisionForce(colVector);
            collide = true;

          } 
        }
      }
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
}


void VoxelLoop() {
  
  for (int i = 0; i < VOXEL_NUM; i++) {
    
    voxel[i].Draw();
  }
}



////////////////////////    Visual    ////////////////////////

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
