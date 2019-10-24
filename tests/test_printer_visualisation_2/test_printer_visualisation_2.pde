float extrusionFlow = 300;

void setup() {
  fullScreen(P3D);
  noSmooth();
  pixelDensity(displayDensity());
  
  noiseSeed(0);
  
  printerHome();
  printerPosition(0, 00, 0, 10000, false);

  for (int j = 0; j < 50000; j++) {
    a += TAU*0.001;
    float x = 60*sin(a);
    float y = 60*cos(a);
    printerPosition(x, y, a*0.1, 100+300*noise(3*a), true);
  }
}

float a = 0;
void draw() {
  background(0);
  
  strokeWeight(10);
  translate(width/2, height/2, 0);
  scale(height/200.0);

  rotateX(TAU/4);
  rotateX(-(mouseY - height/2) / 150.0);
  rotateZ(-(mouseX - width/2) / 200.0);
  
  lights();
  
  for (int i = 0; i < dots; i++) {
    //stroke(255 - 50*noise(i*0.03));
    strokeWeight(dotsSize[i]);
    stroke(255 - 30*dotsSize[i]);
    point(dotsX[i], dotsY[i], dotsZ[i]);
  }
}

float prevPosX, prevPosY, prevPosZ;

void printerHome() {
  println("Home");
  prevPosX = 0;
  prevPosY = 0;
  prevPosZ = 290;
}


float[] dotsX = new float[100000];
float[] dotsY = new float[100000];
float[] dotsZ = new float[100000];
float[] dotsSize = new float[100000];
int dots = 0;
void printerPosition(float x, float y, float z, float speed, boolean waitForOK) {
  // mm, mm, mm, mm/min

  //float travelDistance = sqrt(sq(x-prevPosX) + sq(y-prevPosY) + sq(z-prevPosZ));
  
  dotsX[dots] = x;
  dotsY[dots] = y;
  dotsZ[dots] = z;
  dotsSize[dots] = extrusionFlow/speed;
  dots += 1;
}
