/*
 SineWavePoints
 
 Write sine wave points to the serial port, followed by the Carriage Return and LineFeed terminator.
 */

int i = 0;

// The setup routine runs once when you press reset:
void setup() {
  // Initialize serial communication at 9600 bits per second:
  Serial.begin(112500);
}

// The loop routine runs over and over again forever:
void loop() {
  // Write the sinewave points, followed by the terminator "Carriage Return" and "Linefeed".
  double s =sin(i*50.0/360.0);
  Serial.print(s*8191);
  Serial.write(13);
  Serial.write(10);
  i += 1;
}
