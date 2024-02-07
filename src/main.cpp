#include <Arduino.h>

#include "led.h"
#include <ArtnetWiFi.h>

// WiFi stuff
const char *ssid = "riri_new";
const char *pwd = "B2az41opbn6397";
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
const int echo_pin = 18;
const int trig_pin2 = 16;
const int echo_pin2 = 17;
long ultrason_duration;
long ultrason_duration2;
float distance_cm;
float distance_cm2;
// Vitesse du son dans l'air
#define SOUND_SPEED 340
#define TRIG_PULSE_DURATION_US 10

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

    pinMode(trig_pin, OUTPUT);  // On configure le trig en output
    pinMode(trig_pin2, OUTPUT); // On configure le trig en output
    pinMode(echo_pin, INPUT);   // On configure l'echo en input
    pinMode(echo_pin2, INPUT);  // On configure l'echo en input
}

void loop()
{

    artnet_in.parse();
    artnet.streaming_data(data, size);
    artnet.streaming(target_ip, universe); // automatically send set data in 40fps
    // artnet.streaming(target_ip, net, subnet, univ);  // or you can set net, subnet, and universe

    digitalWrite(trig_pin, LOW);
    digitalWrite(trig_pin, HIGH);
    delayMicroseconds(TRIG_PULSE_DURATION_US); // Créer une impulsion de 10 µs
    digitalWrite(trig_pin, LOW);
    ultrason_duration = pulseIn(echo_pin, HIGH); // Renvoie le temps de propagation de l'onde (en µs)

    digitalWrite(trig_pin2, LOW);
    delayMicroseconds(2);
    digitalWrite(trig_pin2, HIGH);
    delayMicroseconds(TRIG_PULSE_DURATION_US); // Créer une impulsion de 10 µs
    digitalWrite(trig_pin2, LOW);
    ultrason_duration2 = pulseIn(echo_pin2, HIGH); // Renvoie le temps de propagation de l'onde (en µs)

    // Calcul de la distance
    distance_cm = ultrason_duration * SOUND_SPEED / 2 * 0.0001;
    distance_cm2 = ultrason_duration2 * SOUND_SPEED / 2 * 0.0001;

    if (distance_cm < 10)
    {
        data[0] = 255;
    }
    else
    {
        data[0] = 0;
    }

    if (distance_cm2 < 10)
    {
        data[1] = 255;
    }
    else
    {
        data[1] = 0;
    }

    onboard_led.on = millis() % 2000 < 1000;
    onboard_led.update();
}
