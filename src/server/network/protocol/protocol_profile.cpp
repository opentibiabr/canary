/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019–present OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#include "server/network/protocol/protocol_profile.hpp"

#ifndef USE_PRECOMPILED_HEADERS
	#include <algorithm>
	#include <array>
	#include <string>
	#include <string_view>
	#include <vector>
#endif

namespace {
	[[nodiscard]] std::string currentClientVersionLabel() {
		auto label = std::to_string(CLIENT_VERSION_UPPER);
		label += ".";
		if constexpr (CLIENT_VERSION_LOWER < 10) {
			label += "0";
		}
		label += std::to_string(CLIENT_VERSION_LOWER);
		return label;
	}

	[[nodiscard]] std::string joinProtocolLabels(const std::vector<std::string> &labels) {
		if (labels.empty()) {
			return {};
		}

		if (labels.size() == 1) {
			return labels.front();
		}

		std::string result;
		for (size_t index = 0; index < labels.size(); ++index) {
			if (index > 0) {
				result += index + 1 == labels.size() ? " and " : ", ";
			}
			result += labels[index];
		}
		return result;
	}

	constexpr TransportProfile rawClientFirstTransport {
		.id = TransportProfileId::RawClientFirst,
		.outerLength = OuterLengthEncoding::RawBodyLength,
		.encryptedPayload = EncryptedPayloadLayout::None,
		.inboundChecksum = CHECKSUM_METHOD_NONE,
		.outboundChecksum = CHECKSUM_METHOD_NONE,
		.compression = CompressionLayout::None,
		.modernLengthExtraBytes = 0,
		.serverFirstPacketHeaderBytes = 0,
		.hasCryptoHeader = false,
		.lengthIncludesChecksum = false,
		.sequenceHighBitSignalsCompression = false,
	};

	constexpr TransportProfile currentLoginTransport {
		.id = TransportProfileId::CurrentLogin,
		.outerLength = OuterLengthEncoding::ModernBlockCount,
		.encryptedPayload = EncryptedPayloadLayout::ModernPaddingByte,
		.inboundChecksum = CHECKSUM_METHOD_ADLER32,
		.outboundChecksum = CHECKSUM_METHOD_ADLER32,
		.compression = CompressionLayout::None,
		.modernLengthExtraBytes = CHECKSUM_LENGTH,
		.serverFirstPacketHeaderBytes = 0,
		.hasCryptoHeader = true,
		.lengthIncludesChecksum = true,
		.sequenceHighBitSignalsCompression = false,
	};

	constexpr TransportProfile currentGameSequenceTransport {
		.id = TransportProfileId::CurrentGameSequence,
		.outerLength = OuterLengthEncoding::ModernBlockCount,
		.encryptedPayload = EncryptedPayloadLayout::ModernPaddingByte,
		.inboundChecksum = CHECKSUM_METHOD_SEQUENCE,
		.outboundChecksum = CHECKSUM_METHOD_SEQUENCE,
		.compression = CompressionLayout::Official,
		.modernLengthExtraBytes = CHECKSUM_LENGTH,
		.serverFirstPacketHeaderBytes = CHECKSUM_LENGTH + 2,
		.hasCryptoHeader = true,
		.lengthIncludesChecksum = true,
		.sequenceHighBitSignalsCompression = true,
	};

	constexpr TransportProfile currentGamePlainTransport {
		.id = TransportProfileId::CurrentGamePlain,
		.outerLength = OuterLengthEncoding::ModernBlockCount,
		.encryptedPayload = EncryptedPayloadLayout::ModernPaddingByte,
		.inboundChecksum = CHECKSUM_METHOD_NONE,
		.outboundChecksum = CHECKSUM_METHOD_NONE,
		.compression = CompressionLayout::None,
		.modernLengthExtraBytes = CHECKSUM_LENGTH,
		.serverFirstPacketHeaderBytes = CHECKSUM_LENGTH + 2,
		.hasCryptoHeader = true,
		.lengthIncludesChecksum = false,
		.sequenceHighBitSignalsCompression = false,
	};

	constexpr TransportProfile legacyRawWithLoginHeaderTransport {
		.id = TransportProfileId::LegacyRawWithLoginHeader,
		.outerLength = OuterLengthEncoding::RawBodyLength,
		.encryptedPayload = EncryptedPayloadLayout::LegacyInnerLength,
		.inboundChecksum = CHECKSUM_METHOD_ADLER32,
		.outboundChecksum = CHECKSUM_METHOD_ADLER32,
		.compression = CompressionLayout::None,
		.modernLengthExtraBytes = 0,
		.serverFirstPacketHeaderBytes = CHECKSUM_LENGTH + 1,
		.hasCryptoHeader = true,
		.lengthIncludesChecksum = true,
		.sequenceHighBitSignalsCompression = false,
	};

	constexpr TransportProfile legacyClassicTransport {
		.id = TransportProfileId::LegacyClassic,
		.outerLength = OuterLengthEncoding::RawBodyLength,
		.encryptedPayload = EncryptedPayloadLayout::LegacyInnerLength,
		.inboundChecksum = CHECKSUM_METHOD_ADLER32,
		.outboundChecksum = CHECKSUM_METHOD_ADLER32,
		.compression = CompressionLayout::None,
		.modernLengthExtraBytes = 0,
		.serverFirstPacketHeaderBytes = CHECKSUM_LENGTH + 1,
		.hasCryptoHeader = true,
		.lengthIncludesChecksum = true,
		.sequenceHighBitSignalsCompression = false,
	};

	constexpr InitialConnectionBehavior currentInitialBehavior {
		.transport = TransportProfileId::CurrentGamePlain,
		.challenge = {
			.flow = GameHandshakeFlow::ServerChallengeBeforeLogin,
			.layout = ChallengeLayout::CurrentLoginChallenge,
		},
		.expectedProfile = ProtocolProfileId::Current,
	};

	constexpr InitialConnectionBehavior tibia1100InitialBehavior {
		.transport = TransportProfileId::LegacyRawWithLoginHeader,
		.challenge = {
			.flow = GameHandshakeFlow::ServerChallengeBeforeLogin,
			.layout = ChallengeLayout::Tibia1100LoginChallenge,
		},
		.expectedProfile = ProtocolProfileId::Tibia1100,
	};

	constexpr InitialConnectionBehavior cipsoft860InitialBehavior {
		.transport = TransportProfileId::LegacyClassic,
		.challenge = {
			.flow = GameHandshakeFlow::ServerChallengeBeforeLogin,
			.layout = ChallengeLayout::Cipsoft860LoginChallenge,
		},
		.expectedProfile = ProtocolProfileId::Cipsoft860Vanilla,
	};

	constexpr InitialConnectionBehavior cipsoft860ExtendedAssetsInitialBehavior {
		.transport = TransportProfileId::LegacyClassic,
		.challenge = {
			.flow = GameHandshakeFlow::ServerChallengeBeforeLogin,
			.layout = ChallengeLayout::Cipsoft860LoginChallenge,
		},
		.expectedProfile = ProtocolProfileId::Cipsoft860ExtendedAssets,
	};

	constexpr InitialConnectionBehavior cipsoft860CanaryExtendedInitialBehavior {
		.transport = TransportProfileId::LegacyClassic,
		.challenge = {
			.flow = GameHandshakeFlow::ServerChallengeBeforeLogin,
			.layout = ChallengeLayout::Cipsoft860LoginChallenge,
		},
		.expectedProfile = ProtocolProfileId::Cipsoft860CanaryExtended,
	};

	constexpr InitialConnectionBehavior otcv8Extended860InitialBehavior {
		.transport = TransportProfileId::LegacyClassic,
		.challenge = {
			.flow = GameHandshakeFlow::ServerChallengeBeforeLogin,
			.layout = ChallengeLayout::Cipsoft860LoginChallenge,
		},
		.expectedProfile = ProtocolProfileId::OTCv8Extended860,
	};

	constexpr ClientAssetSignatures cipsoft860CanaryAssetSignatures {
		.dat = 0x44363843, // "C86D"
		.spr = 0x53363843, // "C86S"
		.pic = 0x50363843, // "C86P"
	};

	constexpr ClientAssetSignatures cipsoft860DevelopmentAssetSignatures {
		.dat = 0x4C2C7993,
		.spr = 0x4C220594,
		.pic = 0x4AE5C3D3,
	};

	constexpr ClientAssetSignatures cipsoft860ExtendedClientLibrarySignatures {
		.dat = 0x44545845, // "EXTD"
		.spr = 0x44545845, // "EXTD"
		.pic = 0x44545845, // "EXTD"
	};

	constexpr ClientAssetSignatures cipsoft860ExtendedClientLibrarySpriteSignature {
		.dat = 0x4C2C7993,
		.spr = 0x44545845, // "EXTD"
		.pic = 0x4AE5C3D3,
	};

	[[nodiscard]] constexpr bool isCipsoft860CanaryAssetPackage(const ClientAssetSignatures &signatures) {
		// The currently shipped extended 8.60 packages resolve to the Canary-owned
		// runtime profile. Cipsoft860ExtendedAssets stays registered for explicit
		// layout/metadata access, but it is not auto-selected by these signatures.
		return signatures == cipsoft860CanaryAssetSignatures
			|| signatures == cipsoft860DevelopmentAssetSignatures
			|| signatures == cipsoft860ExtendedClientLibrarySignatures
			|| signatures == cipsoft860ExtendedClientLibrarySpriteSignature;
	}

	constexpr ProtocolProfile currentProfile {
		.id = ProtocolProfileId::Current,
		.clientVersion = CLIENT_VERSION,
		.wireFamily = ClientWireFamily::CipsoftVanilla,
		.rsaKeyFamily = RSAKeyFamily::OpenTibia,
		.supportState = ProtocolSupportState::Enabled,
		.itemMapperPolicy = ItemMapperPolicy::NotRequired,
		.initialBehavior = currentInitialBehavior,
		.features = protocolFeatureMask(ProtocolFeature::CurrentPayload | ProtocolFeature::LoginSpeedFormula | ProtocolFeature::ModernLoginSideSystems | ProtocolFeature::ResourceBalancePackets | ProtocolFeature::CustomMonkPackets | ProtocolFeature::MarketPackets | ProtocolFeature::ImbuementWindow | ProtocolFeature::MemorialPackets | ProtocolFeature::PlayerDataLevelPercentU16 | ProtocolFeature::GameEventPayload | ProtocolFeature::OfficialTaskboardPackets | ProtocolFeature::OfficialVocationSpecificPlayerData | ProtocolFeature::OfficialWeaponProficiencyPayload | ProtocolFeature::GraphicalEffectSourceByte | ProtocolFeature::OfficialSoulSealsPackets | ProtocolFeature::OfficialSkillWheelPayload),
		.name = "current",
		.supportLabel = "",
	};

	constexpr ProtocolProfile tibia1100Profile {
		.id = ProtocolProfileId::Tibia1100,
		.clientVersion = 1100,
		.wireFamily = ClientWireFamily::CipsoftVanilla,
		.rsaKeyFamily = RSAKeyFamily::OpenTibia,
		.supportState = ProtocolSupportState::Enabled,
		.itemMapperPolicy = ItemMapperPolicy::NotRequired,
		.initialBehavior = tibia1100InitialBehavior,
		.features = protocolFeatureMask(ProtocolFeature::OldProtocolCompat | ProtocolFeature::LegacyPayload | ProtocolFeature::LoginSpeedFormula | ProtocolFeature::MarketPackets | ProtocolFeature::ImbuementWindow),
		.name = "tibia1100",
		.supportLabel = "10x",
	};

	constexpr ProtocolProfile cipsoft860Profile {
		.id = ProtocolProfileId::Cipsoft860Vanilla,
		.clientVersion = 860,
		.wireFamily = ClientWireFamily::CipsoftVanilla,
		.rsaKeyFamily = RSAKeyFamily::OpenTibia,
		.supportState = ProtocolSupportState::Enabled,
		.itemMapperPolicy = ItemMapperPolicy::RequiredBeforeWorldEnter,
		.initialBehavior = cipsoft860InitialBehavior,
		.features = protocolFeatureMask(ProtocolFeature::OldProtocolCompat | ProtocolFeature::LegacyPayload | ProtocolFeature::RequiresItemMapper | ProtocolFeature::InlineLoginBugReportFlag),
		.name = "cipsoft860vanilla",
		.supportLabel = "8.6",
	};

	constexpr ProtocolProfile cipsoft860ExtendedAssetsProfile {
		.id = ProtocolProfileId::Cipsoft860ExtendedAssets,
		.clientVersion = 860,
		.wireFamily = ClientWireFamily::CipsoftVanilla,
		.rsaKeyFamily = RSAKeyFamily::OpenTibia,
		.supportState = ProtocolSupportState::Enabled,
		.itemMapperPolicy = ItemMapperPolicy::NotRequired,
		.initialBehavior = cipsoft860ExtendedAssetsInitialBehavior,
		.assetSignatures = cipsoft860DevelopmentAssetSignatures,
		.features = protocolFeatureMask(ProtocolFeature::OldProtocolCompat | ProtocolFeature::LegacyPayload | ProtocolFeature::ExtendedSpriteFiles | ProtocolFeature::InlineLoginBugReportFlag),
		.name = "cipsoft860extendedassets",
		.supportLabel = "8.6",
	};

	constexpr ProtocolProfile cipsoft860CanaryExtendedProfile {
		.id = ProtocolProfileId::Cipsoft860CanaryExtended,
		.clientVersion = 860,
		.wireFamily = ClientWireFamily::CipsoftVanilla,
		.rsaKeyFamily = RSAKeyFamily::OpenTibia,
		.supportState = ProtocolSupportState::Enabled,
		.itemMapperPolicy = ItemMapperPolicy::NotRequired,
		.initialBehavior = cipsoft860CanaryExtendedInitialBehavior,
		.assetSignatures = cipsoft860CanaryAssetSignatures,
		.features = protocolFeatureMask(ProtocolFeature::OldProtocolCompat | ProtocolFeature::LegacyPayload | ProtocolFeature::ExtendedSpriteFiles | ProtocolFeature::MagicEffectU16 | ProtocolFeature::InlineLoginBugReportFlag),
		.name = "cipsoft860canaryextended",
		.supportLabel = "8.6",
	};

	constexpr ProtocolProfile otcv8Extended860Profile {
		.id = ProtocolProfileId::OTCv8Extended860,
		.clientVersion = 860,
		.wireFamily = ClientWireFamily::OTCv8Extended,
		.rsaKeyFamily = RSAKeyFamily::OpenTibia,
		.supportState = ProtocolSupportState::BlockedPendingFixture,
		.itemMapperPolicy = ItemMapperPolicy::RequiredBeforeWorldEnter,
		.initialBehavior = otcv8Extended860InitialBehavior,
		.features = protocolFeatureMask(ProtocolFeature::OldProtocolCompat | ProtocolFeature::LegacyPayload | ProtocolFeature::RequiresItemMapper | ProtocolFeature::InlineLoginBugReportFlag),
		.name = "otcv8extended860",
		.supportLabel = "8.6",
	};

	constexpr std::array<const ProtocolProfile*, 6> registeredProfiles {
		&currentProfile,
		&tibia1100Profile,
		&cipsoft860Profile,
		&cipsoft860ExtendedAssetsProfile,
		&cipsoft860CanaryExtendedProfile,
		&otcv8Extended860Profile,
	};

	constexpr AccountLoginLayout currentAccountLoginLayout {
		.profileId = ProtocolProfileId::Current,
		.clientVersion = CLIENT_VERSION,
		.responseTransport = TransportProfileId::CurrentLogin,
		.bytesToSkipBeforeRsa = 17,
		.characterListLayout = AccountCharacterListLayout::WorldListWithSessionKey,
		.sendsSessionKey = true,
	};

	constexpr AccountLoginLayout tibia1100AccountLoginLayout {
		.profileId = ProtocolProfileId::Tibia1100,
		.clientVersion = 1100,
		.responseTransport = TransportProfileId::LegacyClassic,
		.bytesToSkipBeforeRsa = 17,
		.characterListLayout = AccountCharacterListLayout::WorldListWithSessionKey,
		.sendsSessionKey = true,
	};

	constexpr AccountLoginLayout cipsoft860AccountLoginLayout {
		.profileId = ProtocolProfileId::Cipsoft860Vanilla,
		.clientVersion = 860,
		.responseTransport = TransportProfileId::LegacyClassic,
		.bytesToSkipBeforeRsa = 12,
		.hasAssetSignaturesBeforeRsa = true,
		.characterListLayout = AccountCharacterListLayout::LegacyCharacterList,
		.sendsSessionKey = false,
	};

	constexpr AccountLoginLayout cipsoft860ExtendedAssetsAccountLoginLayout {
		.profileId = ProtocolProfileId::Cipsoft860ExtendedAssets,
		.clientVersion = 860,
		.responseTransport = TransportProfileId::LegacyClassic,
		.bytesToSkipBeforeRsa = 12,
		.hasAssetSignaturesBeforeRsa = true,
		.characterListLayout = AccountCharacterListLayout::LegacyCharacterList,
		.sendsSessionKey = false,
	};

	constexpr AccountLoginLayout cipsoft860CanaryExtendedAccountLoginLayout {
		.profileId = ProtocolProfileId::Cipsoft860CanaryExtended,
		.clientVersion = 860,
		.responseTransport = TransportProfileId::LegacyClassic,
		.bytesToSkipBeforeRsa = 12,
		.hasAssetSignaturesBeforeRsa = true,
		.characterListLayout = AccountCharacterListLayout::LegacyCharacterList,
		.sendsSessionKey = false,
	};

	constexpr GameLoginLayout currentGameLoginLayout {
		.profileId = ProtocolProfileId::Current,
		.clientVersion = CLIENT_VERSION,
		.hasClientVersionU32 = true,
		.hasClientVersionString = true,
		.hasAssetHashString = true,
		.hasContentRevisionU16 = false,
		.hasPreviewState = true,
		.authenticationLayout = GameLoginAuthenticationLayout::SessionKey,
		.hasChallengeResponse = true,
		.hasOtcV8Probe = true,
	};

	constexpr GameLoginLayout tibia1100GameLoginLayout {
		.profileId = ProtocolProfileId::Tibia1100,
		.clientVersion = 1100,
		.hasClientVersionU32 = true,
		.hasClientVersionString = false,
		.hasAssetHashString = false,
		.hasContentRevisionU16 = true,
		.hasPreviewState = true,
		.authenticationLayout = GameLoginAuthenticationLayout::SessionKey,
		.hasChallengeResponse = true,
		.hasOtcV8Probe = true,
	};

	constexpr GameLoginLayout cipsoft860GameLoginLayout {
		.profileId = ProtocolProfileId::Cipsoft860Vanilla,
		.clientVersion = 860,
		.hasClientVersionU32 = false,
		.hasClientVersionString = false,
		.hasAssetHashString = false,
		.hasContentRevisionU16 = false,
		.hasPreviewState = false,
		.authenticationLayout = GameLoginAuthenticationLayout::AccountPassword,
		.hasChallengeResponse = true,
		.hasOtcV8Probe = false,
	};

	constexpr GameLoginLayout cipsoft860ExtendedAssetsGameLoginLayout {
		.profileId = ProtocolProfileId::Cipsoft860ExtendedAssets,
		.clientVersion = 860,
		.hasClientVersionU32 = false,
		.hasClientVersionString = false,
		.hasAssetHashString = false,
		.hasContentRevisionU16 = false,
		.hasPreviewState = false,
		.authenticationLayout = GameLoginAuthenticationLayout::AccountPassword,
		.hasChallengeResponse = true,
		.hasOtcV8Probe = false,
	};

	constexpr GameLoginLayout cipsoft860CanaryExtendedGameLoginLayout {
		.profileId = ProtocolProfileId::Cipsoft860CanaryExtended,
		.clientVersion = 860,
		.hasClientVersionU32 = false,
		.hasClientVersionString = false,
		.hasAssetHashString = false,
		.hasContentRevisionU16 = false,
		.hasPreviewState = false,
		.authenticationLayout = GameLoginAuthenticationLayout::AccountPassword,
		.hasChallengeResponse = true,
		.hasOtcV8Probe = false,
	};
}

const TransportProfile &ProtocolProfileRegistry::getTransportProfile(TransportProfileId id) {
	using enum TransportProfileId;
	switch (id) {
		case CurrentLogin:
			return currentLoginTransport;
		case CurrentGameSequence:
			return currentGameSequenceTransport;
		case CurrentGamePlain:
			return currentGamePlainTransport;
		case LegacyRawWithLoginHeader:
			return legacyRawWithLoginHeaderTransport;
		case LegacyClassic:
			return legacyClassicTransport;
		default:
			return rawClientFirstTransport;
	}
}

const ProtocolProfile &ProtocolProfileRegistry::getCurrentProfile() {
	return currentProfile;
}

const ProtocolProfile* ProtocolProfileRegistry::getProfile(ProtocolProfileId id) {
	using enum ProtocolProfileId;
	switch (id) {
		case Current:
			return &currentProfile;
		case Tibia1100:
			return &tibia1100Profile;
		case Cipsoft860Vanilla:
			return &cipsoft860Profile;
		case Cipsoft860ExtendedAssets:
			return &cipsoft860ExtendedAssetsProfile;
		case Cipsoft860CanaryExtended:
			return &cipsoft860CanaryExtendedProfile;
		case OTCv8Extended860:
			return &otcv8Extended860Profile;
		default:
			return nullptr;
	}
}

const ProtocolProfile* ProtocolProfileRegistry::resolveByClientVersion(uint16_t version, ClientWireFamily family /*= ClientWireFamily::CipsoftVanilla*/) {
	if (version == CLIENT_VERSION) {
		return &currentProfile;
	}

	if (version == 1100) {
		return &tibia1100Profile;
	}

	if (version == 860) {
		if (family == ClientWireFamily::OTCv8Extended) {
			return &otcv8Extended860Profile;
		}
		return &cipsoft860Profile;
	}

	return nullptr;
}

const ProtocolProfile* ProtocolProfileRegistry::resolveByClientVersionAndAssets(uint16_t version, const ClientAssetSignatures &signatures, ClientWireFamily family /*= ClientWireFamily::CipsoftVanilla*/) {
	const auto* profile = resolveByClientVersion(version, family);
	if (!profile) {
		return nullptr;
	}

	if (version == 860 && family == ClientWireFamily::CipsoftVanilla && isCipsoft860CanaryAssetPackage(signatures)) {
		return &cipsoft860CanaryExtendedProfile;
	}

	return profile;
}

const AccountLoginLayout* ProtocolProfileRegistry::resolveAccountLoginLayout(uint16_t version) {
	if (version == CLIENT_VERSION) {
		return &currentAccountLoginLayout;
	}

	if (version == 1100) {
		return &tibia1100AccountLoginLayout;
	}

	if (version == 860) {
		return &cipsoft860AccountLoginLayout;
	}

	return nullptr;
}

const AccountLoginLayout* ProtocolProfileRegistry::resolveAccountLoginLayout(ProtocolProfileId id) {
	using enum ProtocolProfileId;
	switch (id) {
		case Current:
			return &currentAccountLoginLayout;
		case Tibia1100:
			return &tibia1100AccountLoginLayout;
		case Cipsoft860Vanilla:
			return &cipsoft860AccountLoginLayout;
		case Cipsoft860ExtendedAssets:
			return &cipsoft860ExtendedAssetsAccountLoginLayout;
		case Cipsoft860CanaryExtended:
			return &cipsoft860CanaryExtendedAccountLoginLayout;
		default:
			return nullptr;
	}
}

const GameLoginLayout* ProtocolProfileRegistry::resolveGameLoginLayout(uint16_t version) {
	if (version == CLIENT_VERSION) {
		return &currentGameLoginLayout;
	}

	if (version == 1100) {
		return &tibia1100GameLoginLayout;
	}

	if (version == 860) {
		return &cipsoft860GameLoginLayout;
	}

	return nullptr;
}

const GameLoginLayout* ProtocolProfileRegistry::resolveGameLoginLayout(ProtocolProfileId id) {
	using enum ProtocolProfileId;
	switch (id) {
		case Current:
			return &currentGameLoginLayout;
		case Tibia1100:
			return &tibia1100GameLoginLayout;
		case Cipsoft860Vanilla:
			return &cipsoft860GameLoginLayout;
		case Cipsoft860ExtendedAssets:
			return &cipsoft860ExtendedAssetsGameLoginLayout;
		case Cipsoft860CanaryExtended:
			return &cipsoft860CanaryExtendedGameLoginLayout;
		default:
			return nullptr;
	}
}

InitialConnectionBehavior ProtocolProfileRegistry::defaultModernInitialBehavior() {
	return currentInitialBehavior;
}

std::string ProtocolProfileRegistry::getAllowedClientProtocolDescription(bool includeOldProtocolProfiles) {
	std::vector<std::string> labels;
	labels.push_back(currentClientVersionLabel());

	if (includeOldProtocolProfiles) {
		for (const auto* profile : registeredProfiles) {
			if (!profile
			    || profile->id == ProtocolProfileId::Current
			    || !isProfileAllowed(profile->id)
			    || profile->supportLabel.empty()
			    || !profile->hasFeature(ProtocolFeature::OldProtocolCompat)) {
				continue;
			}

			const auto alreadyListed = std::ranges::any_of(labels, [label = profile->supportLabel](const std::string &listedLabel) {
				return listedLabel == label;
			});
			if (!alreadyListed) {
				labels.emplace_back(profile->supportLabel);
			}
		}
	}

	return joinProtocolLabels(labels);
}

std::string ProtocolProfileRegistry::getUnsupportedClientProtocolMessage(bool includeOldProtocolProfiles) {
	const auto description = getAllowedClientProtocolDescription(includeOldProtocolProfiles);
	const auto hasMultipleProtocols = description.find(", ") != std::string::npos || description.find(" and ") != std::string::npos;
	return hasMultipleProtocols
		? "Only supported client protocols are " + description + "."
		: "Only supported client protocol is " + description + ".";
}

bool ProtocolProfileRegistry::isProfileAllowed(ProtocolProfileId id) {
	const auto* profile = getProfile(id);
	return profile && profile->supportState == ProtocolSupportState::Enabled;
}
