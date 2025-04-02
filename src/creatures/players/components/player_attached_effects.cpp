/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2024 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

// Player.hpp already includes the attached effects
#include "creatures/players/player.hpp"

#include "game/game.hpp"
#include "creatures/appearance/attached_effects/attached_effects.hpp"
#include "kv/kv.hpp"
#include "server/network/protocol/protocolgame.hpp"

PlayerAttachedEffects::PlayerAttachedEffects(Player &player) :
	m_player(player) {
	defaultOutfit = player.getDefaultOutfit();
}

/**
 * Wings
 */
uint8_t PlayerAttachedEffects::getLastWing() const {
	const int32_t value = m_player.getStorageValue(PSTRG_WING_CURRENTWING);
	if (value > 0) {
		return value;
	}
	const auto lastWing = m_player.kv()->get("last-wing");
	if (!lastWing.has_value()) {
		return 0;
	}

	return static_cast<uint8_t>(lastWing->get<int>());
}

uint8_t PlayerAttachedEffects::getCurrentWing() const {
	const int32_t value = m_player.getStorageValue(PSTRG_WING_CURRENTWING);
	if (value > 0) {
		return value;
	}
	return 0;
}

void PlayerAttachedEffects::setCurrentWing(uint8_t wing) {
	m_player.addStorageValue(PSTRG_WING_CURRENTWING, wing);
}

bool PlayerAttachedEffects::isWinged() const {
	return defaultOutfit.lookWing != 0;
}

bool PlayerAttachedEffects::hasAnyWing() const {
	const auto &wings = g_game().getAttachedEffects()->getWings();
	return std::ranges::any_of(wings, [&](const auto &wing) {
		return hasWing(wing);
	});
}

uint8_t PlayerAttachedEffects::getRandomWingId() const {
	std::vector<uint8_t> availableWings;
	const auto &wings = g_game().getAttachedEffects()->getWings();
	for (const auto &wing : wings) {
		if (hasWing(wing)) {
			availableWings.emplace_back(wing->id);
		}
	}

	if (availableWings.empty()) {
		return 0;
	}

	const auto randomIndex = uniform_random(0, static_cast<int32_t>(availableWings.size() - 1));
	if (randomIndex >= 0 && static_cast<size_t>(randomIndex) < availableWings.size()) {
		return availableWings[randomIndex];
	}

	return 0;
}

bool PlayerAttachedEffects::toggleWing(bool wing) {
	if ((OTSYS_TIME() - lastToggleWing) < 3000 && !wasWinged) {
		m_player.sendCancelMessage(RETURNVALUE_YOUAREEXHAUSTED);
		return false;
	}

	const auto &thisPlayer = m_player.getPlayer();
	if (wing) {
		if (isWinged()) {
			return false;
		}

		const auto &playerOutfit = Outfits::getInstance().getOutfitByLookType(thisPlayer, defaultOutfit.lookType);
		if (!playerOutfit) {
			return false;
		}

		uint8_t currentWingId = getLastWing();
		if (currentWingId == 0) {
			m_player.sendOutfitWindow();
			return false;
		}

		if (m_player.isRandomMounted()) {
			currentWingId = getRandomWingId();
		}

		const auto &currentWing = g_game().getAttachedEffects()->getWingByID(currentWingId);
		if (!currentWing) {
			return false;
		}

		if (!hasWing(currentWing)) {
			setCurrentWing(0);
			m_player.kv()->set("last-wing", 0);
			m_player.sendOutfitWindow();
			return false;
		}

		if (m_player.hasCondition(CONDITION_OUTFIT)) {
			m_player.sendCancelMessage(RETURNVALUE_NOTPOSSIBLE);
			return false;
		}

		defaultOutfit.lookWing = currentWing->id;
		m_player.setDefaultOutfit(defaultOutfit);
		setCurrentWing(currentWing->id);
		m_player.kv()->set("last-wing", currentWing->id);

	} else {
		if (!isWinged()) {
			return false;
		}

		diswing();
	}

	g_game().internalCreatureChangeOutfit(thisPlayer, defaultOutfit);
	lastToggleWing = OTSYS_TIME();
	return true;
}

bool PlayerAttachedEffects::tameWing(uint8_t wingId) {
	const auto &wingPtr = g_game().getAttachedEffects()->getWingByID(wingId);
	if (!wingPtr) {
		return false;
	}

	const uint8_t tmpWingId = wingId - 1;
	const uint32_t key = PSTRG_WING_RANGE_START + (tmpWingId / 31);

	int32_t value = m_player.getStorageValue(key);
	if (value != -1) {
		value |= (1 << (tmpWingId % 31));
	} else {
		value = (1 << (tmpWingId % 31));
	}

	m_player.addStorageValue(key, value);
	return true;
}

bool PlayerAttachedEffects::untameWing(uint8_t wingId) {
	const auto &wingPtr = g_game().getAttachedEffects()->getWingByID(wingId);
	if (!wingPtr) {
		return false;
	}

	const auto &thisPlayer = m_player.getPlayer();

	const uint8_t tmpWingId = wingId - 1;
	const uint32_t key = PSTRG_WING_RANGE_START + (tmpWingId / 31);

	int32_t value = m_player.getStorageValue(key);
	if (value == -1) {
		return true;
	}

	value &= ~(1 << (tmpWingId % 31));
	m_player.addStorageValue(key, value);

	if (getCurrentWing() == wingId) {
		if (isWinged()) {
			diswing();
			g_game().internalCreatureChangeOutfit(thisPlayer, defaultOutfit);
		}

		setCurrentWing(0);
		m_player.kv()->set("last-wing", 0);
	}

	return true;
}

bool PlayerAttachedEffects::hasWing(const std::shared_ptr<Wing> &wing) const {
	if (m_player.isAccessPlayer()) {
		return true;
	}

	const uint8_t tmpWingId = wing->id - 1;

	const int32_t value = m_player.getStorageValue(PSTRG_WING_RANGE_START + (tmpWingId / 31));
	if (value == -1) {
		return false;
	}

	return ((1 << (tmpWingId % 31)) & value) != 0;
}

void PlayerAttachedEffects::diswing() {
	defaultOutfit.lookWing = 0;
	m_player.setDefaultOutfit(defaultOutfit);
}

// Auras

uint8_t PlayerAttachedEffects::getLastAura() const {
	const int32_t value = m_player.getStorageValue(PSTRG_AURA_CURRENTAURA);
	if (value > 0) {
		return value;
	}
	const auto lastAura = m_player.kv()->get("last-aura");
	if (!lastAura.has_value()) {
		return 0;
	}

	return static_cast<uint8_t>(lastAura->get<int>());
}

uint8_t PlayerAttachedEffects::getCurrentAura() const {
	const int32_t value = m_player.getStorageValue(PSTRG_AURA_CURRENTAURA);
	if (value > 0) {
		return value;
	}
	return 0;
}

void PlayerAttachedEffects::setCurrentAura(uint8_t aura) {
	m_player.addStorageValue(PSTRG_AURA_CURRENTAURA, aura);
}

bool PlayerAttachedEffects::hasAnyAura() const {
	const auto &auras = g_game().getAttachedEffects()->getAuras();
	return std::ranges::any_of(auras, [&](const auto &aura) {
		return hasAura(aura);
	});
}

uint8_t PlayerAttachedEffects::getRandomAuraId() const {
	std::vector<uint8_t> playerAuras;
	const auto &auras = g_game().getAttachedEffects()->getAuras();
	for (const auto &aura : auras) {
		if (hasAura(aura)) {
			playerAuras.emplace_back(aura->id);
		}
	}

	if (playerAuras.empty()) {
		return 0;
	}

	const auto randomIndex = uniform_random(0, static_cast<int32_t>(playerAuras.size() - 1));
	if (randomIndex >= 0 && static_cast<size_t>(randomIndex) < playerAuras.size()) {
		return playerAuras[randomIndex];
	}

	return 0;
}

bool PlayerAttachedEffects::toggleAura(bool aura) {
	if ((OTSYS_TIME() - lastToggleAura) < 3000 && !wasAuraed) {
		m_player.sendCancelMessage(RETURNVALUE_YOUAREEXHAUSTED);
		return false;
	}

	const auto &thisPlayer = m_player.getPlayer();
	if (aura) {
		if (isAuraed()) {
			return false;
		}

		const auto &playerOutfit = Outfits::getInstance().getOutfitByLookType(thisPlayer, defaultOutfit.lookType);
		if (!playerOutfit) {
			return false;
		}

		uint8_t currentAuraId = getLastAura();
		if (currentAuraId == 0) {
			m_player.sendOutfitWindow();
			return false;
		}

		if (m_player.isRandomMounted()) {
			currentAuraId = getRandomAuraId();
		}

		const auto &currentAura = g_game().getAttachedEffects()->getAuraByID(currentAuraId);
		if (!currentAura) {
			return false;
		}

		if (!hasAura(currentAura)) {
			setCurrentAura(0);
			m_player.kv()->set("last-aura", 0);
			m_player.sendOutfitWindow();
			return false;
		}

		if (m_player.hasCondition(CONDITION_OUTFIT)) {
			m_player.sendCancelMessage(RETURNVALUE_NOTPOSSIBLE);
			return false;
		}

		defaultOutfit.lookAura = currentAura->id;
		m_player.setDefaultOutfit(defaultOutfit);
		setCurrentAura(currentAura->id);
		m_player.kv()->set("last-aura", currentAura->id);

	} else {
		if (!isAuraed()) {
			return false;
		}

		disaura();
	}

	g_game().internalCreatureChangeOutfit(thisPlayer, defaultOutfit);
	lastToggleAura = OTSYS_TIME();
	return true;
}

bool PlayerAttachedEffects::tameAura(uint8_t auraId) {
	const auto &auraPtr = g_game().getAttachedEffects()->getAuraByID(auraId);
	if (!auraPtr) {
		return false;
	}

	const uint8_t tmpAuraId = auraId - 1;
	const uint32_t key = PSTRG_AURA_RANGE_START + (tmpAuraId / 31);

	int32_t value = m_player.getStorageValue(key);
	if (value != -1) {
		value |= (1 << (tmpAuraId % 31));
	} else {
		value = (1 << (tmpAuraId % 31));
	}

	m_player.addStorageValue(key, value);
	return true;
}

bool PlayerAttachedEffects::untameAura(uint8_t auraId) {
	const auto &auraPtr = g_game().getAttachedEffects()->getAuraByID(auraId);
	if (!auraPtr) {
		return false;
	}

	const uint8_t tmpAuraId = auraId - 1;
	const uint32_t key = PSTRG_AURA_RANGE_START + (tmpAuraId / 31);

	int32_t value = m_player.getStorageValue(key);
	if (value == -1) {
		return true;
	}

	const auto &thisPlayer = m_player.getPlayer();
	value &= ~(1 << (tmpAuraId % 31));
	m_player.addStorageValue(key, value);

	if (getCurrentAura() == auraId) {
		if (isAuraed()) {
			disaura();
			g_game().internalCreatureChangeOutfit(thisPlayer, defaultOutfit);
		}

		setCurrentAura(0);
		m_player.kv()->set("last-aura", 0);
	}

	return true;
}

bool PlayerAttachedEffects::hasAura(const std::shared_ptr<Aura> &aura) const {
	if (m_player.isAccessPlayer()) {
		return true;
	}
	const uint8_t tmpAuraId = aura->id - 1;

	const int32_t value = m_player.getStorageValue(PSTRG_AURA_RANGE_START + (tmpAuraId / 31));
	if (value == -1) {
		return false;
	}

	return ((1 << (tmpAuraId % 31)) & value) != 0;
}

void PlayerAttachedEffects::disaura() {
	defaultOutfit.lookAura = 0;
	m_player.setDefaultOutfit(defaultOutfit);
}

// Effects

uint8_t PlayerAttachedEffects::getLastEffect() const {
	const int32_t value = m_player.getStorageValue(PSTRG_EFFECT_CURRENTEFFECT);
	if (value > 0) {
		return value;
	}

	const auto lastEffect = m_player.kv()->get("last-effect");
	if (!lastEffect.has_value()) {
		return 0;
	}

	return static_cast<uint8_t>(lastEffect->get<int>());
}

uint8_t PlayerAttachedEffects::getCurrentEffect() const {
	const int32_t value = m_player.getStorageValue(PSTRG_EFFECT_CURRENTEFFECT);
	if (value > 0) {
		return value;
	}
	return 0;
}

void PlayerAttachedEffects::setCurrentEffect(uint8_t effect) {
	m_player.addStorageValue(PSTRG_EFFECT_CURRENTEFFECT, effect);
}

bool PlayerAttachedEffects::hasAnyEffect() const {
	const auto &effects = g_game().getAttachedEffects()->getEffects();
	return std::ranges::any_of(effects, [&](const auto &effect) {
		return hasEffect(effect);
	});
}

uint8_t PlayerAttachedEffects::getRandomEffectId() const {
	std::vector<uint8_t> playerEffects;
	const auto &effects = g_game().getAttachedEffects()->getEffects();
	for (const auto &effect : effects) {
		if (hasEffect(effect)) {
			playerEffects.emplace_back(effect->id);
		}
	}

	if (playerEffects.empty()) {
		return 0;
	}

	const auto randomIndex = uniform_random(0, static_cast<int32_t>(playerEffects.size() - 1));
	if (randomIndex >= 0 && static_cast<size_t>(randomIndex) < playerEffects.size()) {
		return playerEffects[randomIndex];
	}

	return 0;
}

bool PlayerAttachedEffects::toggleEffect(bool effect) {
	if ((OTSYS_TIME() - lastToggleEffect) < 3000 && !wasEffected) {
		m_player.sendCancelMessage(RETURNVALUE_YOUAREEXHAUSTED);
		return false;
	}

	const auto &thisPlayer = m_player.getPlayer();
	if (effect) {
		if (isEffected()) {
			return false;
		}

		const auto &playerOutfit = Outfits::getInstance().getOutfitByLookType(thisPlayer, defaultOutfit.lookType);
		if (!playerOutfit) {
			return false;
		}

		uint8_t currentEffectId = getLastEffect();
		if (currentEffectId == 0) {
			m_player.sendOutfitWindow();
			return false;
		}

		if (m_player.isRandomMounted()) {
			currentEffectId = getRandomEffectId();
		}

		const auto &currentEffect = g_game().getAttachedEffects()->getEffectByID(currentEffectId);
		if (!currentEffect) {
			return false;
		}

		if (!hasEffect(currentEffect)) {
			setCurrentEffect(0);
			m_player.kv()->set("last-effect", 0);
			m_player.sendOutfitWindow();
			return false;
		}

		if (m_player.hasCondition(CONDITION_OUTFIT)) {
			m_player.sendCancelMessage(RETURNVALUE_NOTPOSSIBLE);
			return false;
		}

		defaultOutfit.lookEffect = currentEffect->id;
		m_player.setDefaultOutfit(defaultOutfit);
		setCurrentEffect(currentEffect->id);
		m_player.kv()->set("last-effect", currentEffect->id);

	} else {
		if (!isEffected()) {
			return false;
		}

		diseffect();
	}

	g_game().internalCreatureChangeOutfit(thisPlayer, defaultOutfit);
	lastToggleEffect = OTSYS_TIME();
	return true;
}

bool PlayerAttachedEffects::tameEffect(uint8_t effectId) {
	const auto &effectPtr = g_game().getAttachedEffects()->getEffectByID(effectId);
	if (!effectPtr) {
		return false;
	}

	const uint8_t tmpEffectId = effectId - 1;
	const uint32_t key = PSTRG_EFFECT_RANGE_START + (tmpEffectId / 31);

	int32_t value = m_player.getStorageValue(key);
	if (value != -1) {
		value |= (1 << (tmpEffectId % 31));
	} else {
		value = (1 << (tmpEffectId % 31));
	}

	m_player.addStorageValue(key, value);
	return true;
}

bool PlayerAttachedEffects::untameEffect(uint8_t effectId) {
	const auto &effectPtr = g_game().getAttachedEffects()->getEffectByID(effectId);
	if (!effectPtr) {
		return false;
	}

	const uint8_t tmpEffectId = effectId - 1;
	const uint32_t key = PSTRG_EFFECT_RANGE_START + (tmpEffectId / 31);

	int32_t value = m_player.getStorageValue(key);
	if (value == -1) {
		return true;
	}

	const auto &thisPlayer = m_player.getPlayer();
	value &= ~(1 << (tmpEffectId % 31));
	m_player.addStorageValue(key, value);

	if (getCurrentEffect() == effectId) {
		if (isEffected()) {
			diseffect();
			g_game().internalCreatureChangeOutfit(thisPlayer, defaultOutfit);
		}

		setCurrentEffect(0);
		m_player.kv()->set("last-effect", 0);
	}

	return true;
}

bool PlayerAttachedEffects::hasEffect(const std::shared_ptr<Effect> &effect) const {
	if (m_player.isAccessPlayer()) {
		return true;
	}

	const uint8_t tmpEffectId = effect->id - 1;

	const int32_t value = m_player.getStorageValue(PSTRG_EFFECT_RANGE_START + (tmpEffectId / 31));
	if (value == -1) {
		return false;
	}

	return ((1 << (tmpEffectId % 31)) & value) != 0;
}

void PlayerAttachedEffects::diseffect() {
	defaultOutfit.lookEffect = 0;
	m_player.setDefaultOutfit(defaultOutfit);
}

// Shaders
uint16_t PlayerAttachedEffects::getRandomShader() const {
	std::vector<uint16_t> shadersId;
	for (const auto &shader : g_game().getAttachedEffects()->getShaders()) {
		if (hasShader(shader.get())) {
			shadersId.push_back(shader->id);
		}
	}

	if (shadersId.empty()) {
		return 0;
	}

	return shadersId[uniform_random(0, shadersId.size() - 1)];
}

uint16_t PlayerAttachedEffects::getCurrentShader() const {
	return currentShader;
}

void PlayerAttachedEffects::setCurrentShader(uint16_t shaderId) {
	currentShader = shaderId;
}

bool PlayerAttachedEffects::toggleShader(bool shader) {
	if ((OTSYS_TIME() - lastToggleShader) < 3000 && !wasShadered) {
		m_player.sendCancelMessage(RETURNVALUE_YOUAREEXHAUSTED);
		return false;
	}

	const auto &thisPlayer = m_player.getPlayer();
	if (shader) {
		if (isShadered()) {
			return false;
		}

		const auto &playerOutfit = Outfits::getInstance().getOutfitByLookType(thisPlayer, defaultOutfit.lookType);
		if (!playerOutfit) {
			return false;
		}

		uint16_t currentShaderId = getCurrentShader();
		if (currentShaderId == 0) {
			m_player.sendOutfitWindow();
			return false;
		}

		auto currentShaderPtr = g_game().getAttachedEffects()->getShaderByID(currentShaderId);
		if (!currentShaderPtr) {
			return false;
		}

		Shader* currentShader = currentShaderPtr.get();

		if (!hasShader(currentShader)) {
			setCurrentShader(0);
			m_player.sendOutfitWindow();
			return false;
		}

		if (m_player.hasCondition(CONDITION_OUTFIT)) {
			m_player.sendCancelMessage(RETURNVALUE_NOTPOSSIBLE);
			return false;
		}

		defaultOutfit.lookShader = currentShader->id;
		m_player.setDefaultOutfit(defaultOutfit);

	} else {
		if (!isShadered()) {
			return false;
		}

		disshader();
	}

	g_game().internalCreatureChangeOutfit(thisPlayer, defaultOutfit);
	lastToggleShader = OTSYS_TIME();
	return true;
}

bool PlayerAttachedEffects::tameShader(uint16_t shaderId) {
	auto shaderPtr = g_game().getAttachedEffects()->getShaderByID(shaderId);
	if (!shaderPtr) {
		return false;
	}

	if (hasShader(shaderPtr.get())) {
		return false;
	}

	shaders.insert(shaderId);
	return true;
}

bool PlayerAttachedEffects::untameShader(uint16_t shaderId) {
	const auto &shaderPtr = g_game().getAttachedEffects()->getShaderByID(shaderId);
	if (!shaderPtr) {
		return false;
	}

	if (!hasShader(shaderPtr.get())) {
		return false;
	}

	shaders.erase(shaderId);

	const auto &thisPlayer = m_player.getPlayer();

	if (getCurrentShader() == shaderId) {
		if (isShadered()) {
			disshader();
			g_game().internalCreatureChangeOutfit(thisPlayer, defaultOutfit);
		}

		setCurrentShader(0);
	}

	return true;
}

bool PlayerAttachedEffects::hasShader(const Shader* shader) const {
	if (m_player.isAccessPlayer()) {
		return true;
	}

	return shaders.find(shader->id) != shaders.end();
}

bool PlayerAttachedEffects::hasShaders() const {
	for (const auto &shader : g_game().getAttachedEffects()->getShaders()) {
		if (hasShader(shader.get())) {
			return true;
		}
	}
	return false;
}

void PlayerAttachedEffects::disshader() {
	defaultOutfit.lookShader = 0;
	m_player.setDefaultOutfit(defaultOutfit);
}

std::string PlayerAttachedEffects::getCurrentShader_NAME() const {
	uint16_t currentShaderId = getCurrentShader();
	const auto &currentShader = g_game().getAttachedEffects()->getShaderByID(static_cast<uint8_t>(currentShaderId));

	if (currentShader != nullptr) {
		return currentShader->name;
	} else {
		return "Outfit - Default";
	}
}

bool PlayerAttachedEffects::addCustomOutfit(const std::string &type, const std::variant<uint16_t, std::string> &idOrName) {
	uint16_t elementId;
	if (std::holds_alternative<uint16_t>(idOrName)) {
		elementId = std::get<uint16_t>(idOrName);
	} else {
		const std::string &name = std::get<std::string>(idOrName);

		if (type == "wing") {
			const auto &element = g_game().getAttachedEffects()->getWingByName(name);
			if (!element) {
				return false;
			}
			elementId = element->id;
		} else if (type == "aura") {
			const auto &element = g_game().getAttachedEffects()->getAuraByName(name);
			if (!element) {
				return false;
			}
			elementId = element->id;
		} else if (type == "effect") {
			const auto &element = g_game().getAttachedEffects()->getEffectByName(name);
			if (!element) {
				return false;
			}
			elementId = element->id;
		} else if (type == "shader") {
			const auto &element = g_game().getAttachedEffects()->getShaderByName(name);
			if (!element) {
				return false;
			}
			elementId = element->id;
		} else {
			return false;
		}
	}

	if (type == "wing") {
		return tameWing(elementId);
	} else if (type == "aura") {
		return tameAura(elementId);
	} else if (type == "effect") {
		return tameEffect(elementId);
	} else if (type == "shader") {
		return tameShader(elementId);
	}
	return false;
}

bool PlayerAttachedEffects::removeCustomOutfit(const std::string &type, const std::variant<uint16_t, std::string> &idOrName) {
	uint16_t elementId;
	if (std::holds_alternative<uint16_t>(idOrName)) {
		elementId = std::get<uint16_t>(idOrName);
	} else {
		const std::string &name = std::get<std::string>(idOrName);

		if (type == "wings") {
			const auto &element = g_game().getAttachedEffects()->getWingByName(name);
			if (!element) {
				return false;
			}
			elementId = element->id;
		} else if (type == "aura") {
			const auto &element = g_game().getAttachedEffects()->getAuraByName(name);
			if (!element) {
				return false;
			}
			elementId = element->id;
		} else if (type == "effect") {
			const auto &element = g_game().getAttachedEffects()->getEffectByName(name);
			if (!element) {
				return false;
			}
			elementId = element->id;
		} else if (type == "shader") {
			const auto &element = g_game().getAttachedEffects()->getShaderByName(name);
			if (!element) {
				return false;
			}
			elementId = element->id;
		} else {
			return false;
		}
	}

	if (type == "wing") {
		return untameWing(elementId);
	} else if (type == "aura") {
		return untameAura(elementId);
	} else if (type == "effect") {
		return untameEffect(elementId);
	} else if (type == "shader") {
		return untameShader(elementId);
	}
	return false;
}

// OTCR Features
void PlayerAttachedEffects::sendAttachedEffect(const std::shared_ptr<Creature> &creature, uint16_t effectId) const {
	if (!m_player.client || !creature) {
		return;
	}

	m_player.client->sendAttachedEffect(creature, effectId);
}

void PlayerAttachedEffects::sendDetachEffect(const std::shared_ptr<Creature> &creature, uint16_t effectId) const {
	if (!m_player.client || !creature) {
		return;
	}

	m_player.client->sendDetachEffect(creature, effectId);
}

void PlayerAttachedEffects::sendShader(const std::shared_ptr<Creature> &creature, const std::string &shaderName) const {
	if (!m_player.client || !creature) {
		return;
	}

	m_player.client->sendShader(creature, shaderName);
}

void PlayerAttachedEffects::sendMapShader(const std::string &shaderName) const {
	if (!m_player.client) {
		return;
	}

	m_player.client->sendMapShader(shaderName);
}
