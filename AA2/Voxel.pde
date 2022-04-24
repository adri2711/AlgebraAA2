class Voxel {
  private PVector pos;
  private PVector force;
  private float side;
  private color color_v;
  
  Voxel(PVector pos, float side, color color_v) {
    this.pos = pos.copy();
    this.side = side;
    this.color_v = color_v;
  }
  
////////////////////////    Operations    ////////////////////////  
  
  //CalculateCollisionVector:
  //  Returns unitary normal vector of the side against which
  //  the particle collided, or an empty vector if it has not collided.
  PVector CalculateCollisionVector(Particle p) {
    
    float leniency = side/3;
    float radius = side / 2 + leniency;
    PVector pPos = p.GetPos();
    if (pPos.x < pos.x+radius && pPos.x > pos.x-radius  &&  pPos.y < pos.y+radius && pPos.y > pos.y-radius  &&  pPos.z < pos.z+radius && pPos.z > pos.z-radius) {
      
      float[] distSides = new float[6];
      distSides[0] = PVector.dist(p.GetPos(), new PVector(pos.x+radius,pos.y,pos.z));
      distSides[1] = PVector.dist(p.GetPos(), new PVector(pos.x-radius,pos.y,pos.z));
      distSides[2] = PVector.dist(p.GetPos(), new PVector(pos.x,pos.y+radius,pos.z));
      distSides[3] = PVector.dist(p.GetPos(), new PVector(pos.x,pos.y-radius,pos.z));
      distSides[4] = PVector.dist(p.GetPos(), new PVector(pos.x,pos.y,pos.z+radius));
      distSides[5] = PVector.dist(p.GetPos(), new PVector(pos.x,pos.y,pos.z-radius));
      
      int side = 0;
      for (int i = 1; i < 6; i++) {
        if (distSides[i] < distSides[i-1]) {
          side = i;
        }
      }
      switch (side) {
        case 0:
        return new PVector(-1,0,0);
        case 1:
        return new PVector(1,0,0);
        case 2:
        return new PVector(0,-1,0);
        case 3:
        return new PVector(0,1,0);
        case 4:
        return new PVector(0,0,-1);
        case 5:
        return new PVector(0,0,1);
        default:
        return new PVector(0,0,0);
      }
    }
    else {
      return new PVector(0,0,0);
    }
  }
  
////////////////////////    Visual    ////////////////////////  
  
  void Draw() {
    push();
    
    ShiftPerspective();
    translate(pos.x, pos.y, pos.z);
    
    strokeWeight(1);
    stroke(30);
    fill(color_v);
    
    box(side);
    
    pop();   
  }

////////////////////////    Setters    ////////////////////////  
  
  void SetForce(PVector newForce) {
    force = newForce.copy();
  }
  
////////////////////////    Getters    ////////////////////////    
  
  PVector GetPos() {
    return pos;
  }
  
  PVector GetForce() {
    return force;
  }
  
  float GetSide() {
    return side;
  }
}
