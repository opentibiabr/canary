#ifndef USE_PRECOMPILED_HEADERS
	#include <array>
	#include <exception>
	#include <gtest/gtest.h>
#endif

#include "lib/logging/in_memory_logger.hpp"
#include "security/rsa.hpp"
#include "security/rsa_test_vectors.hpp"

TEST(RsaBackendTest, RawDecryptMatchesExpectedFallbackOutput) {
	InMemoryLogger logger;
	RSAManager rsa(logger);
	rsa.setKey(tests::rsa::DefaultP, tests::rsa::DefaultQ);

	auto block = tests::rsa::FixedInput;
	rsa.decrypt(reinterpret_cast<char*>(block.data()));

	EXPECT_EQ(block.size(), tests::rsa::ExpectedFixedOutput.size());
	EXPECT_EQ(block, tests::rsa::ExpectedFixedOutput);
}

TEST(RsaBackendTest, RawDecryptPreservesLeadingZerosIn128ByteBuffer) {
	InMemoryLogger logger;
	RSAManager rsa(logger);
	rsa.setKey(tests::rsa::DefaultP, tests::rsa::DefaultQ);

	std::array<unsigned char, 128> block {};
	block.back() = 1;
	rsa.decrypt(reinterpret_cast<char*>(block.data()));

	std::array<unsigned char, 128> expected {};
	expected.back() = 1;
	EXPECT_EQ(block, expected);
}

TEST(RsaBackendTest, DecryptWithoutLoadedKeyKeepsBufferUnchanged) {
	InMemoryLogger logger;
	RSAManager rsa(logger);

	auto block = tests::rsa::FixedInput;
	rsa.decrypt(reinterpret_cast<char*>(block.data()));

	EXPECT_EQ(block, tests::rsa::FixedInput);
	EXPECT_TRUE(logger.logs.empty());
}

TEST(RsaBackendTest, StartFallsBackToDefaultKeyWhenPemIsMissing) {
	InMemoryLogger logger;
	RSAManager rsa(logger);

	rsa.start("non_existent_key.pem");

	auto block = tests::rsa::FixedInput;
	rsa.decrypt(reinterpret_cast<char*>(block.data()));

	EXPECT_EQ(block, tests::rsa::ExpectedFixedOutput);
	ASSERT_EQ(logger.logs.size(), 1u);
	EXPECT_EQ(logger.logs[0].level, "error");
}

TEST(RsaBackendTest, LoadPemFailureKeepsExistingKey) {
	InMemoryLogger logger;
	RSAManager rsa(logger);
	rsa.setKey(tests::rsa::DefaultP, tests::rsa::DefaultQ);

	EXPECT_FALSE(rsa.loadPEM("non_existent_key.pem"));

	auto block = tests::rsa::FixedInput;
	rsa.decrypt(reinterpret_cast<char*>(block.data()));

	EXPECT_EQ(block, tests::rsa::ExpectedFixedOutput);
}

TEST(RsaBackendTest, SetKeyFailureKeepsExistingKey) {
	InMemoryLogger logger;
	RSAManager rsa(logger);
	rsa.setKey(tests::rsa::DefaultP, tests::rsa::DefaultQ);

	EXPECT_THROW(rsa.setKey("1", "1"), std::exception);

	auto block = tests::rsa::FixedInput;
	rsa.decrypt(reinterpret_cast<char*>(block.data()));

	EXPECT_EQ(block, tests::rsa::ExpectedFixedOutput);
}
