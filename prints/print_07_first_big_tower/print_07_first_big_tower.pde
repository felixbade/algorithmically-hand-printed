float baseRadius = 25;
float baseLayerHeight = 0.3;
float startH = 9;

void setup() {
  size(800, 500);  
  noiseSeed(0);
  noiseDetail(7, 0.45);

  initPrinter();
}

void draw() {
  background(255);
  
  float z = startH;

  float da = TAU*0.001;
  float radiusT = 0;
  for (float a = 0; a < 100000; a += da) {

    // P1 = 410
    float speed = 410;
    
    // P2 = 5.1
    radiusT += da * noise(a) * 5.1;
    float radiusMultiplier = map(sin(radiusT), -1, 1, 0.92, 1.08);
    float radius = baseRadius * radiusMultiplier;

    float x = radius*sin(a);
    float y = radius*cos(a);
    
    // P3 = 1.3
    float layerHeight = baseLayerHeight * 1.3;
    z += da / TAU * layerHeight;
    
    // P5 = 3.1
    float noiseAmplitude = 3.1;
    // P6 = 0.37
    float noiseSize = 0.37;
    float dz = noiseAmplitude * (noise(x*noiseSize, y*noiseSize, z*noiseSize) - 0.5);
    
    printerPosition(x, y, z + dz, speed);
  }
}
