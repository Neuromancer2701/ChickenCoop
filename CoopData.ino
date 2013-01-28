#include <CapacitiveSensor.h>
#include <Thermistor.h>

#define SECOND 1000

#define THERMISTOR 3
#define WATER_SEND 5
#define WATER_RECEIVE 4
#define WATER_FULL 925 /*Calculated by meansuring a full water bottle*/
#define DOOR_STATUS 0

char StatusTable[][8] ={"false", "true"};

char json_template[] = "{ \"Door Open\":%s, \"Time\":%d, \"Water Level\":%d, \"Temperature\":%d.%d}\n\r";
char sendbuffer[128];
			
Thermistor temp(THERMISTOR);
CapacitiveSensor   WaterLevelSensor = CapacitiveSensor(WATER_SEND,WATER_RECEIVE);        // 10M resistor between pins 5 & 4, pin 5 is sensor pin
unsigned long clock = 0;
int temperature = 0;
long rawWaterLevel =  0;
int DoorStatusValue = 0;
int WaterLevel = 0;
char DoorStatusIndex = 0;

	
void setup()
{
  Serial.begin(9600);
  WaterLevelSensor.set_CS_AutocaL_Millis(0xFFFFFFFF);
}

void loop()
{
  clock = millis();
  temperature = int(temp.getTemp()*10);
  rawWaterLevel =  WaterLevelSensor.capacitiveSensor(30);
  WaterLevel = (int)((float)rawWaterLevel/(float)WATER_FULL * 100);
 
  /*The Water Level sensor has a little error build into it so just do some boundary checks*/
  if(WaterLevel > 100) WaterLevel = 100;
  if(WaterLevel < 0 )  WaterLevel = 0;
  
  DoorStatusValue = analogRead(DOOR_STATUS);
  if(DoorStatusValue > 900)
  {     
    DoorStatusIndex = 1;  /*Door Closed*/
  } 
  else 
  {
    DoorStatusIndex = 0;  /*Door Open*/
  }
 
  sprintf(sendbuffer, json_template, StatusTable[DoorStatusIndex], int(clock/SECOND), WaterLevel, int(temperature/10), int(temperature % 10));  
  Serial.write(sendbuffer);
 
  delay(30 * SECOND);
}


