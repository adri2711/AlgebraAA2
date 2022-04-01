class Particle {
  private PVector pos;
  private PVector speed;
  private PVector anchor;
  private float mass;
  private color color_p;
  private int size;
  private boolean isFixed = false;
  
  Particle (PVector pos, boolean isFixed, PVector anchor, float mass, color color_p, int size) {
    this.pos = pos.copy();
    this.speed = new PVector(0,0,0);
    this.anchor = anchor.copy();
    this.mass = mass;
    this.color_p = color_p;
    this.size = size;
    this.isFixed = isFixed;
  }
  
  void ChangeAnchor(PVector newAnchor) {
    anchor = newAnchor;
  }
  
  void Move() {
    PVector force, acc;
    float deltaTime;
    float kFriction, kSpring; //spring = muelle en espanyo pa tos los paletos iletrados
    
    force = new PVector(0.0,0.0,0.0);
    acc = new PVector(0.0,0.0,0.0);
    deltaTime = 0.04;
    kFriction = 0.02;
    kSpring = 0.5;
    
    //1- Add all forces
    //Gravity
    force.x = 0.0;
    force.y = 9.8;
    force.z = 0.0;
    
    //Friction
    force.x += -1.0 * kFriction * speed.x;
    force.y += -1.0 * kFriction * speed.y;
    force.z += -1.0 * kFriction * speed.z;
    
    //Spring
    force.x += -1.0 * kSpring * (pos.x - anchor.x);
    force.y += -1.0 * kSpring * (pos.y - anchor.y);    
    force.z += -1.0 * kSpring * (pos.z - anchor.z);
    
    //2- Calculate acceleration
    acc.x = force.x / mass;
    acc.y = force.y / mass;
    acc.y = force.z / mass;
    
    //3- Calculate phase
    speed.x += deltaTime * acc.x;
    speed.y += deltaTime * acc.y;
    speed.z += deltaTime * acc.z;
    
    pos.x += deltaTime * speed.x;
    pos.y += deltaTime * speed.y;
    pos.z += deltaTime * speed.z;
  }
  
  void Draw() {
    push();
    translate(pos.x,pos.y,pos.z);
    rotateX(radians(-35.26));
    rotateY(radians(45));
    
    strokeWeight(0);
    fill(color_p);
    ellipse(0,0,size,size);
    pop();
  }
  
  PVector ReturnAnchor() {
    return anchor;
  }
  
  boolean IsFixed() {
    return isFixed;
  }
}
