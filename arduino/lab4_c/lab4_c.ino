#include <RobotAsciiCom.h>
#include <Servo.h>
#include <ArmServos.h>
#include <LiquidCrystal.h>

#define DEBOUNCE_DELAY 30

ArmServos robotArm(12, 11, 10, 9, 8, 6);

RobotAsciiCom robotCom;

LiquidCrystal lcd(14, 15, 16, 17, 18, 19, 20);

int led_pins[6] = {64, 65, 66, 67, 68, 69};
int button_pins[2] = {2, 3};
int select_pin = 21;
int vert_analog = 1;
int horz_analog = 0;

int selected_led = 0;

int button_pushed[2] = {0, 0};

int joint_angles[6] = {0, 90, 0, -90, 90, 35};
int joint_center_angles[6] = {0, 90, 0, -90, 90, 35};
int joint_min_angles[6] = {-90, 0, -90, -180, 0, -10};
int joint_max_angles[6] = {90, 180, 90, 0, 180, 80};

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
  Servo
  update_selection();
  
  lcd.begin(16, 2);
  
  robotArm.attach();
  
  Serial.begin(9600);
  robotCom.registerPositionCallback(positionCallback);
  robotCom.registerJointAngleCallback(jointAngleCallback);
  robotCom.registerGripperCallback(gripperCallback);
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
  
  while(Serial.available() > 0){
    robotCom.handleRxByte(Serial.read());
  }
  
  update_lcd();
  
  for(int i=0; i<5; i++){
    robotArm.setJointAngle(i+1, joint_angles[i]);
  }
  robotArm.setGripperDistance(joint_angles[5]);
  
}

void positionCallback(int a1, int a2, int a3, int a4, int a5){
  joint_angles[0] = constrain(a1, joint_min_angles[0], joint_max_angles[0]);
  joint_angles[1] = constrain(a2, joint_min_angles[1], joint_max_angles[1]);
  joint_angles[2] = constrain(a3, joint_min_angles[2], joint_max_angles[2]);
  joint_angles[3] = constrain(a4, joint_min_angles[3], joint_max_angles[3]);
  joint_angles[4] = constrain(a5, joint_min_angles[4], joint_max_angles[  4]);
}

void jointAngleCallback(byte joint, int angle){
  joint_angles[joint-1] = constrain(angle, joint_min_angles[joint-1], joint_max_angles[joint-1]);
}

void gripperCallback(int distance){
  joint_angles[5] = constrain(distance, joint_min_angles[5], joint_max_angles[5]);
}

void adjust_angle(int mod){
  joint_angles[selected_led] += mod;
  joint_angles[selected_led] = constrain(joint_angles[selected_led], joint_min_angles[selected_led], joint_max_angles[selected_led]);
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
  joint_angles[selected_led] = joint_center_angles[selected_led];
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
    
