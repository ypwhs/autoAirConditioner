#include <Wire.h> 
#include <LiquidCrystal_I2C.h>
#include <DS3231.h>

LiquidCrystal_I2C lcd(0x27,20,4);  // set the LCD address to 0x27 for a 16 chars and 2 line display
DS3231 Clock;


void setup()
{
  Serial.begin(115200);
  lcd.init();                      // initialize the lcd 
  lcd.backlight();
  lcd.clear();
  
}

void loop()
{
  lcd.setCursor(0,0);
  lcd.print("Hello, world!");
}
