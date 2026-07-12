/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (c) 2019-present OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#pragma once

#include "creatures/creatures_definitions.hpp"

#ifndef USE_PRECOMPILED_HEADERS
	#include <cstdint>
	#include <vector>
#endif

enum class ExpertPvpModeSource : uint8_t {
	ClientByte = 0,
	DefaultForClient,
	StoredPlayerState,
	CastTimeFieldContext,
	LiveOwnerState,
};

enum class ExpertPvpRelation : uint8_t {
	Unknown = 0,
	Self,
	AccessPlayer,
	PartyAlly,
	GuildAlly,
	WarEnemy,
	DirectAttacker,
	ProtectedAllyAttacker,
	DirectTarget,
	SkulledTarget,
	NeutralPlayer,
	Monster,
	PlayerSummon,
	Npc,
};

enum class ExpertPvpActionKind : uint8_t {
	DirectAttack = 0,
	AreaSpell,
	RuneTarget,
	FieldDamage,
	FieldStep,
	PlayerWalkthrough,
	PathfindingProbe,
	VisualSerialization,
};

enum class ExpertPvpDecisionReason : uint8_t {
	FeatureDisabled = 0,
	NotEvaluated,
	CurrentCanaryFallback,
	InvalidMode,
	MissingPlayer,
	MissingFieldContext,
	Self,
	AccessPlayer,
	Neutral,
	Ally,
	War,
	DirectCombat,
	SkulledTarget,
	Monster,
	Npc,
};

enum class ExpertPvpSkullAction : uint8_t {
	None = 0,
	Yellow,
	White,
	Red,
};

enum class ExpertPvpSituationMark : uint8_t {
	None = 0,
	Yellow,
	Orange,
	Brown,
};

struct ExpertPvpModeResult {
	PvpMode_t mode = PVP_MODE_DOVE;
	ExpertPvpModeSource source = ExpertPvpModeSource::DefaultForClient;
	bool accepted = true;
	bool normalized = false;
	ExpertPvpDecisionReason reason = ExpertPvpDecisionReason::CurrentCanaryFallback;
};

struct ExpertPvpRelationContext {
	uint32_t actorGuid = 0;
	uint32_t subjectGuid = 0;
	PvpMode_t actorMode = PVP_MODE_DOVE;
	bool actorIsAccessPlayer = false;
	bool subjectIsAccessPlayer = false;
	bool isSelf = false;
	bool subjectIsPlayer = false;
	bool subjectIsMonster = false;
	bool subjectIsPlayerSummon = false;
	bool subjectIsNpc = false;
	bool partyAlly = false;
	bool guildAlly = false;
	bool warEnemy = false;
	bool directAttacker = false;
	bool protectedAllyAttacker = false;
	bool directTarget = false;
	bool skulledTarget = false;
};

struct ExpertPvpRelationResult {
	ExpertPvpRelation relation = ExpertPvpRelation::Unknown;
	ExpertPvpRelationContext facts {};
};

struct ExpertPvpSituation {
	uint32_t ownerGuid = 0;
	uint32_t otherGuid = 0;
	uint64_t expiresAt = 0;
	ExpertPvpActionKind reason = ExpertPvpActionKind::DirectAttack;
	bool affectsFields = false;
	bool affectsWalkthrough = false;
	bool affectsMarks = false;
	bool affectsUnjustifiedKills = false;
};

struct ExpertPvpDecision {
	bool handled = false;
	bool allowed = true;
	ExpertPvpActionKind actionKind = ExpertPvpActionKind::DirectAttack;
	ExpertPvpRelation relation = ExpertPvpRelation::Unknown;
	ExpertPvpDecisionReason reason = ExpertPvpDecisionReason::FeatureDisabled;
	uint32_t sideEffectOwnerGuid = 0;
	ExpertPvpSkullAction skullAction = ExpertPvpSkullAction::None;
	bool appliesPzLock = false;
	bool startsFight = false;
	bool sendsSquare = false;
	bool countsUnjustified = false;
};

struct ExpertPvpWalkthroughDecision {
	bool handled = false;
	bool canWalkThrough = false;
	ExpertPvpRelation relation = ExpertPvpRelation::Unknown;
	ExpertPvpDecisionReason reason = ExpertPvpDecisionReason::FeatureDisabled;
};

struct ExpertFieldContext {
	uint32_t ownerGuid = 0;
	ExpertPvpModeSource ownerModeSource = ExpertPvpModeSource::CastTimeFieldContext;
	PvpMode_t ownerMode = PVP_MODE_DOVE;
	uint16_t canonicalItemId = 0;
	uint16_t safeVisualItemId = 0;
	uint16_t blockingVisualItemId = 0;
	std::vector<uint32_t> ownerTargetsAtCast {};
	std::vector<uint32_t> ownerAttackersAtCast {};
	bool ownerWasPlayerOrSummon = false;

	explicit operator bool() const {
		return canonicalItemId != 0;
	}
};

struct ExpertPvpFieldStepDecision {
	bool handled = false;
	bool canStep = true;
	bool removeField = false;
	ExpertPvpRelation relation = ExpertPvpRelation::Unknown;
	ExpertPvpDecisionReason reason = ExpertPvpDecisionReason::FeatureDisabled;
	uint32_t sideEffectOwnerGuid = 0;
	ExpertPvpSkullAction skullAction = ExpertPvpSkullAction::None;
	bool appliesPzLock = false;
	bool startsFight = false;
	bool sendsSquare = false;
};

struct ExpertPvpFieldDamageDecision {
	bool handled = false;
	bool applyDamage = true;
	bool setConditionOwner = false;
	uint32_t conditionOwnerGuid = 0;
	ExpertPvpRelation relation = ExpertPvpRelation::Unknown;
	ExpertPvpDecisionReason reason = ExpertPvpDecisionReason::FeatureDisabled;
};

struct ExpertPvpFieldVisualDecision {
	bool handled = false;
	uint16_t clientItemId = 0;
	ExpertPvpRelation relation = ExpertPvpRelation::Unknown;
	ExpertPvpDecisionReason reason = ExpertPvpDecisionReason::FeatureDisabled;
};
