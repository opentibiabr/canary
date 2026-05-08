/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (C) 2019-present OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#include <gtest/gtest.h>

#include "game/scheduling/dispatcher.hpp"
#include "server/server.hpp"

TEST(ServicePortTest, RetriesIPv6IndependentlyWhenIPv4Opens) {
	asio::io_service ioService;
	auto servicePort = std::make_shared<ServicePort>(ioService);
	servicePort->setEnabledNetworksForTest(true, true);
	servicePort->setBindOnlyGlobalAddressForTest(false);
	servicePort->setOpenNetworkAcceptorFailureForTest(ServicePortNetwork_t::IPv6);

	servicePort->open(0);

	EXPECT_TRUE(servicePort->isAcceptorOpenForTest(ServicePortNetwork_t::IPv4));
	EXPECT_FALSE(servicePort->hasPendingStartForTest(ServicePortNetwork_t::IPv4));
	EXPECT_FALSE(servicePort->isAcceptorOpenForTest(ServicePortNetwork_t::IPv6));
	EXPECT_TRUE(servicePort->hasPendingStartForTest(ServicePortNetwork_t::IPv6));

	const auto retryEvent = servicePort->getPendingStartEventForTest(ServicePortNetwork_t::IPv6);
	EXPECT_NE(0, retryEvent);
	g_dispatcher().stopEvent(retryEvent);

	servicePort->close();
	ioService.run();
	ConnectionManager::getInstance().closeAll();
}
