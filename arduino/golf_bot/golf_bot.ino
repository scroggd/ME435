#include <EEPROM.h>
#include <Max3421e.h>
#include <Usb.h>
#include <AndroidAccessory.h>
#include <LiquidCrystal.h>
#include <RobotAsciiCom.h>
#include <WildThumperCom.h>
#include <GolfBallStand.h>


#define TEAM_NUMBER 7  // Replace this with your team number.

char manufacturer[] = "Rose-Hulman";
char model[] = "GolfBot";  // Change to your app name.
char versionStr[] = "1.0";
        
// Only Manufacturer, Model, and Version matter to Android
AndroidAccessory acc(manufacturer,
                     model,
                     "ME435 robot arm golf bot.",
                     versionStr,
                     "https://sites.google.com/site/me435spring2013/",
                     "12345");

byte rxBuf[255];
char txBuf[64];
int batteryVoltageReplyLength = 0;
int wheelCurrentReplyLength = 0;
// Note, when sending commands <b>to</b> Android I don't add the '\n'.
// Turned out to be easier since the whole message arrives together.

// Just a random set of scripts that you might make for testing.
char placeBallOn1Script[] = "place_ball_on_1";
char placeBallOn2Script[] = "place_ball_on_2";
char placeBallOn3Script[] = "place_ball_on_3";
char black1Script[] = "black_1";
char nonblack1Script[] = "nonblack_1";
char black2Script[] = "black_2";
char nonblack2Script[] = "nonblack_2";
char black3Script[] = "black_3";
char nonblack3Script[] = "nonblack_3";

/***  Pin I/O   ***/ 
#define PIN_RIGHT_BUTTON 2
#define PIN_LEFT_BUTTON 3
#define PIN_SELECT_BUTTON 21

/*** Interrupt flags ***/
volatile int mainEventFlags = 0;
#define FLAG_INTERRUPT_0                   0x0001
#define FLAG_INTERRUPT_1                   0x0002
#define FLAG_INTERRUPT_2                   0x0004
#define FLAG_NEED_TO_SEND_BATTERY_VOLTAGE  0x0008
#define FLAG_NEED_TO_SEND_WHEEL_CURRENT    0x0010

LiquidCrystal lcd(14, 15, 16, 17, 18, 19, 20);
#define LINE_1 0
#define LINE_2 1

RobotAsciiCom robotAsciiCom;
WildThumperCom wildThumperCom(TEAM_NUMBER);
GolfBallStand gbs;

void setup() {
  Serial.begin(9600);  // Change if you are using a different baudrate.
  pinMode(PIN_LEFT_BUTTON, INPUT_PULLUP);
  pinMode(PIN_RIGHT_BUTTON, INPUT_PULLUP);
  pinMode(PIN_SELECT_BUTTON, INPUT_PULLUP);
  
  // Register callbacks for commands you might receive from Android.
  robotAsciiCom.registerWheelSpeedCallback(wheelSpeedMessageFromAndroid);
  robotAsciiCom.registerPositionCallback(positionMessageFromAndroid);
  robotAsciiCom.registerJointAngleCallback(jointAngleMessageFromAndroid);
  robotAsciiCom.registerGripperCallback(gripperMessageFromAndroid);
  robotAsciiCom.registerAttachSelectedServosCallback(attachSelectedServosCallback);
  robotAsciiCom.registerBatteryVoltageRequestCallback(batteryVoltageRequestFromAndroid);
  robotAsciiCom.registerWheelCurrentRequestCallback(wheelCurrentRequestFromAndroid);
  robotAsciiCom.registerCustomStringCallback(customStringCallbackFromAndroid);
  
  // Register callbacks for commands you might receive from the Wild Thumper.
  wildThumperCom.registerBatteryVoltageReplyCallback(batteryVoltageReplyFromThumper);
  wildThumperCom.registerWheelCurrentReplyCallback(wheelCurrentReplyFromThumper);
  
  lcd.clear();
  lcd.print("Golf Bot");
  delay(1500);
  acc.powerOn();
}

void wheelSpeedMessageFromAndroid(byte leftMode, byte rightMode, byte leftDutyCycle, byte rightDutyCycle) {
  wildThumperCom.sendWheelSpeed(leftMode, rightMode, leftDutyCycle, rightDutyCycle);  
  lcd.clear();
  lcd.print("Wheel speed:");
  lcd.setCursor(0, LINE_2);
  lcd.print("L");
  lcd.print(leftMode);
  lcd.print(" R");
  lcd.print(rightMode);
  lcd.print(" L");
  lcd.print(leftDutyCycle);
  lcd.print(" R");
  lcd.print(rightDutyCycle);
}

void positionMessageFromAndroid(int joint1Angle, int joint2Angle, int joint3Angle, int joint4Angle, int joint5Angle) {
  wildThumperCom.sendPosition(joint1Angle, joint2Angle, joint3Angle, joint4Angle, joint5Angle);  
  lcd.clear();
  lcd.print("Position:");
  lcd.setCursor(0, LINE_2);
  lcd.print(joint1Angle);
  lcd.print(" ");
  lcd.print(joint2Angle);
  lcd.print(" ");
  lcd.print(joint3Angle);
  lcd.print(" ");
  lcd.print(joint4Angle);
  lcd.print(" ");
  lcd.print(joint5Angle);
}

void jointAngleMessageFromAndroid(byte jointNumber, int jointAngle) {
  wildThumperCom.sendJointAngle(jointNumber, jointAngle);
  lcd.clear();
  lcd.print("Joint angle:");
  lcd.setCursor(0, LINE_2);
  lcd.print("J");
  lcd.print(jointNumber);
  lcd.print(" move to ");
  lcd.print(jointAngle);
}

void gripperMessageFromAndroid(int gripperDistance) {
  gripperDistance = constrain(gripperDistance, 10, 65);
  wildThumperCom.sendGripperDistance(gripperDistance);
  lcd.clear();
  lcd.print("Gripper:");
  lcd.setCursor(0, LINE_2);
  lcd.print("Gripper to ");
  lcd.print(gripperDistance);
}
   
void attachSelectedServosCallback(byte servosToEnable) {
  wildThumperCom.sendAttachSelectedServos(servosToEnable);
  lcd.clear();
  lcd.print("Attach:");
  lcd.setCursor(0, LINE_2);
  lcd.print("54321G = ");
  lcd.print(servosToEnable, BIN);
}

void batteryVoltageRequestFromAndroid(void) {
  wildThumperCom.sendBatteryVoltageRequest();
}

void wheelCurrentRequestFromAndroid(void) {
  wildThumperCom.sendWheelCurrentRequest();
}

char colorReply[10] = "COLOR XXX";
void customStringCallbackFromAndroid(String customString) {
  lcd.clear();
  if (customString.equalsIgnoreCase("my custom command")) {
    lcd.print("Known CUSTOM");
    // perform that command
  }else if(customString.equalsIgnoreCase("BALL COLORS")){
    char c1 = gbs.determineBallColorChar(LOCATION_1);
    char c2 = gbs.determineBallColorChar(LOCATION_2);
    char c3 = gbs.determineBallColorChar(LOCATION_3);
    
    lcd.print("Colors: ");
    lcd.print(c1);
    lcd.print(c2);
    lcd.print(c3);
  
  lcd.setCursor(0, LINE_2);
  lcd.print(customString);
  lcd.setCursor(0, LINE_2);
  lcd.print(customString);
    colorReply[6] = c1;
    colorReply[7] = c2;
    colorReply[8] = c3;
    acc.write(colorReply, 10);
    
  } else {
    lcd.print("Unknown CUSTOM");
    lcd.setCursor(0, LINE_2);
    lcd.print(customString);
  }
}

void batteryVoltageReplyFromThumper(int batteryMillivolts) {
  // Send to Android from within the main event loop.
  mainEventFlags |= FLAG_NEED_TO_SEND_BATTERY_VOLTAGE;
  batteryVoltageReplyLength = robotAsciiCom.prepareBatteryVoltageReply(
      batteryMillivolts, txBuf, sizeof(txBuf));
  // Display battery voltage on LCD.
  lcd.clear();
  lcd.print("Battery voltage:");
  lcd.setCursor(0, LINE_2);
  lcd.print(batteryMillivolts / 1000);
  lcd.print(".");
  if (batteryMillivolts % 1000  < 100) {
    lcd.print("0");
  }
  if (batteryMillivolts % 1000 < 10) {
    lcd.print("0");
  }
  lcd.print(batteryMillivolts % 1000);
}

void wheelCurrentReplyFromThumper(int leftWheelMotorsMilliamps, int rightWheelMotorsMilliamps) {
  // Send to Android from within the main event loop.
  mainEventFlags |= FLAG_NEED_TO_SEND_WHEEL_CURRENT;
  wheelCurrentReplyLength = robotAsciiCom.prepareWheelCurrentReply(
      leftWheelMotorsMilliamps, rightWheelMotorsMilliamps, txBuf, sizeof(txBuf));

  // Display wheel currents on LCD.
  lcd.clear();
  lcd.print("Wheel current:");
  lcd.setCursor(0, LINE_2);
  lcd.print(leftWheelMotorsMilliamps / 1000);
  lcd.print(".");
  if (leftWheelMotorsMilliamps % 1000  < 100) {
    lcd.print("0");
  }
  if (leftWheelMotorsMilliamps % 1000 < 10) {
    lcd.print("0");
  }
  lcd.print(leftWheelMotorsMilliamps % 1000);
  lcd.print("  ");
  lcd.print(rightWheelMotorsMilliamps / 1000);
  lcd.print(".");
  if (rightWheelMotorsMilliamps % 1000  < 100) {
    lcd.print("0");
  }
  if (rightWheelMotorsMilliamps % 1000 < 10) {
    lcd.print("0");
  }
  lcd.print(rightWheelMotorsMilliamps % 1000);
}

void loop() {
  
  
  // See if there is a new message from Android.
  if (acc.isConnected()) {
    int len = acc.read(rxBuf, sizeof(rxBuf), 1);
    if (len > 0) {
      robotAsciiCom.handleRxBytes(rxBuf, len);
    }
    
    
    // Passing commands from the Wild Thumper on up to Android.
    if (mainEventFlags & FLAG_NEED_TO_SEND_BATTERY_VOLTAGE) {
      mainEventFlags &= ~FLAG_NEED_TO_SEND_BATTERY_VOLTAGE;
      acc.write(txBuf, batteryVoltageReplyLength);
    }
    if (mainEventFlags & FLAG_NEED_TO_SEND_WHEEL_CURRENT) {
      mainEventFlags &= ~FLAG_NEED_TO_SEND_WHEEL_CURRENT;
      acc.write(txBuf, wheelCurrentReplyLength);
    }
  }
  
  // See if there is a new message from the Wild Thumper.
  if (Serial.available() > 0) {
    wildThumperCom.handleRxByte(Serial.read());
  }
 
  if ( (!digitalRead(PIN_RIGHT_BUTTON)) && (!digitalRead(PIN_LEFT_BUTTON)) ) {
      gbs.calibrate(lcd);
  }
  
}
