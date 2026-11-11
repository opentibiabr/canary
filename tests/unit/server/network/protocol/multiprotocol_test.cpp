/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019–present OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#include "creatures/players/grouping/groups.hpp"
#include "creatures/players/player.hpp"
#include "creatures/players/vocations/vocation.hpp"
#include "injection_fixture.hpp"
#include "items/item.hpp"
#include "server/network/protocol/protocol.hpp"
#include "server/network/protocol/protocolgame.hpp"
#include "server/network/protocol/protocol_profile.hpp"
#include "server/network/protocol/protocol_session_hint.hpp"
#include "server/network/protocol/transport_codec.hpp"
#include "server/network/message/networkmessage.hpp"
#include "server/network/message/outputmessage.hpp"
#include "utils/tools.hpp"

#ifndef USE_PRECOMPILED_HEADERS
	#include <array>
	#include <cstddef>
	#include <cstring>
	#include <memory>
#endif

namespace {
	class CurrentTransportProtocol final : public Protocol {
	public:
		explicit CurrentTransportProtocol(const std::array<uint32_t, 4> &xteaKey) :
			Protocol(nullptr) {
			setXTEAKey(xteaKey.data());
			setChecksumMethod(CHECKSUM_METHOD_SEQUENCE);
			enableXTEAEncryption();
		}

		void onRecvFirstMessage(NetworkMessage &) override { }
	};

	[[nodiscard]] uint16_t readU16(const std::byte* buffer) {
		return static_cast<uint16_t>(std::to_integer<uint8_t>(buffer[0])) | static_cast<uint16_t>(std::to_integer<uint8_t>(buffer[1]) << 8);
	}

	[[nodiscard]] uint32_t readU32(const std::byte* buffer) {
		return static_cast<uint32_t>(std::to_integer<uint8_t>(buffer[0])) | (static_cast<uint32_t>(std::to_integer<uint8_t>(buffer[1])) << 8) | (static_cast<uint32_t>(std::to_integer<uint8_t>(buffer[2])) << 16) | (static_cast<uint32_t>(std::to_integer<uint8_t>(buffer[3])) << 24);
	}
}

class SkillAdvanceGameEventTest : public ::testing::Test {
protected:
	struct SkillCase {
		skills_t skill;
		uint8_t expectedId;
	};

	static constexpr std::array cases {
		SkillCase { SKILL_SHIELD, 7 },
		SkillCase { SKILL_SWORD, 2 },
		SkillCase { SKILL_DISTANCE, 6 },
		SkillCase { SKILL_FISHING, 8 },
		SkillCase { SKILL_MAGLEVEL, 1 },
		SkillCase { SKILL_CLUB, 3 },
		SkillCase { SKILL_AXE, 4 },
		SkillCase { SKILL_FIST, 5 },
	};

	void SetUp() override {
		previousInjector = DI::getTestContainer();
		injection = std::make_unique<InjectionFixture>();
		auto &items = Item::items.getItems();
		originalItemCount = items.size();
		if (items.empty()) {
			// The player constructor creates an inbox and needs a fallback item type.
			items.emplace_back();
		}
		protocol = std::make_shared<ProtocolGame>(nullptr);
		player = std::make_shared<Player>(protocol);
		player->vocation = std::make_shared<Vocation>(1);
		player->setGroup(std::make_shared<Group>());
		protocol->player = player;
	}

	void TearDown() override {
		protocol->player.reset();
		player.reset();
		protocol.reset();
		Item::items.getItems().resize(originalItemCount);

		// Lua interfaces can outlive their Lua state during injector destruction.
		const bool previousShutdown = LuaEnvironment::shuttingDown;
		LuaEnvironment::shuttingDown = true;
		DI::setTestContainer(previousInjector);
		injection.reset();
		LuaEnvironment::shuttingDown = previousShutdown;
	}

	void expectGameplayAdvances(bool offline) {
		for (const auto &[skill, expectedId] : cases) {
			SCOPED_TRACE(getSkillName(skill));
			protocol->getCurrentBuffer().reset();
			const bool isMagic = skill == SKILL_MAGLEVEL;
			const auto nextLevel = (isMagic ? player->getBaseMagicLevel() : player->getBaseSkill(skill)) + 1;
			const auto &vocation = player->getVocation();
			const auto tries = isMagic ? vocation->getReqMana(nextLevel) : vocation->getReqSkillTries(skill, nextLevel);
			ASSERT_GT(tries, 0U);

			if (offline) {
				ASSERT_TRUE(player->addOfflineTrainingTries(skill, tries));
			} else if (isMagic) {
				player->addManaSpent(tries);
			} else {
				player->addSkillAdvance(skill, tries);
			}

			const auto &output = protocol->getCurrentBuffer();
			ASSERT_NE(nullptr, output);
			output->setBufferPosition(NetworkMessage::INITIAL_BUFFER_POSITION);
			ASSERT_EQ(0xB4, output->getByte());
			output->getByte(); // Text message type.
			ASSERT_FALSE(output->getString().empty());

			ASSERT_GE(output->getUnreadBytes(), 5U);
			EXPECT_EQ(0x75, output->getByte());
			EXPECT_EQ(0x05, output->getByte());
			EXPECT_EQ(expectedId, output->getByte());
			EXPECT_EQ(nextLevel, output->get<uint16_t>());
		}
	}

	std::shared_ptr<ProtocolGame> protocol;
	std::shared_ptr<Player> player;

private:
	di::extension::injector<>* previousInjector = nullptr;
	std::unique_ptr<InjectionFixture> injection;
	std::size_t originalItemCount = 0;
};

TEST_F(SkillAdvanceGameEventTest, UsesClientSkillIdsInAdvancePacket) {
	for (const auto &[skill, expectedId] : cases) {
		SCOPED_TRACE(getSkillName(skill));
		protocol->getCurrentBuffer().reset();
		player->sendSkillAdvance(skill, 0x0125);

		const auto &output = protocol->getCurrentBuffer();
		const std::array<uint8_t, 5> expected { 0x75, 0x05, expectedId, 0x25, 0x01 };
		ASSERT_NE(nullptr, output);
		ASSERT_EQ(expected.size(), output->getLength());
		const auto* payload = output->getOutputBuffer();
		for (std::size_t i = 0; i < expected.size(); ++i) {
			EXPECT_EQ(expected[i], payload[i]) << "Packet byte " << i;
		}
	}
}

TEST_F(SkillAdvanceGameEventTest, SendsClientSkillIdsOnRegularAdvances) {
	expectGameplayAdvances(false);
}

TEST_F(SkillAdvanceGameEventTest, SendsClientSkillIdsOnOfflineTrainingAdvances) {
	expectGameplayAdvances(true);
}

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
	EXPECT_FALSE(vanilla->hasFeature(ProtocolFeature::ExpertPvpModeByte));
	EXPECT_TRUE(shippedExtendedAssets->hasFeature(ProtocolFeature::ExtendedSpriteFiles));
	EXPECT_TRUE(shippedExtendedAssets->hasFeature(ProtocolFeature::MagicEffectU16));
	EXPECT_FALSE(shippedExtendedAssets->hasFeature(ProtocolFeature::RequiresItemMapper));
	EXPECT_FALSE(shippedExtendedAssets->hasFeature(ProtocolFeature::ExpertPvpModeByte));
	EXPECT_TRUE(extendedAssets->hasFeature(ProtocolFeature::InlineLoginBugReportFlag));
	EXPECT_TRUE(extendedAssets->hasFeature(ProtocolFeature::ExtendedSpriteFiles));
	EXPECT_FALSE(extendedAssets->hasFeature(ProtocolFeature::MagicEffectU16));
	EXPECT_FALSE(extendedAssets->hasFeature(ProtocolFeature::RequiresItemMapper));
	EXPECT_FALSE(extendedAssets->hasFeature(ProtocolFeature::ExpertPvpModeByte));
	EXPECT_TRUE(otcv8->hasFeature(ProtocolFeature::InlineLoginBugReportFlag));
	EXPECT_FALSE(otcv8->hasFeature(ProtocolFeature::ExpertPvpModeByte));
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
	EXPECT_FALSE(current.hasFeature(ProtocolFeature::ExpertPvpModeByte));
	EXPECT_TRUE(tibia1100->hasFeature(ProtocolFeature::ExpertPvpModeByte));
	EXPECT_TRUE(current.hasFeature(ProtocolFeature::TacticsWithoutFightMode));
	EXPECT_TRUE(tibia1100->hasFeature(ProtocolFeature::OldProtocolCompat));
	EXPECT_FALSE(tibia1100->hasFeature(ProtocolFeature::TacticsWithoutFightMode));
	EXPECT_TRUE(ProtocolProfileRegistry::isProfileAllowed(tibia1100->id));
}

TEST(ConnectionTransportTest, ProtocolGameNoLongerImpliesModernFraming) {
	const auto modernSize = TransportCodecs::currentModern().decodeBodySize(1);
	const auto rawSize = TransportCodecs::rawClientFirst().decodeBodySize(1);
	const auto legacySize = TransportCodecs::legacyClassic().decodeBodySize(1);

	ASSERT_TRUE(modernSize);
	ASSERT_TRUE(rawSize);
	ASSERT_TRUE(legacySize);
	EXPECT_EQ(XTEA_MULTIPLE + CHECKSUM_LENGTH, *modernSize);
	EXPECT_EQ(1, *rawSize);
	EXPECT_EQ(1, *legacySize);
	EXPECT_EQ(CHECKSUM_LENGTH + 2, TransportCodecs::currentModern().getProfile().serverFirstPacketHeaderBytes);
	EXPECT_EQ(CHECKSUM_LENGTH + 1, TransportCodecs::legacyClassic().getProfile().serverFirstPacketHeaderBytes);
}

TEST(ConnectionTransportTest, LegacyEncryptedOutboundHeaderFitsInitialBuffer) {
	constexpr auto legacyEncryptedHeaderSize = HEADER_LENGTH + CHECKSUM_LENGTH + sizeof(uint16_t);
	EXPECT_GE(NetworkMessage::INITIAL_BUFFER_POSITION, legacyEncryptedHeaderSize);
}

TEST(ConnectionTransportTest, CurrentEncryptedPayloadExcludesPaddingHeader) {
	constexpr std::array<uint32_t, 4> xteaKey {
		0x10203040,
		0x11223344,
		0x55667788,
		0x90ABCDEF,
	};
	CurrentTransportProtocol sender(xteaKey);
	CurrentTransportProtocol receiver(xteaKey);
	OutputMessage outgoing;
	outgoing.addByte(0x5F);
	outgoing.addByte(0x01);

	const auto &codec = TransportCodecs::currentModern();
	codec.encodeOutbound(sender, outgoing);

	NetworkMessage incoming;
	std::memcpy(incoming.getBuffer(), outgoing.getOutputBuffer(), outgoing.getLength());
	incoming.setLength(outgoing.getLength());
	incoming.setBufferPosition(HEADER_LENGTH);
	ASSERT_TRUE(codec.prepareInbound(receiver, incoming));

	EXPECT_EQ(0x5F, incoming.getByte());
	EXPECT_EQ(1, incoming.getUnreadBytes());
	EXPECT_EQ(0x01, incoming.getByte());
	EXPECT_EQ(0, incoming.getUnreadBytes());
	EXPECT_FALSE(incoming.canRead(1));
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
