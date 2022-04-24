class Slider{

  float minValue;
  float maxValue;
  float sliderRadius;
  float value;
  PVector sliderPosition;
  Point pointToSlide;
  
  Slider(float minValue, float maxValue, float sliderRadius, PVector sliderPosition){
  
    this.minValue = minValue;
    this.maxValue = maxValue;
    this.sliderRadius = sliderRadius;    
    this.sliderPosition = sliderPosition;
  }
  
  void SetPoint(Point pointToSlide){  
  
    this.pointToSlide = pointToSlide;
  }
  
  Point GetPoint(){
  
    return pointToSlide;
  }
  
  void DrawSlider(){
    
    textSize(15);    
    text(nf(minValue, 1, 2), sliderPosition.x - sliderRadius - 35, pointToSlide.GetPosition().y + 3);
    line(sliderPosition.x - sliderRadius, pointToSlide.GetPosition().y, sliderPosition.x + sliderRadius, pointToSlide.GetPosition().y);
    text(nf(maxValue, 1, 2), sliderPosition.x + sliderRadius + 35, pointToSlide.GetPosition().y + 3);  
  }
  
  PVector GetSliderPosition(){
  
    return sliderPosition;    
  }
  
  float GetSliderRadius(){
  
    return sliderRadius;
  }
  
  float GetValue(){
  
    return value;
  }  
  
  void SetValue(){
  
    fill(255);
    this.value = pointToSlide.GetPosition().x - sliderPosition.x;
    this.value = map(value, - sliderRadius, sliderRadius, minValue, maxValue);
    
    if(value < minValue){
      value = minValue;    
    }
    else if(value > maxValue){
      value = maxValue;
    }
  }  
  
  void SetValue(float newValue){
  
    fill(255);
    this.value = newValue;
    
    pointToSlide.SetXPosition(map(value, minValue, maxValue, this.GetPoint().GetMinPosX(), this.GetPoint().GetMaxPosX()));
    
    if(value < minValue){
      value = minValue;    
    }
    else if(value > maxValue){
      value = maxValue;
    }
  }   
  
  void ShowValue(){
    
    fill(255);
    textSize(25);
    
    if(value == -100){
        text(value, sliderPosition.x, sliderPosition.y + 50);    
    }
    else if(value > -100 && value <= -10){    
        text(nf(value, 1, 2), sliderPosition.x, sliderPosition.y + 50);
    }
    else {    
        text(nf(value, 0, 2), sliderPosition.x, sliderPosition.y + 50);
    }
    fill(0);
  }

}
