/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2022 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#ifndef SRC_CREATURES_PLAYERS_GROUPING_PARTY_H_
#define SRC_CREATURES_PLAYERS_GROUPING_PARTY_H_

#include "creatures/players/player.h"
#include "creatures/monsters/monsters.h"

enum SharedExpStatus_t : uint8_t {
	SHAREDEXP_OK,
	SHAREDEXP_TOOFARAWAY,
	SHAREDEXP_LEVELDIFFTOOLARGE,
	SHAREDEXP_MEMBERINACTIVE,
	SHAREDEXP_EMPTYPARTY
};

class Player;
class Party;

using PlayerVector = std::vector<Player*>;

class Party {
	public:
		explicit Party(Player* leader);

		Player* getLeader() const {
			return leader;
		}
		PlayerVector &getMembers() {
			return memberList;
		}
		const PlayerVector &getInvitees() const {
			return inviteList;
		}
		size_t getMemberCount() const {
			return memberList.size();
		}
		size_t getInvitationCount() const {
			return inviteList.size();
		}

		void disband();
		bool invitePlayer(Player &player);
		bool joinParty(Player &player);
		void revokeInvitation(Player &player);
		bool passPartyLeadership(Player* player);
		bool leaveParty(Player* player);

		bool removeInvite(Player &player, bool removeFromPlayer = true);

		bool isPlayerInvited(const Player* player) const;
		void updateAllPartyIcons();
		void broadcastPartyMessage(MessageClasses msgClass, const std::string &msg, bool sendToInvitations = false);
		bool empty() const {
			return memberList.empty() && inviteList.empty();
		}
		bool canOpenCorpse(uint32_t ownerId) const;

		void shareExperience(uint64_t experience, Creature* target = nullptr);
		bool setSharedExperience(Player* player, bool sharedExpActive);
		bool isSharedExperienceActive() const {
			return sharedExpActive;
		}
		bool isSharedExperienceEnabled() const {
			return sharedExpEnabled;
		}
		bool canUseSharedExperience(const Player* player) const;
		SharedExpStatus_t getMemberSharedExperienceStatus(const Player* player) const;
		void updateSharedExperience();

		void updatePlayerTicks(Player* player, int64_t points);
		void clearPlayerPoints(Player* player);

		uint8_t getManaPercent(const Creature* creature) const;
		uint8_t getHealthPercent(const Creature* creature) const;
		void showPlayerStatus(Player* player, Player* member, bool showStatus);
		void updatePlayerStatus(Player* player);
		void updatePlayerStatus(Player* player, const Position &oldPos, const Position &newPos);
		void updatePlayerHealth(const Player* player, const Creature* target, uint8_t healthPercent);
		void updatePlayerMana(const Player* player, uint8_t manaPercent);
		void updatePlayerVocation(const Player* player);

		void updateTrackerAnalyzer() const;
		void addPlayerLoot(const Player* player, const Item* item);
		void addPlayerSupply(const Player* player, const Item* item);
		void addPlayerDamage(const Player* player, uint64_t amount);
		void addPlayerHealing(const Player* player, uint64_t amount);
		void switchAnalyzerPriceType();
		void resetAnalyzer();
		void reloadPrices();

		PartyAnalyzer* getPlayerPartyAnalyzerStruct(uint32_t playerId) const {
			if (auto it = std::find_if(membersData.begin(), membersData.end(), [playerId](const PartyAnalyzer* preyIt) {
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
		std::vector<PartyAnalyzer*> membersData;

	private:
		const char* getSharedExpReturnMessage(SharedExpStatus_t value);
		SharedExpStatus_t getSharedExperienceStatus();

		std::map<uint32_t, int64_t> ticksMap;

		PlayerVector memberList;
		PlayerVector inviteList;

		Player* leader;

		bool sharedExpActive = false;
		bool sharedExpEnabled = false;
};

#endif // SRC_CREATURES_PLAYERS_GROUPING_PARTY_H_
