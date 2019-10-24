import processing.serial.*;

Serial printer;

void initPrinter() {
  String portName = Serial.list()[2];
  println(portName);
  printer = new Serial(this, portName, 250000);
  delay(1000);
  printerHome();
}

void printerHome() {
  printer.write("G28\n");
  waitForPrinterOK();
}

void printerPosition(float x, float y, float z, float speed) {
  // mm, mm, mm, mm/min
  //String message = "G1 X" + x + " Y" + y + " Z" + z + " F" + speed + "\n";
  String message = String.format("G1 X%.2f Y%.2f Z%.2f F%.2f\n", x, y, z, speed).replace(",", ".");
  print("<- " + message);
  printer.write(message);
  
  boolean waitForOK = true;
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
