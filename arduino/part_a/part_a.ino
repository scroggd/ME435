int led_pins[6] = {64, 65, 66, 67, 68, 69};

void setup() {
  for(int i=0; i<6; i++){
    pinMode(led_pins[i], OUTPUT);
  }
}

void loop() {
  int position = 0;
  int direction = 1;
  
  while(true){
    digitalWrite(led_pins[position], HIGH);
    delay(100);
    
    digitalWrite(led_pins[position], LOW);
    position += direction;
    
    if(position == 6){
      position = 4;
      direction *= -1;
    }
    if(position == -1){
      position = 1;
      direction *= -1;
    }
    
  }
}
