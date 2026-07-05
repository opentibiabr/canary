/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (c) 2019-present OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#include "creatures/players/components/pvp/expert_pvp.hpp"

#include "config/configmanager.hpp"

namespace {
	ExpertPvpModeResult makeModeResult(PvpMode_t mode, ExpertPvpModeSource source) {
		ExpertPvpModeResult result;
		result.mode = mode;
		result.source = source;
		result.reason = ExpertPvpDecisionReason::CurrentCanaryFallback;
		return result;
	}

	ExpertPvpDecisionReason disabledOrPendingReason() {
		return ExpertPvp::isEnabled() ? ExpertPvpDecisionReason::NotEvaluated : ExpertPvpDecisionReason::FeatureDisabled;
	}
} // namespace

bool ExpertPvp::isEnabled() {
	return g_configManager().getBoolean(EXPERT_PVP_ENABLED);
}

bool ExpertPvp::isValidMode(PvpMode_t mode) {
	switch (mode) {
		case PVP_MODE_DOVE:
		case PVP_MODE_WHITE_HAND:
		case PVP_MODE_YELLOW_HAND:
		case PVP_MODE_RED_FIST:
			return true;
		default:
			return false;
	}
}

ExpertPvpModeResult ExpertPvp::defaultModeForClient() {
	return makeModeResult(PVP_MODE_DOVE, ExpertPvpModeSource::DefaultForClient);
}

ExpertPvpModeResult ExpertPvp::modeFromClientByte(uint8_t rawMode) {
	return normalizeMode(static_cast<PvpMode_t>(rawMode), ExpertPvpModeSource::ClientByte);
}

ExpertPvpModeResult ExpertPvp::normalizeMode(PvpMode_t requestedMode, ExpertPvpModeSource source) {
	if (isValidMode(requestedMode)) {
		return makeModeResult(requestedMode, source);
	}

	ExpertPvpModeResult result = makeModeResult(PVP_MODE_DOVE, source);
	result.accepted = false;
	result.normalized = true;
	result.reason = ExpertPvpDecisionReason::InvalidMode;
	return result;
}

ExpertPvpRelationResult ExpertPvp::classifyRelation(const ExpertPvpRelationContext &context) {
	ExpertPvpRelationResult result;
	result.facts = context;

	if (context.isSelf) {
		result.relation = ExpertPvpRelation::Self;
		return result;
	}

	if (context.actorIsAccessPlayer || context.subjectIsAccessPlayer) {
		result.relation = ExpertPvpRelation::AccessPlayer;
		return result;
	}

	if (context.subjectIsNpc) {
		result.relation = ExpertPvpRelation::Npc;
		return result;
	}

	if (context.subjectIsPlayerSummon) {
		result.relation = ExpertPvpRelation::PlayerSummon;
		return result;
	}

	if (context.subjectIsMonster) {
		result.relation = ExpertPvpRelation::Monster;
		return result;
	}

	if (context.directAttacker) {
		result.relation = ExpertPvpRelation::DirectAttacker;
		return result;
	}

	if (context.directTarget) {
		result.relation = ExpertPvpRelation::DirectTarget;
		return result;
	}

	if (context.warEnemy) {
		result.relation = ExpertPvpRelation::WarEnemy;
		return result;
	}

	if (context.skulledTarget) {
		result.relation = ExpertPvpRelation::SkulledTarget;
		return result;
	}

	if (context.partyAlly) {
		result.relation = ExpertPvpRelation::PartyAlly;
		return result;
	}

	if (context.guildAlly) {
		result.relation = ExpertPvpRelation::GuildAlly;
		return result;
	}

	if (context.subjectIsPlayer) {
		result.relation = ExpertPvpRelation::NeutralPlayer;
	}

	return result;
}

ExpertPvpDecision ExpertPvp::evaluateCombatAction(ExpertPvpActionKind actionKind, const ExpertPvpRelationContext &relationContext) {
	const auto relation = classifyRelation(relationContext);

	ExpertPvpDecision decision;
	decision.actionKind = actionKind;
	decision.relation = relation.relation;
	decision.reason = disabledOrPendingReason();
	return decision;
}

ExpertPvpWalkthroughDecision ExpertPvp::canWalkThrough(const ExpertPvpRelationContext &relationContext) {
	const auto relation = classifyRelation(relationContext);

	ExpertPvpWalkthroughDecision decision;
	decision.relation = relation.relation;
	decision.reason = disabledOrPendingReason();
	return decision;
}

ExpertPvpFieldStepDecision ExpertPvp::evaluateFieldStep(const ExpertFieldContext &fieldContext, const ExpertPvpRelationContext &relationContext) {
	const auto relation = classifyRelation(relationContext);

	ExpertPvpFieldStepDecision decision;
	decision.relation = relation.relation;
	decision.reason = fieldContext ? disabledOrPendingReason() : ExpertPvpDecisionReason::MissingFieldContext;
	return decision;
}

ExpertPvpFieldDamageDecision ExpertPvp::evaluateFieldDamage(const ExpertFieldContext &fieldContext, const ExpertPvpRelationContext &relationContext) {
	const auto relation = classifyRelation(relationContext);

	ExpertPvpFieldDamageDecision decision;
	decision.relation = relation.relation;
	decision.reason = fieldContext ? disabledOrPendingReason() : ExpertPvpDecisionReason::MissingFieldContext;
	return decision;
}

ExpertPvpFieldVisualDecision ExpertPvp::getFieldClientId(const ExpertFieldContext &fieldContext, const ExpertPvpRelationContext &relationContext) {
	const auto relation = classifyRelation(relationContext);

	ExpertPvpFieldVisualDecision decision;
	decision.clientItemId = fieldContext.canonicalItemId;
	decision.relation = relation.relation;
	decision.reason = fieldContext ? disabledOrPendingReason() : ExpertPvpDecisionReason::MissingFieldContext;
	return decision;
}
