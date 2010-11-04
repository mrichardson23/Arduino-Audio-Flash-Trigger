/* 	Audio camera trigger by Matt Richardson
	This is a basic sound-detecting camera & flash trigger for Arduino.
	Use a piezo element for the sensor (see http://www.arduino.cc/en/Tutorial/KnockSensor)
	Use opto isolators (aka optocouplers) for the flash and camera triggers
	Camera must be in BULB mode for shutter release to work
*/

#define BUTTON_PIN 5
#define CAM_TRIGGER_PIN 11
#define FLASH_TRIGGER_PIN 12
#define SENSOR_PIN 0
#define LED_PIN 10
#define STANDBY 0
#define ACTIVE 1
#define WORKLIGHT_RELAY 9
#define SENSOR_THRESHOLD 0

int mode = STANDBY;

// For best results, set flashDelayMS according to what type
// of shot you're doing. 0 seems best for balloon burst while
// 10 seems best for shattering glass. YMMV.
long flashDelayMS = 10;

void setup() {
	pinMode(BUTTON_PIN, INPUT);
	pinMode(CAM_TRIGGER_PIN, OUTPUT);
	pinMode(FLASH_TRIGGER_PIN, OUTPUT);
	pinMode(LED_PIN, OUTPUT);
	pinMode(WORKLIGHT_RELAY, OUTPUT);
	digitalWrite(LED_PIN, HIGH); 
	digitalWrite(WORKLIGHT_RELAY, HIGH); //turn the lights on
}


void loop() {
	if (digitalRead(BUTTON_PIN) == HIGH)  
	{
		mode = ACTIVE;
		digitalWrite(WORKLIGHT_RELAY, LOW); // turn the lights off
		delay(2000);  // to give time for light to go down and settle after button push
		digitalWrite(LED_PIN, LOW); // show we're ready
		digitalWrite(CAM_TRIGGER_PIN, HIGH); // open the camera shutter
	}
	if ((mode == ACTIVE) && (analogRead(SENSOR_PIN) > SENSOR_THRESHOLD)) //
	{ //If we're in ACTIVE mode and we sense a pop:
		delay(flashDelayMS);
		digitalWrite(FLASH_TRIGGER_PIN, HIGH); // fire flash
		delay(50);
		digitalWrite(FLASH_TRIGGER_PIN, LOW);
		digitalWrite(CAM_TRIGGER_PIN, LOW); // close camera shutter
		mode = STANDBY;
		digitalWrite(LED_PIN, HIGH);
		digitalWrite(WORKLIGHT_RELAY, HIGH); // turn lights back on
	}
}