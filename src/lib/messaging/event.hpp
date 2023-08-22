/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2022 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */
#ifndef CANARY_EVENT_HPP
#define CANARY_EVENT_HPP

enum class EventType {
};

using IEvent = Message<EventType>;
using EventHandler = MessageHandler<EventType>;
using EventPolicy = MessagePolicy<EventType>;
using EventListener = IMessageListener<EventType>;
using EventListeners = MessageListeners<EventType>;
using EventDispatcher = MessageDispatcher<EventType>;
using EventRemover = MessageRemover<EventType>;

inline IEvent event(EventType type) {
	return IEvent { type };
}
#define eventCallback(block) [this](const IEvent &) block
#define appendEventListener(type, block) dispatcher.appendListener(type, eventCallback(block))

#endif // CANARY_EVENT_HPP