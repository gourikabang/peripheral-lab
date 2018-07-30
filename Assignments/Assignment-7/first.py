import RPi.GPIO as GPIO
import time
GPIO.setmode(GPIO.BCM)

A = 4
B = 17
C = 13
D = 19
E = 26
period = 10.0

GPIO.setup(A,GPIO.OUT)
GPIO.setup(B,GPIO.OUT)

GPIO.setup(C,GPIO.IN)
GPIO.setup(D,GPIO.IN)
GPIO.setup(E,GPIO.IN)


# Set trigger to False (Low)
GPIO.output(A, False)
GPIO.output(B, False)

# Allow module to settle
time.sleep(0.5)

while 1:

    while GPIO.input(C)==0:
        GPIO.output(A,True)
        time.sleep(period)
        GPIO.output(A,False)
        GPIO.output(B,True)
        time.sleep(period)
        GPIO.output(B,False)
    
    while GPIO.input(D)==1:
        GPIO.output(A,True)
        time.sleep(period/2)
        GPIO.output(A,False)
        GPIO.output(B,True)
        time.sleep(period/2)
        GPIO.output(B,False)

    if GPIO.input(E) ==0:
        GPIO.output(A, False)
        GPIO.output(B, False)
        time.sleep(5)
        break
GPIO.cleanup()
