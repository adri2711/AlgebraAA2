void Start() {

  ShowInstructions();

  DrawSliders();

  DrawPoints();

  elasticSlider.SetValue();
  elasticSlider.ShowValue();
  K_ELASTIC = -elasticSlider.GetValue();

  frictionSlider.SetValue();
  frictionSlider.ShowValue();
  K_FRICTION = -frictionSlider.GetValue();

  massSlider.SetValue();
  massSlider.ShowValue();
  MASS = massSlider.GetValue();
}

void ShowInstructions() {

  fill(255);  
  textAlign(CENTER);

  textSize(30);
  text("Use the sliders to set values,\nthen select the solver you want to use", width / 2, height / 12);

  textSize(25);  
  text("Rigidity", width / 5, height / 4);
  text("Friction", width / 2, height / 4);
  text("Mass", width - width / 5, height / 4);

  text("Presets:", width / 2, height / 2.1);
  text("Solver:", width / 2, height / 1.3);
}

void DrawSliders() {

  elasticSlider.DrawSlider();
  frictionSlider.DrawSlider();  
  massSlider.DrawSlider();
}

void DrawPoints() {

  elasticSlider.GetPoint().DrawPoint();
  frictionSlider.GetPoint().DrawPoint();
  massSlider.GetPoint().DrawPoint();
}

void ShowButtons() {

  push();

  fill(255);
  strokeWeight(5);

  if (gameStage == 0) {
    push();
    stroke(150, 255, 180);  
    ellipse(eulerButtonPos.x, eulerButtonPos.y, playButtonDiameter, playButtonDiameter);
    ellipse(rkButtonPos.x, rkButtonPos.y, playButtonDiameter, playButtonDiameter);
    fill(0);
    textSize(35);
    text("Euler", eulerButtonPos.x, eulerButtonPos.y+10);
    textSize(25);
    text("Runge\nKutta 4", rkButtonPos.x, rkButtonPos.y-15);
    pop();

    push();
    stroke(150, 255, 255);
    ellipse(preset1Pos.x, preset1Pos.y, presetButtonDiameter, presetButtonDiameter);
    ellipse(preset2Pos.x, preset2Pos.y, presetButtonDiameter, presetButtonDiameter);
    ellipse(preset3Pos.x, preset3Pos.y, presetButtonDiameter, presetButtonDiameter);
    fill(0);
    textSize(20);
    text("Rubber", preset1Pos.x, preset1Pos.y+5);
    text("Cotton", preset2Pos.x, preset2Pos.y+5);
    text("Leather", preset3Pos.x, preset3Pos.y+5);   
    pop();
  } else if (gameStage == 1) {
    push();
    stroke(255, 150, 150);
    ellipse(backButtonPos.x, backButtonPos.y, backButtonDiameter, backButtonDiameter);
    ellipse(resetButtonPos.x, resetButtonPos.y, backButtonDiameter, backButtonDiameter);
    fill(0);
    textSize(20);
    text("Back", backButtonPos.x, backButtonPos.y+7);
    text("Reset", resetButtonPos.x, resetButtonPos.y+7);
    pop();
  }

  pop();
}

void mousePressed() {

  if (gameStage == 0) {

    if (sqrt(pow(elasticSlider.GetPoint().GetPosition().x - mouseX, 2) + pow(elasticSlider.GetPoint().GetPosition().y - mouseY, 2)) <= elasticSlider.GetPoint().GetRadius()) {
      buttonSelected = "elastic";
    } else if (sqrt(pow(frictionSlider.GetPoint().GetPosition().x - mouseX, 2) + pow(frictionSlider.GetPoint().GetPosition().y - mouseY, 2)) <= frictionSlider.GetPoint().GetRadius()) {
      buttonSelected = "friction";
    } else if (sqrt(pow(massSlider.GetPoint().GetPosition().x - mouseX, 2) + pow(massSlider.GetPoint().GetPosition().y - mouseY, 2)) <= massSlider.GetPoint().GetRadius()) {
      buttonSelected = "mass";
    }


    if (sqrt(pow(eulerButtonPos.x - mouseX, 2) + pow(eulerButtonPos.y - mouseY, 2)) <= playButtonDiameter / 2) {
      gameStage = 1;
      EULER_SOLVER = true;
    } else if (sqrt(pow(rkButtonPos.x - mouseX, 2) + pow(rkButtonPos.y - mouseY, 2)) <= playButtonDiameter / 2) {
      gameStage = 1;
      EULER_SOLVER = false;
    } else if (sqrt(pow(preset1Pos.x - mouseX, 2) + pow(preset1Pos.y - mouseY, 2)) <= presetButtonDiameter / 2) {
      //RUBBER PRESET
      elasticSlider.SetValue(30f);
      frictionSlider.SetValue(2f);
      massSlider.SetValue(2f);
    } else if (sqrt(pow(preset2Pos.x - mouseX, 2) + pow(preset2Pos.y - mouseY, 2)) <= presetButtonDiameter / 2) {
      //COTTON PRESET
      elasticSlider.SetValue(60f);
      frictionSlider.SetValue(0.5f);
      massSlider.SetValue(0.5f);
    } else if (sqrt(pow(preset3Pos.x - mouseX, 2) + pow(preset3Pos.y - mouseY, 2)) <= presetButtonDiameter / 2) {
      //LEATHER PRESET
      elasticSlider.SetValue(80f);
      frictionSlider.SetValue(4.2f);
      massSlider.SetValue(1f);
    }
  } else if (gameStage == 1) {
    if (sqrt(pow(backButtonPos.x - mouseX, 2) + pow(backButtonPos.y - mouseY, 2)) <= backButtonDiameter / 2) {
      gameStage = 0;
    } else if (sqrt(pow(resetButtonPos.x - mouseX, 2) + pow(resetButtonPos.y - mouseY, 2)) <= backButtonDiameter / 2) {
      Setup();
    }
  }
}

void mouseDragged() {

  if (gameStage == 0) {

    if (buttonSelected == "elastic" && mouseX >= elasticSlider.GetPoint().GetMinPosX() && mouseX <= elasticSlider.GetPoint().GetMaxPosX()) {
      elasticSlider.GetPoint().SetXPosition(mouseX);
    } else if (buttonSelected == "friction"  && mouseX >= frictionSlider.GetPoint().GetMinPosX() && mouseX <= frictionSlider.GetPoint().GetMaxPosX()) {
      frictionSlider.GetPoint().SetXPosition(mouseX);
    } else if (buttonSelected == "mass"  && mouseX >= massSlider.GetPoint().GetMinPosX() && mouseX <= massSlider.GetPoint().GetMaxPosX()) {
      massSlider.GetPoint().SetXPosition(mouseX);
    }
  }
}

void mouseReleased() {

  buttonSelected = "";
}
