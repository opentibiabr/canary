/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019–present OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#pragma once

#include "core.hpp"
#include "server/server_definitions.hpp"

#ifndef USE_PRECOMPILED_HEADERS
	#include <cstdint>
	#include <optional>
	#include <string>
	#include <string_view>
#endif

enum class ProtocolProfileId : uint8_t {
	Current,
	Tibia1100,
	Cipsoft860Vanilla,
	Cipsoft860ExtendedAssets,
	Cipsoft860CanaryExtended,
	OTCv8Extended860,
};

enum class ClientWireFamily : uint8_t {
	CipsoftVanilla,
	OTClientCompatible,
	OTCv8Extended,
};

enum class RSAKeyFamily : uint8_t {
	OpenTibia,
	CipSoftOfficial,
};

enum class ProtocolSupportState : uint8_t {
	Enabled,
	BlockedPendingFixture,
};

enum class ItemMapperPolicy : uint8_t {
	NotRequired,
	RequiredBeforeWorldEnter,
	Optional,
};

enum class ProtocolFeature : uint64_t {
	None = 0,
	// When a feature is build/version-specific, document the first confirmed
	// protocol version here. Use verified client parser evidence or captures;
	// do not infer from the current profile alone.
	CurrentPayload = 1ULL << 0,
	OldProtocolCompat = 1ULL << 1,
	LegacyPayload = 1ULL << 2,
	RequiresItemMapper = 1ULL << 3,
	InlineLoginBugReportFlag = 1ULL << 4,
	ExtendedSpriteFiles = 1ULL << 5,
	MagicEffectU16 = 1ULL << 6,
	LoginSpeedFormula = 1ULL << 7,
	ModernLoginSideSystems = 1ULL << 8,
	ResourceBalancePackets = 1ULL << 9,
	CustomMonkPackets = 1ULL << 10,
	MarketPackets = 1ULL << 11,
	ImbuementWindow = 1ULL << 12,
	MemorialPackets = 1ULL << 13,
	// Modern 0xA0 player data sends level percent as centesimal u16 instead of u8.
	PlayerDataLevelPercentU16 = 1ULL << 14,
	// 0x75 uses a client event selector before event-specific fields.
	GameEventPayload = 1ULL << 15,
	OfficialTaskboardPackets = 1ULL << 16,
	OfficialVocationSpecificPlayerData = 1ULL << 17,
	OfficialWeaponProficiencyPayload = 1ULL << 18,
	GraphicalEffectSourceByte = 1ULL << 19,
	OfficialSoulSealsPackets = 1ULL << 20,
	OfficialSkillWheelPayload = 1ULL << 21, // 15.25 confirmed: 0x5F includes the current quest-bonus and gem-list layout.
};

[[nodiscard]] constexpr ProtocolFeature operator|(ProtocolFeature left, ProtocolFeature right) {
	return static_cast<ProtocolFeature>(static_cast<uint64_t>(left) | static_cast<uint64_t>(right));
}

[[nodiscard]] constexpr uint64_t protocolFeatureMask(ProtocolFeature feature) {
	return static_cast<uint64_t>(feature);
}

enum class TransportProfileId : uint8_t {
	RawClientFirst,
	CurrentLogin,
	CurrentGameSequence,
	CurrentGamePlain,
	LegacyRawWithLoginHeader,
	LegacyClassic,
};

enum class OuterLengthEncoding : uint8_t {
	RawBodyLength,
	ModernBlockCount,
};

enum class EncryptedPayloadLayout : uint8_t {
	None,
	ModernPaddingByte,
	LegacyInnerLength,
};

enum class CompressionLayout : uint8_t {
	None,
	OpenTibia,
	Official,
};

struct TransportProfile {
	TransportProfileId id = TransportProfileId::RawClientFirst;
	OuterLengthEncoding outerLength = OuterLengthEncoding::RawBodyLength;
	EncryptedPayloadLayout encryptedPayload = EncryptedPayloadLayout::None;
	ChecksumMethods_t inboundChecksum = CHECKSUM_METHOD_NONE;
	ChecksumMethods_t outboundChecksum = CHECKSUM_METHOD_NONE;
	CompressionLayout compression = CompressionLayout::None;
	uint16_t modernLengthExtraBytes = 0;
	uint8_t serverFirstPacketHeaderBytes = 0;
	bool hasCryptoHeader = false;
	bool lengthIncludesChecksum = false;
	bool sequenceHighBitSignalsCompression = false;
};

enum class GameHandshakeFlow : uint8_t {
	ServerChallengeBeforeLogin,
	ClientFirstLoginPacket,
};

enum class ChallengeLayout : uint8_t {
	CurrentLoginChallenge,
	Tibia1100LoginChallenge,
	Cipsoft860LoginChallenge,
};

struct ChallengeProfile {
	GameHandshakeFlow flow = GameHandshakeFlow::ClientFirstLoginPacket;
	ChallengeLayout layout = ChallengeLayout::CurrentLoginChallenge;

	[[nodiscard]] friend constexpr bool operator==(const ChallengeProfile &, const ChallengeProfile &) = default;
};

struct InitialConnectionBehavior {
	TransportProfileId transport = TransportProfileId::RawClientFirst;
	ChallengeProfile challenge {};
	ProtocolProfileId expectedProfile = ProtocolProfileId::Current;

	[[nodiscard]] constexpr bool hasSameWireBehavior(const InitialConnectionBehavior &other) const {
		return transport == other.transport
			&& challenge.flow == other.challenge.flow
			&& challenge.layout == other.challenge.layout;
	}

	[[nodiscard]] friend constexpr bool operator==(const InitialConnectionBehavior &, const InitialConnectionBehavior &) = default;
};

struct ClientAssetSignatures {
	uint32_t dat = 0;
	uint32_t spr = 0;
	uint32_t pic = 0;

	[[nodiscard]] friend constexpr bool operator==(const ClientAssetSignatures &, const ClientAssetSignatures &) = default;
};

struct ProtocolProfile {
	ProtocolProfileId id = ProtocolProfileId::Current;
	uint16_t clientVersion = CLIENT_VERSION;
	ClientWireFamily wireFamily = ClientWireFamily::CipsoftVanilla;
	RSAKeyFamily rsaKeyFamily = RSAKeyFamily::OpenTibia;
	ProtocolSupportState supportState = ProtocolSupportState::Enabled;
	ItemMapperPolicy itemMapperPolicy = ItemMapperPolicy::NotRequired;
	InitialConnectionBehavior initialBehavior {};
	ClientAssetSignatures assetSignatures {};
	uint64_t features = static_cast<uint64_t>(ProtocolFeature::None);
	std::string_view name;
	std::string_view supportLabel;

	[[nodiscard]] bool hasFeature(ProtocolFeature feature) const {
		return (features & static_cast<uint64_t>(feature)) != 0;
	}
};

enum class AccountCharacterListLayout : uint8_t {
	WorldListWithSessionKey,
	LegacyCharacterList,
};

enum class GameLoginAuthenticationLayout : uint8_t {
	SessionKey,
	AccountPassword,
};

struct AccountLoginLayout {
	ProtocolProfileId profileId = ProtocolProfileId::Current;
	uint16_t clientVersion = CLIENT_VERSION;
	TransportProfileId responseTransport = TransportProfileId::CurrentLogin;
	uint8_t bytesToSkipBeforeRsa = 17;
	bool hasAssetSignaturesBeforeRsa = false;
	AccountCharacterListLayout characterListLayout = AccountCharacterListLayout::WorldListWithSessionKey;
	bool sendsSessionKey = true;
};

struct GameLoginLayout {
	ProtocolProfileId profileId = ProtocolProfileId::Current;
	uint16_t clientVersion = CLIENT_VERSION;
	bool hasClientVersionU32 = true;
	bool hasClientVersionString = true;
	bool hasAssetHashString = true;
	bool hasContentRevisionU16 = false;
	bool hasPreviewState = true;
	GameLoginAuthenticationLayout authenticationLayout = GameLoginAuthenticationLayout::SessionKey;
	bool hasChallengeResponse = true;
	bool hasOtcV8Probe = true;
};

class ProtocolProfileRegistry {
public:
	[[nodiscard]] static const TransportProfile &getTransportProfile(TransportProfileId id);
	[[nodiscard]] static const ProtocolProfile &getCurrentProfile();
	[[nodiscard]] static const ProtocolProfile* getProfile(ProtocolProfileId id);
	[[nodiscard]] static const ProtocolProfile* resolveByClientVersion(uint16_t version, ClientWireFamily family = ClientWireFamily::CipsoftVanilla);
	[[nodiscard]] static const ProtocolProfile* resolveByClientVersionAndAssets(uint16_t version, const ClientAssetSignatures &signatures, ClientWireFamily family = ClientWireFamily::CipsoftVanilla);
	[[nodiscard]] static const AccountLoginLayout* resolveAccountLoginLayout(uint16_t version);
	[[nodiscard]] static const AccountLoginLayout* resolveAccountLoginLayout(ProtocolProfileId id);
	[[nodiscard]] static const GameLoginLayout* resolveGameLoginLayout(uint16_t version);
	[[nodiscard]] static const GameLoginLayout* resolveGameLoginLayout(ProtocolProfileId id);
	[[nodiscard]] static InitialConnectionBehavior defaultModernInitialBehavior();
	[[nodiscard]] static std::string getAllowedClientProtocolDescription(bool includeOldProtocolProfiles);
	[[nodiscard]] static std::string getUnsupportedClientProtocolMessage(bool includeOldProtocolProfiles);
	[[nodiscard]] static bool isProfileAllowed(ProtocolProfileId id);
};
