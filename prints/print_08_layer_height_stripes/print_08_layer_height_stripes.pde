float baseRadius = 25;
float baseLayerHeight = 0.4;
float startH = 9;

void setup() {
  size(800, 500);
  
  noiseSeed(0);
  noiseDetail(7, 0.45);

  initPrinter();
  printerPosition(0, 0, startH, 5000);
}

void draw() {
  background(255);
  
  float z = startH;

  float da = TAU*0.001;
  float radiusT = 0;
  for (float a = 0; a < 100000; a += da) {

    float speed = 410;
    
    radiusT += da * noise(a) * 5.1;
    float radiusMultiplier = map(sin(radiusT), -1, 1, 0.92, 1.08);
    float radius = baseRadius * radiusMultiplier;

    float x = radius*sin(a);
    float y = radius*cos(a);
    
    float layerHeight = baseLayerHeight * 2 * noise(a/5.4);
    z += da / TAU * layerHeight;
        
    printerPosition(x, y, z, speed);
  }
}
