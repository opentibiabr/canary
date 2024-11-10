/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2024 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#include "server/network/protocol/protocolgame.hpp"

#include "account/account.hpp"
#include "config/configmanager.hpp"
#include "core.hpp"
#include "creatures/appearance/mounts/mounts.hpp"
#include "creatures/combat/condition.hpp"
#include "creatures/combat/spells.hpp"
#include "creatures/interactions/chat.hpp"
#include "creatures/monsters/monster.hpp"
#include "creatures/monsters/monsters.hpp"
#include "creatures/npcs/npc.hpp"
#include "creatures/players/achievement/player_achievement.hpp"
#include "creatures/players/cyclopedia/player_badge.hpp"
#include "creatures/players/cyclopedia/player_cyclopedia.hpp"
#include "creatures/players/grouping/familiars.hpp"
#include "creatures/players/grouping/party.hpp"
#include "creatures/players/grouping/team_finder.hpp"
#include "creatures/players/highscore_category.hpp"
#include "creatures/players/imbuements/imbuements.hpp"
#include "creatures/players/management/ban.hpp"
#include "creatures/players/management/waitlist.hpp"
#include "creatures/players/player.hpp"
#include "creatures/players/vip/player_vip.hpp"
#include "creatures/players/wheel/player_wheel.hpp"
#include "enums/player_icons.hpp"
#include "game/game.hpp"
#include "game/modal_window/modal_window.hpp"
#include "game/scheduling/dispatcher.hpp"
#include "io/functions/iologindata_load_player.hpp"
#include "io/io_bosstiary.hpp"
#include "io/iobestiary.hpp"
#include "io/iologindata.hpp"
#include "io/iomarket.hpp"
#include "io/ioprey.hpp"
#include "items/items_classification.hpp"
#include "items/weapons/weapons.hpp"
#include "lua/creature/creatureevent.hpp"
#include "lua/modules/modules.hpp"
#include "server/network/message/outputmessage.hpp"
#include "utils/tools.hpp"

#include "enums/account_coins.hpp"
#include "enums/account_group_type.hpp"
#include "enums/account_type.hpp"
#include "enums/object_category.hpp"
#include "enums/player_blessings.hpp"

/*
 * NOTE: This namespace is used so that we can add functions without having to declare them in the ".hpp/.hpp" file
 * Do not use functions only in the .cpp scope without having a namespace, it may conflict with functions in other files of the same name
 */

// This "getIteration" function will allow us to get the total number of iterations that run within a specific map
// Very useful to send the total amount in certain bytes in the ProtocolGame class
namespace {
	template <typename T>
	uint16_t getIterationIncreaseCount(T &map) {
		uint16_t totalIterationCount = 0;
		for ([[maybe_unused]] const auto &[first, second] : map) {
			totalIterationCount++;
		}

		return totalIterationCount;
	}

	template <typename T>
	uint16_t getVectorIterationIncreaseCount(T &vector) {
		uint16_t totalIterationCount = 0;
		for ([[maybe_unused]] const auto &vectorIteration : vector) {
			totalIterationCount++;
		}

		return totalIterationCount;
	}

	void addOutfitAndMountBytes(NetworkMessage &msg, const std::shared_ptr<Item> &item, const CustomAttribute* attribute, const std::string &head, const std::string &body, const std::string &legs, const std::string &feet, bool addAddon = false, bool addByte = false) {
		auto look = attribute->getAttribute<uint16_t>();
		msg.add<uint16_t>(look);
		if (look != 0) {
			const auto lookHead = item->getCustomAttribute(head);
			const auto lookBody = item->getCustomAttribute(body);
			const auto lookLegs = item->getCustomAttribute(legs);
			const auto lookFeet = item->getCustomAttribute(feet);

			msg.addByte(lookHead ? lookHead->getAttribute<uint8_t>() : 0);
			msg.addByte(lookBody ? lookBody->getAttribute<uint8_t>() : 0);
			msg.addByte(lookLegs ? lookLegs->getAttribute<uint8_t>() : 0);
			msg.addByte(lookFeet ? lookFeet->getAttribute<uint8_t>() : 0);

			if (addAddon) {
				const auto lookAddons = item->getCustomAttribute("LookAddons");
				msg.addByte(lookAddons ? lookAddons->getAttribute<uint8_t>() : 0);
			}
		} else {
			if (addByte) {
				msg.add<uint16_t>(0);
			}
		}
	}

	// Send bytes function for avoid repetitions
	void sendBosstiarySlotsBytes(NetworkMessage &msg, uint8_t bossRace, uint32_t bossKillCount, uint16_t bonusBossSlotOne, uint8_t killBonus, uint8_t isSlotOneInactive, uint32_t removePrice) {
		msg.addByte(bossRace); // Boss Race
		msg.add<uint32_t>(bossKillCount); // Kill Count
		msg.add<uint16_t>(bonusBossSlotOne); // Loot Bonus
		msg.addByte(killBonus); // Kill Bonus
		msg.addByte(bossRace); // Boss Race
		msg.add<uint32_t>(isSlotOneInactive == 1 ? 0 : removePrice); // Remove Price
		msg.addByte(isSlotOneInactive); // Inactive? (Only true if equal to Boosted Boss)
	}

	/**
	 * @brief Handles the imbuement damage for a player and adds it to the network message.
	 * @details This function checks if the player's weapon has any imbuements that provide combat-type damage.
	 * @details If such imbuements are found, the corresponding damage values and combat types are added to the network message.
	 * @details If no imbuement damage is found, default values are added to the message.
	 *
	 * @param msg The network message to which the imbuement damage should be added.
	 * @param player Pointer to the player for whom the imbuement damage should be handled.
	 */
	void handleImbuementDamage(NetworkMessage &msg, const std::shared_ptr<Player> &player) {
		bool imbueDmg = false;
		std::shared_ptr<Item> weapon = player->getWeapon();
		if (weapon) {
			uint8_t slots = Item::items[weapon->getID()].imbuementSlot;
			if (slots > 0) {
				for (uint8_t i = 0; i < slots; i++) {
					ImbuementInfo imbuementInfo;
					if (!weapon->getImbuementInfo(i, &imbuementInfo)) {
						continue;
					}

					if (imbuementInfo.duration > 0) {
						auto imbuement = *imbuementInfo.imbuement;
						if (imbuement.combatType != COMBAT_NONE) {
							msg.addByte(static_cast<uint32_t>(imbuement.elementDamage));
							msg.addByte(getCipbiaElement(imbuement.combatType));
							imbueDmg = true;
							break;
						}
					}
				}
			}
		}
		if (!imbueDmg) {
			msg.addByte(0);
			msg.addByte(0);
		}
	}

	/**
	 * @brief Calculates the absorb values for different combat types based on player's equipped items.
	 *
	 * This function calculates the absorb values for each combat type based on the items equipped by the player.
	 * The calculated absorb values are stored in the provided array.
	 *
	 * @param[in] player The pointer to the player whose equipped items are considered.
	 */
	void calculateAbsorbValues(const std::shared_ptr<Player> &player, NetworkMessage &msg, uint8_t &combats) {
		alignas(16) uint16_t damageModifiers[COMBAT_COUNT] = { 10000, 10000, 10000, 10000, 10000, 10000, 10000, 10000, 10000, 10000, 10000, 10000, 10000, 10000 };

		for (int32_t slot = CONST_SLOT_FIRST; slot <= CONST_SLOT_LAST; ++slot) {
			if (!player->isItemAbilityEnabled(static_cast<Slots_t>(slot))) {
				continue;
			}

			const auto item = player->getInventoryItem(static_cast<Slots_t>(slot));
			if (!item) {
				continue;
			}

			const ItemType &itemType = Item::items[item->getID()];
			if (!itemType.abilities) {
				continue;
			}

			for (uint16_t i = 0; i < COMBAT_COUNT; ++i) {
				damageModifiers[i] *= (std::floor(100. - itemType.abilities->absorbPercent[i]) / 100.);
			}

			uint8_t imbuementSlots = itemType.imbuementSlot;
			if (imbuementSlots > 0) {
				for (uint8_t slotId = 0; slotId < imbuementSlots; ++slotId) {
					ImbuementInfo imbuementInfo;
					if (!item->getImbuementInfo(slotId, &imbuementInfo)) {
						continue;
					}

					if (imbuementInfo.duration == 0) {
						continue;
					}

					auto imbuement = *imbuementInfo.imbuement;
					for (uint16_t combat = 0; combat < COMBAT_COUNT; ++combat) {
						const int16_t &imbuementAbsorbPercent = imbuement.absorbPercent[combat];
						if (imbuementAbsorbPercent == 0) {
							continue;
						}

						g_logger().debug("[cyclopedia damage reduction] imbued item {}, reduced {} percent, for element {}", item->getName(), imbuementAbsorbPercent, combatTypeToName(indexToCombatType(combat)));

						damageModifiers[combat] *= (std::floor(100. - imbuementAbsorbPercent) / 100.);
					}
				}
			}
		}

		for (size_t i = 0; i < COMBAT_COUNT; ++i) {
			damageModifiers[i] -= 100 * player->getAbsorbPercent(indexToCombatType(i));
			if (g_configManager().getBoolean(TOGGLE_WHEELSYSTEM)) {
				damageModifiers[i] -= player->wheel()->getResistance(indexToCombatType(i));
			}

			if (damageModifiers[i] != 10000) {
				int16_t clientModifier = std::clamp(10000 - static_cast<int16_t>(damageModifiers[i]), -10000, 10000);
				g_logger().debug("[{}] CombatType: {}, Damage Modifier: {}, Resulting Client Modifier: {}", __FUNCTION__, i, damageModifiers[i], clientModifier);
				msg.addByte(getCipbiaElement(indexToCombatType(i)));
				msg.add<int16_t>(clientModifier);
				++combats;
			}
		}
	}

	/**
	 * @brief Sends the container category to the network message.
	 *
	 * @note The default value is "all", which is the first enum (0). The message must always start with "All".
	 *
	 * @details for example of enum see the ContainerCategory_t
	 *
	 * @param msg The network message to send the category to.
	 */
	template <typename T>
	void sendContainerCategory(NetworkMessage &msg, const std::vector<T> &categories = {}, uint8_t categoryType = 0) {
		msg.addByte(categoryType);
		g_logger().debug("Sendding category type '{}', categories total size '{}'", categoryType, categories.size());
		msg.addByte(categories.size());
		for (auto value : categories) {
			if (value == T::All) {
				continue;
			}

			g_logger().debug("Sendding category number '{}', category name '{}'", static_cast<uint8_t>(value), magic_enum::enum_name(value).data());
			msg.addByte(static_cast<uint8_t>(value));
			msg.addString(toStartCaseWithSpace(magic_enum::enum_name(value).data()));
		}
	}
} // namespace

ProtocolGame::ProtocolGame(const Connection_ptr &initConnection) :
	Protocol(initConnection) {
	version = CLIENT_VERSION;
}

void ProtocolGame::AddItem(NetworkMessage &msg, uint16_t id, uint8_t count, uint8_t tier) const {
	const ItemType &it = Item::items[id];

	msg.add<uint16_t>(it.id);

	if (oldProtocol) {
		msg.addByte(0xFF);
	}

	if (it.stackable) {
		msg.addByte(count);
	}

	if (it.isSplash() || it.isFluidContainer()) {
		msg.addByte(count);
	}

	if (oldProtocol) {
		if (it.animationType == ANIMATION_RANDOM) {
			msg.addByte(0xFE);
		} else if (it.animationType == ANIMATION_DESYNC) {
			msg.addByte(0xFF);
		}

		return;
	}

	if (it.isContainer()) {
		msg.addByte(0x00);
	}

	if (it.isPodium) {
		msg.add<uint16_t>(0);
		msg.add<uint16_t>(0);
		msg.add<uint16_t>(0);

		msg.addByte(2);
		msg.addByte(0x01);
	}

	if (it.upgradeClassification > 0) {
		msg.addByte(tier);
	}

	if (it.expire || it.expireStop || it.clockExpire) {
		msg.add<uint32_t>(it.decayTime);
		msg.addByte(0x01); // Brand-new
	}

	if (it.wearOut) {
		msg.add<uint32_t>(it.charges);
		msg.addByte(0x01); // Brand-new
	}

	if (it.isWrapKit && !oldProtocol) {
		msg.add<uint16_t>(0x00);
	}
}

void ProtocolGame::AddItem(NetworkMessage &msg, const std::shared_ptr<Item> &item) {
	if (!item) {
		return;
	}

	const ItemType &it = Item::items[item->getID()];

	msg.add<uint16_t>(it.id);

	if (oldProtocol) {
		msg.addByte(0xFF);
	}

	if (it.stackable) {
		msg.addByte(static_cast<uint8_t>(std::min<uint16_t>(std::numeric_limits<uint8_t>::max(), item->getItemCount())));
	}

	if (it.isSplash() || it.isFluidContainer()) {
		msg.addByte(item->getAttribute<uint8_t>(ItemAttribute_t::FLUIDTYPE));
	}

	if (oldProtocol) {
		if (it.animationType == ANIMATION_RANDOM) {
			msg.addByte(0xFE);
		} else if (it.animationType == ANIMATION_DESYNC) {
			msg.addByte(0xFF);
		}

		return;
	}

	if (it.isContainer()) {
		uint8_t containerType = 0;

		std::shared_ptr<Container> container = item->getContainer();
		if (container && containerType == 0 && container->getHoldingPlayer() == player) {
			uint32_t lootFlags = 0;
			uint32_t obtainFlags = 0;
			for (const auto &[category, containerMap] : player->m_managedContainers) {
				if (!isValidObjectCategory(category)) {
					continue;
				}
				if (containerMap.first == container) {
					lootFlags |= 1 << category;
				}
				if (containerMap.second == container) {
					obtainFlags |= 1 << category;
				}
			}

			if (lootFlags != 0 || obtainFlags != 0) {
				containerType = 9;
				msg.addByte(containerType);
				msg.add<uint32_t>(lootFlags);
				msg.add<uint32_t>(obtainFlags);
			}
		}

		// Quiver ammo count
		if (container && containerType == 0 && item->isQuiver() && player->getThing(CONST_SLOT_RIGHT) == item) {
			uint16_t ammoTotal = 0;
			for (const std::shared_ptr<Item> &listItem : container->getItemList()) {
				if (player->getLevel() >= Item::items[listItem->getID()].minReqLevel) {
					ammoTotal += listItem->getItemCount();
				}
			}
			containerType = 2;
			msg.addByte(containerType);
			msg.add<uint32_t>(ammoTotal);
		}

		if (containerType == 0) {
			msg.addByte(0x00);
		}
	}

	if (it.isPodium) {
		const auto podiumVisible = item->getCustomAttribute("PodiumVisible");
		const auto lookType = item->getCustomAttribute("LookType");
		const auto lookTypeAttribute = item->getCustomAttribute("LookTypeEx");
		const auto lookMount = item->getCustomAttribute("LookMount");
		const auto lookDirection = item->getCustomAttribute("LookDirection");

		if (lookType && lookType->getAttribute<uint16_t>() != 0) {
			addOutfitAndMountBytes(msg, item, lookType, "LookHead", "LookBody", "LookLegs", "LookFeet", true);
		} else if (lookTypeAttribute) {
			auto lookTypeEx = lookTypeAttribute->getAttribute<uint16_t>();
			// "Tantugly's Head" boss have to send other looktype to the podium
			if (lookTypeEx == 35105) {
				lookTypeEx = 39003;
			}
			msg.add<uint16_t>(0);
			msg.add<uint16_t>(lookTypeEx);
		} else {
			msg.add<uint16_t>(0);
			msg.add<uint16_t>(0);
		}

		if (lookMount) {
			addOutfitAndMountBytes(msg, item, lookMount, "LookMountHead", "LookMountBody", "LookMountLegs", "LookMountFeet");
		} else {
			msg.add<uint16_t>(0);
		}

		msg.addByte(lookDirection ? lookDirection->getAttribute<uint8_t>() : 2);
		msg.addByte(podiumVisible ? podiumVisible->getAttribute<uint8_t>() : 0x01);
	}

	if (item->getClassification() > 0) {
		msg.addByte(item->getTier());
	}

	// Timer
	if (it.expire || it.expireStop || it.clockExpire) {
		if (item->hasAttribute(ItemAttribute_t::DURATION)) {
			msg.add<uint32_t>(item->getDuration() / 1000);
			msg.addByte((item->getDuration() / 1000) == it.decayTime ? 0x01 : 0x00); // Brand-new
		} else {
			msg.add<uint32_t>(it.decayTime);
			msg.addByte(0x01); // Brand-new
		}
	}

	// Charge
	if (it.wearOut) {
		if (item->getSubType() == 0) {
			msg.add<uint32_t>(it.charges);
			msg.addByte(0x01); // Brand-new
		} else {
			msg.add<uint32_t>(static_cast<uint32_t>(item->getSubType()));
			msg.addByte(item->getSubType() == it.charges ? 0x01 : 0x00); // Brand-new
		}
	}

	if (it.isWrapKit && !oldProtocol) {
		uint16_t unWrapId = item->getCustomAttribute("unWrapId") ? static_cast<uint16_t>(item->getCustomAttribute("unWrapId")->getInteger()) : 0;
		if (unWrapId != 0) {
			msg.add<uint16_t>(unWrapId);
		} else {
			msg.add<uint16_t>(0x00);
		}
	}
}

void ProtocolGame::release() {
	// dispatcher thread
	if (player && player->client == shared_from_this()) {
		player->client.reset();
		player = nullptr;
	}

	OutputMessagePool::getInstance().removeProtocolFromAutosend(shared_from_this());
	Protocol::release();
}

void ProtocolGame::login(const std::string &name, uint32_t accountId, OperatingSystem_t operatingSystem) {
	// OTCV8 features
	if (otclientV8 > 0) {
		sendFeatures();
	}

	// Extended opcodes
	if (operatingSystem >= CLIENTOS_OTCLIENT_LINUX) {
		isOTC = true;
		NetworkMessage opcodeMessage;
		opcodeMessage.addByte(0x32);
		opcodeMessage.addByte(0x00);
		opcodeMessage.add<uint16_t>(0x00);
		writeToOutputBuffer(opcodeMessage);
	}

	g_logger().debug("Player logging in in version '{}' and oldProtocol '{}'", getVersion(), oldProtocol);

	// dispatcher thread
	std::shared_ptr<Player> foundPlayer = g_game().getPlayerUniqueLogin(name);
	if (!foundPlayer) {
		player = std::make_shared<Player>(getThis());
		player->setName(name);
		g_game().addPlayerUniqueLogin(player);

		player->setID();

		if (!IOLoginDataLoad::preLoadPlayer(player, name)) {
			g_game().removePlayerUniqueLogin(player);
			disconnectClient("Your character could not be loaded.");
			return;
		}

		if (IOBan::isPlayerNamelocked(player->getGUID())) {
			g_game().removePlayerUniqueLogin(player);
			disconnectClient("Your character has been namelocked.");
			return;
		}

		if (g_game().getGameState() == GAME_STATE_CLOSING && !player->hasFlag(PlayerFlags_t::CanAlwaysLogin)) {
			g_game().removePlayerUniqueLogin(player);
			disconnectClient("The game is just going down.\nPlease try again later.");
			return;
		}

		if (g_game().getGameState() == GAME_STATE_CLOSED && !player->hasFlag(PlayerFlags_t::CanAlwaysLogin)) {
			g_game().removePlayerUniqueLogin(player);
			auto maintainMessage = g_configManager().getString(MAINTAIN_MODE_MESSAGE);
			if (!maintainMessage.empty()) {
				disconnectClient(maintainMessage);
			} else {
				disconnectClient("Server is currently closed.\nPlease try again later.");
			}
			return;
		}

		if (g_configManager().getBoolean(ONLY_PREMIUM_ACCOUNT) && !player->isPremium() && (player->getGroup()->id < GROUP_TYPE_GAMEMASTER || player->getAccountType() < ACCOUNT_TYPE_GAMEMASTER)) {
			g_game().removePlayerUniqueLogin(player);
			disconnectClient("Your premium time for this account is out.\n\nTo play please buy additional premium time from our website");
			return;
		}

		auto onlineCount = g_game().getPlayersByAccount(player->getAccount()).size();
		auto maxOnline = g_configManager().getNumber(MAX_PLAYERS_PER_ACCOUNT);
		if (player->getAccountType() < ACCOUNT_TYPE_GAMEMASTER && onlineCount >= maxOnline) {
			g_game().removePlayerUniqueLogin(player);
			disconnectClient(fmt::format("You may only login with {} character{}\nof your account at the same time.", maxOnline, maxOnline > 1 ? "s" : ""));
			return;
		}

		if (!player->hasFlag(PlayerFlags_t::CannotBeBanned)) {
			BanInfo banInfo;
			if (IOBan::isAccountBanned(accountId, banInfo)) {
				if (banInfo.reason.empty()) {
					banInfo.reason = "(none)";
				}

				std::ostringstream ss;
				if (banInfo.expiresAt > 0) {
					ss << "Your account has been banned until " << formatDateShort(banInfo.expiresAt) << " by " << banInfo.bannedBy << ".\n\nReason specified:\n"
					   << banInfo.reason;
				} else {
					ss << "Your account has been permanently banned by " << banInfo.bannedBy << ".\n\nReason specified:\n"
					   << banInfo.reason;
				}
				g_game().removePlayerUniqueLogin(player);
				disconnectClient(ss.str());
				return;
			}
		}

		WaitingList &waitingList = WaitingList::getInstance();
		if (!waitingList.clientLogin(player)) {
			auto currentSlot = static_cast<uint32_t>(waitingList.getClientSlot(player));
			auto retryTime = static_cast<uint32_t>(WaitingList::getTime(currentSlot));
			std::ostringstream ss;

			ss << "Too many players online.\nYou are at place "
			   << currentSlot << " on the waiting list.";

			auto output = OutputMessagePool::getOutputMessage();
			output->addByte(0x16);
			output->addString(ss.str());
			output->addByte(retryTime);
			send(output);
			disconnect();
			g_game().removePlayerUniqueLogin(player);
			return;
		}

		if (!IOLoginData::loadPlayerById(player, player->getGUID(), false)) {
			g_game().removePlayerUniqueLogin(player);
			disconnectClient("Your character could not be loaded.");
			g_logger().warn("Player {} could not be loaded", player->getName());
			return;
		}

		player->setOperatingSystem(operatingSystem);

		const auto tile = g_game().map.getOrCreateTile(player->getLoginPosition());
		// moving from a pz tile to a non-pz tile
		if (maxOnline > 1 && player->getAccountType() < ACCOUNT_TYPE_GAMEMASTER && !tile->hasFlag(TILESTATE_PROTECTIONZONE)) {
			auto maxOutsizePZ = g_configManager().getNumber(MAX_PLAYERS_OUTSIDE_PZ_PER_ACCOUNT);
			auto accountPlayers = g_game().getPlayersByAccount(player->getAccount());
			int countOutsizePZ = 0;
			for (const auto &accountPlayer : accountPlayers) {
				if (accountPlayer != player && accountPlayer->getTile() && !accountPlayer->getTile()->hasFlag(TILESTATE_PROTECTIONZONE)) {
					++countOutsizePZ;
				}
			}
			if (countOutsizePZ >= maxOutsizePZ) {
				g_game().removePlayerUniqueLogin(player);
				disconnectClient(fmt::format("You can only have {} character{} from your account outside of a protection zone.", maxOutsizePZ == 1 ? "one" : std::to_string(maxOutsizePZ), maxOutsizePZ > 1 ? "s" : ""));
				return;
			}
		}

		if (!g_game().placeCreature(player, player->getLoginPosition()) && !g_game().placeCreature(player, player->getTemplePosition(), false, true)) {
			g_game().removePlayerUniqueLogin(player);
			disconnectClient("Temple position is wrong. Please, contact the administrator.");
			g_logger().warn("Player {} temple position is wrong", player->getName());
			return;
		}

		player->lastIP = player->getIP();
		player->lastLoginSaved = std::max<time_t>(time(nullptr), player->lastLoginSaved + 1);
		acceptPackets = true;
	} else {
		if (eventConnect != 0 || !g_configManager().getBoolean(REPLACE_KICK_ON_LOGIN)) {
			// Already trying to connect
			disconnectClient("You are already logged in.");
			return;
		}

		if (foundPlayer->client) {
			foundPlayer->disconnect();
			foundPlayer->isConnecting = true;

			eventConnect = g_dispatcher().scheduleEvent(
				1000,
				[self = getThis(), playerName = foundPlayer->getName(), operatingSystem] { self->connect(playerName, operatingSystem); }, "ProtocolGame::connect"
			);
		} else {
			connect(foundPlayer->getName(), operatingSystem);
		}
	}
	OutputMessagePool::getInstance().addProtocolToAutosend(shared_from_this());
	sendBosstiaryCooldownTimer();
}

void ProtocolGame::connect(const std::string &playerName, OperatingSystem_t operatingSystem) {
	eventConnect = 0;

	std::shared_ptr<Player> foundPlayer = g_game().getPlayerUniqueLogin(playerName);
	if (!foundPlayer) {
		disconnectClient("You are already logged in.");
		return;
	}

	if (isConnectionExpired()) {
		// ProtocolGame::release() has been called at this point and the Connection object
		// no longer exists, so we return to prevent leakage of the Player.
		return;
	}

	player = foundPlayer;
	g_game().addPlayerUniqueLogin(player);

	g_chat().removeUserFromAllChannels(player);
	player->clearModalWindows();
	player->setOperatingSystem(operatingSystem);
	player->isConnecting = false;

	player->client = getThis();
	player->openPlayerContainers();
	sendAddCreature(player, player->getPosition(), 0, true);
	player->lastIP = player->getIP();
	player->lastLoginSaved = std::max<time_t>(time(nullptr), player->lastLoginSaved + 1);
	player->resetIdleTime();
	acceptPackets = true;
}

void ProtocolGame::logout(bool displayEffect, bool forced) {
	if (!player) {
		return;
	}

	bool removePlayer = !player->isRemoved() && !forced;
	auto tile = player->getTile();
	if (removePlayer && !player->isAccessPlayer()) {
		if (tile && tile->hasFlag(TILESTATE_NOLOGOUT)) {
			player->sendCancelMessage(RETURNVALUE_YOUCANNOTLOGOUTHERE);
			return;
		}

		if (tile && !tile->hasFlag(TILESTATE_PROTECTIONZONE) && player->hasCondition(CONDITION_INFIGHT)) {
			player->sendCancelMessage(RETURNVALUE_YOUMAYNOTLOGOUTDURINGAFIGHT);
			return;
		}
	}

	if (removePlayer && !g_creatureEvents().playerLogout(player)) {
		return;
	}

	displayEffect = displayEffect && !player->isRemoved() && player->getHealth() > 0 && !player->isInGhostMode();
	if (displayEffect) {
		g_game().addMagicEffect(player->getPosition(), CONST_ME_POFF);
	}

	sendSessionEndInformation(forced ? SESSION_END_FORCECLOSE : SESSION_END_LOGOUT);

	g_game().removeCreature(player, true);
}

void ProtocolGame::onRecvFirstMessage(NetworkMessage &msg) {
	if (g_game().getGameState() == GAME_STATE_SHUTDOWN) {
		disconnect();
		return;
	}

	auto operatingSystem = static_cast<OperatingSystem_t>(msg.get<uint16_t>());
	version = msg.get<uint16_t>(); // Protocol version
	g_logger().trace("Protocol version: {}", version);

	// Old protocol support
	oldProtocol = g_configManager().getBoolean(OLD_PROTOCOL) && version <= 1100;

	if (oldProtocol) {
		setChecksumMethod(CHECKSUM_METHOD_ADLER32);
	} else if (operatingSystem <= CLIENTOS_OTCLIENT_MAC) {
		setChecksumMethod(CHECKSUM_METHOD_SEQUENCE);
	}

	clientVersion = static_cast<int32_t>(msg.get<uint32_t>());

	if (!oldProtocol) {
		auto clientVersionString = msg.getString(); // Client version (String)
		g_logger().trace("Client version: {}", clientVersionString);
		if (version >= 1334) {
			auto assetHashIdentifier = msg.getString(); // Assets hash identifier
			g_logger().trace("Client asset hash identifier: {}", assetHashIdentifier);
		}
	}

	if (version < 1334) {
		auto datRevision = msg.get<uint16_t>(); // Dat revision
		g_logger().trace("Dat revision: {}", datRevision);
	}

	auto gamePreviewState = msg.getByte(); // U8 game preview state
	g_logger().trace("Game preview state: {}", gamePreviewState);

	if (!Protocol::RSA_decrypt(msg)) {
		g_logger().warn("[ProtocolGame::onRecvFirstMessage] - RSA Decrypt Failed");
		disconnect();
		return;
	}

	std::array<uint32_t, 4> key = { msg.get<uint32_t>(), msg.get<uint32_t>(), msg.get<uint32_t>(), msg.get<uint32_t>() };
	enableXTEAEncryption();
	setXTEAKey(key.data());

	auto isGameMaster = static_cast<bool>(msg.getByte()); // gamemaster flag
	g_logger().trace("Is Game Master: {}", isGameMaster);

	std::string authType = g_configManager().getString(AUTH_TYPE);
	std::ostringstream ss;
	std::string sessionKey = msg.getString();
	std::string accountDescriptor = sessionKey;
	std::string password;

	if (authType != "session") {
		size_t pos = sessionKey.find('\n');
		if (pos == std::string::npos) {
			ss << "You must enter your " << (oldProtocol ? "username" : "email") << ".";
			disconnectClient(ss.str());
			return;
		}
		accountDescriptor = sessionKey.substr(0, pos);
		if (accountDescriptor.empty()) {
			ss.str(std::string());
			ss << "You must enter your " << (oldProtocol ? "username" : "email") << ".";
			disconnectClient(ss.str());
			return;
		}
		password = sessionKey.substr(pos + 1);
	}

	if (!oldProtocol && operatingSystem == CLIENTOS_NEW_LINUX) {
		// TODO: check what new info for linux is send
		msg.getString();
		msg.getString();
	}

	std::string characterName = msg.getString();

	std::shared_ptr<Player> foundPlayer = g_game().getPlayerUniqueLogin(characterName);
	if (foundPlayer && foundPlayer->client) {
		if (foundPlayer->getProtocolVersion() != getVersion() && foundPlayer->isOldProtocol() != oldProtocol) {
			disconnectClient(fmt::format("You are already logged in using protocol '{}'. Please log out from the other session to connect here.", foundPlayer->getProtocolVersion()));
			return;
		}

		foundPlayer->client->disconnectClient("You are already connected through another client. Please use only one client at a time!");
	}

	auto timeStamp = msg.get<uint32_t>();
	uint8_t randNumber = msg.getByte();
	if (challengeTimestamp != timeStamp || challengeRandom != randNumber) {
		disconnect();
		return;
	}

	// OTCv8 version detection
	auto otcV8StringLength = msg.get<uint16_t>();
	if (otcV8StringLength == 5 && msg.getString(5) == "OTCv8") {
		otclientV8 = msg.get<uint16_t>(); // 253, 260, 261, ...
	}

	if (!oldProtocol && clientVersion != CLIENT_VERSION) {
		ss.str(std::string());
		ss << "Only clients with protocol " << CLIENT_VERSION_UPPER << "." << CLIENT_VERSION_LOWER;
		if (g_configManager().getBoolean(OLD_PROTOCOL)) {
			ss << " or 11.00";
		}
		ss << " allowed!";
		disconnectClient(ss.str());
		return;
	}

	if (g_game().getGameState() == GAME_STATE_STARTUP) {
		disconnectClient("Gameworld is starting up. Please wait.");
		return;
	}

	if (g_game().getGameState() == GAME_STATE_MAINTAIN) {
		disconnectClient("Gameworld is under maintenance. Please re-connect in a while.");
		return;
	}

	BanInfo banInfo;
	if (IOBan::isIpBanned(getIP(), banInfo)) {
		if (banInfo.reason.empty()) {
			banInfo.reason = "(none)";
		}

		ss.str(std::string());
		ss << "Your IP has been banned until " << formatDateShort(banInfo.expiresAt) << " by " << banInfo.bannedBy << ".\n\nReason specified:\n"
		   << banInfo.reason;
		disconnectClient(ss.str());
		return;
	}

	uint32_t accountId;
	if (!IOLoginData::gameWorldAuthentication(accountDescriptor, password, characterName, accountId, oldProtocol, getIP())) {
		ss.str(std::string());
		if (authType == "session") {
			ss << "Your session has expired. Please log in again.";
		} else { // authType == "password"
			ss << "Your " << (oldProtocol ? "username" : "email") << " or password is not correct.";
		}

		auto output = OutputMessagePool::getOutputMessage();
		output->addByte(0x14);
		output->addString(ss.str());
		send(output);
		g_dispatcher().scheduleEvent(
			1000, [self = getThis()] { self->disconnect(); }, "ProtocolGame::disconnect"
		);
		return;
	}

	g_dispatcher().addEvent([self = getThis(), characterName, accountId, operatingSystem] { self->login(characterName, accountId, operatingSystem); }, __FUNCTION__);
}

void ProtocolGame::onConnect() {
	auto output = OutputMessagePool::getOutputMessage();
	static std::random_device rd;
	static std::ranlux24 generator(rd());
	static std::uniform_int_distribution<uint16_t> randNumber(0x00, 0xFF);

	// Skip checksum
	output->skipBytes(sizeof(uint32_t));

	// Packet length & type
	output->add<uint16_t>(0x0006);
	output->addByte(0x1F);

	// Add timestamp & random number
	challengeTimestamp = static_cast<uint32_t>(time(nullptr));
	output->add<uint32_t>(challengeTimestamp);

	challengeRandom = randNumber(generator);
	output->addByte(challengeRandom);

	// Go back and write checksum
	output->skipBytes(-12);
	// To support 11.10-, not have problems with 11.11+
	output->add<uint32_t>(adlerChecksum(output->getOutputBuffer() + sizeof(uint32_t), 8));

	send(output);
}

void ProtocolGame::disconnectClient(const std::string &message) const {
	auto output = OutputMessagePool::getOutputMessage();
	output->addByte(0x14);
	output->addString(message);
	send(output);
	disconnect();
}

void ProtocolGame::writeToOutputBuffer(const NetworkMessage &msg) {
	auto out = getOutputBuffer(msg.getLength());
	out->append(msg);
}

void ProtocolGame::parsePacket(NetworkMessage &msg) {
	if (!acceptPackets || g_game().getGameState() == GAME_STATE_SHUTDOWN || msg.getLength() <= 0) {
		return;
	}

	uint8_t recvbyte = msg.getByte();

	if (!player || player->isRemoved()) {
		if (recvbyte == 0x0F) {
			disconnect();
		}
		return;
	}

	if (player->isDead() || player->getHealth() <= 0) {
		// Check player activity on death screen
		if (m_playerDeathTime == 0) {
			g_game().playerCheckActivity(player->getName(), 1000);
			m_playerDeathTime++;
		}

		parsePacketDead(recvbyte);
		return;
	}

	// Modules system
	if (player && recvbyte != 0xD3) {
		g_modules().executeOnRecvbyte(player->getID(), msg, recvbyte);
	}

	parsePacketFromDispatcher(msg, recvbyte);
}

void ProtocolGame::parsePacketDead(uint8_t recvbyte) {
	if (recvbyte == 0x14) {
		// Remove player from game if click "ok" using otc
		if (player && isOTC) {
			g_game().removePlayerUniqueLogin(player->getName());
		}
		disconnect();
		return;
	}

	if (recvbyte == 0x0F) {
		if (!player) {
			return;
		}

		g_dispatcher().scheduleEvent(
			100, [self = getThis()] { self->sendPing(); }, "ProtocolGame::sendPing"
		);

		if (!player->spawn()) {
			disconnect();
			g_game().removeCreature(player, true);
			return;
		}

		sendAddCreature(player, player->getPosition(), 0, false);
		addBless();
		resetPlayerDeathTime();
		return;
	}

	if (recvbyte == 0x1D) {
		// keep the connection alive
		g_dispatcher().scheduleEvent(
			100, [self = getThis()] { self->sendPingBack(); }, "ProtocolGame::sendPingBack"
		);
		return;
	}
}

void ProtocolGame::addBless() {
	if (!player) {
		return;
	}
	player->checkAndShowBlessingMessage();
}

void ProtocolGame::parsePacketFromDispatcher(NetworkMessage &msg, uint8_t recvbyte) {
	if (!acceptPackets || g_game().getGameState() == GAME_STATE_SHUTDOWN) {
		return;
	}

	if (!player || player->isRemoved() || player->getHealth() <= 0) {
		return;
	}

	switch (recvbyte) {
		case 0x14:
			logout(true, false);
			break;
		case 0x1D:
			g_game().playerReceivePingBack(player->getID());
			break;
		case 0x1E:
			g_game().playerReceivePing(player->getID());
			break;
		case 0x2a:
			parseCyclopediaMonsterTracker(msg);
			break;
		case 0x2B:
			parsePartyAnalyzerAction(msg);
			break;
		case 0x2c:
			parseLeaderFinderWindow(msg);
			break;
		case 0x2d:
			parseMemberFinderWindow(msg);
			break;
		case 0x28:
			parseStashWithdraw(msg);
			break;
		case 0x29:
			parseRetrieveDepotSearch(msg);
			break;
		case 0x32:
			parseExtendedOpcode(msg);
			break; // otclient extended opcode
		case 0x60:
			parseInventoryImbuements(msg);
			break;
		case 0x61:
			parseOpenWheel(msg);
			break;
		case 0x62:
			parseSaveWheel(msg);
			break;
		case 0x64:
			parseAutoWalk(msg);
			break;
		case 0x65:
			g_game().playerMove(player->getID(), DIRECTION_NORTH);
			break;
		case 0x66:
			g_game().playerMove(player->getID(), DIRECTION_EAST);
			break;
		case 0x67:
			g_game().playerMove(player->getID(), DIRECTION_SOUTH);
			break;
		case 0x68:
			g_game().playerMove(player->getID(), DIRECTION_WEST);
			break;
		case 0x69:
			g_game().playerStopAutoWalk(player->getID());
			break;
		case 0x6A:
			g_game().playerMove(player->getID(), DIRECTION_NORTHEAST);
			break;
		case 0x6B:
			g_game().playerMove(player->getID(), DIRECTION_SOUTHEAST);
			break;
		case 0x6C:
			g_game().playerMove(player->getID(), DIRECTION_SOUTHWEST);
			break;
		case 0x6D:
			g_game().playerMove(player->getID(), DIRECTION_NORTHWEST);
			break;
		case 0x6F:
			g_game().playerTurn(player->getID(), DIRECTION_NORTH);
			break;
		case 0x70:
			g_game().playerTurn(player->getID(), DIRECTION_EAST);
			break;
		case 0x71:
			g_game().playerTurn(player->getID(), DIRECTION_SOUTH);
			break;
		case 0x72:
			g_game().playerTurn(player->getID(), DIRECTION_WEST);
			break;
		case 0x73:
			parseTeleport(msg);
			break;
		case 0x77:
			parseHotkeyEquip(msg);
			break;
		case 0x78:
			parseThrow(msg);
			break;
		case 0x79:
			parseLookInShop(msg);
			break;
		case 0x7A:
			parsePlayerBuyOnShop(msg);
			break;
		case 0x7B:
			parsePlayerSellOnShop(msg);
			break;
		case 0x7C:
			g_game().playerCloseShop(player->getID());
			break;
		case 0x7D:
			parseRequestTrade(msg);
			break;
		case 0x7E:
			parseLookInTrade(msg);
			break;
		case 0x7F:
			g_game().playerAcceptTrade(player->getID());
			break;
		case 0x80:
			g_game().playerCloseTrade(player->getID());
			break;
		case 0x81:
			parseFriendSystemAction(msg);
			break;
		case 0x82:
			parseUseItem(msg);
			break;
		case 0x83:
			parseUseItemEx(msg);
			break;
		case 0x84:
			parseUseWithCreature(msg);
			break;
		case 0x85:
			parseRotateItem(msg);
			break;
		case 0x86:
			parseConfigureShowOffSocket(msg);
			break;
		case 0x87:
			parseCloseContainer(msg);
			break;
		case 0x88:
			parseUpArrowContainer(msg);
			break;
		case 0x89:
			parseTextWindow(msg);
			break;
		case 0x8A:
			parseHouseWindow(msg);
			break;
		case 0x8B:
			parseWrapableItem(msg);
			break;
		case 0x8C:
			parseLookAt(msg);
			break;
		case 0x8D:
			parseLookInBattleList(msg);
			break;
		case 0x8E: /* join aggression */
			break;
		case 0x8F:
			parseQuickLoot(msg);
			break;
		case 0x90:
			parseLootContainer(msg);
			break;
		case 0x91:
			parseQuickLootBlackWhitelist(msg);
			break;
		case 0x92:
			parseOpenDepotSearch();
			break;
		case 0x93:
			parseCloseDepotSearch();
			break;
		case 0x94:
			parseDepotSearchItemRequest(msg);
			break;
		case 0x95:
			parseOpenParentContainer(msg);
			break;
		case 0x96:
			parseSay(msg);
			break;
		case 0x97:
			g_game().playerRequestChannels(player->getID());
			break;
		case 0x98:
			parseOpenChannel(msg);
			break;
		case 0x99:
			parseCloseChannel(msg);
			break;
		case 0x9A:
			parseOpenPrivateChannel(msg);
			break;
		case 0x9E:
			g_game().playerCloseNpcChannel(player->getID());
			break;
		case 0x9F:
			parseSetMonsterPodium(msg);
			break;
		case 0xA0:
			parseFightModes(msg);
			break;
		case 0xA1:
			parseAttack(msg);
			break;
		case 0xA2:
			parseFollow(msg);
			break;
		case 0xA3:
			parseInviteToParty(msg);
			break;
		case 0xA4:
			parseJoinParty(msg);
			break;
		case 0xA5:
			parseRevokePartyInvite(msg);
			break;
		case 0xA6:
			parsePassPartyLeadership(msg);
			break;
		case 0xA7:
			g_game().playerLeaveParty(player->getID());
			break;
		case 0xA8:
			parseEnableSharedPartyExperience(msg);
			break;
		case 0xAA:
			g_game().playerCreatePrivateChannel(player->getID());
			break;
		case 0xAB:
			parseChannelInvite(msg);
			break;
		case 0xAC:
			parseChannelExclude(msg);
			break;
		case 0xAE:
			parseSendBosstiary();
			break;
		case 0xAF:
			parseSendBosstiarySlots();
			break;
		case 0xB0:
			parseBosstiarySlot(msg);
			break;
		case 0xB1:
			parseHighscores(msg);
			break;
		case 0xBA:
			parseTaskHuntingAction(msg);
			break;
		case 0xBE:
			g_game().playerCancelAttackAndFollow(player->getID());
			break;
		case 0xBF:
			parseForgeEnter(msg);
			break;
		case 0xC0:
			parseForgeBrowseHistory(msg);
			break;
		case 0xC9: /* update tile */
			break;
		case 0xCA:
			parseUpdateContainer(msg);
			break;
		case 0xCB:
			parseBrowseField(msg);
			break;
		case 0xCC:
			parseSeekInContainer(msg);
			break;
		case 0xCD:
			parseInspectionObject(msg);
			break;
		case 0xD2:
			g_game().playerRequestOutfit(player->getID());
			break;
		case 0xD3:
			parseSetOutfit(msg);
			break;
		case 0xD4:
			parseToggleMount(msg);
			break;
		case 0xD5:
			parseApplyImbuement(msg);
			break;
		case 0xD6:
			parseClearImbuement(msg);
			break;
		case 0xD7:
			parseCloseImbuementWindow(msg);
			break;
		case 0xDC:
			parseAddVip(msg);
			break;
		case 0xDD:
			parseRemoveVip(msg);
			break;
		case 0xDE:
			parseEditVip(msg);
			break;
		case 0xDF:
			parseVipGroupActions(msg);
			break;
		case 0xE1:
			parseBestiarysendRaces();
			break;
		case 0xE2:
			parseBestiarysendCreatures(msg);
			break;
		case 0xE3:
			parseBestiarysendMonsterData(msg);
			break;
		case 0xE4:
			parseSendBuyCharmRune(msg);
			break;
		case 0xE5:
			parseCyclopediaCharacterInfo(msg);
			break;
		case 0xE6:
			parseBugReport(msg);
			break;
		case 0xE7:
			parseWheelGemAction(msg);
			break;
		case 0xE8:
			parseOfferDescription(msg);
			break;
		case 0xEB:
			parsePreyAction(msg);
			break;
		case 0xED:
			parseSendResourceBalance();
			break;
		case 0xEE:
			parseGreet(msg);
			break;
		// Premium coins transfer
		// case 0xEF: parseCoinTransfer(msg); break;
		case 0xF0:
			g_game().playerShowQuestLog(player->getID());
			break;
		case 0xF1:
			parseQuestLine(msg);
			break;
		// case 0xF2: parseRuleViolationReport(msg); break;
		case 0xF3: /* get object info */
			break;
		case 0xF4:
			parseMarketLeave();
			break;
		case 0xF5:
			parseMarketBrowse(msg);
			break;
		case 0xF6:
			parseMarketCreateOffer(msg);
			break;
		case 0xF7:
			parseMarketCancelOffer(msg);
			break;
		case 0xF8:
			parseMarketAcceptOffer(msg);
			break;
		case 0xF9:
			parseModalWindowAnswer(msg);
			break;
		case 0xFF:
			parseRewardChestCollect(msg);
			break;
			// case 0xFA: parseStoreOpen(msg); break;
			// case 0xFB: parseStoreRequestOffers(msg); break;
			// case 0xFC: parseStoreBuyOffer(msg) break;
			// case 0xFD: parseStoreOpenTransactionHistory(msg); break;
			// case 0xFE: parseStoreRequestTransactionHistory(msg); break;

			// case 0xDF, 0xE0, 0xE1, 0xFB, 0xFC, 0xFD, 0xFE Premium Shop.

		default:
			std::string hexString = fmt::format("0x{:02x}", recvbyte);
			g_logger().debug("Player '{}' sent unknown packet header: hex[{}], decimal[{}]", player->getName(), asUpperCaseString(hexString), recvbyte);
			break;
	}
}

void ProtocolGame::parseHotkeyEquip(NetworkMessage &msg) {
	if (!player) {
		return;
	}

	auto itemId = msg.get<uint16_t>();
	auto tier = msg.get<uint8_t>();
	g_game().playerEquipItem(player->getID(), itemId, Item::items[itemId].upgradeClassification > 0, tier);
}

void ProtocolGame::GetTileDescription(const std::shared_ptr<Tile> &tile, NetworkMessage &msg) {
	if (oldProtocol) {
		msg.add<uint16_t>(0x00); // Env effects
	}

	int32_t count;
	std::shared_ptr<Item> ground = tile->getGround();
	if (ground) {
		AddItem(msg, ground);
		count = 1;
	} else {
		count = 0;
	}

	const TileItemVector* items = tile->getItemList();
	if (items) {
		for (auto it = items->getBeginTopItem(), end = items->getEndTopItem(); it != end; ++it) {
			AddItem(msg, *it);

			count++;
			if (count == 9 && tile->getPosition() == player->getPosition()) {
				break;
			} else if (count == 10) {
				return;
			}
		}
	}

	const CreatureVector* creatures = tile->getCreatures();
	if (creatures) {
		bool playerAdded = false;
		for (auto creature : std::ranges::reverse_view(*creatures)) {
			if (!player->canSeeCreature(creature)) {
				continue;
			}

			if (tile->getPosition() == player->getPosition() && count == 9 && !playerAdded) {
				creature = player;
			}

			if (creature->getID() == player->getID()) {
				playerAdded = true;
			}

			bool known;
			uint32_t removedKnown;
			checkCreatureAsKnown(creature->getID(), known, removedKnown);
			AddCreature(msg, creature, known, removedKnown);

			if (++count == 10) {
				return;
			}
		}
	}

	if (items) {
		for (auto it = items->getBeginDownItem(), end = items->getEndDownItem(); it != end; ++it) {
			AddItem(msg, *it);

			if (++count == 10) {
				return;
			}
		}
	}
}

void ProtocolGame::GetMapDescription(int32_t x, int32_t y, int32_t z, int32_t width, int32_t height, NetworkMessage &msg) {
	int32_t skip = -1;
	int32_t startz, endz, zstep;

	if (z > MAP_INIT_SURFACE_LAYER) {
		startz = z - MAP_LAYER_VIEW_LIMIT;
		endz = std::min<int32_t>(MAP_MAX_LAYERS - 1, z + MAP_LAYER_VIEW_LIMIT);
		zstep = 1;
	} else {
		startz = MAP_INIT_SURFACE_LAYER;
		endz = 0;
		zstep = -1;
	}

	for (int32_t nz = startz; nz != endz + zstep; nz += zstep) {
		GetFloorDescription(msg, x, y, nz, width, height, z - nz, skip);
	}

	if (skip >= 0) {
		msg.addByte(skip);
		msg.addByte(0xFF);
	}
}

void ProtocolGame::GetFloorDescription(NetworkMessage &msg, int32_t x, int32_t y, int32_t z, int32_t width, int32_t height, int32_t offset, int32_t &skip) {
	for (int32_t nx = 0; nx < width; nx++) {
		for (int32_t ny = 0; ny < height; ny++) {
			std::shared_ptr<Tile> tile = g_game().map.getTile(static_cast<uint16_t>(x + nx + offset), static_cast<uint16_t>(y + ny + offset), static_cast<uint8_t>(z));
			if (tile) {
				if (skip >= 0) {
					msg.addByte(skip);
					msg.addByte(0xFF);
				}

				skip = 0;
				GetTileDescription(tile, msg);
			} else if (skip == 0xFE) {
				msg.addByte(0xFF);
				msg.addByte(0xFF);
				skip = -1;
			} else {
				++skip;
			}
		}
	}
}

void ProtocolGame::checkCreatureAsKnown(uint32_t id, bool &known, uint32_t &removedKnown) {
	if (auto [creatureKnown, creatureInserted] = knownCreatureSet.insert(id);
	    !creatureInserted) {
		known = true;
		return;
	}
	known = false;
	if (knownCreatureSet.size() > 1300) {
		// Look for a creature to remove
		for (auto it = knownCreatureSet.begin(), end = knownCreatureSet.end(); it != end; ++it) {
			if (*it == id) {
				continue;
			}
			// We need to protect party players from removing
			std::shared_ptr<Creature> creature = g_game().getCreatureByID(*it);
			if (std::shared_ptr<Player> checkPlayer;
			    creature && (checkPlayer = creature->getPlayer()) != nullptr) {
				if (player->getParty() != checkPlayer->getParty() && !canSee(creature)) {
					removedKnown = *it;
					knownCreatureSet.erase(it);
					return;
				}
			} else if (!canSee(creature)) {
				removedKnown = *it;
				knownCreatureSet.erase(it);
				return;
			}
		}

		// Bad situation. Let's just remove anyone.
		auto it = knownCreatureSet.begin();
		if (*it == id) {
			++it;
		}

		removedKnown = *it;
		knownCreatureSet.erase(it);
	} else {
		removedKnown = 0;
	}
}

bool ProtocolGame::canSee(const std::shared_ptr<Creature> &c) const {
	if (!c || !player || c->isRemoved()) {
		return false;
	}

	if (!player->canSeeCreature(c)) {
		return false;
	}

	return canSee(c->getPosition());
}

bool ProtocolGame::canSee(const Position &pos) const {
	return canSee(pos.x, pos.y, pos.z);
}

bool ProtocolGame::canSee(int32_t x, int32_t y, int32_t z) const {
	if (!player) {
		return false;
	}

	const Position &myPos = player->getPosition();
	if (myPos.z <= MAP_INIT_SURFACE_LAYER) {
		// we are on ground level or above (7 -> 0)
		// view is from 7 -> 0
		if (z > MAP_INIT_SURFACE_LAYER) {
			return false;
		}
	} else if (myPos.z >= MAP_INIT_SURFACE_LAYER + 1) {
		// we are underground (8 -> 15)
		// view is +/- 2 from the floor we stand on
		if (std::abs(myPos.getZ() - z) > MAP_LAYER_VIEW_LIMIT) {
			return false;
		}
	}

	// negative offset means that the action taken place is on a lower floor than ourself
	const int8_t offsetz = myPos.getZ() - z;
	return (x >= myPos.getX() - MAP_MAX_CLIENT_VIEW_PORT_X + offsetz) && (x <= myPos.getX() + (MAP_MAX_CLIENT_VIEW_PORT_X + 1) + offsetz) && (y >= myPos.getY() - MAP_MAX_CLIENT_VIEW_PORT_Y + offsetz) && (y <= myPos.getY() + (MAP_MAX_CLIENT_VIEW_PORT_Y + 1) + offsetz);
}

// Parse methods
void ProtocolGame::parseChannelInvite(NetworkMessage &msg) {
	const std::string name = msg.getString();
	g_game().playerChannelInvite(player->getID(), name);
}

void ProtocolGame::parseChannelExclude(NetworkMessage &msg) {
	const std::string name = msg.getString();
	g_game().playerChannelExclude(player->getID(), name);
}

void ProtocolGame::parseOpenChannel(NetworkMessage &msg) {
	auto channelId = msg.get<uint16_t>();
	g_game().playerOpenChannel(player->getID(), channelId);
}

void ProtocolGame::parseCloseChannel(NetworkMessage &msg) {
	auto channelId = msg.get<uint16_t>();
	g_game().playerCloseChannel(player->getID(), channelId);
}

void ProtocolGame::parseOpenPrivateChannel(NetworkMessage &msg) {
	std::string receiver = msg.getString();
	g_game().playerOpenPrivateChannel(player->getID(), receiver);
}

void ProtocolGame::parseAutoWalk(NetworkMessage &msg) {
	uint8_t numdirs = msg.getByte();
	if (numdirs == 0 || (msg.getBufferPosition() + numdirs) != (msg.getLength() + 8)) {
		return;
	}

	std::vector<Direction> path;
	path.resize(numdirs, DIRECTION_NORTH);
	for (size_t i = numdirs; --i < numdirs;) {
		const uint8_t rawdir = msg.getByte();
		switch (rawdir) {
			case 1:
				path[i] = DIRECTION_EAST;
				break;
			case 2:
				path[i] = DIRECTION_NORTHEAST;
				break;
			case 3:
				path[i] = DIRECTION_NORTH;
				break;
			case 4:
				path[i] = DIRECTION_NORTHWEST;
				break;
			case 5:
				path[i] = DIRECTION_WEST;
				break;
			case 6:
				path[i] = DIRECTION_SOUTHWEST;
				break;
			case 7:
				path[i] = DIRECTION_SOUTH;
				break;
			case 8:
				path[i] = DIRECTION_SOUTHEAST;
				break;
			default:
				break;
		}
	}

	if (path.empty()) {
		return;
	}

	g_game().playerAutoWalk(player->getID(), path);
}

void ProtocolGame::parseSetOutfit(NetworkMessage &msg) {
	if (!player || player->isRemoved()) {
		return;
	}

	uint16_t startBufferPosition = msg.getBufferPosition();
	const auto &outfitModule = g_modules().getEventByRecvbyte(0xD3, false);
	if (outfitModule) {
		outfitModule->executeOnRecvbyte(player, msg);
	}

	if (msg.getBufferPosition() == startBufferPosition) {
		uint8_t outfitType = !oldProtocol ? msg.getByte() : 0;
		Outfit_t newOutfit;
		newOutfit.lookType = msg.get<uint16_t>();
		newOutfit.lookHead = std::min<uint8_t>(132, msg.getByte());
		newOutfit.lookBody = std::min<uint8_t>(132, msg.getByte());
		newOutfit.lookLegs = std::min<uint8_t>(132, msg.getByte());
		newOutfit.lookFeet = std::min<uint8_t>(132, msg.getByte());
		newOutfit.lookAddons = msg.getByte();
		if (outfitType == 0) {
			newOutfit.lookMount = msg.get<uint16_t>();
			if (!oldProtocol) {
				newOutfit.lookMountHead = std::min<uint8_t>(132, msg.getByte());
				newOutfit.lookMountBody = std::min<uint8_t>(132, msg.getByte());
				newOutfit.lookMountLegs = std::min<uint8_t>(132, msg.getByte());
				newOutfit.lookMountFeet = std::min<uint8_t>(132, msg.getByte());
				bool isMounted = msg.getByte();
				newOutfit.lookFamiliarsType = msg.get<uint16_t>();
				g_logger().debug("Bool isMounted: {}", isMounted);
			}

			uint8_t isMountRandomized = msg.getByte();
			g_game().playerChangeOutfit(player->getID(), newOutfit, isMountRandomized);
		} else if (outfitType == 1) {
			// This value probably has something to do with try outfit variable inside outfit window dialog
			// if try outfit is set to 2 it expects uint32_t value after mounted and disable mounts from outfit window dialog
			newOutfit.lookMount = 0;
			msg.get<uint32_t>();
		} else if (outfitType == 2) {
			Position pos = msg.getPosition();
			auto itemId = msg.get<uint16_t>();
			uint8_t stackpos = msg.getByte();
			newOutfit.lookMount = msg.get<uint16_t>();
			newOutfit.lookMountHead = std::min<uint8_t>(132, msg.getByte());
			newOutfit.lookMountBody = std::min<uint8_t>(132, msg.getByte());
			newOutfit.lookMountLegs = std::min<uint8_t>(132, msg.getByte());
			newOutfit.lookMountFeet = std::min<uint8_t>(132, msg.getByte());
			uint8_t direction = std::max<uint8_t>(DIRECTION_NORTH, std::min<uint8_t>(DIRECTION_WEST, msg.getByte()));
			uint8_t podiumVisible = msg.getByte();
			g_game().playerSetShowOffSocket(player->getID(), newOutfit, pos, stackpos, itemId, podiumVisible, direction);
		}
	}
}

void ProtocolGame::parseToggleMount(NetworkMessage &msg) {
	bool mount = msg.getByte() != 0;
	g_game().playerToggleMount(player->getID(), mount);
}

void ProtocolGame::parseApplyImbuement(NetworkMessage &msg) {
	uint8_t slot = msg.getByte();
	auto imbuementId = msg.get<uint32_t>();
	bool protectionCharm = msg.getByte() != 0x00;
	g_game().playerApplyImbuement(player->getID(), imbuementId, slot, protectionCharm);
}

void ProtocolGame::parseClearImbuement(NetworkMessage &msg) {
	uint8_t slot = msg.getByte();
	g_game().playerClearImbuement(player->getID(), slot);
}

void ProtocolGame::parseCloseImbuementWindow(NetworkMessage &) {
	g_game().playerCloseImbuementWindow(player->getID());
}

void ProtocolGame::parseUseItem(NetworkMessage &msg) {
	Position pos = msg.getPosition();
	auto itemId = msg.get<uint16_t>();
	uint8_t stackpos = msg.getByte();
	uint8_t index = msg.getByte();
	g_game().playerUseItem(player->getID(), pos, stackpos, index, itemId);
}

void ProtocolGame::parseUseItemEx(NetworkMessage &msg) {
	Position fromPos = msg.getPosition();
	auto fromItemId = msg.get<uint16_t>();
	uint8_t fromStackPos = msg.getByte();
	Position toPos = msg.getPosition();
	auto toItemId = msg.get<uint16_t>();
	uint8_t toStackPos = msg.getByte();
	g_game().playerUseItemEx(player->getID(), fromPos, fromStackPos, fromItemId, toPos, toStackPos, toItemId);
}

void ProtocolGame::parseUseWithCreature(NetworkMessage &msg) {
	Position fromPos = msg.getPosition();
	auto itemId = msg.get<uint16_t>();
	uint8_t fromStackPos = msg.getByte();
	auto creatureId = msg.get<uint32_t>();
	g_game().playerUseWithCreature(player->getID(), fromPos, fromStackPos, creatureId, itemId);
}

void ProtocolGame::parseCloseContainer(NetworkMessage &msg) {
	uint8_t cid = msg.getByte();
	g_game().playerCloseContainer(player->getID(), cid);
}

void ProtocolGame::parseUpArrowContainer(NetworkMessage &msg) {
	uint8_t cid = msg.getByte();
	g_game().playerMoveUpContainer(player->getID(), cid);
}

void ProtocolGame::parseUpdateContainer(NetworkMessage &msg) {
	uint8_t cid = msg.getByte();
	g_game().playerUpdateContainer(player->getID(), cid);
}

void ProtocolGame::parseTeleport(NetworkMessage &msg) {
	Position newPosition = msg.getPosition();
	g_game().playerTeleport(player->getID(), newPosition);
}

void ProtocolGame::parseThrow(NetworkMessage &msg) {
	Position fromPos = msg.getPosition();
	auto itemId = msg.get<uint16_t>();
	uint8_t fromStackpos = msg.getByte();
	Position toPos = msg.getPosition();
	uint8_t count = msg.getByte();

	if (toPos != fromPos) {
		g_game().playerMoveThing(player->getID(), fromPos, itemId, fromStackpos, toPos, count);
	}
}

void ProtocolGame::parseLookAt(NetworkMessage &msg) {
	Position pos = msg.getPosition();
	auto itemId = msg.get<uint16_t>();
	uint8_t stackpos = msg.getByte();
	g_game().playerLookAt(player->getID(), itemId, pos, stackpos);
}

void ProtocolGame::parseLookInBattleList(NetworkMessage &msg) {
	auto creatureId = msg.get<uint32_t>();
	g_game().playerLookInBattleList(player->getID(), creatureId);
}

void ProtocolGame::parseQuickLoot(NetworkMessage &msg) {
	if (oldProtocol) {
		return;
	}

	uint8_t variant = msg.getByte();
	const Position pos = msg.getPosition();
	auto itemId = 0;
	uint8_t stackpos = 0;
	bool lootAllCorpses = true;
	bool autoLoot = true;

	if (variant == 2) {
		// Loot player nearby (13.40)
	} else {
		itemId = msg.get<uint16_t>();
		stackpos = msg.getByte();
		lootAllCorpses = variant == 1;
		autoLoot = false;
	}
	g_logger().debug("[{}] variant {}, pos {}, itemId {}, stackPos {}", __FUNCTION__, variant, pos.toString(), itemId, stackpos);
	g_game().playerQuickLoot(player->getID(), pos, itemId, stackpos, nullptr, lootAllCorpses, autoLoot);
}

void ProtocolGame::parseLootContainer(NetworkMessage &msg) {
	if (oldProtocol) {
		return;
	}

	uint8_t action = msg.getByte();
	if (action == 0) {
		auto category = static_cast<ObjectCategory_t>(msg.getByte());
		Position pos = msg.getPosition();
		auto itemId = msg.get<uint16_t>();
		uint8_t stackpos = msg.getByte();
		g_game().playerSetManagedContainer(player->getID(), category, pos, itemId, stackpos, true);
	} else if (action == 1) {
		auto category = static_cast<ObjectCategory_t>(msg.getByte());
		g_game().playerClearManagedContainer(player->getID(), category, true);
	} else if (action == 2) {
		auto category = static_cast<ObjectCategory_t>(msg.getByte());
		g_game().playerOpenManagedContainer(player->getID(), category, true);
	} else if (action == 3) {
		bool useMainAsFallback = msg.getByte() == 1;
		g_game().playerSetQuickLootFallback(player->getID(), useMainAsFallback);
	} else if (action == 4) {
		auto category = static_cast<ObjectCategory_t>(msg.getByte());
		Position pos = msg.getPosition();
		auto itemId = msg.get<uint16_t>();
		uint8_t stackpos = msg.getByte();
		g_logger().debug("[{}] action {}, category {}, pos {}, itemId {}, stackPos {}", __FUNCTION__, action, static_cast<uint8_t>(category), pos.toString(), itemId, stackpos);
		g_game().playerSetManagedContainer(player->getID(), category, pos, itemId, stackpos, false);
	} else if (action == 5) {
		auto category = static_cast<ObjectCategory_t>(msg.getByte());
		g_game().playerClearManagedContainer(player->getID(), category, false);
	} else if (action == 6) {
		auto category = static_cast<ObjectCategory_t>(msg.getByte());
		g_game().playerOpenManagedContainer(player->getID(), category, false);
	}

	g_logger().debug("[{}] action type {}", __FUNCTION__, action);
}

void ProtocolGame::parseQuickLootBlackWhitelist(NetworkMessage &msg) {
	if (oldProtocol) {
		return;
	}

	auto filter = (QuickLootFilter_t)msg.getByte();
	std::vector<uint16_t> listedItems;

	auto size = msg.get<uint16_t>();
	listedItems.reserve(size);

	for (int i = 0; i < size; i++) {
		listedItems.push_back(msg.get<uint16_t>());
	}

	g_game().playerQuickLootBlackWhitelist(player->getID(), filter, listedItems);
}

void ProtocolGame::parseSay(NetworkMessage &msg) {
	std::string receiver;
	uint16_t channelId {};

	auto type = static_cast<SpeakClasses>(msg.getByte());
	switch (type) {
		case TALKTYPE_PRIVATE_TO:
		case TALKTYPE_PRIVATE_RED_TO:
			receiver = msg.getString();
			channelId = 0;
			break;

		case TALKTYPE_CHANNEL_Y:
		case TALKTYPE_CHANNEL_R1:
			channelId = msg.get<uint16_t>();
			break;

		default:
			channelId = 0;
			break;
	}

	const std::string text = msg.getString();
	if (text.length() > 255) {
		return;
	}

	g_game().playerSay(player->getID(), channelId, type, receiver, text);
}

void ProtocolGame::parseFightModes(NetworkMessage &msg) {
	uint8_t rawFightMode = msg.getByte(); // 1 - offensive, 2 - balanced, 3 - defensive
	uint8_t rawChaseMode = msg.getByte(); // 0 - stand while fightning, 1 - chase opponent
	uint8_t rawSecureMode = msg.getByte(); // 0 - can't attack unmarked, 1 - can attack unmarked
	// uint8_t rawPvpMode = msg.getByte(); // pvp mode introduced in 10.0

	FightMode_t fightMode;
	if (rawFightMode == 1) {
		fightMode = FIGHTMODE_ATTACK;
	} else if (rawFightMode == 2) {
		fightMode = FIGHTMODE_BALANCED;
	} else {
		fightMode = FIGHTMODE_DEFENSE;
	}

	g_game().playerSetFightModes(player->getID(), fightMode, rawChaseMode != 0, rawSecureMode != 0);
}

void ProtocolGame::parseAttack(NetworkMessage &msg) {
	auto creatureId = msg.get<uint32_t>();
	// msg.get<uint32_t>(); creatureId (same as above)
	g_game().playerSetAttackedCreature(player->getID(), creatureId);
}

void ProtocolGame::parseFollow(NetworkMessage &msg) {
	auto creatureId = msg.get<uint32_t>();
	// msg.get<uint32_t>(); creatureId (same as above)
	g_game().playerFollowCreature(player->getID(), creatureId);
}

void ProtocolGame::parseTextWindow(NetworkMessage &msg) {
	auto windowTextId = msg.get<uint32_t>();
	const std::string newText = msg.getString();
	g_game().playerWriteItem(player->getID(), windowTextId, newText);
}

void ProtocolGame::parseHouseWindow(NetworkMessage &msg) {
	uint8_t doorId = msg.getByte();
	auto id = msg.get<uint32_t>();
	const std::string text = msg.getString();
	g_game().playerUpdateHouseWindow(player->getID(), doorId, id, text);
}

void ProtocolGame::parseLookInShop(NetworkMessage &msg) {
	auto id = msg.get<uint16_t>();
	uint8_t count = msg.getByte();
	g_game().playerLookInShop(player->getID(), id, count);
}

void ProtocolGame::parsePlayerBuyOnShop(NetworkMessage &msg) {
	auto id = msg.get<uint16_t>();
	uint8_t count = msg.getByte();
	uint16_t amount = oldProtocol ? static_cast<uint16_t>(msg.getByte()) : msg.get<uint16_t>();
	bool ignoreCap = msg.getByte() != 0;
	bool inBackpacks = msg.getByte() != 0;
	g_game().playerBuyItem(player->getID(), id, count, amount, ignoreCap, inBackpacks);
}

void ProtocolGame::parsePlayerSellOnShop(NetworkMessage &msg) {
	auto id = msg.get<uint16_t>();
	uint8_t count = std::max(msg.getByte(), (uint8_t)1);
	uint16_t amount = oldProtocol ? static_cast<uint16_t>(msg.getByte()) : msg.get<uint16_t>();
	bool ignoreEquipped = msg.getByte() != 0;

	g_game().playerSellItem(player->getID(), id, count, amount, ignoreEquipped);
}

void ProtocolGame::parseRequestTrade(NetworkMessage &msg) {
	Position pos = msg.getPosition();
	auto itemId = msg.get<uint16_t>();
	uint8_t stackpos = msg.getByte();
	auto playerId = msg.get<uint32_t>();
	g_game().playerRequestTrade(player->getID(), pos, stackpos, playerId, itemId);
}

void ProtocolGame::parseLookInTrade(NetworkMessage &msg) {
	bool counterOffer = (msg.getByte() == 0x01);
	uint8_t index = msg.getByte();
	g_game().playerLookInTrade(player->getID(), counterOffer, index);
}

void ProtocolGame::parseAddVip(NetworkMessage &msg) {
	const std::string name = msg.getString();
	g_game().playerRequestAddVip(player->getID(), name);
}

void ProtocolGame::parseRemoveVip(NetworkMessage &msg) {
	auto guid = msg.get<uint32_t>();
	g_game().playerRequestRemoveVip(player->getID(), guid);
}

void ProtocolGame::parseEditVip(NetworkMessage &msg) {
	std::vector<uint8_t> vipGroupsId;
	auto guid = msg.get<uint32_t>();
	const std::string description = msg.getString();
	uint32_t icon = std::min<uint32_t>(10, msg.get<uint32_t>()); // 10 is max icon in 9.63
	bool notify = msg.getByte() != 0;
	uint8_t groupsAmount = msg.getByte();
	for (uint8_t i = 0; i < groupsAmount; ++i) {
		uint8_t groupId = msg.getByte();
		vipGroupsId.emplace_back(groupId);
	}
	g_game().playerRequestEditVip(player->getID(), guid, description, icon, notify, vipGroupsId);
}

void ProtocolGame::parseVipGroupActions(NetworkMessage &msg) {
	uint8_t action = msg.getByte();

	switch (action) {
		case 0x01: {
			const std::string groupName = msg.getString();
			player->vip()->addGroup(groupName);
			break;
		}
		case 0x02: {
			const uint8_t groupId = msg.getByte();
			const std::string newGroupName = msg.getString();
			player->vip()->editGroup(groupId, newGroupName);
			break;
		}
		case 0x03: {
			const uint8_t groupId = msg.getByte();
			player->vip()->removeGroup(groupId);
			break;
		}
		default: {
			break;
		}
	}
}

void ProtocolGame::parseRotateItem(NetworkMessage &msg) {
	Position pos = msg.getPosition();
	auto itemId = msg.get<uint16_t>();
	uint8_t stackpos = msg.getByte();
	const auto &itemType = Item::items[itemId];
	if (itemType.isPodium) {
		g_game().playerRotatePodium(player->getID(), pos, stackpos, itemId);
	} else {
		g_game().playerRotateItem(player->getID(), pos, stackpos, itemId);
	}
}

void ProtocolGame::parseWrapableItem(NetworkMessage &msg) {
	Position pos = msg.getPosition();
	auto itemId = msg.get<uint16_t>();
	uint8_t stackpos = msg.getByte();
	g_game().playerWrapableItem(player->getID(), pos, stackpos, itemId);
}

void ProtocolGame::parseInspectionObject(NetworkMessage &msg) {
	if (oldProtocol) {
		return;
	}

	uint8_t inspectionType = msg.getByte();
	if (inspectionType == INSPECT_NORMALOBJECT) {
		Position pos = msg.getPosition();
		g_game().playerInspectItem(player, pos);
	} else if (inspectionType == INSPECT_NPCTRADE || inspectionType == INSPECT_CYCLOPEDIA) {
		auto itemId = msg.get<uint16_t>();
		uint16_t itemCount = msg.getByte();
		g_game().playerInspectItem(player, itemId, static_cast<int8_t>(itemCount), (inspectionType == INSPECT_CYCLOPEDIA));
	}
}

void ProtocolGame::sendSessionEndInformation(SessionEndInformations information) {
	if (!oldProtocol) {
		auto output = OutputMessagePool::getOutputMessage();
		output->addByte(0x18);
		output->addByte(information);
		send(output);
	}
	disconnect();
}

void ProtocolGame::sendItemInspection(uint16_t itemId, uint8_t itemCount, const std::shared_ptr<Item> &item, bool cyclopedia) {
	if (oldProtocol) {
		return;
	}

	NetworkMessage msg;
	msg.addByte(0x76);
	msg.addByte(0x00);
	msg.addByte(cyclopedia ? 0x01 : 0x00);
	msg.add<uint32_t>(player->getID()); // 13.00 Creature ID
	msg.addByte(0x01);

	const ItemType &it = Item::items[itemId];

	if (item) {
		msg.addString(item->getName());
		AddItem(msg, item);
	} else {
		msg.addString(it.name);
		AddItem(msg, it.id, itemCount, 0);
	}
	msg.addByte(0);

	auto descriptions = Item::getDescriptions(it, item);
	msg.addByte(descriptions.size());
	for (const auto &description : descriptions) {
		msg.addString(description.first);
		msg.addString(description.second);
	}
	writeToOutputBuffer(msg);
}

void ProtocolGame::parseFriendSystemAction(NetworkMessage &msg) {
	uint8_t state = msg.getByte();
	if (state == 0x0E) {
		uint8_t titleId = msg.getByte();
		g_game().playerFriendSystemAction(player, state, titleId);
	}
}

void ProtocolGame::parseCyclopediaCharacterInfo(NetworkMessage &msg) {
	if (oldProtocol) {
		return;
	}

	uint32_t characterID;
	CyclopediaCharacterInfoType_t characterInfoType;
	characterID = msg.get<uint32_t>();
	characterInfoType = static_cast<CyclopediaCharacterInfoType_t>(msg.getByte());
	uint16_t entriesPerPage = 0, page = 0;
	if (characterInfoType == CYCLOPEDIA_CHARACTERINFO_RECENTDEATHS || characterInfoType == CYCLOPEDIA_CHARACTERINFO_RECENTPVPKILLS) {
		entriesPerPage = std::min<uint16_t>(30, std::max<uint16_t>(5, msg.get<uint16_t>()));
		page = std::max<uint16_t>(1, msg.get<uint16_t>());
	}
	if (characterID == 0) {
		characterID = player->getGUID();
	}
	g_game().playerCyclopediaCharacterInfo(player, characterID, characterInfoType, entriesPerPage, page);
}

void ProtocolGame::parseHighscores(NetworkMessage &msg) {
	if (oldProtocol) {
		return;
	}

	auto type = static_cast<HighscoreType_t>(msg.getByte());
	uint8_t category = msg.getByte();
	auto vocation = msg.get<uint32_t>();
	uint16_t page = 1;
	const std::string worldName = msg.getString();
	msg.getByte(); // Game World Category
	msg.getByte(); // BattlEye World Type
	if (type == HIGHSCORE_GETENTRIES) {
		page = std::max<uint16_t>(1, msg.get<uint16_t>());
	}
	uint8_t entriesPerPage = std::min<uint8_t>(30, std::max<uint8_t>(5, msg.getByte()));
	g_game().playerHighscores(player, type, category, vocation, worldName, page, entriesPerPage);
}

void ProtocolGame::parseTaskHuntingAction(NetworkMessage &msg) {
	if (oldProtocol) {
		return;
	}

	uint8_t slot = msg.getByte();
	uint8_t action = msg.getByte();
	bool upgrade = msg.getByte() != 0;
	auto raceId = msg.get<uint16_t>();

	if (!g_configManager().getBoolean(TASK_HUNTING_ENABLED)) {
		return;
	}

	g_game().playerTaskHuntingAction(player->getID(), slot, action, upgrade, raceId);
}

void ProtocolGame::sendHighscoresNoData() {
	if (oldProtocol) {
		return;
	}

	NetworkMessage msg;
	msg.addByte(0xB1);
	msg.addByte(0x01); // No data available
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendHighscores(const std::vector<HighscoreCharacter> &characters, uint8_t categoryId, uint32_t vocationId, uint16_t page, uint16_t pages, uint32_t updateTimer) {
	if (oldProtocol) {
		return;
	}

	NetworkMessage msg;
	msg.addByte(0xB1);
	msg.addByte(0x00); // All data available

	msg.addByte(1); // Worlds
	auto serverName = g_configManager().getString(SERVER_NAME);
	msg.addString(serverName); // First World
	msg.addString(serverName); // Selected World

	msg.addByte(0); // Game World Category: 0xFF(-1) - Selected World
	msg.addByte(0); // BattlEye World Type

	auto vocationPosition = msg.getBufferPosition();
	uint8_t vocations = 1;

	msg.skipBytes(1); // Vocation Count
	msg.add<uint32_t>(0xFFFFFFFF); // All Vocations - hardcoded
	msg.addString("(all)"); // All Vocations - hardcoded

	uint32_t selectedVocation = 0xFFFFFFFF;
	const auto vocationsMap = g_vocations().getVocations();
	for (const auto &it : vocationsMap) {
		const auto &vocation = it.second;
		if (vocation->getFromVocation() == static_cast<uint32_t>(vocation->getId())) {
			msg.add<uint32_t>(vocation->getFromVocation()); // Vocation Id
			msg.addString(vocation->getVocName()); // Vocation Name
			++vocations;
			if (vocation->getFromVocation() == vocationId) {
				selectedVocation = vocationId;
			}
		}
	}
	msg.add<uint32_t>(selectedVocation); // Selected Vocation

	uint8_t selectedCategory = 0;
	const auto &highscoreCategories = g_game().getHighscoreCategories();
	msg.addByte(highscoreCategories.size()); // Category Count
	g_logger().debug("[ProtocolGame::sendHighscores] - Category Count: {}", highscoreCategories.size());
	for (const HighscoreCategory &category : highscoreCategories) {
		g_logger().debug("[ProtocolGame::sendHighscores] - Category: {} - Name: {}", category.m_id, category.m_name);
		msg.addByte(category.m_id); // Category Id
		msg.addString(category.m_name); // Category Name
		if (category.m_id == categoryId) {
			selectedCategory = categoryId;
		}
	}
	msg.addByte(selectedCategory); // Selected Category

	msg.add<uint16_t>(page); // Current page
	msg.add<uint16_t>(pages); // Pages

	msg.addByte(characters.size()); // Character Count
	for (const HighscoreCharacter &character : characters) {
		msg.add<uint32_t>(character.rank); // Rank
		msg.addString(character.name); // Character Name
		msg.addString(character.loyaltyTitle); // Character Loyalty Title
		msg.addByte(character.vocation); // Vocation Id
		msg.addString(serverName); // World
		msg.add<uint16_t>(character.level); // Level
		msg.addByte((player->getGUID() == character.id)); // Player Indicator Boolean
		msg.add<uint64_t>(character.points); // Points
	}

	msg.addByte(0xFF); // ??
	msg.addByte(0); // ??
	msg.addByte(1); // ??
	msg.add<uint32_t>(updateTimer); // Last Update
	msg.setBufferPosition(vocationPosition);
	msg.addByte(vocations);
	writeToOutputBuffer(msg);
}

void ProtocolGame::parseConfigureShowOffSocket(NetworkMessage &msg) {
	if (oldProtocol) {
		return;
	}

	Position pos = msg.getPosition();
	auto itemId = msg.get<uint16_t>();
	uint8_t stackpos = msg.getByte();
	g_game().playerConfigureShowOffSocket(player->getID(), pos, stackpos, itemId);
}

void ProtocolGame::parseRuleViolationReport(NetworkMessage &msg) {
	uint8_t reportType = msg.getByte();
	uint8_t reportReason = msg.getByte();
	const std::string &targetName = msg.getString();
	const std::string &comment = msg.getString();
	std::string translation;
	if (reportType == REPORT_TYPE_NAME) {
		translation = msg.getString();
	} else if (reportType == REPORT_TYPE_STATEMENT) {
		translation = msg.getString();
		msg.get<uint32_t>(); // statement id, used to get whatever player have said, we don't log that.
	}

	g_game().playerReportRuleViolationReport(player->getID(), targetName, reportType, reportReason, comment, translation);
}

void ProtocolGame::parseBestiarysendRaces() {
	if (oldProtocol) {
		return;
	}

	NetworkMessage msg;
	msg.addByte(0xd5);
	msg.add<uint16_t>(BESTY_RACE_LAST);
	std::map<uint16_t, std::string> mtype_list = g_game().getBestiaryList();
	for (uint8_t i = BESTY_RACE_FIRST; i <= BESTY_RACE_LAST; i++) {
		std::string BestClass;
		uint16_t count = 0;
		for (const auto &rit : mtype_list) {
			const auto mtype = g_monsters().getMonsterType(rit.second);
			if (!mtype) {
				return;
			}
			if (mtype->info.bestiaryRace == static_cast<BestiaryType_t>(i)) {
				count += 1;
				BestClass = mtype->info.bestiaryClass;
			}
		}
		msg.addString(BestClass);
		msg.add<uint16_t>(count);
		uint16_t unlockedCount = g_iobestiary().getBestiaryRaceUnlocked(player, static_cast<BestiaryType_t>(i));
		msg.add<uint16_t>(unlockedCount);
	}
	writeToOutputBuffer(msg);

	player->BestiarysendCharms();
}

void ProtocolGame::sendBestiaryEntryChanged(uint16_t raceid) {
	if (oldProtocol) {
		return;
	}

	NetworkMessage msg;
	msg.addByte(0xd9);
	msg.add<uint16_t>(raceid);
	writeToOutputBuffer(msg);
}

void ProtocolGame::parseBestiarysendMonsterData(NetworkMessage &msg) {
	if (oldProtocol) {
		return;
	}

	auto raceId = msg.get<uint16_t>();
	std::string Class;
	std::shared_ptr<MonsterType> mtype = nullptr;
	std::map<uint16_t, std::string> mtype_list = g_game().getBestiaryList();

	auto ait = mtype_list.find(raceId);
	if (ait != mtype_list.end()) {
		auto mType = g_monsters().getMonsterType(ait->second);
		if (mType) {
			Class = mType->info.bestiaryClass;
			mtype = mType;
		}
	}

	if (!mtype) {
		g_logger().warn("[ProtocolGame::parseBestiarysendMonsterData] - "
		                "MonsterType was not found");
		return;
	}

	uint32_t killCounter = player->getBestiaryKillCount(raceId);
	uint8_t currentLevel = g_iobestiary().getKillStatus(mtype, killCounter);

	NetworkMessage newmsg;
	newmsg.addByte(0xd7);
	newmsg.add<uint16_t>(raceId);
	newmsg.addString(Class);

	newmsg.addByte(currentLevel);

	newmsg.add<uint16_t>(0); // Animus Mastery Bonus
	newmsg.add<uint16_t>(0); // Animus Mastery Points

	newmsg.add<uint32_t>(killCounter);

	newmsg.add<uint16_t>(mtype->info.bestiaryFirstUnlock);
	newmsg.add<uint16_t>(mtype->info.bestiarySecondUnlock);
	newmsg.add<uint16_t>(mtype->info.bestiaryToUnlock);

	newmsg.addByte(mtype->info.bestiaryStars);
	newmsg.addByte(mtype->info.bestiaryOccurrence);

	std::vector<LootBlock> lootList = mtype->info.lootItems;
	newmsg.addByte(lootList.size());
	for (const LootBlock &loot : lootList) {
		int8_t difficult = g_iobestiary().calculateDifficult(loot.chance);
		bool shouldAddItem = false;

		switch (currentLevel) {
			case 1:
				shouldAddItem = false;
				break;
			case 2:
				if (difficult < 2) {
					shouldAddItem = true;
				}
				break;
			case 3:
				if (difficult < 3) {
					shouldAddItem = true;
				}
				break;
			case 4:
				shouldAddItem = true;
				break;
		}

		newmsg.add<uint16_t>(g_configManager().getBoolean(SHOW_LOOTS_IN_BESTIARY) || shouldAddItem == true ? loot.id : 0);
		newmsg.addByte(difficult);
		newmsg.addByte(0); // 1 if special event - 0 if regular loot (?)
		if (g_configManager().getBoolean(SHOW_LOOTS_IN_BESTIARY) || shouldAddItem == true) {
			newmsg.addString(loot.name);
			newmsg.addByte(loot.countmax > 0 ? 0x1 : 0x0);
		}
	}

	if (currentLevel > 1) {
		newmsg.add<uint16_t>(mtype->info.bestiaryCharmsPoints);
		int8_t attackmode = 0;
		if (!mtype->info.isHostile) {
			attackmode = 2;
		} else if (mtype->info.targetDistance) {
			attackmode = 1;
		}

		newmsg.addByte(attackmode);
		newmsg.addByte(0x2);
		newmsg.add<uint32_t>(mtype->info.healthMax);
		newmsg.add<uint32_t>(mtype->info.experience);
		newmsg.add<uint16_t>(mtype->getBaseSpeed());
		newmsg.add<uint16_t>(mtype->info.armor);
		newmsg.addDouble(mtype->info.mitigation);
	}

	if (currentLevel > 2) {
		std::map<uint8_t, int16_t> elements = g_iobestiary().getMonsterElements(mtype);

		newmsg.addByte(elements.size());
		for (auto &element : elements) {
			newmsg.addByte(element.first);
			newmsg.add<uint16_t>(element.second);
		}

		newmsg.add<uint16_t>(1);
		newmsg.addString(mtype->info.bestiaryLocations);
	}

	if (currentLevel > 3) {
		charmRune_t mType_c = g_iobestiary().getCharmFromTarget(player, mtype);
		if (mType_c != CHARM_NONE) {
			newmsg.addByte(1);
			newmsg.addByte(mType_c);
			newmsg.add<uint32_t>(player->getLevel() * 100);
		} else {
			newmsg.addByte(0);
			newmsg.addByte(1);
		}
	}

	writeToOutputBuffer(newmsg);
}

void ProtocolGame::parseCyclopediaMonsterTracker(NetworkMessage &msg) {
	auto monsterRaceId = msg.get<uint16_t>();
	// Bosstiary tracker: 0 = disabled, 1 = enabled
	// Bestiary tracker: 1 = enabled
	auto trackerButtonType = msg.getByte();

	// Bosstiary tracker logic
	if (const auto monsterType = g_ioBosstiary().getMonsterTypeByBossRaceId(monsterRaceId)) {
		if (player->getBestiaryKillCount(monsterRaceId)) {
			if (trackerButtonType == 1) {
				player->addMonsterToCyclopediaTrackerList(monsterType, true, true);
			} else {
				player->removeMonsterFromCyclopediaTrackerList(monsterType, true, true);
			}
		}
		return;
	}

	// Bestiary tracker logic
	const auto bestiaryMonsters = g_game().getBestiaryList();
	auto it = bestiaryMonsters.find(monsterRaceId);
	if (it != bestiaryMonsters.end()) {
		const auto mtype = g_monsters().getMonsterType(it->second);
		if (!mtype) {
			g_logger().error("[{}] player {} have wrong boss with race {}", __FUNCTION__, player->getName(), monsterRaceId);
			return;
		}

		if (trackerButtonType == 1) {
			player->addMonsterToCyclopediaTrackerList(mtype, false, true);
		} else {
			player->removeMonsterFromCyclopediaTrackerList(mtype, false, true);
		}
	}
}

void ProtocolGame::sendTeamFinderList() {
	if (!player || oldProtocol) {
		return;
	}

	NetworkMessage msg;
	msg.addByte(0x2D);
	msg.addByte(0x00); // Bool value, with 'true' the player exceed packets for second.
	const auto &teamFinder = g_game().getTeamFinderList();
	msg.add<uint16_t>(teamFinder.size());
	for (const auto &it : teamFinder) {
		const auto &leader = g_game().getPlayerByGUID(it.first);
		if (!leader) {
			return;
		}

		const auto &teamAssemble = it.second;
		if (!teamAssemble) {
			return;
		}

		uint8_t status = 0;
		uint16_t membersSize = 0;
		msg.add<uint32_t>(leader->getGUID());
		msg.addString(leader->getName());
		msg.add<uint16_t>(teamAssemble->minLevel);
		msg.add<uint16_t>(teamAssemble->maxLevel);
		msg.addByte(teamAssemble->vocationIDs);
		msg.add<uint16_t>(teamAssemble->teamSlots);
		for (auto itt : teamAssemble->membersMap) {
			std::shared_ptr<Player> member = g_game().getPlayerByGUID(it.first);
			if (member) {
				if (itt.first == player->getGUID()) {
					status = itt.second;
				}

				if (itt.second == 3) {
					membersSize += 1;
				}
			}
		}
		msg.add<uint16_t>(std::max<uint16_t>((teamAssemble->teamSlots - teamAssemble->freeSlots), membersSize));
		// The leader does not count on this math, he is included inside the 'freeSlots'.
		msg.add<uint32_t>(teamAssemble->timestamp);
		msg.addByte(teamAssemble->teamType);

		switch (teamAssemble->teamType) {
			case 1: {
				msg.add<uint16_t>(teamAssemble->bossID);
				break;
			}
			case 2: {
				msg.add<uint16_t>(teamAssemble->hunt_type);
				msg.add<uint16_t>(teamAssemble->hunt_area);
				break;
			}
			case 3: {
				msg.add<uint16_t>(teamAssemble->questID);
				break;
			}

			default:
				break;
		}

		msg.addByte(status);
	}
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendLeaderTeamFinder(bool reset) {
	if (!player || oldProtocol) {
		return;
	}

	const auto &teamAssemble = g_game().getTeamFinder(player);
	if (!teamAssemble) {
		return;
	}

	NetworkMessage msg;
	msg.addByte(0x2C);
	msg.addByte(reset ? 1 : 0);
	if (reset) {
		g_game().removeTeamFinderListed(player->getGUID());
		return;
	}

	msg.add<uint16_t>(teamAssemble->minLevel);
	msg.add<uint16_t>(teamAssemble->maxLevel);
	msg.addByte(teamAssemble->vocationIDs);
	msg.add<uint16_t>(teamAssemble->teamSlots);
	msg.add<uint16_t>(teamAssemble->freeSlots);
	msg.add<uint32_t>(teamAssemble->timestamp);
	msg.addByte(teamAssemble->teamType);

	switch (teamAssemble->teamType) {
		case 1: {
			msg.add<uint16_t>(teamAssemble->bossID);
			break;
		}
		case 2: {
			msg.add<uint16_t>(teamAssemble->hunt_type);
			msg.add<uint16_t>(teamAssemble->hunt_area);
			break;
		}
		case 3: {
			msg.add<uint16_t>(teamAssemble->questID);
			break;
		}

		default:
			break;
	}

	uint16_t membersSize = 1;
	for (auto memberPair : teamAssemble->membersMap) {
		std::shared_ptr<Player> member = g_game().getPlayerByGUID(memberPair.first);
		if (member) {
			membersSize += 1;
		}
	}

	msg.add<uint16_t>(membersSize);
	std::shared_ptr<Player> leader = g_game().getPlayerByGUID(teamAssemble->leaderGuid);
	if (!leader) {
		return;
	}

	msg.add<uint32_t>(leader->getGUID());
	msg.addString(leader->getName());
	msg.add<uint16_t>(leader->getLevel());
	msg.addByte(leader->getVocation()->getClientId());
	msg.addByte(3);

	for (auto memberPair : teamAssemble->membersMap) {
		std::shared_ptr<Player> member = g_game().getPlayerByGUID(memberPair.first);
		if (!member) {
			continue;
		}
		msg.add<uint32_t>(member->getGUID());
		msg.addString(member->getName());
		msg.add<uint16_t>(member->getLevel());
		msg.addByte(member->getVocation()->getClientId());
		msg.addByte(memberPair.second);
	}

	writeToOutputBuffer(msg);
}

void ProtocolGame::createLeaderTeamFinder(NetworkMessage &msg) {
	if (!player || oldProtocol) {
		return;
	}

	const auto &teamAssemble = g_game().getOrCreateTeamFinder(player);
	teamAssemble->minLevel = msg.get<uint16_t>();
	teamAssemble->maxLevel = msg.get<uint16_t>();
	teamAssemble->vocationIDs = msg.getByte();
	teamAssemble->teamSlots = msg.get<uint16_t>();
	teamAssemble->freeSlots = msg.get<uint16_t>();
	teamAssemble->partyBool = (msg.getByte() == 1);
	teamAssemble->timestamp = msg.get<uint32_t>();
	teamAssemble->teamType = msg.getByte();

	uint16_t bossID = 0;
	uint16_t huntType1 = 0;
	uint16_t huntType2 = 0;
	uint16_t questID = 0;

	switch (teamAssemble->teamType) {
		case 1: {
			bossID = msg.get<uint16_t>();
			break;
		}
		case 2: {
			huntType1 = msg.get<uint16_t>();
			huntType2 = msg.get<uint16_t>();
			break;
		}

		case 3: {
			questID = msg.get<uint16_t>();
			break;
		}

		default:
			break;
	}

	teamAssemble->bossID = bossID;
	teamAssemble->hunt_type = huntType1;
	teamAssemble->hunt_area = huntType2;
	teamAssemble->questID = questID;
	teamAssemble->leaderGuid = player->getGUID();

	auto party = player->getParty();
	if (teamAssemble->partyBool && party) {
		for (const std::shared_ptr<Player> &member : party->getMembers()) {
			if (member && member->getGUID() != player->getGUID()) {
				teamAssemble->membersMap.insert({ member->getGUID(), 3 });
			}
		}
		auto partyLeader = party->getLeader();
		if (partyLeader && partyLeader->getGUID() != player->getGUID()) {
			teamAssemble->membersMap.insert({ partyLeader->getGUID(), 3 });
		}
	}
}

void ProtocolGame::parsePartyAnalyzerAction(NetworkMessage &msg) const {
	if (!player || oldProtocol) {
		return;
	}

	std::shared_ptr<Party> party = player->getParty();
	if (!party || !party->getLeader() || party->getLeader()->getID() != player->getID()) {
		return;
	}

	auto action = static_cast<PartyAnalyzerAction_t>(msg.getByte());
	if (action == PARTYANALYZERACTION_RESET) {
		party->resetAnalyzer();
	} else if (action == PARTYANALYZERACTION_PRICETYPE) {
		party->switchAnalyzerPriceType();
	} else if (action == PARTYANALYZERACTION_PRICEVALUE) {
		auto size = msg.get<uint16_t>();
		for (uint16_t i = 1; i <= size; i++) {
			auto itemId = msg.get<uint16_t>();
			auto price = msg.get<uint64_t>();
			player->setItemCustomPrice(itemId, price);
		}
		party->reloadPrices();
		party->updateTrackerAnalyzer();
	}
}

void ProtocolGame::parseLeaderFinderWindow(NetworkMessage &msg) {
	if (!player || oldProtocol) {
		return;
	}

	uint8_t action = msg.getByte();
	switch (action) {
		case 0: {
			player->sendLeaderTeamFinder(false);
			break;
		}
		case 1: {
			player->sendLeaderTeamFinder(true);
			break;
		}
		case 2: {
			auto memberID = msg.get<uint32_t>();
			std::shared_ptr<Player> member = g_game().getPlayerByGUID(memberID);
			if (!member) {
				return;
			}

			const auto &teamAssemble = g_game().getTeamFinder(player);
			if (!teamAssemble) {
				return;
			}

			uint8_t memberStatus = msg.getByte();
			for (auto &memberPair : teamAssemble->membersMap) {
				if (memberPair.first == memberID) {
					memberPair.second = memberStatus;
				}
			}

			switch (memberStatus) {
				case 2: {
					member->sendTextMessage(MESSAGE_STATUS, "You are invited to a new team.");
					break;
				}
				case 3: {
					member->sendTextMessage(MESSAGE_STATUS, "Your team finder request was accepted.");
					break;
				}
				case 4: {
					member->sendTextMessage(MESSAGE_STATUS, "Your team finder request was denied.");
					break;
				}

				default:
					break;
			}
			player->sendLeaderTeamFinder(false);
			break;
		}
		case 3: {
			player->createLeaderTeamFinder(msg);
			player->sendLeaderTeamFinder(false);
			break;
		}

		default:
			break;
	}
}

void ProtocolGame::parseMemberFinderWindow(NetworkMessage &msg) {
	if (!player || oldProtocol) {
		return;
	}

	uint8_t action = msg.getByte();
	if (action == 0) {
		player->sendTeamFinderList();
	} else {
		auto leaderID = msg.get<uint32_t>();
		std::shared_ptr<Player> leader = g_game().getPlayerByGUID(leaderID);
		if (!leader) {
			return;
		}

		const auto &teamAssemble = g_game().getTeamFinder(player);
		if (!teamAssemble) {
			return;
		}

		if (action == 1) {
			leader->sendTextMessage(MESSAGE_STATUS, "There is a new request to join your team.");
			teamAssemble->membersMap.insert({ player->getGUID(), 1 });
		} else {
			for (auto itt = teamAssemble->membersMap.begin(), end = teamAssemble->membersMap.end(); itt != end; ++itt) {
				if (itt->first == player->getGUID()) {
					teamAssemble->membersMap.erase(itt);
					break;
				}
			}
		}
		player->sendTeamFinderList();
	}
}

void ProtocolGame::parseSendBuyCharmRune(NetworkMessage &msg) {
	if (!player || oldProtocol) {
		return;
	}

	auto runeID = static_cast<charmRune_t>(msg.getByte());
	uint8_t action = msg.getByte();
	auto raceid = msg.get<uint16_t>();
	g_iobestiary().sendBuyCharmRune(player, runeID, action, raceid);
}

void ProtocolGame::refreshCyclopediaMonsterTracker(const std::unordered_set<std::shared_ptr<MonsterType>> &trackerSet, bool isBoss) {
	if (!player || oldProtocol) {
		return;
	}

	NetworkMessage msg;
	msg.addByte(0xB9);
	msg.addByte(isBoss ? 0x01 : 0x00);
	msg.addByte(trackerSet.size());
	for (const auto &mtype : trackerSet) {
		auto raceId = mtype->info.raceid;
		const auto stages = g_ioBosstiary().getBossRaceKillStages(mtype->info.bosstiaryRace);
		if (isBoss && (stages.empty() || stages.size() != 3)) {
			return;
		}

		uint32_t killAmount = player->getBestiaryKillCount(raceId);
		msg.add<uint16_t>(raceId);
		msg.add<uint32_t>(killAmount);
		bool completed = false;
		if (isBoss) {
			for (const auto &stage : stages) {
				msg.add<uint16_t>(static_cast<uint16_t>(stage.kills));
			}
			completed = g_ioBosstiary().getBossCurrentLevel(player, raceId) == 3;
		} else {
			msg.add<uint16_t>(mtype->info.bestiaryFirstUnlock);
			msg.add<uint16_t>(mtype->info.bestiarySecondUnlock);
			msg.add<uint16_t>(mtype->info.bestiaryToUnlock);
			completed = g_iobestiary().getKillStatus(mtype, killAmount) == 4;
		}

		if (completed) {
			msg.addByte(4);
		} else {
			msg.addByte(0);
		}
	}

	writeToOutputBuffer(msg);
}

void ProtocolGame::BestiarysendCharms() {
	if (!player || oldProtocol) {
		return;
	}

	int32_t removeRuneCost = player->getLevel() * 100;
	if (player->hasCharmExpansion()) {
		removeRuneCost = (removeRuneCost * 75) / 100;
	}
	NetworkMessage msg;
	msg.addByte(0xd8);
	msg.add<uint32_t>(player->getCharmPoints());

	const auto charmList = g_game().getCharmList();
	msg.addByte(charmList.size());
	for (const auto &c_type : charmList) {
		msg.addByte(c_type->id);
		msg.addString(c_type->name);
		msg.addString(c_type->description);
		msg.addByte(0); // Unknown
		msg.add<uint16_t>(c_type->points);
		if (g_iobestiary().hasCharmUnlockedRuneBit(c_type, player->getUnlockedRunesBit())) {
			msg.addByte(1);
			uint16_t raceid = player->parseRacebyCharm(c_type->id, false, 0);
			if (raceid > 0) {
				msg.addByte(1);
				msg.add<uint16_t>(raceid);
				msg.add<uint32_t>(removeRuneCost);
			} else {
				msg.addByte(0);
			}
		} else {
			msg.addByte(0);
			msg.addByte(0);
		}
	}
	msg.addByte(4); // Unknown

	auto finishedMonstersSet = g_iobestiary().getBestiaryFinished(player);
	for (charmRune_t charmRune : g_iobestiary().getCharmUsedRuneBitAll(player)) {
		const auto tmpCharm = g_iobestiary().getBestiaryCharm(charmRune);
		uint16_t tmp_raceid = player->parseRacebyCharm(tmpCharm->id, false, 0);

		std::erase(finishedMonstersSet, tmp_raceid);
	}

	msg.add<uint16_t>(finishedMonstersSet.size());
	for (uint16_t raceid_tmp : finishedMonstersSet) {
		msg.add<uint16_t>(raceid_tmp);
	}

	writeToOutputBuffer(msg);
}

void ProtocolGame::parseBestiarysendCreatures(NetworkMessage &msg) {
	if (!player || oldProtocol) {
		return;
	}

	std::ostringstream ss;
	std::map<uint16_t, std::string> race = {};
	std::string text;
	uint8_t search = msg.getByte();

	if (search == 1) {
		auto monsterAmount = msg.get<uint16_t>();
		std::map<uint16_t, std::string> mtype_list = g_game().getBestiaryList();
		for (uint16_t monsterCount = 1; monsterCount <= monsterAmount; monsterCount++) {
			auto raceid = msg.get<uint16_t>();
			if (player->getBestiaryKillCount(raceid) > 0) {
				auto it = mtype_list.find(raceid);
				if (it != mtype_list.end()) {
					race.insert({ raceid, it->second });
				}
			}
		}
	} else {
		std::string raceName = msg.getString();
		race = g_iobestiary().findRaceByName(raceName);

		if (race.empty()) {
			g_logger().warn("[ProtocolGame::parseBestiarysendCreature] - "
			                "Race was not found: {}, search: {}",
			                raceName, search);
			return;
		}
		text = raceName;
	}
	NetworkMessage newmsg;
	newmsg.addByte(0xd6);
	newmsg.addString(text);
	newmsg.add<uint16_t>(race.size());
	std::map<uint16_t, uint32_t> creaturesKilled = g_iobestiary().getBestiaryKillCountByMonsterIDs(player, race);

	for (const auto &it_ : race) {
		uint16_t raceid_ = it_.first;
		newmsg.add<uint16_t>(raceid_);

		uint8_t progress = 0;
		uint8_t occurrence = 0;
		for (const auto &_it : creaturesKilled) {
			if (_it.first == raceid_) {
				const auto tmpType = g_monsters().getMonsterType(it_.second);
				if (!tmpType) {
					return;
				}
				progress = g_iobestiary().getKillStatus(tmpType, _it.second);
				occurrence = tmpType->info.bestiaryOccurrence;
			}
		}

		if (progress > 0) {
			newmsg.addByte(progress);
			newmsg.addByte(occurrence);
		} else {
			newmsg.addByte(0);
		}

		newmsg.add<uint16_t>(0); // Creature Animous Bonus
	}

	newmsg.add<uint16_t>(0); // Animus Mastery Points

	writeToOutputBuffer(newmsg);
}

void ProtocolGame::parseBugReport(NetworkMessage &msg) {
	uint8_t category = msg.getByte();
	std::string message = msg.getString();

	Position position;
	if (category == BUG_CATEGORY_MAP) {
		position = msg.getPosition();
	}

	g_game().playerReportBug(player->getID(), message, position, category);
}

void ProtocolGame::parseGreet(NetworkMessage &msg) {
	auto npcId = msg.get<uint32_t>();
	g_game().playerNpcGreet(player->getID(), npcId);
}

void ProtocolGame::parseOfferDescription(NetworkMessage &msg) {
	auto offerId = msg.get<uint32_t>();
	g_logger().debug("[{}] offer id: {}", __FUNCTION__, offerId);
}

void ProtocolGame::parsePreyAction(NetworkMessage &msg) {
	int8_t index = -1;
	uint8_t slot = msg.getByte();
	uint8_t action = msg.getByte();
	uint8_t option = 0;
	uint16_t raceId = 0;
	if (action == static_cast<uint8_t>(PreyAction_MonsterSelection)) {
		index = msg.getByte();
	} else if (action == static_cast<uint8_t>(PreyAction_Option)) {
		option = msg.getByte();
	} else if (action == static_cast<uint8_t>(PreyAction_ListAll_Selection)) {
		raceId = msg.get<uint16_t>();
	}

	if (!g_configManager().getBoolean(PREY_ENABLED)) {
		return;
	}

	g_game().playerPreyAction(player->getID(), slot, action, option, index, raceId);
}

void ProtocolGame::parseSendResourceBalance() {
	auto [sliverCount, coreCount] = player->getForgeSliversAndCores();

	sendResourcesBalance(
		player->getMoney(),
		player->getBankBalance(),
		player->getPreyCards(),
		player->getTaskHuntingPoints(),
		player->getForgeDusts(),
		sliverCount,
		coreCount
	);
}

void ProtocolGame::parseInviteToParty(NetworkMessage &msg) {
	auto targetId = msg.get<uint32_t>();
	g_game().playerInviteToParty(player->getID(), targetId);
}

void ProtocolGame::parseJoinParty(NetworkMessage &msg) {
	auto targetId = msg.get<uint32_t>();
	g_game().playerJoinParty(player->getID(), targetId);
}

void ProtocolGame::parseRevokePartyInvite(NetworkMessage &msg) {
	auto targetId = msg.get<uint32_t>();
	g_game().playerRevokePartyInvitation(player->getID(), targetId);
}

void ProtocolGame::parsePassPartyLeadership(NetworkMessage &msg) {
	auto targetId = msg.get<uint32_t>();
	g_game().playerPassPartyLeadership(player->getID(), targetId);
}

void ProtocolGame::parseEnableSharedPartyExperience(NetworkMessage &msg) {
	bool sharedExpActive = msg.getByte() == 1;
	g_game().playerEnableSharedPartyExperience(player->getID(), sharedExpActive);
}

void ProtocolGame::parseQuestLine(NetworkMessage &msg) {
	auto questId = msg.get<uint16_t>();
	g_game().playerShowQuestLine(player->getID(), questId);
}

void ProtocolGame::parseMarketLeave() {
	g_game().playerLeaveMarket(player->getID());
}

void ProtocolGame::parseMarketBrowse(NetworkMessage &msg) {
	uint16_t browseId = oldProtocol ? msg.get<uint16_t>() : static_cast<uint16_t>(msg.getByte());

	if ((oldProtocol && browseId == MARKETREQUEST_OWN_OFFERS_OLD) || (!oldProtocol && browseId == MARKETREQUEST_OWN_OFFERS)) {
		g_game().playerBrowseMarketOwnOffers(player->getID());
	} else if ((oldProtocol && browseId == MARKETREQUEST_OWN_HISTORY_OLD) || (!oldProtocol && browseId == MARKETREQUEST_OWN_HISTORY)) {
		g_game().playerBrowseMarketOwnHistory(player->getID());
	} else if (!oldProtocol) {
		auto itemId = msg.get<uint16_t>();
		auto tier = msg.get<uint8_t>();
		player->sendMarketEnter(player->getLastDepotId());
		g_game().playerBrowseMarket(player->getID(), itemId, tier);
	} else {
		g_game().playerBrowseMarket(player->getID(), browseId, 0);
	}
}

void ProtocolGame::parseMarketCreateOffer(NetworkMessage &msg) {
	uint8_t type = msg.getByte();
	auto itemId = msg.get<uint16_t>();
	uint8_t itemTier = 0;
	if (!oldProtocol && Item::items[itemId].upgradeClassification > 0) {
		itemTier = msg.getByte();
	}

	auto amount = msg.get<uint16_t>();
	uint64_t price = oldProtocol ? static_cast<uint64_t>(msg.get<uint32_t>()) : msg.get<uint64_t>();
	bool anonymous = (msg.getByte() != 0);
	if (amount > 0 && price > 0) {
		g_game().playerCreateMarketOffer(player->getID(), type, itemId, amount, price, itemTier, anonymous);
	}
}

void ProtocolGame::parseMarketCancelOffer(NetworkMessage &msg) {
	auto timestamp = msg.get<uint32_t>();
	auto counter = msg.get<uint16_t>();
	if (counter > 0) {
		g_game().playerCancelMarketOffer(player->getID(), timestamp, counter);
	}

	updateCoinBalance();
}

void ProtocolGame::parseMarketAcceptOffer(NetworkMessage &msg) {
	auto timestamp = msg.get<uint32_t>();
	auto counter = msg.get<uint16_t>();
	auto amount = msg.get<uint16_t>();
	if (amount > 0 && counter > 0) {
		g_game().playerAcceptMarketOffer(player->getID(), timestamp, counter, amount);
	}

	updateCoinBalance();
}

void ProtocolGame::parseModalWindowAnswer(NetworkMessage &msg) {
	auto id = msg.get<uint32_t>();
	uint8_t button = msg.getByte();
	uint8_t choice = msg.getByte();
	g_game().playerAnswerModalWindow(player->getID(), id, button, choice);
}

void ProtocolGame::parseRewardChestCollect(NetworkMessage &msg) {
	const auto position = msg.getPosition();
	auto itemId = msg.get<uint16_t>();
	auto stackPosition = msg.getByte();

	// Block collect reward
	auto useCollect = g_configManager().getBoolean(REWARD_CHEST_COLLECT_ENABLED);
	if (!useCollect) {
		return;
	}

	auto maxCollectItems = g_configManager().getNumber(REWARD_CHEST_MAX_COLLECT_ITEMS);
	g_game().playerRewardChestCollect(player->getID(), position, itemId, stackPosition, maxCollectItems);
}

void ProtocolGame::parseBrowseField(NetworkMessage &msg) {
	const Position &pos = msg.getPosition();
	g_game().playerBrowseField(player->getID(), pos);
}

void ProtocolGame::parseSeekInContainer(NetworkMessage &msg) {
	uint8_t containerId = msg.getByte();
	auto index = msg.get<uint16_t>();
	auto primaryType = msg.getByte();
	g_game().playerSeekInContainer(player->getID(), containerId, index, primaryType);
}

// Send methods
void ProtocolGame::sendOpenPrivateChannel(const std::string &receiver) {
	NetworkMessage msg;
	msg.addByte(0xAD);
	msg.addString(receiver);
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendExperienceTracker(int64_t rawExp, int64_t finalExp) {
	if (!player || oldProtocol) {
		return;
	}

	NetworkMessage msg;
	msg.addByte(0xAF);
	msg.add<int64_t>(rawExp);
	msg.add<int64_t>(finalExp);
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendChannelEvent(uint16_t channelId, const std::string &playerName, ChannelEvent_t channelEvent) {
	NetworkMessage msg;
	msg.addByte(0xF3);
	msg.add<uint16_t>(channelId);
	msg.addString(playerName);
	msg.addByte(channelEvent);
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendCreatureOutfit(const std::shared_ptr<Creature> &creature, const Outfit_t &outfit) {
	if (!canSee(creature)) {
		return;
	}

	Outfit_t newOutfit = outfit;
	if (player->isWearingSupportOutfit()) {
		player->setCurrentMount(0);
		newOutfit.lookMount = 0;
	}

	NetworkMessage msg;
	msg.addByte(0x8E);
	msg.add<uint32_t>(creature->getID());
	AddOutfit(msg, newOutfit);

	if (!oldProtocol && newOutfit.lookMount != 0) {
		msg.addByte(newOutfit.lookMountHead);
		msg.addByte(newOutfit.lookMountBody);
		msg.addByte(newOutfit.lookMountLegs);
		msg.addByte(newOutfit.lookMountFeet);
	}
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendCreatureLight(const std::shared_ptr<Creature> &creature) {
	if (!canSee(creature)) {
		return;
	}

	NetworkMessage msg;
	AddCreatureLight(msg, creature);
	writeToOutputBuffer(msg);
}

void ProtocolGame::addCreatureIcon(NetworkMessage &msg, const std::shared_ptr<Creature> &creature) {
	if (!creature || !player || oldProtocol) {
		return;
	}

	const auto icons = creature->getIcons();
	// client only supports 3 icons, otherwise it will crash
	const auto count = icons.size() > 3 ? 3 : icons.size();
	msg.addByte(count);
	for (uint8_t i = 0; i < count; ++i) {
		const auto icon = icons[i];
		msg.addByte(icon.serialize());
		msg.addByte(static_cast<uint8_t>(icon.category));
		msg.add<uint16_t>(icon.count);
	}
}

void ProtocolGame::sendCreatureIcon(const std::shared_ptr<Creature> &creature) {
	if (!creature || !player || oldProtocol) {
		return;
	}

	NetworkMessage msg;
	msg.addByte(0x8B);
	msg.add<uint32_t>(creature->getID());
	// Type 14 for this
	msg.addByte(14);
	addCreatureIcon(msg, creature);
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendWorldLight(const LightInfo &lightInfo) {
	NetworkMessage msg;
	AddWorldLight(msg, lightInfo);
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendTibiaTime(int32_t time) {
	if (!player || oldProtocol) {
		return;
	}

	NetworkMessage msg;
	msg.addByte(0xEF);
	msg.addByte(time / 60);
	msg.addByte(time % 60);
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendCreatureWalkthrough(const std::shared_ptr<Creature> &creature, bool walkthrough) {
	if (!canSee(creature)) {
		return;
	}

	NetworkMessage msg;
	msg.addByte(0x92);
	msg.add<uint32_t>(creature->getID());
	msg.addByte(walkthrough ? 0x00 : 0x01);
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendCreatureShield(const std::shared_ptr<Creature> &creature) {
	if (!canSee(creature)) {
		return;
	}

	NetworkMessage msg;
	msg.addByte(0x91);
	msg.add<uint32_t>(creature->getID());
	msg.addByte(player->getPartyShield(creature->getPlayer()));
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendCreatureEmblem(const std::shared_ptr<Creature> &creature) {
	if (!creature || !canSee(creature) || oldProtocol) {
		return;
	}

	auto tile = creature->getTile();
	if (!tile) {
		return;
	}

	// Remove creature from client and re-add to update
	Position pos = creature->getPosition();
	int32_t stackpos = tile->getClientIndexOfCreature(player, creature);
	sendRemoveTileThing(pos, stackpos);
	NetworkMessage msg;
	msg.addByte(0x6A);
	msg.addPosition(pos);
	msg.addByte(static_cast<uint8_t>(stackpos));
	AddCreature(msg, creature, false, creature->getID());
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendCreatureSkull(const std::shared_ptr<Creature> &creature) {
	if (g_game().getWorldType() != WORLD_TYPE_PVP) {
		return;
	}

	if (!canSee(creature)) {
		return;
	}

	NetworkMessage msg;
	msg.addByte(0x90);
	msg.add<uint32_t>(creature->getID());
	msg.addByte(player->getSkullClient(creature));
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendCreatureType(const std::shared_ptr<Creature> &creature, uint8_t creatureType) {
	NetworkMessage msg;
	msg.addByte(0x95);
	msg.add<uint32_t>(creature->getID());
	if (creatureType == CREATURETYPE_SUMMON_OTHERS) {
		creatureType = CREATURETYPE_SUMMON_PLAYER;
	}
	msg.addByte(creatureType); // type or any byte idk
	if (!oldProtocol && creatureType == CREATURETYPE_SUMMON_PLAYER) {
		std::shared_ptr<Creature> master = creature->getMaster();
		if (master) {
			msg.add<uint32_t>(master->getID());
		} else {
			msg.add<uint32_t>(0);
		}
	}

	writeToOutputBuffer(msg);
}

void ProtocolGame::sendCreatureSquare(const std::shared_ptr<Creature> &creature, SquareColor_t color) {
	if (!canSee(creature)) {
		return;
	}

	NetworkMessage msg;
	msg.addByte(0x93);
	msg.add<uint32_t>(creature->getID());
	msg.addByte(0x01);
	msg.addByte(color);
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendTutorial(uint8_t tutorialId) {
	NetworkMessage msg;
	msg.addByte(0xDC);
	msg.addByte(tutorialId);
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendAddMarker(const Position &pos, uint8_t markType, const std::string &desc) {
	NetworkMessage msg;
	msg.addByte(0xDD);

	if (!oldProtocol) {
		msg.addByte(enumToValue(CyclopediaMapData_t::MinimapMarker));
	}

	msg.addPosition(pos);
	msg.addByte(markType);
	msg.addString(desc);
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendCyclopediaCharacterNoData(CyclopediaCharacterInfoType_t characterInfoType, uint8_t errorCode) {
	if (!player || oldProtocol) {
		return;
	}

	NetworkMessage msg;
	msg.addByte(0xDA);
	msg.addByte(static_cast<uint8_t>(characterInfoType));
	msg.addByte(errorCode);
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendCyclopediaCharacterBaseInformation() {
	if (!player || oldProtocol) {
		return;
	}

	NetworkMessage msg;
	msg.addByte(0xDA);
	msg.addByte(CYCLOPEDIA_CHARACTERINFO_BASEINFORMATION);
	msg.addByte(0x00);
	msg.addString(player->getName());
	msg.addString(player->getVocation()->getVocName());
	msg.add<uint16_t>(player->getLevel());
	AddOutfit(msg, player->getDefaultOutfit(), false);

	msg.addByte(0x01); // Store summary & Character titles
	msg.addString(player->title()->getCurrentTitleName()); // character title
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendCyclopediaCharacterGeneralStats() {
	if (!player || oldProtocol) {
		return;
	}

	NetworkMessage msg;
	msg.addByte(0xDA);
	msg.addByte(CYCLOPEDIA_CHARACTERINFO_GENERALSTATS);
	// Send no error
	// 1: No data available at the moment.
	// 2: You are not allowed to see this character's data.
	// 3: You are not allowed to inspect this character.
	msg.addByte(0x00); // 0x00 Here means 'no error'

	msg.add<uint64_t>(player->getExperience());
	msg.add<uint16_t>(player->getLevel());
	msg.addByte(player->getLevelPercent());
	msg.add<uint16_t>(player->getBaseXpGain()); // BaseXPGainRate
	msg.add<uint16_t>(player->getGrindingXpBoost()); // LowLevelBonus
	msg.add<uint16_t>(player->getXpBoostPercent()); // XPBoost
	msg.add<uint16_t>(player->getStaminaXpBoost()); // StaminaMultiplier(100=x1.0)
	msg.add<uint16_t>(player->getXpBoostTime()); // xpBoostRemainingTime
	msg.addByte(player->getXpBoostTime() > 0 ? 0x00 : 0x01); // canBuyXpBoost
	msg.add<uint32_t>(std::min<int32_t>(player->getHealth(), std::numeric_limits<uint16_t>::max()));
	msg.add<uint32_t>(std::min<int32_t>(player->getMaxHealth(), std::numeric_limits<uint16_t>::max()));
	msg.add<uint32_t>(std::min<int32_t>(player->getMana(), std::numeric_limits<uint16_t>::max()));
	msg.add<uint32_t>(std::min<int32_t>(player->getMaxMana(), std::numeric_limits<uint16_t>::max()));
	msg.addByte(player->getSoul());
	msg.add<uint16_t>(player->getStaminaMinutes());

	std::shared_ptr<Condition> condition = player->getCondition(CONDITION_REGENERATION, CONDITIONID_DEFAULT);
	msg.add<uint16_t>(condition ? condition->getTicks() / 1000 : 0x00);
	msg.add<uint16_t>(player->getOfflineTrainingTime() / 60 / 1000);
	msg.add<uint16_t>(player->getSpeed());
	msg.add<uint16_t>(player->getBaseSpeed());
	msg.add<uint32_t>(player->getCapacity());
	msg.add<uint32_t>(player->getBaseCapacity());
	msg.add<uint32_t>(player->hasFlag(PlayerFlags_t::HasInfiniteCapacity) ? 1000000 : player->getFreeCapacity());
	msg.addByte(8);
	msg.addByte(1);
	msg.add<uint16_t>(player->getMagicLevel());
	msg.add<uint16_t>(player->getBaseMagicLevel());
	msg.add<uint16_t>(player->getLoyaltyMagicLevel());
	msg.add<uint16_t>(player->getMagicLevelPercent() * 100);

	for (uint8_t i = SKILL_FIRST; i < SKILL_CRITICAL_HIT_CHANCE; ++i) {
		static const uint8_t HardcodedSkillIds[] = { 11, 9, 8, 10, 7, 6, 13 };
		const auto skill = static_cast<skills_t>(i);
		msg.addByte(HardcodedSkillIds[i]);
		msg.add<uint16_t>(std::min<int32_t>(player->getSkillLevel(skill), std::numeric_limits<uint16_t>::max()));
		msg.add<uint16_t>(player->getBaseSkill(skill));
		msg.add<uint16_t>(player->getLoyaltySkill(skill));
		msg.add<uint16_t>(player->getSkillPercent(skill) * 100);
	}

	auto bufferPosition = msg.getBufferPosition();
	msg.skipBytes(1);
	uint8_t total = 0;
	for (size_t i = 0; i < COMBAT_COUNT; i++) {
		auto specializedMagicLevel = player->getSpecializedMagicLevel(indexToCombatType(i));
		if (specializedMagicLevel > 0) {
			++total;
			msg.addByte(getCipbiaElement(indexToCombatType(i)));
			msg.add<uint16_t>(specializedMagicLevel);
		}
	}
	msg.setBufferPosition(bufferPosition);
	msg.addByte(total);
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendCyclopediaCharacterCombatStats() {
	if (!player || oldProtocol) {
		return;
	}

	NetworkMessage msg;
	msg.addByte(0xDA);
	msg.addByte(CYCLOPEDIA_CHARACTERINFO_COMBATSTATS);
	msg.addByte(0x00);
	for (uint8_t i = SKILL_CRITICAL_HIT_CHANCE; i <= SKILL_LAST; ++i) {
		if (i == SKILL_LIFE_LEECH_CHANCE || i == SKILL_MANA_LEECH_CHANCE) {
			continue;
		}
		auto skill = static_cast<skills_t>(i);
		msg.add<uint16_t>(std::min<int32_t>(player->getSkillLevel(skill), std::numeric_limits<uint16_t>::max()));
		msg.add<uint16_t>(0);
	}

	// Version 12.81 new skill (Fatal, Dodge and Momentum)
	sendForgeSkillStats(msg);

	// Cleave (12.70)
	msg.add<uint16_t>(static_cast<uint16_t>(player->getCleavePercent()));
	// Magic shield capacity (12.70)
	msg.add<uint16_t>(static_cast<uint16_t>(player->getMagicShieldCapacityFlat())); // Direct bonus
	msg.add<uint16_t>(static_cast<uint16_t>(player->getMagicShieldCapacityPercent())); // Percentage bonus

	// Perfect shot range (12.70)
	for (uint8_t range = 1; range <= 5; range++) {
		msg.add<uint16_t>(static_cast<uint16_t>(player->getPerfectShotDamage(range)));
	}

	// Damage reflection (12.70)
	msg.add<uint16_t>(static_cast<uint16_t>(player->getReflectFlat(COMBAT_PHYSICALDAMAGE)));

	uint8_t haveBlesses = 0;
	for (auto bless : magic_enum::enum_values<Blessings>()) {
		if (player->hasBlessing(enumToValue(bless))) {
			++haveBlesses;
		}
	}

	msg.addByte(haveBlesses);
	msg.addByte(magic_enum::enum_count<Blessings>());

	std::shared_ptr<Item> weapon = player->getWeapon();
	if (weapon) {
		const ItemType &it = Item::items[weapon->getID()];
		if (it.weaponType == WEAPON_WAND) {
			msg.add<uint16_t>(it.maxHitChance);
			msg.addByte(getCipbiaElement(it.combatType));
			msg.addByte(0);
			msg.addByte(0);
		} else if (it.weaponType == WEAPON_DISTANCE || it.weaponType == WEAPON_AMMO || it.weaponType == WEAPON_MISSILE) {
			int32_t attackValue = weapon->getAttack();
			if (it.weaponType == WEAPON_AMMO) {
				std::shared_ptr<Item> weaponItem = player->getWeapon(true);
				if (weaponItem) {
					attackValue += weaponItem->getAttack();
				}
			}

			int32_t attackSkill = player->getSkillLevel(SKILL_DISTANCE);
			float attackFactor = player->getAttackFactor();
			int32_t maxDamage = static_cast<int32_t>(Weapons::getMaxWeaponDamage(player->getLevel(), attackSkill, attackValue, attackFactor, true) * player->getVocation()->distDamageMultiplier);
			if (it.abilities && it.abilities->elementType != COMBAT_NONE) {
				maxDamage += static_cast<int32_t>(Weapons::getMaxWeaponDamage(player->getLevel(), attackSkill, attackValue - weapon->getAttack() + it.abilities->elementDamage, attackFactor, true) * player->getVocation()->distDamageMultiplier);
			}
			msg.add<uint16_t>(maxDamage >> 1);
			msg.addByte(CIPBIA_ELEMENTAL_PHYSICAL);
			if (it.abilities && it.abilities->elementType != COMBAT_NONE) {
				if (attackValue) {
					msg.addByte(static_cast<uint32_t>(it.abilities->elementDamage) * 100 / attackValue);
				} else {
					msg.addByte(0);
				}
				msg.addByte(getCipbiaElement(it.abilities->elementType));
			} else {
				handleImbuementDamage(msg, player);
			}
		} else {
			int32_t attackValue = std::max<int32_t>(0, weapon->getAttack());
			int32_t attackSkill = player->getWeaponSkill(weapon);
			float attackFactor = player->getAttackFactor();
			int32_t maxDamage = static_cast<int32_t>(Weapons::getMaxWeaponDamage(player->getLevel(), attackSkill, attackValue, attackFactor, true) * player->getVocation()->meleeDamageMultiplier);
			if (it.abilities && it.abilities->elementType != COMBAT_NONE) {
				maxDamage += static_cast<int32_t>(Weapons::getMaxWeaponDamage(player->getLevel(), attackSkill, it.abilities->elementDamage, attackFactor, true) * player->getVocation()->meleeDamageMultiplier);
			}
			msg.add<uint16_t>(maxDamage >> 1);
			msg.addByte(CIPBIA_ELEMENTAL_PHYSICAL);
			if (it.abilities && it.abilities->elementType != COMBAT_NONE) {
				if (attackValue) {
					msg.addByte(static_cast<uint32_t>(it.abilities->elementDamage) * 100 / attackValue);
				} else {
					msg.addByte(0);
				}
				msg.addByte(getCipbiaElement(it.abilities->elementType));
			} else {
				handleImbuementDamage(msg, player);
			}
		}
	} else {
		float attackFactor = player->getAttackFactor();
		int32_t attackSkill = player->getSkillLevel(SKILL_FIST);
		int32_t attackValue = 7;

		int32_t maxDamage = Weapons::getMaxWeaponDamage(player->getLevel(), attackSkill, attackValue, attackFactor, true);
		msg.add<uint16_t>(maxDamage >> 1);
		msg.addByte(CIPBIA_ELEMENTAL_PHYSICAL);
		msg.addByte(0);
		msg.addByte(0);
	}

	msg.add<uint16_t>(player->getArmor());
	msg.add<uint16_t>(player->getDefense());
	// Wheel of destiny mitigation
	if (g_configManager().getBoolean(TOGGLE_WHEELSYSTEM)) {
		msg.addDouble(player->getMitigation());
	} else {
		msg.addDouble(0);
	}

	// Store the "combats" to increase in absorb values function and send to client later
	uint8_t combats = 0;
	auto startCombats = msg.getBufferPosition();
	msg.skipBytes(1);

	// Calculate and parse the combat absorbs values
	calculateAbsorbValues(player, msg, combats);

	// Now set the buffer position skiped and send the total combats count
	auto endCombats = msg.getBufferPosition();
	msg.setBufferPosition(startCombats);
	msg.addByte(combats);
	msg.setBufferPosition(endCombats);

	// Concoctions potions (12.70)
	auto startConcoctions = msg.getBufferPosition();
	msg.skipBytes(1);
	auto activeConcoctions = player->getActiveConcoctions();
	uint8_t concoctions = 0;
	for (const auto &concoction : activeConcoctions) {
		if (concoction.second == 0) {
			continue;
		}
		msg.add<uint16_t>(concoction.first);
		msg.add<uint16_t>(concoction.second);
		++concoctions;
	}

	msg.setBufferPosition(startConcoctions);
	msg.addByte(concoctions);

	writeToOutputBuffer(msg);
}

void ProtocolGame::sendCyclopediaCharacterRecentDeaths(uint16_t page, uint16_t pages, const std::vector<RecentDeathEntry> &entries) {
	if (!player || oldProtocol) {
		return;
	}

	NetworkMessage msg;
	msg.addByte(0xDA);
	msg.addByte(CYCLOPEDIA_CHARACTERINFO_RECENTDEATHS);
	msg.addByte(0x00); // 0x00 Here means 'no error'
	msg.add<uint16_t>(page);
	msg.add<uint16_t>(pages);
	msg.add<uint16_t>(entries.size());
	for (const RecentDeathEntry &entry : entries) {
		msg.add<uint32_t>(entry.timestamp);
		msg.addString(entry.cause);
	}

	writeToOutputBuffer(msg);
}

void ProtocolGame::sendCyclopediaCharacterRecentPvPKills(uint16_t page, uint16_t pages, const std::vector<RecentPvPKillEntry> &entries) {
	if (!player || oldProtocol) {
		return;
	}

	NetworkMessage msg;
	msg.addByte(0xDA);
	msg.addByte(CYCLOPEDIA_CHARACTERINFO_RECENTPVPKILLS);
	msg.addByte(0x00); // 0x00 Here means 'no error'
	msg.add<uint16_t>(page);
	msg.add<uint16_t>(pages);
	msg.add<uint16_t>(entries.size());
	for (const RecentPvPKillEntry &entry : entries) {
		msg.add<uint32_t>(entry.timestamp);
		msg.addString(entry.description);
		msg.addByte(entry.status);
	}

	writeToOutputBuffer(msg);
}

void ProtocolGame::sendCyclopediaCharacterAchievements(uint16_t secretsUnlocked, const std::vector<std::pair<Achievement, uint32_t>> &achievementsUnlocked) {
	if (!player || oldProtocol) {
		return;
	}

	NetworkMessage msg;
	msg.addByte(0xDA);
	msg.addByte(CYCLOPEDIA_CHARACTERINFO_ACHIEVEMENTS);
	msg.addByte(0x00); // 0x00 Here means 'no error'
	msg.add<uint16_t>(player->achiev()->getPoints());
	msg.add<uint16_t>(secretsUnlocked);
	msg.add<uint16_t>(static_cast<uint16_t>(achievementsUnlocked.size()));
	for (const auto &[achievement, addedTimestamp] : achievementsUnlocked) {
		msg.add<uint16_t>(achievement.id);
		msg.add<uint32_t>(addedTimestamp);
		if (achievement.secret) {
			msg.addByte(0x01);
			msg.addString(achievement.name);
			msg.addString(achievement.description);
			msg.addByte(achievement.grade);
		} else {
			msg.addByte(0x00);
		}
	}
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendCyclopediaCharacterItemSummary(const ItemsTierCountList &inventoryItems, const ItemsTierCountList &storeInboxItems, const StashItemList &supplyStashItems, const ItemsTierCountList &depotBoxItems, const ItemsTierCountList &inboxItems) {
	if (!player || oldProtocol) {
		return;
	}

	NetworkMessage msg;
	msg.addByte(0xDA);
	msg.addByte(CYCLOPEDIA_CHARACTERINFO_ITEMSUMMARY);
	msg.addByte(0x00); // 0x00 Here means 'no error'

	uint16_t inventoryItemsCount = 0;
	const auto startInventory = msg.getBufferPosition();
	msg.skipBytes(2);

	for (const auto &inventoryItems_it : inventoryItems) {
		for (const auto &[itemTier, itemCount] : inventoryItems_it.second) {
			const ItemType &it = Item::items[inventoryItems_it.first];
			msg.add<uint16_t>(inventoryItems_it.first); // Item ID
			if (it.upgradeClassification > 0) {
				msg.addByte(itemTier);
			}
			msg.add<uint32_t>(itemCount);

			++inventoryItemsCount;
		}
	}

	const auto endInventory = msg.getBufferPosition();

	msg.setBufferPosition(startInventory);
	msg.add<uint16_t>(inventoryItemsCount);

	msg.setBufferPosition(endInventory);

	uint16_t storeInboxItemsCount = 0;
	const auto startStoreInbox = msg.getBufferPosition();
	msg.skipBytes(2);

	for (const auto &storeInboxItems_it : storeInboxItems) {
		for (const auto &[itemTier, itemCount] : storeInboxItems_it.second) {
			const ItemType &it = Item::items[storeInboxItems_it.first];
			msg.add<uint16_t>(storeInboxItems_it.first); // Item ID
			if (it.upgradeClassification > 0) {
				msg.addByte(itemTier);
			}
			msg.add<uint32_t>(itemCount);

			++storeInboxItemsCount;
		}
	}

	const auto endStoreInbox = msg.getBufferPosition();

	msg.setBufferPosition(startStoreInbox);
	msg.add<uint16_t>(storeInboxItemsCount);

	msg.setBufferPosition(endStoreInbox);

	msg.add<uint16_t>(supplyStashItems.size());

	for (const auto &[itemId, itemCount] : supplyStashItems) {
		msg.add<uint16_t>(itemId);
		msg.add<uint32_t>(itemCount);
	}

	uint16_t depotBoxItemsCount = 0;
	const auto startDepotBox = msg.getBufferPosition();
	msg.skipBytes(2);

	for (const auto &depotBoxItems_it : depotBoxItems) {
		for (const auto &[itemTier, itemCount] : depotBoxItems_it.second) {
			const ItemType &it = Item::items[depotBoxItems_it.first];
			msg.add<uint16_t>(depotBoxItems_it.first); // Item ID
			if (it.upgradeClassification > 0) {
				msg.addByte(itemTier);
			}
			msg.add<uint32_t>(itemCount);

			++depotBoxItemsCount;
		}
	}

	const auto endDepotBox = msg.getBufferPosition();

	msg.setBufferPosition(startDepotBox);
	msg.add<uint16_t>(depotBoxItemsCount);

	msg.setBufferPosition(endDepotBox);

	uint16_t inboxItemsCount = 0;
	const auto startInbox = msg.getBufferPosition();
	msg.skipBytes(2);

	for (const auto &inboxItems_it : inboxItems) {
		for (const auto &[itemTier, itemCount] : inboxItems_it.second) {
			const ItemType &it = Item::items[inboxItems_it.first];
			msg.add<uint16_t>(inboxItems_it.first); // Item ID
			if (it.upgradeClassification > 0) {
				msg.addByte(itemTier);
			}
			msg.add<uint32_t>(itemCount);

			++inboxItemsCount;
		}
	}

	msg.setBufferPosition(startInbox);
	msg.add<uint16_t>(inboxItemsCount);

	writeToOutputBuffer(msg);
}

void ProtocolGame::sendCyclopediaCharacterOutfitsMounts() {
	if (!player || oldProtocol) {
		return;
	}

	NetworkMessage msg;
	msg.addByte(0xDA);
	msg.addByte(CYCLOPEDIA_CHARACTERINFO_OUTFITSMOUNTS);
	msg.addByte(0x00);
	Outfit_t currentOutfit = player->getDefaultOutfit();

	uint16_t outfitSize = 0;
	auto startOutfits = msg.getBufferPosition();
	msg.skipBytes(2);

	const auto outfits = Outfits::getInstance().getOutfits(player->getSex());
	for (const auto &outfit : outfits) {
		uint8_t addons;
		if (!player->getOutfitAddons(outfit, addons)) {
			continue;
		}
		const std::string from = outfit->from;
		++outfitSize;

		msg.add<uint16_t>(outfit->lookType);
		msg.addString(outfit->name);
		msg.addByte(addons);
		if (from == "store") {
			msg.addByte(CYCLOPEDIA_CHARACTERINFO_OUTFITTYPE_STORE);
		} else if (from == "quest") {
			msg.addByte(CYCLOPEDIA_CHARACTERINFO_OUTFITTYPE_QUEST);
		} else {
			msg.addByte(CYCLOPEDIA_CHARACTERINFO_OUTFITTYPE_NONE);
		}
		if (outfit->lookType == currentOutfit.lookType) {
			msg.add<uint32_t>(1000);
		} else {
			msg.add<uint32_t>(0);
		}
	}
	if (outfitSize > 0) {
		msg.addByte(currentOutfit.lookHead);
		msg.addByte(currentOutfit.lookBody);
		msg.addByte(currentOutfit.lookLegs);
		msg.addByte(currentOutfit.lookFeet);
	}

	uint16_t mountSize = 0;
	auto startMounts = msg.getBufferPosition();
	msg.skipBytes(2);
	for (const auto &mount : g_game().mounts->getMounts()) {
		const std::string type = mount->type;
		if (player->hasMount(mount)) {
			++mountSize;

			msg.add<uint16_t>(mount->clientId);
			msg.addString(mount->name);
			if (type == "store") {
				msg.addByte(CYCLOPEDIA_CHARACTERINFO_OUTFITTYPE_STORE);
			} else if (type == "quest") {
				msg.addByte(CYCLOPEDIA_CHARACTERINFO_OUTFITTYPE_QUEST);
			} else {
				msg.addByte(CYCLOPEDIA_CHARACTERINFO_OUTFITTYPE_NONE);
			}
			msg.add<uint32_t>(1000);
		}
	}
	if (mountSize > 0) {
		msg.addByte(currentOutfit.lookMountHead);
		msg.addByte(currentOutfit.lookMountBody);
		msg.addByte(currentOutfit.lookMountLegs);
		msg.addByte(currentOutfit.lookMountFeet);
	}

	uint16_t familiarsSize = 0;
	auto startFamiliars = msg.getBufferPosition();
	msg.skipBytes(2);
	const auto familiars = Familiars::getInstance().getFamiliars(player->getVocationId());
	for (const auto &familiar : familiars) {
		const std::string type = familiar->type;
		if (!player->getFamiliar(familiar)) {
			continue;
		}
		++familiarsSize;
		msg.add<uint16_t>(familiar->lookType);
		msg.addString(familiar->name);
		if (type == "quest") {
			msg.addByte(CYCLOPEDIA_CHARACTERINFO_OUTFITTYPE_QUEST);
		} else {
			msg.addByte(CYCLOPEDIA_CHARACTERINFO_OUTFITTYPE_NONE);
		}
		msg.add<uint32_t>(0);
	}

	msg.setBufferPosition(startOutfits);
	msg.add<uint16_t>(outfitSize);
	msg.setBufferPosition(startMounts);
	msg.add<uint16_t>(mountSize);
	msg.setBufferPosition(startFamiliars);
	msg.add<uint16_t>(familiarsSize);
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendCyclopediaCharacterStoreSummary() {
	if (!player || oldProtocol) {
		return;
	}

	NetworkMessage msg;
	msg.addByte(0xDA);
	msg.addByte(CYCLOPEDIA_CHARACTERINFO_STORESUMMARY);
	msg.addByte(0x00); // 0x00 Here means 'no error'
	msg.add<uint32_t>(player->getXpBoostTime()); // Remaining Store Xp Boost Time
	auto remaining = player->kv()->get("daily-reward-xp-boost");
	msg.add<uint32_t>(remaining ? static_cast<uint32_t>(remaining->getNumber()) : 0); // Remaining Daily Reward Xp Boost Time

	auto cyclopediaSummary = player->cyclopedia()->getSummary();

	msg.addByte(static_cast<uint8_t>(magic_enum::enum_count<Blessings>()));
	for (auto bless : magic_enum::enum_values<Blessings>()) {
		std::string name = toStartCaseWithSpace(magic_enum::enum_name(bless).data());
		msg.addString(name);
		auto blessValue = enumToValue(bless);
		if (player->hasBlessing(blessValue)) {
			msg.addByte(static_cast<uint16_t>(player->blessings[blessValue - 1]));
		} else {
			msg.addByte(0x00);
		}
	}

	uint8_t preySlotsUnlocked = 0;
	// Prey third slot unlocked
	if (const auto &slotP = player->getPreySlotById(PreySlot_Three);
	    slotP && slotP->state != PreyDataState_Locked) {
		preySlotsUnlocked++;
	}
	// Task hunting third slot unlocked
	if (const auto &slotH = player->getTaskHuntingSlotById(PreySlot_Three);
	    slotH && slotH->state != PreyTaskDataState_Locked) {
		preySlotsUnlocked++;
	}
	msg.addByte(preySlotsUnlocked); // getPreySlotById + getTaskHuntingSlotById

	msg.addByte(cyclopediaSummary.m_preyWildcards); // getPreyCardsObtained
	msg.addByte(cyclopediaSummary.m_instantRewards); // getRewardCollectionObtained
	msg.addByte(player->hasCharmExpansion() ? 0x01 : 0x00);
	msg.addByte(cyclopediaSummary.m_hirelings); // getHirelingsObtained

	std::vector<uint16_t> m_hSkills;
	for (const auto &it : g_game().getHirelingSkills()) {
		if (player->kv()->scoped("hireling-skills")->get(it.second)) {
			m_hSkills.emplace_back(it.first);
			g_logger().debug("skill id: {}, name: {}", it.first, it.second);
		}
	}
	msg.addByte(m_hSkills.size());
	for (const auto &id : m_hSkills) {
		msg.addByte(id - 1000);
	}

	/*std::vector<uint16_t> m_hOutfits;
	for (const auto &it : g_game().getHirelingOutfits()) {
	    if (player->kv()->scoped("hireling-outfits")->get(it.second)) {
	        m_hOutfits.emplace_back(it.first);
	        g_logger().debug("outfit id: {}, name: {}", it.first, it.second);
	    }
	}
	msg.addByte(m_hOutfits.size());
	for (const auto &id : m_hOutfits) {
	    msg.addByte(0x01); // TODO need to get the correct id from hireling outfit
	}*/
	msg.addByte(0x00); // hireling outfit size

	auto houseItems = player->cyclopedia()->getResult(static_cast<uint8_t>(Summary_t::HOUSE_ITEMS));
	msg.add<uint16_t>(houseItems.size());
	for (const auto &hItem_it : houseItems) {
		const ItemType &it = Item::items[hItem_it.first];
		msg.add<uint16_t>(it.id); // Item ID
		msg.addString(it.name);
		msg.addByte(hItem_it.second);
	}

	writeToOutputBuffer(msg);
}

void ProtocolGame::sendCyclopediaCharacterInspection() {
	if (!player || oldProtocol) {
		return;
	}

	NetworkMessage msg;
	msg.addByte(0xDA);
	msg.addByte(CYCLOPEDIA_CHARACTERINFO_INSPECTION);
	msg.addByte(0x00);
	uint8_t inventoryItems = 0;
	auto startInventory = msg.getBufferPosition();
	msg.skipBytes(1);
	for (std::underlying_type<Slots_t>::type slot = CONST_SLOT_FIRST; slot <= CONST_SLOT_LAST; slot++) {
		std::shared_ptr<Item> inventoryItem = player->getInventoryItem(static_cast<Slots_t>(slot));
		if (inventoryItem) {
			++inventoryItems;

			msg.addByte(slot);
			msg.addString(inventoryItem->getName());
			AddItem(msg, inventoryItem);

			uint8_t itemImbuements = 0;
			auto startImbuements = msg.getBufferPosition();
			msg.skipBytes(1);
			for (uint8_t slotid = 0; slotid < inventoryItem->getImbuementSlot(); slotid++) {
				ImbuementInfo imbuementInfo;
				if (!inventoryItem->getImbuementInfo(slotid, &imbuementInfo)) {
					continue;
				}

				msg.add<uint16_t>(imbuementInfo.imbuement->getIconID());
				itemImbuements++;
			}

			auto endImbuements = msg.getBufferPosition();
			msg.setBufferPosition(startImbuements);
			msg.addByte(itemImbuements);
			msg.setBufferPosition(endImbuements);

			auto descriptions = Item::getDescriptions(Item::items[inventoryItem->getID()], inventoryItem);
			msg.addByte(descriptions.size());
			for (const auto &description : descriptions) {
				msg.addString(description.first);
				msg.addString(description.second);
			}
		}
	}
	msg.addString(player->getName());
	AddOutfit(msg, player->getDefaultOutfit(), false);

	// Player overall summary
	uint8_t playerDescriptionSize = 0;
	auto playerDescriptionPosition = msg.getBufferPosition();
	msg.skipBytes(1);

	// Player title
	if (player->title()->getCurrentTitle() != 0) {
		playerDescriptionSize++;
		msg.addString("Character Title");
		msg.addString(player->title()->getCurrentTitleName());
	}

	// Level description
	playerDescriptionSize++;
	msg.addString("Level");
	msg.addString(std::to_string(player->getLevel()));

	// Vocation description
	playerDescriptionSize++;
	msg.addString("Vocation");
	msg.addString(player->getVocation()->getVocName());

	// Loyalty title
	if (!player->getLoyaltyTitle().empty()) {
		playerDescriptionSize++;
		msg.addString("Loyalty Title");
		msg.addString(player->getLoyaltyTitle());
	}

	// Marriage description
	if (const auto spouseId = player->getMarriageSpouse(); spouseId > 0) {
		if (const auto &spouse = g_game().getPlayerByID(spouseId, true); spouse) {
			playerDescriptionSize++;
			msg.addString("Married to");
			msg.addString(spouse->getName());
		}
	}

	// Prey description
	for (uint8_t slotId = PreySlot_First; slotId <= PreySlot_Last; slotId++) {
		if (const auto &slot = player->getPreySlotById(static_cast<PreySlot_t>(slotId));
		    slot && slot->isOccupied()) {
			playerDescriptionSize++;
			std::string activePrey = fmt::format("Active Prey {}", slotId + 1);
			msg.addString(activePrey);

			std::string desc;
			if (auto mtype = g_monsters().getMonsterTypeByRaceId(slot->selectedRaceId)) {
				desc.append(mtype->name);
			} else {
				desc.append("Unknown creature");
			}

			if (slot->bonus == PreyBonus_Damage) {
				desc.append(" (Improved Damage +");
			} else if (slot->bonus == PreyBonus_Defense) {
				desc.append(" (Improved Defense +");
			} else if (slot->bonus == PreyBonus_Experience) {
				desc.append(" (Improved Experience +");
			} else if (slot->bonus == PreyBonus_Loot) {
				desc.append(" (Improved Loot +");
			}
			desc.append(fmt::format("{}%, remaining", slot->bonusPercentage));
			uint8_t hours = slot->bonusTimeLeft / 3600;
			uint8_t minutes = (slot->bonusTimeLeft - (hours * 3600)) / 60;
			desc.append(fmt::format("{}:{}{}h", hours, (minutes < 10 ? "0" : ""), minutes));
			msg.addString(desc);
		}
	}

	// Outfit description
	playerDescriptionSize++;
	msg.addString("Outfit");
	if (const auto outfit = Outfits::getInstance().getOutfitByLookType(player, player->getDefaultOutfit().lookType)) {
		msg.addString(outfit->name);
	} else {
		msg.addString("unknown");
	}

	msg.setBufferPosition(startInventory);
	msg.addByte(inventoryItems);

	msg.setBufferPosition(playerDescriptionPosition);
	msg.addByte(playerDescriptionSize);

	writeToOutputBuffer(msg);
}

void ProtocolGame::sendCyclopediaCharacterBadges() {
	if (!player || oldProtocol) {
		return;
	}

	NetworkMessage msg;
	msg.addByte(0xDA);
	msg.addByte(CYCLOPEDIA_CHARACTERINFO_BADGES);
	msg.addByte(0x00);
	msg.addByte(0x01); // ShowAccountInformation, if 0x01 will show IsOnline, IsPremium, character title, badges

	const auto loggedPlayer = g_game().getPlayerUniqueLogin(player->getName());
	msg.addByte(loggedPlayer ? 0x01 : 0x00); // IsOnline
	msg.addByte(player->isPremium() ? 0x01 : 0x00); // IsPremium (GOD has always 'Premium')
	// Character loyalty title
	msg.addString(player->getLoyaltyTitle());

	uint8_t badgesSize = 0;
	auto badgesSizePosition = msg.getBufferPosition();
	msg.skipBytes(1);
	for (const auto &badge : g_game().getBadges()) {
		if (player->badge()->hasBadge(badge.m_id)) {
			msg.add<uint32_t>(badge.m_id);
			msg.addString(badge.m_name);
			badgesSize++;
		}
	}

	msg.setBufferPosition(badgesSizePosition);
	msg.addByte(badgesSize);

	writeToOutputBuffer(msg);
}

void ProtocolGame::sendCyclopediaCharacterTitles() {
	if (!player || oldProtocol) {
		return;
	}

	auto titles = g_game().getTitles();

	NetworkMessage msg;
	msg.addByte(0xDA);
	msg.addByte(CYCLOPEDIA_CHARACTERINFO_TITLES);
	msg.addByte(0x00); // 0x00 Here means 'no error'
	msg.addByte(player->title()->getCurrentTitle());
	msg.addByte(static_cast<uint8_t>(titles.size()));
	for (const auto &title : titles) {
		msg.addByte(title.m_id);
		auto titleName = player->title()->getNameBySex(player->getSex(), title.m_maleName, title.m_femaleName);
		msg.addString(titleName);
		msg.addString(title.m_description);
		msg.addByte(title.m_permanent ? 0x01 : 0x00);
		auto isUnlocked = player->title()->isTitleUnlocked(title.m_id);
		msg.addByte(isUnlocked ? 0x01 : 0x00);
	}

	writeToOutputBuffer(msg);
}

void ProtocolGame::sendReLoginWindow(uint8_t unfairFightReduction) {
	NetworkMessage msg;
	msg.addByte(0x28);
	msg.addByte(0x00);
	msg.addByte(unfairFightReduction);
	if (!oldProtocol) {
		msg.addByte(0x00); // use death redemption (boolean)
	}
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendStats() {
	NetworkMessage msg;
	AddPlayerStats(msg);
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendBasicData() {
	if (!player) {
		return;
	}

	NetworkMessage msg;
	msg.addByte(0x9F);
	if (player->isPremium() || player->isVip()) {
		msg.addByte(1);
		msg.add<uint32_t>(getTimeNow() + ((player->getPremiumDays() + 1) * 86400));
	} else {
		msg.addByte(0);
		msg.add<uint32_t>(0);
	}
	msg.addByte(player->getVocation()->getClientId());

	// Prey window
	if (player->getVocation()->getId() == 0 && player->getGroup()->id < GROUP_TYPE_GAMEMASTER) {
		msg.addByte(0);
	} else {
		msg.addByte(1); // has reached Main (allow player to open Prey window)
	}

	// Filter only valid ids
	std::list<uint16_t> spellsList = g_spells().getSpellsByVocation(player->getVocationId());
	std::vector<std::shared_ptr<InstantSpell>> validSpells;
	for (uint16_t sid : spellsList) {
		auto spell = g_spells().getInstantSpellById(sid);
		if (spell && spell->getSpellId() > 0) {
			validSpells.emplace_back(spell);
		}
	}

	// Send total size of spells
	msg.add<uint16_t>(validSpells.size());
	// Send each spell valid ids
	for (const auto &spell : validSpells) {
		if (!spell) {
			continue;
		}

		// Only send valid spells to old client
		if (oldProtocol) {
			msg.addByte(spell->getSpellId());
			continue;
		}

		if (spell->isLearnable() && !player->hasLearnedInstantSpell(spell->getName())) {
			msg.add<uint16_t>(0);
		} else if (spell && spell->isLearnable() && player->hasLearnedInstantSpell(spell->getName())) {
			// Ignore spell if not have wheel grade (or send if you have)
			auto grade = player->wheel()->getSpellUpgrade(spell->getName());
			if (static_cast<uint8_t>(grade) == 0) {
				msg.add<uint16_t>(0);
			} else {
				msg.add<uint16_t>(spell->getSpellId());
			}
		} else {
			msg.add<uint16_t>(spell->getSpellId());
		}
	}

	if (!oldProtocol) {
		msg.addByte(player->getVocation()->getMagicShield()); // bool - determine whether magic shield is active or not
	}

	writeToOutputBuffer(msg);
}

void ProtocolGame::sendBlessStatus() {
	if (!player) {
		return;
	}

	NetworkMessage msg;
	// uint8_t maxClientBlessings = (player->operatingSystem == CLIENTOS_NEW_WINDOWS) ? 8 : 6; (compartability for the client 10)
	// Ignore ToF (bless 1)
	uint8_t blessCount = 0;
	uint16_t flag = 0;
	uint16_t pow2 = 2;
	for (int i = 1; i <= 8; i++) {
		if (player->hasBlessing(i)) {
			if (i > 1) {
				blessCount++;
			}

			flag |= pow2;
		}
	}

	msg.addByte(0x9C);
	if (oldProtocol) {
		msg.add<uint16_t>(blessCount >= 5 ? 0x01 : 0x00);
	} else {
		bool glow = player->getVocationId() > VOCATION_NONE && ((g_configManager().getBoolean(INVENTORY_GLOW) && blessCount >= 5) || player->getLevel() < g_configManager().getNumber(ADVENTURERSBLESSING_LEVEL));
		msg.add<uint16_t>(glow ? 1 : 0); // Show up the glowing effect in items if you have all blesses or adventurer's blessing
		msg.addByte((blessCount >= 7) ? 3 : ((blessCount >= 5) ? 2 : 1)); // 1 = Disabled | 2 = normal | 3 = green
	}

	writeToOutputBuffer(msg);
}

void ProtocolGame::sendPremiumTrigger() {
	if (!g_configManager().getBoolean(FREE_PREMIUM) && !g_configManager().getBoolean(VIP_SYSTEM_ENABLED)) {
		NetworkMessage msg;
		msg.addByte(0x9E);
		msg.addByte(16);
		for (uint16_t i = 0; i <= 15; i++) {
			// PREMIUM_TRIGGER_TRAIN_OFFLINE = false, PREMIUM_TRIGGER_XP_BOOST = false, PREMIUM_TRIGGER_MARKET = false, PREMIUM_TRIGGER_VIP_LIST = false, PREMIUM_TRIGGER_DEPOT_SPACE = false, PREMIUM_TRIGGER_INVITE_PRIVCHAT = false
			msg.addByte(0x01);
		}
		writeToOutputBuffer(msg);
	}
}

void ProtocolGame::sendTextMessage(const TextMessage &message) {
	if (message.type == MESSAGE_NONE) {
		g_logger().error("[ProtocolGame::sendTextMessage] - Message type is wrong, missing or invalid for player with name {}, on position {}", player->getName(), player->getPosition().toString());
		player->sendTextMessage(MESSAGE_ADMINISTRATOR, "There was a problem requesting your message, please contact the administrator");
		return;
	}

	MessageClasses internalType = message.type;
	if (oldProtocol && message.type > MESSAGE_LAST_OLDPROTOCOL) {
		switch (internalType) {
			case MESSAGE_REPORT: {
				internalType = MESSAGE_LOOT;
				break;
			}
			case MESSAGE_HOTKEY_PRESSED: {
				internalType = MESSAGE_LOOK;
				break;
			}
			case MESSAGE_TUTORIAL_HINT: {
				internalType = MESSAGE_LOGIN;
				break;
			}
			case MESSAGE_THANK_YOU: {
				internalType = MESSAGE_LOGIN;
				break;
			}
			case MESSAGE_MARKET: {
				internalType = MESSAGE_EVENT_ADVANCE;
				break;
			}
			case MESSAGE_MANA: {
				internalType = MESSAGE_HEALED;
				break;
			}
			case MESSAGE_BEYOND_LAST: {
				internalType = MESSAGE_LOOT;
				break;
			}
			case MESSAGE_ATTENTION: {
				internalType = MESSAGE_EVENT_ADVANCE;
				break;
			}
			case MESSAGE_BOOSTED_CREATURE: {
				internalType = MESSAGE_LOOT;
				break;
			}
			case MESSAGE_OFFLINE_TRAINING: {
				internalType = MESSAGE_LOOT;
				break;
			}
			case MESSAGE_TRANSACTION: {
				internalType = MESSAGE_LOOT;
				break;
			}
			case MESSAGE_POTION: {
				internalType = MESSAGE_FAILURE;
				break;
			}

			default: {
				internalType = MESSAGE_EVENT_ADVANCE;
				break;
			}
		}
	}

	NetworkMessage msg;
	msg.addByte(0xB4);
	msg.addByte(internalType);
	switch (internalType) {
		case MESSAGE_DAMAGE_DEALT:
		case MESSAGE_DAMAGE_RECEIVED:
		case MESSAGE_DAMAGE_OTHERS: {
			msg.addPosition(message.position);
			msg.add<uint32_t>(message.primary.value);
			msg.addByte(message.primary.color);
			msg.add<uint32_t>(message.secondary.value);
			msg.addByte(message.secondary.color);
			break;
		}
		case MESSAGE_HEALED:
		case MESSAGE_HEALED_OTHERS: {
			msg.addPosition(message.position);
			msg.add<uint32_t>(message.primary.value);
			msg.addByte(message.primary.color);
			break;
		}
		case MESSAGE_EXPERIENCE:
		case MESSAGE_EXPERIENCE_OTHERS: {
			msg.addPosition(message.position);
			if (!oldProtocol) {
				msg.add<uint64_t>(message.primary.value);
			} else {
				msg.add<uint32_t>(message.primary.value);
			}
			msg.addByte(message.primary.color);
			break;
		}
		case MESSAGE_GUILD:
		case MESSAGE_PARTY_MANAGEMENT:
		case MESSAGE_PARTY:
			msg.add<uint16_t>(message.channelId);
			break;
		default:
			break;
	}
	msg.addString(message.text);
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendClosePrivate(uint16_t channelId) {
	NetworkMessage msg;
	msg.addByte(0xB3);
	msg.add<uint16_t>(channelId);
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendCreatePrivateChannel(uint16_t channelId, const std::string &channelName) {
	NetworkMessage msg;
	msg.addByte(0xB2);
	msg.add<uint16_t>(channelId);
	msg.addString(channelName);
	msg.add<uint16_t>(0x01);
	msg.addString(player->getName());
	msg.add<uint16_t>(0x00);
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendChannelsDialog() {
	NetworkMessage msg;
	msg.addByte(0xAB);

	const ChannelList &list = g_chat().getChannelList(player);
	msg.addByte(list.size());
	for (const auto &channel : list) {
		msg.add<uint16_t>(channel->getId());
		msg.addString(channel->getName());
	}

	writeToOutputBuffer(msg);
}

void ProtocolGame::sendChannel(uint16_t channelId, const std::string &channelName, const UsersMap* channelUsers, const InvitedMap* invitedUsers) {
	NetworkMessage msg;
	msg.addByte(0xAC);

	msg.add<uint16_t>(channelId);
	msg.addString(channelName);

	if (channelUsers) {
		msg.add<uint16_t>(channelUsers->size());
		for (const auto &it : *channelUsers) {
			msg.addString(it.second->getName());
		}
	} else {
		msg.add<uint16_t>(0x00);
	}

	if (invitedUsers) {
		msg.add<uint16_t>(invitedUsers->size());
		for (const auto &it : *invitedUsers) {
			msg.addString(it.second->getName());
		}
	} else {
		msg.add<uint16_t>(0x00);
	}
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendChannelMessage(const std::string &author, const std::string &text, SpeakClasses type, uint16_t channel) {
	NetworkMessage msg;
	msg.addByte(0xAA);
	msg.add<uint32_t>(0x00);
	msg.addString(author);
	msg.add<uint16_t>(0x00);
	msg.addByte(type);
	msg.add<uint16_t>(channel);
	msg.addString(text);
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendIcons(const std::unordered_set<PlayerIcon> &iconSet, const IconBakragore iconBakragore) {
	NetworkMessage msg;
	msg.addByte(0xA2);

	std::bitset<static_cast<size_t>(PlayerIcon::Count)> iconsBitSet;
	for (const auto &icon : iconSet) {
		iconsBitSet.set(enumToValue(icon));
	}

	uint32_t icons = iconsBitSet.to_ulong();

	if (oldProtocol) {
		// Send as uint16_t in old protocol
		msg.add<uint16_t>(static_cast<uint16_t>(icons));
	} else {
		// Send as uint32_t in new protocol
		msg.add<uint32_t>(icons);
		msg.addByte(enumToValue(iconBakragore)); // Icons Bakragore
	}

	writeToOutputBuffer(msg);
}

void ProtocolGame::sendIconBakragore(const IconBakragore icon) {
	NetworkMessage msg;
	msg.addByte(0xA2);
	msg.add<uint32_t>(0); // Send empty normal icons
	msg.addByte(enumToValue(icon));
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendUnjustifiedPoints(const uint8_t &dayProgress, const uint8_t &dayLeft, const uint8_t &weekProgress, const uint8_t &weekLeft, const uint8_t &monthProgress, const uint8_t &monthLeft, const uint8_t &skullDuration) {
	NetworkMessage msg;
	msg.addByte(0xB7);
	msg.addByte(dayProgress);
	msg.addByte(dayLeft);
	msg.addByte(weekProgress);
	msg.addByte(weekLeft);
	msg.addByte(monthProgress);
	msg.addByte(monthLeft);
	msg.addByte(skullDuration);
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendContainer(uint8_t cid, const std::shared_ptr<Container> &container, bool hasParent, uint16_t firstIndex) {
	if (!player || !container) {
		return;
	}

	NetworkMessage msg;
	msg.addByte(0x6E);

	msg.addByte(cid);

	if (container->getID() == ITEM_BROWSEFIELD) {
		AddItem(msg, ITEM_BAG, 1, container->getTier());
		msg.addString("Browse Field");
	} else {
		AddItem(msg, container);
		msg.addString(container->getName());
	}

	const auto itemsStoreInboxToSend = container->getStoreInboxFilteredItems();

	msg.addByte(container->capacity());

	msg.addByte(hasParent ? 0x01 : 0x00);

	// Depot search
	if (!oldProtocol) {
		msg.addByte((player->isDepotSearchAvailable() && container->isInsideDepot(true)) ? 0x01 : 0x00);
	}

	msg.addByte(container->isUnlocked() ? 0x01 : 0x00); // Drag and drop
	msg.addByte(container->hasPagination() ? 0x01 : 0x00); // Pagination

	uint32_t containerSize = container->size();
	if (!itemsStoreInboxToSend.empty()) {
		containerSize = itemsStoreInboxToSend.size();
	}
	msg.add<uint16_t>(containerSize);
	msg.add<uint16_t>(firstIndex);

	uint32_t maxItemsToSend;

	if (container->hasPagination() && firstIndex > 0) {
		maxItemsToSend = std::min<uint32_t>(container->capacity(), containerSize - firstIndex);
	} else {
		maxItemsToSend = container->capacity();
	}

	const ItemDeque &itemList = container->getItemList();
	if (firstIndex >= containerSize) {
		msg.addByte(0x00);
	} else if (container->getID() == ITEM_STORE_INBOX && !itemsStoreInboxToSend.empty()) {
		msg.addByte(std::min<uint32_t>(maxItemsToSend, containerSize));
		for (const auto &item : itemsStoreInboxToSend) {
			AddItem(msg, item);
		}
	} else {
		msg.addByte(std::min<uint32_t>(maxItemsToSend, containerSize));

		uint32_t i = 0;
		for (auto it = itemList.begin() + firstIndex, end = itemList.end(); i < maxItemsToSend && it != end; ++it, ++i) {
			AddItem(msg, *it);
		}
	}

	// From here on down is for version 13.21+
	if (oldProtocol) {
		writeToOutputBuffer(msg);
		return;
	}

	if (container->isStoreInbox()) {
		const auto &categories = container->getStoreInboxValidCategories();
		const auto enumName = container->getAttribute<std::string>(ItemAttribute_t::STORE_INBOX_CATEGORY);
		auto category = magic_enum::enum_cast<ContainerCategory_t>(enumName);
		if (category.has_value()) {
			bool toSendCategory = false;
			// Check if category exist in the deque
			for (const auto &tempCategory : categories) {
				if (tempCategory == category.value()) {
					toSendCategory = true;
					g_logger().debug("found category {}", toSendCategory);
				}
			}

			if (!toSendCategory) {
				std::shared_ptr<Container> container = player->getContainerByID(cid);
				if (container) {
					container->removeAttribute(ItemAttribute_t::STORE_INBOX_CATEGORY);
				}
			}
			sendContainerCategory<ContainerCategory_t>(msg, categories, static_cast<uint8_t>(category.value()));
		} else {
			sendContainerCategory<ContainerCategory_t>(msg, categories);
		}
	} else {
		msg.addByte(0x00);
		msg.addByte(0x00);
	}

	// New container menu options
	if (container->isMovable()) { // Pickupable/Moveable (?)
		msg.addByte(1);
	} else {
		msg.addByte(0);
	}

	if (container->getHoldingPlayer()) { // Player holding the item (?)
		msg.addByte(1);
	} else {
		msg.addByte(0);
	}

	writeToOutputBuffer(msg);
}

void ProtocolGame::sendLootContainers() {
	if (!player || oldProtocol) {
		return;
	}

	NetworkMessage msg;
	msg.addByte(0xC0);
	msg.addByte(player->quickLootFallbackToMainContainer ? 1 : 0);

	std::map<ObjectCategory_t, std::pair<std::shared_ptr<Container>, std::shared_ptr<Container>>> managedContainersMap;
	for (const auto &[category, containersPair] : player->m_managedContainers) {
		if (containersPair.first && !containersPair.first->isRemoved()) {
			managedContainersMap[category].first = containersPair.first;
		}
		if (containersPair.second && !containersPair.second->isRemoved()) {
			managedContainersMap[category].second = containersPair.second;
		}
	}

	auto msgPosition = msg.getBufferPosition();
	msg.skipBytes(1);
	uint8_t containers = 0;
	for (const auto &[category, containersPair] : managedContainersMap) {
		if (!isValidObjectCategory(category)) {
			continue;
		}
		containers++;
		msg.addByte(category);
		uint16_t lootContainerId = containersPair.first ? containersPair.first->getID() : 0;
		uint16_t obtainContainerId = containersPair.second ? containersPair.second->getID() : 0;
		msg.add<uint16_t>(lootContainerId);
		msg.add<uint16_t>(obtainContainerId);
	}
	msg.setBufferPosition(msgPosition);
	msg.addByte(containers);

	writeToOutputBuffer(msg);
}

void ProtocolGame::sendLootStats(const std::shared_ptr<Item> &item, uint8_t count) {
	if (!item) {
		return;
	}

	if (oldProtocol) {
		item->setIsLootTrackeable(false);
		return;
	}

	std::shared_ptr<Item> lootedItem = nullptr;
	lootedItem = item->clone();
	lootedItem->setItemCount(count);

	NetworkMessage msg;
	msg.addByte(0xCF);
	AddItem(msg, lootedItem);
	msg.addString(lootedItem->getName());
	item->setIsLootTrackeable(false);
	writeToOutputBuffer(msg);

	lootedItem = nullptr;
}

void ProtocolGame::sendShop(const std::shared_ptr<Npc> &npc) {
	Benchmark brenchmark;
	NetworkMessage msg;
	msg.addByte(0x7A);
	msg.addString(npc->getName());

	if (!oldProtocol) {
		msg.add<uint16_t>(npc->getCurrency());
		msg.addString(std::string()); // Currency name
	}

	const auto &shoplist = npc->getShopItemVector(player->getGUID());
	uint16_t itemsToSend = std::min<size_t>(shoplist.size(), std::numeric_limits<uint16_t>::max());
	msg.add<uint16_t>(itemsToSend);

	// Initialize before the loop to avoid database overload on each iteration
	auto talkactionHidden = player->kv()->get("npc-shop-hidden-sell-item");
	// Initialize the inventoryMap outside the loop to avoid creation on each iteration
	std::map<uint16_t, uint16_t> inventoryMap;
	player->getAllSaleItemIdAndCount(inventoryMap);
	uint16_t i = 0;
	for (const ShopBlock &shopBlock : shoplist) {
		if (++i > itemsToSend) {
			break;
		}

		// Hidden sell items from the shop if they are not in the player's inventory
		if (talkactionHidden && talkactionHidden->get<bool>()) {
			const auto &foundItem = inventoryMap.find(shopBlock.itemId);
			if (foundItem == inventoryMap.end() && shopBlock.itemSellPrice > 0 && shopBlock.itemBuyPrice == 0) {
				AddHiddenShopItem(msg);
				continue;
			}
		}

		AddShopItem(msg, shopBlock);
	}

	writeToOutputBuffer(msg);
	g_logger().debug("ProtocolGame::sendShop - Time: {} ms, shop items: {}", brenchmark.duration(), shoplist.size());
}

void ProtocolGame::sendCloseShop() {
	NetworkMessage msg;
	msg.addByte(0x7C);
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendClientCheck() {
	if (!player || oldProtocol) {
		return;
	}

	NetworkMessage msg;
	msg.addByte(0x63);
	msg.add<uint32_t>(1);
	msg.addByte(1);
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendGameNews() {
	if (!player || oldProtocol) {
		return;
	}

	NetworkMessage msg;
	msg.addByte(0x98);
	msg.add<uint32_t>(1); // unknown
	msg.addByte(1); //(0 = open | 1 = highlight)
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendResourcesBalance(uint64_t money /*= 0*/, uint64_t bank /*= 0*/, uint64_t preyCards /*= 0*/, uint64_t taskHunting /*= 0*/, uint64_t forgeDust /*= 0*/, uint64_t forgeSliver /*= 0*/, uint64_t forgeCores /*= 0*/) {
	sendResourceBalance(RESOURCE_BANK, bank);
	sendResourceBalance(RESOURCE_INVENTORY_MONEY, money);
	sendResourceBalance(RESOURCE_PREY_CARDS, preyCards);
	sendResourceBalance(RESOURCE_TASK_HUNTING, taskHunting);
	sendResourceBalance(RESOURCE_FORGE_DUST, forgeDust);
	sendResourceBalance(RESOURCE_FORGE_SLIVER, forgeSliver);
	sendResourceBalance(RESOURCE_FORGE_CORES, forgeCores);
}

void ProtocolGame::sendResourceBalance(Resource_t resourceType, uint64_t value) {
	if (oldProtocol && resourceType > RESOURCE_PREY_CARDS) {
		return;
	}

	NetworkMessage msg;
	msg.addByte(0xEE);
	msg.addByte(resourceType);
	msg.add<uint64_t>(value);
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendSaleItemList(const std::vector<ShopBlock> &shopVector, const std::map<uint16_t, uint16_t> &inventoryMap) {
	sendResourceBalance(RESOURCE_BANK, player->getBankBalance());

	uint16_t currency = player->getShopOwner() ? player->getShopOwner()->getCurrency() : static_cast<uint16_t>(ITEM_GOLD_COIN);
	if (currency == ITEM_GOLD_COIN) {
		// Since we already have full inventory map we shouldn't call getMoney here - it is simply wasting cpu power
		uint64_t playerMoney = 0;
		auto it = inventoryMap.find(ITEM_CRYSTAL_COIN);
		if (it != inventoryMap.end()) {
			playerMoney += static_cast<uint64_t>(it->second) * 10000;
		}
		it = inventoryMap.find(ITEM_PLATINUM_COIN);
		if (it != inventoryMap.end()) {
			playerMoney += static_cast<uint64_t>(it->second) * 100;
		}
		it = inventoryMap.find(ITEM_GOLD_COIN);
		if (it != inventoryMap.end()) {
			playerMoney += static_cast<uint64_t>(it->second);
		}
		sendResourceBalance(RESOURCE_INVENTORY_MONEY, playerMoney);
	} else {
		uint64_t customCurrencyValue = 0;
		auto search = inventoryMap.find(currency);
		if (search != inventoryMap.end()) {
			customCurrencyValue += static_cast<uint64_t>(search->second);
		}
		sendResourceBalance(oldProtocol ? RESOURCE_INVENTORY_MONEY : RESOURCE_INVENTORY_CURRENCY_CUSTOM, customCurrencyValue);
	}

	NetworkMessage msg;
	msg.addByte(0x7B);

	if (oldProtocol) {
		msg.add<uint64_t>(player->getMoney() + player->getBankBalance());
	}

	uint16_t itemsToSend = 0;
	const uint16_t ItemsToSendLimit = oldProtocol ? 0xFF : 0xFFFF;
	auto msgPosition = msg.getBufferPosition();
	msg.skipBytes(oldProtocol ? 1 : 2);

	for (const ShopBlock &shopBlock : shopVector) {
		if (shopBlock.itemSellPrice == 0) {
			continue;
		}

		auto it = inventoryMap.find(shopBlock.itemId);
		if (it != inventoryMap.end()) {
			msg.add<uint16_t>(shopBlock.itemId);
			if (oldProtocol) {
				msg.addByte(static_cast<uint8_t>(std::min<uint16_t>(it->second, std::numeric_limits<uint8_t>::max())));
			} else {
				msg.add<uint16_t>(std::min<uint16_t>(it->second, std::numeric_limits<uint16_t>::max()));
			}
			if (++itemsToSend >= ItemsToSendLimit) {
				break;
			}
		}
	}

	msg.setBufferPosition(msgPosition);
	if (oldProtocol) {
		msg.addByte(static_cast<uint8_t>(itemsToSend));
	} else {
		msg.add<uint16_t>(itemsToSend);
	}
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendMarketEnter(uint32_t depotId) {
	NetworkMessage msg;
	msg.addByte(0xF6);

	if (oldProtocol) {
		msg.add<uint64_t>(player->getBankBalance());
	}

	msg.addByte(static_cast<uint8_t>(std::min<uint32_t>(IOMarket::getPlayerOfferCount(player->getGUID()), std::numeric_limits<uint8_t>::max())));

	std::shared_ptr<DepotLocker> depotLocker = player->getDepotLocker(depotId);
	if (!depotLocker) {
		msg.add<uint16_t>(0x00);
		writeToOutputBuffer(msg);
		return;
	}

	player->setInMarket(true);

	// Only use here locker items, itemVector is for use of Game::createMarketOffer
	auto [itemVector, lockerItems] = player->requestLockerItems(depotLocker, true);
	auto totalItemsCountPosition = msg.getBufferPosition();
	msg.skipBytes(2); // Total items count

	uint16_t totalItemsCount = 0;
	for (const auto &[itemId, tierAndCountMap] : lockerItems) {
		for (const auto &[tier, count] : tierAndCountMap) {
			msg.add<uint16_t>(itemId);
			if (!oldProtocol && Item::items[itemId].upgradeClassification > 0) {
				msg.addByte(tier);
			}
			msg.add<uint16_t>(static_cast<uint16_t>(count));
			totalItemsCount++;
		}
	}

	msg.setBufferPosition(totalItemsCountPosition);
	msg.add<uint16_t>(totalItemsCount);
	writeToOutputBuffer(msg);

	updateCoinBalance();
	sendResourcesBalance(player->getMoney(), player->getBankBalance(), player->getPreyCards(), player->getTaskHuntingPoints());
}

void ProtocolGame::sendCoinBalance() {
	if (!player) {
		return;
	}

	// send is updating
	// TODO: export this to it own function
	NetworkMessage msg;
	msg.addByte(0xF2);
	msg.addByte(0x01);
	writeToOutputBuffer(msg);

	msg.reset();

	// send update
	msg.addByte(0xDF);
	msg.addByte(0x01);

	msg.add<uint32_t>(player->coinBalance); // Normal Coins
	msg.add<uint32_t>(player->coinTransferableBalance); // Transferable Coins

	if (!oldProtocol) {
		msg.add<uint32_t>(player->coinBalance); // Reserved Auction Coins
	}

	writeToOutputBuffer(msg);
}

void ProtocolGame::updateCoinBalance() {
	if (!player) {
		return;
	}

	g_dispatcher().addEvent(
		[playerId = player->getID()] {
			const auto &threadPlayer = g_game().getPlayerByID(playerId);
			if (threadPlayer && threadPlayer->getAccount()) {
				const auto [coins, errCoin] = threadPlayer->getAccount()->getCoins(CoinType::Normal);
				const auto [transferCoins, errTCoin] = threadPlayer->getAccount()->getCoins(CoinType::Transferable);

				threadPlayer->coinBalance = coins;
				threadPlayer->coinTransferableBalance = transferCoins;
				threadPlayer->sendCoinBalance();
			}
		},
		__FUNCTION__
	);
}

void ProtocolGame::sendMarketLeave() {
	NetworkMessage msg;
	msg.addByte(0xF7);
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendMarketBrowseItem(uint16_t itemId, const MarketOfferList &buyOffers, const MarketOfferList &sellOffers, uint8_t tier) {
	NetworkMessage msg;

	msg.addByte(0xF9);
	if (!oldProtocol) {
		msg.addByte(MARKETREQUEST_ITEM_BROWSE);
	}

	msg.add<uint16_t>(itemId);
	if (!oldProtocol && Item::items[itemId].upgradeClassification > 0) {
		msg.addByte(tier);
	}

	msg.add<uint32_t>(buyOffers.size());
	for (const MarketOffer &offer : buyOffers) {
		msg.add<uint32_t>(offer.timestamp);
		msg.add<uint16_t>(offer.counter);
		msg.add<uint16_t>(offer.amount);
		if (oldProtocol) {
			msg.add<uint32_t>(offer.price);
		} else {
			msg.add<uint64_t>(static_cast<uint64_t>(offer.price));
		}
		msg.addString(offer.playerName);
	}

	msg.add<uint32_t>(sellOffers.size());
	for (const MarketOffer &offer : sellOffers) {
		msg.add<uint32_t>(offer.timestamp);
		msg.add<uint16_t>(offer.counter);
		msg.add<uint16_t>(offer.amount);
		if (oldProtocol) {
			msg.add<uint32_t>(offer.price);
		} else {
			msg.add<uint64_t>(static_cast<uint64_t>(offer.price));
		}
		msg.addString(offer.playerName);
	}

	updateCoinBalance();
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendMarketAcceptOffer(const MarketOfferEx &offer) {
	NetworkMessage msg;
	msg.addByte(0xF9);
	if (!oldProtocol) {
		msg.addByte(MARKETREQUEST_ITEM_BROWSE);
	}

	msg.add<uint16_t>(offer.itemId);
	if (!oldProtocol && Item::items[offer.itemId].upgradeClassification > 0) {
		msg.addByte(offer.tier);
	}

	if (offer.type == MARKETACTION_BUY) {
		msg.add<uint32_t>(0x01);
		msg.add<uint32_t>(offer.timestamp);
		msg.add<uint16_t>(offer.counter);
		msg.add<uint16_t>(offer.amount);
		if (oldProtocol) {
			msg.add<uint32_t>(offer.price);
		} else {
			msg.add<uint64_t>(static_cast<uint64_t>(offer.price));
		}
		msg.addString(offer.playerName);
		msg.add<uint32_t>(0x00);
	} else {
		msg.add<uint32_t>(0x00);
		msg.add<uint32_t>(0x01);
		msg.add<uint32_t>(offer.timestamp);
		msg.add<uint16_t>(offer.counter);
		msg.add<uint16_t>(offer.amount);
		if (oldProtocol) {
			msg.add<uint32_t>(offer.price);
		} else {
			msg.add<uint64_t>(static_cast<uint64_t>(offer.price));
		}
		msg.addString(offer.playerName);
	}

	writeToOutputBuffer(msg);
}

void ProtocolGame::sendMarketBrowseOwnOffers(const MarketOfferList &buyOffers, const MarketOfferList &sellOffers) {
	NetworkMessage msg;
	msg.addByte(0xF9);
	if (oldProtocol) {
		msg.add<uint16_t>(MARKETREQUEST_OWN_OFFERS_OLD);
	} else {
		msg.addByte(MARKETREQUEST_OWN_OFFERS);
	}

	msg.add<uint32_t>(buyOffers.size());
	for (const MarketOffer &offer : buyOffers) {
		msg.add<uint32_t>(offer.timestamp);
		msg.add<uint16_t>(offer.counter);
		msg.add<uint16_t>(offer.itemId);
		if (!oldProtocol && Item::items[offer.itemId].upgradeClassification > 0) {
			msg.addByte(offer.tier);
		}
		msg.add<uint16_t>(offer.amount);
		if (oldProtocol) {
			msg.add<uint32_t>(offer.price);
		} else {
			msg.add<uint64_t>(static_cast<uint64_t>(offer.price));
		}
	}

	msg.add<uint32_t>(sellOffers.size());
	for (const MarketOffer &offer : sellOffers) {
		msg.add<uint32_t>(offer.timestamp);
		msg.add<uint16_t>(offer.counter);
		msg.add<uint16_t>(offer.itemId);
		if (!oldProtocol && Item::items[offer.itemId].upgradeClassification > 0) {
			msg.addByte(offer.tier);
		}
		msg.add<uint16_t>(offer.amount);
		if (oldProtocol) {
			msg.add<uint32_t>(offer.price);
		} else {
			msg.add<uint64_t>(static_cast<uint64_t>(offer.price));
		}
	}

	writeToOutputBuffer(msg);
}

void ProtocolGame::sendMarketCancelOffer(const MarketOfferEx &offer) {
	NetworkMessage msg;
	msg.addByte(0xF9);
	if (oldProtocol) {
		msg.add<uint16_t>(MARKETREQUEST_OWN_OFFERS_OLD);
	} else {
		msg.addByte(MARKETREQUEST_OWN_OFFERS);
	}

	if (offer.type == MARKETACTION_BUY) {
		msg.add<uint32_t>(0x01);
		msg.add<uint32_t>(offer.timestamp);
		msg.add<uint16_t>(offer.counter);
		msg.add<uint16_t>(offer.itemId);
		if (!oldProtocol && Item::items[offer.itemId].upgradeClassification > 0) {
			msg.addByte(offer.tier);
		}
		msg.add<uint16_t>(offer.amount);
		if (oldProtocol) {
			msg.add<uint32_t>(offer.price);
		} else {
			msg.add<uint64_t>(static_cast<uint64_t>(offer.price));
		}
		msg.add<uint32_t>(0x00);
	} else {
		msg.add<uint32_t>(0x00);
		msg.add<uint32_t>(0x01);
		msg.add<uint32_t>(offer.timestamp);
		msg.add<uint16_t>(offer.counter);
		msg.add<uint16_t>(offer.itemId);
		if (!oldProtocol && Item::items[offer.itemId].upgradeClassification > 0) {
			msg.addByte(offer.tier);
		}
		msg.add<uint16_t>(offer.amount);
		if (oldProtocol) {
			msg.add<uint32_t>(offer.price);
		} else {
			msg.add<uint64_t>(static_cast<uint64_t>(offer.price));
		}
	}

	writeToOutputBuffer(msg);
}

void ProtocolGame::sendMarketBrowseOwnHistory(const HistoryMarketOfferList &buyOffers, const HistoryMarketOfferList &sellOffers) {
	uint32_t i = 0;
	std::map<uint32_t, uint16_t> counterMap;
	uint32_t buyOffersToSend = std::min<uint32_t>(buyOffers.size(), 810 + std::max<int32_t>(0, 810 - sellOffers.size()));
	uint32_t sellOffersToSend = std::min<uint32_t>(sellOffers.size(), 810 + std::max<int32_t>(0, 810 - buyOffers.size()));

	NetworkMessage msg;
	msg.addByte(0xF9);
	if (oldProtocol) {
		msg.add<uint16_t>(MARKETREQUEST_OWN_HISTORY_OLD);
	} else {
		msg.addByte(MARKETREQUEST_OWN_HISTORY);
	}

	msg.add<uint32_t>(buyOffersToSend);
	for (auto it = buyOffers.begin(); i < buyOffersToSend; ++it, ++i) {
		msg.add<uint32_t>(it->timestamp);
		msg.add<uint16_t>(counterMap[it->timestamp]++);
		msg.add<uint16_t>(it->itemId);
		if (!oldProtocol && Item::items[it->itemId].upgradeClassification > 0) {
			msg.addByte(it->tier);
		}
		msg.add<uint16_t>(it->amount);
		if (oldProtocol) {
			msg.add<uint32_t>(it->price);
		} else {
			msg.add<uint64_t>(static_cast<uint64_t>(it->price));
		}
		msg.addByte(it->state);
	}

	counterMap.clear();
	i = 0;

	msg.add<uint32_t>(sellOffersToSend);
	for (auto it = sellOffers.begin(); i < sellOffersToSend; ++it, ++i) {
		msg.add<uint32_t>(it->timestamp);
		msg.add<uint16_t>(counterMap[it->timestamp]++);
		msg.add<uint16_t>(it->itemId);
		if (Item::items[it->itemId].upgradeClassification > 0) {
			msg.addByte(it->tier);
		}
		msg.add<uint16_t>(it->amount);
		msg.add<uint64_t>(it->price);
		msg.addByte(it->state);
	}

	writeToOutputBuffer(msg);
}

void ProtocolGame::sendForgingData() {
	if (!player || oldProtocol) {
		return;
	}

	NetworkMessage msg;
	msg.addByte(0x86);

	std::map<uint8_t, uint16_t> tierCorePrices;
	std::map<uint8_t, uint64_t> convergenceFusionPrices;
	std::map<uint8_t, uint64_t> convergenceTransferPrices;

	const auto classifications = g_game().getItemsClassifications();
	msg.addByte(classifications.size());
	for (const auto &classification : classifications) {
		msg.addByte(classification->id);
		msg.addByte(classification->tiers.size());
		for (const auto &[tier, tierInfo] : classification->tiers) {
			msg.addByte(tier - 1);
			msg.add<uint64_t>(tierInfo.regularPrice);
			tierCorePrices[tier] = tierInfo.corePrice;
			convergenceFusionPrices[tier] = tierInfo.convergenceFusionPrice;
			convergenceTransferPrices[tier] = tierInfo.convergenceTransferPrice;
		}
	}

	// Version 13.30
	// Forge Config Bytes

	// Exalted core table per tier
	msg.addByte(static_cast<uint8_t>(tierCorePrices.size()));
	for (const auto &[tier, cores] : tierCorePrices) {
		msg.addByte(tier);
		msg.addByte(cores);
	}

	// Convergence fusion prices per tier
	msg.addByte(static_cast<uint8_t>(convergenceFusionPrices.size()));
	for (const auto &[tier, price] : convergenceFusionPrices) {
		msg.addByte(tier - 1);
		msg.add<uint64_t>(price);
	}

	// Convergence transfer prices per tier
	msg.addByte(static_cast<uint8_t>(convergenceTransferPrices.size()));
	for (const auto &[tier, price] : convergenceTransferPrices) {
		msg.addByte(tier);
		msg.add<uint64_t>(price);
	}

	// (conversion) (left column top) Cost to make 1 bottom item - 20
	msg.addByte(static_cast<uint8_t>(g_configManager().getNumber(FORGE_COST_ONE_SLIVER)));
	// (conversion) (left column bottom) How many items to make - 3
	msg.addByte(static_cast<uint8_t>(g_configManager().getNumber(FORGE_SLIVER_AMOUNT)));
	// (conversion) (middle column top) Cost to make 1 - 50
	msg.addByte(static_cast<uint8_t>(g_configManager().getNumber(FORGE_CORE_COST)));
	// (conversion) (right column top) Current stored dust limit minus this number = cost to increase stored dust limit - 75
	msg.addByte(75);
	// (conversion) (right column bottom) Starting stored dust limit
	msg.add<uint16_t>(player->getForgeDustLevel());
	// (conversion) (right column bottom) Max stored dust limit - 325
	msg.add<uint16_t>(g_configManager().getNumber(FORGE_MAX_DUST));
	// (normal fusion) dust cost - 100
	msg.addByte(static_cast<uint8_t>(g_configManager().getNumber(FORGE_FUSION_DUST_COST)));
	// (convergence fusion) dust cost - 130
	msg.addByte(static_cast<uint8_t>(g_configManager().getNumber(FORGE_CONVERGENCE_FUSION_DUST_COST)));
	// (normal transfer) dust cost - 100
	msg.addByte(static_cast<uint8_t>(g_configManager().getNumber(FORGE_TRANSFER_DUST_COST)));
	// (convergence transfer) dust cost - 160
	msg.addByte(static_cast<uint8_t>(g_configManager().getNumber(FORGE_CONVERGENCE_TRANSFER_DUST_COST)));
	// (fusion) Base success rate - 50
	msg.addByte(static_cast<uint8_t>(g_configManager().getNumber(FORGE_BASE_SUCCESS_RATE)));
	// (fusion) Bonus success rate - 15
	msg.addByte(static_cast<uint8_t>(g_configManager().getNumber(FORGE_BONUS_SUCCESS_RATE)));
	// (fusion) Tier loss chance after reduction - 50
	msg.addByte(static_cast<uint8_t>(g_configManager().getNumber(FORGE_TIER_LOSS_REDUCTION)));

	// Update player resources
	parseSendResourceBalance();

	writeToOutputBuffer(msg);
}

void ProtocolGame::sendOpenForge() {
	// We will use it when sending the bytes to send the item information to the client
	std::map<uint16_t, std::map<uint8_t, uint16_t>> fusionItemsMap;
	std::map<int32_t, std::map<uint16_t, std::map<uint8_t, uint16_t>>> convergenceFusionItemsMap;
	std::map<int32_t, std::map<uint16_t, std::map<uint8_t, uint16_t>>> convergenceTransferItemsMap;
	std::map<uint16_t, std::map<uint8_t, uint16_t>> donorTierItemMap;
	std::map<uint16_t, std::map<uint8_t, uint16_t>> receiveTierItemMap;

	auto maxConfigTier = g_configManager().getNumber(FORGE_MAX_ITEM_TIER);

	/*
	 *Start - Parsing items informations
	 */
	for (const auto &item : player->getAllInventoryItems(true)) {
		if (item->hasImbuements()) {
			continue;
		}

		auto itemClassification = item->getClassification();
		auto itemTier = item->getTier();
		auto maxTier = (itemClassification == 4 ? maxConfigTier : itemClassification);
		// Save fusion items on map
		if (itemClassification != 0 && itemTier < maxTier) {
			getForgeInfoMap(item, fusionItemsMap);
		}

		if (itemClassification > 0) {
			if (itemClassification < 4 && itemTier > maxTier) {
				continue;
			}
			// Save transfer (donator of tier) items on map
			if (itemTier > 1) {
				getForgeInfoMap(item, donorTierItemMap);
			}
			// Save transfer (receiver of tier) items on map
			if (itemTier == 0) {
				getForgeInfoMap(item, receiveTierItemMap);
			}
			if (itemClassification == 4) {
				auto slotPosition = item->getSlotPosition();
				if ((slotPosition & SLOTP_TWO_HAND) != 0) {
					slotPosition = SLOTP_HAND;
				}
				getForgeInfoMap(item, convergenceFusionItemsMap[slotPosition]);
				getForgeInfoMap(item, convergenceTransferItemsMap[item->getClassification()]);
			}
		}
	}

	// Checking size of map to send in the addByte (total fusion items count)
	uint8_t fusionTotalItemsCount = 0;
	for (const auto &[itemId, tierAndCountMap] : fusionItemsMap) {
		for (const auto &[itemTier, itemCount] : tierAndCountMap) {
			if (itemCount >= 2) {
				fusionTotalItemsCount++;
			}
		}
	}

	/*
	 * Start - Sending bytes
	 */
	NetworkMessage msg;

	// Header byte (135)
	msg.addByte(0x87);

	msg.add<uint16_t>(fusionTotalItemsCount);
	for (const auto &[itemId, tierAndCountMap] : fusionItemsMap) {
		for (const auto &[itemTier, itemCount] : tierAndCountMap) {
			if (itemCount >= 2) {
				msg.addByte(0x01); // Number of friend items?
				msg.add<uint16_t>(itemId);
				msg.addByte(itemTier);
				msg.add<uint16_t>(itemCount);
			}
		}
	}

	// msg.add<uint16_t>(convergenceItemsMap.size());
	auto convergenceFusionCountPosition = msg.getBufferPosition();
	msg.skipBytes(2);
	uint16_t convergenceFusionCount = 0;
	/*
	for each convergence fusion (1 per item slot, only class 4):
	1 byte: count fusable items
	for each fusable item:
	    2 bytes: item id
	    1 byte: tier
	    2 bytes: count
	*/
	for (const auto &[slot, itemMap] : convergenceFusionItemsMap) {
		uint8_t totalItemsCount = 0;
		auto totalItemsCountPosition = msg.getBufferPosition();
		msg.skipBytes(1); // Total items count
		for (const auto &[itemId, tierAndCountMap] : itemMap) {
			for (const auto &[tier, itemCount] : tierAndCountMap) {
				if (tier >= maxConfigTier) {
					continue;
				}
				totalItemsCount++;
				msg.add<uint16_t>(itemId);
				msg.addByte(tier);
				msg.add<uint16_t>(itemCount);
			}
		}
		auto endPosition = msg.getBufferPosition();
		msg.setBufferPosition(totalItemsCountPosition);
		if (totalItemsCount > 0) {
			msg.addByte(totalItemsCount);
			msg.setBufferPosition(endPosition);
			convergenceFusionCount++;
		}
	}

	auto transferTotalCountPosition = msg.getBufferPosition();
	msg.setBufferPosition(convergenceFusionCountPosition);
	msg.add<uint16_t>(convergenceFusionCount);
	msg.setBufferPosition(transferTotalCountPosition);

	auto transferTotalCount = getIterationIncreaseCount(donorTierItemMap);
	msg.addByte(static_cast<uint8_t>(transferTotalCount));
	if (transferTotalCount > 0) {
		for (const auto &[itemId, tierAndCountMap] : donorTierItemMap) {
			// Let's access the itemType to check the item's (donator of tier) classification level
			// Must be the same as the item that will receive the tier
			const ItemType &donorType = Item::items[itemId];
			auto donorSlotPosition = donorType.slotPosition;
			if ((donorSlotPosition & SLOTP_TWO_HAND) != 0) {
				donorSlotPosition = SLOTP_HAND;
			}

			// Total count of item (donator of tier)
			auto donorTierTotalItemsCount = getIterationIncreaseCount(tierAndCountMap);
			msg.add<uint16_t>(donorTierTotalItemsCount);
			for (const auto &[donorItemTier, donorItemCount] : tierAndCountMap) {
				msg.add<uint16_t>(itemId);
				msg.addByte(donorItemTier);
				msg.add<uint16_t>(donorItemCount);
			}

			uint16_t receiveTierTotalItemCount = 0;
			for (const auto &[iteratorItemId, unusedTierAndCountMap] : receiveTierItemMap) {
				// Let's access the itemType to check the item's (receiver of tier) classification level
				const ItemType &receiveType = Item::items[iteratorItemId];
				auto receiveSlotPosition = receiveType.slotPosition;
				if ((receiveSlotPosition & SLOTP_TWO_HAND) != 0) {
					receiveSlotPosition = SLOTP_HAND;
				}
				if (donorType.upgradeClassification == receiveType.upgradeClassification && donorSlotPosition == receiveSlotPosition) {
					receiveTierTotalItemCount++;
				}
			}

			// Total count of item (receiver of tier)
			msg.add<uint16_t>(receiveTierTotalItemCount);
			if (receiveTierTotalItemCount > 0) {
				for (const auto &[receiveItemId, receiveTierAndCountMap] : receiveTierItemMap) {
					// Let's access the itemType to check the item's (receiver of tier) classification level
					const ItemType &receiveType = Item::items[receiveItemId];
					auto receiveSlotPosition = receiveType.slotPosition;
					if ((receiveSlotPosition & SLOTP_TWO_HAND) != 0) {
						receiveSlotPosition = SLOTP_HAND;
					}
					if (donorType.upgradeClassification == receiveType.upgradeClassification && donorSlotPosition == receiveSlotPosition) {
						for (const auto &[receiveItemTier, receiveItemCount] : receiveTierAndCountMap) {
							msg.add<uint16_t>(receiveItemId);
							msg.add<uint16_t>(receiveItemCount);
						}
					}
				}
			}
		}
	}

	auto convergenceCountPosition = msg.getBufferPosition();
	msg.skipBytes(1);
	uint8_t convergenceTransferCount = 0;

	/*
	for each convergence transfer:
	    2 bytes: count donors
	    for each donor:
	        2 bytes: item id
	        1 byte: tier
	        2 bytes: count
	    2 bytes: count receivers
	    for each receiver:
	        2 bytes: item id
	        2 bytes: count
	*/
	for (const auto &[slot, itemMap] : convergenceTransferItemsMap) {
		uint16_t donorCount = 0;
		uint16_t receiverCount = 0;
		auto donorCountPosition = msg.getBufferPosition();
		msg.skipBytes(2); // Donor count
		for (const auto &[itemId, tierAndCountMap] : itemMap) {
			for (const auto [tier, itemCount] : tierAndCountMap) {
				if (tier >= 1) {
					donorCount++;
					msg.add<uint16_t>(itemId);
					msg.addByte(tier);
					msg.add<uint16_t>(itemCount);
				} else {
					receiverCount++;
				}
			}
		}
		if (donorCount == 0 && receiverCount == 0) {
			msg.setBufferPosition(donorCountPosition);
			continue;
		}
		auto receiverCountPosition = msg.getBufferPosition();
		msg.setBufferPosition(donorCountPosition);
		msg.add<uint16_t>(donorCount);
		++convergenceTransferCount;
		msg.setBufferPosition(receiverCountPosition);
		msg.add<uint16_t>(receiverCount);
		for (const auto &[itemId, tierAndCountMap] : itemMap) {
			for (const auto [tier, itemCount] : tierAndCountMap) {
				if (tier == 0) {
					msg.add<uint16_t>(itemId);
					msg.add<uint16_t>(itemCount);
				}
			}
		}
	}
	auto dustLevelPosition = msg.getBufferPosition();
	msg.setBufferPosition(convergenceCountPosition);
	msg.addByte(convergenceTransferCount);
	msg.setBufferPosition(dustLevelPosition);

	msg.add<uint16_t>(player->getForgeDustLevel()); // Player dust limit
	writeToOutputBuffer(msg);
	// Update forging informations
	sendForgingData();
}

void ProtocolGame::parseForgeEnter(NetworkMessage &msg) {
	if (oldProtocol) {
		return;
	}

	// 0xBF -> 0 = fusion, 1 = transfer, 2 = dust to sliver, 3 = sliver to core, 4 = increase dust limit
	const auto actionType = static_cast<ForgeAction_t>(msg.getByte());

	bool convergence = false;
	uint16_t firstItem = 0;
	uint8_t tier = 0;
	uint16_t secondItem = 0;

	if (actionType == ForgeAction_t::FUSION || actionType == ForgeAction_t::TRANSFER) {
		convergence = msg.getByte();
		firstItem = msg.get<uint16_t>();
		tier = msg.getByte();
		secondItem = msg.get<uint16_t>();
	}

	if (actionType == ForgeAction_t::FUSION) {
		const bool usedCore = convergence ? false : msg.getByte();
		const bool reduceTierLoss = convergence ? false : msg.getByte();
		g_game().playerForgeFuseItems(player->getID(), actionType, firstItem, tier, secondItem, usedCore, reduceTierLoss, convergence);
	} else if (actionType == ForgeAction_t::TRANSFER) {
		g_game().playerForgeTransferItemTier(player->getID(), actionType, firstItem, tier, secondItem, convergence);
	} else if (actionType <= ForgeAction_t::INCREASELIMIT) {
		g_game().playerForgeResourceConversion(player->getID(), actionType);
	}
}

void ProtocolGame::parseForgeBrowseHistory(NetworkMessage &msg) {
	if (oldProtocol) {
		return;
	}

	g_game().playerBrowseForgeHistory(player->getID(), msg.getByte());
}

void ProtocolGame::sendForgeResult(ForgeAction_t actionType, uint16_t leftItemId, uint8_t leftTier, uint16_t rightItemId, uint8_t rightTier, bool success, uint8_t bonus, uint8_t coreCount, bool convergence) {
	NetworkMessage msg;
	msg.addByte(0x8A);

	// 0 = fusion | 1 = transfer
	msg.addByte(static_cast<uint8_t>(actionType));
	msg.addByte(convergence);

	if (convergence && actionType == ForgeAction_t::FUSION) {
		success = true;
		std::swap(leftItemId, rightItemId);
	}

	msg.addByte(success);

	msg.add<uint16_t>(leftItemId);
	msg.addByte(leftTier);
	msg.add<uint16_t>(rightItemId);
	msg.addByte(rightTier);

	if (actionType == ForgeAction_t::TRANSFER) {
		msg.addByte(0x00); // Bonus type always none for transfer
	} else {
		msg.addByte(bonus); // Roll fusion bonus
		// Core kept
		if (bonus == 2) {
			msg.addByte(coreCount);
		} else if (bonus >= 4 && bonus <= 8) {
			msg.add<uint16_t>(leftItemId);
			msg.addByte(leftTier);
		}
	}

	writeToOutputBuffer(msg);
	g_logger().debug("Send forge fusion: type {}, left item {}, left tier {}, right item {}, rightTier {}, success {}, bonus {}, coreCount {}, convergence {}", fmt::underlying(actionType), leftItemId, leftTier, rightItemId, rightTier, success, bonus, coreCount, convergence);
	sendOpenForge();
}

void ProtocolGame::sendForgeHistory(uint8_t page) {
	page = page + 1;
	auto historyVector = player->getForgeHistory();
	auto historyVectorLen = getVectorIterationIncreaseCount(historyVector);

	uint16_t lastPage = (1 < std::floor((historyVectorLen - 1) / 9) + 1) ? static_cast<uint16_t>(std::floor((historyVectorLen - 1) / 9) + 1) : 1;
	uint16_t currentPage = (lastPage < page) ? lastPage : page;

	std::vector<ForgeHistory> historyPerPage;
	uint16_t pageFirstEntry = (0 < historyVectorLen - (currentPage - 1) * 9) ? historyVectorLen - (currentPage - 1) * 9 : 0;
	uint16_t pageLastEntry = (0 < historyVectorLen - currentPage * 9) ? historyVectorLen - currentPage * 9 : 0;
	for (uint16_t entry = pageFirstEntry; entry > pageLastEntry; --entry) {
		historyPerPage.emplace_back(historyVector[entry - 1]);
	}

	auto historyPageToSend = getVectorIterationIncreaseCount(historyPerPage);

	NetworkMessage msg;
	msg.addByte(0x88);
	msg.add<uint16_t>(currentPage - 1); // Current page
	msg.add<uint16_t>(lastPage); // Last page
	msg.addByte(static_cast<uint8_t>(historyPageToSend)); // History to send

	if (historyPageToSend > 0) {
		for (const auto &history : historyPerPage) {
			auto action = magic_enum::enum_integer(history.actionType);
			msg.add<uint32_t>(static_cast<uint32_t>(history.createdAt));
			msg.addByte(action);
			msg.addString(history.description);
			msg.addByte((history.bonus >= 1 && history.bonus < 8) ? 0x01 : 0x00);
		}
	}

	writeToOutputBuffer(msg);
}

void ProtocolGame::sendForgeError(const ReturnValue returnValue) {
	sendMessageDialog(getReturnMessage(returnValue));
	closeForgeWindow();
}

void ProtocolGame::closeForgeWindow() {
	NetworkMessage msg;
	msg.addByte(0x89);
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendMarketDetail(uint16_t itemId, uint8_t tier) {
	NetworkMessage msg;
	msg.addByte(0xF8);
	msg.add<uint16_t>(itemId);
	const ItemType &it = Item::items[itemId];

	if (!oldProtocol && it.upgradeClassification > 0) {
		msg.addByte(tier);
	}

	if (it.armor != 0) {
		msg.addString(std::to_string(it.armor));
	} else {
		msg.add<uint16_t>(0x00);
	}

	if (it.isRanged()) {
		std::ostringstream ss;
		bool separator = false;

		if (it.attack != 0) {
			ss << "attack +" << it.attack;
			separator = true;
		}

		if (it.hitChance != 0) {
			if (separator) {
				ss << ", ";
			}
			ss << "chance to hit +" << static_cast<int16_t>(it.hitChance) << "%";
			separator = true;
		}

		if (it.shootRange != 0) {
			if (separator) {
				ss << ", ";
			}
			ss << static_cast<uint16_t>(it.shootRange) << " fields";
		}
		msg.addString(ss.str());
	} else {
		std::string attackDescription;
		if (it.abilities && it.abilities->elementType != COMBAT_NONE && it.abilities->elementDamage != 0) {
			attackDescription = fmt::format("{} {}", it.abilities->elementDamage, getCombatName(it.abilities->elementType));
		}

		if (it.attack != 0 && !attackDescription.empty()) {
			attackDescription = fmt::format("{} physical + {}", it.attack, attackDescription);
		} else if (it.attack != 0 && attackDescription.empty()) {
			attackDescription = std::to_string(it.attack);
		}

		msg.addString(attackDescription);
	}

	if (it.isContainer()) {
		msg.addString(std::to_string(it.maxItems));
	} else {
		msg.add<uint16_t>(0x00);
	}

	if (it.defense != 0 || it.isMissile()) {
		if (it.extraDefense != 0) {
			std::ostringstream ss;
			ss << it.defense << ' ' << std::showpos << it.extraDefense << std::noshowpos;
			msg.addString(ss.str());
		} else {
			msg.addString(std::to_string(it.defense));
		}
	} else {
		msg.add<uint16_t>(0x00);
	}

	if (!it.description.empty()) {
		const std::string &descr = it.description;
		if (descr.back() == '.') {
			msg.addString(std::string(descr, 0, descr.length() - 1));
		} else {
			msg.addString(descr);
		}
	} else {
		msg.add<uint16_t>(0x00);
	}

	if (it.decayTime != 0) {
		std::ostringstream ss;
		ss << it.decayTime << " seconds";
		msg.addString(ss.str());
	} else {
		msg.add<uint16_t>(0x00);
	}

	if (it.abilities) {
		std::ostringstream ss;
		bool separator = false;

		for (size_t i = 0; i < COMBAT_COUNT; ++i) {
			if (it.abilities->absorbPercent[i] == 0) {
				continue;
			}

			if (separator) {
				ss << ", ";
			} else {
				separator = true;
			}

			ss << fmt::format("{} {:+}%", getCombatName(indexToCombatType(i)), it.abilities->absorbPercent[i]);
		}

		msg.addString(ss.str());
	} else {
		msg.add<uint16_t>(0x00);
	}

	if (it.minReqLevel != 0) {
		msg.addString(std::to_string(it.minReqLevel));
	} else {
		msg.add<uint16_t>(0x00);
	}

	if (it.minReqMagicLevel != 0) {
		msg.addString(std::to_string(it.minReqMagicLevel));
	} else {
		msg.add<uint16_t>(0x00);
	}

	msg.addString(it.vocationString);
	msg.addString(it.runeSpellName);

	if (it.abilities) {
		std::ostringstream ss;
		bool separator = false;

		for (uint8_t i = SKILL_FIRST; i <= SKILL_FISHING; i++) {
			if (!it.abilities->skills[i]) {
				continue;
			}

			if (separator) {
				ss << ", ";
			} else {
				separator = true;
			}

			ss << fmt::format("{} {:+}", getSkillName(i), it.abilities->skills[i]);
		}

		for (uint8_t i = SKILL_CRITICAL_HIT_CHANCE; i <= SKILL_LAST; i++) {
			auto skills = it.abilities->skills[i];
			if (!skills) {
				continue;
			}

			if (separator) {
				ss << ", ";
			} else {
				separator = true;
			}

			ss << fmt::format("{} {:+}%", getSkillName(i), skills / 100.0);
		}

		if (it.abilities->stats[STAT_MAGICPOINTS] != 0) {
			if (separator) {
				ss << ", ";
			} else {
				separator = true;
			}

			ss << fmt::format(" magic level {:+}", it.abilities->stats[STAT_MAGICPOINTS]);
		}

		// Version 12.72 (Specialized magic level modifier)
		for (uint8_t i = 1; i <= 11; i++) {
			if (it.abilities->specializedMagicLevel[i]) {
				if (separator) {
					ss << ", ";
				} else {
					separator = true;
				}
				std::string combatName = getCombatName(indexToCombatType(i));
				ss << std::showpos << combatName << std::noshowpos << "magic level +" << it.abilities->specializedMagicLevel[i];
			}
		}

		if (it.abilities->speed != 0) {
			if (separator) {
				ss << ", ";
			}

			ss << fmt::format("speed {:+}", (it.abilities->speed >> 1));
		}

		msg.addString(ss.str());
	} else {
		msg.add<uint16_t>(0x00);
	}

	if (it.charges != 0) {
		msg.addString(std::to_string(it.charges));
	} else {
		msg.add<uint16_t>(0x00);
	}

	std::string weaponName = getWeaponName(it.weaponType);

	if (it.slotPosition & SLOTP_TWO_HAND) {
		if (!weaponName.empty()) {
			weaponName += ", two-handed";
		} else {
			weaponName = "two-handed";
		}
	}

	msg.addString(weaponName);

	if (it.weight != 0) {
		std::ostringstream ss;
		if (it.weight < 10) {
			ss << "0.0" << it.weight;
		} else if (it.weight < 100) {
			ss << "0." << it.weight;
		} else {
			std::string weightString = std::to_string(it.weight);
			weightString.insert(weightString.end() - 2, '.');
			ss << weightString;
		}
		ss << " oz";
		msg.addString(ss.str());
	} else {
		msg.add<uint16_t>(0x00);
	}

	if (!oldProtocol) {
		std::string augmentsDescription = it.parseAugmentDescription(true);
		if (!augmentsDescription.empty()) {
			msg.addString(augmentsDescription);
		} else {
			msg.add<uint16_t>(0x00); // no augments
		}
	}

	if (it.imbuementSlot > 0) {
		msg.addString(std::to_string(it.imbuementSlot));
	} else {
		msg.add<uint16_t>(0x00);
	}

	if (!oldProtocol) {
		// Version 12.70 new skills
		if (it.abilities) {
			std::ostringstream string;
			if (it.abilities->magicShieldCapacityFlat > 0) {
				string.clear();
				string << std::showpos << it.abilities->magicShieldCapacityFlat << std::noshowpos << " and " << it.abilities->magicShieldCapacityPercent << "%";
				msg.addString(string.str());
			} else {
				msg.add<uint16_t>(0x00);
			}

			if (it.abilities->cleavePercent > 0) {
				string.clear();
				string << it.abilities->cleavePercent << "%";
				msg.addString(string.str());
			} else {
				msg.add<uint16_t>(0x00);
			}

			if (it.abilities->reflectFlat[COMBAT_PHYSICALDAMAGE] > 0) {
				string.clear();
				string << it.abilities->reflectFlat[COMBAT_PHYSICALDAMAGE];
				msg.addString(string.str());
			} else {
				msg.add<uint16_t>(0x00);
			}

			if (it.abilities->perfectShotDamage > 0) {
				string.clear();
				string << std::showpos << it.abilities->perfectShotDamage << std::noshowpos << " at range " << unsigned(it.abilities->perfectShotRange);
				msg.addString(string.str());
			} else {
				msg.add<uint16_t>(0x00);
			}
		} else {
			// Send empty skills
			// Cleave modifier
			msg.add<uint16_t>(0x00);
			// Magic shield capacity
			msg.add<uint16_t>(0x00);
			// Damage reflection modifie
			msg.add<uint16_t>(0x00);
			// Perfect shot modifier
			msg.add<uint16_t>(0x00);
		}

		// Upgrade and tier detail modifier
		if (it.upgradeClassification > 0 && tier > 0) {
			msg.addString(std::to_string(it.upgradeClassification));
			std::ostringstream ss;

			double chance;
			if (it.isWeapon()) {
				chance = 0.5 * tier + 0.05 * ((tier - 1) * (tier - 1));
				ss << fmt::format("{} ({:.2f}% Onslaught)", static_cast<uint16_t>(tier), chance);
			} else if (it.isHelmet()) {
				chance = 2 * tier + 0.05 * ((tier - 1) * (tier - 1));
				ss << fmt::format("{} ({:.2f}% Momentum)", static_cast<uint16_t>(tier), chance);
			} else if (it.isArmor()) {
				chance = (0.0307576 * tier * tier) + (0.440697 * tier) + 0.026;
				ss << fmt::format("{} ({:.2f}% Ruse)", static_cast<uint16_t>(tier), chance);
			}
			msg.addString(ss.str());
		} else if (it.upgradeClassification > 0 && tier == 0) {
			msg.addString(std::to_string(it.upgradeClassification));
			msg.addString(std::to_string(tier));
		} else {
			msg.add<uint16_t>(0x00);
			msg.add<uint16_t>(0x00);
		}
	}

	const auto &purchaseStatsMap = IOMarket::getInstance().getPurchaseStatistics();
	auto purchaseIterator = purchaseStatsMap.find(itemId);
	if (purchaseIterator != purchaseStatsMap.end()) {
		const auto &tierStatsMap = purchaseIterator->second;
		auto tierStatsIter = tierStatsMap.find(tier);
		if (tierStatsIter != tierStatsMap.end()) {
			const auto &purchaseStatistics = tierStatsIter->second;
			msg.addByte(0x01);
			msg.add<uint32_t>(purchaseStatistics.numTransactions);
			if (oldProtocol) {
				msg.add<uint32_t>(std::min<uint64_t>(std::numeric_limits<uint32_t>::max(), purchaseStatistics.totalPrice));
				msg.add<uint32_t>(std::min<uint64_t>(std::numeric_limits<uint32_t>::max(), purchaseStatistics.highestPrice));
				msg.add<uint32_t>(std::min<uint64_t>(std::numeric_limits<uint32_t>::max(), purchaseStatistics.lowestPrice));
			} else {
				msg.add<uint64_t>(purchaseStatistics.totalPrice);
				msg.add<uint64_t>(purchaseStatistics.highestPrice);
				msg.add<uint64_t>(purchaseStatistics.lowestPrice);
			}
		} else {
			msg.addByte(0x00);
		}
	} else {
		msg.addByte(0x00); // send to old protocol ?
	}

	const auto &saleStatsMap = IOMarket::getInstance().getSaleStatistics();
	auto saleIterator = saleStatsMap.find(itemId);
	if (saleIterator != saleStatsMap.end()) {
		const auto &tierStatsMap = saleIterator->second;
		auto tierStatsIter = tierStatsMap.find(tier);
		if (tierStatsIter != tierStatsMap.end()) {
			const auto &saleStatistics = tierStatsIter->second;
			msg.addByte(0x01);
			msg.add<uint32_t>(saleStatistics.numTransactions);
			if (oldProtocol) {
				msg.add<uint32_t>(std::min<uint64_t>(std::numeric_limits<uint32_t>::max(), saleStatistics.totalPrice));
				msg.add<uint32_t>(std::min<uint64_t>(std::numeric_limits<uint32_t>::max(), saleStatistics.highestPrice));
				msg.add<uint32_t>(std::min<uint64_t>(std::numeric_limits<uint32_t>::max(), saleStatistics.lowestPrice));
			} else {
				msg.add<uint64_t>(std::min<uint64_t>(std::numeric_limits<uint32_t>::max(), saleStatistics.totalPrice));
				msg.add<uint64_t>(saleStatistics.highestPrice);
				msg.add<uint64_t>(saleStatistics.lowestPrice);
			}
		} else {
			msg.addByte(0x00);
		}
	} else {
		msg.addByte(0x00); // send to old protocol ?
	}

	writeToOutputBuffer(msg);
}

void ProtocolGame::sendTradeItemRequest(const std::string &traderName, const std::shared_ptr<Item> &item, bool ack) {
	NetworkMessage msg;

	if (ack) {
		msg.addByte(0x7D);
	} else {
		msg.addByte(0x7E);
	}

	msg.addString(traderName);

	if (std::shared_ptr<Container> tradeContainer = item->getContainer()) {
		std::list<std::shared_ptr<Container>> listContainer { tradeContainer };
		std::list<std::shared_ptr<Item>> itemList { tradeContainer };
		while (!listContainer.empty()) {
			const auto &container = listContainer.front();
			for (const auto &containerItem : container->getItemList()) {
				const auto &tmpContainer = containerItem->getContainer();
				if (tmpContainer) {
					listContainer.emplace_back(tmpContainer);
				}
				itemList.emplace_back(containerItem);
			}

			// Removes the object after processing everything, avoiding memory usage after freeing
			listContainer.pop_front();
		}

		msg.addByte(itemList.size());
		for (const std::shared_ptr<Item> &listItem : itemList) {
			AddItem(msg, listItem);
		}
	} else {
		msg.addByte(0x01);
		AddItem(msg, item);
	}
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendCloseTrade() {
	NetworkMessage msg;
	msg.addByte(0x7F);
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendCloseContainer(uint8_t cid) {
	NetworkMessage msg;
	msg.addByte(0x6F);
	msg.addByte(cid);
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendCreatureTurn(const std::shared_ptr<Creature> &creature, uint32_t stackPos) {
	if (!canSee(creature)) {
		return;
	}

	NetworkMessage msg;
	msg.addByte(0x6B);
	msg.addPosition(creature->getPosition());
	msg.addByte(static_cast<uint8_t>(stackPos));
	msg.add<uint16_t>(0x63);
	msg.add<uint32_t>(creature->getID());
	msg.addByte(creature->getDirection());
	msg.addByte(player->canWalkthroughEx(creature) ? 0x00 : 0x01);
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendCreatureSay(const std::shared_ptr<Creature> &creature, SpeakClasses type, const std::string &text, const Position* pos /* = nullptr*/) {
	NetworkMessage msg;
	msg.addByte(0xAA);

	static uint32_t statementId = 0;
	msg.add<uint32_t>(++statementId);

	msg.addString(creature->getName());

	if (!oldProtocol) {
		msg.addByte(0x00); // Show (Traded)
	}

	// Add level only for players
	if (std::shared_ptr<Player> speaker = creature->getPlayer()) {
		msg.add<uint16_t>(speaker->getLevel());
	} else {
		msg.add<uint16_t>(0x00);
	}

	if (oldProtocol && type >= TALKTYPE_MONSTER_LAST_OLDPROTOCOL && type != TALKTYPE_CHANNEL_R2) {
		msg.addByte(TALKTYPE_MONSTER_SAY);
	} else {
		msg.addByte(type);
	}

	if (pos) {
		msg.addPosition(*pos);
	} else {
		msg.addPosition(creature->getPosition());
	}

	msg.addString(text);
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendToChannel(const std::shared_ptr<Creature> &creature, SpeakClasses type, const std::string &text, uint16_t channelId) {
	NetworkMessage msg;
	msg.addByte(0xAA);

	static uint32_t statementId = 0;
	msg.add<uint32_t>(++statementId);
	if (!creature) {
		msg.add<uint32_t>(0x00);
		if (!oldProtocol && statementId != 0) {
			msg.addByte(0x00); // Show (Traded)
		}
	} else if (type == TALKTYPE_CHANNEL_R2) {
		msg.add<uint32_t>(0x00);
		if (!oldProtocol && statementId != 0) {
			msg.addByte(0x00); // Show (Traded)
		}
		type = TALKTYPE_CHANNEL_R1;
	} else {
		msg.addString(creature->getName());
		if (!oldProtocol && statementId != 0) {
			msg.addByte(0x00); // Show (Traded)
		}

		// Add level only for players
		if (std::shared_ptr<Player> speaker = creature->getPlayer()) {
			msg.add<uint16_t>(speaker->getLevel());
		} else {
			msg.add<uint16_t>(0x00);
		}
	}

	if (oldProtocol && type >= TALKTYPE_MONSTER_LAST_OLDPROTOCOL && type != TALKTYPE_CHANNEL_R2) {
		msg.addByte(TALKTYPE_CHANNEL_O);
	} else {
		msg.addByte(type);
	}

	msg.add<uint16_t>(channelId);
	msg.addString(text);
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendPrivateMessage(const std::shared_ptr<Player> &speaker, SpeakClasses type, const std::string &text) {
	NetworkMessage msg;
	msg.addByte(0xAA);
	static uint32_t statementId = 0;
	msg.add<uint32_t>(++statementId);
	if (speaker) {
		msg.addString(speaker->getName());
		if (!oldProtocol && statementId != 0) {
			msg.addByte(0x00); // Show (Traded)
		}
		msg.add<uint16_t>(speaker->getLevel());
	} else {
		msg.add<uint32_t>(0x00);
		if (!oldProtocol && statementId != 0) {
			msg.addByte(0x00); // Show (Traded)
		}
	}

	if (oldProtocol && type >= TALKTYPE_MONSTER_LAST_OLDPROTOCOL && type != TALKTYPE_CHANNEL_R2) {
		msg.addByte(TALKTYPE_PRIVATE_TO);
	} else {
		msg.addByte(type);
	}

	msg.addString(text);
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendCancelTarget() {
	NetworkMessage msg;
	msg.addByte(0xA3);
	msg.add<uint32_t>(0x00);
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendChangeSpeed(const std::shared_ptr<Creature> &creature, uint16_t speed) {
	NetworkMessage msg;
	msg.addByte(0x8F);
	msg.add<uint32_t>(creature->getID());
	msg.add<uint16_t>(creature->getBaseSpeed());
	msg.add<uint16_t>(speed);
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendCancelWalk() {
	if (player) {
		NetworkMessage msg;
		msg.addByte(0xB5);
		msg.addByte(player->getDirection());
		writeToOutputBuffer(msg);
	}
}

void ProtocolGame::sendSkills() {
	NetworkMessage msg;
	AddPlayerSkills(msg);
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendPing() {
	if (player) {
		NetworkMessage msg;
		msg.addByte(0x1D);
		writeToOutputBuffer(msg);
	}
}

void ProtocolGame::sendPingBack() {
	NetworkMessage msg;
	msg.addByte(0x1E);
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendDistanceShoot(const Position &from, const Position &to, uint16_t type) {
	if (oldProtocol && type > 0xFF) {
		return;
	}
	NetworkMessage msg;
	if (oldProtocol) {
		msg.addByte(0x85);
		msg.addPosition(from);
		msg.addPosition(to);
		msg.addByte(static_cast<uint8_t>(type));
	} else {
		msg.addByte(0x83);
		msg.addPosition(from);
		msg.addByte(MAGIC_EFFECTS_CREATE_DISTANCEEFFECT);
		msg.add<uint16_t>(type);
		msg.addByte(static_cast<uint8_t>(static_cast<int8_t>(static_cast<int32_t>(to.x) - static_cast<int32_t>(from.x))));
		msg.addByte(static_cast<uint8_t>(static_cast<int8_t>(static_cast<int32_t>(to.y) - static_cast<int32_t>(from.y))));
		msg.addByte(MAGIC_EFFECTS_END_LOOP);
	}
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendRestingStatus(uint8_t protection) {
	if (oldProtocol || !player) {
		return;
	}

	NetworkMessage msg;
	msg.addByte(0xA9);
	msg.addByte(protection); // 1 / 0

	uint8_t dailyStreak = 0;
	auto dailyRewardKV = player->kv()->scoped("daily-reward")->get("streak");
	if (dailyRewardKV && dailyRewardKV.has_value()) {
		dailyStreak = static_cast<uint8_t>(dailyRewardKV->getNumber());
	}

	msg.addByte(dailyStreak < 2 ? 0 : 1);
	if (dailyStreak < 2) {
		msg.addString("Resting Area (no active bonus)");
	} else {
		std::ostringstream ss;
		ss << "Active Resting Area Bonuses: ";
		if (dailyStreak < DAILY_REWARD_DOUBLE_HP_REGENERATION) {
			ss << "\nHit Points Regeneration";
		} else {
			ss << "\nDouble Hit Points Regeneration";
		}
		if (dailyStreak >= DAILY_REWARD_MP_REGENERATION) {
			if (dailyStreak < DAILY_REWARD_DOUBLE_MP_REGENERATION) {
				ss << ",\nMana Points Regeneration";
			} else {
				ss << ",\nDouble Mana Points Regeneration";
			}
		}
		if (dailyStreak >= DAILY_REWARD_STAMINA_REGENERATION) {
			ss << ",\nStamina Points Regeneration";
		}
		if (dailyStreak >= DAILY_REWARD_SOUL_REGENERATION) {
			ss << ",\nSoul Points Regeneration";
		}
		ss << ".";
		msg.addString(ss.str());
	}
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendMagicEffect(const Position &pos, uint16_t type) {
	if (!canSee(pos) || (oldProtocol && type > 0xFF)) {
		return;
	}

	NetworkMessage msg;
	if (oldProtocol) {
		msg.addByte(0x83);
		msg.addPosition(pos);
		msg.addByte(static_cast<uint8_t>(type));
	} else {
		msg.addByte(0x83);
		msg.addPosition(pos);
		msg.addByte(MAGIC_EFFECTS_CREATE_EFFECT);
		msg.add<uint16_t>(type);
		msg.addByte(MAGIC_EFFECTS_END_LOOP);
	}
	writeToOutputBuffer(msg);
}

void ProtocolGame::removeMagicEffect(const Position &pos, uint16_t type) {
	if (oldProtocol && type > 0xFF) {
		return;
	}
	NetworkMessage msg;
	msg.addByte(0x84);
	msg.addPosition(pos);
	if (oldProtocol) {
		msg.addByte(static_cast<uint8_t>(type));
	} else {
		msg.add<uint16_t>(type);
	}
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendCreatureHealth(const std::shared_ptr<Creature> &creature) {
	if (creature->isHealthHidden()) {
		return;
	}

	NetworkMessage msg;
	msg.addByte(0x8C);
	msg.add<uint32_t>(creature->getID());
	if (creature->isHealthHidden()) {
		msg.addByte(0x00);
	} else {
		msg.addByte(static_cast<uint8_t>(std::min<double>(100, std::ceil((static_cast<double>(creature->getHealth()) / std::max<int32_t>(creature->getMaxHealth(), 1)) * 100))));
	}

	writeToOutputBuffer(msg);
}

void ProtocolGame::sendPartyCreatureUpdate(const std::shared_ptr<Creature> &target) {
	if (!player || oldProtocol) {
		return;
	}

	bool known;
	uint32_t removedKnown = 0;
	uint32_t cid = target->getID();
	checkCreatureAsKnown(cid, known, removedKnown);

	NetworkMessage msg;
	msg.addByte(0x8B);
	msg.add<uint32_t>(cid);
	msg.addByte(0); // creature update
	AddCreature(msg, target, known, removedKnown);
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendPartyCreatureShield(const std::shared_ptr<Creature> &target) {
	uint32_t cid = target->getID();
	if (!knownCreatureSet.contains(cid)) {
		sendPartyCreatureUpdate(target);
		return;
	}

	NetworkMessage msg;
	msg.addByte(0x91);
	msg.add<uint32_t>(cid);
	msg.addByte(player->getPartyShield(target->getPlayer()));
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendPartyCreatureSkull(const std::shared_ptr<Creature> &target) {
	if (g_game().getWorldType() != WORLD_TYPE_PVP) {
		return;
	}

	uint32_t cid = target->getID();
	if (!knownCreatureSet.contains(cid)) {
		sendPartyCreatureUpdate(target);
		return;
	}

	NetworkMessage msg;
	msg.addByte(0x90);
	msg.add<uint32_t>(cid);
	msg.addByte(player->getSkullClient(target));
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendPartyCreatureHealth(const std::shared_ptr<Creature> &target, uint8_t healthPercent) {
	uint32_t cid = target->getID();
	if (!knownCreatureSet.contains(cid)) {
		sendPartyCreatureUpdate(target);
		return;
	}

	NetworkMessage msg;
	msg.addByte(0x8C);
	msg.add<uint32_t>(cid);
	msg.addByte(std::min<uint8_t>(100, healthPercent));
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendPartyPlayerMana(const std::shared_ptr<Player> &target, uint8_t manaPercent) {
	uint32_t cid = target->getID();
	if (!knownCreatureSet.contains(cid)) {
		sendPartyCreatureUpdate(target);
	}

	if (oldProtocol) {
		return;
	}

	NetworkMessage msg;
	msg.addByte(0x8B);
	msg.add<uint32_t>(cid);
	msg.addByte(11); // mana percent
	msg.addByte(std::min<uint8_t>(100, manaPercent));
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendPartyCreatureShowStatus(const std::shared_ptr<Creature> &target, bool showStatus) {
	uint32_t cid = target->getID();
	if (!knownCreatureSet.contains(cid)) {
		sendPartyCreatureUpdate(target);
	}

	if (oldProtocol) {
		return;
	}

	NetworkMessage msg;
	msg.addByte(0x8B);
	msg.add<uint32_t>(cid);
	msg.addByte(12); // show status
	msg.addByte((showStatus ? 0x01 : 0x00));
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendPartyPlayerVocation(const std::shared_ptr<Player> &target) {
	if (!target) {
		return;
	}

	uint32_t cid = target->getID();
	if (!knownCreatureSet.contains(cid)) {
		sendPartyCreatureUpdate(target);
		return;
	}

	if (oldProtocol) {
		return;
	}

	NetworkMessage msg;
	msg.addByte(0x8B);
	msg.add<uint32_t>(cid);
	msg.addByte(13); // vocation
	msg.addByte(target->getVocation()->getClientId());
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendPlayerVocation(const std::shared_ptr<Player> &target) {
	if (!player || !target || oldProtocol) {
		return;
	}

	NetworkMessage msg;
	msg.addByte(0x8B);
	msg.add<uint32_t>(target->getID());
	msg.addByte(13); // vocation
	msg.addByte(target->getVocation()->getClientId());
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendFYIBox(const std::string &message) {
	NetworkMessage msg;
	msg.addByte(0x15);
	msg.addString(message);
	writeToOutputBuffer(msg);
}

// tile
void ProtocolGame::sendMapDescription(const Position &pos) {
	NetworkMessage msg;
	msg.addByte(0x64);
	msg.addPosition(player->getPosition());
	GetMapDescription(pos.x - MAP_MAX_CLIENT_VIEW_PORT_X, pos.y - MAP_MAX_CLIENT_VIEW_PORT_Y, pos.z, (MAP_MAX_CLIENT_VIEW_PORT_X + 1) * 2, (MAP_MAX_CLIENT_VIEW_PORT_Y + 1) * 2, msg);
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendAddTileItem(const Position &pos, uint32_t stackpos, const std::shared_ptr<Item> &item) {
	if (!canSee(pos)) {
		return;
	}

	NetworkMessage msg;
	msg.addByte(0x6A);
	msg.addPosition(pos);
	msg.addByte(static_cast<uint8_t>(stackpos));
	AddItem(msg, item);
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendUpdateTileItem(const Position &pos, uint32_t stackpos, const std::shared_ptr<Item> &item) {
	if (!canSee(pos)) {
		return;
	}

	NetworkMessage msg;
	msg.addByte(0x6B);
	msg.addPosition(pos);
	msg.addByte(static_cast<uint8_t>(stackpos));
	AddItem(msg, item);
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendRemoveTileThing(const Position &pos, uint32_t stackpos) {
	if (!canSee(pos)) {
		return;
	}

	NetworkMessage msg;
	RemoveTileThing(msg, pos, stackpos);
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendUpdateTileCreature(const Position &pos, uint32_t stackpos, const std::shared_ptr<Creature> &creature) {
	if (!canSee(pos)) {
		return;
	}

	NetworkMessage msg;
	msg.addByte(0x6B);
	msg.addPosition(pos);
	msg.addByte(static_cast<uint8_t>(stackpos));

	bool known;
	uint32_t removedKnown;
	checkCreatureAsKnown(creature->getID(), known, removedKnown);
	AddCreature(msg, creature, false, removedKnown);
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendUpdateTile(const std::shared_ptr<Tile> &tile, const Position &pos) {
	if (!canSee(pos)) {
		return;
	}

	NetworkMessage msg;
	msg.addByte(0x69);
	msg.addPosition(pos);

	if (tile) {
		GetTileDescription(tile, msg);
		msg.addByte(0x00);
		msg.addByte(0xFF);
	} else {
		msg.addByte(0x01);
		msg.addByte(0xFF);
	}

	writeToOutputBuffer(msg);
}

void ProtocolGame::sendPendingStateEntered() {
	if (!player || oldProtocol) {
		return;
	}

	NetworkMessage msg;
	msg.addByte(0x0A);
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendEnterWorld() {
	NetworkMessage msg;
	msg.addByte(0x0F);
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendFightModes() {
	NetworkMessage msg;
	msg.addByte(0xA7);
	msg.addByte(player->fightMode);
	msg.addByte(player->chaseMode);
	msg.addByte(player->secureMode);
	msg.addByte(PVP_MODE_DOVE);
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendAllowBugReport() {
	if (oldProtocol) {
		return;
	}

	NetworkMessage msg;
	msg.addByte(0x1A);
	msg.addByte(0x00); // 0x01 = DISABLE bug report
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendAddCreature(const std::shared_ptr<Creature> &creature, const Position &pos, int32_t stackpos, bool isLogin) {
	if (!canSee(pos)) {
		return;
	}

	if (creature != player) {
		if (stackpos >= 10) {
			return;
		}

		NetworkMessage msg;
		msg.addByte(0x6A);
		msg.addPosition(pos);
		msg.addByte(static_cast<uint8_t>(stackpos));

		bool known;
		uint32_t removedKnown;
		checkCreatureAsKnown(creature->getID(), known, removedKnown);
		AddCreature(msg, creature, known, removedKnown);
		writeToOutputBuffer(msg);

		if (isLogin) {
			if (std::shared_ptr<Player> creaturePlayer = creature->getPlayer()) {
				if (!creaturePlayer->isAccessPlayer() || creaturePlayer->getAccountType() == ACCOUNT_TYPE_NORMAL) {
					sendMagicEffect(pos, CONST_ME_TELEPORT);
				}
			} else {
				sendMagicEffect(pos, CONST_ME_TELEPORT);
			}
		}

		return;
	}

	NetworkMessage msg;
	msg.addByte(0x17);

	msg.add<uint32_t>(player->getID());
	msg.add<uint16_t>(SERVER_BEAT); // beat duration (50)

	msg.addDouble(Creature::speedA, 3);
	msg.addDouble(Creature::speedB, 3);
	msg.addDouble(Creature::speedC, 3);

	// Allow bug report (Ctrl + Z)
	if (oldProtocol) {
		if (player->getAccountType() >= ACCOUNT_TYPE_NORMAL) {
			msg.addByte(0x01);
		} else {
			msg.addByte(0x00);
		}
	}

	msg.addByte(0x00); // can change pvp framing option
	msg.addByte(0x00); // expert mode button enabled

	msg.addString(g_configManager().getString(STORE_IMAGES_URL));
	msg.add<uint16_t>(static_cast<uint16_t>(g_configManager().getNumber(STORE_COIN_PACKET)));

	if (!oldProtocol) {
		msg.addByte(shouldAddExivaRestrictions ? 0x01 : 0x00); // exiva button enabled
	}

	writeToOutputBuffer(msg);

	// Allow bug report (Ctrl + Z)
	sendAllowBugReport();

	sendTibiaTime(g_game().getLightHour());
	sendPendingStateEntered();
	sendEnterWorld();
	sendMapDescription(pos);
	loggedIn = true;

	if (isLogin) {
		sendMagicEffect(pos, CONST_ME_TELEPORT);
		sendHotkeyPreset();
		sendDisableLoginMusic();
	}

	for (int i = CONST_SLOT_FIRST; i <= CONST_SLOT_LAST; ++i) {
		sendInventoryItem(static_cast<Slots_t>(i), player->getInventoryItem(static_cast<Slots_t>(i)));
	}

	sendStats();
	sendSkills();
	sendBlessStatus();
	sendPremiumTrigger();
	sendItemsPrice();
	sendPreyPrices();
	player->sendPreyData();
	player->sendTaskHuntingData();
	sendForgingData();

	// gameworld light-settings
	sendWorldLight(g_game().getWorldLightInfo());

	// player light level
	sendCreatureLight(creature);

	sendVIPGroups();

	const auto &vipEntries = IOLoginData::getVIPEntries(player->getAccountId());

	if (player->isAccessPlayer()) {
		for (const VIPEntry &entry : vipEntries) {
			VipStatus_t vipStatus;

			std::shared_ptr<Player> vipPlayer = g_game().getPlayerByGUID(entry.guid);
			if (!vipPlayer) {
				vipStatus = VipStatus_t::Offline;
			} else {
				vipStatus = vipPlayer->vip()->getStatus();
			}

			sendVIP(entry.guid, entry.name, entry.description, entry.icon, entry.notify, vipStatus);
		}
	} else {
		for (const VIPEntry &entry : vipEntries) {
			VipStatus_t vipStatus;

			std::shared_ptr<Player> vipPlayer = g_game().getPlayerByGUID(entry.guid);
			if (!vipPlayer || vipPlayer->isInGhostMode()) {
				vipStatus = VipStatus_t::Offline;
			} else {
				vipStatus = vipPlayer->vip()->getStatus();
			}

			sendVIP(entry.guid, entry.name, entry.description, entry.icon, entry.notify, vipStatus);
		}
	}

	sendInventoryIds();
	std::shared_ptr<Item> slotItem = player->getInventoryItem(CONST_SLOT_BACKPACK);
	if (slotItem) {
		player->setMainBackpackUnassigned(slotItem->getContainer());
	}

	sendLootContainers();
	sendBasicData();
	// Wheel of destiny cooldown
	if (!oldProtocol && g_configManager().getBoolean(TOGGLE_WHEELSYSTEM)) {
		player->wheel()->sendGiftOfLifeCooldown();
	}

	player->sendClientCheck();
	player->sendGameNews();
	player->sendIcons();

	// We need to manually send the open containers on player login, on IOLoginData it won't work.
	if (isLogin && oldProtocol) {
		player->openPlayerContainers();
	}
}

void ProtocolGame::sendMoveCreature(const std::shared_ptr<Creature> &creature, const Position &newPos, int32_t newStackPos, const Position &oldPos, int32_t oldStackPos, bool teleport) {
	if (creature == player) {
		if (oldStackPos >= 10) {
			sendMapDescription(newPos);
		} else if (teleport) {
			NetworkMessage msg;
			RemoveTileThing(msg, oldPos, oldStackPos);
			writeToOutputBuffer(msg);
			sendMapDescription(newPos);
		} else {
			NetworkMessage msg;
			if (oldPos.z == MAP_INIT_SURFACE_LAYER && newPos.z >= MAP_INIT_SURFACE_LAYER + 1) {
				RemoveTileThing(msg, oldPos, oldStackPos);
			} else {
				msg.addByte(0x6D);
				msg.addPosition(oldPos);
				msg.addByte(static_cast<uint8_t>(oldStackPos));
				msg.addPosition(newPos);
			}

			if (newPos.z > oldPos.z) {
				MoveDownCreature(msg, creature, newPos, oldPos);
			} else if (newPos.z < oldPos.z) {
				MoveUpCreature(msg, creature, newPos, oldPos);
			}

			if (oldPos.y > newPos.y) { // north, for old x
				msg.addByte(0x65);
				GetMapDescription(oldPos.x - MAP_MAX_CLIENT_VIEW_PORT_X, newPos.y - MAP_MAX_CLIENT_VIEW_PORT_Y, newPos.z, (MAP_MAX_CLIENT_VIEW_PORT_X + 1) * 2, 1, msg);
			} else if (oldPos.y < newPos.y) { // south, for old x
				msg.addByte(0x67);
				GetMapDescription(oldPos.x - MAP_MAX_CLIENT_VIEW_PORT_X, newPos.y + (MAP_MAX_CLIENT_VIEW_PORT_Y + 1), newPos.z, (MAP_MAX_CLIENT_VIEW_PORT_X + 1) * 2, 1, msg);
			}

			if (oldPos.x < newPos.x) { // east, [with new y]
				msg.addByte(0x66);
				GetMapDescription(newPos.x + (MAP_MAX_CLIENT_VIEW_PORT_X + 1), newPos.y - MAP_MAX_CLIENT_VIEW_PORT_Y, newPos.z, 1, (MAP_MAX_CLIENT_VIEW_PORT_Y + 1) * 2, msg);
			} else if (oldPos.x > newPos.x) { // west, [with new y]
				msg.addByte(0x68);
				GetMapDescription(newPos.x - MAP_MAX_CLIENT_VIEW_PORT_X, newPos.y - MAP_MAX_CLIENT_VIEW_PORT_Y, newPos.z, 1, (MAP_MAX_CLIENT_VIEW_PORT_Y + 1) * 2, msg);
			}
			writeToOutputBuffer(msg);
		}
	} else if (canSee(oldPos) && canSee(newPos)) {
		if (teleport || (oldPos.z == MAP_INIT_SURFACE_LAYER && newPos.z >= MAP_INIT_SURFACE_LAYER + 1) || oldStackPos >= 10) {
			sendRemoveTileThing(oldPos, oldStackPos);
			sendAddCreature(creature, newPos, newStackPos, false);
		} else {
			NetworkMessage msg;
			msg.addByte(0x6D);
			msg.addPosition(oldPos);
			msg.addByte(static_cast<uint8_t>(oldStackPos));
			msg.addPosition(newPos);
			writeToOutputBuffer(msg);
		}
	} else if (canSee(oldPos)) {
		sendRemoveTileThing(oldPos, oldStackPos);
	} else if (canSee(newPos)) {
		sendAddCreature(creature, newPos, newStackPos, false);
	}
}

void ProtocolGame::sendInventoryItem(Slots_t slot, const std::shared_ptr<Item> &item) {
	NetworkMessage msg;
	if (item) {
		msg.addByte(0x78);
		msg.addByte(slot);
		AddItem(msg, item);
	} else {
		msg.addByte(0x79);
		msg.addByte(slot);
	}
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendInventoryIds() {
	ItemsTierCountList items = player->getInventoryItemsId();

	NetworkMessage msg;
	msg.addByte(0xF5);
	auto countPosition = msg.getBufferPosition();
	msg.skipBytes(2); // Total items count

	for (uint16_t i = 1; i <= 11; i++) {
		msg.add<uint16_t>(i);
		msg.addByte(0x00);
		msg.add<uint16_t>(0x01);
	}

	uint16_t totalItemsCount = 0;
	for (const auto &[itemId, item] : items) {
		for (const auto [tier, count] : item) {
			msg.add<uint16_t>(itemId);
			msg.addByte(tier);
			msg.add<uint16_t>(static_cast<uint16_t>(count));
			totalItemsCount++;
		}
	}

	msg.setBufferPosition(countPosition);
	msg.add<uint16_t>(totalItemsCount + 11);
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendAddContainerItem(uint8_t cid, uint16_t slot, const std::shared_ptr<Item> &item) {
	NetworkMessage msg;
	msg.addByte(0x70);
	msg.addByte(cid);
	msg.add<uint16_t>(slot);
	AddItem(msg, item);
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendUpdateContainerItem(uint8_t cid, uint16_t slot, const std::shared_ptr<Item> &item) {
	NetworkMessage msg;
	msg.addByte(0x71);
	msg.addByte(cid);
	msg.add<uint16_t>(slot);
	AddItem(msg, item);
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendRemoveContainerItem(uint8_t cid, uint16_t slot, const std::shared_ptr<Item> &lastItem) {
	NetworkMessage msg;
	msg.addByte(0x72);
	msg.addByte(cid);
	msg.add<uint16_t>(slot);
	if (lastItem) {
		AddItem(msg, lastItem);
	} else {
		msg.add<uint16_t>(0x00);
	}
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendTextWindow(uint32_t windowTextId, const std::shared_ptr<Item> &item, uint16_t maxlen, bool canWrite) {
	NetworkMessage msg;
	msg.addByte(0x96);
	msg.add<uint32_t>(windowTextId);
	AddItem(msg, item);

	if (canWrite) {
		msg.add<uint16_t>(maxlen);
		msg.addString(item->getAttribute<std::string>(ItemAttribute_t::TEXT));
	} else {
		const std::string &text = item->getAttribute<std::string>(ItemAttribute_t::TEXT);
		msg.add<uint16_t>(text.size());
		msg.addString(text);
	}

	const std::string &writer = item->getAttribute<std::string>(ItemAttribute_t::WRITER);
	if (!writer.empty()) {
		msg.addString(writer);
	} else {
		msg.add<uint16_t>(0x00);
	}

	if (!oldProtocol) {
		msg.addByte(0x00); // Show (Traded)
	}

	auto writtenDate = item->getAttribute<time_t>(ItemAttribute_t::DATE);
	if (writtenDate != 0) {
		msg.addString(formatDateShort(writtenDate));
	} else {
		msg.add<uint16_t>(0x00);
	}

	writeToOutputBuffer(msg);
}

void ProtocolGame::sendTextWindow(uint32_t windowTextId, uint32_t itemId, const std::string &text) {
	NetworkMessage msg;
	msg.addByte(0x96);
	msg.add<uint32_t>(windowTextId);
	AddItem(msg, itemId, 1, 0);
	msg.add<uint16_t>(text.size());
	msg.addString(text);
	msg.add<uint16_t>(0x00);

	if (!oldProtocol) {
		msg.addByte(0x00); // Show (Traded)
	}

	msg.add<uint16_t>(0x00);
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendHouseWindow(uint32_t windowTextId, const std::string &text) {
	NetworkMessage msg;
	msg.addByte(0x97);
	msg.addByte(0x00);
	msg.add<uint32_t>(windowTextId);
	msg.addString(text);
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendOutfitWindow() {
	NetworkMessage msg;
	msg.addByte(0xC8);

	Outfit_t currentOutfit = player->getDefaultOutfit();
	auto isSupportOutfit = player->isWearingSupportOutfit();
	bool mounted = false;

	if (!isSupportOutfit) {
		const auto currentMount = g_game().mounts->getMountByID(player->getLastMount());
		if (currentMount) {
			mounted = (currentOutfit.lookMount == currentMount->clientId);
			currentOutfit.lookMount = currentMount->clientId;
		}
	} else {
		currentOutfit.lookMount = 0;
	}

	AddOutfit(msg, currentOutfit);

	if (oldProtocol) {
		std::vector<ProtocolOutfit> protocolOutfits;
		const auto outfits = Outfits::getInstance().getOutfits(player->getSex());
		protocolOutfits.reserve(outfits.size());
		for (const auto &outfit : outfits) {
			uint8_t addons;
			if (!player->getOutfitAddons(outfit, addons)) {
				continue;
			}

			protocolOutfits.emplace_back(outfit->name, outfit->lookType, addons);
			// Game client doesn't allow more than 100 outfits
			if (protocolOutfits.size() == 150) {
				break;
			}
		}

		msg.addByte(protocolOutfits.size());
		for (const ProtocolOutfit &outfit : protocolOutfits) {
			msg.add<uint16_t>(outfit.lookType);
			msg.addString(outfit.name);
			msg.addByte(outfit.addons);
		}

		std::vector<std::shared_ptr<Mount>> mounts;
		for (const auto &mount : g_game().mounts->getMounts()) {
			if (player->hasMount(mount)) {
				mounts.emplace_back(mount);
			}
		}

		msg.addByte(mounts.size());
		for (const auto &mount : mounts) {
			msg.add<uint16_t>(mount->clientId);
			msg.addString(mount->name);
		}

		writeToOutputBuffer(msg);
		return;
	}

	msg.addByte(isSupportOutfit ? 0 : currentOutfit.lookMountHead);
	msg.addByte(isSupportOutfit ? 0 : currentOutfit.lookMountBody);
	msg.addByte(isSupportOutfit ? 0 : currentOutfit.lookMountLegs);
	msg.addByte(isSupportOutfit ? 0 : currentOutfit.lookMountFeet);
	msg.add<uint16_t>(currentOutfit.lookFamiliarsType);

	auto startOutfits = msg.getBufferPosition();
	// 100 is the limit of old protocol clients.
	uint16_t limitOutfits = std::numeric_limits<uint16_t>::max();
	uint16_t outfitSize = 0;
	msg.skipBytes(2);

	if (player->isAccessPlayer() && g_configManager().getBoolean(ENABLE_SUPPORT_OUTFIT)) {
		msg.add<uint16_t>(75);
		msg.addString("Gamemaster");
		msg.addByte(0);
		msg.addByte(0x00);
		++outfitSize;

		msg.add<uint16_t>(266);
		msg.addString("Customer Support");
		msg.addByte(0);
		msg.addByte(0x00);
		++outfitSize;

		msg.add<uint16_t>(302);
		msg.addString("Community Manager");
		msg.addByte(0);
		msg.addByte(0x00);
		++outfitSize;
	}

	const auto outfits = Outfits::getInstance().getOutfits(player->getSex());

	for (const auto &outfit : outfits) {
		uint8_t addons;
		if (player->getOutfitAddons(outfit, addons)) {
			msg.add<uint16_t>(outfit->lookType);
			msg.addString(outfit->name);
			msg.addByte(addons);
			msg.addByte(0x00);
			++outfitSize;
		} else if (outfit->lookType == 1210 || outfit->lookType == 1211) {
			if (player->canWear(1210, 0) || player->canWear(1211, 0)) {
				msg.add<uint16_t>(outfit->lookType);
				msg.addString(outfit->name);
				msg.addByte(3);
				msg.addByte(0x02);
				++outfitSize;
			}
		} else if (outfit->lookType == 1456 || outfit->lookType == 1457) {
			if (player->canWear(1456, 0) || player->canWear(1457, 0)) {
				msg.add<uint16_t>(outfit->lookType);
				msg.addString(outfit->name);
				msg.addByte(3);
				msg.addByte(0x03);
				++outfitSize;
			}
		} else if (outfit->from == "store") {
			msg.add<uint16_t>(outfit->lookType);
			msg.addString(outfit->name);
			msg.addByte(outfit->lookType >= 962 && outfit->lookType <= 975 ? 0 : 3);
			msg.addByte(0x01);
			msg.add<uint32_t>(0x00);
			++outfitSize;
		}

		if (outfitSize == limitOutfits) {
			break;
		}
	}

	auto endOutfits = msg.getBufferPosition();
	msg.setBufferPosition(startOutfits);
	msg.add<uint16_t>(outfitSize);
	msg.setBufferPosition(endOutfits);

	auto startMounts = msg.getBufferPosition();
	uint16_t limitMounts = std::numeric_limits<uint16_t>::max();
	uint16_t mountSize = 0;
	msg.skipBytes(2);

	const auto mounts = g_game().mounts->getMounts();
	for (const auto &mount : mounts) {
		if (player->hasMount(mount)) {
			msg.add<uint16_t>(mount->clientId);
			msg.addString(mount->name);
			msg.addByte(0x00);
			++mountSize;
		} else if (mount->type == "store") {
			msg.add<uint16_t>(mount->clientId);
			msg.addString(mount->name);
			msg.addByte(0x01);
			msg.add<uint32_t>(0x00);
			++mountSize;
		}

		if (mountSize == limitMounts) {
			break;
		}
	}

	auto endMounts = msg.getBufferPosition();
	msg.setBufferPosition(startMounts);
	msg.add<uint16_t>(mountSize);
	msg.setBufferPosition(endMounts);

	auto startFamiliars = msg.getBufferPosition();
	uint16_t limitFamiliars = std::numeric_limits<uint16_t>::max();
	uint16_t familiarSize = 0;
	msg.skipBytes(2);

	const auto familiars = Familiars::getInstance().getFamiliars(player->getVocationId());

	for (const auto &familiar : familiars) {
		if (!player->getFamiliar(familiar)) {
			continue;
		}

		msg.add<uint16_t>(familiar->lookType);
		msg.addString(familiar->name);
		msg.addByte(0x00);
		if (++familiarSize == limitFamiliars) {
			break;
		}
	}

	auto endFamiliars = msg.getBufferPosition();
	msg.setBufferPosition(startFamiliars);
	msg.add<uint16_t>(familiarSize);
	msg.setBufferPosition(endFamiliars);

	msg.addByte(0x00); // Try outfit
	msg.addByte(mounted ? 0x01 : 0x00);

	// Version 12.81 - Random mount 'bool'
	msg.addByte(isSupportOutfit ? 0x00 : (player->isRandomMounted() ? 0x01 : 0x00));

	writeToOutputBuffer(msg);
}

void ProtocolGame::sendPodiumWindow(const std::shared_ptr<Item> &podium, const Position &position, uint16_t itemId, uint8_t stackpos) {
	if (!podium || oldProtocol) {
		g_logger().error("[{}] item is nullptr", __FUNCTION__);
		return;
	}

	NetworkMessage msg;
	msg.addByte(0xC8);

	const auto podiumVisible = podium->getCustomAttribute("PodiumVisible");
	const auto lookType = podium->getCustomAttribute("LookType");
	const auto lookMount = podium->getCustomAttribute("LookMount");
	const auto lookDirection = podium->getCustomAttribute("LookDirection");
	if (lookType) {
		addOutfitAndMountBytes(msg, podium, lookType, "LookHead", "LookBody", "LookLegs", "LookFeet", true);
	} else {
		msg.add<uint16_t>(0);
	}

	if (lookMount) {
		addOutfitAndMountBytes(msg, podium, lookMount, "LookMountHead", "LookMountBody", "LookMountLegs", "LookMountFeet");
	} else {
		msg.add<uint16_t>(0);
		msg.addByte(0);
		msg.addByte(0);
		msg.addByte(0);
		msg.addByte(0);
	}
	msg.add<uint16_t>(0);

	auto startOutfits = msg.getBufferPosition();
	uint16_t limitOutfits = std::numeric_limits<uint16_t>::max();
	uint16_t outfitSize = 0;
	msg.skipBytes(2);

	const auto outfits = Outfits::getInstance().getOutfits(player->getSex());
	for (const auto &outfit : outfits) {
		uint8_t addons;
		if (!player->getOutfitAddons(outfit, addons)) {
			continue;
		}

		msg.add<uint16_t>(outfit->lookType);
		msg.addString(outfit->name);
		msg.addByte(addons);
		msg.addByte(0x00);
		if (++outfitSize == limitOutfits) {
			break;
		}
	}

	auto endOutfits = msg.getBufferPosition();
	msg.setBufferPosition(startOutfits);
	msg.add<uint16_t>(outfitSize);
	msg.setBufferPosition(endOutfits);

	auto startMounts = msg.getBufferPosition();
	uint16_t limitMounts = std::numeric_limits<uint16_t>::max();
	uint16_t mountSize = 0;
	msg.skipBytes(2);

	const auto mounts = g_game().mounts->getMounts();
	for (const auto &mount : mounts) {
		if (player->hasMount(mount)) {
			msg.add<uint16_t>(mount->clientId);
			msg.addString(mount->name);
			msg.addByte(0x00);
			if (++mountSize == limitMounts) {
				break;
			}
		}
	}

	auto endMounts = msg.getBufferPosition();
	msg.setBufferPosition(startMounts);
	msg.add<uint16_t>(mountSize);
	msg.setBufferPosition(endMounts);

	msg.add<uint16_t>(0);

	msg.addByte(0x05);
	msg.addByte(lookMount ? 0x01 : 0x00);

	msg.add<uint16_t>(0);

	msg.addPosition(position);
	msg.add<uint16_t>(itemId);
	msg.addByte(stackpos);

	msg.addByte(podiumVisible ? podiumVisible->getAttribute<uint8_t>() : 0x01);
	msg.addByte(lookType ? 0x01 : 0x00);
	msg.addByte(lookDirection ? lookDirection->getAttribute<uint8_t>() : 2);
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendUpdatedVIPStatus(uint32_t guid, VipStatus_t newStatus) {
	if (oldProtocol && newStatus == VipStatus_t::Training) {
		return;
	}

	NetworkMessage msg;
	msg.addByte(0xD3);
	msg.add<uint32_t>(guid);
	msg.addByte(enumToValue(newStatus));
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendVIP(uint32_t guid, const std::string &name, const std::string &description, uint32_t icon, bool notify, VipStatus_t status) {
	if (oldProtocol && status == VipStatus_t::Training) {
		return;
	}

	NetworkMessage msg;
	msg.addByte(0xD2);
	msg.add<uint32_t>(guid);
	msg.addString(name);
	msg.addString(description);
	msg.add<uint32_t>(std::min<uint32_t>(10, icon));
	msg.addByte(notify ? 0x01 : 0x00);
	msg.addByte(enumToValue(status));

	const auto &vipGuidGroups = player->vip()->getGroupsIdGuidBelongs(guid);

	if (!oldProtocol) {
		msg.addByte(vipGuidGroups.size()); // vipGroups
		for (const auto &vipGroupID : vipGuidGroups) {
			msg.addByte(vipGroupID);
		}
	}

	writeToOutputBuffer(msg);
}

void ProtocolGame::sendVIPGroups() {
	if (oldProtocol) {
		return;
	}

	const auto &vipGroups = player->vip()->getGroups();

	NetworkMessage msg;
	msg.addByte(0xD4);
	msg.addByte(vipGroups.size()); // vipGroups.size()
	for (const auto &vipGroup : vipGroups) {
		msg.addByte(vipGroup->id);
		msg.addString(vipGroup->name);
		msg.addByte(vipGroup->customizable ? 0x01 : 0x00); // 0x00 = not Customizable, 0x01 = Customizable
	}
	msg.addByte(player->vip()->getMaxGroupEntries() - vipGroups.size()); // max vip groups

	writeToOutputBuffer(msg);
}

void ProtocolGame::sendSpellCooldown(uint16_t spellId, uint32_t time) {
	NetworkMessage msg;
	msg.addByte(0xA4);
	if (oldProtocol && spellId >= 170) {
		msg.addByte(170);
	} else {
		if (oldProtocol) {
			msg.addByte(spellId);
		} else {
			msg.add<uint16_t>(spellId);
		}
	}
	msg.add<uint32_t>(time);
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendSpellGroupCooldown(SpellGroup_t groupId, uint32_t time) {
	if (oldProtocol) {
		return;
	}

	NetworkMessage msg;
	msg.addByte(0xA5);
	msg.addByte(groupId);
	msg.add<uint32_t>(time);
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendUseItemCooldown(uint32_t time) {
	if (!player || oldProtocol) {
		return;
	}

	NetworkMessage msg;
	msg.addByte(0xA6);
	msg.add<uint32_t>(time);
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendPreyTimeLeft(const std::unique_ptr<PreySlot> &slot) {
	if (!player || !slot) {
		return;
	}

	NetworkMessage msg;

	msg.addByte(0xE7);
	msg.addByte(static_cast<uint8_t>(slot->id));
	msg.add<uint16_t>(slot->bonusTimeLeft);

	writeToOutputBuffer(msg);
}

void ProtocolGame::sendPreyData(const std::unique_ptr<PreySlot> &slot) {
	if (!player) {
		return;
	}

	NetworkMessage msg;
	msg.addByte(0xE8);
	std::vector<uint16_t> validRaceIds;
	for (auto raceId : slot->raceIdList) {
		if (g_monsters().getMonsterTypeByRaceId(raceId)) {
			validRaceIds.emplace_back(raceId);
		} else {
			g_logger().error("[ProtocolGame::sendPreyData] - Unknown monster type raceid: {}, removing prey slot from player {}", raceId, player->getName());
			// Remove wrong raceid from slot
			slot->removeMonsterType(raceId);
			// Send empty bytes (do not debug client)
			msg.addByte(0);
			msg.addByte(1);
			msg.add<uint32_t>(0);
			msg.addByte(0);
			writeToOutputBuffer(msg);
			return;
		}
	}

	msg.addByte(static_cast<uint8_t>(slot->id));
	msg.addByte(static_cast<uint8_t>(slot->state));

	if (slot->state == PreyDataState_Locked) {
		msg.addByte(player->isPremium() ? 0x01 : 0x00);
	} else if (slot->state == PreyDataState_Inactive) {
		// Empty
	} else if (slot->state == PreyDataState_Active) {
		if (const auto mtype = g_monsters().getMonsterTypeByRaceId(slot->selectedRaceId)) {
			msg.addString(mtype->name);
			const Outfit_t outfit = mtype->info.outfit;
			msg.add<uint16_t>(outfit.lookType);
			if (outfit.lookType == 0) {
				msg.add<uint16_t>(outfit.lookTypeEx);
			} else {
				msg.addByte(outfit.lookHead);
				msg.addByte(outfit.lookBody);
				msg.addByte(outfit.lookLegs);
				msg.addByte(outfit.lookFeet);
				msg.addByte(outfit.lookAddons);
			}

			msg.addByte(static_cast<uint8_t>(slot->bonus));
			msg.add<uint16_t>(slot->bonusPercentage);
			msg.addByte(slot->bonusRarity);
			msg.add<uint16_t>(slot->bonusTimeLeft);
		}
	} else if (slot->state == PreyDataState_Selection) {
		msg.addByte(static_cast<uint8_t>(validRaceIds.size()));
		for (uint16_t raceId : validRaceIds) {
			const auto mtype = g_monsters().getMonsterTypeByRaceId(raceId);
			if (!mtype) {
				continue;
			}

			msg.addString(mtype->name);
			const Outfit_t outfit = mtype->info.outfit;
			msg.add<uint16_t>(outfit.lookType);
			if (outfit.lookType == 0) {
				msg.add<uint16_t>(outfit.lookTypeEx);
				continue;
			}

			msg.addByte(outfit.lookHead);
			msg.addByte(outfit.lookBody);
			msg.addByte(outfit.lookLegs);
			msg.addByte(outfit.lookFeet);
			msg.addByte(outfit.lookAddons);
		}
	} else if (slot->state == PreyDataState_SelectionChangeMonster) {
		msg.addByte(static_cast<uint8_t>(slot->bonus));
		msg.add<uint16_t>(slot->bonusPercentage);
		msg.addByte(slot->bonusRarity);
		msg.addByte(static_cast<uint8_t>(validRaceIds.size()));
		for (uint16_t raceId : validRaceIds) {
			const auto mtype = g_monsters().getMonsterTypeByRaceId(raceId);
			if (!mtype) {
				continue;
			}

			msg.addString(mtype->name);
			const Outfit_t outfit = mtype->info.outfit;
			msg.add<uint16_t>(outfit.lookType);
			if (outfit.lookType == 0) {
				msg.add<uint16_t>(outfit.lookTypeEx);
				continue;
			}

			msg.addByte(outfit.lookHead);
			msg.addByte(outfit.lookBody);
			msg.addByte(outfit.lookLegs);
			msg.addByte(outfit.lookFeet);
			msg.addByte(outfit.lookAddons);
		}
	} else if (slot->state == PreyDataState_ListSelection) {
		const std::map<uint16_t, std::string> bestiaryList = g_game().getBestiaryList();
		msg.add<uint16_t>(static_cast<uint16_t>(bestiaryList.size()));
		std::for_each(bestiaryList.begin(), bestiaryList.end(), [&msg](auto mType) {
			msg.add<uint16_t>(mType.first);
		});
	} else {
		g_logger().warn("[ProtocolGame::sendPreyData] - Unknown prey state: {}", fmt::underlying(slot->state));
		return;
	}

	if (oldProtocol) {
		auto currentTime = OTSYS_TIME();
		auto timeDiffMs = (slot->freeRerollTimeStamp > currentTime) ? (slot->freeRerollTimeStamp - currentTime) : 0;
		auto timeDiffMinutes = timeDiffMs / 60000;
		msg.add<uint16_t>(timeDiffMinutes ? timeDiffMinutes : 0);
	} else {
		msg.add<uint32_t>(std::max<uint32_t>(static_cast<uint32_t>(((slot->freeRerollTimeStamp - OTSYS_TIME()) / 1000)), 0));
		msg.addByte(static_cast<uint8_t>(slot->option));
	}

	writeToOutputBuffer(msg);
}

void ProtocolGame::sendPreyPrices() {
	if (!player) {
		return;
	}

	NetworkMessage msg;

	msg.addByte(0xE9);
	msg.add<uint32_t>(player->getPreyRerollPrice());
	if (!oldProtocol) {
		msg.addByte(static_cast<uint8_t>(g_configManager().getNumber(PREY_BONUS_REROLL_PRICE)));
		msg.addByte(static_cast<uint8_t>(g_configManager().getNumber(PREY_SELECTION_LIST_PRICE)));
		msg.add<uint32_t>(player->getTaskHuntingRerollPrice());
		msg.add<uint32_t>(player->getTaskHuntingRerollPrice());
		msg.addByte(static_cast<uint8_t>(g_configManager().getNumber(TASK_HUNTING_SELECTION_LIST_PRICE)));
		msg.addByte(static_cast<uint8_t>(g_configManager().getNumber(TASK_HUNTING_BONUS_REROLL_PRICE)));
	}

	writeToOutputBuffer(msg);
}

void ProtocolGame::sendModalWindow(const ModalWindow &modalWindow) {
	if (!player) {
		return;
	}

	NetworkMessage msg;
	msg.addByte(0xFA);

	msg.add<uint32_t>(modalWindow.id);
	msg.addString(modalWindow.title);
	msg.addString(modalWindow.message);

	msg.addByte(modalWindow.buttons.size());
	for (const auto &it : modalWindow.buttons) {
		msg.addString(it.first);
		msg.addByte(it.second);
	}

	msg.addByte(modalWindow.choices.size());
	for (const auto &it : modalWindow.choices) {
		msg.addString(it.first);
		msg.addByte(it.second);
	}

	msg.addByte(modalWindow.defaultEscapeButton);
	msg.addByte(modalWindow.defaultEnterButton);
	msg.addByte(modalWindow.priority ? 0x01 : 0x00);

	writeToOutputBuffer(msg);
}

////////////// Add common messages
void ProtocolGame::AddCreature(NetworkMessage &msg, const std::shared_ptr<Creature> &creature, bool known, uint32_t remove) {
	CreatureType_t creatureType = creature->getType();
	std::shared_ptr<Player> otherPlayer = creature->getPlayer();

	if (known) {
		msg.add<uint16_t>(0x62);
		msg.add<uint32_t>(creature->getID());
	} else {
		msg.add<uint16_t>(0x61);
		msg.add<uint32_t>(remove);
		msg.add<uint32_t>(creature->getID());
		if (!oldProtocol && creature->isHealthHidden()) {
			msg.addByte(CREATURETYPE_HIDDEN);
		} else {
			msg.addByte(creatureType);
		}

		if (!oldProtocol && creatureType == CREATURETYPE_SUMMON_PLAYER) {
			if (std::shared_ptr<Creature> master = creature->getMaster()) {
				msg.add<uint32_t>(master->getID());
			} else {
				msg.add<uint32_t>(0x00);
			}
		}

		if (!oldProtocol && creature->isHealthHidden()) {
			msg.addString(std::string());
		} else {
			msg.addString(creature->getName());
		}
	}

	if (creature->isHealthHidden()) {
		msg.addByte(0x00);
	} else {
		msg.addByte(std::ceil((static_cast<double>(creature->getHealth()) / std::max<int32_t>(creature->getMaxHealth(), 1)) * 100));
	}

	msg.addByte(creature->getDirection());

	if (!creature->isInGhostMode() && !creature->isInvisible()) {
		const Outfit_t &outfit = creature->getCurrentOutfit();
		AddOutfit(msg, outfit);
		if (!oldProtocol && outfit.lookMount != 0) {
			msg.addByte(outfit.lookMountHead);
			msg.addByte(outfit.lookMountBody);
			msg.addByte(outfit.lookMountLegs);
			msg.addByte(outfit.lookMountFeet);
		}
	} else {
		static Outfit_t outfit;
		AddOutfit(msg, outfit);
	}

	LightInfo lightInfo = creature->getCreatureLight();
	msg.addByte(player->isAccessPlayer() ? 0xFF : lightInfo.level);
	msg.addByte(lightInfo.color);

	msg.add<uint16_t>(creature->getStepSpeed());

	addCreatureIcon(msg, creature);

	msg.addByte(player->getSkullClient(creature));
	msg.addByte(player->getPartyShield(otherPlayer));

	if (!known) {
		msg.addByte(player->getGuildEmblem(otherPlayer));
	}

	if (!oldProtocol && creatureType == CREATURETYPE_MONSTER) {
		if (std::shared_ptr<Creature> master = creature->getMaster()) {
			if (std::shared_ptr<Player> masterPlayer = master->getPlayer()) {
				creatureType = CREATURETYPE_SUMMON_PLAYER;
			}
		}
	}

	if (!oldProtocol && creature->isHealthHidden()) {
		msg.addByte(CREATURETYPE_HIDDEN);
	} else {
		msg.addByte(creatureType); // Type (for summons)
	}

	if (!oldProtocol && creatureType == CREATURETYPE_SUMMON_PLAYER) {
		if (std::shared_ptr<Creature> master = creature->getMaster()) {
			msg.add<uint32_t>(master->getID());
		} else {
			msg.add<uint32_t>(0x00);
		}
	}

	if (!oldProtocol && creatureType == CREATURETYPE_PLAYER) {
		if (std::shared_ptr<Player> otherCreature = creature->getPlayer()) {
			msg.addByte(otherCreature->getVocation()->getClientId());
		} else {
			msg.addByte(0);
		}
	}

	auto bubble = creature->getSpeechBubble();
	msg.addByte(oldProtocol && bubble == SPEECHBUBBLE_HIRELING ? static_cast<uint8_t>(SPEECHBUBBLE_NONE) : bubble);
	msg.addByte(0xFF); // MARK_UNMARKED
	if (!oldProtocol) {
		msg.addByte(0x00); // inspection type
	} else {
		if (otherPlayer) {
			msg.add<uint16_t>(otherPlayer->getHelpers());
		} else {
			msg.add<uint16_t>(0x00);
		}
	}

	msg.addByte(player->canWalkthroughEx(creature) ? 0x00 : 0x01);
}

void ProtocolGame::AddPlayerStats(NetworkMessage &msg) {
	msg.addByte(0xA0);

	if (oldProtocol) {
		msg.add<uint16_t>(std::min<int32_t>(player->getHealth(), std::numeric_limits<uint16_t>::max()));
		msg.add<uint16_t>(std::min<int32_t>(player->getMaxHealth(), std::numeric_limits<uint16_t>::max()));
	} else {
		msg.add<uint32_t>(std::min<int32_t>(player->getHealth(), std::numeric_limits<int32_t>::max()));
		msg.add<uint32_t>(std::min<int32_t>(player->getMaxHealth(), std::numeric_limits<int32_t>::max()));
	}

	msg.add<uint32_t>(player->hasFlag(PlayerFlags_t::HasInfiniteCapacity) ? 1000000 : player->getFreeCapacity());
	if (oldProtocol) {
		msg.add<uint32_t>(player->getFreeCapacity());
	}

	msg.add<uint64_t>(player->getExperience());

	msg.add<uint16_t>(player->getLevel());
	msg.addByte(std::min<uint8_t>(player->getLevelPercent(), 100));

	msg.add<uint16_t>(player->getBaseXpGain()); // base xp gain rate

	if (oldProtocol) {
		msg.add<uint16_t>(player->getVoucherXpBoost()); // xp voucher
	}

	msg.add<uint16_t>(player->getGrindingXpBoost()); // low level bonus
	msg.add<uint16_t>(player->getXpBoostPercent()); // xp boost
	msg.add<uint16_t>(player->getStaminaXpBoost()); // stamina multiplier (100 = 1.0x)

	if (!oldProtocol) {
		msg.add<uint32_t>(std::min<int32_t>(player->getMana(), std::numeric_limits<int32_t>::max()));
		msg.add<uint32_t>(std::min<int32_t>(player->getMaxMana(), std::numeric_limits<int32_t>::max()));
	} else {
		msg.add<uint16_t>(std::min<int32_t>(player->getMana(), std::numeric_limits<uint16_t>::max()));
		msg.add<uint16_t>(std::min<int32_t>(player->getMaxMana(), std::numeric_limits<uint16_t>::max()));

		msg.addByte(static_cast<uint8_t>(std::min<uint32_t>(player->getMagicLevel(), std::numeric_limits<uint8_t>::max())));
		msg.addByte(static_cast<uint8_t>(std::min<uint32_t>(player->getBaseMagicLevel(), std::numeric_limits<uint8_t>::max())));
		msg.addByte(std::min<uint8_t>(static_cast<uint8_t>(player->getMagicLevelPercent()), 100));
	}

	msg.addByte(player->getSoul());

	msg.add<uint16_t>(player->getStaminaMinutes());

	msg.add<uint16_t>(player->getBaseSpeed());

	std::shared_ptr<Condition> condition = player->getCondition(CONDITION_REGENERATION, CONDITIONID_DEFAULT);
	msg.add<uint16_t>(condition ? condition->getTicks() / 1000 : 0x00);

	msg.add<uint16_t>(player->getOfflineTrainingTime() / 60 / 1000);

	msg.add<uint16_t>(player->getXpBoostTime()); // xp boost time (seconds)
	msg.addByte(1); // enables exp boost in the store

	if (!oldProtocol) {
		msg.add<uint32_t>(player->getManaShield()); // remaining mana shield
		msg.add<uint32_t>(player->getMaxManaShield()); // total mana shield
	}
}

void ProtocolGame::AddPlayerSkills(NetworkMessage &msg) {
	msg.addByte(0xA1);

	if (oldProtocol) {
		for (uint8_t i = SKILL_FIRST; i <= SKILL_FISHING; ++i) {
			auto skill = static_cast<skills_t>(i);
			msg.add<uint16_t>(std::min<int32_t>(player->getSkillLevel(skill), std::numeric_limits<uint16_t>::max()));
			msg.add<uint16_t>(player->getBaseSkill(skill));
			msg.addByte(std::min<uint8_t>(100, static_cast<uint8_t>(player->getSkillPercent(skill))));
		}
	} else {
		msg.add<uint16_t>(player->getMagicLevel());
		msg.add<uint16_t>(player->getBaseMagicLevel());
		msg.add<uint16_t>(player->getLoyaltyMagicLevel());
		msg.add<uint16_t>(player->getMagicLevelPercent() * 100);

		for (uint8_t i = SKILL_FIRST; i <= SKILL_FISHING; ++i) {
			auto skill = static_cast<skills_t>(i);
			msg.add<uint16_t>(std::min<int32_t>(player->getSkillLevel(skill), std::numeric_limits<uint16_t>::max()));
			msg.add<uint16_t>(player->getBaseSkill(skill));
			msg.add<uint16_t>(player->getLoyaltySkill(skill));
			msg.add<uint16_t>(player->getSkillPercent(skill) * 100);
		}
	}

	for (uint8_t i = SKILL_CRITICAL_HIT_CHANCE; i <= SKILL_LAST; ++i) {
		if (!oldProtocol && (i == SKILL_LIFE_LEECH_CHANCE || i == SKILL_MANA_LEECH_CHANCE)) {
			continue;
		}
		auto skill = static_cast<skills_t>(i);
		msg.add<uint16_t>(std::min<int32_t>(player->getSkillLevel(skill), std::numeric_limits<uint16_t>::max()));
		msg.add<uint16_t>(player->getBaseSkill(skill));
	}

	if (!oldProtocol) {
		// 13.10 list (U8 + U16)
		msg.addByte(0);
		// Version 12.81 new skill (Fatal, Dodge and Momentum)
		sendForgeSkillStats(msg);

		// used for imbuement (Feather)
		msg.add<uint32_t>(player->getCapacity()); // total capacity
		msg.add<uint32_t>(player->getBaseCapacity()); // base total capacity
	}
}

void ProtocolGame::AddOutfit(NetworkMessage &msg, const Outfit_t &outfit, bool addMount /* = true*/) {
	msg.add<uint16_t>(outfit.lookType);
	if (outfit.lookType != 0) {
		msg.addByte(outfit.lookHead);
		msg.addByte(outfit.lookBody);
		msg.addByte(outfit.lookLegs);
		msg.addByte(outfit.lookFeet);
		msg.addByte(outfit.lookAddons);
	} else {
		msg.add<uint16_t>(outfit.lookTypeEx);
	}

	if (addMount) {
		msg.add<uint16_t>(outfit.lookMount);
	}
}

void ProtocolGame::addImbuementInfo(NetworkMessage &msg, uint16_t imbuementId) const {
	Imbuement* imbuement = g_imbuements().getImbuement(imbuementId);
	const BaseImbuement* baseImbuement = g_imbuements().getBaseByID(imbuement->getBaseID());
	const CategoryImbuement* categoryImbuement = g_imbuements().getCategoryByID(imbuement->getCategory());

	msg.add<uint32_t>(imbuementId);
	msg.addString(baseImbuement->name + " " + imbuement->getName());
	msg.addString(imbuement->getDescription());
	msg.addString(categoryImbuement->name + imbuement->getSubGroup());

	msg.add<uint16_t>(imbuement->getIconID());
	msg.add<uint32_t>(baseImbuement->duration);

	msg.addByte(imbuement->isPremium() ? 0x01 : 0x00);

	const auto items = imbuement->getItems();
	msg.addByte(items.size());

	for (const auto &itm : items) {
		const ItemType &it = Item::items[itm.first];
		msg.add<uint16_t>(itm.first);
		msg.addString(it.name);
		msg.add<uint16_t>(itm.second);
	}

	msg.add<uint32_t>(baseImbuement->price);
	msg.addByte(baseImbuement->percent);
	msg.add<uint32_t>(baseImbuement->protectionPrice);
}

void ProtocolGame::openImbuementWindow(const std::shared_ptr<Item> &item) {
	if (!item || item->isRemoved()) {
		return;
	}

	player->setImbuingItem(item);

	NetworkMessage msg;
	msg.addByte(0xEB);
	msg.add<uint16_t>(item->getID());
	if (!oldProtocol && item->getClassification() > 0) {
		msg.addByte(0);
	}
	msg.addByte(item->getImbuementSlot());

	// Send imbuement time
	for (uint8_t slotid = 0; slotid < static_cast<uint8_t>(item->getImbuementSlot()); slotid++) {
		ImbuementInfo imbuementInfo;
		if (!item->getImbuementInfo(slotid, &imbuementInfo)) {
			msg.addByte(0x00);
			continue;
		}

		msg.addByte(0x01);
		addImbuementInfo(msg, imbuementInfo.imbuement->getID());
		msg.add<uint32_t>(imbuementInfo.duration);
		msg.add<uint32_t>(g_imbuements().getBaseByID(imbuementInfo.imbuement->getBaseID())->removeCost);
	}

	std::vector<Imbuement*> imbuements = g_imbuements().getImbuements(player, item);
	phmap::flat_hash_map<uint16_t, uint16_t> needItems;

	msg.add<uint16_t>(imbuements.size());
	for (const Imbuement* imbuement : imbuements) {
		addImbuementInfo(msg, imbuement->getID());

		const auto items = imbuement->getItems();
		for (const auto &itm : items) {
			if (!needItems.count(itm.first)) {
				needItems[itm.first] = player->getItemTypeCount(itm.first);
				uint32_t stashCount = player->getStashItemCount(Item::items[itm.first].id);
				if (stashCount > 0) {
					needItems[itm.first] += stashCount;
				}
			}
		}
	}

	msg.add<uint32_t>(needItems.size());
	for (const auto &itm : needItems) {
		msg.add<uint16_t>(itm.first);
		msg.add<uint16_t>(itm.second);
	}

	sendResourcesBalance(player->getMoney(), player->getBankBalance(), player->getPreyCards(), player->getTaskHuntingPoints());

	writeToOutputBuffer(msg);
}

void ProtocolGame::sendMessageDialog(const std::string &message) {
	NetworkMessage msg;
	msg.addByte(0xED);
	msg.addByte(0x14); // Unknown type
	msg.addString(message);
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendImbuementResult(const std::string &message) {
	NetworkMessage msg;
	msg.addByte(0xED);
	msg.addByte(0x01);
	msg.addString(message);
	writeToOutputBuffer(msg);
}

void ProtocolGame::closeImbuementWindow() {
	NetworkMessage msg;
	msg.addByte(0xEC);
	writeToOutputBuffer(msg);
}

void ProtocolGame::AddWorldLight(NetworkMessage &msg, LightInfo lightInfo) {
	msg.addByte(0x82);
	msg.addByte((player->isAccessPlayer() ? 0xFF : lightInfo.level));
	msg.addByte(lightInfo.color);
}

void ProtocolGame::sendSpecialContainersAvailable() {
	if (oldProtocol || !player) {
		return;
	}

	NetworkMessage msg;
	msg.addByte(0x2A);
	msg.addByte(player->isSupplyStashMenuAvailable() ? 0x01 : 0x00);
	msg.addByte(player->isMarketMenuAvailable() ? 0x01 : 0x00);
	writeToOutputBuffer(msg);
}

void ProtocolGame::updatePartyTrackerAnalyzer(const std::shared_ptr<Party> &party) {
	if (oldProtocol || !player || !party || !party->getLeader()) {
		return;
	}

	NetworkMessage msg;
	msg.addByte(0x2B);
	msg.add<uint32_t>(party->getAnalyzerTimeNow());
	msg.add<uint32_t>(party->getLeader()->getID());
	msg.addByte(static_cast<uint8_t>(party->priceType));

	msg.addByte(static_cast<uint8_t>(party->membersData.size()));
	for (const std::shared_ptr<PartyAnalyzer> &analyzer : party->membersData) {
		msg.add<uint32_t>(analyzer->id);
		if (std::shared_ptr<Player> member = g_game().getPlayerByID(analyzer->id);
		    !member || !member->getParty() || member->getParty() != party) {
			msg.addByte(0);
		} else {
			msg.addByte(1);
		}

		msg.add<uint64_t>(analyzer->lootPrice);
		msg.add<uint64_t>(analyzer->supplyPrice);
		msg.add<uint64_t>(analyzer->damage);
		msg.add<uint64_t>(analyzer->healing);
	}

	bool showNames = !party->membersData.empty();
	msg.addByte(showNames ? 0x01 : 0x00);
	if (showNames) {
		msg.addByte(static_cast<uint8_t>(party->membersData.size()));
		for (const std::shared_ptr<PartyAnalyzer> &analyzer : party->membersData) {
			msg.add<uint32_t>(analyzer->id);
			msg.addString(analyzer->name);
		}
	}

	writeToOutputBuffer(msg);
}

void ProtocolGame::AddCreatureLight(NetworkMessage &msg, const std::shared_ptr<Creature> &creature) {
	LightInfo lightInfo = creature->getCreatureLight();

	msg.addByte(0x8D);
	msg.add<uint32_t>(creature->getID());
	msg.addByte((player->isAccessPlayer() ? 0xFF : lightInfo.level));
	msg.addByte(lightInfo.color);
}

// tile
void ProtocolGame::RemoveTileThing(NetworkMessage &msg, const Position &pos, uint32_t stackpos) {
	if (stackpos >= 10) {
		return;
	}

	msg.addByte(0x6C);
	msg.addPosition(pos);
	msg.addByte(static_cast<uint8_t>(stackpos));
}

void ProtocolGame::sendKillTrackerUpdate(const std::shared_ptr<Container> &corpse, const std::string &name, const Outfit_t creatureOutfit) {
	if (oldProtocol) {
		return;
	}

	bool isCorpseEmpty = corpse->empty();

	NetworkMessage msg;
	msg.addByte(0xD1);
	msg.addString(name);
	msg.add<uint16_t>(creatureOutfit.lookType ? creatureOutfit.lookType : 21);
	msg.addByte(creatureOutfit.lookType ? creatureOutfit.lookHead : 0x00);
	msg.addByte(creatureOutfit.lookType ? creatureOutfit.lookBody : 0x00);
	msg.addByte(creatureOutfit.lookType ? creatureOutfit.lookLegs : 0x00);
	msg.addByte(creatureOutfit.lookType ? creatureOutfit.lookFeet : 0x00);
	msg.addByte(creatureOutfit.lookType ? creatureOutfit.lookAddons : 0x00);
	msg.addByte(isCorpseEmpty ? 0 : corpse->size());

	if (!isCorpseEmpty) {
		for (const auto &it : corpse->getItemList()) {
			AddItem(msg, it);
		}
	}

	writeToOutputBuffer(msg);
}

void ProtocolGame::sendUpdateSupplyTracker(const std::shared_ptr<Item> &item) {
	if (oldProtocol || !player || !item) {
		return;
	}

	NetworkMessage msg;
	msg.addByte(0xCE);
	msg.add<uint16_t>(item->getID());

	writeToOutputBuffer(msg);
}

void ProtocolGame::sendUpdateImpactTracker(CombatType_t type, int32_t amount) {
	if (!player || oldProtocol) {
		return;
	}

	auto clientElement = getCipbiaElement(type);
	if (clientElement == CIPBIA_ELEMENTAL_UNDEFINED) {
		return;
	}

	NetworkMessage msg;
	msg.addByte(0xCC);
	if (type == COMBAT_HEALING) {
		msg.addByte(ANALYZER_HEAL);
		msg.add<uint32_t>(amount);
	} else {
		msg.addByte(ANALYZER_DAMAGE_DEALT);
		msg.add<uint32_t>(amount);
		msg.addByte(clientElement);
	}
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendUpdateInputAnalyzer(CombatType_t type, int32_t amount, const std::string &target) {
	if (!player || oldProtocol) {
		return;
	}

	auto clientElement = getCipbiaElement(type);
	if (clientElement == CIPBIA_ELEMENTAL_UNDEFINED) {
		return;
	}

	NetworkMessage msg;
	msg.addByte(0xCC);
	msg.addByte(ANALYZER_DAMAGE_RECEIVED);
	msg.add<uint32_t>(amount);
	msg.addByte(clientElement);
	msg.addString(target);
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendTaskHuntingData(const std::unique_ptr<TaskHuntingSlot> &slot) {
	if (!player || oldProtocol) {
		return;
	}

	NetworkMessage msg;
	msg.addByte(0xBB);
	msg.addByte(static_cast<uint8_t>(slot->id));
	msg.addByte(static_cast<uint8_t>(slot->state));
	if (slot->state == PreyTaskDataState_Locked) {
		msg.addByte(player->isPremium() ? 0x01 : 0x00);
	} else if (slot->state == PreyTaskDataState_Inactive) {
		// Empty
	} else if (slot->state == PreyTaskDataState_Selection) {
		std::shared_ptr<Player> user = player;
		msg.add<uint16_t>(static_cast<uint16_t>(slot->raceIdList.size()));
		std::for_each(slot->raceIdList.begin(), slot->raceIdList.end(), [&msg, user](uint16_t raceid) {
			msg.add<uint16_t>(raceid);
			msg.addByte(user->isCreatureUnlockedOnTaskHunting(g_monsters().getMonsterTypeByRaceId(raceid)) ? 0x01 : 0x00);
		});
	} else if (slot->state == PreyTaskDataState_ListSelection) {
		std::shared_ptr<Player> user = player;
		const std::map<uint16_t, std::string> bestiaryList = g_game().getBestiaryList();
		msg.add<uint16_t>(static_cast<uint16_t>(bestiaryList.size()));
		std::for_each(bestiaryList.begin(), bestiaryList.end(), [&msg, user](auto mType) {
			msg.add<uint16_t>(mType.first);
			msg.addByte(user->isCreatureUnlockedOnTaskHunting(g_monsters().getMonsterType(mType.second)) ? 0x01 : 0x00);
		});
	} else if (slot->state == PreyTaskDataState_Active) {
		if (const auto &option = g_ioprey().getTaskRewardOption(slot)) {
			msg.add<uint16_t>(slot->selectedRaceId);
			if (slot->upgrade) {
				msg.addByte(0x01);
				msg.add<uint16_t>(option->secondKills);
			} else {
				msg.addByte(0x00);
				msg.add<uint16_t>(option->firstKills);
			}
			msg.add<uint16_t>(slot->currentKills);
			msg.addByte(slot->rarity);
		} else {
			g_logger().warn("[ProtocolGame::sendTaskHuntingData] - Unknown slot option {} on player {}", fmt::underlying(slot->id), player->getName());
			return;
		}
	} else if (slot->state == PreyTaskDataState_Completed) {
		if (const auto &option = g_ioprey().getTaskRewardOption(slot)) {
			msg.add<uint16_t>(slot->selectedRaceId);
			if (slot->upgrade) {
				msg.addByte(0x01);
				msg.add<uint16_t>(option->secondKills);
				msg.add<uint16_t>(std::min<uint16_t>(slot->currentKills, option->secondKills));
			} else {
				msg.addByte(0x00);
				msg.add<uint16_t>(option->firstKills);
				msg.add<uint16_t>(std::min<uint16_t>(slot->currentKills, option->firstKills));
			}
			msg.addByte(slot->rarity);
		} else {
			g_logger().warn("[ProtocolGame::sendTaskHuntingData] - Unknown slot option {} on player {}", fmt::underlying(slot->id), player->getName());
			return;
		}
	} else {
		g_logger().warn("[ProtocolGame::sendTaskHuntingData] - Unknown task hunting state: {}", fmt::underlying(slot->state));
		return;
	}

	msg.add<uint32_t>(std::max<uint32_t>(static_cast<uint32_t>(((slot->freeRerollTimeStamp - OTSYS_TIME()) / 1000)), 0));
	writeToOutputBuffer(msg);
}

void ProtocolGame::MoveUpCreature(NetworkMessage &msg, const std::shared_ptr<Creature> &creature, const Position &newPos, const Position &oldPos) {
	if (creature != player) {
		return;
	}

	// floor change up
	msg.addByte(0xBE);

	// going to surface
	if (newPos.z == MAP_INIT_SURFACE_LAYER) {
		int32_t skip = -1;
		GetFloorDescription(msg, oldPos.x - MAP_MAX_CLIENT_VIEW_PORT_X, oldPos.y - MAP_MAX_CLIENT_VIEW_PORT_Y, 5, (MAP_MAX_CLIENT_VIEW_PORT_X + 1) * 2, (MAP_MAX_CLIENT_VIEW_PORT_Y + 1) * 2, 3, skip); //(floor 7 and 6 already set)
		GetFloorDescription(msg, oldPos.x - MAP_MAX_CLIENT_VIEW_PORT_X, oldPos.y - MAP_MAX_CLIENT_VIEW_PORT_Y, 4, (MAP_MAX_CLIENT_VIEW_PORT_X + 1) * 2, (MAP_MAX_CLIENT_VIEW_PORT_Y + 1) * 2, 4, skip);
		GetFloorDescription(msg, oldPos.x - MAP_MAX_CLIENT_VIEW_PORT_X, oldPos.y - MAP_MAX_CLIENT_VIEW_PORT_Y, 3, (MAP_MAX_CLIENT_VIEW_PORT_X + 1) * 2, (MAP_MAX_CLIENT_VIEW_PORT_Y + 1) * 2, 5, skip);
		GetFloorDescription(msg, oldPos.x - MAP_MAX_CLIENT_VIEW_PORT_X, oldPos.y - MAP_MAX_CLIENT_VIEW_PORT_Y, 2, (MAP_MAX_CLIENT_VIEW_PORT_X + 1) * 2, (MAP_MAX_CLIENT_VIEW_PORT_Y + 1) * 2, 6, skip);
		GetFloorDescription(msg, oldPos.x - MAP_MAX_CLIENT_VIEW_PORT_X, oldPos.y - MAP_MAX_CLIENT_VIEW_PORT_Y, 1, (MAP_MAX_CLIENT_VIEW_PORT_X + 1) * 2, (MAP_MAX_CLIENT_VIEW_PORT_Y + 1) * 2, 7, skip);
		GetFloorDescription(msg, oldPos.x - MAP_MAX_CLIENT_VIEW_PORT_X, oldPos.y - MAP_MAX_CLIENT_VIEW_PORT_Y, 0, (MAP_MAX_CLIENT_VIEW_PORT_X + 1) * 2, (MAP_MAX_CLIENT_VIEW_PORT_Y + 1) * 2, 8, skip);

		if (skip >= 0) {
			msg.addByte(skip);
			msg.addByte(0xFF);
		}
	}
	// underground, going one floor up (still underground)
	else if (newPos.z > MAP_INIT_SURFACE_LAYER) {
		int32_t skip = -1;
		GetFloorDescription(msg, oldPos.x - MAP_MAX_CLIENT_VIEW_PORT_X, oldPos.y - MAP_MAX_CLIENT_VIEW_PORT_Y, oldPos.getZ() - 3, (MAP_MAX_CLIENT_VIEW_PORT_X + 1) * 2, (MAP_MAX_CLIENT_VIEW_PORT_Y + 1) * 2, 3, skip);

		if (skip >= 0) {
			msg.addByte(skip);
			msg.addByte(0xFF);
		}
	}

	// moving up a floor up makes us out of sync
	// west
	msg.addByte(0x68);
	GetMapDescription(oldPos.x - MAP_MAX_CLIENT_VIEW_PORT_X, oldPos.y - (MAP_MAX_CLIENT_VIEW_PORT_Y - 1), newPos.z, 1, (MAP_MAX_CLIENT_VIEW_PORT_Y + 1) * 2, msg);

	// north
	msg.addByte(0x65);
	GetMapDescription(oldPos.x - MAP_MAX_CLIENT_VIEW_PORT_X, oldPos.y - MAP_MAX_CLIENT_VIEW_PORT_Y, newPos.z, (MAP_MAX_CLIENT_VIEW_PORT_X + 1) * 2, 1, msg);
}

void ProtocolGame::MoveDownCreature(NetworkMessage &msg, const std::shared_ptr<Creature> &creature, const Position &newPos, const Position &oldPos) {
	if (creature != player) {
		return;
	}

	// floor change down
	msg.addByte(0xBF);

	// going from surface to underground
	if (newPos.z == MAP_INIT_SURFACE_LAYER + 1) {
		int32_t skip = -1;

		GetFloorDescription(msg, oldPos.x - MAP_MAX_CLIENT_VIEW_PORT_X, oldPos.y - MAP_MAX_CLIENT_VIEW_PORT_Y, newPos.z, (MAP_MAX_CLIENT_VIEW_PORT_X + 1) * 2, (MAP_MAX_CLIENT_VIEW_PORT_Y + 1) * 2, -1, skip);
		GetFloorDescription(msg, oldPos.x - MAP_MAX_CLIENT_VIEW_PORT_X, oldPos.y - MAP_MAX_CLIENT_VIEW_PORT_Y, newPos.z + 1, (MAP_MAX_CLIENT_VIEW_PORT_X + 1) * 2, (MAP_MAX_CLIENT_VIEW_PORT_Y + 1) * 2, -2, skip);
		GetFloorDescription(msg, oldPos.x - MAP_MAX_CLIENT_VIEW_PORT_X, oldPos.y - MAP_MAX_CLIENT_VIEW_PORT_Y, newPos.z + 2, (MAP_MAX_CLIENT_VIEW_PORT_X + 1) * 2, (MAP_MAX_CLIENT_VIEW_PORT_Y + 1) * 2, -3, skip);

		if (skip >= 0) {
			msg.addByte(skip);
			msg.addByte(0xFF);
		}
	}
	// going further down
	else if (newPos.z > oldPos.z && newPos.z > MAP_INIT_SURFACE_LAYER + 1 && newPos.z < MAP_MAX_LAYERS - MAP_LAYER_VIEW_LIMIT) {
		int32_t skip = -1;
		GetFloorDescription(msg, oldPos.x - MAP_MAX_CLIENT_VIEW_PORT_X, oldPos.y - MAP_MAX_CLIENT_VIEW_PORT_Y, newPos.z + MAP_LAYER_VIEW_LIMIT, (MAP_MAX_CLIENT_VIEW_PORT_X + 1) * 2, (MAP_MAX_CLIENT_VIEW_PORT_Y + 1) * 2, -3, skip);

		if (skip >= 0) {
			msg.addByte(skip);
			msg.addByte(0xFF);
		}
	}

	// moving down a floor makes us out of sync
	// east
	msg.addByte(0x66);
	GetMapDescription(oldPos.x + MAP_MAX_CLIENT_VIEW_PORT_X + 1, oldPos.y - (MAP_MAX_CLIENT_VIEW_PORT_Y + 1), newPos.z, 1, ((MAP_MAX_CLIENT_VIEW_PORT_Y + 1) * 2), msg);

	// south
	msg.addByte(0x67);
	GetMapDescription(oldPos.x - MAP_MAX_CLIENT_VIEW_PORT_X, oldPos.y + (MAP_MAX_CLIENT_VIEW_PORT_Y + 1), newPos.z, ((MAP_MAX_CLIENT_VIEW_PORT_X + 1) * 2), 1, msg);
}

void ProtocolGame::AddHiddenShopItem(NetworkMessage &msg) {
	// Empty bytes from AddShopItem
	msg.add<uint16_t>(0);
	msg.addByte(0);
	msg.addString(std::string());
	msg.add<uint32_t>(0);
	msg.add<uint32_t>(0);
	msg.add<uint32_t>(0);
}

void ProtocolGame::AddShopItem(NetworkMessage &msg, const ShopBlock &shopBlock) {
	// Sends the item information empty if the player doesn't have the storage to buy/sell a certain item
	if (shopBlock.itemStorageKey != 0 && player->getStorageValue(shopBlock.itemStorageKey) < shopBlock.itemStorageValue) {
		AddHiddenShopItem(msg);
		return;
	}

	const ItemType &it = Item::items[shopBlock.itemId];
	msg.add<uint16_t>(shopBlock.itemId);
	if (it.isSplash() || it.isFluidContainer()) {
		msg.addByte(static_cast<uint8_t>(shopBlock.itemSubType));
	} else {
		msg.addByte(0x00);
	}

	// If not send "itemName" variable from the npc shop, will registered the name that is in items.xml
	if (shopBlock.itemName.empty()) {
		msg.addString(it.name);
	} else {
		msg.addString(shopBlock.itemName);
	}
	msg.add<uint32_t>(it.weight);
	msg.add<uint32_t>(shopBlock.itemBuyPrice == 4294967295 ? 0 : shopBlock.itemBuyPrice);
	msg.add<uint32_t>(shopBlock.itemSellPrice == 4294967295 ? 0 : shopBlock.itemSellPrice);
}

void ProtocolGame::parseExtendedOpcode(NetworkMessage &msg) {
	uint8_t opcode = msg.getByte();
	const std::string &buffer = msg.getString();

	// process additional opcodes via lua script event
	g_game().parsePlayerExtendedOpcode(player->getID(), opcode, buffer);
}

// OTCv8
void ProtocolGame::sendFeatures() {
	if (otclientV8 == 0) {
		return;
	}

	std::map<GameFeature_t, bool> features;
	// Place for non-standard OTCv8 features
	features[GameFeature_t::ExtendedOpcode] = true;

	if (features.empty()) {
		return;
	}

	NetworkMessage msg;
	msg.addByte(0x43);
	msg.add<uint16_t>(static_cast<uint16_t>(features.size()));
	for (const auto &[gameFeature, haveFeature] : features) {
		msg.addByte(static_cast<uint8_t>(gameFeature));
		msg.addByte(haveFeature ? 1 : 0);
	}
	writeToOutputBuffer(msg);
}

void ProtocolGame::parseInventoryImbuements(NetworkMessage &msg) {
	if (oldProtocol) {
		return;
	}

	bool isTrackerOpen = msg.getByte(); // Window is opened or closed
	g_game().playerRequestInventoryImbuements(player->getID(), isTrackerOpen);
}

void ProtocolGame::sendInventoryImbuements(const std::map<Slots_t, std::shared_ptr<Item>> &items) {
	if (oldProtocol) {
		return;
	}

	NetworkMessage msg;
	msg.addByte(0x5D);

	msg.addByte(static_cast<uint8_t>(items.size()));
	for (const auto &[slot, item] : items) {
		msg.addByte(slot);
		AddItem(msg, item);

		uint8_t slots = item->getImbuementSlot();
		msg.addByte(slots);
		if (slots == 0) {
			continue;
		}

		for (uint8_t imbueSlot = 0; imbueSlot < slots; imbueSlot++) {
			ImbuementInfo imbuementInfo;
			if (!item->getImbuementInfo(imbueSlot, &imbuementInfo)) {
				msg.addByte(0x00);
				continue;
			}

			auto imbuement = imbuementInfo.imbuement;
			if (!imbuement) {
				msg.addByte(0x00);
				continue;
			}

			const BaseImbuement* baseImbuement = g_imbuements().getBaseByID(imbuement->getBaseID());
			msg.addByte(0x01);
			msg.addString(baseImbuement->name + " " + imbuement->getName());
			msg.add<uint16_t>(imbuement->getIconID());
			msg.add<uint32_t>(imbuementInfo.duration);

			std::shared_ptr<Tile> playerTile = player->getTile();
			// Check if the player is in a protection zone
			bool isInProtectionZone = playerTile && playerTile->hasFlag(TILESTATE_PROTECTIONZONE);
			// Check if the player is in fight mode
			bool isInFightMode = player->hasCondition(CONDITION_INFIGHT);
			// Get the category of the imbuement
			const CategoryImbuement* categoryImbuement = g_imbuements().getCategoryByID(imbuement->getCategory());
			// Parent of the imbued item
			auto parent = item->getParent();
			// If the imbuement is aggressive and the player is not in fight mode or is in a protection zone, or the item is in a container, ignore it.
			if (categoryImbuement && categoryImbuement->agressive && (isInProtectionZone || !isInFightMode)) {
				msg.addByte(0);
				continue;
			}
			// If the item is not in the backpack slot and it's not a agressive imbuement, ignore it.
			if (categoryImbuement && !categoryImbuement->agressive && parent && parent != player) {
				msg.addByte(0);
				continue;
			}

			msg.addByte(1);
		}
	}

	writeToOutputBuffer(msg);
}

void ProtocolGame::sendItemsPrice() {
	if (!player || oldProtocol) {
		return;
	}

	NetworkMessage msg;
	msg.addByte(0xCD);

	auto countBuffer = msg.getBufferPosition();
	uint16_t count = 0;
	msg.skipBytes(2);
	for (const auto &[itemId, tierAndPriceMap] : g_game().getItemsPrice()) {
		for (const auto &[tier, price] : tierAndPriceMap) {
			msg.add<uint16_t>(itemId);
			if (Item::items[itemId].upgradeClassification > 0) {
				msg.addByte(tier);
			}
			msg.add<uint64_t>(price);
			count++;
		}
	}
	msg.setBufferPosition(countBuffer);
	msg.add<uint16_t>(count);

	writeToOutputBuffer(msg);
}

void ProtocolGame::reloadCreature(const std::shared_ptr<Creature> &creature) {
	if (!creature || !canSee(creature)) {
		return;
	}

	auto tile = creature->getTile();
	if (!tile) {
		return;
	}

	uint32_t stackpos = tile->getClientIndexOfCreature(player, creature);

	if (stackpos >= 10) {
		return;
	}

	NetworkMessage msg;

	if (knownCreatureSet.contains(creature->getID())) {
		msg.addByte(0x6B);
		msg.addPosition(creature->getPosition());
		msg.addByte(static_cast<uint8_t>(stackpos));
		AddCreature(msg, creature, false, 0);
	} else {
		sendAddCreature(creature, creature->getPosition(), stackpos, false);
	}

	writeToOutputBuffer(msg);
}

void ProtocolGame::sendOpenStash() {
	if (!player || oldProtocol) {
		return;
	}

	NetworkMessage msg;
	msg.addByte(0x29);
	StashItemList list = player->getStashItems();
	msg.add<uint16_t>(list.size());
	for (auto item : list) {
		msg.add<uint16_t>(item.first);
		msg.add<uint32_t>(item.second);
	}
	msg.add<uint16_t>(static_cast<uint16_t>(g_configManager().getNumber(STASH_ITEMS) - getStashSize(list)));
	writeToOutputBuffer(msg);
}

void ProtocolGame::parseStashWithdraw(NetworkMessage &msg) {
	if (oldProtocol) {
		return;
	}

	if (!player->isSupplyStashMenuAvailable()) {
		player->sendCancelMessage("You can't use supply stash right now.");
		return;
	}

	if (player->isUIExhausted(500)) {
		player->sendCancelMessage("You need to wait to do this again.");
		return;
	}

	auto action = static_cast<Supply_Stash_Actions_t>(msg.getByte());
	switch (action) {
		case SUPPLY_STASH_ACTION_STOW_ITEM: {
			Position pos = msg.getPosition();
			auto itemId = msg.get<uint16_t>();
			uint8_t stackpos = msg.getByte();
			uint32_t count = msg.getByte();
			g_game().playerStowItem(player->getID(), pos, itemId, stackpos, count, false);
			break;
		}
		case SUPPLY_STASH_ACTION_STOW_CONTAINER: {
			Position pos = msg.getPosition();
			auto itemId = msg.get<uint16_t>();
			uint8_t stackpos = msg.getByte();
			g_game().playerStowItem(player->getID(), pos, itemId, stackpos, 0, false);
			break;
		}
		case SUPPLY_STASH_ACTION_STOW_STACK: {
			Position pos = msg.getPosition();
			auto itemId = msg.get<uint16_t>();
			uint8_t stackpos = msg.getByte();
			g_game().playerStowItem(player->getID(), pos, itemId, stackpos, 0, true);
			break;
		}
		case SUPPLY_STASH_ACTION_WITHDRAW: {
			auto itemId = msg.get<uint16_t>();
			auto count = msg.get<uint32_t>();
			uint8_t stackpos = msg.getByte();
			g_game().playerStashWithdraw(player->getID(), itemId, count, stackpos);
			break;
		}
		default:
			g_logger().error("Unknown 'supply stash' action switch: {}", fmt::underlying(action));
			break;
	}

	player->updateUIExhausted();
}

void ProtocolGame::sendCreatureHelpers(uint32_t creatureId, uint16_t helpers) {
	if (!oldProtocol) {
		return;
	}

	NetworkMessage msg;
	msg.addByte(0x94);
	msg.add<uint32_t>(creatureId);
	msg.add<uint16_t>(helpers);
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendDepotItems(const ItemsTierCountList &itemMap, uint16_t count) {
	if (!player || oldProtocol) {
		return;
	}

	NetworkMessage msg;
	msg.addByte(0x94);

	msg.add<uint16_t>(count); // List size
	for (const auto &itemMap_it : itemMap) {
		for (const auto &[itemTier, itemCount] : itemMap_it.second) {
			msg.add<uint16_t>(itemMap_it.first); // Item ID
			if (itemTier > 0) {
				msg.addByte(itemTier - 1);
			}
			msg.add<uint16_t>(static_cast<uint16_t>(itemCount));
		}
	}

	writeToOutputBuffer(msg);
}

void ProtocolGame::sendCloseDepotSearch() {
	if (!player || oldProtocol) {
		return;
	}

	NetworkMessage msg;
	msg.addByte(0x9A);
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendDepotSearchResultDetail(uint16_t itemId, uint8_t tier, uint32_t depotCount, const ItemVector &depotItems, uint32_t inboxCount, const ItemVector &inboxItems, uint32_t stashCount) {
	if (!player || oldProtocol) {
		return;
	}

	NetworkMessage msg;
	msg.addByte(0x99);
	msg.add<uint16_t>(itemId);
	if (Item::items[itemId].upgradeClassification > 0) {
		msg.addByte(tier);
	}

	msg.add<uint32_t>(depotCount);
	msg.addByte(static_cast<uint8_t>(depotItems.size()));
	for (const auto &item : depotItems) {
		AddItem(msg, item);
	}

	msg.add<uint32_t>(inboxCount);
	msg.addByte(static_cast<uint8_t>(inboxItems.size()));
	for (const auto &item : inboxItems) {
		AddItem(msg, item);
	}

	msg.addByte(stashCount > 0 ? 0x01 : 0x00);
	if (stashCount > 0) {
		msg.add<uint16_t>(itemId);
		msg.add<uint32_t>(stashCount);
	}

	writeToOutputBuffer(msg);
}

void ProtocolGame::parseOpenDepotSearch() {
	if (oldProtocol) {
		return;
	}

	g_game().playerRequestDepotItems(player->getID());
}

void ProtocolGame::parseCloseDepotSearch() {
	if (oldProtocol) {
		return;
	}

	g_game().playerRequestCloseDepotSearch(player->getID());
}

void ProtocolGame::parseDepotSearchItemRequest(NetworkMessage &msg) {
	if (oldProtocol) {
		return;
	}

	auto itemId = msg.get<uint16_t>();
	uint8_t itemTier = 0;
	if (Item::items[itemId].upgradeClassification > 0) {
		itemTier = msg.getByte();
	}

	g_game().playerRequestDepotSearchItem(player->getID(), itemId, itemTier);
}

void ProtocolGame::parseRetrieveDepotSearch(NetworkMessage &msg) {
	if (oldProtocol) {
		return;
	}

	auto itemId = msg.get<uint16_t>();
	uint8_t itemTier = 0;
	if (Item::items[itemId].upgradeClassification > 0) {
		itemTier = msg.getByte();
	}
	uint8_t type = msg.getByte();

	g_game().playerRequestDepotSearchRetrieve(player->getID(), itemId, itemTier, type);
}

void ProtocolGame::parseOpenParentContainer(NetworkMessage &msg) {
	if (oldProtocol) {
		return;
	}

	Position pos = msg.getPosition();
	g_game().playerRequestOpenContainerFromDepotSearch(player->getID(), pos);
}

void ProtocolGame::sendUpdateCreature(const std::shared_ptr<Creature> &creature) {
	if (oldProtocol || !creature || !player) {
		return;
	}

	auto tile = creature->getTile();
	if (!tile) {
		return;
	}

	if (!canSee(creature)) {
		return;
	}

	int32_t stackPos = tile->getClientIndexOfCreature(player, creature);
	if (stackPos == -1 || stackPos >= 10) {
		return;
	}

	NetworkMessage msg;
	msg.addByte(0x6B);
	msg.addPosition(creature->getPosition());
	msg.addByte(static_cast<uint8_t>(stackPos));
	AddCreature(msg, creature, false, 0);
	writeToOutputBuffer(msg);
}

void ProtocolGame::getForgeInfoMap(const std::shared_ptr<Item> &item, std::map<uint16_t, std::map<uint8_t, uint16_t>> &itemsMap) const {
	std::map<uint8_t, uint16_t> itemInfo;
	itemInfo.insert({ item->getTier(), item->getItemCount() });
	auto [first, inserted] = itemsMap.try_emplace(item->getID(), itemInfo);
	if (!inserted) {
		auto [otherFirst, otherInserted] = itemsMap[item->getID()].try_emplace(item->getTier(), item->getItemCount());
		if (!otherInserted) {
			(itemsMap[item->getID()])[item->getTier()] += item->getItemCount();
		}
	}
}

void ProtocolGame::sendForgeSkillStats(NetworkMessage &msg) const {
	if (oldProtocol) {
		return;
	}

	std::vector<Slots_t> slots { CONST_SLOT_LEFT, CONST_SLOT_ARMOR, CONST_SLOT_HEAD, CONST_SLOT_LEGS };
	for (const auto &slot : slots) {
		double_t skill = 0;
		if (const auto &item = player->getInventoryItem(slot); item) {
			const ItemType &it = Item::items[item->getID()];
			if (it.isWeapon()) {
				skill = item->getFatalChance() * 100;
			}
			if (it.isArmor()) {
				skill = item->getDodgeChance() * 100;
			}
			if (it.isHelmet()) {
				skill = item->getMomentumChance() * 100;
			}
			if (it.isLegs()) {
				skill = item->getTranscendenceChance() * 100;
			}
		}

		auto skillCast = static_cast<uint16_t>(skill);
		msg.add<uint16_t>(skillCast);
		msg.add<uint16_t>(skillCast);
	}
}

void ProtocolGame::sendBosstiaryData() {
	if (oldProtocol) {
		return;
	}

	NetworkMessage msg;
	msg.addByte(0x61);

	msg.add<uint16_t>(25); // Number of kills to achieve 'Bane Prowess'
	msg.add<uint16_t>(100); // Number of kills to achieve 'Bane expertise'
	msg.add<uint16_t>(300); // Number of kills to achieve 'Base Mastery'

	msg.add<uint16_t>(5); // Number of kills to achieve 'Archfoe Prowess'
	msg.add<uint16_t>(20); // Number of kills to achieve 'Archfoe Expertise'
	msg.add<uint16_t>(60); // Number of kills to achieve 'Archfoe Mastery'

	msg.add<uint16_t>(1); // Number of kills to achieve 'Nemesis Prowess'
	msg.add<uint16_t>(3); // Number of kills to achieve 'Nemesis Expertise'
	msg.add<uint16_t>(5); // Number of kills to achieve 'Nemesis Mastery'

	msg.add<uint16_t>(5); // Points will receive when reach 'Bane Prowess'
	msg.add<uint16_t>(15); // Points will receive when reach 'Bane Expertise'
	msg.add<uint16_t>(30); // Points will receive when reach 'Base Mastery'

	msg.add<uint16_t>(10); // Points will receive when reach 'Archfoe Prowess'
	msg.add<uint16_t>(30); // Points will receive when reach 'Archfoe Expertise'
	msg.add<uint16_t>(60); // Points will receive when reach 'Archfoe Mastery'

	msg.add<uint16_t>(10); // Points will receive when reach 'Nemesis Prowess'
	msg.add<uint16_t>(30); // Points will receive when reach 'Nemesis Expertise'
	msg.add<uint16_t>(60); // Points will receive when reach 'Nemesis Mastery'

	writeToOutputBuffer(msg);
}

void ProtocolGame::parseSendBosstiary() {
	if (oldProtocol) {
		return;
	}

	sendBosstiaryData();

	NetworkMessage msg;
	msg.addByte(0x73);

	auto mtype_map = g_ioBosstiary().getBosstiaryMap();
	auto bossesBuffer = msg.getBufferPosition();
	uint16_t bossesCount = 0;
	msg.skipBytes(2);

	for (const auto &[bossid, name] : mtype_map) {
		const auto mType = g_monsters().getMonsterType(name);
		if (!mType) {
			continue;
		}

		auto bossRace = mType->info.bosstiaryRace;
		if (bossRace < BosstiaryRarity_t::RARITY_BANE || bossRace > BosstiaryRarity_t::RARITY_NEMESIS) {
			g_logger().error("[{}] monster {} have wrong boss race {}", __FUNCTION__, mType->name, fmt::underlying(bossRace));
			continue;
		}

		auto killCount = player->getBestiaryKillCount(bossid);
		msg.add<uint32_t>(bossid);
		msg.addByte(static_cast<uint8_t>(bossRace));
		msg.add<uint32_t>(killCount);
		msg.addByte(0);
		msg.addByte(player->isBossOnBosstiaryTracker(mType) ? 0x01 : 0x00);
		++bossesCount;
	}

	msg.setBufferPosition(bossesBuffer);
	msg.add<uint16_t>(bossesCount);

	writeToOutputBuffer(msg);
}

void ProtocolGame::parseSendBosstiarySlots() {
	if (oldProtocol) {
		return;
	}

	uint32_t bossIdSlotOne = player->getSlotBossId(1);
	uint32_t bossIdSlotTwo = player->getSlotBossId(2);
	uint32_t boostedBossId = g_ioBosstiary().getBoostedBossId();

	// Sanity checks
	const std::string &boostedBossName = g_ioBosstiary().getBoostedBossName();
	if (boostedBossName.empty()) {
		g_logger().error("[{}] The boosted boss name is empty", __FUNCTION__);
		return;
	}
	const auto mTypeBoosted = g_monsters().getMonsterType(boostedBossName);
	auto boostedBossRace = mTypeBoosted ? mTypeBoosted->info.bosstiaryRace : BosstiaryRarity_t::BOSS_INVALID;
	auto isValidBoostedBoss = boostedBossId == 0 || (boostedBossRace >= BosstiaryRarity_t::RARITY_BANE && boostedBossRace <= BosstiaryRarity_t::RARITY_NEMESIS);
	if (!isValidBoostedBoss) {
		g_logger().error("[{}] The boosted boss '{}' has an invalid race", __FUNCTION__, boostedBossName);
		return;
	}

	const auto mTypeSlotOne = g_ioBosstiary().getMonsterTypeByBossRaceId((uint16_t)bossIdSlotOne);
	auto bossRaceSlotOne = mTypeSlotOne ? mTypeSlotOne->info.bosstiaryRace : BosstiaryRarity_t::BOSS_INVALID;
	auto isValidBossSlotOne = bossIdSlotOne == 0 || (bossRaceSlotOne >= BosstiaryRarity_t::RARITY_BANE && bossRaceSlotOne <= BosstiaryRarity_t::RARITY_NEMESIS);
	if (!isValidBossSlotOne) {
		g_logger().error("[{}] boss slot1 with race id '{}' has an invalid race", __FUNCTION__, bossIdSlotOne);
		return;
	}

	const auto mTypeSlotTwo = g_ioBosstiary().getMonsterTypeByBossRaceId((uint16_t)bossIdSlotTwo);
	auto bossRaceSlotTwo = mTypeSlotTwo ? mTypeSlotTwo->info.bosstiaryRace : BosstiaryRarity_t::BOSS_INVALID;
	auto isValidBossSlotTwo = bossIdSlotTwo == 0 || (bossRaceSlotTwo >= BosstiaryRarity_t::RARITY_BANE && bossRaceSlotTwo <= BosstiaryRarity_t::RARITY_NEMESIS);
	if (!isValidBossSlotTwo) {
		g_logger().error("[{}] boss slot1 with race id '{}' has an invalid race", __FUNCTION__, bossIdSlotTwo);
		return;
	}

	sendBosstiaryData();

	NetworkMessage msg;
	msg.addByte(0x62);

	uint32_t playerBossPoints = player->getBossPoints();
	uint16_t currentBonus = g_ioBosstiary().calculateLootBonus(playerBossPoints);
	uint32_t pointsNextBonus = g_ioBosstiary().calculateBossPoints(currentBonus + 1);
	msg.add<uint32_t>(playerBossPoints); // Player Points
	msg.add<uint32_t>(pointsNextBonus); // Total Points next bonus
	msg.add<uint16_t>(currentBonus); // Current Bonus
	msg.add<uint16_t>(currentBonus + 1); // Next Bonus

	uint32_t removePrice = g_ioBosstiary().calculteRemoveBoss(player->getRemoveTimes());

	auto bossesUnlockedList = g_ioBosstiary().getBosstiaryFinished(player);
	if (auto it = std::ranges::find(bossesUnlockedList.begin(), bossesUnlockedList.end(), boostedBossId);
	    it != bossesUnlockedList.end()) {
		bossesUnlockedList.erase(it);
	}
	auto bossesUnlockedSize = static_cast<uint16_t>(bossesUnlockedList.size());

	bool isSlotOneUnlocked = (bossesUnlockedSize > 0 ? true : false);
	msg.addByte(isSlotOneUnlocked ? 1 : 0);
	msg.add<uint32_t>(isSlotOneUnlocked ? bossIdSlotOne : 0);
	if (isSlotOneUnlocked && bossIdSlotOne != 0) {
		// Variables Boss Slot One
		auto bossKillCount = player->getBestiaryKillCount(static_cast<uint16_t>(bossIdSlotOne));
		auto slotOneBossLevel = g_ioBosstiary().getBossCurrentLevel(player, (uint16_t)bossIdSlotOne);
		uint16_t bonusBossSlotOne = currentBonus + (slotOneBossLevel == 3 ? 25 : 0);
		uint8_t isSlotOneInactive = bossIdSlotOne == boostedBossId ? 1 : 0;
		// Bytes Slot One
		sendBosstiarySlotsBytes(msg, static_cast<uint8_t>(bossRaceSlotOne), bossKillCount, bonusBossSlotOne, 0, isSlotOneInactive, removePrice);
		bossesUnlockedSize--;
	}

	uint32_t slotTwoPoints = 1500;
	bool isSlotTwoUnlocked = (playerBossPoints >= slotTwoPoints ? true : false);
	msg.addByte(isSlotTwoUnlocked ? 1 : 0);
	msg.add<uint32_t>(isSlotTwoUnlocked ? bossIdSlotTwo : slotTwoPoints);
	if (isSlotTwoUnlocked && bossIdSlotTwo != 0) {
		// Variables Boss Slot Two
		auto bossKillCount = player->getBestiaryKillCount((uint16_t)(bossIdSlotTwo));
		auto slotTwoBossLevel = g_ioBosstiary().getBossCurrentLevel(player, (uint16_t)bossIdSlotTwo);
		uint16_t bonusBossSlotTwo = currentBonus + (slotTwoBossLevel == 3 ? 25 : 0);
		uint8_t isSlotTwoInactive = bossIdSlotTwo == boostedBossId ? 1 : 0;
		// Bytes Slot Two
		sendBosstiarySlotsBytes(msg, static_cast<uint8_t>(bossRaceSlotTwo), bossKillCount, bonusBossSlotTwo, 0, isSlotTwoInactive, removePrice);
		bossesUnlockedSize--;
	}

	bool isTodaySlotUnlocked = g_configManager().getBoolean(BOOSTED_BOSS_SLOT);
	msg.addByte(isTodaySlotUnlocked ? 1 : 0);
	msg.add<uint32_t>(boostedBossId);
	if (isTodaySlotUnlocked && boostedBossId != 0) {
		auto boostedBossKillCount = player->getBestiaryKillCount(static_cast<uint16_t>(boostedBossId));
		auto boostedLootBonus = static_cast<uint16_t>(g_configManager().getNumber(BOOSTED_BOSS_LOOT_BONUS));
		auto bosstiaryMultiplier = static_cast<uint8_t>(g_configManager().getNumber(BOSSTIARY_KILL_MULTIPLIER));
		auto boostedKillBonus = static_cast<uint8_t>(g_configManager().getNumber(BOOSTED_BOSS_KILL_BONUS));
		sendBosstiarySlotsBytes(msg, static_cast<uint8_t>(boostedBossRace), boostedBossKillCount, boostedLootBonus, bosstiaryMultiplier + boostedKillBonus, 0, 0);
	}

	msg.addByte(bossesUnlockedSize != 0 ? 1 : 0);
	if (bossesUnlockedSize != 0) {
		auto unlockCountBuffer = msg.getBufferPosition();
		uint16_t bossesCount = 0;
		msg.skipBytes(2);
		for (const auto &bossId : bossesUnlockedList) {
			if (bossId == bossIdSlotOne || bossId == bossIdSlotTwo) {
				continue;
			}

			const auto mType = g_ioBosstiary().getMonsterTypeByBossRaceId(bossId);
			if (!mType) {
				g_logger().error("[{}] monster {} not found", __FUNCTION__, bossId);
				continue;
			}

			auto bossRace = mType->info.bosstiaryRace;
			if (bossRace < BosstiaryRarity_t::RARITY_BANE || bossRace > BosstiaryRarity_t::RARITY_NEMESIS) {
				g_logger().error("[{}] monster {} have wrong boss race {}", __FUNCTION__, mType->name, fmt::underlying(bossRace));
				continue;
			}

			msg.add<uint32_t>(bossId);
			msg.addByte(static_cast<uint8_t>(bossRace));
			bossesCount++;
		}
		msg.setBufferPosition(unlockCountBuffer);
		msg.add<uint16_t>(bossesCount);
	}

	writeToOutputBuffer(msg);
	parseSendResourceBalance();
}

void ProtocolGame::parseBosstiarySlot(NetworkMessage &msg) {
	if (oldProtocol) {
		return;
	}

	uint8_t slotBossId = msg.getByte();
	auto selectedBossId = msg.get<uint32_t>();

	g_game().playerBosstiarySlot(player->getID(), slotBossId, selectedBossId);
}

void ProtocolGame::sendPodiumDetails(NetworkMessage &msg, const std::vector<uint16_t> &toSendMonsters, bool isBoss) const {
	auto toSendMonstersSize = static_cast<uint16_t>(toSendMonsters.size());
	msg.add<uint16_t>(toSendMonstersSize);
	for (const auto &raceId : toSendMonsters) {
		const auto mType = g_monsters().getMonsterTypeByRaceId(raceId, isBoss);
		if (!mType) {
			continue;
		}

		// Podium of tenacity only need raceId
		if (!isBoss) {
			msg.add<uint16_t>(raceId);
			continue;
		}

		auto monsterOutfit = mType->info.outfit;
		msg.add<uint16_t>(raceId);
		auto isLookType = monsterOutfit.lookType != 0;
		// "Tantugly's Head" boss have to send other looktype to the podium
		if (monsterOutfit.lookTypeEx == 35105) {
			monsterOutfit.lookTypeEx = 39003;
			msg.addString("Tentugly");
		} else {
			msg.addString(mType->name);
		}
		msg.add<uint16_t>(monsterOutfit.lookType);
		if (isLookType) {
			msg.addByte(monsterOutfit.lookHead);
			msg.addByte(monsterOutfit.lookBody);
			msg.addByte(monsterOutfit.lookLegs);
			msg.addByte(monsterOutfit.lookFeet);
			msg.addByte(monsterOutfit.lookAddons);
		} else {
			msg.add<uint16_t>(monsterOutfit.lookTypeEx);
		}
	}
}

void ProtocolGame::sendMonsterPodiumWindow(const std::shared_ptr<Item> &podium, const Position &position, uint16_t itemId, uint8_t stackPos) {
	if (!podium || oldProtocol) {
		g_logger().error("[{}] item is nullptr", __FUNCTION__);
		return;
	}

	NetworkMessage msg;
	msg.addByte(0xC2);

	auto podiumVisible = podium->getCustomAttribute("PodiumVisible");
	auto lookType = podium->getCustomAttribute("LookType");
	auto lookDirection = podium->getCustomAttribute("LookDirection");

	bool isBossSelected = false;
	uint16_t lookValue = 0;
	if (lookType) {
		lookValue = static_cast<uint16_t>(lookType->getInteger());
		isBossSelected = lookValue > 0;
	}

	msg.add<uint16_t>(isBossSelected ? lookValue : 0); // Boss LookType
	if (isBossSelected) {
		auto lookHead = podium->getCustomAttribute("LookHead");
		auto lookBody = podium->getCustomAttribute("LookBody");
		auto lookLegs = podium->getCustomAttribute("LookLegs");
		auto lookFeet = podium->getCustomAttribute("LookFeet");

		msg.addByte(lookHead ? static_cast<uint8_t>(lookHead->getInteger()) : 0);
		msg.addByte(lookBody ? static_cast<uint8_t>(lookBody->getInteger()) : 0);
		msg.addByte(lookLegs ? static_cast<uint8_t>(lookLegs->getInteger()) : 0);
		msg.addByte(lookFeet ? static_cast<uint8_t>(lookFeet->getInteger()) : 0);

		auto lookAddons = podium->getCustomAttribute("LookAddons");
		msg.addByte(lookAddons ? static_cast<uint8_t>(lookAddons->getInteger()) : 0);
	} else {
		msg.add<uint16_t>(0); // Boss LookType
	}
	msg.add<uint16_t>(0); // Size of an unknown list. (No ingame visual effect)

	bool isBossPodium = podium->getID() == ITEM_PODIUM_OF_VIGOUR;
	msg.addByte(isBossPodium ? 0x01 : 0x00); // Bosstiary or bestiary
	if (isBossPodium) {
		const auto &unlockedBosses = g_ioBosstiary().getBosstiaryFinished(player, 2);
		sendPodiumDetails(msg, unlockedBosses, true);
	} else {
		const auto &unlockedMonsters = g_iobestiary().getBestiaryFinished(player);
		sendPodiumDetails(msg, unlockedMonsters, false);
	}

	msg.addPosition(position); // Position of the podium on the map
	msg.add<uint16_t>(itemId); // ClientID of the podium
	msg.addByte(stackPos); // StackPos of the podium on the map

	msg.addByte(podiumVisible ? static_cast<uint8_t>(podiumVisible->getInteger()) : 0x01); // A boolean saying if it's visible or not
	msg.addByte(lookType ? 0x01 : 0x00); // A boolean saying if there's a boss selected
	msg.addByte(lookDirection ? static_cast<uint8_t>(lookDirection->getInteger()) : 2); // Direction where the boss is looking
	writeToOutputBuffer(msg);
}

void ProtocolGame::parseSetMonsterPodium(NetworkMessage &msg) const {
	if (!player || oldProtocol) {
		return;
	}

	// For some reason the cip sends uint32_t, but we use uint16_t, so let's just ignore that
	auto monsterRaceId = static_cast<uint16_t>(msg.get<uint32_t>());
	Position pos = msg.getPosition();
	auto itemId = msg.get<uint16_t>();
	uint8_t stackpos = msg.getByte();
	uint8_t direction = msg.getByte();
	uint8_t podiumVisible = msg.getByte();
	uint8_t monsterVisible = msg.getByte();

	g_game().playerSetMonsterPodium(player->getID(), monsterRaceId, pos, stackpos, itemId, direction, std::make_pair(podiumVisible, monsterVisible));
}

void ProtocolGame::sendBosstiaryCooldownTimer() {
	if (!player || oldProtocol) {
		return;
	}

	NetworkMessage msg;
	msg.addByte(0xBD);

	auto startBosses = msg.getBufferPosition();
	msg.skipBytes(2); // Boss count
	uint16_t bossesCount = 0;
	for (std::map<uint16_t, std::string> bossesMap = g_ioBosstiary().getBosstiaryMap();
	     const auto &[bossRaceId, _] : bossesMap) {
		const auto mType = g_ioBosstiary().getMonsterTypeByBossRaceId(bossRaceId);
		if (!mType) {
			continue;
		}

		auto timerValue = player->kv()->scoped("boss.cooldown")->get(toKey(std::to_string(bossRaceId)));
		if (!timerValue || !timerValue.has_value()) {
			continue;
		}
		auto timer = timerValue->getNumber();
		uint64_t sendTimer = timer > 0 ? static_cast<uint64_t>(timer) : 0;
		msg.add<uint32_t>(bossRaceId); // bossRaceId
		msg.add<uint64_t>(sendTimer); // Boss cooldown in seconds
		bossesCount++;
	}
	auto endBosses = msg.getBufferPosition();
	msg.setBufferPosition(startBosses);
	msg.add<uint16_t>(bossesCount);
	msg.setBufferPosition(endBosses);

	writeToOutputBuffer(msg);
}

void ProtocolGame::sendBosstiaryEntryChanged(uint32_t bossid) {
	if (oldProtocol) {
		return;
	}

	NetworkMessage msg;
	msg.addByte(0xE6);
	msg.add<uint32_t>(bossid);
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendSingleSoundEffect(const Position &pos, SoundEffect_t id, SourceEffect_t source) {
	if (oldProtocol) {
		return;
	}

	NetworkMessage msg;
	msg.addByte(0x83);
	msg.addPosition(pos);
	msg.addByte(0x06); // Sound effect type
	msg.addByte(static_cast<uint8_t>(source)); // Sound source type
	msg.add<uint16_t>(static_cast<uint16_t>(id)); // Sound id
	msg.addByte(0x00); // Breaking the effects loop
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendDoubleSoundEffect(
	const Position &pos,
	SoundEffect_t mainSoundId,
	SourceEffect_t mainSource,
	SoundEffect_t secondarySoundId,
	SourceEffect_t secondarySource
) {
	if (oldProtocol) {
		return;
	}

	NetworkMessage msg;
	msg.addByte(0x83);
	msg.addPosition(pos);

	// Primary sound
	msg.addByte(0x06); // Sound effect type
	msg.addByte(static_cast<uint8_t>(mainSource)); // Sound source type
	msg.add<uint16_t>(static_cast<uint16_t>(mainSoundId)); // Sound id

	// Secondary sound (Can be an array too, but not necessary here)
	msg.addByte(0x07); // Multiple effect type
	msg.addByte(0x01); // Useless ENUM (So far)
	msg.addByte(static_cast<uint8_t>(secondarySource)); // Sound source type
	msg.add<uint16_t>(static_cast<uint16_t>(secondarySoundId)); // Sound id

	msg.addByte(0x00); // Breaking the effects loop
	writeToOutputBuffer(msg);
}

void ProtocolGame::parseOpenWheel(NetworkMessage &msg) {
	if (oldProtocol || !g_configManager().getBoolean(TOGGLE_WHEELSYSTEM)) {
		return;
	}

	auto ownerId = msg.get<uint32_t>();
	g_game().playerOpenWheel(player->getID(), ownerId);
}

void ProtocolGame::parseWheelGemAction(NetworkMessage &msg) {
	if (oldProtocol || !g_configManager().getBoolean(TOGGLE_WHEELSYSTEM)) {
		return;
	}

	g_game().playerWheelGemAction(player->getID(), msg);
}

void ProtocolGame::sendOpenWheelWindow(uint32_t ownerId) {
	if (!player || oldProtocol || !g_configManager().getBoolean(TOGGLE_WHEELSYSTEM)) {
		return;
	}

	NetworkMessage msg;
	player->wheel()->sendOpenWheelWindow(msg, ownerId);
	writeToOutputBuffer(msg);
}

void ProtocolGame::parseSaveWheel(NetworkMessage &msg) {
	if (oldProtocol || !g_configManager().getBoolean(TOGGLE_WHEELSYSTEM)) {
		return;
	}

	g_game().playerSaveWheel(player->getID(), msg);
}

void ProtocolGame::sendDisableLoginMusic() {
	if (oldProtocol || !player || player->getOperatingSystem() >= CLIENTOS_OTCLIENT_LINUX) {
		return;
	}

	NetworkMessage msg;
	msg.addByte(0x85);
	msg.addByte(0x01);
	msg.addByte(0x00);
	msg.addByte(0x00);
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendHotkeyPreset() {
	if (!player || oldProtocol) {
		return;
	}

	auto vocation = g_vocations().getVocation(player->getVocation()->getBaseId());
	if (vocation) {
		NetworkMessage msg;
		msg.addByte(0x9D);
		msg.add<uint32_t>(vocation->getClientId());
		writeToOutputBuffer(msg);
	}
}

void ProtocolGame::sendTakeScreenshot(Screenshot_t screenshotType) {
	if (screenshotType == SCREENSHOT_TYPE_NONE || oldProtocol) {
		return;
	}

	NetworkMessage msg;
	msg.addByte(0x75);
	msg.addByte(screenshotType);
	writeToOutputBuffer(msg);
}
