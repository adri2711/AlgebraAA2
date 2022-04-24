class Particle {
  private float mass;
  private PVector index;
  private PVector pos;
  private PVector posInit;
  private PVector posPrev;
  private PVector posEvenMorePrev;
  private PVector vel;
  private PVector acc;
  private PVector force;
  private color color_p;
  private boolean isFixed = false;

  Particle (int row, int col, float mass, boolean isFixed, color color_p) {
    this.index = new PVector(row, col);
    this.pos = new PVector((float)(row * SPACING), (float)(col * SPACING * (1-TILT)), (float)(col * pow(-1,VIEW) * SPACING * TILT));
    this.posInit = this.pos.copy();
    this.posPrev = this.pos.copy();
    this.posEvenMorePrev = this.pos.copy();

    this.mass = mass;
    this.color_p = color_p;
    this.isFixed = isFixed;

    force = new PVector(0.0, 0.0, 0.0);
    vel = new PVector(0.0, 0.0, 0.0);
    acc = new PVector(0.0, 0.0, 0.0);
  }


  //CalculateAdjacentForce:
  //  Adds tension and friction forces applied by an adjacent particle (adj).
  //
  void CalculateAdjacentForce(Particle adj, float strength) {

    float distInit = posInit.dist(adj.posInit);
    float distCurr = pos.dist(adj.pos);

    float tension = -K_ELASTIC * (distCurr - distInit);    //-k*dx
    PVector tVector = new PVector(0,0,0);                  //Normalized tension vector
    PVector temp = pos.copy();
    tVector.set((temp.sub(adj.pos)).div(distCurr));
    
    force.sub(tVector.mult(tension).mult(strength));

    PVector fVector = new PVector(0,0,0);                  //Friction vector
    PVector temp2 = vel.copy();
    fVector.set(temp2.sub(adj.vel));
    
    force.sub(fVector.mult(-K_FRICTION).mult(strength));
  }

  //CalculateGravity:
  //  Adds force of gravity.
  //
  void CalculateGravity() {
    PVector temp = GRAVITY.copy();
    force.sub(temp.mult(mass));
  }
  
  //CalculateCollisionForce:
  //  Adds force applied by solid voxels
  //
  void CalculateCollisionForce(PVector normal) {
    
    vel.x = max(vel.x * normal.x, 0);
    vel.y = max(vel.y * normal.y, 0);
    vel.z = max(vel.z * normal.z, 0);
    
    /*vel.x -= vel.x * abs(normal.x);
    vel.y -= vel.y * abs(normal.y);
    vel.z -= vel.z * abs(normal.z);*/
    
    PVector temp = force.copy();
    float f = temp.mag();
    force.sub(normal.mult(f));
  }


  //Update:
  //  Updates velocity, acceleration and position of the particle based
  //  on the forces that affect it.
  void Update() {
    
    PVector temp = force.copy();
    acc.set(temp.div(mass));
    
    if (EULER_SOLVER) {
      //Euler solver
      vel = new PVector(Euler(vel.x, acc.x, DELTA_T_EULER), Euler(vel.y, acc.y, DELTA_T_EULER), Euler(vel.z, acc.z, DELTA_T_EULER));
    }
    else {
      //Runge-Kutta 4 solver
      vel = new PVector(RK4(vel.x, acc.x, DELTA_T_RK), RK4(vel.y, acc.y, DELTA_T_RK), RK4(vel.z, acc.z, DELTA_T_RK));
    }
    
    pos = new PVector(Euler(pos.x, vel.x, DELTA_T_EULER), Euler(pos.y, vel.y, DELTA_T_EULER), Euler(pos.z, vel.z, DELTA_T_EULER));
    
  }

  void SetPos(PVector newPos) {
    pos = newPos.copy();
  }

  void SetForce(PVector newForce) {
    force = newForce.copy();
  }

  void SetColor(color newColor) {
    color_p = newColor;
  }

  void DrawParticle() {
    push();
    
    ShiftPerspective();
    translate(pos.x, pos.y, pos.z);

    strokeWeight(0);
    fill(color_p);
    ellipse(0, 0, 10, 10);
    
    pop();
  }
  
  void DrawFabric(Particle adj1, Particle adj2, Particle adj3) {
    push();
    
    ShiftPerspective();
    translate(pos.x, pos.y, pos.z);
    
    strokeWeight(0);
    fill(color_p);
    
    beginShape();
    vertex(0,0,0);
    vertex(adj1.pos.x-pos.x, adj1.pos.y-pos.y, adj1.pos.z-pos.z);
    vertex(adj2.pos.x-pos.x, adj2.pos.y-pos.y, adj2.pos.z-pos.z);
    vertex(adj3.pos.x-pos.x, adj3.pos.y-pos.y, adj3.pos.z-pos.z);
    endShape(CLOSE);
    
    pop();    
  }

  void Debug() {
    print("\n\n",index,":\n");
    print("Pos: ", pos.x, ",", pos.y, ",", pos.z, "\n");
    print("Init Pos: ", posInit.x, ",", posInit.y, ",", posInit.z, "\n");
    if (!isFixed) {
      print("Force: ", force.x, ",", force.y, ",", force.z, "\n");
      print("Velocity: ", vel.x, ",", vel.y, ",", vel.z, "\n");
    } else {
      print ("Fixed\n");
    }
  }


  PVector GetPos() {
    return pos;
  }

  boolean IsFixed() {
    return isFixed;
  }
}
