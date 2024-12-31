/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2024 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#pragma once

#include "creatures/creatures_definitions.hpp"

enum MessageClasses : uint8_t;

enum SharedExpStatus_t : uint8_t {
	SHAREDEXP_OK,
	SHAREDEXP_TOOFARAWAY,
	SHAREDEXP_LEVELDIFFTOOLARGE,
	SHAREDEXP_MEMBERINACTIVE,
	SHAREDEXP_EMPTYPARTY
};

struct Position;

class Player;
class Party;
class Item;
class Creature;

class Party final : public SharedObject {
public:
	static std::shared_ptr<Party> create(const std::shared_ptr<Player> &leader);

	std::shared_ptr<Party> getParty();

	std::shared_ptr<Player> getLeader() const;
	std::vector<std::shared_ptr<Player>> getPlayers() const;
	std::vector<std::shared_ptr<Player>> getMembers();
	std::vector<std::shared_ptr<Player>> getInvitees();
	size_t getMemberCount() const;
	size_t getInvitationCount() const;
	uint8_t getUniqueVocationsCount() const;

	void disband();
	bool invitePlayer(const std::shared_ptr<Player> &player);
	bool joinParty(const std::shared_ptr<Player> &player);
	void revokeInvitation(const std::shared_ptr<Player> &player);
	bool passPartyLeadership(const std::shared_ptr<Player> &player);
	bool leaveParty(const std::shared_ptr<Player> &player, bool forceRemove = false);

	bool removeInvite(const std::shared_ptr<Player> &player, bool removeFromPlayer = true);

	bool isPlayerInvited(const std::shared_ptr<Player> &player) const;
	void updateAllPartyIcons();
	void broadcastPartyMessage(MessageClasses msgClass, const std::string &msg, bool sendToInvitations = false);
	bool empty() const;
	bool canOpenCorpse(uint32_t ownerId) const;

	void shareExperience(uint64_t experience, const std::shared_ptr<Creature> &target = nullptr);
	bool setSharedExperience(const std::shared_ptr<Player> &player, bool sharedExpActive, bool silent = false);
	bool isSharedExperienceActive() const;
	bool isSharedExperienceEnabled() const;
	bool canUseSharedExperience(const std::shared_ptr<Player> &player);
	SharedExpStatus_t getMemberSharedExperienceStatus(const std::shared_ptr<Player> &player);
	void updateSharedExperience();

	void updatePlayerTicks(const std::shared_ptr<Player> &player, uint32_t points);
	void clearPlayerPoints(const std::shared_ptr<Player> &player);

	void showPlayerStatus(const std::shared_ptr<Player> &player, const std::shared_ptr<Player> &member, bool showStatus) const;
	void updatePlayerStatus(const std::shared_ptr<Player> &player);
	void updatePlayerStatus(const std::shared_ptr<Player> &player, const Position &oldPos, const Position &newPos);
	void updatePlayerHealth(const std::shared_ptr<Player> &player, const std::shared_ptr<Creature> &target, uint8_t healthPercent);
	void updatePlayerMana(const std::shared_ptr<Player> &player, uint8_t manaPercent);
	void updatePlayerVocation(const std::shared_ptr<Player> &player);

	void updateTrackerAnalyzer();
	void addPlayerLoot(const std::shared_ptr<Player> &player, const std::shared_ptr<Item> &item);
	void addPlayerSupply(const std::shared_ptr<Player> &player, const std::shared_ptr<Item> &item);
	void addPlayerDamage(const std::shared_ptr<Player> &player, uint64_t amount);
	void addPlayerHealing(const std::shared_ptr<Player> &player, uint64_t amount);
	void switchAnalyzerPriceType();
	void resetAnalyzer();
	void reloadPrices() const;

	std::shared_ptr<PartyAnalyzer> getPlayerPartyAnalyzerStruct(uint32_t playerId) const;

	uint32_t getAnalyzerTimeNow() const;

public:
	// Party analyzer
	time_t trackerTime = time(nullptr);
	PartyAnalyzer_t priceType = MARKET_PRICE;
	std::vector<std::shared_ptr<PartyAnalyzer>> membersData;

private:
	const char* getSharedExpReturnMessage(SharedExpStatus_t value) const;
	bool isPlayerActive(const std::shared_ptr<Player> &player);
	SharedExpStatus_t getSharedExperienceStatus();
	uint32_t getHighestLevel();
	uint32_t getLowestLevel();
	uint32_t getMinLevel();
	uint32_t getMaxLevel();
	float shareRangeMultiplier() const;

	std::map<uint32_t, int64_t> ticksMap;

	std::vector<std::shared_ptr<Player>> memberList;
	std::vector<std::shared_ptr<Player>> inviteList;

	std::weak_ptr<Player> m_leader;

	bool sharedExpActive = false;
	bool sharedExpEnabled = false;
};
