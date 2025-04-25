/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2024 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#pragma once

struct Aura {
	Aura(uint16_t initId, const std::string &name) :
		id(initId), name(name) { }
	uint16_t id;
	std::string name;
};

struct Shader {
	Shader(uint8_t initId, const std::string &name) :
		id(initId), name(name) { }
	uint8_t id;
	std::string name;
};

struct Effect {
	Effect(uint16_t initId, const std::string &name) :
		id(initId), name(name) { }
	uint16_t id;
	std::string name;
};

struct Wing {
	Wing(uint16_t initId, const std::string &name) :
		id(initId), name(name) { }
	uint16_t id;
	std::string name;
};

class AttachedEffects {
public:
	bool reload();
	bool loadFromXml();

	std::shared_ptr<Aura> getAuraByID(uint8_t id);
	std::shared_ptr<Effect> getEffectByID(uint8_t id);
	std::shared_ptr<Wing> getWingByID(uint8_t id);
	std::shared_ptr<Shader> getShaderByID(uint8_t id);

	std::shared_ptr<Aura> getAuraByName(const std::string &name);
	std::shared_ptr<Shader> getShaderByName(const std::string &name);
	std::shared_ptr<Effect> getEffectByName(const std::string &name);
	std::shared_ptr<Wing> getWingByName(const std::string &name);

	[[nodiscard]] const std::vector<std::shared_ptr<Aura>> &getAuras() const {
		return auras;
	}
	[[nodiscard]] const std::vector<std::shared_ptr<Shader>> &getShaders() const {
		return shaders;
	}
	[[nodiscard]] const std::vector<std::shared_ptr<Effect>> &getEffects() const {
		return effects;
	}
	[[nodiscard]] const std::vector<std::shared_ptr<Wing>> &getWings() const {
		return wings;
	}

private:
	std::vector<std::shared_ptr<Aura>> auras;
	std::vector<std::shared_ptr<Shader>> shaders;
	std::vector<std::shared_ptr<Effect>> effects;
	std::vector<std::shared_ptr<Wing>> wings;
};
