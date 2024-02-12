//Firebase
#include <Arduino.h>
#include <WiFi.h>
#include <FirebaseESP32.h>
// Provide the token generation process info.
#include <addons/TokenHelper.h>
// Provide the RTDB payload printing info and other helper functions.
#include <addons/RTDBHelper.h>
/* 1. Define the WiFi credentials */
#define WIFI_SSID "Autobonics_4G"
#define WIFI_PASSWORD "autobonics@27"
// For the following credentials, see examples/Authentications/SignInAsUser/EmailPassword/EmailPassword.ino
/* 2. Define the API Key */
#define API_KEY "AIzaSyDpuCzU9z1eYMCPp-Xql_LEUxrvuXPhn74"
/* 3. Define the RTDB URL */
#define DATABASE_URL "https://medicus-5ca5f-default-rtdb.asia-southeast1.firebasedatabase.app/" //<databaseName>.firebaseio.com or <databaseName>.<region>.firebasedatabase.app
/* 4. Define the user Email and password that alreadey registerd or added in your project */
#define USER_EMAIL "device@gmail.com"
#define USER_PASSWORD "12345678"
// Define Firebase Data object
FirebaseData fbdo;
FirebaseAuth auth;
FirebaseConfig config;
unsigned long sendDataPrevMillis = 0;
// Variable to save USER UID
String uid;
//Databse
String path;

unsigned long printDataPrevMillis = 0;


//Servos
#include <Servo.h>
static const int servoPin1 = 26;
static const int servoPin2 = 25;
static const int servoPin3 = 33;
Servo servo1;
Servo servo2;
Servo servo3;


#include <OneWire.h>
#include <DallasTemperature.h>
#define sensorPin 2          
#define oneWireBus 4
OneWire oneWire(oneWireBus);
DallasTemperature sensors(&oneWire);
int heartRate = 0;
float temperatureC;


#include <SPI.h>//https://www.arduino.cc/en/reference/SPI
#include <MFRC522.h>//https://github.com/miguelbalboa/rfid
#define RST_PIN 4          
#define SS_PIN 5 
String content= "";
MFRC522 rfid(SS_PIN, RST_PIN);

//====================================================================================
FirebaseData stream;
void streamCallback(StreamData data)
{
  Serial.println("NEW DATA!");
  String p = data.dataPath();
  Serial.println(p);
  printResult(data); // see addons/RTDBHelper.h

  FirebaseJson jsonObject = data.jsonObject();

  FirebaseJsonData isOpen1;
  FirebaseJsonData isOpen2;
  FirebaseJsonData isOpen3;
  FirebaseJsonData cont;

  // Retrieve values from JSON object
  jsonObject.get(isOpen1, "isOpen1");
  jsonObject.get(isOpen2, "isOpen2");
  jsonObject.get(isOpen3, "isOpen3");
  jsonObject.get(cont, "content");
  

  if (isOpen1.success)
  {
      Serial.println("Success data isOpen1");
      bool value = isOpen1.to<bool>(); 
      if(value) {
          servo1.write(90);
          delay(100);
          servo1.write(40);
          delay(1000);
          servo1.write(90);
      }
  }
  if (isOpen2.success)
  {
      Serial.println("Success data isOpen2");
      bool value = isOpen2.to<bool>(); 
      if(value) {
          servo2.write(90);
          delay(100);
          servo2.write(40);
          delay(1000);
          servo2.write(90);
      }
  }
  if (isOpen3.success)
  {
      Serial.println("Success data isOpen3");
      bool value = isOpen3.to<bool>(); 
      if(value) {
          servo3.write(90);
          delay(100);
          servo3.write(40);
          delay(1000);
          servo3.write(90);
      }
  }
  if (cont.success)
  {
      Serial.println("Success data cont");
      String value = cont.to<String>(); 
      content = value;
  }
}


void streamTimeoutCallback(bool timeout)
{
  if (timeout)
    Serial.println("stream timed out, resuming...\n");

  if (!stream.httpConnected())
    Serial.printf("error code: %d, reason: %s\n\n", stream.httpCode(), stream.errorReason().c_str());
}
//============================================================================






void setup() {
  Serial.begin(115200);
  Serial.println("BOA Starting..");

  servo1.attach(servoPin1);
  servo2.attach(servoPin2);
  servo3.attach(servoPin3);
  //Sensors
  sensors.begin();    

  //RFID
  SPI.begin();
  rfid.PCD_Init();
	delay(4);				// Optional delay. Some board do need more time after init to be ready, see Readme
  Serial.print(F("Reader :"));
  rfid.PCD_DumpVersionToSerial();
  Serial.println("Put your card to the reader...");    

  //WIFI
  WiFi.begin(WIFI_SSID, WIFI_PASSWORD);
  Serial.print("Connecting to Wi-Fi");
  unsigned long ms = millis();
  while (WiFi.status() != WL_CONNECTED)
  {
    Serial.print(".");
    delay(300);
  }
  Serial.println();
  Serial.print("Connected with IP: ");
  Serial.println(WiFi.localIP());
  Serial.println();

  //FIREBASE
  Serial.printf("Firebase Client v%s\n\n", FIREBASE_CLIENT_VERSION);
  /* Assign the api key (required) */
  config.api_key = API_KEY;

  /* Assign the user sign in credentials */
  auth.user.email = USER_EMAIL;
  auth.user.password = USER_PASSWORD;

  /* Assign the RTDB URL (required) */
  config.database_url = DATABASE_URL;

  /* Assign the callback function for the long running token generation task */
  config.token_status_callback = tokenStatusCallback; // see addons/TokenHelper.h

  // Limit the size of response payload to be collected in FirebaseData
  fbdo.setResponseSize(2048);

  Firebase.begin(&config, &auth);

  // Comment or pass false value when WiFi reconnection will control by your code or third party library
  Firebase.reconnectWiFi(true);

  Firebase.setDoubleDigits(5);

  config.timeout.serverResponse = 10 * 1000;

  // Getting the user UID might take a few seconds
  Serial.println("Getting User UID");
  while ((auth.token.uid) == "") {
    Serial.print('.');
    delay(1000);
  }
  // Print user UID
  uid = auth.token.uid.c_str();
  Serial.print("User UID: ");
  Serial.println(uid);

  path = "devices/" + uid + "/reading";

  //Stream setup
  if (!Firebase.beginStream(stream, "devices/" + uid + "/data"))
    Serial.printf("sream begin error, %s\n\n", stream.errorReason().c_str());

  Firebase.setStreamCallback(stream, streamCallback, streamTimeoutCallback);
}

void updateData(){
  if (Firebase.ready() && (millis() - sendDataPrevMillis > 1000 || sendDataPrevMillis == 0))
  {
    sendDataPrevMillis = millis();
    FirebaseJson json;
    json.set("heartRate", heartRate);
    json.set("temp", temperatureC);
    json.set("rfid", content);
    json.set(F("ts/.sv"), F("timestamp"));
    Serial.printf("Set data with timestamp... %s\n", Firebase.setJSON(fbdo, path.c_str(), json) ? fbdo.to<FirebaseJson>().raw() : fbdo.errorReason().c_str());
    Serial.println(""); 
  }
}

////////////////////////////////////////

void loop() {

  // Heart Rate
  int sensorValue = analogRead(sensorPin);
  heartRate = map(sensorValue, 0, 4095, 30, 120); 
  Serial.print("Heart rate: ");
  Serial.println(heartRate);

  // Temperature
  sensors.requestTemperatures();
  temperatureC = sensors.getTempCByIndex(0);
  Serial.print("Temperature: ");
  Serial.print(temperatureC);
  Serial.println("ºC / ");

  readRFID();
  updateData();
}

void readRFID(void ) { /* function readRFID */
  ////Read RFID card
  // for (byte i = 0; i < 6; i++) {
  //     key.keyByte[i] = 0xFF;
  // }
  // Look for new 1 cards
  if (!rfid.PICC_IsNewCardPresent())
      return;
  // Verify if the NUID has been readed
  if (!rfid.PICC_ReadCardSerial())
      return;
  // Store NUID into nuidPICC array
//  for (byte i = 0; i < 4; i++) {
//      nuidPICC[i] = rfid.uid.uidByte[i];
//  }
  Serial.print(F("RFID In Hex: "));
	// rfid.PICC_DumpToSerial(&(rfid.uid));

  printHex(rfid.uid.uidByte, rfid.uid.size);
  Serial.println();
  // Halt PICC
//  rfid.PICC_HaltA();
  // Stop encryption on PCD
//  rfid.PCD_StopCrypto1();
}
/**
    Helper routine to dump a byte array as hex values to Serial.
*/
void printHex(byte *buffer, byte bufferSize) {
  content = "";
  for (byte i = 0; i < bufferSize; i++) {
    Serial.print(buffer[i] < 0x10 ? " 0" : " ");
    Serial.print(buffer[i], HEX);
    content.concat(String(buffer[i] < 0x10 ? "0" : ""));
    content.concat(String(buffer[i], HEX));
  }
  Serial.print("Content: ");
  Serial.println(content);
}
