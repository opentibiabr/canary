/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2024 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#pragma once

class Creature;
class LuaScriptInterface;

struct Position;

class CreatureCallback {
public:
	CreatureCallback(LuaScriptInterface* scriptInterface, const std::shared_ptr<Creature> &targetCreature) :
		scriptInterface(scriptInterface), m_targetCreature(targetCreature) {};
	~CreatureCallback() = default;

	bool startScriptInterface(int32_t scriptId);

	void pushSpecificCreature(const std::shared_ptr<Creature> &creature);

	bool persistLuaState() const;

	void pushCreature(const std::shared_ptr<Creature> &creature);

	void pushPosition(const Position &position, int32_t stackpos = 0);

	void pushNumber(int32_t number);

	void pushString(const std::string &str);

	void pushBoolean(const bool str);

protected:
	static std::string getCreatureClass(const std::shared_ptr<Creature> &creature);

private:
	LuaScriptInterface* scriptInterface;
	std::weak_ptr<Creature> m_targetCreature;
	uint32_t params = 0;
	lua_State* L = nullptr;
};
