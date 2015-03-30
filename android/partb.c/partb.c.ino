int led_pins[6] = {64, 65, 66, 67, 68, 69};
int button_pins[2] = {2, 3};

void setup() {
  
  // LED init
  for(int i=0; i<6; i++){
    pinMode(led_pins[i], OUTPUT);
  }
  
  // Button init
  for(int i=0; i<2; i++){
    pinMode(button_pins[i], INPUT_PULLUP);
  }
}

void loop() {
  if( !digitalRead(button_pins[0])){
    digitalWrite(led_pins[0], HIGH);
  }else{
    digitalWrite(led_pins[0], HIGH);
  }
  
  if( !digitalRead(button_pins[1])){
    digitalWrite(led_pins[1], HIGH);
  }else{
    digitalWrite(led_pins[1], HIGH);
  }
    
}
