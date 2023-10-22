boolean[] keys = new boolean[128]; // Information of pressed keys

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

int q = int(random(-10, -3)); // Value of the electron charge
boolean visualizar = false; // Boolean that defines if the electron is going to affect the electric field or not

Module[] mods; // Array of class of type `Module` that saves each line

Module[] mods_percibido; // Array of class of type `Module` with the impact f the electron in the electric field

int n = int(random(5, 15)); // Number of charges
int[][] listCharges = new int[n][3]; // Array of random charges

float min_magnitude = 10000.0; // Min value of electric field in a point


// Electron information

// Electron position
int xelectron = window_width / 2;
int yelectron = window_height / 2;

// Electron speed
float electron_speed_x = 0;
float electron_speed_y = 0;

// Electron force
float max_electron_force = 8;
float electron_force = 10;

float electron_mass = 1; // Electron mass

// Forces applied to the electron
float forcex = 0;
float forcey = 0;
float forcex_neta = 0;
float forcey_neta = 0;
float force_campox = 0;
float force_campoy = 0;
float coeficiente_roce = 1; 

// rgb base values
float br = random(0.0, 100.0);
float bg = random(0.0, 100.0);
float bb = random(0.0, 100.0);

void setup() {
  
  size(1200, 600);
  stroke(0);
  noFill();
  
  // Create empty mods array for points in the field
  mods = new Module[count];
  mods_percibido = new Module[count];
  
  int index = 0;
  
  // Create random charges
  for (int i = 0; i < n; i++) {
    listCharges[i][0] = int(random(0, window_width));
    listCharges[i][1] = int(random(5, window_height));
    listCharges[i][2] = int(random(-10, 10));
  }

  // Create data for each point of the field
  for (int row = 0; row < n_height; row++) {
    for (int col = 0; col < n_width; col++) {
      
      // Define position
      float x = col * cell_size;
      float y = row * cell_size;
      
      float k = 1000;
      float[] force = totalForce(int(x), int(y)); //Direction of the electric field in that point
      float magnitude = k * (float) Math.sqrt(force[0] * force[0] + force[1] * force[1]); //Magnitude of the electric field in that point
      
      // Check if its min magnitude
      if (min_magnitude > magnitude) {
        min_magnitude = magnitude;
      }
      
      // Unitary vector of electric field direction
      float x_coord = k * force[0] / magnitude;
      float y_coord = k * force[1] / magnitude;
      
      // Create instances of each point
      mods_percibido[index] = new Module(x, y, magnitude, x_coord, y_coord, cell_size, br, bg, bb);
      mods[index] = new Module(x, y, magnitude, x_coord, y_coord, cell_size, br, bg, bb);
      index = index + 1;
    }
  }
}

// Check what keys are being pressed for movement and impact of the electron
void keyPressed() {
  keys[keyCode] = true;
  if (key == 'v' || key == 'V') {
    if (!vKeyPressedFlag) {
      vKeyPressedFlag = true;
      lastKeyPressTime = millis();
    }
  }
}

// Check what keys were released for movement and impact of the electron
void keyReleased() {
  keys[keyCode] = false;
}

// Draw each frame at a rate of 30 fps
void draw() {
  background(br * 0.3, bg * 0.3, bb * 0.3); // Create random background with the rgb base
  strokeCap(SQUARE);
  
  if (vKeyPressedFlag) {
    if (millis() - lastKeyPressTime >= debounceDelay) {
      visualizar = !visualizar;
      vKeyPressedFlag = false;
    }
  }

  
  int[] electron = { xelectron,yelectron,q }; // Electron information
  
  // Update velocity, position and field by electron movement
  for (int row = 0; row < n_height; row++) {
    for (int col = 0; col < n_width; col++) {
      
      // Position
      int x = col * cell_size;
      int y = row * cell_size;
      float k = 1000;
      int indice = row * n_width + col;
      
      // Get force of the electron and the field in each point
      float[] force_electron = force(x,y,electron);
      float[] force = { 0,0 };
      if (visualizar) {
        force[0] = mods_percibido[indice].v_x * mods_percibido[indice].magnitude/k + force_electron[0]*force_electron[2];
        force[1] = mods_percibido[indice].v_y * mods_percibido[indice].magnitude/k + force_electron[1]*force_electron[2];
        float magnitude = k * (float) Math.sqrt(force[0] * force[0] + force[1] * force[1]);
        
        if (min_magnitude > magnitude) {
          min_magnitude = magnitude;
        }
        
        // Force vector
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
  
  // Display, update and move for each frame
  for (Module mod : mods) {
    mod.display(min_magnitude);
    mod.update();
    mod.move(xelectron, yelectron);
  }
  
  noStroke();
  
  // Display the charges located in the field
  for (int i = 0; i < n; i ++) {
    if (listCharges[i][2] < 0) {
      fill(230, 23, 80);
    } else {
      fill(230, 184, 100);
    }
    ellipse(listCharges[i][0], listCharges[i][1], abs(listCharges[i][2]) * 1.1, abs(listCharges[i][2]) * 1.1);
  }
  
  // Draw the electron
  fill(230, 23, 80);
  ellipse(xelectron, yelectron, q * 1.1, q * 1.1);
  
  // Force on the electron by moving the keys
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
    
   // Get electron position
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
   
   // Force of the camp
   force_campox = mods_percibido[indice].v_x * mods_percibido[indice].magnitude * q;
   force_campoy = mods_percibido[indice].v_y * mods_percibido[indice].magnitude * q;
    
   // Regulate the force over the electron
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
    
    // Forces sum per axis
    forcex_neta = forcex + force_campox - coeficiente_roce * electron_speed_x;
    forcey_neta = forcey + force_campoy - coeficiente_roce * electron_speed_y;

    // Value of the speed with the influence of the force
    electron_speed_x += forcex_neta/electron_mass;
    electron_speed_y += forcey_neta/electron_mass;

    // Value of the position with the influence of the force
    xelectron += electron_speed_x;
    yelectron += electron_speed_y;
    
    // Return the electron to the other side of the screen
    xelectron = xelectron % window_width; 
    yelectron = yelectron % window_height; 
    if (xelectron < 0) {
      xelectron = window_width;
    }
    if (yelectron < 0) {
      yelectron = window_height;
    }


}

// Function that gets the force by certain charge
float[] force(int x, int y, int[] fixedCharge) {
  float r = sqrt(pow(x - fixedCharge[0], 2) + pow(y - fixedCharge[1], 2));
  float k = fixedCharge[2] / (r * r);
  float z = (x - fixedCharge[0]) / r;
  float w = (y - fixedCharge[1]) / r;
  return new float[]{z, w, k};
}

// Function that gets the total force
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
