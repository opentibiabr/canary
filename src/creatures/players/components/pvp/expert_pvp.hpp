/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (c) 2019-present OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#pragma once

#include "creatures/players/components/pvp/expert_pvp_definitions.hpp"

#ifndef USE_PRECOMPILED_HEADERS
	#include <memory>
#endif

class Creature;
class Item;
class Player;

class ExpertPvp {
public:
	ExpertPvp() = delete;

	[[nodiscard]] static bool isEnabled();
	[[nodiscard]] static bool isValidMode(PvpMode_t mode);

	[[nodiscard]] static ExpertPvpModeResult defaultModeForClient();
	[[nodiscard]] static ExpertPvpModeResult modeFromClientByte(uint8_t rawMode);
	[[nodiscard]] static ExpertPvpModeResult normalizeMode(PvpMode_t requestedMode, ExpertPvpModeSource source = ExpertPvpModeSource::StoredPlayerState);

	[[nodiscard]] static ExpertPvpRelationResult classifyRelation(const ExpertPvpRelationContext &context);
	[[nodiscard]] static ExpertPvpRelationResult classifyRelation(const std::shared_ptr<Player> &actor, const std::shared_ptr<Creature> &subject);
	[[nodiscard]] static ExpertPvpRelationResult classifyFieldRelation(const ExpertFieldContext &fieldContext, const std::shared_ptr<Creature> &subject);
	[[nodiscard]] static ExpertPvpDecision evaluateCombatAction(ExpertPvpActionKind actionKind, const ExpertPvpRelationContext &relationContext);
	[[nodiscard]] static ExpertPvpDecision evaluateCombatAction(PvpMode_t actorMode, ExpertPvpActionKind actionKind, const ExpertPvpRelationContext &relationContext);
	[[nodiscard]] static ExpertPvpWalkthroughDecision canWalkThrough(const ExpertPvpRelationContext &relationContext);
	[[nodiscard]] static ExpertPvpWalkthroughDecision evaluateWalkthrough(const ExpertPvpRelationContext &relationContext);
	[[nodiscard]] static ExpertPvpFieldStepDecision evaluateFieldStep(const ExpertFieldContext &fieldContext, const ExpertPvpRelationContext &relationContext);
	[[nodiscard]] static ExpertPvpFieldDamageDecision evaluateFieldDamage(const ExpertFieldContext &fieldContext, const ExpertPvpRelationContext &relationContext);
	[[nodiscard]] static ExpertPvpFieldVisualDecision getFieldClientId(const ExpertFieldContext &fieldContext, const ExpertPvpRelationContext &relationContext);
	static void applyFieldStepSideEffects(const ExpertPvpFieldStepDecision &decision);

	[[nodiscard]] static bool isExpertFieldItem(uint16_t itemId);
	[[nodiscard]] static ExpertFieldContext makeFieldContext(uint32_t ownerGuid, PvpMode_t ownerMode, uint16_t itemId, bool ownerWasPlayerOrSummon);
	[[nodiscard]] static ExpertFieldContext getFieldContext(const std::shared_ptr<Item> &item);
	[[nodiscard]] static ExpertFieldContext attachFieldContext(const std::shared_ptr<Item> &item, const std::shared_ptr<Creature> &owner);
};
