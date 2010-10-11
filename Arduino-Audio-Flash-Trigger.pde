/* 	Audio camera trigger by Matt Richardson
	This is a basic sound-detecting camera & flash trigger for Arduino.
	Use a piezo element for the sensor (see http://www.arduino.cc/en/Tutorial/KnockSensor)
	Use opto isolators (aka optocouplers) for the flash and camera triggers
	Camera must be in BULB mode for this to work.
*/

#define BUTTON_PIN 10
#define CAM_TRIGGER_PIN 11
#define FLASH_TRIGGER_PIN 12
#define SENSOR_PIN 0
#define LED_PIN 13
#define STANDBY 0
#define ACTIVE 1
#define SENSOR_TRESHOLD 0

int mode = STANDBY;
long flashDelayMS = 0;

void setup() {
	pinMode(BUTTON_PIN, INPUT);
	pinMode(CAM_TRIGGER_PIN, OUTPUT);
	pinMode(FLASH_TRIGGER_PIN, OUTPUT);
	pinMode(LED_PIN, OUTPUT);
	digitalWrite(LED_PIN, HIGH);
}


void loop() {
	if (digitalRead(BUTTON_PIN) == HIGH)  
	{
		mode = ACTIVE;
		delay(1000);  // to give time to settle after button push
		digitalWrite(LED_PIN, LOW);
		digitalWrite(CAM_TRIGGER_PIN, HIGH); // open the camera shutter
	}
	if ((mode == ACTIVE) && (analogRead(SENSOR_PIN) > SENSOR_THRESHOLD)) //
	{ //If we're in ACTIVE mode and we sense a pop:
		delay(flashDelayMS);
		digitalWrite(FLASH_TRIGGER_PIN, HIGH);
		delay(50);
		digitalWrite(FLASH_TRIGGER_PIN, LOW);
		digitalWrite(CAM_TRIGGER_PIN, LOW); // close camera shutter
		mode = STANDBY;
		digitalWrite(LED_PIN, HIGH);
	}
}