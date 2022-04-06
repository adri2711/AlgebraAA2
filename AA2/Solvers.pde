float Euler(float x, float dx, float deltaT) {
  return x + dx*deltaT;
}

float Verlet(float x, float xPrev, float d2x, float deltaT) {
  return 2*x - xPrev + deltaT*deltaT*d2x;
}
