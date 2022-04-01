final int particleNum = 5;
Particle[] particle = new Particle[particleNum];

void setup() {
  size(1080,720,P3D); 
  //Particle (PVector pos, PVector speed, PVector anchor, float mass, color color_p, int size)
  particle[0] = new Particle(new PVector(width/2,20,0), true, new PVector(width/2,height/2), 1.0, color(0,200,100), 40);
  for (int i = 1; i < particleNum; i++) {
    particle[i] = new Particle(new PVector(0,10*i,5*i), false, particle[i-1].ReturnAnchor(), 1.0, color(255,0,0), 40);
  }
}

void draw() {
  background(255);
  lights();

  ParticleLoop();
}

void ParticleLoop() {
  
  for (int i = 0; i < particleNum; i++) {
    if (!particle[i].IsFixed()) {
      particle[i].Move();
      stroke(50,100,200);
      strokeWeight(5);
      line(particle[i].pos.x,particle[i].pos.y,particle[i-1].pos.x,particle[i-1].pos.y);
    }
    particle[i].Draw();
  }
}
