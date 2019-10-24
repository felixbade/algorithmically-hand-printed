ParameterBox p;

void setup() {
  fullScreen();
  pixelDensity(displayDensity());
  
  p = new ParameterBox(this, "usbmodem");

  noiseDetail(7, 0.45);
  noiseSeed(0);
}

void draw() {
  background(255);
  noStroke();
  fill(255);
  stroke(0);
  
  p.update();

  p.setScale(p.P1, 1, 1000, p.LOG);
  float noiseSize = p.p1; // 5.4
  p.setScale(p.P2, 1, 1000, p.LOG);
  float noiseAmp = p.p2; // 20
  
  println(p.p1, p.p2);

  int y = 0;
  float t = 0;
  while (y < height) {
    float h = noiseAmp * noise(t/noiseSize);
    //fill(255*noise(t));
    rect(0, y, width, y+h);
    y += h;
    
    t += TAU;
  }
}
