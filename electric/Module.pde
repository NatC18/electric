class Module {
  float x;
  float y;
  float angle;
  float magnitude;
  float v_x;
  float v_y;
  float n;
  int cell_size;
  int pond;
  float og_angle;
  float r;
  float g;
  float b;
  float xOffset;
  float yOffset;
  float varr;
  float varg;
  float varb;
  float scaling;
  float scaling_pond;
  float noise_scale;
  float noise_pond;
   
  
  Module(float xTemp, float yTemp, float magnitudeTemp, float v_xTemp, float v_yTemp, int cell_sizeTemp, float br, float bg, float bb){
    x = xTemp;
    y = yTemp;
    magnitude = magnitudeTemp;
    v_x = v_xTemp;
    v_y = v_yTemp;
    angle = (float) Math.atan2(v_x, v_y);
    og_angle = (float) Math.atan2(v_x, v_y);
    cell_size = cell_sizeTemp;
    if (random(0.0, 1.1) < 0.5) {
      pond = -1;
    } else {
      pond = 1;
    }
    
    // Base colors for displaying
    r = br + 170 * n;
    g = bg + 230 * n;
    b = bb + 170 * n;

    // Variable amount for te base rgb params
    varr = 0;
    varg = 0;
    varb = 0;
    
    // Initial scale size of a line
    scaling = random(0.1, 3.0);
    
    // Get if the scaling is going to grow or shrink
    if (random(0.0, 1.0) < 0.5) {
      scaling_pond = 1;
    } else {
      scaling_pond = -1;
    }
    
    if (angle < 0) {
        angle += 2 * Math.PI;
    }
    
    // Noise vor color change
    noise_scale = 0.05;
    n = noise(magnitude);
    if (n < 0.5) {
      noise_pond = 1;
    } else {
      noise_pond = -1;
    }
    
  }

  // Update values with each frame
  void update(){
    //angle = (float) Math.atan2(v_x, v_y);
    //og_angle = (float) Math.atan2(v_x, v_y);
    //float large = log(magnitude / min_magnitude);
    
    //stroke(r + varr, g + varg, b + varb);
    //strokeWeight(large * 0.5);
    
    //pushMatrix();
    //translate(x, y);
    //rotate(angle);
    //scale(scaling);
    //line(-large / 2 * cell_size * 0.2 + xOffset, 0, large / 2 * cell_size * 0.2 + yOffset, 0);
    //popMatrix();
      
    scaling += 0.01 * scaling_pond;
    if (scaling < 0.1) {
      scaling_pond *= -1;
    }
    else if (scaling > 3) {
      scaling_pond *= -1;
    }

    // Change colors per frame with noise
    r += n * noise_pond;
    g += n * noise_pond;
    b += n * noise_pond;
    
    // Get max values of the color change
    if ( r > br + 30) {
      noise_pond *= -1;
    }else if ( g > bg + 30) {
      noise_pond *= -1;
    }else if ( b > bb + 30) {
      noise_pond *= -1;
    }
    
    // Get min values of the color change
    if ( r < br - 30) {
      noise_pond *= -1;
    }else if ( g < bg - 30) {
      noise_pond *= -1;
    }else if ( b < bb - 30) {
      noise_pond *= -1;
    }
  }
   
  void display(float min_magnitude){
    
    // Scale field magnitude
    float large = log(magnitude / min_magnitude);
    stroke(r + varr, g + varg, b + varb);
    strokeWeight(large * 0.5);
    
    pushMatrix();
    translate(x, y);
    rotate(angle);
    scale(scaling);
    line(-large / 2 * cell_size * 0.2 + xOffset, 0, large / 2 * cell_size * 0.2 + yOffset, 0);
    popMatrix();
  }
  
  // Get distance between electron and the point
  float distance(float x1, float y1, float x2, float y2) {
    float dx = x2 - x1;
    float dy = y2 - y1;
    return sqrt(dx*dx + dy*dy);
  }
  
  // Impact of the electron moving
  void move(float xelectron, float yelectron) {
    float d = distance(x, y, xelectron, yelectron);
    if (d < 60){
      varr += 15;
      varg += 5;
      varb += 5;
    }
    else {
      varr = 0;
      varg = 0;
      varb = 0;
    }  
  }
}
