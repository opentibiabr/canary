/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2024 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */
#pragma once

#include <eventpp/utilities/scopedremover.h>
#include <eventpp/eventdispatcher.h>

template <typename T>
struct Message {
	T type;
};

template <typename T>
using MessageHandler = void(const Message<T> &);

template <typename T>
struct MessagePolicy {
	static T getEvent(const Message<T> &msg) {
		return msg.type;
	}
};

template <typename T>
using MessageDispatcher = eventpp::EventDispatcher<T, MessageHandler<T>, MessagePolicy<T>>;

template <typename T>
using MessageRemover = eventpp::ScopedRemover<MessageDispatcher<T>>;

template <typename T>
class IMessageListener {
public:
	virtual ~IMessageListener() = default;
	virtual void setupListeners(MessageDispatcher<T> &dispatcher) = 0;
};

template <typename T>
using MessageListeners = std::vector<std::shared_ptr<IMessageListener<T>>>;
