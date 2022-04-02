class Particle {
  private float mass;
  private PVector index;
  private PVector pos;
  private PVector posInit;
  private PVector vel;
  private PVector acc;
  private PVector force;
  private color color_p;
  private boolean isFixed = false;

  Particle (int row, int col, int spacing, float mass, boolean isFixed, color color_p) {
    this.index = new PVector(row, col);
    this.pos = new PVector((row-1) * spacing, (col-1) * spacing, 0.0);
    this.posInit = this.pos.copy();

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
  void CalculateAdjacentForce(Particle adj) {

    float distInit = posInit.dist(adj.posInit);
    float distCurr = pos.dist(adj.pos);

    float tension = -kElastic * (distCurr - distInit);    //-k*dx
    PVector tVector = (pos.sub(adj.pos)).div(distCurr);   //Normalized tension vector
    force.sub(tVector.mult(tension));

    PVector fVector = vel.sub(adj.vel);                   //Friction vector
    force.sub(fVector.mult(-kFriction));
  }

  //CalculateGravity:
  //  Adds force of gravity.
  //
  void CalculateGravity() {
    force.sub(gravity.mult(mass));
  }

  //Update:
  //  Updates velocity, acceleration and position of the particle based
  //  on the forces that affect it.
  void Update() {
    acc = force.div(mass);
    if (eulerSolver) {
      vel = new PVector(Euler(vel.x, acc.x, deltaTime), Euler(vel.y, acc.y, deltaTime));
      pos = new PVector(Euler(pos.x, vel.x, deltaTime), Euler(pos.y, vel.y, deltaTime));
    }
  }

  void SetPos(PVector newPos) {
    pos = newPos.copy();
  }

  void SetForce(PVector newForce) {
    force = newForce.copy();
  }


  void Draw() {
    push();
    translate(pos.x, pos.y, pos.z);
    rotateX(radians(-35.26));
    rotateY(radians(45));

    strokeWeight(0);
    fill(color_p);
    ellipse(0, 0, mass, mass);
    pop();
  }

  /*void Debug() {
   print("Pos: ", pos.x, ",", pos.y, ",", pos.z, "\n");
   print("Anchor: ", anchor.x, ",", anchor.y, ",", anchor.z, "\n");
   if (!isFixed) {
   print("Force: ", force.x, ",", force.y, ",", force.z, "\n");
   print("Speed: ", speed.x, ",", speed.y, ",", speed.z, "\n");
   } else {
   print ("Fixed\n");
   }
   print("\n");
   }*/


  PVector ReturnPos() {
    return pos;
  }

  boolean IsFixed() {
    return isFixed;
  }
}
