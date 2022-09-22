#ifndef SRC_SERVER_NETWORK_WEBHOOK_WEBHOOK_H_
#define SRC_SERVER_NETWORK_WEBHOOK_WEBHOOK_H_

#include <string>

#include "config/configmanager.h"

void webhook_init();

void webhook_send_message(std::string title, std::string message, int color, std::string url);

#endif  // SRC_SERVER_NETWORK_WEBHOOK_WEBHOOK_H_
