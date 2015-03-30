#include <Max3421e_constants.h>
#include <Max3421e.h>
#include <Max_LCD.h>
#include <ch9.h>
#include <Usb.h>

#include <AndroidAccessory.h>



#define PIN_LED 13

char manufacturer[] = "Rose-Hulman";
char model[] = "LED Toggle";
char versionStr[] = "1.0";

char rxBuf[255];
AndroidAccessory acc(manufacturer, model, "", versionStr, "", "1");

void setup() {
  Serial.begin(9600);
  while(!Serial);
  Serial.println("Serial connection ready");
  
  delay(1500);
  Serial.println("Delayed");
  acc.powerOn();
  Serial.println("Power");

}

void loop() {
  if(acc.isConnected()){
    int len = acc.read(rxBuf, sizeof(rxBuf), 1);
    if(len > 0){
      rxBuf[len-1] = '\0';
      String inputString = String(rxBuf);
      Serial.println(inputString);
      
      if(inputString.equalsIgnoreCase("ON")){
        digitalWrite(PIN_LED, 1);
      }else if(inputString.equalsIgnoreCase("OFF")){
        digitalWrite(PIN_LED, 0);
      }
    }
  }
}
