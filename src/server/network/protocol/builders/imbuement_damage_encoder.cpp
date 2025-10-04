#include "server/network/protocol/builders/imbuement_damage_encoder.hpp"

#include "config/configmanager.hpp"
#include "creatures/creatures_definitions.hpp"
#include "creatures/players/imbuements/imbuements.hpp"
#include "creatures/players/player.hpp"
#include "items/item.hpp"
#include "lib/logging/log_with_spd_log.hpp"
#include "server/network/message/outputmessage.hpp"
#include "utils/tools.hpp"

void ImbuementDamageEncoder::writeDamage(NetworkMessage &msg, const std::shared_ptr<Player> &player) {
	if (!player) {
		msg.addDouble(0);
		msg.addByte(0);
		return;
	}

	bool imbueDmg = false;
	const auto &weapon = player->getWeapon();
	if (weapon) {
		uint8_t slots = Item::items[weapon->getID()].imbuementSlot;
		if (slots > 0) {
			for (uint8_t i = 0; i < slots; i++) {
				ImbuementInfo imbuementInfo;
				if (!weapon->getImbuementInfo(i, &imbuementInfo)) {
					continue;
				}

				if (imbuementInfo.duration == 0) {
					continue;
				}

				auto imbuement = *imbuementInfo.imbuement;
				bool hasValidCombat = imbuement.combatType != COMBAT_NONE && imbuement.combatType < COMBAT_COUNT;
				if (hasValidCombat) {
					msg.addDouble(imbuement.elementDamage / 100.);
					msg.addByte(getCipbiaElement(imbuement.combatType));
					imbueDmg = true;
					break;
				}
			}
		}
	}

	if (!imbueDmg) {
		msg.addDouble(0);
		msg.addByte(0);
	}
}

void ImbuementDamageEncoder::writeAbsorbValues(const std::shared_ptr<Player> &player, NetworkMessage &msg, uint8_t &combats, bool fromPlayerSkills) {
	if (!player) {
		return;
	}

	alignas(16) uint16_t damageModifiers[COMBAT_COUNT] = { 10000, 10000, 10000, 10000, 10000, 10000, 10000, 10000, 10000,
		                                                   10000, 10000, 10000, 10000, 10000 };

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
		if (imbuementSlots == 0) {
			continue;
		}

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

	for (size_t i = 0; i < COMBAT_COUNT; ++i) {
		damageModifiers[i] -= 100 * player->getAbsorbPercent(indexToCombatType(i));
		if (g_configManager().getBoolean(TOGGLE_WHEELSYSTEM)) {
			damageModifiers[i] -= player->wheel().getResistance(indexToCombatType(i));
		}

		if (damageModifiers[i] == 10000) {
			continue;
		}

		double clientModifier = (10000 - static_cast<int16_t>(damageModifiers[i])) / 10000.;
		g_logger().debug("[{}] CombatType: {}, Damage Modifier: {}, Resulting Client Modifier: {}", __FUNCTION__, i, damageModifiers[i], clientModifier);
		if (!fromPlayerSkills) {
			msg.addByte(0x04);
		}
		msg.addByte(getCipbiaElement(indexToCombatType(i)));
		msg.addDouble(clientModifier);
		++combats;
	}
}
