#ifndef SRC_WEBHOOK_H_
#define SRC_WEBHOOK_H_

#include <string>

void webhook_init();

void webhook_send_message(std::string title, std::string message, int color);

#endif  // SRC_WEBHOOK_H_
