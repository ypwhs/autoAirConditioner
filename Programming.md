#中央空调控制器-代码篇

#[代码链接](autoAirConditioner.ino)

##使用的库

`#include <Wire.h>`

这个库是I2C必备的库,系统自带.

`#include <Servo.h>`

舵机控制库,系统自带.

`#include <LiquidCrystal_I2C.h>`[传送门](libraries/LiquidCrystal_I2C2004V1)

`#include <DS3231.h>`[传送门](libraries/DS3231)

`#include <DS3231.h>`[传送门](libraries/DHT)

#部分函数介绍

##液晶屏

构造函数:`LiquidCrystal_I2C lcd(0x27, 20, 4);`

`0x27`为液晶屏的I2C地址,20表示一行20字符,4表示可以显示四行.

初始化:

```c
  lcd.init();
  lcd.backlight();
  lcd.clear();
```

写字:

```c
  lcd.setCursor(0, 0);		//x,y
  lcd.print(a);
```

##DS3231

构造函数:`DS3231 Clock;`

获取时间:

```c
int second = 0, minute = 0, hour = 0, date = 0, month = 0, year = 0;
bool h12;
bool PM;
bool Century = false;
void refreshTime() {
  second = Clock.getSecond();
  minute = Clock.getMinute();
  hour = Clock.getHour(h12, PM);
  date = Clock.getDate();
  month = Clock.getMonth(Century);
  year = Clock.getYear();
}
```

跑一次`refreshTime()`后,可以获取到模块中的时间,year需要加2000才是正确的值.

设置时间:

```c
  Clock.setSecond(second);
  Clock.setMinute(minute);
  Clock.setHour(hour);
  Clock.setDate(date);
  Clock.setMonth(month);
  Clock.setYear(year);
```

##DHT22

构造函数:`DHT dht;`

获取温湿度:

```c
  now = millis();
  if (now - last > dht.getMinimumSamplingPeriod()) {
    humidity = dht.getHumidity();
    temperature = dht.getTemperature();
    lcd.setCursor(0, 2);
    lcd.print(dht.getStatusString());
    lcd.print(" C: ");
    lcd.print(temperature);
    lcd.print(" H: ");
    lcd.print(humidity);
    last = now;
  }
```

这里有一个思想需要介绍

`millis()`可以获取单片机从开机到现在的运行时间,单位是毫秒.通过这个值,我们可以实现**一定程度上的多线程**.

首先我们如果没有使用这个函数,由于DHT22采样时间是2秒一次(不同型号可能不同,通过这个函数得到的:`dht.getMinimumSamplingPeriod()`),我们必须获取了温湿度之后,执行`delay(2000)`,才能保证获取到正确的温湿度,这样带来的后果就是:我们给单片机发指令之后,也必须等待2秒以后才会执行.因此我们使用`millis()`函数来获取当前运行时间,然后减去上一次执行之后的时间,来判断是否到2秒,也就是这一句:`if (now - last > dht.getMinimumSamplingPeriod())`,只有到两秒之后,才会执行下面的获取温湿度代码,然后将温湿度打在屏幕上,最后将last赋值,实现**一定程度上的多线程**.

##Servo

构造函数:`Servo myservo;`

`myservo.attach(3);`

转动舵机:
`myservo.write(90);		//90可以改为任意角度`

##Serial

串口通讯

初始化函数:`Serial.begin(115200);	//115200为波特率`

读取函数:

```c
  if (Serial.available() > 0)
  {
    char rec = Serial.read();
  }
```

读取一段:`Serial.readBytesUntil((char)0x80, time, 45);`

写串口:`Serial.println(time);`