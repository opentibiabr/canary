/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019–present OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#include "server/network/protocol/protocol.hpp"
#include "server/network/protocol/protocol_profile.hpp"
#include "server/network/protocol/protocol_session_hint.hpp"
#include "server/network/protocol/transport_codec.hpp"
#include "server/network/message/networkmessage.hpp"
#include "server/network/message/outputmessage.hpp"
#include "utils/tools.hpp"

#ifndef USE_PRECOMPILED_HEADERS
	#include <cstddef>
#endif

namespace {
	[[nodiscard]] uint16_t readU16(const std::byte* buffer) {
		return static_cast<uint16_t>(std::to_integer<uint8_t>(buffer[0])) | static_cast<uint16_t>(std::to_integer<uint8_t>(buffer[1]) << 8);
	}

	[[nodiscard]] uint32_t readU32(const std::byte* buffer) {
		return static_cast<uint32_t>(std::to_integer<uint8_t>(buffer[0])) | (static_cast<uint32_t>(std::to_integer<uint8_t>(buffer[1])) << 8) | (static_cast<uint32_t>(std::to_integer<uint8_t>(buffer[2])) << 16) | (static_cast<uint32_t>(std::to_integer<uint8_t>(buffer[3])) << 24);
	}
}

class TestTransportProtocol final : public Protocol {
public:
	TestTransportProtocol() :
		Protocol(nullptr) { }

	void onRecvFirstMessage(NetworkMessage &) override { }

	void enableEncryption(const std::array<uint32_t, 4> &xteaKey = { 1, 2, 3, 4 }) {
		setXTEAKey(xteaKey.data());
		enableXTEAEncryption();
	}

	// Lets tests build deterministic ciphertext fixtures (e.g. an out-of-range
	// decrypted padding byte) without duplicating the XTEA algorithm.
	void encryptBlock(uint8_t* buffer, size_t length) {
		XTEA_transform(buffer, length, true);
	}
};

TEST(ProtocolProfileRegistryTest, Version860ProfilesAreDifferentProfiles) {
	using enum ProtocolProfileId;
	const auto* vanilla = ProtocolProfileRegistry::resolveByClientVersion(860, ClientWireFamily::CipsoftVanilla);
	const auto* shippedExtendedAssets = ProtocolProfileRegistry::resolveByClientVersionAndAssets(
		860,
		ClientAssetSignatures {
			.dat = 0x4C2C7993,
			.spr = 0x4C220594,
			.pic = 0x4AE5C3D3,
		},
		ClientWireFamily::CipsoftVanilla
	);
	const auto* canaryAssets = ProtocolProfileRegistry::resolveByClientVersionAndAssets(
		860,
		ClientAssetSignatures {
			.dat = 0x44363843,
			.spr = 0x53363843,
			.pic = 0x50363843,
		},
		ClientWireFamily::CipsoftVanilla
	);
	const auto* extendedAssets = ProtocolProfileRegistry::getProfile(Cipsoft860ExtendedAssets);
	const auto* otcv8 = ProtocolProfileRegistry::resolveByClientVersion(860, ClientWireFamily::OTCv8Extended);

	ASSERT_NE(nullptr, vanilla);
	ASSERT_NE(nullptr, shippedExtendedAssets);
	ASSERT_NE(nullptr, canaryAssets);
	ASSERT_NE(nullptr, extendedAssets);
	ASSERT_NE(nullptr, otcv8);
	EXPECT_NE(vanilla->id, otcv8->id);
	EXPECT_NE(vanilla->id, extendedAssets->id);
	EXPECT_NE(extendedAssets->id, otcv8->id);
	EXPECT_EQ(Cipsoft860Vanilla, vanilla->id);
	EXPECT_EQ(Cipsoft860CanaryExtended, shippedExtendedAssets->id);
	EXPECT_EQ(Cipsoft860CanaryExtended, canaryAssets->id);
	EXPECT_EQ(Cipsoft860ExtendedAssets, extendedAssets->id);
	EXPECT_EQ(OTCv8Extended860, otcv8->id);
	EXPECT_EQ(ClientWireFamily::CipsoftVanilla, vanilla->wireFamily);
	EXPECT_EQ(ClientWireFamily::CipsoftVanilla, shippedExtendedAssets->wireFamily);
	EXPECT_EQ(ClientWireFamily::CipsoftVanilla, extendedAssets->wireFamily);
	EXPECT_EQ(ClientWireFamily::OTCv8Extended, otcv8->wireFamily);
	EXPECT_EQ(RSAKeyFamily::OpenTibia, vanilla->rsaKeyFamily);
	EXPECT_EQ(860, vanilla->clientVersion);
	EXPECT_EQ(860, shippedExtendedAssets->clientVersion);
	EXPECT_EQ(860, extendedAssets->clientVersion);
	EXPECT_EQ(860, otcv8->clientVersion);
	EXPECT_TRUE(vanilla->hasFeature(ProtocolFeature::InlineLoginBugReportFlag));
	EXPECT_TRUE(vanilla->hasFeature(ProtocolFeature::RequiresItemMapper));
	EXPECT_TRUE(shippedExtendedAssets->hasFeature(ProtocolFeature::ExtendedSpriteFiles));
	EXPECT_TRUE(shippedExtendedAssets->hasFeature(ProtocolFeature::MagicEffectU16));
	EXPECT_FALSE(shippedExtendedAssets->hasFeature(ProtocolFeature::RequiresItemMapper));
	EXPECT_TRUE(extendedAssets->hasFeature(ProtocolFeature::InlineLoginBugReportFlag));
	EXPECT_TRUE(extendedAssets->hasFeature(ProtocolFeature::ExtendedSpriteFiles));
	EXPECT_FALSE(extendedAssets->hasFeature(ProtocolFeature::MagicEffectU16));
	EXPECT_FALSE(extendedAssets->hasFeature(ProtocolFeature::RequiresItemMapper));
	EXPECT_TRUE(otcv8->hasFeature(ProtocolFeature::InlineLoginBugReportFlag));
	EXPECT_TRUE(ProtocolProfileRegistry::isProfileAllowed(vanilla->id));
	EXPECT_TRUE(ProtocolProfileRegistry::isProfileAllowed(shippedExtendedAssets->id));
	EXPECT_TRUE(ProtocolProfileRegistry::isProfileAllowed(extendedAssets->id));
	EXPECT_FALSE(ProtocolProfileRegistry::isProfileAllowed(otcv8->id));
}

TEST(ProtocolProfileRegistryTest, Cipsoft860UsesClassicLoginLayouts) {
	const auto* accountLayout = ProtocolProfileRegistry::resolveAccountLoginLayout(860);
	const auto* gameLayout = ProtocolProfileRegistry::resolveGameLoginLayout(860);
	const auto* profile = ProtocolProfileRegistry::getProfile(ProtocolProfileId::Cipsoft860Vanilla);

	ASSERT_NE(nullptr, accountLayout);
	ASSERT_NE(nullptr, gameLayout);
	ASSERT_NE(nullptr, profile);
	EXPECT_EQ(TransportProfileId::LegacyClassic, accountLayout->responseTransport);
	EXPECT_EQ(12, accountLayout->bytesToSkipBeforeRsa);
	EXPECT_TRUE(accountLayout->hasAssetSignaturesBeforeRsa);
	EXPECT_EQ(AccountCharacterListLayout::LegacyCharacterList, accountLayout->characterListLayout);
	EXPECT_FALSE(accountLayout->sendsSessionKey);
	EXPECT_FALSE(gameLayout->hasClientVersionU32);
	EXPECT_FALSE(gameLayout->hasContentRevisionU16);
	EXPECT_FALSE(gameLayout->hasPreviewState);
	EXPECT_EQ(GameLoginAuthenticationLayout::AccountPassword, gameLayout->authenticationLayout);
	EXPECT_EQ(TransportProfileId::LegacyClassic, profile->initialBehavior.transport);
	EXPECT_EQ(ChallengeLayout::Cipsoft860LoginChallenge, profile->initialBehavior.challenge.layout);

	const auto* extendedProfile = ProtocolProfileRegistry::getProfile(ProtocolProfileId::Cipsoft860ExtendedAssets);
	const auto* extendedAccountLayout = ProtocolProfileRegistry::resolveAccountLoginLayout(ProtocolProfileId::Cipsoft860ExtendedAssets);
	const auto* extendedGameLayout = ProtocolProfileRegistry::resolveGameLoginLayout(ProtocolProfileId::Cipsoft860ExtendedAssets);
	const auto* canaryProfile = ProtocolProfileRegistry::getProfile(ProtocolProfileId::Cipsoft860CanaryExtended);
	const auto* canaryAccountLayout = ProtocolProfileRegistry::resolveAccountLoginLayout(ProtocolProfileId::Cipsoft860CanaryExtended);
	const auto* canaryGameLayout = ProtocolProfileRegistry::resolveGameLoginLayout(ProtocolProfileId::Cipsoft860CanaryExtended);
	ASSERT_NE(nullptr, extendedProfile);
	ASSERT_NE(nullptr, extendedAccountLayout);
	ASSERT_NE(nullptr, extendedGameLayout);
	ASSERT_NE(nullptr, canaryProfile);
	ASSERT_NE(nullptr, canaryAccountLayout);
	ASSERT_NE(nullptr, canaryGameLayout);
	EXPECT_TRUE(profile->initialBehavior.hasSameWireBehavior(extendedProfile->initialBehavior));
	EXPECT_TRUE(profile->initialBehavior.hasSameWireBehavior(canaryProfile->initialBehavior));
	EXPECT_EQ(AccountCharacterListLayout::LegacyCharacterList, extendedAccountLayout->characterListLayout);
	EXPECT_EQ(AccountCharacterListLayout::LegacyCharacterList, canaryAccountLayout->characterListLayout);
	EXPECT_EQ(GameLoginAuthenticationLayout::AccountPassword, extendedGameLayout->authenticationLayout);
	EXPECT_EQ(GameLoginAuthenticationLayout::AccountPassword, canaryGameLayout->authenticationLayout);
}

TEST(ProtocolProfileRegistryTest, CurrentAnd1100UseDifferentInitialWireBehavior) {
	const auto &current = ProtocolProfileRegistry::getCurrentProfile();
	const auto* tibia1100 = ProtocolProfileRegistry::getProfile(ProtocolProfileId::Tibia1100);

	ASSERT_NE(nullptr, tibia1100);
	EXPECT_NE(current.id, tibia1100->id);
	EXPECT_FALSE(current.initialBehavior.hasSameWireBehavior(tibia1100->initialBehavior));
	EXPECT_TRUE(tibia1100->hasFeature(ProtocolFeature::OldProtocolCompat));
	EXPECT_TRUE(ProtocolProfileRegistry::isProfileAllowed(tibia1100->id));
}

TEST(ConnectionTransportTest, ProtocolGameNoLongerImpliesModernFraming) {
	const auto modernSize = TransportCodecs::currentGameSequence().decodeBodySize(1);
	const auto rawSize = TransportCodecs::rawClientFirst().decodeBodySize(1);
	const auto legacySize = TransportCodecs::legacyClassic().decodeBodySize(1);

	ASSERT_TRUE(modernSize);
	ASSERT_TRUE(rawSize);
	ASSERT_TRUE(legacySize);
	EXPECT_EQ(XTEA_MULTIPLE + CHECKSUM_LENGTH, *modernSize);
	EXPECT_EQ(1, *rawSize);
	EXPECT_EQ(1, *legacySize);
	EXPECT_EQ(CHECKSUM_LENGTH + 2, TransportCodecs::currentGameSequence().getProfile().serverFirstPacketHeaderBytes);
	EXPECT_EQ(CHECKSUM_LENGTH + 1, TransportCodecs::legacyClassic().getProfile().serverFirstPacketHeaderBytes);
}

TEST(ConnectionTransportTest, LegacyEncryptedOutboundHeaderFitsInitialBuffer) {
	constexpr auto legacyEncryptedHeaderSize = HEADER_LENGTH + CHECKSUM_LENGTH + sizeof(uint16_t);
	EXPECT_GE(NetworkMessage::INITIAL_BUFFER_POSITION, legacyEncryptedHeaderSize);
}

TEST(ConnectionTransportTest, LegacyLoginChallengeIncludesInnerMessageSize) {
	OutputMessage msg;
	constexpr uint32_t timestamp = 0x01020304;
	constexpr uint8_t random = 0x7A;

	msg.addByte(0x1F);
	msg.add<uint32_t>(timestamp);
	msg.addByte(random);
	msg.writeLegacyInnerLength();
	const uint32_t checksum = adlerChecksum(msg.getOutputBuffer(), msg.getLength());
	msg.writeChecksum(checksum);
	msg.writeRawMessageLength();

	const uint8_t* buffer = msg.getOutputBuffer();
	const auto* byteBuffer = reinterpret_cast<const std::byte*>(buffer);
	constexpr uint16_t payloadSize = 1 + sizeof(uint32_t) + sizeof(uint8_t);
	constexpr uint16_t bodySize = CHECKSUM_LENGTH + sizeof(uint16_t) + payloadSize;

	EXPECT_EQ(HEADER_LENGTH + bodySize, msg.getLength());
	EXPECT_EQ(bodySize, readU16(byteBuffer));
	EXPECT_EQ(checksum, readU32(byteBuffer + HEADER_LENGTH));
	EXPECT_EQ(payloadSize, readU16(byteBuffer + HEADER_LENGTH + CHECKSUM_LENGTH));
	EXPECT_EQ(0x1F, buffer[HEADER_LENGTH + CHECKSUM_LENGTH + sizeof(uint16_t)]);
	EXPECT_EQ(random, buffer[HEADER_LENGTH + CHECKSUM_LENGTH + sizeof(uint16_t) + 1 + sizeof(uint32_t)]);
}

TEST(TransportProfileTest, LoginAndGameContractsAreExplicitlySeparated) {
	const auto &login = TransportCodecs::currentLogin().getProfile();
	const auto &gameSequence = TransportCodecs::currentGameSequence().getProfile();
	const auto &gamePlain = TransportCodecs::currentGamePlain().getProfile();

	EXPECT_EQ(TransportProfileId::CurrentLogin, login.id);
	EXPECT_EQ(CHECKSUM_METHOD_ADLER32, login.inboundChecksum);
	EXPECT_EQ(CHECKSUM_METHOD_ADLER32, login.outboundChecksum);
	EXPECT_EQ(CompressionLayout::None, login.compression);

	EXPECT_EQ(TransportProfileId::CurrentGameSequence, gameSequence.id);
	EXPECT_EQ(CHECKSUM_METHOD_SEQUENCE, gameSequence.inboundChecksum);
	EXPECT_EQ(CHECKSUM_METHOD_SEQUENCE, gameSequence.outboundChecksum);
	EXPECT_EQ(CompressionLayout::Official, gameSequence.compression);
	EXPECT_TRUE(gameSequence.sequenceHighBitSignalsCompression);

	EXPECT_EQ(TransportProfileId::CurrentGamePlain, gamePlain.id);
	EXPECT_EQ(CHECKSUM_METHOD_NONE, gamePlain.inboundChecksum);
	EXPECT_EQ(CHECKSUM_METHOD_NONE, gamePlain.outboundChecksum);
	EXPECT_EQ(CompressionLayout::None, gamePlain.compression);
	EXPECT_FALSE(gamePlain.sequenceHighBitSignalsCompression);
}

TEST(TransportCodecTest, CurrentLoginWritesAdlerChecksumFromProfile) {
	TestTransportProtocol protocol;
	protocol.enableEncryption();
	OutputMessage msg;
	msg.addByte(0xAB);

	TransportCodecs::currentLogin().encodeOutbound(protocol, msg);

	const auto* bytes = reinterpret_cast<const std::byte*>(msg.getOutputBuffer());
	ASSERT_EQ(14, msg.getLength());
	EXPECT_EQ(1, readU16(bytes));
	const auto storedChecksum = readU32(bytes + HEADER_LENGTH);
	const auto calculatedChecksum = adlerChecksum(msg.getOutputBuffer() + HEADER_LENGTH + CHECKSUM_LENGTH, msg.getLength() - HEADER_LENGTH - CHECKSUM_LENGTH);
	EXPECT_EQ(calculatedChecksum, storedChecksum);
}

TEST(TransportCodecTest, CurrentGameSequenceWritesSequenceFromProfile) {
	TestTransportProtocol protocol;
	protocol.enableEncryption();
	OutputMessage first;
	first.addByte(0xAB);
	TransportCodecs::currentGameSequence().encodeOutbound(protocol, first);

	const auto* firstBytes = reinterpret_cast<const std::byte*>(first.getOutputBuffer());
	EXPECT_EQ(1, readU32(firstBytes + HEADER_LENGTH));

	OutputMessage second;
	second.addByte(0xCD);
	TransportCodecs::currentGameSequence().encodeOutbound(protocol, second);
	const auto* secondBytes = reinterpret_cast<const std::byte*>(second.getOutputBuffer());
	EXPECT_EQ(2, readU32(secondBytes + HEADER_LENGTH));
}

TEST(TransportCodecTest, InboundSequenceRejectsReplay) {
	TestTransportProtocol protocol;
	NetworkMessage first;
	first.add<uint32_t>(1);
	first.addByte(0xAA);
	first.setBufferPosition(NetworkMessage::INITIAL_BUFFER_POSITION);
	EXPECT_TRUE(TransportCodecs::currentGameSequence().prepareInbound(protocol, first));

	NetworkMessage replay;
	replay.add<uint32_t>(1);
	replay.addByte(0xAA);
	replay.setBufferPosition(NetworkMessage::INITIAL_BUFFER_POSITION);
	EXPECT_FALSE(TransportCodecs::currentGameSequence().prepareInbound(protocol, replay));
}

TEST(TransportCodecTest, InboundAdlerValidatesPayload) {
	// prepareInbound's Adler branch reads the checksum and the remaining
	// payload using absolute buffer offsets, exactly like a message freshly
	// populated off the socket (position == HEADER_LENGTH, length == HEADER_LENGTH
	// + body size). Building the fixture with NetworkMessage::add<T>() instead
	// (which tracks length relative to INITIAL_BUFFER_POSITION) would desync
	// that arithmetic, so construct it the same way Connection does.
	TestTransportProtocol protocol;
	constexpr uint8_t payload = 0x5A;
	constexpr uint16_t bodyLength = CHECKSUM_LENGTH + sizeof(payload);

	NetworkMessage valid;
	valid.setBufferPosition(HEADER_LENGTH);
	valid.add<uint32_t>(adlerChecksum(&payload, sizeof(payload)));
	valid.addByte(payload);
	valid.setLength(HEADER_LENGTH + bodyLength);
	valid.setBufferPosition(HEADER_LENGTH);
	EXPECT_TRUE(TransportCodecs::currentLogin().prepareInbound(protocol, valid));

	NetworkMessage invalid;
	invalid.setBufferPosition(HEADER_LENGTH);
	invalid.add<uint32_t>(0xDEADBEEF);
	invalid.addByte(payload);
	invalid.setLength(HEADER_LENGTH + bodyLength);
	invalid.setBufferPosition(HEADER_LENGTH);
	EXPECT_FALSE(TransportCodecs::currentLogin().prepareInbound(protocol, invalid));
}

TEST(TransportCodecTest, DecryptRejectsFrameShorterThanTransportHeader) {
	TestTransportProtocol protocol;
	protocol.enableEncryption();

	NetworkMessage tooShort;
	tooShort.setLength(HEADER_LENGTH - 1);
	tooShort.setBufferPosition(HEADER_LENGTH);

	EXPECT_FALSE(TransportCodecs::currentGamePlain().prepareInbound(protocol, tooShort));
}

TEST(TransportCodecTest, DecryptRejectsPaddingLargerThanBlock) {
	TestTransportProtocol protocol;
	protocol.enableEncryption();

	// Encrypt a block whose decrypted first byte (the padding count) is
	// larger than the block itself, the way a corrupted or hostile frame
	// would look after a correct XTEA decrypt.
	std::array<uint8_t, XTEA_MULTIPLE> block = { 250, 0x11, 0x22, 0x33, 0x44, 0x55, 0x66, 0x77 };
	protocol.encryptBlock(block.data(), block.size());

	NetworkMessage msg;
	uint8_t* buffer = msg.getBuffer();
	for (size_t i = 0; i < block.size(); ++i) {
		buffer[HEADER_LENGTH + i] = block[i];
	}
	msg.setLength(HEADER_LENGTH + block.size());
	msg.setBufferPosition(HEADER_LENGTH);

	EXPECT_FALSE(TransportCodecs::currentGamePlain().prepareInbound(protocol, msg));
}

TEST(TransportCodecTest, CurrentGamePlainRoundTripsWithoutChecksum) {
	TestTransportProtocol protocol;
	protocol.enableEncryption();

	OutputMessage outbound;
	outbound.addByte(0x42);
	TransportCodecs::currentGamePlain().encodeOutbound(protocol, outbound);

	const auto wireLength = outbound.getLength();
	const auto* wireBytes = outbound.getOutputBuffer();

	NetworkMessage inbound;
	uint8_t* inboundBuffer = inbound.getBuffer();
	for (NetworkMessage::MsgSize_t i = 0; i < wireLength; ++i) {
		inboundBuffer[i] = wireBytes[i];
	}
	inbound.setLength(wireLength);
	inbound.setBufferPosition(HEADER_LENGTH);

	ASSERT_TRUE(TransportCodecs::currentGamePlain().prepareInbound(protocol, inbound));
	EXPECT_EQ(0x42, inbound.getByte());
}

TEST(SessionHintTest, ClaimDoesNotConsumeHint) {
	auto &store = ProtocolSessionHintStore::getInstance();
	constexpr uint32_t testIp = 0x0A000101;
	const std::string session = "account-one\npassword-one";
	const std::string character = "Hint Knight";

	store.registerHint(testIp, ProtocolProfileId::Tibia1100, session, { character });

	const auto lease = store.claimByIp(testIp);
	ASSERT_TRUE(lease);
	EXPECT_TRUE(store.consumeIfMatches(*lease, session, character, 1100));
}

TEST(SessionHintTest, ModernHintIsConsumedAfterValidatedLogin) {
	auto &store = ProtocolSessionHintStore::getInstance();
	constexpr uint32_t testIp = 0x0A000107;
	const std::string session = "modern-relog\npassword";
	const std::string character = "Modern Relog";

	store.registerHint(testIp, ProtocolProfileId::Current, session, { character });

	const auto lease = store.claimByIp(testIp);
	ASSERT_TRUE(lease);
	EXPECT_TRUE(store.consumeIfMatches(*lease, session, character, CLIENT_VERSION));
	EXPECT_FALSE(store.claimByIp(testIp));
}

TEST(SessionHintTest, LegacyHintRemainsClaimableAfterValidatedRelog) {
	auto &store = ProtocolSessionHintStore::getInstance();
	constexpr uint32_t testIp = 0x0A000108;
	const std::string session = "legacy-relog\npassword";
	const std::string character = "Legacy Relog";

	store.registerHint(testIp, ProtocolProfileId::Cipsoft860CanaryExtended, session, { character });

	const auto firstLease = store.claimByIp(testIp);
	ASSERT_TRUE(firstLease);
	EXPECT_EQ(TransportProfileId::LegacyClassic, firstLease->behavior.transport);
	EXPECT_TRUE(store.consumeIfMatches(*firstLease, session, character, 860));

	const auto relogLease = store.claimByIp(testIp);
	ASSERT_TRUE(relogLease);
	EXPECT_EQ(TransportProfileId::LegacyClassic, relogLease->behavior.transport);
	EXPECT_TRUE(store.consumeIfMatches(*relogLease, session, character, 860));
}

TEST(SessionHintTest, SameInitialBehaviorDifferentProfilesCanSelectTransport) {
	auto &store = ProtocolSessionHintStore::getInstance();
	constexpr uint32_t testIp = 0x0A000102;
	const std::string vanillaSession = "vanilla-account\nvanilla-password";
	const std::string extendedSession = "extended-account\nextended-password";

	store.registerHint(testIp, ProtocolProfileId::Cipsoft860Vanilla, vanillaSession, { "Vanilla Character" });
	store.registerHint(testIp, ProtocolProfileId::Cipsoft860CanaryExtended, extendedSession, { "Extended Character" });

	const auto lease = store.claimByIp(testIp);
	ASSERT_TRUE(lease);
	EXPECT_EQ(2, lease->candidateIds.size());
	EXPECT_TRUE(store.consumeIfMatches(*lease, extendedSession, "Extended Character", 860));
}

TEST(SessionHintTest, ConflictingCurrentAnd1100HintsDoNotSelectTransport) {
	auto &store = ProtocolSessionHintStore::getInstance();
	constexpr uint32_t testIp = 0x0A000103;

	store.registerHint(testIp, ProtocolProfileId::Current, "modern-account\nmodern-password", { "Modern Character" });
	store.registerHint(testIp, ProtocolProfileId::Tibia1100, "old-account\nold-password", { "Old Character" });

	const auto lease = store.claimByIp(testIp);
	EXPECT_FALSE(lease);
}

TEST(SessionHintTest, Conflicting860AndModernHintsDoNotSelectLegacy) {
	auto &store = ProtocolSessionHintStore::getInstance();
	constexpr uint32_t testIp = 0x0A000104;

	store.registerHint(testIp, ProtocolProfileId::Current, "modern-account\nmodern-password", { "Modern Character" });
	store.registerHint(testIp, ProtocolProfileId::Cipsoft860Vanilla, "legacy-account\nlegacy-password", { "Legacy Character" });

	const auto lease = store.claimByIp(testIp);
	EXPECT_FALSE(lease);
}

TEST(SessionHintTest, NewHintReplacesOlderSameIpCharacterHint) {
	auto &store = ProtocolSessionHintStore::getInstance();
	constexpr uint32_t testIp = 0x0A000105;
	const std::string character = "Shared Character";
	const std::string modernSession = "modern-account\nmodern-password";
	const std::string legacySession = "legacy-account\nlegacy-password";

	store.registerHint(testIp, ProtocolProfileId::Current, modernSession, { character });
	store.registerHint(testIp, ProtocolProfileId::Cipsoft860Vanilla, legacySession, { character });

	const auto lease = store.claimByIp(testIp);
	ASSERT_TRUE(lease);
	EXPECT_EQ(TransportProfileId::LegacyClassic, lease->behavior.transport);
	EXPECT_TRUE(store.consumeIfMatches(*lease, legacySession, character, 860));
}

TEST(SessionHintTest, WrongCharacterDoesNotConsumeHint) {
	auto &store = ProtocolSessionHintStore::getInstance();
	constexpr uint32_t testIp = 0x0A000109;
	const std::string session = "account-two\npassword-two";
	const std::string character = "Correct Character";

	store.registerHint(testIp, ProtocolProfileId::Tibia1100, session, { character });

	const auto lease = store.claimByIp(testIp);
	ASSERT_TRUE(lease);
	EXPECT_FALSE(store.consumeIfMatches(*lease, session, "Wrong Character", 1100));
	EXPECT_TRUE(store.consumeIfMatches(*lease, session, character, 1100));
}

TEST(SessionHintTest, ConsumeReturnsMatchedAssetProfile) {
	auto &store = ProtocolSessionHintStore::getInstance();
	constexpr uint32_t testIp = 0x0A000106;
	const std::string session = "extended-account\nextended-password";
	const std::string character = "Extended Character";

	store.registerHint(testIp, ProtocolProfileId::Cipsoft860CanaryExtended, session, { character });

	const auto lease = store.claimByIp(testIp);
	ASSERT_TRUE(lease);
	const auto matchedProfile = store.consumeAndResolveProfile(*lease, session, character, 860);
	ASSERT_TRUE(matchedProfile);
	EXPECT_EQ(ProtocolProfileId::Cipsoft860CanaryExtended, *matchedProfile);
}
