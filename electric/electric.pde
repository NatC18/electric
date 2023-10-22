int numRows = 5;  // Number of rows
int numCols = 5;  // Number of columns
float spacing = 30;  // Spacing between lines
float lineLength = 20;  // Length of each line
float rotationSpeed = 0.02;  // Speed of rotation

int window_height = 600;
int window_width = 1200;

int cell_size = 15;

int n_height = window_height / cell_size;
int n_width = window_width / cell_size;

int count = n_height * n_width;

float noise_scale = 0.1;

int[][] charges;

Module[] mods;

int q = -5;
int n = int(random(5, 15));
int[][] listCharges = new int[n][3];

  
float min_magnitude = 10000.0;
float max_magnitude = 0.0;

int xelectron = window_width / 2;
int yelectron = window_height / 2;

float electron_speed_x = 0;
float electron_speed_y = 0;

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

void setup() {
  size(1200, 600);
  background(255);
  stroke(0);
  noFill();
  
  mods = new Module[count];
  
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
      float b = random(-80.0, 100.0);
      mods[index++] = new Module(x, y, lineLength, magnitude, x_coord, y_coord, nn, cell_size, b);
      print(b, "\n");
      //mods[index++] = new Module(x, y, lineLength);
      
    }
  }
  
}

void keyPressed() {
  keys[key] = true;
}

void keyReleased() {
  keys[key] = false;
}

void draw() {
  //background(29, 87, 89);
  background(8, 49, 56);
  strokeCap(SQUARE);
  
  for (Module mod : mods) {
    mod.display(min_magnitude, max_magnitude);
    mod.update();
    mod.move(xelectron, yelectron);
  }
  
  fill(230, 23, 80);
  noStroke();
  ellipse(xelectron, yelectron, 10, 10);
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
   
   force_campox = mods[indice].v_x * mods[indice].magnitude * q;
   force_campoy = mods[indice].v_y * mods[indice].magnitude * q;



     
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
