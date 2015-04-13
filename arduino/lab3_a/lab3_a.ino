#include <LiquidCrystal.h>
#include <Servo.h>

#define DEBOUNCE_DELAY 30

Servo servo;
int servo_pins[6] = {12, 11, 10, 9, 8, 6};
LiquidCrystal lcd(14, 15, 16, 17, 18, 19, 20);

int led_pins[6] = {64, 65, 66, 67, 68, 69};
int button_pins[2] = {2, 3};
int select_pin = 21;
int vert_analog = 1;
int horz_analog = 0;

int selected_led = 0;

int button_pushed[2] = {0, 0};

int joint_angles[6] = {90, 90, 90, 90, 90, 90};

int next_joystick_read = 0;


void setup() {
  
  for(int i=0; i<6; i++){
    pinMode(led_pins[i], OUTPUT);
  }
  
  for(int i=0; i<2; i++){
    pinMode(button_pins[i], INPUT_PULLUP);
  }
  pinMode(select_pin, INPUT_PULLUP);
  
  attachInterrupt(1, dec, FALLING);
  attachInterrupt(0, inc, FALLING);
  attachInterrupt(2, select, FALLING);
  
  update_selection();
  
  lcd.begin(16, 2);
  
}

void loop() {
  
  if(button_pushed[0] != 0){
    if(millis() - button_pushed[0] > DEBOUNCE_DELAY){
      if(!digitalRead(button_pins[0])){
        selected_led++;
        update_selection();
      }
      button_pushed[0] = 0;
    }
  }
  
  if(button_pushed[1] != 0){
    if(millis() - button_pushed[1] > DEBOUNCE_DELAY){
      if(!digitalRead(button_pins[1])){
        selected_led--;
        update_selection();
      }
      button_pushed[1] = 0;
    }
  }
  
  int time = millis();
  if(time > next_joystick_read){
    int horz_reading = analogRead(horz_analog);
    int vert_reading = analogRead(vert_analog);
    
    bool not_done = true;
    
    if(vert_reading > 900 && not_done){
      adjust_angle(4);
      next_joystick_read = time + 100;
      not_done = false;
    }
    
    if(vert_reading < 100 && not_done){
      adjust_angle(-4);
      next_joystick_read = time + 100;
      not_done = false;
    }
    
    if(horz_reading > 900 && not_done){
      adjust_angle(-1);
      next_joystick_read = time + 100;
      not_done = false;
    }

    
    if(horz_reading < 100 && not_done){
      adjust_angle(1);
      next_joystick_read = time + 100;
      not_done = false;
    }
  }
  
  
  update_lcd();
  
}

void adjust_angle(int mod){
  joint_angles[selected_led] += mod;
  
  if(joint_angles[selected_led] > 180)
    joint_angles[selected_led] = 180;
  if(joint_angles[selected_led] < 0)
    joint_angles[selected_led] = 0;
  
  servo.attach(selected_led);
  servo.write(joint_angles[selected_led]);
}

char lcd_buff[16];
void update_lcd(){
  lcd.setCursor(0, 0);
  sprintf(lcd_buff, "%4d %4d %4d", joint_angles[0], joint_angles[1], joint_angles[2]);
  lcd.print(lcd_buff);
  
  lcd.setCursor(0, 1);
  sprintf(lcd_buff, "%4d %4d %4d", joint_angles[3], joint_angles[4], joint_angles[5]);
  lcd.print(lcd_buff);
  
}

void inc(){
  if(button_pushed[0] == 0){
    button_pushed[0] = millis();
  }
}

void dec(){
  if(button_pushed[1] == 0){
    button_pushed[1] = millis();
  } 
}

void select(){
  joint_angles[selected_led] = 90;
}

void update_selection(){
  if(selected_led > 5)
    selected_led = 0;
  if(selected_led < 0)
    selected_led = 5;
  
  for(int i=0; i<6; i++){
    digitalWrite(led_pins[i], ((i == selected_led) ? HIGH : LOW));
  }
}
    
