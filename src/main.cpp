#include <Arduino.h>

#include "led.h"
#include <ArtnetWiFi.h>

// WiFi stuff
const char *ssid = "filsdecrea";
const char *pwd = "";
// const char *ssid = "riri_new";
// const char *pwd = "B2az41opbn6397";
const IPAddress ip(2, 0, 0, 101);
const IPAddress gateway(2, 0, 0, 1);
const IPAddress subnet(255, 0, 0, 0);

ArtnetWiFiSender artnet;
ArtnetWiFiReceiver artnet_in;

const String target_ip = "2.255.255.255";
uint8_t universe = 9;
uint8_t universe_in = 7;

const uint16_t size = 512;
uint8_t data[size];
uint8_t value = 0;

void onArtnet(const uint8_t *data_in, const uint16_t length_in)
{
    for (uint8_t i = 10; i < 22; i++)
    {
        data[i] = data_in[i];
    }
}

const int trig_pin = 5;
const int trig_pin2 = 17;
int trigstate = 0;
int trigstate2 = 0;
boolean trig = false;
boolean trig2 = false;
boolean oldtrig = false;
boolean oldtrig2 = false;

void setup()
{
    Serial.begin(115200);

    // WiFi stuff
    WiFi.begin(ssid, pwd);
    WiFi.config(ip, gateway, subnet);
    while (WiFi.status() != WL_CONNECTED)
    {
        Serial.print(".");
        delay(500);
    }
    Serial.print("WiFi connected, IP = ");
    Serial.println(WiFi.localIP());

    String NAME = "L_LOVER Capteur ";
    artnet_in.shortname(NAME);
    artnet_in.longname(NAME);

    // init led
    init_led();

    artnet.begin();
    artnet_in.begin(); // artnet.begin(net, subnet); // optionally you can change net and subnet
    artnet_in.subscribe(universe_in, onArtnet);

    pinMode(trig_pin, INPUT_PULLDOWN);
    pinMode(trig_pin2, INPUT_PULLDOWN);
}

void loop()
{

    artnet_in.parse();
    artnet.streaming_data(data, size);
    artnet.streaming(target_ip, universe); // automatically send set data in 40fps
    // artnet.streaming(target_ip, net, subnet, univ);  // or you can set net, subnet, and universe

    oldtrig = trig;
    oldtrig2 = trig2;

    trigstate = digitalRead(trig_pin);
    trigstate2 = digitalRead(trig_pin2);

    if (trigstate == HIGH)
    {
        data[0] = 255;
        trig = true;
    }
    else
    {
        data[0] = 0;
        trig = false;
    }

    if (trigstate2 == HIGH)
    {
        data[1] = 255;
        trig2 = true;
    }
    else
    {
        data[1] = 0;
        trig2 = false;
    }

    if (oldtrig != trig)
    {
        Serial.print("Trig = ");
        Serial.println(trig);
    }

    if (oldtrig2!= trig2)
    {
        Serial.print("Trig2 = ");
        Serial.println(trig2);
    }
    onboard_led.on = millis() % 2000 < 1000;
    onboard_led.update();
}
