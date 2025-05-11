/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2024 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#include "game/instances/instance_manager.hpp"
#include "game/game.hpp"
#include "map/map.hpp"
#include "utils/tools.hpp"

uint32_t InstanceManager::createInstance(const std::shared_ptr<Player> &player, const std::string &mapName, const Position &entryPosition, const Position &exitPosition, bool isPartyInstance) {
	if (!player) {
		return 0;
	}

	// Check if player already has an instance
	auto playerIdIt = playerInstances.find(player->getID());
	if (playerIdIt != playerInstances.end()) {
		// Player already has an instance, return that ID
		return playerIdIt->second;
	}
	
	// If this is a party instance, check if the party already has an instance
	uint32_t partyId = 0;
	if (isPartyInstance) {
		auto party = player->getParty();
		if (party) {
			partyId = party->getID();
			auto partyInstanceIt = partyInstances.find(partyId);
			if (partyInstanceIt != partyInstances.end()) {
				// Party already has an instance, add player to it and return that ID
				uint32_t existingInstanceId = partyInstanceIt->second;
				addPlayerToInstance(player, existingInstanceId);
				return existingInstanceId;
			}
		} else {
			// Player doesn't have a party, treat as a normal instance
			isPartyInstance = false;
		}
	}

	// Create a new instance
	uint32_t instanceId = nextInstanceId++;
	
	// Create instance data
	InstanceData instanceData;
	instanceData.instanceId = instanceId;
	instanceData.ownerId = player->getID();
	instanceData.isPartyInstance = isPartyInstance;
	instanceData.partyId = partyId;
	instanceData.mapName = mapName;
	instanceData.creationTime = time(nullptr);
	instanceData.entryPosition = entryPosition;
	instanceData.exitPosition = exitPosition;
	instanceData.active = true;
	instanceData.playerIds.push_back(player->getID());
	
	// Store the instance data
	instances[instanceId] = instanceData;
	playerInstances[player->getID()] = instanceId;
	
	// If this is a party instance, map the party to the instance
	if (isPartyInstance && partyId > 0) {
		partyInstances[partyId] = instanceId;
		g_logger().info("Created party instance {} for party {} (leader: {}) using map {}", 
			instanceId, partyId, player->getName(), mapName);
	} else {
		g_logger().info("Created instance {} for player {} using map {}", 
			instanceId, player->getName(), mapName);
	}
	
	// Load the instance map
	// We use the custom map loading functionality to load the instance map
	// The instance index is the instance ID
	g_game().map.loadMapCustom(mapName, true, true, true, true, instanceId);
	
	return instanceId;
}

bool InstanceManager::teleportToInstance(const std::shared_ptr<Player> &player, uint32_t instanceId) {
	if (!player) {
		return false;
	}
	
	// Find the instance
	auto instanceIt = instances.find(instanceId);
	if (instanceIt == instances.end()) {
		return false;
	}
	
	// Check if the player is allowed to enter this instance
	bool canEnter = false;
	
	// If this is a party instance, check if the player is in the party
	if (instanceIt->second.isPartyInstance) {
		auto party = player->getParty();
		if (party && party->getID() == instanceIt->second.partyId) {
			canEnter = true;
		}
	}
	
	// If the player is the owner of the instance, they can always enter
	if (instanceIt->second.ownerId == player->getID()) {
		canEnter = true;
	}
	
	// Check if the player is already in the instance's player list
	for (uint32_t playerId : instanceIt->second.playerIds) {
		if (playerId == player->getID()) {
			canEnter = true;
			break;
		}
	}
	
	if (!canEnter) {
		return false;
	}
	
	// Add player to the instance if not already in it
	bool playerInInstance = false;
	for (uint32_t playerId : instanceIt->second.playerIds) {
		if (playerId == player->getID()) {
			playerInInstance = true;
			break;
		}
	}
	
	if (!playerInInstance) {
		instanceIt->second.playerIds.push_back(player->getID());
		playerInstances[player->getID()] = instanceId;
	}
	
	// Teleport the player to the instance entry position
	const Position &destPos = instanceIt->second.entryPosition;
	g_game().internalTeleport(player, destPos);
	
	g_logger().info("Player {} teleported to instance {}", player->getName(), instanceId);
	
	return true;
}

bool InstanceManager::teleportFromInstance(const std::shared_ptr<Player> &player) {
	if (!player) {
		return false;
	}
	
	// Check if player is in an instance
	auto playerIdIt = playerInstances.find(player->getID());
	if (playerIdIt == playerInstances.end()) {
		return false;
	}
	
	// Get the instance data
	auto instanceIt = instances.find(playerIdIt->second);
	if (instanceIt == instances.end()) {
		// Instance not found, remove player from instances map
		playerInstances.erase(playerIdIt);
		return false;
	}
	
	// Remove player from the instance
	removePlayerFromInstance(player->getID());
	
	// Teleport the player back to the main world
	const Position &exitPos = instanceIt->second.exitPosition;
	g_game().internalTeleport(player, exitPos);
	
	g_logger().info("Player {} teleported from instance {}", player->getName(), instanceIt->second.instanceId);
	
	return true;
}

bool InstanceManager::isPlayerInInstance(const std::shared_ptr<Player> &player) {
	if (!player) {
		return false;
	}
	
	return playerInstances.find(player->getID()) != playerInstances.end();
}

uint32_t InstanceManager::getPlayerInstanceId(const std::shared_ptr<Player> &player) {
	if (!player) {
		return 0;
	}
	
	auto playerIdIt = playerInstances.find(player->getID());
	if (playerIdIt == playerInstances.end()) {
		return 0;
	}
	
	return playerIdIt->second;
}

bool InstanceManager::removeInstance(uint32_t instanceId) {
	// Find the instance
	auto instanceIt = instances.find(instanceId);
	if (instanceIt == instances.end()) {
		return false;
	}
	
	// Remove all players from the instance
	for (uint32_t playerId : instanceIt->second.playerIds) {
		playerInstances.erase(playerId);
	}
	
	// If this is a party instance, remove the party from instances map
	if (instanceIt->second.isPartyInstance && instanceIt->second.partyId > 0) {
		partyInstances.erase(instanceIt->second.partyId);
	}
	
	// Remove the instance
	instances.erase(instanceIt);
	
	g_logger().info("Removed instance {}", instanceId);
	
	return true;
}

void InstanceManager::cleanupInstances(uint32_t maxAge) {
	time_t currentTime = time(nullptr);
	
	// Find expired instances
	std::vector<uint32_t> expiredInstances;
	for (const auto &[instanceId, instanceData] : instances) {
		if (currentTime - instanceData.creationTime > maxAge) {
			expiredInstances.push_back(instanceId);
		}
	}
	
	// Remove expired instances
	for (uint32_t instanceId : expiredInstances) {
		removeInstance(instanceId);
	}
	
	if (!expiredInstances.empty()) {
		g_logger().info("Cleaned up {} expired instances", expiredInstances.size());
	}
}

uint32_t InstanceManager::getPartyInstanceId(uint32_t partyId) {
	auto partyInstanceIt = partyInstances.find(partyId);
	if (partyInstanceIt == partyInstances.end()) {
		return 0;
	}
	
	return partyInstanceIt->second;
}

bool InstanceManager::teleportToPartyMemberInstance(const std::shared_ptr<Player> &player, const std::shared_ptr<Player> &partyMember) {
	if (!player || !partyMember) {
		return false;
	}
	
	// Check if the party member is in an instance
	auto memberInstanceIt = playerInstances.find(partyMember->getID());
	if (memberInstanceIt == playerInstances.end()) {
		return false;
	}
	
	// Get the instance data
	auto instanceIt = instances.find(memberInstanceIt->second);
	if (instanceIt == instances.end()) {
		return false;
	}
	
	// Check if this is a party instance
	if (!instanceIt->second.isPartyInstance) {
		return false;
	}
	
	// Check if both players are in the same party
	auto playerParty = player->getParty();
	auto memberParty = partyMember->getParty();
	
	if (!playerParty || !memberParty || playerParty->getID() != memberParty->getID()) {
		return false;
	}
	
	// Teleport the player to the instance
	return teleportToInstance(player, instanceIt->second.instanceId);
}

bool InstanceManager::addPlayerToInstance(const std::shared_ptr<Player> &player, uint32_t instanceId) {
	if (!player) {
		return false;
	}
	
	// Find the instance
	auto instanceIt = instances.find(instanceId);
	if (instanceIt == instances.end()) {
		return false;
	}
	
	// Check if player is already in the instance
	for (uint32_t playerId : instanceIt->second.playerIds) {
		if (playerId == player->getID()) {
			return true; // Player is already in the instance
		}
	}
	
	// Add player to the instance
	instanceIt->second.playerIds.push_back(player->getID());
	playerInstances[player->getID()] = instanceId;
	
	g_logger().info("Added player {} to instance {}", player->getName(), instanceId);
	
	return true;
}

bool InstanceManager::removePlayerFromInstance(uint32_t playerId) {
	// Check if player is in an instance
	auto playerIdIt = playerInstances.find(playerId);
	if (playerIdIt == playerInstances.end()) {
		return false;
	}
	
	uint32_t instanceId = playerIdIt->second;
	
	// Find the instance
	auto instanceIt = instances.find(instanceId);
	if (instanceIt == instances.end()) {
		// Instance not found, remove player from instances map
		playerInstances.erase(playerIdIt);
		return false;
	}
	
	// Remove player from the instance's player list
	auto &playerIds = instanceIt->second.playerIds;
	playerIds.erase(std::remove(playerIds.begin(), playerIds.end(), playerId), playerIds.end());
	
	// Remove player from instances map
	playerInstances.erase(playerId);
	
	// If this is a party instance and there are no more players, remove the instance
	if (instanceIt->second.isPartyInstance && playerIds.empty()) {
		removeInstance(instanceId);
	}
	// If this is a personal instance and the owner left, remove the instance
	else if (!instanceIt->second.isPartyInstance && instanceIt->second.ownerId == playerId) {
		removeInstance(instanceId);
	}
	
	g_logger().info("Removed player {} from instance {}", playerId, instanceId);
	
	return true;
}

bool InstanceManager::consumePortal(uint32_t instanceId) {
	// Find the instance
	auto instanceIt = instances.find(instanceId);
	if (instanceIt == instances.end()) {
		return false;
	}
	
	// Check if there are portals to consume
	if (instanceIt->second.remainingPortals <= 0) {
		return false;
	}
	
	// Consume a portal
	instanceIt->second.remainingPortals--;
	
	// If there are portal positions stored, remove the last one
	if (!instanceIt->second.portalPositions.empty()) {
		instanceIt->second.portalPositions.pop_back();
	}
	
	g_logger().info("Consumed a portal from instance {}. Remaining: {}", 
		instanceId, static_cast<uint32_t>(instanceIt->second.remainingPortals));
	
	// If no portals remain, remove the instance
	if (instanceIt->second.remainingPortals <= 0) {
		g_logger().info("No more portals remaining for instance {}. Removing instance.", instanceId);
		
		// Get a copy of player IDs before removing the instance
		std::vector<uint32_t> playerIds = instanceIt->second.playerIds;
		
		// Remove the instance
		removeInstance(instanceId);
		
		// Teleport all players out of the instance
		for (uint32_t playerId : playerIds) {
			auto player = g_game().getPlayerByID(playerId);
			if (player) {
				// Teleport the player back to the main world
				// We need to use the exit position from before the instance was removed
				const Position &exitPos = instanceIt->second.exitPosition;
				g_game().internalTeleport(player, exitPos);
				
				// Send a message to the player
				player->sendTextMessage(MESSAGE_EVENT_ADVANCE, "The instance has been closed because all portals were consumed.");
			}
		}
	}
	
	return true;
}

uint8_t InstanceManager::getRemainingPortals(uint32_t instanceId) {
	// Find the instance
	auto instanceIt = instances.find(instanceId);
	if (instanceIt == instances.end()) {
		return 0;
	}
	
	return instanceIt->second.remainingPortals;
}

bool InstanceManager::addPortalPosition(uint32_t instanceId, const Position &position) {
	// Find the instance
	auto instanceIt = instances.find(instanceId);
	if (instanceIt == instances.end()) {
		return false;
	}
	
	// Add the portal position
	instanceIt->second.portalPositions.push_back(position);
	
	return true;
}