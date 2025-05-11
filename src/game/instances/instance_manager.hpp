/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2024 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#pragma once

#include <unordered_map>
#include <string>
#include <memory>
#include <vector>
#include <ctime>

#include "creatures/players/player.hpp"
#include "game/movement/position.hpp"

class Map;

/**
 * Structure to hold instance data
 */
struct InstanceData {
	uint32_t instanceId;
	uint32_t ownerId;  // ID of the player or party leader who created the instance
	bool isPartyInstance;  // Whether this is a party instance
	uint32_t partyId;  // ID of the party if this is a party instance
	std::string mapName;
	time_t creationTime;
	Position entryPosition;
	Position exitPosition;
	bool active;
	std::vector<uint32_t> playerIds;  // IDs of all players in this instance
	uint8_t remainingPortals = 6;  // Number of portals remaining (Path of Exile style)
	std::vector<Position> portalPositions;  // Positions of the portals
};

/**
 * Class to manage player instances
 * Inspired by Path of Exile's instance system
 */
class InstanceManager {
public:
	InstanceManager() = default;
	~InstanceManager() = default;

	// Singleton implementation
	static InstanceManager &getInstance() {
		static InstanceManager instance;
		return instance;
	}
	
	/**
	 * Initializes the instance manager
	 */
	void init() {
		g_logger().info("Instance Manager initialized");
	}

	/**
	 * Creates a new instance for a player
	 * @param player The player to create the instance for
	 * @param mapName The name of the map template to use
	 * @param entryPosition The position where the player will be teleported to in the instance
	 * @param exitPosition The position where the player will return to after leaving the instance
	 * @param isPartyInstance Whether this is a party instance
	 * @return The instance ID if successful, 0 otherwise
	 */
	uint32_t createInstance(const std::shared_ptr<Player> &player, const std::string &mapName, const Position &entryPosition, const Position &exitPosition, bool isPartyInstance = false);

	/**
	 * Teleports a player to their instance
	 * @param player The player to teleport
	 * @param instanceId The ID of the instance to teleport to
	 * @return True if successful, false otherwise
	 */
	bool teleportToInstance(const std::shared_ptr<Player> &player, uint32_t instanceId);
	
	/**
	 * Teleports a player to a party member's instance
	 * @param player The player to teleport
	 * @param partyMember The party member whose instance to teleport to
	 * @return True if successful, false otherwise
	 */
	bool teleportToPartyMemberInstance(const std::shared_ptr<Player> &player, const std::shared_ptr<Player> &partyMember);

	/**
	 * Teleports a player out of their instance back to the main world
	 * @param player The player to teleport
	 * @return True if successful, false otherwise
	 */
	bool teleportFromInstance(const std::shared_ptr<Player> &player);

	/**
	 * Checks if a player is in an instance
	 * @param player The player to check
	 * @return True if the player is in an instance, false otherwise
	 */
	bool isPlayerInInstance(const std::shared_ptr<Player> &player);

	/**
	 * Gets the instance ID for a player
	 * @param player The player to get the instance ID for
	 * @return The instance ID if the player is in an instance, 0 otherwise
	 */
	uint32_t getPlayerInstanceId(const std::shared_ptr<Player> &player);

	/**
	 * Removes an instance
	 * @param instanceId The ID of the instance to remove
	 * @return True if successful, false otherwise
	 */
	bool removeInstance(uint32_t instanceId);

	/**
	 * Cleans up expired instances
	 * @param maxAge The maximum age of an instance in seconds
	 */
	void cleanupInstances(uint32_t maxAge = 3600);

	/**
	 * Gets the instance ID for a party
	 * @param partyId The ID of the party
	 * @return The instance ID if the party has an instance, 0 otherwise
	 */
	uint32_t getPartyInstanceId(uint32_t partyId);
	
	/**
	 * Adds a player to an instance
	 * @param player The player to add
	 * @param instanceId The ID of the instance
	 * @return True if successful, false otherwise
	 */
	bool addPlayerToInstance(const std::shared_ptr<Player> &player, uint32_t instanceId);
	
	/**
	 * Removes a player from an instance
	 * @param playerId The ID of the player to remove
	 * @return True if successful, false otherwise
	 */
	bool removePlayerFromInstance(uint32_t playerId);
	
	/**
	 * Consumes a portal from an instance
	 * @param instanceId The ID of the instance
	 * @return True if successful, false otherwise
	 */
	bool consumePortal(uint32_t instanceId);
	
	/**
	 * Gets the number of remaining portals for an instance
	 * @param instanceId The ID of the instance
	 * @return The number of remaining portals, 0 if the instance doesn't exist
	 */
	uint8_t getRemainingPortals(uint32_t instanceId);
	
	/**
	 * Adds a portal position to an instance
	 * @param instanceId The ID of the instance
	 * @param position The position of the portal
	 * @return True if successful, false otherwise
	 */
	bool addPortalPosition(uint32_t instanceId, const Position &position);

private:
	std::unordered_map<uint32_t, InstanceData> instances;
	std::unordered_map<uint32_t, uint32_t> playerInstances; // Maps player ID to instance ID
	std::unordered_map<uint32_t, uint32_t> partyInstances; // Maps party ID to instance ID
	uint32_t nextInstanceId = 1;
};

// Global accessor function
inline InstanceManager &g_instances() {
	return InstanceManager::getInstance();
}