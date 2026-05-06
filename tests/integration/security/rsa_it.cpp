#ifndef USE_PRECOMPILED_HEADERS
	#include <gtest/gtest.h>
#endif

#include "lib/logging/in_memory_logger.hpp"
#include "security/rsa.hpp"
#include "security/rsa_test_vectors.hpp"

#ifndef RSA_TEST_KEY
	#error "RSA_TEST_KEY must point to the RSA PEM fixture"
#endif

TEST(RsaIntegrationTest, StartLoadsPemAndDecryptsFallbackCompatibleBlock) {
	InMemoryLogger logger;
	RSAManager rsa(logger);

	rsa.start(RSA_TEST_KEY);

	auto block = tests::rsa::FixedInput;
	rsa.decrypt(reinterpret_cast<char*>(block.data()));

	EXPECT_EQ(block, tests::rsa::ExpectedFixedOutput);
	EXPECT_TRUE(logger.logs.empty());
}
