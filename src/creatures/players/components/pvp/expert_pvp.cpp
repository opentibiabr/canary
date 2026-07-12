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
#include "map/spectators.hpp"
#include "utils/tools.hpp"
#include "utils/utils_definitions.hpp"

#ifndef USE_PRECOMPILED_HEADERS
	#include <algorithm>
	#include <charconv>
	#include <string>
	#include <string_view>
	#include <system_error>
	#include <vector>
#endif

namespace {
	constexpr auto expertFieldOwnerGuidAttribute = "expertPvpOwnerGuid";
	constexpr auto expertFieldOwnerModeAttribute = "expertPvpOwnerMode";
	constexpr auto expertFieldCanonicalItemIdAttribute = "expertPvpCanonicalItemId";
	constexpr auto expertFieldSafeVisualItemIdAttribute = "expertPvpSafeVisualItemId";
	constexpr auto expertFieldBlockingVisualItemIdAttribute = "expertPvpBlockingVisualItemId";
	constexpr auto expertFieldOwnerTargetsAtCastAttribute = "expertPvpOwnerTargetsAtCast";
	constexpr auto expertFieldOwnerAttackersAtCastAttribute = "expertPvpOwnerAttackersAtCast";
	constexpr auto expertFieldOwnerWasPlayerOrSummonAttribute = "expertPvpOwnerWasPlayerOrSummon";
	constexpr auto expertPvpWorldType = "expert-pvp";
	constexpr auto legacyRetroPvpWorldType = "pvp";
	constexpr auto retroPvpWorldType = "retro-pvp";

	[[nodiscard]] std::string getConfiguredWorldType() {
		return asLowerCaseString(g_configManager().getString(WORLD_TYPE));
	}

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

	[[nodiscard]] std::string getCustomAttributeString(const std::shared_ptr<Item> &item, const char* attributeName) {
		const auto* attribute = item ? item->getCustomAttribute(attributeName) : nullptr;
		return attribute ? attribute->getAttribute<std::string>() : std::string {};
	}

	[[nodiscard]] std::vector<uint32_t> parseGuidList(std::string_view value) {
		std::vector<uint32_t> guids;
		size_t offset = 0;
		while (offset < value.size()) {
			const auto delimiter = value.find(',', offset);
			const auto tokenEnd = delimiter == std::string_view::npos ? value.size() : delimiter;
			const auto token = value.substr(offset, tokenEnd - offset);

			uint32_t guid = 0;
			const auto* begin = token.data();
			const auto* end = begin + token.size();
			const auto result = std::from_chars(begin, end, guid);
			if (result.ec == std::errc {} && result.ptr == end && guid != 0) {
				guids.emplace_back(guid);
			}

			if (delimiter == std::string_view::npos) {
				break;
			}
			offset = delimiter + 1;
		}
		return guids;
	}

	[[nodiscard]] std::string serializeGuidList(const std::vector<uint32_t> &guids) {
		std::string value;
		for (const auto guid : guids) {
			if (guid == 0) {
				continue;
			}

			if (!value.empty()) {
				value.push_back(',');
			}
			value.append(std::to_string(guid));
		}
		return value;
	}

	[[nodiscard]] bool containsGuid(const std::vector<uint32_t> &guids, uint32_t guid) {
		return std::find(guids.begin(), guids.end(), guid) != guids.end();
	}

	[[nodiscard]] bool hasPvpSituationBetween(const std::shared_ptr<Player> &left, const std::shared_ptr<Player> &right) {
		return left && right && left != right && (left->hasAttacked(right) || right->hasAttacked(left));
	}

	[[nodiscard]] bool isViewerAlly(const std::shared_ptr<Player> &viewer, const std::shared_ptr<Player> &player) {
		return viewer && player && viewer != player && (viewer->isPartner(player) || viewer->isGuildMate(player));
	}

	[[nodiscard]] bool hasAllyInSituationWithSubject(const std::shared_ptr<Player> &viewer, const std::shared_ptr<Player> &subject) {
		if (!viewer || !subject) {
			return false;
		}

		for (const auto &playerEntry : g_game().getPlayers()) {
			const auto &player = playerEntry.second;
			if (!player || !isViewerAlly(viewer, player)) {
				continue;
			}

			if (hasPvpSituationBetween(subject, player)) {
				return true;
			}
		}
		return false;
	}

	[[nodiscard]] bool hasAnyPvpSituation(const std::shared_ptr<Player> &subject) {
		if (!subject) {
			return false;
		}

		for (const auto &playerEntry : g_game().getPlayers()) {
			const auto &player = playerEntry.second;
			if (!player || player == subject) {
				continue;
			}

			if (hasPvpSituationBetween(subject, player)) {
				return true;
			}
		}
		return false;
	}

	[[nodiscard]] CreatureMark_t toCreatureMark(ExpertPvpSituationMark mark) {
		switch (mark) {
			case ExpertPvpSituationMark::Yellow:
				return CREATURE_MARK_YELLOW;
			case ExpertPvpSituationMark::Orange:
				return CREATURE_MARK_ORANGE;
			case ExpertPvpSituationMark::Brown:
				return CREATURE_MARK_BROWN;
			default:
				return CREATURE_MARK_UNMARKED;
		}
	}

	void addVisiblePlayers(std::vector<std::shared_ptr<Player>> &players, const std::shared_ptr<Player> &center) {
		if (!center) {
			return;
		}

		for (const auto &spectator : Spectators().find<Player>(center->getPosition(), true)) {
			const auto &spectatorPlayer = spectator ? spectator->getPlayer() : nullptr;
			if (spectatorPlayer && std::find(players.begin(), players.end(), spectatorPlayer) == players.end()) {
				players.emplace_back(spectatorPlayer);
			}
		}
	}

	void snapshotFieldRelationsAtCast(ExpertFieldContext &context, const std::shared_ptr<Player> &ownerPlayer) {
		if (!ownerPlayer) {
			return;
		}

		for (const auto &playerEntry : g_game().getPlayers()) {
			const auto &player = playerEntry.second;
			if (!player || player == ownerPlayer) {
				continue;
			}

			if (ownerPlayer->hasAttacked(player)) {
				context.ownerTargetsAtCast.emplace_back(player->getGUID());
			}
			if (player->hasAttacked(ownerPlayer)) {
				context.ownerAttackersAtCast.emplace_back(player->getGUID());
			}
		}
	}

	void applyFieldRelationSnapshot(const ExpertFieldContext &fieldContext, ExpertPvpRelationContext &context) {
		if (context.subjectGuid == 0 || context.subjectGuid == fieldContext.ownerGuid) {
			return;
		}

		const bool subjectWasTargetAtCast = containsGuid(fieldContext.ownerTargetsAtCast, context.subjectGuid);
		const bool subjectWasAttackerAtCast = containsGuid(fieldContext.ownerAttackersAtCast, context.subjectGuid);
		if (subjectWasAttackerAtCast) {
			context.directAttacker = true;
			return;
		}

		if (subjectWasTargetAtCast) {
			context.directTarget = true;
			context.directAttacker = false;
		}
	}

	[[nodiscard]] bool isSkulledClientTarget(const std::shared_ptr<Player> &actor, const std::shared_ptr<Player> &subjectPlayer) {
		if (!actor || !subjectPlayer) {
			return false;
		}

		const auto skull = actor->getSkullClient(subjectPlayer);
		return skull != SKULL_NONE && skull != SKULL_GREEN;
	}

	[[nodiscard]] bool hasAttackedProtectedAlly(const std::shared_ptr<Player> &actor, const std::shared_ptr<Player> &subjectPlayer) {
		if (!actor || !subjectPlayer || actor == subjectPlayer) {
			return false;
		}

		for (const auto &[guid, player] : g_game().getPlayers()) {
			(void)guid;
			if (!player || player == actor || player == subjectPlayer) {
				continue;
			}

			if ((actor->isPartner(player) || actor->isGuildMate(player)) && subjectPlayer->hasAttacked(player)) {
				return true;
			}
		}
		return false;
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

	void applyPlayerSituationSideEffects(uint32_t ownerGuid, uint32_t subjectGuid, ExpertPvpSkullAction skullAction, bool appliesPzLock) {
		if (ownerGuid == 0 || subjectGuid == 0 || ownerGuid == subjectGuid) {
			return;
		}

		const auto &owner = g_game().getPlayerByGUID(ownerGuid);
		const auto &subject = g_game().getPlayerByGUID(subjectGuid);
		if (!owner || !subject) {
			return;
		}

		const bool ownerAlreadyAttacked = owner->hasAttacked(subject);
		if (!owner->isInWar(subject)) {
			owner->addAttacked(subject);
		}

		if (appliesPzLock) {
			owner->addPzLockTicks();
		}

		if (skullAction == ExpertPvpSkullAction::White && subject->getSkull() == SKULL_NONE && owner->getSkull() == SKULL_NONE && !subject->hasKilled(owner)) {
			owner->setSkull(SKULL_WHITE);
		}

		owner->sendOpenPvpSituations();
		subject->sendCreatureSkull(owner);
		if (!ownerAlreadyAttacked || skullAction != ExpertPvpSkullAction::None) {
			ExpertPvp::refreshVisibleSituationMarks(owner, subject);
		}
	}

	[[nodiscard]] bool isMagicWallOrWildGrowthField(const ExpertFieldContext &fieldContext) {
		return fieldContext.canonicalItemId == ITEM_MAGICWALL || fieldContext.canonicalItemId == ITEM_WILDGROWTH;
	}
} // namespace

bool ExpertPvp::isEnabled() {
	return isExpertPvpWorldType();
}

bool ExpertPvp::isExpertPvpWorldType() {
	return isExpertPvpWorldTypeName(getConfiguredWorldType());
}

bool ExpertPvp::isRetroPvpWorldType() {
	return isRetroPvpWorldTypeName(getConfiguredWorldType());
}

bool ExpertPvp::isExpertPvpWorldTypeName(std::string_view worldType) {
	return asLowerCaseString(std::string(worldType)) == expertPvpWorldType;
}

bool ExpertPvp::isRetroPvpWorldTypeName(std::string_view worldType) {
	const auto normalizedWorldType = asLowerCaseString(std::string(worldType));
	return normalizedWorldType == retroPvpWorldType || normalizedWorldType == legacyRetroPvpWorldType;
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

	if (context.partyAlly) {
		result.relation = ExpertPvpRelation::PartyAlly;
		return result;
	}

	if (context.guildAlly) {
		result.relation = ExpertPvpRelation::GuildAlly;
		return result;
	}

	if (context.directAttacker) {
		result.relation = ExpertPvpRelation::DirectAttacker;
		return result;
	}

	if (context.protectedAllyAttacker) {
		result.relation = ExpertPvpRelation::ProtectedAllyAttacker;
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
		context.protectedAllyAttacker = hasAttackedProtectedAlly(actor, subjectOwnerPlayer);
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
		applyFieldRelationSnapshot(fieldContext, relation.facts);
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
	applyFieldRelationSnapshot(fieldContext, context);

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
		decision.appliesPzLock = false;
		return decision;
	}

	if (relation.relation == ExpertPvpRelation::ProtectedAllyAttacker) {
		decision.reason = ExpertPvpDecisionReason::DirectCombat;
		if (mode.mode == PVP_MODE_WHITE_HAND || mode.mode == PVP_MODE_YELLOW_HAND || mode.mode == PVP_MODE_RED_FIST) {
			decision.allowed = true;
			describePvpPressure(decision, relationContext);
			decision.appliesPzLock = false;
		}
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

	if (relation.relation == ExpertPvpRelation::Self || relation.relation == ExpertPvpRelation::AccessPlayer) {
		decision.canWalkThrough = true;
		decision.reason = reasonForAllowedRelation(relation.relation);
		return decision;
	}

	if (relation.relation == ExpertPvpRelation::PartyAlly || relation.relation == ExpertPvpRelation::GuildAlly) {
		decision.canWalkThrough = true;
		decision.reason = ExpertPvpDecisionReason::Ally;
		return decision;
	}

	const auto mode = normalizeMode(relationContext.actorMode, ExpertPvpModeSource::StoredPlayerState);
	if (!mode.accepted) {
		decision.reason = ExpertPvpDecisionReason::InvalidMode;
		return decision;
	}

	bool blocks = relationContext.warEnemy;
	switch (mode.mode) {
		case PVP_MODE_DOVE:
			blocks = blocks || relationContext.directAttacker;
			break;
		case PVP_MODE_WHITE_HAND:
			blocks = blocks || relationContext.directAttacker || relationContext.protectedAllyAttacker;
			break;
		case PVP_MODE_YELLOW_HAND:
			blocks = blocks || relationContext.directAttacker || relationContext.skulledTarget;
			break;
		case PVP_MODE_RED_FIST:
			blocks = blocks || relationContext.subjectIsPlayer || relationContext.subjectIsPlayerSummon;
			break;
		default:
			decision.reason = ExpertPvpDecisionReason::InvalidMode;
			return decision;
	}

	decision.canWalkThrough = !blocks;
	if (relationContext.warEnemy) {
		decision.reason = ExpertPvpDecisionReason::War;
	} else if (relationContext.directAttacker || relationContext.protectedAllyAttacker) {
		decision.reason = ExpertPvpDecisionReason::DirectCombat;
	} else if (relationContext.skulledTarget) {
		decision.reason = ExpertPvpDecisionReason::SkulledTarget;
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

	if (relation.relation == ExpertPvpRelation::Self) {
		decision.canStep = false;
		decision.reason = ExpertPvpDecisionReason::Self;
		return decision;
	}

	if (relation.relation == ExpertPvpRelation::AccessPlayer) {
		decision.reason = ExpertPvpDecisionReason::AccessPlayer;
		return decision;
	}

	if (relation.relation == ExpertPvpRelation::PartyAlly || relation.relation == ExpertPvpRelation::GuildAlly) {
		decision.reason = ExpertPvpDecisionReason::Ally;
		return decision;
	}

	if (relationContext.directTarget && !relationContext.directAttacker) {
		decision.reason = ExpertPvpDecisionReason::DirectCombat;
		return decision;
	}

	bool blocks = relationContext.warEnemy;
	switch (mode.mode) {
		case PVP_MODE_DOVE:
			blocks = blocks || relationContext.directAttacker;
			break;
		case PVP_MODE_WHITE_HAND:
			blocks = blocks || relationContext.directAttacker || relationContext.protectedAllyAttacker;
			break;
		case PVP_MODE_YELLOW_HAND:
			blocks = blocks || relationContext.directAttacker || relationContext.skulledTarget;
			break;
		case PVP_MODE_RED_FIST:
			blocks = blocks || relationContext.directAttacker || relationContext.protectedAllyAttacker || relationContext.skulledTarget || relationContext.subjectIsPlayer || relationContext.subjectIsPlayerSummon;
			break;
		default:
			decision.canStep = false;
			decision.reason = ExpertPvpDecisionReason::InvalidMode;
			return decision;
	}

	decision.canStep = !blocks;
	if (relationContext.warEnemy) {
		decision.reason = ExpertPvpDecisionReason::War;
	} else if (relationContext.directAttacker || relationContext.protectedAllyAttacker || relationContext.directTarget) {
		decision.reason = ExpertPvpDecisionReason::DirectCombat;
	} else if (relationContext.skulledTarget) {
		decision.reason = ExpertPvpDecisionReason::SkulledTarget;
	}

	const bool unjustifiedRedBlock = blocks && mode.mode == PVP_MODE_RED_FIST && !relationContext.directAttacker && !relationContext.protectedAllyAttacker && !relationContext.warEnemy && !relationContext.skulledTarget;
	if (unjustifiedRedBlock) {
		decision.sideEffectOwnerGuid = fieldContext.ownerGuid;
		decision.skullAction = ExpertPvpSkullAction::White;
		decision.appliesPzLock = true;
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

ExpertPvpSituationMark ExpertPvp::getSituationMark(const std::shared_ptr<Player> &subject, const std::shared_ptr<Player> &viewer) {
	if (!isEnabled() || !subject || !viewer || subject == viewer) {
		return ExpertPvpSituationMark::None;
	}

	if (hasPvpSituationBetween(subject, viewer)) {
		return ExpertPvpSituationMark::Yellow;
	}

	if (hasAllyInSituationWithSubject(viewer, subject)) {
		return ExpertPvpSituationMark::Orange;
	}

	if (hasAnyPvpSituation(subject)) {
		return ExpertPvpSituationMark::Brown;
	}

	return ExpertPvpSituationMark::None;
}

CreatureMark_t ExpertPvp::getSituationCreatureMark(const std::shared_ptr<Player> &subject, const std::shared_ptr<Player> &viewer) {
	return toCreatureMark(getSituationMark(subject, viewer));
}

void ExpertPvp::refreshCreatureMarkForViewer(const std::shared_ptr<Player> &viewer, const std::shared_ptr<Player> &subject) {
	if (!viewer || !subject) {
		return;
	}

	viewer->sendCreatureMark(subject, getSituationCreatureMark(subject, viewer));
}

void ExpertPvp::refreshVisibleSituationMarks(const std::shared_ptr<Player> &first, const std::shared_ptr<Player> &second) {
	if (!isEnabled()) {
		return;
	}

	std::vector<std::shared_ptr<Player>> viewers;
	addVisiblePlayers(viewers, first);
	addVisiblePlayers(viewers, second);

	for (const auto &viewer : viewers) {
		refreshCreatureMarkForViewer(viewer, first);
		refreshCreatureMarkForViewer(viewer, second);
	}
}

void ExpertPvp::refreshAllVisibleSituationMarks() {
	if (!isEnabled()) {
		return;
	}

	for (const auto &viewerEntry : g_game().getPlayers()) {
		const auto &viewer = viewerEntry.second;
		if (!viewer) {
			continue;
		}

		for (const auto &subjectEntry : g_game().getPlayers()) {
			const auto &subject = subjectEntry.second;
			refreshCreatureMarkForViewer(viewer, subject);
		}
	}
}

void ExpertPvp::applyCombatSideEffects(const ExpertPvpDecision &decision, const ExpertPvpRelationContext &relationContext) {
	if (!isEnabled() || !decision.handled || !decision.allowed || !decision.startsFight || decision.sideEffectOwnerGuid == 0) {
		return;
	}

	applyPlayerSituationSideEffects(decision.sideEffectOwnerGuid, relationContext.subjectGuid, decision.skullAction, decision.appliesPzLock);
}

void ExpertPvp::applyFieldStepSideEffects(const ExpertPvpFieldStepDecision &decision, const ExpertPvpRelationContext &relationContext) {
	if (!isEnabled() || !decision.handled || decision.canStep || decision.sideEffectOwnerGuid == 0) {
		return;
	}

	applyPlayerSituationSideEffects(decision.sideEffectOwnerGuid, relationContext.subjectGuid, decision.skullAction, decision.appliesPzLock);
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
	context.ownerTargetsAtCast = parseGuidList(getCustomAttributeString(item, expertFieldOwnerTargetsAtCastAttribute));
	context.ownerAttackersAtCast = parseGuidList(getCustomAttributeString(item, expertFieldOwnerAttackersAtCastAttribute));
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
	snapshotFieldRelationsAtCast(context, ownerPlayer);
	item->setCustomAttribute(expertFieldOwnerGuidAttribute, static_cast<int64_t>(context.ownerGuid));
	item->setCustomAttribute(expertFieldOwnerModeAttribute, static_cast<int64_t>(context.ownerMode));
	item->setCustomAttribute(expertFieldCanonicalItemIdAttribute, static_cast<int64_t>(context.canonicalItemId));
	item->setCustomAttribute(expertFieldSafeVisualItemIdAttribute, static_cast<int64_t>(context.safeVisualItemId));
	item->setCustomAttribute(expertFieldBlockingVisualItemIdAttribute, static_cast<int64_t>(context.blockingVisualItemId));
	item->setCustomAttribute(expertFieldOwnerTargetsAtCastAttribute, serializeGuidList(context.ownerTargetsAtCast));
	item->setCustomAttribute(expertFieldOwnerAttackersAtCastAttribute, serializeGuidList(context.ownerAttackersAtCast));
	item->setCustomAttribute(expertFieldOwnerWasPlayerOrSummonAttribute, context.ownerWasPlayerOrSummon);
	return context;
}
