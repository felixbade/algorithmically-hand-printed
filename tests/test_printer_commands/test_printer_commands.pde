import processing.serial.*;

Serial printer;

void setup() {
  size(800, 500);
  String portName = Serial.list()[1];
  println(portName);
  printer = new Serial(this, portName, 250000);
  delay(1000);
  printerHome();
  printerPosition(0, 00, 0, 10000);
  //frameRate();
}

void draw() {
  background(255);
  float r = millis() * 0.01;
  ellipse(0, 0, r, r);
  
  for (float a = 0; a < 100000; a += TAU*0.001) {
    //float a = millis() * 0.001 * TAU * 0.05;
    float x = 60*sin(a);
    float y = 60*cos(a);
    printerPosition(x, y, 0, 200);
  }
}

void printerHome() {
  printer.write("G28\n");
  waitForPrinterOK();
}

void printerPosition(float x, float y, float z, float speed) {
  // mm, mm, mm, mm/min
  printer.write("G1 X" + x + " Y" + y + " Z" + z + " F" + speed + "\n");
  waitForPrinterOK();
}

void waitForPrinterOK() {
  while (true) {
    String response = waitAndGetPrinterStatus();
    print(response);
    if (response.indexOf("ok") != -1) {
      return;
    }
  }
}

String waitAndGetPrinterStatus() {
  while (printer.available() == 0) {
    delay(1);
  }

  if (printer.available() > 0) {
    String response = printer.readStringUntil('\n');
    if (response == null) {
      return "";
    }
    return response;
  }
  return "";
}
