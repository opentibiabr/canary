/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2022 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.org/
*/

#include "pch.hpp"

#include "io/iologindata.h"
#include "io/functions/iologindata_load_player.hpp"
#include "io/functions/iologindata_save_player.hpp"
#include "game/game.h"
#include "game/scheduling/scheduler.h"
#include "creatures/monsters/monster.h"
#include "io/ioprey.h"
#include "protobuf/itemsserialization.pb.h"
#include "protobuf/playersystems.pb.h"

bool IOLoginData::authenticateAccountPassword(const std::string& email, const std::string& password, account::Account *account) {
	if (account::ERROR_NO != account->LoadAccountDB(email)) {
		SPDLOG_ERROR("Email {} doesn't match any account.", email);
		return false;
	}

	std::string accountPassword;
	account->GetPassword(&accountPassword);
	if (transformToSHA1(password) != accountPassword) {
			SPDLOG_ERROR("Password '{}' doesn't match any account", transformToSHA1(password));
			return false;
	}

	return true;
}

bool IOLoginData::gameWorldAuthentication(const std::string& email, const std::string& password, std::string& characterName, uint32_t *accountId)
{
	account::Account account;
	if (!IOLoginData::authenticateAccountPassword(email, password, &account)) {
		return false;
	}

	account::Player player;
	if (account::ERROR_NO != account.GetAccountPlayer(&player, characterName)) {
		SPDLOG_ERROR("Player not found or deleted for account.");
		return false;
	}

	account.GetID(accountId);

	return true;
}

account::AccountType IOLoginData::getAccountType(uint32_t accountId)
{
  std::ostringstream query;
  query << "SELECT `type` FROM `accounts` WHERE `id` = " << accountId;
  DBResult_ptr result = Database::getInstance().storeQuery(query.str());
  if (!result) {
    return account::ACCOUNT_TYPE_NORMAL;
  }
  return static_cast<account::AccountType>(result->getNumber<uint16_t>("type"));
}

void IOLoginData::setAccountType(uint32_t accountId, account::AccountType accountType)
{
  std::ostringstream query;
  query << "UPDATE `accounts` SET `type` = " << static_cast<uint16_t>(accountType) << " WHERE `id` = " << accountId;
  Database::getInstance().executeQuery(query.str());
}

void IOLoginData::updateOnlineStatus(uint32_t guid, bool login)
{
  if (g_configManager().getBoolean(ALLOW_CLONES)) {
    return;
  }

  std::ostringstream query;
  if (login) {
    query << "INSERT INTO `players_online` VALUES (" << guid << ')';
  } else {
    query << "DELETE FROM `players_online` WHERE `player_id` = " << guid;
  }
  Database::getInstance().executeQuery(query.str());
}

bool IOLoginData::preloadPlayer(Player* player, const std::string& name)
{
  Database& db = Database::getInstance();

  std::ostringstream query;
  query << "SELECT `id`, `account_id`, `group_id`, `deletion`, (SELECT `type` FROM `accounts` WHERE `accounts`.`id` = `account_id`) AS `account_type`";
  if (!g_configManager().getBoolean(FREE_PREMIUM)) {
    query << ", (SELECT `premdays` FROM `accounts` WHERE `accounts`.`id` = `account_id`) AS `premium_days`";
  }
  query << " FROM `players` WHERE `name` = " << db.escapeString(name);
  DBResult_ptr result = db.storeQuery(query.str());
  if (!result) {
    return false;
  }

  if (result->getNumber<uint64_t>("deletion") != 0) {
    return false;
  }

  player->setGUID(result->getNumber<uint32_t>("id"));
  Group* group = g_game().groups.getGroup(result->getNumber<uint16_t>("group_id"));
  if (!group) {
    SPDLOG_ERROR("Player {} has group id {} whitch doesn't exist", player->name,
			result->getNumber<uint16_t>("group_id"));
    return false;
  }
  player->setGroup(group);
  player->accountNumber = result->getNumber<uint32_t>("account_id");
  player->accountType = static_cast<account::AccountType>(result->getNumber<uint16_t>("account_type"));
  if (!g_configManager().getBoolean(FREE_PREMIUM)) {
    player->premiumDays = result->getNumber<uint16_t>("premium_days");
  } else {
    player->premiumDays = std::numeric_limits<uint16_t>::max();
  }
  return true;
}

bool IOLoginData::loadPlayerById(Player* player, uint32_t id)
{
  Database& db = Database::getInstance();
  std::ostringstream query;
  query << "SELECT * FROM `players` WHERE `id` = " << id;
  return loadPlayer(player, db.storeQuery(query.str()));
}

bool IOLoginData::loadPlayerByName(Player* player, const std::string& name)
{
  Database& db = Database::getInstance();
  std::ostringstream query;
  query << "SELECT * FROM `players` WHERE `name` = " << db.escapeString(name);
  return loadPlayer(player, db.storeQuery(query.str()));
}

bool IOLoginData::loadPlayer(Player* player, DBResult_ptr result)
{
  if (!result) {
    return false;
  }

  Database& db = Database::getInstance();

  uint32_t accountId = result->getNumber<uint32_t>("account_id");
  account::Account acc;
  acc.SetDatabaseInterface(&db);
  acc.LoadAccountDB(accountId);

  player->setGUID(result->getNumber<uint32_t>("id"));
  player->name = result->getString("name");
  acc.GetID(&(player->accountNumber));
  acc.GetAccountType(&(player->accountType));

  if (g_configManager().getBoolean(FREE_PREMIUM)) {
    player->premiumDays = std::numeric_limits<uint16_t>::max();
  } else {
    acc.GetPremiumRemaningDays(&(player->premiumDays));
  }

  acc.GetCoins(&(player->coinBalance));

  Group* group = g_game().groups.getGroup(result->getNumber<uint16_t>("group_id"));
  if (!group) {
    SPDLOG_ERROR("Player {} has group id {} whitch doesn't exist", player->name, result->getNumber<uint16_t>("group_id"));
    return false;
  }
  player->setGroup(group);

  player->setBankBalance(result->getNumber<uint64_t>("balance"));

  player->quickLootFallbackToMainContainer = result->getNumber<bool>("quickloot_fallback");

  player->setSex(static_cast<PlayerSex_t>(result->getNumber<uint16_t>("sex")));
  player->level = std::max<uint32_t>(1, result->getNumber<uint32_t>("level"));

  uint64_t experience = result->getNumber<uint64_t>("experience");

  uint64_t currExpCount = Player::getExpForLevel(player->level);
  uint64_t nextExpCount = Player::getExpForLevel(player->level + 1);
  if (experience < currExpCount || experience > nextExpCount) {
    experience = currExpCount;
  }

  player->experience = experience;

  if (currExpCount < nextExpCount) {
    player->levelPercent = Player::getPercentLevel(player->experience - currExpCount, nextExpCount - currExpCount);
  } else {
    player->levelPercent = 0;
  }

  player->soul = result->getNumber<uint16_t>("soul");
  player->capacity = result->getNumber<uint32_t>("cap") * 100;
  for (int i = 1; i <= 8; i++) {
    std::ostringstream ss;
    ss << "blessings" << i;
    player->addBlessing(i, result->getNumber<uint16_t>(ss.str()));
  }

  unsigned long attrSize;
  const char* attr = result->getStream("conditions", attrSize);
  PropStream propStream;
  propStream.init(attr, attrSize);

  Condition* condition = Condition::createCondition(propStream);
  while (condition) {
    if (condition->unserialize(propStream)) {
      player->storedConditionList.push_front(condition);
    } else {
      delete condition;
    }
    condition = Condition::createCondition(propStream);
  }

  if (!player->setVocation(result->getNumber<uint16_t>("vocation"))) {
    SPDLOG_ERROR("Player {} has vocation id {} whitch doesn't exist",
			player->name, result->getNumber<uint16_t>("vocation"));
    return false;
  }

  player->mana = result->getNumber<uint32_t>("mana");
  player->manaMax = result->getNumber<uint32_t>("manamax");
  player->magLevel = result->getNumber<uint32_t>("maglevel");

  uint64_t nextManaCount = player->vocation->getReqMana(player->magLevel + 1);
  uint64_t manaSpent = result->getNumber<uint64_t>("manaspent");
  if (manaSpent > nextManaCount) {
    manaSpent = 0;
  }

  player->manaSpent = manaSpent;
  player->magLevelPercent = Player::getPercentLevel(player->manaSpent, nextManaCount);

  player->health = result->getNumber<int32_t>("health");
  player->healthMax = result->getNumber<int32_t>("healthmax");

  player->defaultOutfit.lookType = result->getNumber<uint16_t>("looktype");
	if (g_configManager().getBoolean(WARN_UNSAFE_SCRIPTS) && player->defaultOutfit.lookType != 0 && !g_game().isLookTypeRegistered(player->defaultOutfit.lookType)) {
		SPDLOG_WARN("[IOLoginData::loadPlayer] An unregistered creature looktype type with id '{}' was blocked to prevent client crash.", player->defaultOutfit.lookType);
		return false;
	}
  player->defaultOutfit.lookHead = result->getNumber<uint16_t>("lookhead");
  player->defaultOutfit.lookBody = result->getNumber<uint16_t>("lookbody");
  player->defaultOutfit.lookLegs = result->getNumber<uint16_t>("looklegs");
  player->defaultOutfit.lookFeet = result->getNumber<uint16_t>("lookfeet");
  player->defaultOutfit.lookAddons = result->getNumber<uint16_t>("lookaddons");
  player->defaultOutfit.lookMountHead = result->getNumber<uint16_t>("lookmounthead");
  player->defaultOutfit.lookMountBody = result->getNumber<uint16_t>("lookmountbody");
  player->defaultOutfit.lookMountLegs = result->getNumber<uint16_t>("lookmountlegs");
  player->defaultOutfit.lookMountFeet = result->getNumber<uint16_t>("lookmountfeet");
  player->defaultOutfit.lookFamiliarsType = result->getNumber<uint16_t>("lookfamiliarstype");
	if (g_configManager().getBoolean(WARN_UNSAFE_SCRIPTS) && player->defaultOutfit.lookFamiliarsType != 0 && !g_game().isLookTypeRegistered(player->defaultOutfit.lookFamiliarsType)) {
		SPDLOG_WARN("[IOLoginData::loadPlayer] An unregistered creature looktype type with id '{}' was blocked to prevent client crash.", player->defaultOutfit.lookFamiliarsType);
		return false;
	}
  player->isDailyReward = result->getNumber<uint16_t>("isreward");
  player->currentOutfit = player->defaultOutfit;

  if (g_game().getWorldType() != WORLD_TYPE_PVP_ENFORCED) {
    const time_t skullSeconds = result->getNumber<time_t>("skulltime") - time(nullptr);
    if (skullSeconds > 0) {
      //ensure that we round up the number of ticks
      player->skullTicks = (skullSeconds + 2);

      uint16_t skull = result->getNumber<uint16_t>("skull");
      if (skull == SKULL_RED) {
        player->skull = SKULL_RED;
      } else if (skull == SKULL_BLACK) {
        player->skull = SKULL_BLACK;
      }
    }
  }

  player->loginPosition.x = result->getNumber<uint16_t>("posx");
  player->loginPosition.y = result->getNumber<uint16_t>("posy");
  player->loginPosition.z = result->getNumber<uint16_t>("posz");

  player->addPreyCards(result->getNumber<uint64_t>("prey_wildcard"));
  player->addTaskHuntingPoints(result->getNumber<uint64_t>("task_points"));
  player->addForgeDusts(result->getNumber<uint64_t>("forge_dusts"));
  player->addForgeDustLevel(result->getNumber<uint64_t>("forge_dust_level"));

  player->charmPoints = result->getNumber<uint32_t>("charm_points");
  player->charmExpansion = result->getNumber<bool>("charm_upgrade");

  player->lastLoginSaved = result->getNumber<time_t>("lastlogin");
  player->lastLogout = result->getNumber<time_t>("lastlogout");

  player->offlineTrainingTime = result->getNumber<int32_t>("offlinetraining_time") * 1000;
  auto skill = result->getInt8FromString(result->getString("offlinetraining_skill"), __FUNCTION__);
  player->setOfflineTrainingSkill(skill);

  Town* town = g_game().map.towns.getTown(result->getNumber<uint32_t>("town_id"));
  if (!town) {
    SPDLOG_ERROR("Player {} has town id {} whitch doesn't exist", player->name,
			result->getNumber<uint16_t>("town_id"));
    return false;
  }

  player->town = town;

  const Position& loginPos = player->loginPosition;
  if (loginPos.x == 0 && loginPos.y == 0 && loginPos.z == 0) {
    player->loginPosition = player->getTemplePosition();
  }

  player->staminaMinutes = result->getNumber<uint16_t>("stamina");
  player->setStoreXpBoost(result->getNumber<uint16_t>("xpboost_value"));
  player->setExpBoostStamina(result->getNumber<uint16_t>("xpboost_stamina"));

  static const std::string skillNames[] = {"skill_fist", "skill_club", "skill_sword", "skill_axe", "skill_dist", "skill_shielding", "skill_fishing", "skill_critical_hit_chance", "skill_critical_hit_damage", "skill_life_leech_chance", "skill_life_leech_amount", "skill_mana_leech_chance", "skill_mana_leech_amount"};
  static const std::string skillNameTries[] = {"skill_fist_tries", "skill_club_tries", "skill_sword_tries", "skill_axe_tries", "skill_dist_tries", "skill_shielding_tries", "skill_fishing_tries", "skill_critical_hit_chance_tries", "skill_critical_hit_damage_tries", "skill_life_leech_chance_tries", "skill_life_leech_amount_tries", "skill_mana_leech_chance_tries", "skill_mana_leech_amount_tries"};
  static constexpr size_t size = sizeof(skillNames) / sizeof(std::string);
  for (uint8_t i = 0; i < size; ++i) {
    uint16_t skillLevel = result->getNumber<uint16_t>(skillNames[i]);
    uint64_t skillTries = result->getNumber<uint64_t>(skillNameTries[i]);
    uint64_t nextSkillTries = player->vocation->getReqSkillTries(i, skillLevel + 1);
    if (skillTries > nextSkillTries) {
      skillTries = 0;
    }

    player->skills[i].level = skillLevel;
    player->skills[i].tries = skillTries;
    player->skills[i].percent = Player::getPercentLevel(skillTries, nextSkillTries);
  }

  player->setManaShield(result->getNumber<uint16_t>("manashield"));
  player->setMaxManaShield(result->getNumber<uint16_t>("max_manashield"));

  // Load forge history
  IOLoginDataLoad::loadPlayerForgeHistory(player, result);

  std::ostringstream query;
  query << "SELECT `guild_id`, `rank_id`, `nick` FROM `guild_membership` WHERE `player_id` = " << player->getGUID();
  if ((result = db.storeQuery(query.str()))) {
    uint32_t guildId = result->getNumber<uint32_t>("guild_id");
    uint32_t playerRankId = result->getNumber<uint32_t>("rank_id");
    player->guildNick = result->getString("nick");

    Guild* guild = g_game().getGuild(guildId);
    if (!guild) {
      guild = IOGuild::loadGuild(guildId);
      g_game().addGuild(guild);
    }

    if (guild) {
      player->guild = guild;
      GuildRank_ptr rank = guild->getRankById(playerRankId);
      if (!rank) {
        query.str(std::string());
        query << "SELECT `id`, `name`, `level` FROM `guild_ranks` WHERE `id` = " << playerRankId;

        if ((result = db.storeQuery(query.str()))) {
          guild->addRank(result->getNumber<uint32_t>("id"), result->getString("name"), result->getNumber<uint16_t>("level"));
        }

        rank = guild->getRankById(playerRankId);
        if (!rank) {
          player->guild = nullptr;
        }
      }

      player->guildRank = rank;

      IOGuild::getWarList(guildId, player->guildWarVector);

      query.str(std::string());
      query << "SELECT COUNT(*) AS `members` FROM `guild_membership` WHERE `guild_id` = " << guildId;
      if ((result = db.storeQuery(query.str()))) {
        guild->setMemberCount(result->getNumber<uint32_t>("members"));
      }
    }
  }

  query.str(std::string());
  query << "SELECT * FROM `player_bin_data` WHERE `player_id` = " << player->getGUID();
  if ((result = db.storeQuery(query.str()))) {
    loadPlayerDataFromProtobufArray(player, result);
  }

  query.str(std::string());
  query << "SELECT `player_id`, `name` FROM `player_spells` WHERE `player_id` = " << player->getGUID();
  if ((result = db.storeQuery(query.str()))) {
    do {
      player->learnedInstantSpellList.emplace_front(result->getString("name"));
    } while (result->next());
  }

  query.str(std::string());
  query << "SELECT `player_id`, `time`, `target`, `unavenged` FROM `player_kills` WHERE `player_id` = " << player->getGUID();
  if ((result = db.storeQuery(query.str()))) {
    do {
      time_t killTime = result->getNumber<time_t>("time");
      if ((time(nullptr) - killTime) <= g_configManager().getNumber(FRAG_TIME)) {
        player->unjustifiedKills.emplace_back(result->getNumber<uint32_t>("target"), killTime, result->getNumber<bool>("unavenged"));
      }
    } while (result->next());
  }

  // Store Inbox
  if (!player->inventory[CONST_SLOT_STORE_INBOX]) {
    player->internalAddThing(CONST_SLOT_STORE_INBOX, Item::CreateItem(ITEM_STORE_INBOX));
  }

  //load storage map
  query.str(std::string());
  query << "SELECT `key`, `value` FROM `player_storage` WHERE `player_id` = " << player->getGUID();
  if ((result = db.storeQuery(query.str()))) {
    do {
      player->addStorageValue(result->getNumber<uint32_t>("key"), result->getNumber<int32_t>("value"), true);
    } while (result->next());
  }

  //load vip
  query.str(std::string());
  query << "SELECT `player_id` FROM `account_viplist` WHERE `account_id` = " << player->getAccount();
  if ((result = db.storeQuery(query.str()))) {
    do {
      player->addVIPInternal(result->getNumber<uint32_t>("player_id"));
    } while (result->next());
  }

  player->initializePrey();
  player->initializeTaskHunting();
  player->updateBaseSpeed();
  player->updateInventoryWeight();
  player->updateInventoryImbuement(true);
  player->updateItemsLight(true);
  return true;
}

void IOLoginData::savePlayerDataToProtobufArray(Player* player, std::ostringstream& query)
{
  Database& db = Database::getInstance();
  using ContainerBlock = std::pair<Container*, int32_t>;
  std::list<ContainerBlock> queue;
  ItemBlockList itemList;
  int32_t runningId = 100;
  const auto& openContainers = player->getOpenContainers();
  size_t protobufSize;

  // Inventory
  auto inventoryItemsProtobuf = Canary::protobuf::itemsserialization::ItemsSerialization();
  for (int32_t slotId = CONST_SLOT_FIRST; slotId <= CONST_SLOT_LAST; ++slotId) {
    if (Item* item = player->inventory[slotId]) {
      itemList.emplace_back(slotId, item);
    }
  }

  for (const auto& it : itemList) {
    int32_t pid = it.first;
    Item* item = it.second;
    ++runningId;

    if (Container* container = item->getContainer()) {
      if (container->getIntAttr(ITEM_ATTRIBUTE_OPENCONTAINER) > 0) {
        container->setIntAttr(ITEM_ATTRIBUTE_OPENCONTAINER, 0);
      }

      if (!openContainers.empty()) {
        for (const auto& its : openContainers) {
          auto openContainer = its.second;
          auto opcontainer = openContainer.container;

          if (opcontainer == container) {
            container->setIntAttr(ITEM_ATTRIBUTE_OPENCONTAINER, ((int)its.first) + 1);
            break;
          }
        }
      }

      queue.emplace_back(container, runningId);
    }

    auto inventoryItem = inventoryItemsProtobuf.add_item();
    inventoryItem->set_pid(pid);
    inventoryItem->set_sid(runningId);
    inventoryItem->set_id(item->getID());
    inventoryItem->set_subtype(item->getSubType());
    item->serializeAttrToProtobuf(inventoryItem);
  }

  while (!queue.empty()) {
    const ContainerBlock& cb = queue.front();
    Container* container = cb.first;
    int32_t parentId = cb.second;
    queue.pop_front();

    for (Item* item : container->getItemList()) {
      ++runningId;

      if (Container* subContainer = item->getContainer()) {
        queue.emplace_back(subContainer, runningId);
        if (subContainer->getIntAttr(ITEM_ATTRIBUTE_OPENCONTAINER) > 0) {
          subContainer->setIntAttr(ITEM_ATTRIBUTE_OPENCONTAINER, 0);
        }

        if (!openContainers.empty()) {
          for (const auto& it : openContainers) {
            auto openContainer = it.second;
            auto opcontainer = openContainer.container;

            if (opcontainer == subContainer) {
              subContainer->setIntAttr(ITEM_ATTRIBUTE_OPENCONTAINER, ((int)it.first) + 1);
              break;
            }
          }
        }
      }

      auto inventoryItem = inventoryItemsProtobuf.add_item();
      inventoryItem->set_pid(parentId);
      inventoryItem->set_sid(runningId);
      inventoryItem->set_id(item->getID());
      inventoryItem->set_subtype(item->getSubType());
      item->serializeAttrToProtobuf(inventoryItem);
    }
  }

  protobufSize = inventoryItemsProtobuf.ByteSizeLong();
  std::unique_ptr<char[]> inventorySerialized(new char[protobufSize]);
  inventoryItemsProtobuf.SerializeToArray(&inventorySerialized[0], static_cast<int>(protobufSize));

  query << "," << db.escapeBlob(&inventorySerialized[0], protobufSize);
  // End inventory

  // Depot items
  queue.clear();
  itemList.clear();
  runningId = 100;
  auto depotItemsProtobuf = Canary::protobuf::itemsserialization::ItemsSerialization();
  for (const auto& it : player->depotChests) {
    DepotChest* depotChest = it.second;
    for (Item* item : depotChest->getItemList()) {
      itemList.emplace_back(it.first, item);
    }
  }

  for (const auto& it : itemList) {
    int32_t pid = it.first;
    Item* item = it.second;
    ++runningId;

    if (Container* container = item->getContainer()) {
      if (container->getIntAttr(ITEM_ATTRIBUTE_OPENCONTAINER) > 0) {
        container->setIntAttr(ITEM_ATTRIBUTE_OPENCONTAINER, 0);
      }

      if (!openContainers.empty()) {
        for (const auto& its : openContainers) {
          auto openContainer = its.second;
          auto opcontainer = openContainer.container;

          if (opcontainer == container) {
            container->setIntAttr(ITEM_ATTRIBUTE_OPENCONTAINER, ((int)its.first) + 1);
            break;
          }
        }
      }

      queue.emplace_back(container, runningId);
    }

    auto depotItem = depotItemsProtobuf.add_item();
    depotItem->set_pid(pid);
    depotItem->set_sid(runningId);
    depotItem->set_id(item->getID());
    depotItem->set_subtype(item->getSubType());
    item->serializeAttrToProtobuf(depotItem);
  }

  while (!queue.empty()) {
    const ContainerBlock& cb = queue.front();
    Container* container = cb.first;
    int32_t parentId = cb.second;
    queue.pop_front();

    for (Item* item : container->getItemList()) {
      ++runningId;

      if (Container* subContainer = item->getContainer()) {
        queue.emplace_back(subContainer, runningId);
        if (subContainer->getIntAttr(ITEM_ATTRIBUTE_OPENCONTAINER) > 0) {
          subContainer->setIntAttr(ITEM_ATTRIBUTE_OPENCONTAINER, 0);
        }

        if (!openContainers.empty()) {
          for (const auto& it : openContainers) {
            auto openContainer = it.second;
            auto opcontainer = openContainer.container;

            if (opcontainer == subContainer) {
              subContainer->setIntAttr(ITEM_ATTRIBUTE_OPENCONTAINER, ((int)it.first) + 1);
              break;
            }
          }
        }
      }

      auto depotItem = depotItemsProtobuf.add_item();
      depotItem->set_pid(parentId);
      depotItem->set_sid(runningId);
      depotItem->set_id(item->getID());
      depotItem->set_subtype(item->getSubType());
      item->serializeAttrToProtobuf(depotItem);
    }
  }

  protobufSize = depotItemsProtobuf.ByteSizeLong();
  std::unique_ptr<char[]> depotSerialized(new char[protobufSize]);
  depotItemsProtobuf.SerializeToArray(&depotSerialized[0], static_cast<int>(protobufSize));

  query << "," << db.escapeBlob(&depotSerialized[0], protobufSize);
  // End depot

  // Inbox
  queue.clear();
  itemList.clear();
  runningId = 100;
  auto inboxItemsProtobuf = Canary::protobuf::itemsserialization::ItemsSerialization();
  for (Item* item : player->getInbox()->getItemList()) {
    itemList.emplace_back(0, item);
  }

  for (const auto& it : itemList) {
    int32_t pid = it.first;
    Item* item = it.second;
    ++runningId;

    if (Container* container = item->getContainer()) {
      if (container->getIntAttr(ITEM_ATTRIBUTE_OPENCONTAINER) > 0) {
        container->setIntAttr(ITEM_ATTRIBUTE_OPENCONTAINER, 0);
      }

      if (!openContainers.empty()) {
        for (const auto& its : openContainers) {
          auto openContainer = its.second;
          auto opcontainer = openContainer.container;

          if (opcontainer == container) {
            container->setIntAttr(ITEM_ATTRIBUTE_OPENCONTAINER, ((int)its.first) + 1);
            break;
          }
        }
      }

      queue.emplace_back(container, runningId);
    }

    auto inboxItem = inboxItemsProtobuf.add_item();
    inboxItem->set_pid(pid);
    inboxItem->set_sid(runningId);
    inboxItem->set_id(item->getID());
    inboxItem->set_subtype(item->getSubType());
    item->serializeAttrToProtobuf(inboxItem);
  }

  while (!queue.empty()) {
    const ContainerBlock& cb = queue.front();
    Container* container = cb.first;
    int32_t parentId = cb.second;
    queue.pop_front();

    for (Item* item : container->getItemList()) {
      ++runningId;

      if (Container* subContainer = item->getContainer()) {
        queue.emplace_back(subContainer, runningId);
        if (subContainer->getIntAttr(ITEM_ATTRIBUTE_OPENCONTAINER) > 0) {
          subContainer->setIntAttr(ITEM_ATTRIBUTE_OPENCONTAINER, 0);
        }

        if (!openContainers.empty()) {
          for (const auto& it : openContainers) {
            auto openContainer = it.second;
            auto opcontainer = openContainer.container;

            if (opcontainer == subContainer) {
              subContainer->setIntAttr(ITEM_ATTRIBUTE_OPENCONTAINER, ((int)it.first) + 1);
              break;
            }
          }
        }
      }

      auto inboxItem = inboxItemsProtobuf.add_item();
      inboxItem->set_pid(parentId);
      inboxItem->set_sid(runningId);
      inboxItem->set_id(item->getID());
      inboxItem->set_subtype(item->getSubType());
      item->serializeAttrToProtobuf(inboxItem);
    }
  }

  protobufSize = inboxItemsProtobuf.ByteSizeLong();
  std::unique_ptr<char[]> inboxSerialized(new char[protobufSize]);
  inboxItemsProtobuf.SerializeToArray(&inboxSerialized[0], static_cast<int>(protobufSize));

  query << "," << db.escapeBlob(&inboxSerialized[0], protobufSize);
  // End inbox

  // Stash
  auto stashItemsProtobuf = Canary::protobuf::itemsserialization::ItemsSerialization();
  for (auto const [itemId, count] : player->getStashItems()) {
    auto stashItem = stashItemsProtobuf.add_item();
    stashItem->set_id(itemId);
    stashItem->set_subtype(count);
  }

  protobufSize = stashItemsProtobuf.ByteSizeLong();
  std::unique_ptr<char[]> stashSerialized(new char[protobufSize]);
  stashItemsProtobuf.SerializeToArray(&stashSerialized[0], static_cast<int>(protobufSize));

  query << "," << db.escapeBlob(&stashSerialized[0], protobufSize);
  // End stash

  // Reward
  std::vector<uint32_t> rewardList;
  player->getRewardList(rewardList);
  queue.clear();
  itemList.clear();
  runningId = 100;
  int running = 0;
  auto rewardItemsProtobuf = Canary::protobuf::itemsserialization::ItemsSerialization();
  for (const auto& rewardId : rewardList) {
    // rewards that are empty or older than 7 days aren't stored
    if (Reward* reward = player->getReward(rewardId, false);
        !reward->empty() && (time(nullptr) - rewardId <= 60 * 60 * 24 * 7)) {
      itemList.emplace_back(++running, reward);
    }
  }

  for (const auto& it : itemList) {
    int32_t pid = it.first;
    Item* item = it.second;
    ++runningId;

    if (Container* container = item->getContainer()) {
      if (container->getIntAttr(ITEM_ATTRIBUTE_OPENCONTAINER) > 0) {
        container->setIntAttr(ITEM_ATTRIBUTE_OPENCONTAINER, 0);
      }

      if (!openContainers.empty()) {
        for (const auto& its : openContainers) {
          auto openContainer = its.second;
          auto opcontainer = openContainer.container;

          if (opcontainer == container) {
            container->setIntAttr(ITEM_ATTRIBUTE_OPENCONTAINER, ((int)its.first) + 1);
            break;
          }
        }
      }

      queue.emplace_back(container, runningId);
    }

    auto rewardItem = rewardItemsProtobuf.add_item();
    rewardItem->set_pid(pid);
    rewardItem->set_sid(runningId);
    rewardItem->set_id(item->getID());
    rewardItem->set_subtype(item->getSubType());
    item->serializeAttrToProtobuf(rewardItem);
  }

  while (!queue.empty()) {
    const ContainerBlock& cb = queue.front();
    Container* container = cb.first;
    int32_t parentId = cb.second;
    queue.pop_front();

    for (Item* item : container->getItemList()) {
      ++runningId;

      if (Container* subContainer = item->getContainer()) {
        queue.emplace_back(subContainer, runningId);
        if (subContainer->getIntAttr(ITEM_ATTRIBUTE_OPENCONTAINER) > 0) {
          subContainer->setIntAttr(ITEM_ATTRIBUTE_OPENCONTAINER, 0);
        }

        if (!openContainers.empty()) {
          for (const auto& it : openContainers) {
            auto openContainer = it.second;
            auto opcontainer = openContainer.container;

            if (opcontainer == subContainer) {
              subContainer->setIntAttr(ITEM_ATTRIBUTE_OPENCONTAINER, ((int)it.first) + 1);
              break;
            }
          }
        }
      }

      auto rewardItem = rewardItemsProtobuf.add_item();
      rewardItem->set_pid(parentId);
      rewardItem->set_sid(runningId);
      rewardItem->set_id(item->getID());
      rewardItem->set_subtype(item->getSubType());
      item->serializeAttrToProtobuf(rewardItem);
    }
  }

  protobufSize = rewardItemsProtobuf.ByteSizeLong();
  std::unique_ptr<char[]> rewardSerialized(new char[protobufSize]);
  rewardItemsProtobuf.SerializeToArray(&rewardSerialized[0], static_cast<int>(protobufSize));

  query << "," << db.escapeBlob(&rewardSerialized[0], protobufSize);
  // End reward

  // Player systems
  auto playerSystemsList = Canary::protobuf::playersystems::PlayerSystems();
  
  // Prey
  for (uint8_t slotId = PreySlot_First; slotId <= PreySlot_Last; slotId++) {
    PreySlot* slot = player->getPreySlotById(static_cast<PreySlot_t>(slotId));
    if (slot) {
      auto preyProtobuf = playerSystemsList.add_prey();
      preyProtobuf->set_slot(static_cast<uint32_t>(slot->id));
      preyProtobuf->set_state(static_cast<uint32_t>(slot->state));
      preyProtobuf->set_raceid(static_cast<uint32_t>(slot->selectedRaceId));
      preyProtobuf->set_option(static_cast<uint32_t>(slot->option));
      preyProtobuf->set_bonus_type(static_cast<uint32_t>(slot->bonus));
      preyProtobuf->set_bonus_rarity(static_cast<uint32_t>(slot->bonusRarity));
      preyProtobuf->set_bonus_percentage(static_cast<uint32_t>(slot->bonusPercentage));
      preyProtobuf->set_bonus_time(static_cast<uint32_t>(slot->bonusTimeLeft));
      preyProtobuf->set_free_reroll(static_cast<uint64_t>(slot->freeRerollTimeStamp));
      std::for_each(slot->raceIdList.begin(), slot->raceIdList.end(), [preyProtobuf](uint16_t raceId)
      {
        preyProtobuf->add_grid(static_cast<uint32_t>(raceId));
      });
    }
  }
  // End prey

  // Task hunting
  for (uint8_t slotId = PreySlot_First; slotId <= PreySlot_Last; slotId++) {
    TaskHuntingSlot* slot = player->getTaskHuntingSlotById(static_cast<PreySlot_t>(slotId));
    if (slot) {
      auto taskHuntingProtobuf = playerSystemsList.add_task_hunting();
      taskHuntingProtobuf->set_slot(static_cast<uint32_t>(slot->id));
      taskHuntingProtobuf->set_state(static_cast<uint32_t>(slot->state));
      taskHuntingProtobuf->set_raceid(static_cast<uint32_t>(slot->selectedRaceId));
      taskHuntingProtobuf->set_upgrade(slot->upgrade);
      taskHuntingProtobuf->set_rarity(static_cast<uint32_t>(slot->rarity));
      taskHuntingProtobuf->set_kills(static_cast<uint32_t>(slot->currentKills));
      taskHuntingProtobuf->set_disable_time(static_cast<uint32_t>(slot->disabledUntilTimeStamp));
      taskHuntingProtobuf->set_free_reroll(static_cast<uint64_t>(slot->freeRerollTimeStamp));
      std::for_each(slot->raceIdList.begin(), slot->raceIdList.end(), [taskHuntingProtobuf](uint16_t raceId)
      {
        taskHuntingProtobuf->add_grid(static_cast<uint32_t>(raceId));
      });
    }
  }
  // End task hunting

  // Charm
  auto charmProtobuf = playerSystemsList.add_charms();
  charmProtobuf->set_type(Canary::protobuf::playersystems::CHARM_TYPE::CHARM_TYPE_USED);
  charmProtobuf->set_raceid(static_cast<uint32_t>(player->UsedRunesBit));

  charmProtobuf = playerSystemsList.add_charms();
  charmProtobuf->set_type(Canary::protobuf::playersystems::CHARM_TYPE::CHARM_TYPE_UNLOCKED);
  charmProtobuf->set_raceid(static_cast<uint32_t>(player->UnlockedRunesBit));

  charmProtobuf = playerSystemsList.add_charms();
  charmProtobuf->set_type(Canary::protobuf::playersystems::CHARM_TYPE::CHARM_TYPE_WOUND);
  charmProtobuf->set_raceid(static_cast<uint32_t>(player->charmRuneWound));

  charmProtobuf = playerSystemsList.add_charms();
  charmProtobuf->set_type(Canary::protobuf::playersystems::CHARM_TYPE::CHARM_TYPE_ENFLAME);
  charmProtobuf->set_raceid(static_cast<uint32_t>(player->charmRuneEnflame));

  charmProtobuf = playerSystemsList.add_charms();
  charmProtobuf->set_type(Canary::protobuf::playersystems::CHARM_TYPE::CHARM_TYPE_POISON);
  charmProtobuf->set_raceid(static_cast<uint32_t>(player->charmRunePoison));

  charmProtobuf = playerSystemsList.add_charms();
  charmProtobuf->set_type(Canary::protobuf::playersystems::CHARM_TYPE::CHARM_TYPE_FREEZE);
  charmProtobuf->set_raceid(static_cast<uint32_t>(player->charmRuneFreeze));

  charmProtobuf = playerSystemsList.add_charms();
  charmProtobuf->set_type(Canary::protobuf::playersystems::CHARM_TYPE::CHARM_TYPE_ZAP);
  charmProtobuf->set_raceid(static_cast<uint32_t>(player->charmRuneZap));

  charmProtobuf = playerSystemsList.add_charms();
  charmProtobuf->set_type(Canary::protobuf::playersystems::CHARM_TYPE::CHARM_TYPE_CURSE);
  charmProtobuf->set_raceid(static_cast<uint32_t>(player->charmRuneCurse));

  charmProtobuf = playerSystemsList.add_charms();
  charmProtobuf->set_type(Canary::protobuf::playersystems::CHARM_TYPE::CHARM_TYPE_CRIPPLE);
  charmProtobuf->set_raceid(static_cast<uint32_t>(player->charmRuneCripple));

  charmProtobuf = playerSystemsList.add_charms();
  charmProtobuf->set_type(Canary::protobuf::playersystems::CHARM_TYPE::CHARM_TYPE_PARRY);
  charmProtobuf->set_raceid(static_cast<uint32_t>(player->charmRuneParry));

  charmProtobuf = playerSystemsList.add_charms();
  charmProtobuf->set_type(Canary::protobuf::playersystems::CHARM_TYPE::CHARM_TYPE_DODGE);
  charmProtobuf->set_raceid(static_cast<uint32_t>(player->charmRuneDodge));

  charmProtobuf = playerSystemsList.add_charms();
  charmProtobuf->set_type(Canary::protobuf::playersystems::CHARM_TYPE::CHARM_TYPE_ADRENALINE);
  charmProtobuf->set_raceid(static_cast<uint32_t>(player->charmRuneAdrenaline));

  charmProtobuf = playerSystemsList.add_charms();
  charmProtobuf->set_type(Canary::protobuf::playersystems::CHARM_TYPE::CHARM_TYPE_NUMB);
  charmProtobuf->set_raceid(static_cast<uint32_t>(player->charmRuneNumb));

  charmProtobuf = playerSystemsList.add_charms();
  charmProtobuf->set_type(Canary::protobuf::playersystems::CHARM_TYPE::CHARM_TYPE_CLEANSE);
  charmProtobuf->set_raceid(static_cast<uint32_t>(player->charmRuneCleanse));

  charmProtobuf = playerSystemsList.add_charms();
  charmProtobuf->set_type(Canary::protobuf::playersystems::CHARM_TYPE::CHARM_TYPE_BLESS);
  charmProtobuf->set_raceid(static_cast<uint32_t>(player->charmRuneBless));

  charmProtobuf = playerSystemsList.add_charms();
  charmProtobuf->set_type(Canary::protobuf::playersystems::CHARM_TYPE::CHARM_TYPE_SCAVENGE);
  charmProtobuf->set_raceid(static_cast<uint32_t>(player->charmRuneScavenge));

  charmProtobuf = playerSystemsList.add_charms();
  charmProtobuf->set_type(Canary::protobuf::playersystems::CHARM_TYPE::CHARM_TYPE_GUT);
  charmProtobuf->set_raceid(static_cast<uint32_t>(player->charmRuneGut));

  charmProtobuf = playerSystemsList.add_charms();
  charmProtobuf->set_type(Canary::protobuf::playersystems::CHARM_TYPE::CHARM_TYPE_LOW_BLOW);
  charmProtobuf->set_raceid(static_cast<uint32_t>(player->charmRuneLowBlow));

  charmProtobuf = playerSystemsList.add_charms();
  charmProtobuf->set_type(Canary::protobuf::playersystems::CHARM_TYPE::CHARM_TYPE_DIVINE);
  charmProtobuf->set_raceid(static_cast<uint32_t>(player->charmRuneDivine));

  charmProtobuf = playerSystemsList.add_charms();
  charmProtobuf->set_type(Canary::protobuf::playersystems::CHARM_TYPE::CHARM_TYPE_VAMP);
  charmProtobuf->set_raceid(static_cast<uint32_t>(player->charmRuneVamp));

  charmProtobuf = playerSystemsList.add_charms();
  charmProtobuf->set_type(Canary::protobuf::playersystems::CHARM_TYPE::CHARM_TYPE_VOID);
  charmProtobuf->set_raceid(static_cast<uint32_t>(player->charmRuneVoid));
  // End charm

  // Bestiary tracker
  for (MonsterType* mType : player->getBestiaryTrackerList()) {
    playerSystemsList.add_bestiary_tracker(static_cast<uint32_t>(mType->info.raceid));
  }
  // End bestiary tracker

  protobufSize = playerSystemsList.ByteSizeLong();
  std::unique_ptr<char[]> systemsSerialized(new char[protobufSize]);
  playerSystemsList.SerializeToArray(&systemsSerialized[0], static_cast<int>(protobufSize));

  query << "," << db.escapeBlob(&systemsSerialized[0], protobufSize);
  // End player systems
}

bool IOLoginData::savePlayer(Player* player)
{
  if (player->getHealth() <= 0) {
    player->changeHealth(1);
  }
  Database& db = Database::getInstance();

  std::ostringstream query;
  query << "SELECT `save` FROM `players` WHERE `id` = " << player->getGUID();
  DBResult_ptr result = db.storeQuery(query.str());
  if (!result) {
    SPDLOG_WARN("[IOLoginData::savePlayer] - Error for select result query from player: {}", player->getName());
    return false;
  }

  if (result->getNumber<uint16_t>("save") == 0) {
    query.str(std::string());
    query << "UPDATE `players` SET `lastlogin` = " << player->lastLoginSaved << ", `lastip` = " << player->lastIP << " WHERE `id` = " << player->getGUID();
    return db.executeQuery(query.str());
  }

  //First, an UPDATE query to write the player itself
  query.str(std::string());
  query << "UPDATE `players` SET ";
  query << "`level` = " << player->level << ',';
  query << "`group_id` = " << player->group->id << ',';
  query << "`vocation` = " << player->getVocationId() << ',';
  query << "`health` = " << player->health << ',';
  query << "`healthmax` = " << player->healthMax << ',';
  query << "`experience` = " << player->experience << ',';
  query << "`lookbody` = " << static_cast<uint32_t>(player->defaultOutfit.lookBody) << ',';
  query << "`lookfeet` = " << static_cast<uint32_t>(player->defaultOutfit.lookFeet) << ',';
  query << "`lookhead` = " << static_cast<uint32_t>(player->defaultOutfit.lookHead) << ',';
  query << "`looklegs` = " << static_cast<uint32_t>(player->defaultOutfit.lookLegs) << ',';
  query << "`looktype` = " << player->defaultOutfit.lookType << ',';
  query << "`lookaddons` = " << static_cast<uint32_t>(player->defaultOutfit.lookAddons) << ',';
  query << "`lookmountbody` = " << static_cast<uint32_t>(player->defaultOutfit.lookMountBody) << ',';
  query << "`lookmountfeet` = " << static_cast<uint32_t>(player->defaultOutfit.lookMountFeet) << ',';
  query << "`lookmounthead` = " << static_cast<uint32_t>(player->defaultOutfit.lookMountHead) << ',';
  query << "`lookmountlegs` = " << static_cast<uint32_t>(player->defaultOutfit.lookMountLegs) << ',';
  query << "`lookfamiliarstype` = " << player->defaultOutfit.lookFamiliarsType << ',';
  query << "`isreward` = " << static_cast<uint16_t>(player->isDailyReward) << ',';
  query << "`maglevel` = " << player->magLevel << ',';
  query << "`mana` = " << player->mana << ',';
  query << "`manamax` = " << player->manaMax << ',';
  query << "`manaspent` = " << player->manaSpent << ',';
  query << "`soul` = " << static_cast<uint16_t>(player->soul) << ',';
  query << "`town_id` = " << player->town->getID() << ',';

  const Position& loginPosition = player->getLoginPosition();
  query << "`posx` = " << loginPosition.getX() << ',';
  query << "`posy` = " << loginPosition.getY() << ',';
  query << "`posz` = " << loginPosition.getZ() << ',';

  query << "`prey_wildcard` = " << player->getPreyCards() << ',';
  query << "`task_points` = " << player->getTaskHuntingPoints() << ',';
  query << "`forge_dusts` = " << player->getForgeDusts() << ',';
  query << "`forge_dust_level` = " << player->getForgeDustLevel() << ',';
  query << "`charm_points` = " << player->charmPoints << ',';
  query << "`charm_upgrade` = " << ((player->charmExpansion) ? 1 : 0) << ',';

  query << "`cap` = " << (player->capacity / 100) << ',';
  query << "`sex` = " << static_cast<uint16_t>(player->sex) << ',';

  if (player->lastLoginSaved != 0) {
    query << "`lastlogin` = " << player->lastLoginSaved << ',';
  }

  if (player->lastIP != 0) {
    query << "`lastip` = " << player->lastIP << ',';
  }

  //serialize conditions
  PropWriteStream propWriteStream;
  for (Condition* condition : player->conditions) {
    if (condition->isPersistent()) {
      condition->serialize(propWriteStream);
      propWriteStream.write<uint8_t>(CONDITIONATTR_END);
    }
  }

  size_t attributesSize;
  const char* attributes = propWriteStream.getStream(attributesSize);

  query << "`conditions` = " << db.escapeBlob(attributes, attributesSize) << ',';

  if (g_game().getWorldType() != WORLD_TYPE_PVP_ENFORCED) {
    int64_t skullTime = 0;

    if (player->skullTicks > 0) {
      skullTime = time(nullptr) + player->skullTicks;
    }

    query << "`skulltime` = " << skullTime << ',';

    Skulls_t skull = SKULL_NONE;
    if (player->skull == SKULL_RED) {
      skull = SKULL_RED;
    } else if (player->skull == SKULL_BLACK) {
      skull = SKULL_BLACK;
    }
    query << "`skull` = " << static_cast<int64_t>(skull) << ',';
  }

  query << "`lastlogout` = " << player->getLastLogout() << ',';
  query << "`balance` = " << player->bankBalance << ',';
  query << "`offlinetraining_time` = " << player->getOfflineTrainingTime() / 1000 << ',';
  query << "`offlinetraining_skill` = " << std::to_string(player->getOfflineTrainingSkill()) << ',';
  query << "`stamina` = " << player->getStaminaMinutes() << ',';
  query << "`skill_fist` = " << player->skills[SKILL_FIST].level << ',';
  query << "`skill_fist_tries` = " << player->skills[SKILL_FIST].tries << ',';
  query << "`skill_club` = " << player->skills[SKILL_CLUB].level << ',';
  query << "`skill_club_tries` = " << player->skills[SKILL_CLUB].tries << ',';
  query << "`skill_sword` = " << player->skills[SKILL_SWORD].level << ',';
  query << "`skill_sword_tries` = " << player->skills[SKILL_SWORD].tries << ',';
  query << "`skill_axe` = " << player->skills[SKILL_AXE].level << ',';
  query << "`skill_axe_tries` = " << player->skills[SKILL_AXE].tries << ',';
  query << "`skill_dist` = " << player->skills[SKILL_DISTANCE].level << ',';
  query << "`skill_dist_tries` = " << player->skills[SKILL_DISTANCE].tries << ',';
  query << "`skill_shielding` = " << player->skills[SKILL_SHIELD].level << ',';
  query << "`skill_shielding_tries` = " << player->skills[SKILL_SHIELD].tries << ',';
  query << "`skill_fishing` = " << player->skills[SKILL_FISHING].level << ',';
  query << "`skill_fishing_tries` = " << player->skills[SKILL_FISHING].tries << ',';
  query << "`skill_critical_hit_chance` = " << player->skills[SKILL_CRITICAL_HIT_CHANCE].level << ',';
  query << "`skill_critical_hit_chance_tries` = " << player->skills[SKILL_CRITICAL_HIT_CHANCE].tries << ',';
  query << "`skill_critical_hit_damage` = " << player->skills[SKILL_CRITICAL_HIT_DAMAGE].level << ',';
  query << "`skill_critical_hit_damage_tries` = " << player->skills[SKILL_CRITICAL_HIT_DAMAGE].tries << ',';
  query << "`skill_life_leech_chance` = " << player->skills[SKILL_LIFE_LEECH_CHANCE].level << ',';
  query << "`skill_life_leech_chance_tries` = " << player->skills[SKILL_LIFE_LEECH_CHANCE].tries << ',';
  query << "`skill_life_leech_amount` = " << player->skills[SKILL_LIFE_LEECH_AMOUNT].level << ',';
  query << "`skill_life_leech_amount_tries` = " << player->skills[SKILL_LIFE_LEECH_AMOUNT].tries << ',';
  query << "`skill_mana_leech_chance` = " << player->skills[SKILL_MANA_LEECH_CHANCE].level << ',';
  query << "`skill_mana_leech_chance_tries` = " << player->skills[SKILL_MANA_LEECH_CHANCE].tries << ',';
  query << "`skill_mana_leech_amount` = " << player->skills[SKILL_MANA_LEECH_AMOUNT].level << ',';
  query << "`skill_mana_leech_amount_tries` = " << player->skills[SKILL_MANA_LEECH_AMOUNT].tries << ',';
  query << "`manashield` = " << player->getManaShield() << ',';
  query << "`max_manashield` = " << player->getMaxManaShield() << ',';
  query << "`xpboost_value` = " << player->getStoreXpBoost() << ',';
  query << "`xpboost_stamina` = " << player->getExpBoostStamina() << ',';
  query << "`quickloot_fallback` = " << (player->quickLootFallbackToMainContainer ? 1 : 0) << ',';

  if (!player->isOffline()) {
    query << "`onlinetime` = `onlinetime` + " << (time(nullptr) - player->lastLoginSaved) << ',';
  }
  for (int i = 1; i <= 8; i++) {
    query << "`blessings" << i << "`" << " = " << static_cast<uint32_t>(player->getBlessingCount(i)) << ((i == 8) ? ' ' : ',');
  }

  query << " WHERE `id` = " << player->getGUID();

  DBTransaction transaction;
  if (!transaction.begin()) {
    return false;
  }

  if (!db.executeQuery(query.str())) {
    return false;
  }

   IOLoginDataSave::savePlayerForgeHistory(player);

  // Save items to protobuf
  query.str(std::string());
  query << "DELETE FROM `player_bin_data` WHERE `player_id` = " << player->getGUID();
  if (!db.executeQuery(query.str())) {
    return false;
  }

  query.str(std::string());
  query << "INSERT INTO `player_bin_data` (`player_id`, `inventory`, `depot`, `inbox`, `stash`, `reward`, `systems`) VALUES (" << player->getGUID();
  savePlayerDataToProtobufArray(player, query);
  query << ")";
  if (!db.executeQuery(query.str())) {
    return false;
  }

  // learned spells
  query.str(std::string());
  query << "DELETE FROM `player_spells` WHERE `player_id` = " << player->getGUID();
  if (!db.executeQuery(query.str())) {
    return false;
  }

  // Player spells
  query.str(std::string());
  DBInsert spellsQuery("INSERT INTO `player_spells` (`player_id`, `name` ) VALUES ");
  for (const std::string& spellName : player->learnedInstantSpellList) {
    query << player->getGUID() << ',' << db.escapeString(spellName);
    if (!spellsQuery.addRow(query)) {
      return false;
    }
  }

  if (!spellsQuery.execute()) {
    return false;
  }

  //player kills
  query.str(std::string());
  query << "DELETE FROM `player_kills` WHERE `player_id` = " << player->getGUID();
  if (!db.executeQuery(query.str())) {
    return false;
  }

  // Player kills
  query.str(std::string());
  DBInsert killsQuery("INSERT INTO `player_kills` (`player_id`, `target`, `time`, `unavenged`) VALUES");
  for (const auto& kill : player->unjustifiedKills) {
    query << player->getGUID() << ',' << kill.target << ',' << kill.time << ',' << kill.unavenged;
    if (!killsQuery.addRow(query)) {
      return false;
    }
  }

  if (!killsQuery.execute()) {
    return false;
  }

  // Player storages
  query.str(std::string());
  DBInsert storageQuery("INSERT INTO `player_storage` (`player_id`, `key`, `value`) VALUES ");
  player->genReservedStorageRange();

  for (const auto& it : player->storageMap) {
    query << player->getGUID() << ',' << it.first << ',' << it.second;
    if (!storageQuery.addRow(query)) {
      return false;
    }
  }

  if (!storageQuery.execute()) {
    return false;
  }

  //End the transaction
  return transaction.commit();
}

std::string IOLoginData::getNameByGuid(uint32_t guid)
{
  std::ostringstream query;
  query << "SELECT `name` FROM `players` WHERE `id` = " << guid;
  DBResult_ptr result = Database::getInstance().storeQuery(query.str());
  if (!result) {
    return std::string();
  }
  return result->getString("name");
}

uint32_t IOLoginData::getGuidByName(const std::string& name)
{
  Database& db = Database::getInstance();

  std::ostringstream query;
  query << "SELECT `id` FROM `players` WHERE `name` = " << db.escapeString(name);
  DBResult_ptr result = db.storeQuery(query.str());
  if (!result) {
    return 0;
  }
  return result->getNumber<uint32_t>("id");
}

bool IOLoginData::getGuidByNameEx(uint32_t& guid, bool& specialVip, std::string& name)
{
  Database& db = Database::getInstance();

  std::ostringstream query;
  query << "SELECT `name`, `id`, `group_id`, `account_id` FROM `players` WHERE `name` = " << db.escapeString(name);
  DBResult_ptr result = db.storeQuery(query.str());
  if (!result) {
    return false;
  }

  name = result->getString("name");
  guid = result->getNumber<uint32_t>("id");
  if (auto group = g_game().groups.getGroup(result->getNumber<uint16_t>("group_id"))) {
    specialVip = group->flags[Groups::getFlagNumber(PlayerFlags_t::SpecialVIP)];
  } else {
    specialVip = false;
  }

  return true;
}

bool IOLoginData::formatPlayerName(std::string& name)
{
  Database& db = Database::getInstance();

  std::ostringstream query;
  query << "SELECT `name` FROM `players` WHERE `name` = " << db.escapeString(name);

  DBResult_ptr result = db.storeQuery(query.str());
  if (!result) {
    return false;
  }

  name = result->getString("name");
  return true;
}

void IOLoginData::loadPlayerDataFromProtobufArray(Player* player, DBResult_ptr result)
{
  ItemMap itemMap;
  unsigned long protobufSize;
  const char* protobufArray;
  std::vector<std::pair<uint8_t, Container*>> openContainersList;

  // Stash
  protobufSize = 0;
  protobufArray = result->getStream("stash", protobufSize);
  auto stashProtobufList = Canary::protobuf::itemsserialization::ItemsSerialization();
  stashProtobufList.ParseFromArray(protobufArray, protobufSize);
  for (const auto& stashItem : stashProtobufList.item()) {
    player->addItemOnStash(static_cast<uint16_t>(stashItem.id()), stashItem.subtype());
  }
  // End stash

  // Inventory
  protobufSize = 0;
  protobufArray = result->getStream("inventory", protobufSize);
  auto inventoryProtobufList = Canary::protobuf::itemsserialization::ItemsSerialization();
  inventoryProtobufList.ParseFromArray(protobufArray, protobufSize);
  for (const auto& inventoryItem : inventoryProtobufList.item()) {
    Item* item = Item::CreateItem(static_cast<uint16_t>(inventoryItem.id()), static_cast<uint16_t>(inventoryItem.subtype()));
    if (!item) {
      SPDLOG_WARN("[IOLoginData::loadPlayerDataFromProtobufArray::Inventory] - Item with id '{}' could not be created and was ignored.", inventoryItem.id());
      continue;
    }

    if (inventoryItem.attribute_size() > 0 && !item->unserializeAttrFromProtobuf(inventoryItem)) {
      SPDLOG_WARN("[IOLoginData::loadPlayerDataFromProtobufArray::Inventory] - Item with id '{}' attributes could not be unserialized and was ignored.", inventoryItem.id());
      delete item;
      continue;
    }

    std::pair<Item*, uint32_t> pair(item, inventoryItem.pid());
    itemMap[inventoryItem.sid()] = pair;
  }

  for (ItemMap::const_reverse_iterator it = itemMap.rbegin(), end = itemMap.rend(); it != end; ++it) {
    const std::pair<Item*, int32_t>& pair = it->second;
    Item* item = pair.first;
    if (!item) {
      continue;
    }

    int32_t pid = pair.second;

    if (pid >= CONST_SLOT_FIRST && pid <= CONST_SLOT_LAST) {
      player->internalAddThing(pid, item);
      item->startDecaying();
    } else {
      ItemMap::const_iterator it2 = itemMap.find(pid);
      if (it2 == itemMap.end()) {
        continue;
      }

      if (Container* container = it2->second.first->getContainer()) {
        container->internalAddThing(item);
        item->startDecaying();
      }
    }

    if (Container* itemContainer = item->getContainer()) {
      int64_t cid = item->getIntAttr(ITEM_ATTRIBUTE_OPENCONTAINER);
      if (cid > 0) {
        openContainersList.emplace_back(std::make_pair(cid, itemContainer));
      }

      if (item->hasAttribute(ITEM_ATTRIBUTE_QUICKLOOTCONTAINER)) {
        int64_t flags = item->getIntAttr(ITEM_ATTRIBUTE_QUICKLOOTCONTAINER);
        for (uint8_t category = OBJECTCATEGORY_FIRST; category <= OBJECTCATEGORY_LAST; category++) {
          if (hasBitSet(1 << category, flags)) {
            player->setLootContainer((ObjectCategory_t)category, itemContainer, true);
          }
        }
      }
    }
  }

  std::sort(openContainersList.begin(), openContainersList.end(), [](const std::pair<uint8_t, Container*> &left, const std::pair<uint8_t, Container*> &right) {
    return left.first < right.first;
  });

  for (auto& it : openContainersList) {
    player->addContainer(it.first - 1, it.second);
    player->onSendContainer(it.second);
  }
  // End inventory

  // Depot
  itemMap.clear();
  protobufSize = 0;
  protobufArray = result->getStream("depot", protobufSize);
  auto depotProtobufList = Canary::protobuf::itemsserialization::ItemsSerialization();
  depotProtobufList.ParseFromArray(protobufArray, protobufSize);
  for (const auto& depotItem : depotProtobufList.item()) {
    Item* item = Item::CreateItem(static_cast<uint16_t>(depotItem.id()), static_cast<uint16_t>(depotItem.subtype()));
    if (!item) {
      SPDLOG_WARN("[IOLoginData::loadPlayerDataFromProtobufArray::Depot] - Item with id '{}' could not be created and was ignored.", depotItem.id());
      continue;
    }

    if (depotItem.attribute_size() > 0 && !item->unserializeAttrFromProtobuf(depotItem)) {
      SPDLOG_WARN("[IOLoginData::loadPlayerDataFromProtobufArray::Depot] - Item with id '{}' attributes could not be unserialized and was ignored.", depotItem.id());
      delete item;
      continue;
    }

    std::pair<Item*, uint32_t> pair(item, depotItem.pid());
    itemMap[depotItem.sid()] = pair;
  }

  for (ItemMap::const_reverse_iterator it = itemMap.rbegin(), end = itemMap.rend(); it != end; ++it) {
    const std::pair<Item*, int32_t>& pair = it->second;
    Item* item = pair.first;

    int32_t pid = pair.second;
    if (pid >= 0 && pid < 100) {
      if (DepotChest* depotChest = player->getDepotChest(pid, true)) {
        depotChest->internalAddThing(item);
        item->startDecaying();
      }
    } else {
      ItemMap::const_iterator it2 = itemMap.find(pid);
      if (it2 == itemMap.end()) {
        continue;
      }

      if (Container* container = it2->second.first->getContainer()) {
        container->internalAddThing(item);
        item->startDecaying();
      }
    }
  }
  // End depot

  // Reward
  itemMap.clear();
  protobufSize = 0;
  protobufArray = result->getStream("reward", protobufSize);
  auto rewardProtobufList = Canary::protobuf::itemsserialization::ItemsSerialization();
  rewardProtobufList.ParseFromArray(protobufArray, protobufSize);
  for (const auto& rewardItem : rewardProtobufList.item()) {
    Item* item = Item::CreateItem(static_cast<uint16_t>(rewardItem.id()), static_cast<uint16_t>(rewardItem.subtype()));
    if (!item) {
      SPDLOG_WARN("[IOLoginData::loadPlayerDataFromProtobufArray::Reward] - Item with id '{}' could not be created and was ignored.", rewardItem.id());
      continue;
    }

    if (rewardItem.attribute_size() > 0 && !item->unserializeAttrFromProtobuf(rewardItem)) {
      SPDLOG_WARN("[IOLoginData::loadPlayerDataFromProtobufArray::Reward] - Item with id '{}' attributes could not be unserialized and was ignored.", rewardItem.id());
      delete item;
      continue;
    }

    std::pair<Item*, uint32_t> pair(item, rewardItem.pid());
    itemMap[rewardItem.sid()] = pair;
  }

  // First loop handles the reward containers to retrieve it's date attribute
  for (auto& it : itemMap) {
    const std::pair<Item*, int32_t>& pair = it.second;
    Item* item = pair.first;

    int32_t pid = pair.second;
    if (pid < 0 || pid >= 100) {
      break;
    }

    // Update the map with the special reward container
    if (Reward* reward = player->getReward(item->getIntAttr(ITEM_ATTRIBUTE_DATE), true)) {
      it.second = std::pair<Item*, int32_t>(reward->getItem(), pid); 
    }
  }

  // Second loop (this time a reverse one) to insert the items in the correct order
  for (const auto& it : std::views::reverse(itemMap)) {
    const std::pair<Item*, int32_t>& pair = it.second;
    Item* item = pair.first;

    int32_t pid = pair.second;
    if (pid >= 0 && pid < 100) {
      break;
    }

    ItemMap::const_iterator it2 = itemMap.find(pid);
    if (it2 == itemMap.end()) {
      continue;
    }

    if (Container* container = it2->second.first->getContainer()) {
      container->internalAddThing(item);
    }
  }
  // End reward

  // Inbox
  itemMap.clear();
  protobufSize = 0;
  protobufArray = result->getStream("inbox", protobufSize);
  auto inboxProtobufList = Canary::protobuf::itemsserialization::ItemsSerialization();
  inboxProtobufList.ParseFromArray(protobufArray, protobufSize);
  for (const auto& inboxtem : inboxProtobufList.item()) {
    Item* item = Item::CreateItem(static_cast<uint16_t>(inboxtem.id()), static_cast<uint16_t>(inboxtem.subtype()));
    if (!item) {
      SPDLOG_WARN("[IOLoginData::loadPlayerDataFromProtobufArray::Inbox] - Item with id '{}' could not be created and was ignored.", inboxtem.id());
      continue;
    }

    if (inboxtem.attribute_size() > 0 && !item->unserializeAttrFromProtobuf(inboxtem)) {
      SPDLOG_WARN("[IOLoginData::loadPlayerDataFromProtobufArray::Inbox] - Item with id '{}' attributes could not be unserialized and was ignored.", inboxtem.id());
      delete item;
      continue;
    }

    std::pair<Item*, uint32_t> pair(item, inboxtem.pid());
    itemMap[inboxtem.sid()] = pair;
  }

  for (ItemMap::const_reverse_iterator it = itemMap.rbegin(), end = itemMap.rend(); it != end; ++it) {
    const std::pair<Item*, int32_t>& pair = it->second;
    Item* item = pair.first;
    int32_t pid = pair.second;

    if (pid >= 0 && pid < 100) {
      player->getInbox()->internalAddThing(item);
      item->startDecaying();
    } else {
      ItemMap::const_iterator it2 = itemMap.find(pid);

      if (it2 == itemMap.end()) {
        continue;
      }

      if (Container* container = it2->second.first->getContainer()) {
        container->internalAddThing(item);
        item->startDecaying();
      }
    }
  }
  // End inbox

  // Player systems
  protobufSize = 0;
  protobufArray = result->getStream("systems", protobufSize);
  auto systemsProtobufList = Canary::protobuf::playersystems::PlayerSystems();
  systemsProtobufList.ParseFromArray(protobufArray, protobufSize);

  // Task hunting
  for (const auto& taskHuntingIt : systemsProtobufList.task_hunting()) {
    auto slot = new TaskHuntingSlot(static_cast<PreySlot_t>(taskHuntingIt.slot()));
    slot->state = static_cast<PreyTaskDataState_t>(taskHuntingIt.state());
    slot->selectedRaceId = static_cast<uint16_t>(taskHuntingIt.raceid());
    slot->upgrade = taskHuntingIt.upgrade();
    slot->rarity = static_cast<uint8_t>(taskHuntingIt.rarity());
    slot->currentKills = static_cast<uint16_t>(taskHuntingIt.kills());
    slot->disabledUntilTimeStamp = taskHuntingIt.disable_time();
    slot->freeRerollTimeStamp = taskHuntingIt.free_reroll();
  
    for (const auto& raceId : taskHuntingIt.grid()) {
      slot->raceIdList.push_back(static_cast<uint16_t>(raceId));
    }

    if (slot->state == PreyTaskDataState_Inactive && slot->disabledUntilTimeStamp < OTSYS_TIME()) {
      slot->state = PreyTaskDataState_Selection;
    }

    player->setTaskHuntingSlotClass(slot);
  }
  // End task hunting

  // Prey
  for (const auto& preyIt : systemsProtobufList.prey()) {
    auto slot = new PreySlot(static_cast<PreySlot_t>(preyIt.slot()));

    slot->state = static_cast<PreyDataState_t>(preyIt.state());
    slot->selectedRaceId = static_cast<uint16_t>(preyIt.raceid());
    slot->option = static_cast<PreyOption_t>(preyIt.option());
    slot->bonus = static_cast<PreyBonus_t>(preyIt.bonus_type());
    slot->bonusRarity = static_cast<uint8_t>(preyIt.bonus_rarity());
    slot->bonusPercentage = static_cast<uint16_t>(preyIt.bonus_percentage());
    slot->bonusTimeLeft = static_cast<uint16_t>(preyIt.bonus_time());
    slot->freeRerollTimeStamp = preyIt.free_reroll();

    for (const auto& raceId : preyIt.grid()) {
      slot->raceIdList.push_back(static_cast<uint16_t>(raceId));
    }

    player->setPreySlotClass(slot);
  }
  // End prey

  // Charm
  for (const auto& charmIt : systemsProtobufList.charms()) {
    switch (charmIt.type()) {
      case (Canary::protobuf::playersystems::CHARM_TYPE::CHARM_TYPE_USED): {
        player->UsedRunesBit = charmIt.raceid();
        break;
      }
      case (Canary::protobuf::playersystems::CHARM_TYPE::CHARM_TYPE_UNLOCKED): {
        player->UnlockedRunesBit = charmIt.raceid();
        break;
      }
      case (Canary::protobuf::playersystems::CHARM_TYPE::CHARM_TYPE_WOUND): {
        player->charmRuneWound = static_cast<uint16_t>(charmIt.raceid());
        break;
      }
      case (Canary::protobuf::playersystems::CHARM_TYPE::CHARM_TYPE_ENFLAME): {
        player->charmRuneEnflame = static_cast<uint16_t>(charmIt.raceid());
        break;
      }
      case (Canary::protobuf::playersystems::CHARM_TYPE::CHARM_TYPE_POISON): {
        player->charmRunePoison = static_cast<uint16_t>(charmIt.raceid());
        break;
      }
      case (Canary::protobuf::playersystems::CHARM_TYPE::CHARM_TYPE_FREEZE): {
        player->charmRuneFreeze = static_cast<uint16_t>(charmIt.raceid());
        break;
      }
      case (Canary::protobuf::playersystems::CHARM_TYPE::CHARM_TYPE_ZAP): {
        player->charmRuneZap = static_cast<uint16_t>(charmIt.raceid());
        break;
      }
      case (Canary::protobuf::playersystems::CHARM_TYPE::CHARM_TYPE_CURSE): {
        player->charmRuneCurse = static_cast<uint16_t>(charmIt.raceid());
        break;
      }
      case (Canary::protobuf::playersystems::CHARM_TYPE::CHARM_TYPE_CRIPPLE): {
        player->charmRuneCripple = static_cast<uint16_t>(charmIt.raceid());
        break;
      }
      case (Canary::protobuf::playersystems::CHARM_TYPE::CHARM_TYPE_PARRY): {
        player->charmRuneParry = static_cast<uint16_t>(charmIt.raceid());
        break;
      }
      case (Canary::protobuf::playersystems::CHARM_TYPE::CHARM_TYPE_DODGE): {
        player->charmRuneDodge = static_cast<uint16_t>(charmIt.raceid());
        break;
      }
      case (Canary::protobuf::playersystems::CHARM_TYPE::CHARM_TYPE_ADRENALINE): {
        player->charmRuneAdrenaline = static_cast<uint16_t>(charmIt.raceid());
        break;
      }
      case (Canary::protobuf::playersystems::CHARM_TYPE::CHARM_TYPE_NUMB): {
        player->charmRuneNumb = static_cast<uint16_t>(charmIt.raceid());
        break;
      }
      case (Canary::protobuf::playersystems::CHARM_TYPE::CHARM_TYPE_CLEANSE): {
        player->charmRuneCleanse = static_cast<uint16_t>(charmIt.raceid());
        break;
      }
      case (Canary::protobuf::playersystems::CHARM_TYPE::CHARM_TYPE_BLESS): {
        player->charmRuneBless = static_cast<uint16_t>(charmIt.raceid());
        break;
      }
      case (Canary::protobuf::playersystems::CHARM_TYPE::CHARM_TYPE_SCAVENGE): {
        player->charmRuneScavenge = static_cast<uint16_t>(charmIt.raceid());
        break;
      }
      case (Canary::protobuf::playersystems::CHARM_TYPE::CHARM_TYPE_GUT): {
        player->charmRuneGut = static_cast<uint16_t>(charmIt.raceid());
        break;
      }
      case (Canary::protobuf::playersystems::CHARM_TYPE::CHARM_TYPE_LOW_BLOW): {
        player->charmRuneLowBlow = static_cast<uint16_t>(charmIt.raceid());
        break;
      }
      case (Canary::protobuf::playersystems::CHARM_TYPE::CHARM_TYPE_DIVINE): {
        player->charmRuneDivine = static_cast<uint16_t>(charmIt.raceid());
        break;
      }
      case (Canary::protobuf::playersystems::CHARM_TYPE::CHARM_TYPE_VAMP): {
        player->charmRuneVamp = static_cast<uint16_t>(charmIt.raceid());
        break;
      }
      case (Canary::protobuf::playersystems::CHARM_TYPE::CHARM_TYPE_VOID): {
        player->charmRuneVoid = static_cast<uint16_t>(charmIt.raceid());
        break;
      }
      default: {
        break;
      }
    }
  }
  // End charm

  // Bestiary tracker
  for (const auto& trackerRaceId : systemsProtobufList.bestiary_tracker()) {
    if (MonsterType* mType = g_monsters().getMonsterTypeByRaceId(static_cast<uint16_t>(trackerRaceId))) {
      player->addBestiaryTrackerList(mType);
    }
  }
  // End bestiary tracker
  // End player systems
}

void IOLoginData::increaseBankBalance(uint32_t guid, uint64_t bankBalance)
{
  std::ostringstream query;
  query << "UPDATE `players` SET `balance` = `balance` + " << bankBalance << " WHERE `id` = " << guid;
  Database::getInstance().executeQuery(query.str());
}

bool IOLoginData::hasBiddedOnHouse(uint32_t guid)
{
  Database& db = Database::getInstance();

  std::ostringstream query;
  query << "SELECT `id` FROM `houses` WHERE `highest_bidder` = " << guid << " LIMIT 1";
  return db.storeQuery(query.str()).get() != nullptr;
}

std::forward_list<VIPEntry> IOLoginData::getVIPEntries(uint32_t accountId)
{
  std::forward_list<VIPEntry> entries;

  std::ostringstream query;
  query << "SELECT `player_id`, (SELECT `name` FROM `players` WHERE `id` = `player_id`) AS `name`, `description`, `icon`, `notify` FROM `account_viplist` WHERE `account_id` = " << accountId;

  DBResult_ptr result = Database::getInstance().storeQuery(query.str());
  if (result) {
    do {
      entries.emplace_front(
        result->getNumber<uint32_t>("player_id"),
        result->getString("name"),
        result->getString("description"),
        result->getNumber<uint32_t>("icon"),
        result->getNumber<uint16_t>("notify") != 0
      );
    } while (result->next());
  }
  return entries;
}

void IOLoginData::addVIPEntry(uint32_t accountId, uint32_t guid, const std::string& description, uint32_t icon, bool notify)
{
  Database& db = Database::getInstance();

  std::ostringstream query;
  query << "INSERT INTO `account_viplist` (`account_id`, `player_id`, `description`, `icon`, `notify`) VALUES (" << accountId << ',' << guid << ',' << db.escapeString(description) << ',' << icon << ',' << notify << ')';
  db.executeQuery(query.str());
}

void IOLoginData::editVIPEntry(uint32_t accountId, uint32_t guid, const std::string& description, uint32_t icon, bool notify)
{
  Database& db = Database::getInstance();

  std::ostringstream query;
  query << "UPDATE `account_viplist` SET `description` = " << db.escapeString(description) << ", `icon` = " << icon << ", `notify` = " << notify << " WHERE `account_id` = " << accountId << " AND `player_id` = " << guid;
  db.executeQuery(query.str());
}

void IOLoginData::removeVIPEntry(uint32_t accountId, uint32_t guid)
{
  std::ostringstream query;
  query << "DELETE FROM `account_viplist` WHERE `account_id` = " << accountId << " AND `player_id` = " << guid;
  Database::getInstance().executeQuery(query.str());
}

void IOLoginData::addPremiumDays(uint32_t accountId, int32_t addDays)
{
  std::ostringstream query;
  query << "UPDATE `accounts` SET `premdays` = `premdays` + " << addDays << " WHERE `id` = " << accountId;
  Database::getInstance().executeQuery(query.str());
}

void IOLoginData::removePremiumDays(uint32_t accountId, int32_t removeDays)
{
  std::ostringstream query;
  query << "UPDATE `accounts` SET `premdays` = `premdays` - " << removeDays << " WHERE `id` = " << accountId;
  Database::getInstance().executeQuery(query.str());
}
