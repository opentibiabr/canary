/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2022 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#pragma once

#include "creatures/players/player.hpp"
#include "creatures/monsters/monsters.hpp"
#include "lib/di/container.hpp"

enum SharedExpStatus_t : uint8_t {
	SHAREDEXP_OK,
	SHAREDEXP_TOOFARAWAY,
	SHAREDEXP_LEVELDIFFTOOLARGE,
	SHAREDEXP_MEMBERINACTIVE,
	SHAREDEXP_EMPTYPARTY
};

class Player;
class Party;

class Party : public SharedObject {
public:
	static std::shared_ptr<Party> create(std::shared_ptr<Player> leader);

	std::shared_ptr<Party> getParty() {
		return static_self_cast<Party>();
	}

	std::shared_ptr<Player> getLeader() const {
		return m_leader.lock();
	}
	std::vector<std::shared_ptr<Player>> getPlayers() const {
		std::vector<std::shared_ptr<Player>> players;
		for (auto &member : memberList) {
			players.push_back(member);
		}
		players.push_back(getLeader());
		return players;
	}
	std::vector<std::shared_ptr<Player>> getMembers() {
		return memberList;
	}
	std::vector<std::shared_ptr<Player>> getInvitees() {
		return inviteList;
	}
	size_t getMemberCount() const {
		return memberList.size();
	}
	size_t getInvitationCount() const {
		return inviteList.size();
	}

	void disband();
	bool invitePlayer(const std::shared_ptr<Player> &player);
	bool joinParty(const std::shared_ptr<Player> &player);
	void revokeInvitation(const std::shared_ptr<Player> &player);
	bool passPartyLeadership(std::shared_ptr<Player> player);
	bool leaveParty(std::shared_ptr<Player> player);

	bool removeInvite(const std::shared_ptr<Player> &player, bool removeFromPlayer = true);

	bool isPlayerInvited(const std::shared_ptr<Player> &player) const;
	void updateAllPartyIcons();
	void broadcastPartyMessage(MessageClasses msgClass, const std::string &msg, bool sendToInvitations = false);
	bool empty() const {
		return memberList.empty() && inviteList.empty();
	}
	bool canOpenCorpse(uint32_t ownerId) const;

	void shareExperience(uint64_t experience, std::shared_ptr<Creature> target = nullptr);
	bool setSharedExperience(std::shared_ptr<Player> player, bool sharedExpActive, bool silent = false);
	bool isSharedExperienceActive() const {
		return sharedExpActive;
	}
	bool isSharedExperienceEnabled() const {
		return sharedExpEnabled;
	}
	bool canUseSharedExperience(std::shared_ptr<Player> player);
	SharedExpStatus_t getMemberSharedExperienceStatus(std::shared_ptr<Player> player);
	void updateSharedExperience();

	void updatePlayerTicks(std::shared_ptr<Player> player, uint32_t points);
	void clearPlayerPoints(std::shared_ptr<Player> player);

	void showPlayerStatus(std::shared_ptr<Player> player, std::shared_ptr<Player> member, bool showStatus);
	void updatePlayerStatus(std::shared_ptr<Player> player);
	void updatePlayerStatus(std::shared_ptr<Player> player, const Position &oldPos, const Position &newPos);
	void updatePlayerHealth(std::shared_ptr<Player> player, std::shared_ptr<Creature> target, uint8_t healthPercent);
	void updatePlayerMana(std::shared_ptr<Player> player, uint8_t manaPercent);
	void updatePlayerVocation(std::shared_ptr<Player> player);

	void updateTrackerAnalyzer();
	void addPlayerLoot(std::shared_ptr<Player> player, std::shared_ptr<Item> item);
	void addPlayerSupply(std::shared_ptr<Player> player, std::shared_ptr<Item> item);
	void addPlayerDamage(std::shared_ptr<Player> player, uint64_t amount);
	void addPlayerHealing(std::shared_ptr<Player> player, uint64_t amount);
	void switchAnalyzerPriceType();
	void resetAnalyzer();
	void reloadPrices();

	std::shared_ptr<PartyAnalyzer> getPlayerPartyAnalyzerStruct(uint32_t playerId) const {
		if (auto it = std::find_if(membersData.begin(), membersData.end(), [playerId](const std::shared_ptr<PartyAnalyzer> preyIt) {
				return preyIt->id == playerId;
			});
			it != membersData.end()) {
			return *it;
		}

		return nullptr;
	}

	uint32_t getAnalyzerTimeNow() const {
		return static_cast<uint32_t>(time(nullptr) - trackerTime);
	}

public:
	// Party analyzer
	time_t trackerTime = time(nullptr);
	PartyAnalyzer_t priceType = MARKET_PRICE;
	std::vector<std::shared_ptr<PartyAnalyzer>> membersData;

private:
	const char* getSharedExpReturnMessage(SharedExpStatus_t value);
	bool isPlayerActive(std::shared_ptr<Player> player);
	SharedExpStatus_t getSharedExperienceStatus();
	uint32_t getHighestLevel();
	uint32_t getLowestLevel();
	uint32_t getMinLevel();
	uint32_t getMaxLevel();

	std::map<uint32_t, int64_t> ticksMap;

	std::vector<std::shared_ptr<Player>> memberList;
	std::vector<std::shared_ptr<Player>> inviteList;

	std::weak_ptr<Player> m_leader;

	bool sharedExpActive = false;
	bool sharedExpEnabled = false;
};
