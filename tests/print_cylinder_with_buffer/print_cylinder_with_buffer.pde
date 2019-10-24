import processing.serial.*;

Serial printer;

float radius = 35;
float layerHeight = 0.8;
float startH = 1;

void setup() {
  size(800, 500);
  String portName = Serial.list()[1];
  println(portName);
  printer = new Serial(this, portName, 250000);
  delay(1000);
  printerHome();
  printerPosition(0, radius, startH, 3000, true);
  //frameRate();
}

void draw() {
  background(255);
  
  for (float a = 0; a < 100000; a += TAU*0.001) {
    //float a = millis() * 0.001 * TAU * 0.05;
    float x = radius*sin(a);
    float y = radius*cos(a);
    float z = startH+layerHeight * a / TAU;
    printerPosition(x, y, z, 400+400*noise(3*a), true);
  }
}

void printerHome() {
  printer.write("G28\n");
  waitForPrinterOK();
}

void printerPosition(float x, float y, float z, float speed, boolean waitForOK) {
  // mm, mm, mm, mm/min
  //String message = "G1 X" + x + " Y" + y + " Z" + z + " F" + speed + "\n";
  String message = String.format("G1 X%.2f Y%.2f Z%.2f F%.2f\n", x, y, z, speed).replace(",", ".");
  print("<- " + message);
  printer.write(message);
  
  if (waitForOK) {
    waitForPrinterOK();
  }
}

void waitForPrinterOK() {
  while (true) {
    String response = waitAndGetPrinterStatus();
    if (response.length() != 0) {
      print("-> " + response);
    }
    
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
