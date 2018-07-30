import RPi.GPIO as GPIO          
import time                      
GPIO.setwarnings(False)          
GPIO.setmode(GPIO.BCM)          
GPIO.setup(26,GPIO.OUT)

p = GPIO.PWM(26,1000)          #GPIO19 as PWM output, with 100Hz frequency
p.start(0)                              #generate PWM signal with 0% duty cycle
while 1:                               #execute loop forever
    for x in range (100):                          #execute loop for 50 times, x being incremented from 0 to 49.
        p.ChangeDutyCycle(x)               #change duty cycle for varying the brightness of LED.
        time.sleep(0.02)                           #sleep for 100m second
      
    for x in range (100):                         #execute loop for 50 times, x being incremented from 0 to 49.
        p.ChangeDutyCycle(100-x)        #change duty cycle for changing the brightness of LED.
        time.sleep(0.02)                          #sleep for 100m second
p.stop()
GPIO.cleanup()
