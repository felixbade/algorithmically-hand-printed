ParameterBox p;

float extrusionFlow = 500;

void setup() {
  fullScreen(P3D);
  noSmooth();
  pixelDensity(displayDensity());

  p = new ParameterBox(this, "usbmodem");

  noiseSeed(0);
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
  
  p.update();
  
  printerHome();
  printerPosition(0, 00, 0, 10000, false);

  float r = 30;
  float h = 1;
  
  p.setScale(p.P1, 1, 1000, p.LOG);
  p.setScale(p.P2, 1, 1000, p.LOG);
  
  p.setScale(p.P5, 3, 1000, p.LOG);
  p.setScale(p.P6, 3, 1000, p.LOG);
  
  p.setScale(p.P9, 3, 1000, p.LOG);
  p.setScale(p.P10, 3, 1000, p.LOG);
  
  p.setScale(p.P3, 0.1, 10, p.LOG);
  scale(p.p3);
  translate(0, 0, -20);

  p.setScale(p.P4, 1, 1000, p.LOG);
  p.setScale(p.P8, 0.03, 10, p.LOG);
  p.setScale(p.P12, 0.03, 10, p.LOG);

  a = 0;
  for (int j = 0; j < 50000; j++) {
    a += TAU*0.001;
    float x = r * sin(a);
    float y = r * cos(a);
    float z = a/TAU * h;
    
    float horAmp = p.p1;
    float hor2horFreq = p.p5;
    float ver2horFreq = p.p9;
    
    float verAmp = p.p2;
    float hor2verFreq = p.p6;
    float ver2verFreq = p.p10;

    float dx = horAmp * (noise(x/hor2horFreq + 1000, y/hor2horFreq + 1000, 1000 + z/ver2horFreq) - 0.5);
    float dy = horAmp * (noise(x/hor2horFreq + 2000.5, y/hor2horFreq + 1000.5, 1000 + z/ver2horFreq) - 0.5);
    float dz = verAmp * (noise(x/hor2verFreq + 3000, y/hor2verFreq + 1000, 1000 + z/ver2verFreq) - 0.5);

    x += dx;
    y += dy;
    z += dz;
    
    float speedAmp = p.p4;
    float hor2speedFreq = p.p8;
    float ver2speedFreq = p.p12;


    float speed = speedAmp * (noise(x/hor2speedFreq + 3000, y/hor2speedFreq + 1000, 1000 + z/ver2speedFreq) - 0.5); 
    
    printerPosition(x, y, z, 250+speed, true);
  }
  
  for (int i = 0; i < dots; i++) {
    //stroke(255 - 50*noise(i*0.03));
    strokeWeight(dotsSize[i]);
    stroke(255 - 150/dotsSize[i]);
    point(dotsX[i], dotsY[i], dotsZ[i]);
  }
}

float prevPosX, prevPosY, prevPosZ;

void printerHome() {
  println("Home");
  prevPosX = 0;
  prevPosY = 0;
  prevPosZ = 290;
  dots = 0;
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
