float baseRadius = 25;
float baseLayerHeight = 0.4;
float startH = 9;

ParameterBox p;

void setup() {
  size(800, 500);
  
  p = new ParameterBox(this, "usbmodem");

  noiseSeed(0);
  noiseDetail(5, 0.45);

  initPrinter();
  printerPosition(0, 0, startH, 5000);
}

void draw() {
  background(0);
  
  strokeWeight(10);
  translate(width/2, height/2, 0);
  scale(height/200.0);

  p.setScale(p.P8, -TAU/2, TAU/2, p.LIN);
  p.setScale(p.P12, -TAU/4, TAU/4, p.LIN);

  noCursor();
  rotateX(TAU/4);
  rotateX(-(mouseY - height/2) / 150.0);
  rotateX(p.p12);
  rotateZ(-(mouseX - width/2) / 200.0);
  rotateZ(p.p8);
  
  lights();
  
  p.update();
  
  p.setScale(p.P1, 1, 1000, p.LOG);
  p.setScale(p.P2, 1, 1000, p.LOG);
  
  p.setScale(p.P5, 3, 1000, p.LOG);
  p.setScale(p.P6, 3, 1000, p.LOG);
  
  p.setScale(p.P9, 3, 1000, p.LOG);
  p.setScale(p.P10, 3, 1000, p.LOG);
  
  p.setScale(p.P3, 0.1, 10, p.LOG);
  scale(p.p3);
  translate(0, 0, -20);

  p.setScale(p.P4, 0.1, 10, p.LOG);
  p.setScale(p.P7, 0.001, 1, p.LOG);

  float z = startH;

  float da = TAU*0.001;
  float radiusT = 0;
  for (float a = 0; a < 100000; a += da) {
    
    // helix
    float speed = 410;
    
    radiusT += da * noise(a) * 5.1;
    float radiusMultiplier = map(sin(radiusT), -1, 1, 0.95, 1.05);
    float radius = baseRadius * radiusMultiplier;

    float x = radius*sin(a);
    float y = radius*cos(a);
    
    float layerHeight = baseLayerHeight * 2 * noise(a/30);
    z += da / TAU * layerHeight;
    
    
    //noise
    float horAmp = p.p1;
    float hor2horFreq = p.p5;
    float ver2horFreq = p.p9;
    
    float verAmp = p.p2;
    float hor2verFreq = p.p6;
    float ver2verFreq = p.p10;

    float dx = horAmp * (noise(x/hor2horFreq + 1000, y/hor2horFreq + 1000, 1000 + z/ver2horFreq) - 0.5);
    float dy = horAmp * (noise(x/hor2horFreq + 2000.5, y/hor2horFreq + 1000.5, 1000 + z/ver2horFreq) - 0.5);
    float dz = verAmp * (noise(x/hor2verFreq + 3000, y/hor2verFreq + 1000, 1000 + z/ver2verFreq) - 0.5);

    float dzm = 1 - exp(-z * p.p7);

    //float speed = 400;//100+300*noise(3 * a * p.p4);
    
    printerPosition(x + dx, y + dy, z + dz * dzm, speed);
  }
}
