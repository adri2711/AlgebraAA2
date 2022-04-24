void Start() {
  
  ShowInstructions();
  
  DrawSliders();
  
  DrawPoints();
  
  elasticSlider.SetValue();
  elasticSlider.ShowValue();
  K_ELASTIC = elasticSlider.GetValue();
  
  frictionSlider.SetValue();
  frictionSlider.ShowValue();
  K_FRICTION = frictionSlider.GetValue();
  
  massSlider.SetValue();
  massSlider.ShowValue();
  MASS = massSlider.GetValue();
  
  ShowButtons();
  
}

void ShowInstructions(){

  fill(255);  
  textAlign(CENTER);
  
  textSize(55);
  text("Use the slider to set values,\nthen select the solver you want to use", width / 2, height / 7);
  
  textSize(45);  
  text("ELASTIC", width / 5, height / 2 - 70);
  text("FRICTION", width / 2, height / 2 - 70);
  text("MASS", width - width / 5, height / 2 - 70);
}

void DrawSliders(){
  
  elasticSlider.DrawSlider();
  frictionSlider.DrawSlider();  
  massSlider.DrawSlider();
}

void DrawPoints(){
  
  elasticSlider.GetPoint().DrawPoint();
  frictionSlider.GetPoint().DrawPoint();
  massSlider.GetPoint().DrawPoint();
}

void ShowButtons(){
  
  fill(255);
  strokeWeight(3);
  stroke(150, 255, 255);
  ellipse(eulerButtonPos.x, eulerButtonPos.y, playButtonDiameter, playButtonDiameter);
  ellipse(verletButtonPos.x, verletButtonPos.y, playButtonDiameter, playButtonDiameter);
  fill(0);
  textSize(45);
  text("EULER", width / 3, height - height / 5 + 20);
  textSize(35);
  text("RUNGE\nKUTTA 4", width - width / 3, height - height / 5 - 20);
}

void mousePressed(){

  if(sqrt(pow(elasticSlider.GetPoint().GetPosition().x - mouseX, 2) + pow(elasticSlider.GetPoint().GetPosition().y - mouseY, 2)) <= elasticSlider.GetPoint().GetRadius()){
    buttonSelected = "elastic";
  }
  else if(sqrt(pow(frictionSlider.GetPoint().GetPosition().x - mouseX, 2) + pow(frictionSlider.GetPoint().GetPosition().y - mouseY, 2)) <= frictionSlider.GetPoint().GetRadius()){
    buttonSelected = "friction";
  }
  else if(sqrt(pow(massSlider.GetPoint().GetPosition().x - mouseX, 2) + pow(massSlider.GetPoint().GetPosition().y - mouseY, 2)) <= massSlider.GetPoint().GetRadius()){
     buttonSelected = "mass";
  }

}

void mouseDragged() {
  
  if (gameStage == 0) {
    if (sqrt(pow(eulerButtonPos.x - mouseX, 2) + pow(eulerButtonPos.y - mouseY, 2)) <= solversButtonsDiameter / 2 /*&& !EULER_SOLVER*/) {
      gameStage = 1;
      ChangeSolverMode();
    }
    else if(sqrt(pow(verletButtonPos.x - mouseX, 2) + pow(verletButtonPos.y - mouseY, 2)) <= solversButtonsDiameter / 2 /*&& EULER_SOLVER*/){
      gameStage = 1;
      ChangeSolverMode();
    }
    else if(buttonSelected == "elastic" && mouseX >= elasticSlider.GetPoint().GetMinPosX() && mouseX <= elasticSlider.GetPoint().GetMaxPosX()){
      elasticSlider.GetPoint().SetXPosition(mouseX);
    }
    else if(buttonSelected == "friction"  && mouseX >= frictionSlider.GetPoint().GetMinPosX() && mouseX <= frictionSlider.GetPoint().GetMaxPosX()){
      frictionSlider.GetPoint().SetXPosition(mouseX);
    }
    else if(buttonSelected == "mass"  && mouseX >= massSlider.GetPoint().GetMinPosX() && mouseX <= massSlider.GetPoint().GetMaxPosX()){
       massSlider.GetPoint().SetXPosition(mouseX);
    }
  } 
}

void mouseReleased(){

  buttonSelected = "";
}
