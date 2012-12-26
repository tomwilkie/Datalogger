#include <Wire.h>
#include <ADXL345.h>
#include <HMC5843.h>
#include <I2C.h>
#include <ITG3200.h>
#include <Sensor.h>

ADXL345* pAccel;
HMC5843* pMag;
ITG3200* pGyro;

void setup() {
  Serial.begin(115200);
  Wire.begin();
  
  pAccel = ADXL345::instance();
  pMag = HMC5843::instance();
  pGyro = ITG3200::instance();
  
  Serial.println("Initializing sensors");
  pAccel->init();
  pMag->init();
  pGyro->init();
  
  Serial.println("Sensors ready");
}

void loop() {
    pAccel->read();
  pMag->read();
  pGyro->read();
  
  const int16_t* buf = 0;
  
  buf = pAccel->rawReading();
  printInt16Array(buf,3);
  buf = pMag->rawReading();
  printInt16Array(buf,3);
  buf = pGyro->rawReading();
  printInt16Array(buf,3);
  
  Serial.println();
  
  delay(100);
}

void printInt16Array(const int16_t* buf, size_t len) {
  size_t i;
  for(i=0;i<len;++i) {
    Serial.print(buf[i]);
    Serial.print("\t");
  }
  Serial.print("\t");
}

