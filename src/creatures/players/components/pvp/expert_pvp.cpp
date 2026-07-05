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
#include "creatures/creature.hpp"
#include "creatures/players/grouping/groups.hpp"
#include "creatures/players/player.hpp"

namespace {
	[[nodiscard]] bool isAccessPlayer(const std::shared_ptr<Player> &player) {
		if (!player) {
			return false;
		}

		const auto &group = player->getGroup();
		return group && group->access;
	}

	[[nodiscard]] std::shared_ptr<Player> getMasterPlayer(const std::shared_ptr<Creature> &creature) {
		const auto &master = creature ? creature->getMaster() : nullptr;
		return master ? master->getPlayer() : nullptr;
	}

	[[nodiscard]] bool isSkulledClientTarget(const std::shared_ptr<Player> &actor, const std::shared_ptr<Player> &subjectPlayer) {
		if (!actor || !subjectPlayer) {
			return false;
		}

		const auto skull = actor->getSkullClient(subjectPlayer);
		return skull != SKULL_NONE && skull != SKULL_GREEN;
	}

	[[nodiscard]] bool isAlwaysAllowedRelation(ExpertPvpRelation relation) {
		switch (relation) {
			case ExpertPvpRelation::Self:
			case ExpertPvpRelation::AccessPlayer:
			case ExpertPvpRelation::Monster:
			case ExpertPvpRelation::Npc:
				return true;
			default:
				return false;
		}
	}

	[[nodiscard]] ExpertPvpDecisionReason reasonForAllowedRelation(ExpertPvpRelation relation) {
		switch (relation) {
			case ExpertPvpRelation::Self:
				return ExpertPvpDecisionReason::Self;
			case ExpertPvpRelation::AccessPlayer:
				return ExpertPvpDecisionReason::AccessPlayer;
			case ExpertPvpRelation::Monster:
				return ExpertPvpDecisionReason::Monster;
			case ExpertPvpRelation::Npc:
				return ExpertPvpDecisionReason::Npc;
			default:
				return ExpertPvpDecisionReason::Neutral;
		}
	}

	void describePvpPressure(ExpertPvpDecision &decision, const ExpertPvpRelationContext &relationContext) {
		decision.sideEffectOwnerGuid = relationContext.actorGuid;
		decision.startsFight = true;
		decision.appliesPzLock = true;
	}

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

	if (context.subjectIsPlayerSummon) {
		result.relation = ExpertPvpRelation::PlayerSummon;
		return result;
	}

	if (context.subjectIsMonster) {
		result.relation = ExpertPvpRelation::Monster;
		return result;
	}

	if (context.subjectIsPlayer) {
		result.relation = ExpertPvpRelation::NeutralPlayer;
	}

	return result;
}

ExpertPvpRelationResult ExpertPvp::classifyRelation(const std::shared_ptr<Player> &actor, const std::shared_ptr<Creature> &subject) {
	ExpertPvpRelationContext context;
	if (!actor || !subject) {
		return classifyRelation(context);
	}

	context.actorGuid = actor->getGUID();
	context.actorMode = actor->getPvpMode();
	context.actorIsAccessPlayer = isAccessPlayer(actor);

	const auto subjectPlayer = subject->getPlayer();
	const auto subjectMonster = subject->getMonster();
	const auto subjectOwnerPlayer = subjectPlayer ? subjectPlayer : getMasterPlayer(subject);
	if (subjectOwnerPlayer) {
		context.subjectGuid = subjectOwnerPlayer->getGUID();
	}

	context.subjectIsPlayer = subjectPlayer != nullptr;
	context.subjectIsMonster = subjectMonster != nullptr;
	context.subjectIsPlayerSummon = !subjectPlayer && subject->isSummon() && subjectOwnerPlayer != nullptr;
	context.subjectIsNpc = subject->getNpc() != nullptr;
	context.subjectIsAccessPlayer = isAccessPlayer(subjectOwnerPlayer);
	context.isSelf = subjectOwnerPlayer == actor;

	if (subjectOwnerPlayer && subjectOwnerPlayer != actor) {
		context.partyAlly = actor->isPartner(subjectOwnerPlayer);
		context.guildAlly = actor->isGuildMate(subjectOwnerPlayer);
		context.warEnemy = actor->isInWar(subjectOwnerPlayer);
		context.directAttacker = subjectOwnerPlayer->hasAttacked(actor);
		context.directTarget = actor->hasAttacked(subjectOwnerPlayer);
		context.skulledTarget = isSkulledClientTarget(actor, subjectOwnerPlayer);
	}

	return classifyRelation(context);
}

ExpertPvpDecision ExpertPvp::evaluateCombatAction(ExpertPvpActionKind actionKind, const ExpertPvpRelationContext &relationContext) {
	if (!isEnabled()) {
		const auto relation = classifyRelation(relationContext);

		ExpertPvpDecision decision;
		decision.actionKind = actionKind;
		decision.relation = relation.relation;
		decision.reason = ExpertPvpDecisionReason::FeatureDisabled;
		return decision;
	}

	return evaluateCombatAction(relationContext.actorMode, actionKind, relationContext);
}

ExpertPvpDecision ExpertPvp::evaluateCombatAction(PvpMode_t actorMode, ExpertPvpActionKind actionKind, const ExpertPvpRelationContext &relationContext) {
	const auto mode = normalizeMode(actorMode, ExpertPvpModeSource::StoredPlayerState);
	const auto relation = classifyRelation(relationContext);

	ExpertPvpDecision decision;
	decision.handled = true;
	decision.allowed = false;
	decision.actionKind = actionKind;
	decision.relation = relation.relation;

	if (!mode.accepted) {
		decision.reason = ExpertPvpDecisionReason::InvalidMode;
		return decision;
	}

	if (relation.relation == ExpertPvpRelation::Unknown) {
		decision.reason = ExpertPvpDecisionReason::MissingPlayer;
		return decision;
	}

	if (isAlwaysAllowedRelation(relation.relation)) {
		decision.allowed = true;
		decision.reason = reasonForAllowedRelation(relation.relation);
		return decision;
	}

	if (relation.relation == ExpertPvpRelation::PartyAlly || relation.relation == ExpertPvpRelation::GuildAlly) {
		decision.reason = ExpertPvpDecisionReason::Ally;
		return decision;
	}

	if (relation.relation == ExpertPvpRelation::WarEnemy) {
		decision.allowed = true;
		decision.reason = ExpertPvpDecisionReason::War;
		describePvpPressure(decision, relationContext);
		decision.appliesPzLock = false;
		return decision;
	}

	if (relation.relation == ExpertPvpRelation::DirectAttacker) {
		decision.allowed = true;
		decision.reason = ExpertPvpDecisionReason::DirectCombat;
		describePvpPressure(decision, relationContext);
		return decision;
	}

	if (relation.relation == ExpertPvpRelation::DirectTarget) {
		decision.reason = ExpertPvpDecisionReason::DirectCombat;
		if (mode.mode == PVP_MODE_YELLOW_HAND || mode.mode == PVP_MODE_RED_FIST) {
			decision.allowed = true;
			describePvpPressure(decision, relationContext);
		}
		return decision;
	}

	if (relation.relation == ExpertPvpRelation::SkulledTarget) {
		decision.reason = ExpertPvpDecisionReason::SkulledTarget;
		if (mode.mode == PVP_MODE_YELLOW_HAND || mode.mode == PVP_MODE_RED_FIST) {
			decision.allowed = true;
			describePvpPressure(decision, relationContext);
		}
		return decision;
	}

	decision.reason = ExpertPvpDecisionReason::Neutral;
	if (mode.mode == PVP_MODE_RED_FIST) {
		decision.allowed = true;
		decision.skullAction = ExpertPvpSkullAction::White;
		decision.countsUnjustified = true;
		describePvpPressure(decision, relationContext);
	}
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
