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
#include "game/game.hpp"
#include "items/item.hpp"

namespace {
	constexpr auto expertFieldOwnerGuidAttribute = "expertPvpOwnerGuid";
	constexpr auto expertFieldOwnerModeAttribute = "expertPvpOwnerMode";
	constexpr auto expertFieldCanonicalItemIdAttribute = "expertPvpCanonicalItemId";
	constexpr auto expertFieldSafeVisualItemIdAttribute = "expertPvpSafeVisualItemId";
	constexpr auto expertFieldBlockingVisualItemIdAttribute = "expertPvpBlockingVisualItemId";
	constexpr auto expertFieldOwnerWasPlayerOrSummonAttribute = "expertPvpOwnerWasPlayerOrSummon";

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

	[[nodiscard]] std::shared_ptr<Player> getOwnerPlayer(const std::shared_ptr<Creature> &creature) {
		if (!creature) {
			return nullptr;
		}

		if (const auto &player = creature->getPlayer()) {
			return player;
		}

		return getMasterPlayer(creature);
	}

	[[nodiscard]] uint32_t getCustomAttributeU32(const std::shared_ptr<Item> &item, const char* attributeName, uint32_t fallback = 0) {
		const auto* attribute = item ? item->getCustomAttribute(attributeName) : nullptr;
		return attribute ? attribute->getAttribute<uint32_t>() : fallback;
	}

	[[nodiscard]] uint16_t getCustomAttributeU16(const std::shared_ptr<Item> &item, const char* attributeName, uint16_t fallback = 0) {
		const auto* attribute = item ? item->getCustomAttribute(attributeName) : nullptr;
		return attribute ? attribute->getAttribute<uint16_t>() : fallback;
	}

	[[nodiscard]] bool getCustomAttributeBool(const std::shared_ptr<Item> &item, const char* attributeName, bool fallback = false) {
		const auto* attribute = item ? item->getCustomAttribute(attributeName) : nullptr;
		return attribute ? attribute->getAttribute<bool>() : fallback;
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

	[[nodiscard]] bool isMagicWallOrWildGrowthField(const ExpertFieldContext &fieldContext) {
		return fieldContext.canonicalItemId == ITEM_MAGICWALL || fieldContext.canonicalItemId == ITEM_WILDGROWTH;
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

ExpertPvpRelationResult ExpertPvp::classifyFieldRelation(const ExpertFieldContext &fieldContext, const std::shared_ptr<Creature> &subject) {
	ExpertPvpRelationContext context;
	context.actorGuid = fieldContext.ownerGuid;
	context.actorMode = fieldContext.ownerMode;

	if (!fieldContext || fieldContext.ownerGuid == 0 || !subject) {
		return classifyRelation(context);
	}

	if (const auto &ownerPlayer = g_game().getPlayerByGUID(fieldContext.ownerGuid)) {
		auto relation = classifyRelation(ownerPlayer, subject);
		relation.facts.actorGuid = fieldContext.ownerGuid;
		relation.facts.actorMode = fieldContext.ownerMode;
		return classifyRelation(relation.facts);
	}

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
	context.subjectIsAccessPlayer = isAccessPlayer(subjectPlayer);
	context.isSelf = subjectPlayer && subjectPlayer->getGUID() == fieldContext.ownerGuid;

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
	if (!isEnabled()) {
		const auto relation = classifyRelation(relationContext);

		ExpertPvpWalkthroughDecision decision;
		decision.relation = relation.relation;
		decision.reason = ExpertPvpDecisionReason::FeatureDisabled;
		return decision;
	}

	return evaluateWalkthrough(relationContext);
}

ExpertPvpWalkthroughDecision ExpertPvp::evaluateWalkthrough(const ExpertPvpRelationContext &relationContext) {
	const auto relation = classifyRelation(relationContext);

	ExpertPvpWalkthroughDecision decision;
	decision.handled = true;
	decision.relation = relation.relation;
	decision.reason = ExpertPvpDecisionReason::Neutral;

	switch (relation.relation) {
		case ExpertPvpRelation::Self:
		case ExpertPvpRelation::AccessPlayer:
			decision.canWalkThrough = true;
			decision.reason = reasonForAllowedRelation(relation.relation);
			break;
		case ExpertPvpRelation::NeutralPlayer:
			decision.canWalkThrough = true;
			decision.reason = ExpertPvpDecisionReason::Neutral;
			break;
		case ExpertPvpRelation::PartyAlly:
		case ExpertPvpRelation::GuildAlly:
			decision.canWalkThrough = true;
			decision.reason = ExpertPvpDecisionReason::Ally;
			break;
		case ExpertPvpRelation::DirectAttacker:
		case ExpertPvpRelation::DirectTarget:
			decision.reason = ExpertPvpDecisionReason::DirectCombat;
			break;
		case ExpertPvpRelation::WarEnemy:
			decision.reason = ExpertPvpDecisionReason::War;
			break;
		case ExpertPvpRelation::SkulledTarget:
			decision.reason = ExpertPvpDecisionReason::SkulledTarget;
			break;
		default:
			decision.reason = ExpertPvpDecisionReason::MissingPlayer;
			break;
	}

	return decision;
}

ExpertPvpFieldStepDecision ExpertPvp::evaluateFieldStep(const ExpertFieldContext &fieldContext, const ExpertPvpRelationContext &relationContext) {
	const auto relation = classifyRelation(relationContext);

	ExpertPvpFieldStepDecision decision;
	decision.relation = relation.relation;
	if (!fieldContext || fieldContext.ownerGuid == 0 || !fieldContext.ownerWasPlayerOrSummon || !isMagicWallOrWildGrowthField(fieldContext)) {
		decision.reason = ExpertPvpDecisionReason::MissingFieldContext;
		return decision;
	}

	decision.handled = true;
	decision.reason = ExpertPvpDecisionReason::Neutral;

	const auto mode = normalizeMode(fieldContext.ownerMode, fieldContext.ownerModeSource);
	if (!mode.accepted) {
		decision.canStep = false;
		decision.reason = ExpertPvpDecisionReason::InvalidMode;
		return decision;
	}

	switch (relation.relation) {
		case ExpertPvpRelation::Self:
			decision.canStep = false;
			decision.reason = ExpertPvpDecisionReason::Self;
			break;
		case ExpertPvpRelation::AccessPlayer:
			decision.canStep = true;
			decision.reason = ExpertPvpDecisionReason::AccessPlayer;
			break;
		case ExpertPvpRelation::PartyAlly:
		case ExpertPvpRelation::GuildAlly:
			decision.canStep = true;
			decision.reason = ExpertPvpDecisionReason::Ally;
			break;
		case ExpertPvpRelation::DirectAttacker:
		case ExpertPvpRelation::DirectTarget:
			decision.canStep = false;
			decision.reason = ExpertPvpDecisionReason::DirectCombat;
			break;
		case ExpertPvpRelation::WarEnemy:
			decision.canStep = false;
			decision.reason = ExpertPvpDecisionReason::War;
			break;
		case ExpertPvpRelation::SkulledTarget:
			decision.canStep = false;
			decision.reason = ExpertPvpDecisionReason::SkulledTarget;
			break;
		case ExpertPvpRelation::NeutralPlayer:
			decision.canStep = mode.mode != PVP_MODE_RED_FIST;
			decision.reason = ExpertPvpDecisionReason::Neutral;
			if (!decision.canStep) {
				decision.sideEffectOwnerGuid = fieldContext.ownerGuid;
				decision.skullAction = ExpertPvpSkullAction::White;
				decision.appliesPzLock = true;
			}
			break;
		default:
			decision.canStep = false;
			decision.reason = ExpertPvpDecisionReason::MissingPlayer;
			break;
	}

	return decision;
}

ExpertPvpFieldDamageDecision ExpertPvp::evaluateFieldDamage(const ExpertFieldContext &fieldContext, const ExpertPvpRelationContext &relationContext) {
	ExpertPvpFieldDamageDecision decision;
	if (!fieldContext || fieldContext.ownerGuid == 0 || !fieldContext.ownerWasPlayerOrSummon) {
		decision.reason = ExpertPvpDecisionReason::MissingFieldContext;
		return decision;
	}

	const auto combatDecision = evaluateCombatAction(fieldContext.ownerMode, ExpertPvpActionKind::FieldDamage, relationContext);
	decision.handled = true;
	decision.applyDamage = combatDecision.allowed;
	decision.relation = combatDecision.relation;
	decision.reason = combatDecision.reason;

	if (decision.applyDamage) {
		decision.setConditionOwner = true;
		decision.conditionOwnerGuid = fieldContext.ownerGuid;
	}

	return decision;
}

ExpertPvpFieldVisualDecision ExpertPvp::getFieldClientId(const ExpertFieldContext &fieldContext, const ExpertPvpRelationContext &relationContext) {
	ExpertPvpFieldVisualDecision decision;
	decision.clientItemId = fieldContext.canonicalItemId;
	if (!fieldContext || !isMagicWallOrWildGrowthField(fieldContext)) {
		decision.reason = ExpertPvpDecisionReason::MissingFieldContext;
		return decision;
	}

	const auto stepDecision = evaluateFieldStep(fieldContext, relationContext);
	decision.handled = stepDecision.handled;
	decision.relation = stepDecision.relation;
	decision.reason = stepDecision.reason;

	if (stepDecision.handled) {
		decision.clientItemId = stepDecision.canStep ? fieldContext.safeVisualItemId : fieldContext.blockingVisualItemId;
	}

	return decision;
}

bool ExpertPvp::isExpertFieldItem(uint16_t itemId) {
	switch (itemId) {
		case ITEM_FIREFIELD_PVP_FULL:
		case ITEM_FIREFIELD_PVP_MEDIUM:
		case ITEM_FIREFIELD_PVP_SMALL:
		case ITEM_FIREFIELD_PERSISTENT_FULL:
		case ITEM_FIREFIELD_PERSISTENT_MEDIUM:
		case ITEM_FIREFIELD_PERSISTENT_SMALL:
		case ITEM_FIREFIELD_NOPVP:
		case ITEM_POISONFIELD_PVP:
		case ITEM_POISONFIELD_PERSISTENT:
		case ITEM_POISONFIELD_NOPVP:
		case ITEM_ENERGYFIELD_PVP:
		case ITEM_ENERGYFIELD_PERSISTENT:
		case ITEM_ENERGYFIELD_NOPVP:
		case ITEM_MAGICWALL:
		case ITEM_MAGICWALL_PERSISTENT:
		case ITEM_MAGICWALL_SAFE:
		case ITEM_WILDGROWTH:
		case ITEM_WILDGROWTH_PERSISTENT:
		case ITEM_WILDGROWTH_SAFE:
			return true;
		default:
			return false;
	}
}

ExpertFieldContext ExpertPvp::makeFieldContext(uint32_t ownerGuid, PvpMode_t ownerMode, uint16_t itemId, bool ownerWasPlayerOrSummon) {
	ExpertFieldContext context;
	context.ownerGuid = ownerGuid;
	context.ownerModeSource = ExpertPvpModeSource::CastTimeFieldContext;
	context.ownerMode = normalizeMode(ownerMode, ExpertPvpModeSource::CastTimeFieldContext).mode;
	context.ownerWasPlayerOrSummon = ownerWasPlayerOrSummon;

	switch (itemId) {
		case ITEM_FIREFIELD_PVP_FULL:
		case ITEM_FIREFIELD_PVP_MEDIUM:
		case ITEM_FIREFIELD_PVP_SMALL:
		case ITEM_FIREFIELD_PERSISTENT_FULL:
		case ITEM_FIREFIELD_PERSISTENT_MEDIUM:
		case ITEM_FIREFIELD_PERSISTENT_SMALL:
		case ITEM_FIREFIELD_NOPVP:
		case ITEM_POISONFIELD_PVP:
		case ITEM_POISONFIELD_PERSISTENT:
		case ITEM_POISONFIELD_NOPVP:
		case ITEM_ENERGYFIELD_PVP:
		case ITEM_ENERGYFIELD_PERSISTENT:
		case ITEM_ENERGYFIELD_NOPVP:
			context.canonicalItemId = itemId;
			context.safeVisualItemId = itemId;
			context.blockingVisualItemId = itemId;
			break;
		case ITEM_MAGICWALL:
		case ITEM_MAGICWALL_PERSISTENT:
		case ITEM_MAGICWALL_SAFE:
			context.canonicalItemId = ITEM_MAGICWALL;
			context.safeVisualItemId = ITEM_MAGICWALL_SAFE;
			context.blockingVisualItemId = ITEM_MAGICWALL;
			break;
		case ITEM_WILDGROWTH:
		case ITEM_WILDGROWTH_PERSISTENT:
		case ITEM_WILDGROWTH_SAFE:
			context.canonicalItemId = ITEM_WILDGROWTH;
			context.safeVisualItemId = ITEM_WILDGROWTH_SAFE;
			context.blockingVisualItemId = ITEM_WILDGROWTH;
			break;
		default:
			break;
	}

	return context;
}

ExpertFieldContext ExpertPvp::getFieldContext(const std::shared_ptr<Item> &item) {
	if (!item || !isExpertFieldItem(item->getID())) {
		return {};
	}

	const auto* ownerGuidAttribute = item->getCustomAttribute(expertFieldOwnerGuidAttribute);
	const auto ownerGuid = ownerGuidAttribute ? ownerGuidAttribute->getAttribute<uint32_t>() : 0;
	const auto ownerMode = static_cast<PvpMode_t>(getCustomAttributeU32(item, expertFieldOwnerModeAttribute, PVP_MODE_DOVE));
	auto context = makeFieldContext(ownerGuid, ownerMode, item->getID(), getCustomAttributeBool(item, expertFieldOwnerWasPlayerOrSummonAttribute, ownerGuidAttribute != nullptr));
	context.canonicalItemId = getCustomAttributeU16(item, expertFieldCanonicalItemIdAttribute, context.canonicalItemId);
	context.safeVisualItemId = getCustomAttributeU16(item, expertFieldSafeVisualItemIdAttribute, context.safeVisualItemId);
	context.blockingVisualItemId = getCustomAttributeU16(item, expertFieldBlockingVisualItemIdAttribute, context.blockingVisualItemId);
	return context;
}

ExpertFieldContext ExpertPvp::attachFieldContext(const std::shared_ptr<Item> &item, const std::shared_ptr<Creature> &owner) {
	if (!item || !isExpertFieldItem(item->getID())) {
		return {};
	}

	const auto ownerPlayer = getOwnerPlayer(owner);
	if (!ownerPlayer) {
		return {};
	}

	auto context = makeFieldContext(ownerPlayer->getGUID(), ownerPlayer->getPvpMode(), item->getID(), true);
	item->setCustomAttribute(expertFieldOwnerGuidAttribute, static_cast<int64_t>(context.ownerGuid));
	item->setCustomAttribute(expertFieldOwnerModeAttribute, static_cast<int64_t>(context.ownerMode));
	item->setCustomAttribute(expertFieldCanonicalItemIdAttribute, static_cast<int64_t>(context.canonicalItemId));
	item->setCustomAttribute(expertFieldSafeVisualItemIdAttribute, static_cast<int64_t>(context.safeVisualItemId));
	item->setCustomAttribute(expertFieldBlockingVisualItemIdAttribute, static_cast<int64_t>(context.blockingVisualItemId));
	item->setCustomAttribute(expertFieldOwnerWasPlayerOrSummonAttribute, context.ownerWasPlayerOrSummon);
	return context;
}
