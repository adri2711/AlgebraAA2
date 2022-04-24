float Euler(float x, float dx, float deltaT) {
  return x + dx*deltaT;
}

float Verlet(float x, float xPrev, float d2x, float deltaT) {
  return 2*x - xPrev + pow(deltaT,2)*d2x;
}

float RK4(float y, float y0, float deltaT) {
  
  float k1 = 0, k2 = 0, k3 = 0, k4 = 0;
  
  k1 = y0;
  k2 = y0 + (deltaT/2) * k1;
  k3 = y0 + (deltaT/2) * k2;
  k4 = y0 + deltaT * k3;
  
  float T4 = (k1 + 2*k2 + 2*k3 + k4)/6;
  
  return y + T4 * deltaT;
  
}
