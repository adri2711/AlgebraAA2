class Point{

  PVector position;
  int minPosX;
  int maxPosX;  
  float radius = 10;

  Point(PVector position, float sliderRadius){
    
    this.position = position;
    this.minPosX = Math.round(position.x - sliderRadius);
    this.maxPosX = Math.round(position.x + sliderRadius);
  }
  
  PVector GetPosition(){
  
    return position;
  }
  
  float GetRadius(){
  
    return radius;  
  }
  
  int GetMinPosX(){
  
    return minPosX;
  }
  
  int GetMaxPosX(){
  
    return maxPosX;
  }
  
  void SetXPosition(float posX){
    this.position.x = posX;
  }
  
  void DrawPoint(){
  
    stroke(150, 255, 255);
    ellipse(position.x, position.y, radius * 2, radius * 2);
  }

}
