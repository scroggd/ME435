#include <LiquidCrystal.h>
LiquidCrystal lcd(14, 15, 16, 17, 18, 19, 20);

int led_pins[6] = {64, 65, 66, 67, 68, 69};
int button_pins[2] = {3, 2};

void setup() {
  
  // LED init
  for(int i=0; i<6; i++){
    pinMode(led_pins[i], OUTPUT);
  }
  
  // Button init
  for(int i=0; i<2; i++){
    pinMode(button_pins[i], INPUT_PULLUP);
  }
  
  lcd.begin(16, 2);
  lcd.print("hello, world!");
}

void loop() {
  lcd.setCursor(0, 1);
  lcd.print(millis()/1000);
}
