#include "app/framework/include/af.h"
#include "sensor_data.h"
#define SOURCE_ENDPOINT 1
#define DESTINATION_ENDPOINT 1
#define MSG_INTERVAL_MS 5000
#define EMBER_AF_DOXYGEN_CLI_COMMAND_BUILD_SEND_MSG_RAW


static sl_zigbee_event_t sendMsgEvent;
static SensorData data;
static void sendMsgEventHandler(sl_zigbee_event_t *event);

// Function to send a message
void sendTestMessage(void) {
  EmberStatus status;
  EmberNodeId destination =  0x04F0; // Node ID của Coordinator
  EmberNodeId source = emberAfGetNodeId(); // Node ID của thiết bị gửi
  uint8_t message[10];
  // read datain
  get_value_sensor(&data);
  //
  float temp = (float) data.temperature;


  snprintf((char *)message, sizeof(message), "test%.2f",temp);
  static uint8_t msg[10] ={0x00, 0x0A, 0x00};
  msg[1] +=1;
  msg[3] = (uint8_t)(source >> 8); // Gửi byte cao trước
  msg[4] = (uint8_t)source; // Gửi byte thấp sau
  msg[5] = data.temperature;
  msg[6] = data.humidity;
  msg[7] = data.smoke;
  msg[8] = data.fire;
  msg[9] = data.button_state;

  // Khởi tạo APS frame để gửi tin nhắn
  EmberApsFrame apsFrame;
  apsFrame.profileId = 0x0104; // Home Automation profile ID
  apsFrame.sourceEndpoint = SOURCE_ENDPOINT;
  apsFrame.destinationEndpoint = DESTINATION_ENDPOINT;
  apsFrame.clusterId = 0x000F; // Basic cluster ID
  apsFrame.options = EMBER_AF_DEFAULT_APS_OPTIONS;
  apsFrame.groupId = 0;
  apsFrame.sequence = 0;

  // Gửi tin nhắn unicast đến thiết bị đích
  status = emberAfSendUnicast(EMBER_OUTGOING_DIRECT, destination, &apsFrame, 10 , msg);
  if (status != EMBER_SUCCESS) {
    emberAfCorePrintln("Error: %d", status);
  } else {
    emberAfCorePrintln("Message sent: %s", message);
  }
}


void emberAfMainInitCallback(void) {
  emberAfCorePrintln("Main init");

  // Thiết lập sự kiện để gửi tin nhắn
  sl_zigbee_event_init(&sendMsgEvent, sendMsgEventHandler);
  sl_zigbee_event_set_delay_ms(&sendMsgEvent, MSG_INTERVAL_MS);
}

// Hàm callback để gửi tin nhắn mỗi khi timer được gọi
static void sendMsgEventHandler(sl_zigbee_event_t *event) {
  sendTestMessage();
  sl_zigbee_event_set_delay_ms(&sendMsgEvent, MSG_INTERVAL_MS);
}


