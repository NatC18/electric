float lineLength = 20;  // Length of each line
float rotationSpeed = 0.02;  // Speed of rotation
float noise_scale = 0.1; // The scale of the noise

int debounceDelay = 200; // Adjust this value as needed
int lastKeyPressTime = 0;
boolean vKeyPressedFlag = false;

int window_height = 600; // Window height
int window_width = 1200; // Window width
int cell_size = 15; // Adjust cell_size
int n_height = window_height / cell_size; // Amount of lines in the x axis
int n_width = window_width / cell_size; // Amount of lines in the y axis
int count = n_height * n_width; // Amount of points we view

int[][] charges; // Array of random charges
int q = int(random(-10, -3)); // Value of the electron charge
boolean visualizar = false; // Boolean that defines if the electron is going to affect the electric field or not

Module[] mods; // Array of class of type `Module` that saves each line

Module[] mods_percibido; // Array of class of type `Module` with the impact f the electron in the electric field


int n = int(random(5, 15));

int[][] listCharges = new int[n][3];

  
float min_magnitude = 10000.0;
float max_magnitude = 0.0;

int xelectron = window_width / 2;
int yelectron = window_height / 2;

float electron_speed_x = 0;
float electron_speed_y = 0;
float max_electron_force = 8;

float electron_force = 10;
float electron_mass = 1;
float coeficiente_roce = 1;

float forcex = 0;
float forcey = 0;
float forcex_neta = 0;
float forcey_neta = 0;
float force_campox = 0;
float force_campoy = 0;

boolean[] keys = new boolean[128];

float br = random(0.0, 100.0);
float bg = random(0.0, 100.0);
float bb = random(0.0, 100.0);

void setup() {
  size(1200, 600);
  background(255);
  stroke(0);
  noFill();
  
  mods = new Module[count];
  mods_percibido = new Module[count];
  
  int index = 0;
  
  for (int i = 0; i < n; i++) {
    listCharges[i][0] = int(random(0, window_width));
    listCharges[i][1] = int(random(5, window_height));
    listCharges[i][2] = int(random(-10, 10));
  }

 
  
  for (int row = 0; row < n_height; row++) {
    for (int col = 0; col < n_width; col++) {
      float x = col * cell_size;
      float y = row * cell_size;
      float k = 1000;
      float nn = noise(x * noise_scale, y * noise_scale);
      float[] force = totalForce(int(x), int(y));
      //float v_x = 0.0;
      //float v_y = 0.0;
      float magnitude = k * (float) Math.sqrt(force[0] * force[0] + force[1] * force[1]);
      if (min_magnitude > magnitude) {
        min_magnitude = magnitude;
      }
      if (max_magnitude < magnitude) {
        max_magnitude = magnitude;
      }
      // print(magnitude, "\n");
      float x_coord = k * force[0] / magnitude;
      float y_coord = k * force[1] / magnitude;
      //print(x_coord, y_coord, "\n");
      mods_percibido[index] = new Module(x, y, lineLength, magnitude, x_coord, y_coord, nn, cell_size, br, bg, bb);
      mods[index] = new Module(x, y, lineLength, magnitude, x_coord, y_coord, nn, cell_size, br, bg, bb);
      index = index + 1;
      //print(b, "\n");
      //mods[index++] = new Module(x, y, lineLength);
      
    }
  }
}

void keyPressed() {
  keys[keyCode] = true;
  if (key == 'v' || key == 'V') {
    if (!vKeyPressedFlag) {
      // Set the flag and record the time of the "V" key press
      vKeyPressedFlag = true;
      lastKeyPressTime = millis();
    }
  }
}

void keyReleased() {
  keys[keyCode] = false;
}

void draw() {
  //background(29, 87, 89);
  background(br * 0.3, bg * 0.3, bb * 0.3);
  strokeCap(SQUARE);
  if (vKeyPressedFlag) {
    if (millis() - lastKeyPressTime >= debounceDelay) {
      visualizar = !visualizar;
      vKeyPressedFlag = false;
    }
  }

  int[] electron = { xelectron,yelectron,q };
  for (int row = 0; row < n_height; row++) {
    for (int col = 0; col < n_width; col++) {
      int x = col * cell_size;
      int y = row * cell_size;
      float k = 1000;
      int indice = row * n_width + col;
      float[] force_electron = force(x,y,electron);
      float[] force = { 0,0 };
      if (visualizar) {
      force[0] = mods_percibido[indice].v_x * mods_percibido[indice].magnitude/k + force_electron[0]*force_electron[2];
      force[1] = mods_percibido[indice].v_y * mods_percibido[indice].magnitude/k + force_electron[1]*force_electron[2];
      float magnitude = k * (float) Math.sqrt(force[0] * force[0] + force[1] * force[1]);
      if (min_magnitude > magnitude) {
        min_magnitude = magnitude;
      }
      if (max_magnitude < magnitude) {
        max_magnitude = magnitude;
      }
      // print(magnitude, "\n");
      float x_coord = k * force[0] / magnitude;
      float y_coord = k * force[1] / magnitude;
      
      mods[indice].v_x = x_coord;
      mods[indice].v_y = y_coord;
      mods[indice].magnitude = magnitude;
      }
      else {
      mods[indice].v_x = mods_percibido[indice].v_x;
      mods[indice].v_y = mods_percibido[indice].v_y;
      mods[indice].magnitude = mods_percibido[indice].magnitude;
      }
    }
  }
  for (Module mod : mods) {
    mod.display(min_magnitude, max_magnitude);
    mod.update();
    mod.move(xelectron, yelectron);
  }
  noStroke();
  for (int i = 0; i < n; i ++) {
    if (listCharges[i][2] < 0) {
      fill(230, 23, 80);
    } else {
      fill(230, 184, 100);
    }
    ellipse(listCharges[i][0], listCharges[i][1], abs(listCharges[i][2]) * 1.1, abs(listCharges[i][2]) * 1.1);
    
  }
  
  fill(230, 23, 80);
  
  ellipse(xelectron, yelectron, q * 1.1, q * 1.1);
   if (keys['w'] || keys['W']) {
     forcey = -electron_force; // Move up
   }
   if (keys['s'] || keys['S']) {
     forcey = electron_force; // Move down
   }
   if (!(keys['w'] || keys['W']) && !(keys['s'] || keys['S'])) {
     forcey = 0;
   }
   if (keys['a'] || keys['A']) {
     forcex = -electron_force; // Move left
   }
   if (keys['d'] || keys['D']) {
     forcex = electron_force; // Move right
   }
   if (!(keys['a'] || keys['A']) && !(keys['d'] || keys['D'])) {
     forcex = 0;
   }
    
   int j = floor(xelectron/cell_size);
   int i = floor(yelectron/cell_size);
   
   if ( i < 0) {
     i = 0;
   }
   if ( j < 0) {
     j = 0;
   }
   if (i>=n_height) {
     i = n_height-1;
   }
   if (j>=n_width) {
     j = n_width-1;
   }
   
   int indice = i * n_width + j;
   
   force_campox = mods_percibido[indice].v_x * mods_percibido[indice].magnitude * q;
   force_campoy = mods_percibido[indice].v_y * mods_percibido[indice].magnitude * q;
    
   if (force_campox > max_electron_force) {
      force_campox = max_electron_force;
    }
    else if (force_campox < -max_electron_force){
      force_campox = -max_electron_force;
    }
   if (force_campoy > max_electron_force) {
      force_campoy = max_electron_force;
    }
    else if (force_campoy < -max_electron_force){
      force_campoy = -max_electron_force;
    }


     
    forcex_neta = forcex + force_campox - coeficiente_roce * electron_speed_x;
    forcey_neta = forcey + force_campoy - coeficiente_roce * electron_speed_y;

    electron_speed_x += forcex_neta/electron_mass;
    electron_speed_y += forcey_neta/electron_mass;


    xelectron += electron_speed_x;
    yelectron += electron_speed_y;
    
    xelectron = xelectron % window_width; 
    yelectron = yelectron % window_height; 
    if (xelectron < 0) {
      xelectron = window_width;
    }
    if (yelectron < 0) {
      yelectron = window_height;
    }


}

float[] force(int x, int y, int[] fixedCharge) {
  float r = sqrt(pow(x - fixedCharge[0], 2) + pow(y - fixedCharge[1], 2));
  float k = fixedCharge[2] / (r * r);
  float z = (x - fixedCharge[0]) / r;
  float w = (y - fixedCharge[1]) / r;
  return new float[]{z, w, k};
}

float[] totalForce(int x, int y) {
  float z = 0;
  float w = 0;
  for (int i = 0; i < listCharges.length; i++) {
    float[] f_i = force(x, y, listCharges[i]);
    z += f_i[0] * f_i[2];
    w += f_i[1] * f_i[2];
  }
  return new float[]{z, w};
}
