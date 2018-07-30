#include <Servo.h>
#include<Wire.h>

Servo myservo1;
Servo myservo2;

#define MPU_addr1  0x68
#define MPU_addr2  0x69

#define GYRO_ZOUT_H  0x47
#define GYRO_ZOUT_L  0x48

int16_t z1,z2;

void setup(){
  Wire.begin();
  
  Wire.beginTransmission(MPU_addr1);
  Wire.write(0x6B);
  Wire.write(0);  
  Wire.endTransmission(true);
  
  Wire.beginTransmission(MPU_addr2);
  Wire.write(0x6B);
  Wire.write(0);
  Wire.endTransmission(true);
  
  myservo1.attach(8);
  myservo2.attach(10);
  
  Serial.begin(9600);
}
void loop(){
  Wire.beginTransmission(MPU_addr1);
  Wire.write(0x3B);  // starting with register 0x3B (ACCEL_XOUT_H)
  Wire.endTransmission(false);
  Wire.requestFrom(MPU_addr1,6,true);
  
  z1=Wire.read()<<8|Wire.read();  // 0x43 (GYRO_XOUT_H) & 0x44 (GYRO_XOUT_L)
  z1=Wire.read()<<8|Wire.read();  // 0x45 (GYRO_YOUT_H) & 0x46 (GYRO_YOUT_L)
  z1=Wire.read()<<8|Wire.read();  // 0x47 (GYRO_ZOUT_H) & 0x48 (GYRO_ZOUT_L)
  if(z1<-7000)
  {
    Serial.print(1);
    myservo1.write(150);
  }
  else if(z1>4000)
  {
    Serial.print(-1);
    myservo1.write(40);
  }
  else
  {
    Serial.print(0);
    myservo1.write(90);
  }
  delay(50);
  Wire.beginTransmission(MPU_addr2);
  Wire.write(0x3B);
  Wire.endTransmission(false);
  Wire.requestFrom(MPU_addr2,6,true);
  
  z2=Wire.read()<<8|Wire.read();  // 0x43 (GYRO_XOUT_H) & 0x44 (GYRO_XOUT_L)
  z2=Wire.read()<<8|Wire.read();  // 0x45 (GYRO_YOUT_H) & 0x46 (GYRO_YOUT_L)
  z2=Wire.read()<<8|Wire.read();  // 0x47 (GYRO_ZOUT_H) & 0x48 (GYRO_ZOUT_L)
  if(z2<-7000)
  {
    Serial.println(1);
    myservo2.write(150);
  }
  else if(z2>4000)
  {
    Serial.println(-1);
    myservo2.write(40);
  }
  else
  {
    Serial.println(0);
    myservo2.write(90);
  }
  delay(50);
}
