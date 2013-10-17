#include <SoftwareSerial.h>
#include <max6675.h>

int GND = 8;
int VCC = 9;

int thermoDataOut = 10;
int thermoChipSelect = 11;
int thermoClock = 12;

int bleTX = 2;
int bleRX = 3;

SoftwareSerial bleShield(bleTX, bleRX);

MAX6675 thermo(thermoClock, thermoChipSelect, thermoDataOut);

void setup() {
  pinMode(GND, OUTPUT);
  pinMode(VCC, OUTPUT);

  digitalWrite(GND, LOW);	// Power the thermocouple
  digitalWrite(VCC, HIGH);	// amplifier

  bleShield.begin(19200);	// Init the BLE Shield Serial
  Serial.begin(19200); 		// Init the serial port

  delay(500);  
}

void loop() {
  double tempC = thermo.readCelsius();	// Read the temperature
    
  Serial.print(tempC);		// Send the temperature to both
  bleShield.print(tempC);	// the serial port and BLE Shield
  
  Serial.println("C");
  bleShield.print("C          ");	// Need to pad the data to
					// the BLE Shield
    
  delay(1000); 			// Wait a second
}
