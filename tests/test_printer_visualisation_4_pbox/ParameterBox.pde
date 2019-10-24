import processing.serial.*;
import processing.net.*;
import java.security.*;

class ParameterBox {
  
  float p1, p2, p3, p4, p5, p6, p7, p8, p9, p10, p11, p12, p13, p14, p15, p16;
  float[] ps;
  int P1 = 0;
  int P2 = 1;
  int P3 = 2;
  int P4 = 3;
  int P5 = 4;
  int P6 = 5;
  int P7 = 6;
  int P8 = 7;
  int P9 = 8;
  int P10 = 9;
  int P11 = 10;
  int P12 = 11;
  int P13 = 12;
  int P14 = 13;
  int P15 = 14;
  int P16 = 15;
  boolean LIN = false;
  boolean LOG = true;
  SerialMessageInterface messageInterface;
  
  int maxValue = 1000000; // max value of the step that can be received
  int[] receivedValues;
  float[] scaleMins;
  float[] scaleMaxs;
  boolean[] logScales;
  
  ParameterBox(PApplet parent, String serialNameContains) {
    this.messageInterface = new SerialMessageInterface(parent, serialNameContains, "My name is Parameter Box.");
    ps = new float[16];
    receivedValues = new int[16];
    scaleMins = new float[16];
    scaleMaxs = new float[16];
    logScales = new boolean[16];
    
    for (int i = 0; i < 16; i++) {
      scaleMins[i] = 0;
      scaleMaxs[i] = 1;
      logScales[i] = LIN;
      receivedValues[i] = maxValue / 2; // initialize to 0.5
    }
  }
  
  boolean isConnected() {
    return this.messageInterface.connected;
  }

  void update() {
    readValues();
    mapValues();
  }
  
  void readValues() {
    String message = this.messageInterface.lastMessage;
    
    if (message.length() == 0) {
      return;
    }
  
    String[] sections = message.split("; ");
    maxValue = Integer.parseInt(sections[0]);
    
    String[] numbers = sections[1].split(",");
    for (int i = 0; i < min(receivedValues.length, numbers.length); i++) {
      receivedValues[i] = Integer.parseInt(numbers[i]);
    }
  }
  
  void mapValues() {
    for (int i = 0; i < 16; i++) {
      if (logScales[i] == LIN) {
        ps[i] = map(receivedValues[i], 0, maxValue, scaleMins[i], scaleMaxs[i]);
      } else {
        ps[i] = exp(map(receivedValues[i], 0, maxValue, log(scaleMins[i]), log(scaleMaxs[i])));
      }
    }
    
    this.p1 = ps[0];
    this.p2 = ps[1];
    this.p3 = ps[2];
    this.p4 = ps[3];
    this.p5 = ps[4];
    this.p6 = ps[5];
    this.p7 = ps[6];
    this.p8 = ps[7];
    this.p9 = ps[8];
    this.p10 = ps[9];
    this.p11 = ps[10];
    this.p12 = ps[11];
    this.p13 = ps[12];
    this.p14 = ps[13];
    this.p15 = ps[14];
    this.p16 = ps[15];
  }
  
  float getValue(int p) {
    return ps[p];
  }
  
  // pbox.setScale(pbox.P2, 10, 300, pbox.LOG);
  void setScale(int p, float minValue, float maxValue, boolean logScale) {
    if (logScale) {
      if (minValue <= 0 || maxValue <= 0) {
        throw new InvalidParameterException("Log scale must be positive.");
      }
    }
    this.scaleMins[p] = minValue;
    this.scaleMaxs[p] = maxValue;
    this.logScales[p] = logScale;
    this.mapValues();
  }
  
  void setScale(int p, float minValue, float maxValue) {
    this.setScale(p, minValue, maxValue, LIN);
  }    
}




class SerialMessageInterface extends Thread {
  
  String lastMessage;
  PApplet parent;
  Serial device;
  String handShakeMessageConatains;
  int reconnectTimeout = 100;
  boolean connected = false;
  boolean verbose = false;
  String serialNameContains;

  SerialMessageInterface(PApplet parent, String serialNameContains, String handShakeMessageConatains) {
    this.serialNameContains = serialNameContains;
    this.parent = parent;
    this.handShakeMessageConatains = handShakeMessageConatains;
    this.lastMessage = "";
    this.start();
  }
  
  void run() {
    connectToDevice();
    int lastReceivedData = millis();
    while (true) {
      device.write('\n');
      delay(20);
      if (device.available() > 0) {
        while (device.available() > 0) {
          lastMessage = readLine();
          lastReceivedData = millis();
        }
      } else {
        delay(100);
      }
      
      if (millis() - lastReceivedData > reconnectTimeout) {
        connected = false;
        connectToDevice();
      }
    }
  }
  
  void connectToDevice() {
    // try to find the controller
    String port = "";
    while (port.equals("")) {
      for (String s : Serial.list()) {
        if (s.indexOf(serialNameContains) == -1) continue;
        port = s;
        try {
          device = new Serial(parent, port);
        } catch (Exception e) {
          if (verbose) {
            println("could not connect to " + port);
            e.printStackTrace();
          }
          port = "";
          continue;
        }
        
        delay(100); // magic number: hope that the device sends something in the first 100ms
        if (device.available() == 0) {
          if (verbose) println(port + " did not send anything (disconnedted)");
          port = "";
          continue;
        }
        
        String handshake = readLine();
        boolean correctHandshake = true;
        if (handshake.indexOf(handShakeMessageConatains) == -1) {
          correctHandshake = false;
          // sometimes there is some garbage in the buffer or something
          // so see if the next message is the correct one
          if (device.available() > 0) {
            handshake = readLine();
            if (handshake.indexOf(handShakeMessageConatains) != -1) {
              correctHandshake = true;
            }
          }
        }
        if (!correctHandshake) {
          print(device.available());
          if (verbose) println(port + " sent a wrong handshake (disconnedted)");
          println(handshake);
          for (int i = 0; i < 1000; i++) {
            println(readLine());
          }
          port = "";
          continue;
        }
        
        // yay we made it through all the checks. it's the right device!
        if (verbose) println(port + " looks like the right device");
        this.connected = true;
        break;        
      }
      if (port.equals("")) {
        delay(100);
      }
    }
  }
  
  String readLine() {
    String response = device.readStringUntil('\n');
    if (response == null) {
      return "";
    }
    return response.replace("\n", "").replace("\r", "");
  }
}
