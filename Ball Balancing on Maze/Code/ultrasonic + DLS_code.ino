#include <Wire.h>
#include <Digital_Light_TSL2561.h>

#define led1 10
#define led2 11

const int trig1Pin = 7;
const int echo1Pin = 6;
const int trig2Pin = 5;
const int echo2Pin = 4;
long cnt=0,duration1, inches1, cm1,duration2, inches2, cm2,prev1,prev2,mini=1000,ledVal,i=0,score1=0,score2=0;
bool flag = true;
void setup() {
  Wire.begin();
  Serial.begin(9600);
  pinMode(led1,OUTPUT);
  pinMode(led2,OUTPUT);
  TSL2561.init();
}

void loop()
{
  pinMode(trig2Pin, OUTPUT);
  digitalWrite(trig2Pin, LOW);
  delayMicroseconds(2);
  digitalWrite(trig2Pin, HIGH);
  delayMicroseconds(10);
  digitalWrite(trig2Pin, LOW);
  pinMode(echo2Pin, INPUT);
  duration2 = pulseIn(echo2Pin, HIGH);

  pinMode(trig1Pin, OUTPUT);
  digitalWrite(trig1Pin, LOW);
  delayMicroseconds(2);
  digitalWrite(trig1Pin, HIGH);
  delayMicroseconds(10);
  digitalWrite(trig1Pin, LOW);
  pinMode(echo1Pin, INPUT);
  duration1 = pulseIn(echo1Pin, HIGH);
  
  prev1 = cm1;
  prev2 = cm2;
  cnt = 1;
  cm1 = microsecondsToCentimeters(duration1);
  cm2 = microsecondsToCentimeters(duration2);
  ledVal = TSL2561.readVisibleLux();
  
  if(ledVal<50)
  {
    for(i=0;i<5;i++)
    {
      pinMode(trig2Pin, OUTPUT);
      digitalWrite(trig2Pin, LOW);
      delayMicroseconds(2);
      digitalWrite(trig2Pin, HIGH);
      delayMicroseconds(10);
      digitalWrite(trig2Pin, LOW);
      pinMode(echo2Pin, INPUT);
      duration2 = pulseIn(echo2Pin, HIGH);
    
      pinMode(trig1Pin, OUTPUT);
      digitalWrite(trig1Pin, LOW);
      delayMicroseconds(2);
      digitalWrite(trig1Pin, HIGH);
      delayMicroseconds(10);
      digitalWrite(trig1Pin, LOW);
      pinMode(echo1Pin, INPUT);
      duration1 = pulseIn(echo1Pin, HIGH);
      cm1 = microsecondsToCentimeters(duration1);
      cm2 = microsecondsToCentimeters(duration2);
      if(cm1<50 || cm2 <50)
      {
        Serial.println("Winner is 2");
        score1++;
        
        digitalWrite(led2,LOW);
        digitalWrite(led1,HIGH);
        break;
      }
    }
    if(i==5)
    {
      Serial.println("Winner is 2");
        score2++;  
        
        digitalWrite(led1,LOW);
        digitalWrite(led2,HIGH);
        exit(0);
    }
  }
  if(score1==2 || score2==2)
  {
    if(score1>score2)
    {
       digitalWrite(led2,LOW);
       digitalWrite(led1,HIGH);
       Serial.println("Winner is 1");
    }
    else
    {
        digitalWrite(led1,LOW);
        digitalWrite(led2,HIGH);
        Serial.println("Winner is 2");  
    }
    return;
  }
}

long microsecondsToCentimeters(long microseconds)
{
  return microseconds / 29 / 2;
}
