/* example of using wiring pi                                               */
/* from:                                                                    */
/* http://fritzing.org/projects/simple-raspberry-pi-led-example             */
/*                                                                          */
/* Assumes you have the WiringPi library installed (http://wiringpi.com/).  */

#include <wiringPi.h>

int main (void)
{
   int offset;
   offset = 100;
   wiringPiSetup () ;
   pinMode(0, OUTPUT);
   pinMode(2, OUTPUT);
   pinMode(3, OUTPUT);
   for (;;) // Loop continously
   {
      digitalWrite (0, HIGH) ;
      delay(offset); // delay 'offset' miliseconds
      digitalWrite(0, LOW); // turn off 0
      digitalWrite(2, HIGH); // turn on 2
      delay(offset);
      digitalWrite(2, LOW); // turn off 2
      digitalWrite(3, HIGH); // turn on 3
      delay (offset);
      digitalWrite(3, LOW); // turn off 3
   } // Loop back and start over
   return 0 ;
}
