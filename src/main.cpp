#include <Arduino.h>

// Please include ArtnetWiFi.h to use Artnet on the platform
// which can use both WiFi and Ethernet
#include <ArtnetWiFi.h>
// this is also valid for other platforms which can use only WiFi
// #include <Artnet.h>

// WiFi stuff
const char *ssid = "riri_new";
const char *pwd = "B2az41opbn6397";
const IPAddress ip(2, 0, 0, 101);
const IPAddress gateway(2, 0, 0, 1);
const IPAddress subnet(255, 0, 0, 0);

ArtnetWiFiSender artnet;
const String target_ip = "2.255.255.255";
uint32_t universe = 9;

const uint16_t size = 512;
uint8_t data[size];
uint8_t value = 0;

const int trig_pin = 5;
const int echo_pin = 18;
long ultrason_duration;
float distance_cm;
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

                              
    artnet.begin(); 
    // artnet.begin(net, subnet); // optionally you can change net and subnet

    pinMode(trig_pin, OUTPUT); // On configure le trig en output
    pinMode(echo_pin, INPUT);  // On configure l'echo en input
}

void loop()
{
    // value = (millis() / 40) % 256;
    // memset(data, value, size);

    artnet.streaming_data(data, size);
    artnet.streaming(target_ip, universe); // automatically send set data in 40fps
    // artnet.streaming(target_ip, net, subnet, univ);  // or you can set net, subnet, and universe

    digitalWrite(trig_pin, LOW);
    delayMicroseconds(2);
    // Créer une impulsion de 10 µs
    digitalWrite(trig_pin, HIGH);
    delayMicroseconds(TRIG_PULSE_DURATION_US);
    digitalWrite(trig_pin, LOW);

    // Renvoie le temps de propagation de l'onde (en µs)
    ultrason_duration = pulseIn(echo_pin, HIGH);

    // Calcul de la distance
    distance_cm = ultrason_duration * SOUND_SPEED/2 * 0.0001;

    if (distance_cm < 30)
    {
        data[0] = 255;
    }
    else
    {
        data[0] = 0 ;
    }

    // On affiche la distance sur le port série
    // Serial.print("Distance (cm): ");
    // Serial.println(distance_cm);
}   
