#include <stdio.h>
#include <Wire.h>
#include <Sensor.h>
#include <ADXL345.h>
#include <HMC5843.h>
#include <I2C.h>
#include <ITG3200.h>
#include <Sensor.h>
#include <adk.h>

#define SENSORS 3
#define ACCEL 0
#define MAG 1
#define GYRO 2

Sensor* sensors[SENSORS]; 

// Accessory descriptor. It's how Arduino identifies itself to Android.
const char applicationName[] = "Datalogger"; // the app on your phone
const char accessoryName[] = "Datalogger"; // your Arduino board
const char companyName[] = "Davrian";

// Make up anything you want for these
char versionNumber[] = "1.0";
char serialNumber[] = "1";
char url[] = "http://www.google.com";

USBHost Usb;
ADK adk(&Usb, companyName, applicationName, accessoryName, versionNumber, url, serialNumber);


void setup() {
  Serial.begin(115200);
  Wire.begin();
  cpu_irq_enable();
  
  printf("Datalogger active\n");
  
  // Setup delay so that we can attach serial console and
  // soft reset without having reinitialising USB
  delay(2000);
  
  sensors[ACCEL] = ADXL345::instance();
  sensors[MAG] = HMC5843::instance();
  sensors[GYRO] = ITG3200::instance();
  
  printf("Initializing sensors\n");
  for (int i = 0; i < SENSORS; i++) {
    sensors[i]->init();
  }
  printf("Sensors ready\n");
}

int16_t* readSensors() {
  const size_t axis = 3;
  int16_t* results = (int16_t*) malloc(sizeof(int16_t) * SENSORS * axis);
  
  for (int i = 0; i < SENSORS; i++) {
    sensors[i]->read();
    const int16_t *result = sensors[i]->rawReading();
    for (int j = 0; j < axis; j++) {
      results[(i * axis) + j] = result[j];
    }
  }
  
  return results;
}

void sendResultsToSerial(int16_t* results, size_t len) {
  return;
  
  for (size_t i = 0; i < len; i++) {
    Serial.print(results[i]);
    Serial.print("\t");
  }
  Serial.print("\n");
}

int firstTime = 1;

void sendResultsToUSB(int16_t* results, size_t len) {
  Usb.Task();
  
  if (!adk.isReady()) {
    return;
  } else if (firstTime) {
    delay(1000);
    firstTime = !firstTime;
  }
  
  // byte at beginning of buffer is buffer size;
  size_t buf_len = 1 + (len * 2);
  
  printf("sending %d bytes\n", buf_len);
  
  uint8_t buf[buf_len];
  buf[0] = buf_len - 1; // len does not include itself
  for (size_t i = 0; i < len; i++) {
    ((uint16_t *) (buf + 1))[i] = results[i];
  }
  
  uint32_t res = adk.write(buf_len, buf);
  if (res != 0)
    printf("write failed %lu\n", res);
    
  // read some stuff; try to keep connection alive
  /*uint8_t buf2[128];
  uint32_t nbread = 0;
  adk.read(&nbread, 128, buf2);
  printf("read %lu bytes\n", nbread);*/
}

void loop() {
  int16_t* results = readSensors();
  sendResultsToSerial(results, SENSORS * 3);
  sendResultsToUSB(results, SENSORS * 3); 
  free(results);
  delay(200);
}

