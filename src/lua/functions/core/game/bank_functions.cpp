/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019–present OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#include "lua/functions/core/game/bank_functions.hpp"

#include "creatures/players/player.hpp"
#include "game/bank/bank.hpp"
#include "game/game.hpp"
#include "lua/functions/lua_functions_loader.hpp"

void BankFunctions::init(lua_State* L) {
	sol::state_view lua(L);
	auto bankTable = lua.create_named_table("Bank");

	bankTable.set_function("credit", [](sol::object playerOrGuild, uint64_t amount) {
		const auto &bank = getBank(playerOrGuild);
		if (!bank) {
			Lua::reportErrorFunc("Bank is nullptr");
			return false;
		}
		return bank->credit(amount);
	});

	bankTable.set_function("debit", [](sol::object playerOrGuild, uint64_t amount) {
		const auto &bank = getBank(playerOrGuild);
		if (!bank) {
			Lua::reportErrorFunc("Bank is nullptr");
			return false;
		}
		return bank->debit(amount);
	});

	bankTable.set_function("balance", [](sol::object playerOrGuild, sol::optional<uint64_t> amount) {
		const auto &bank = getBank(playerOrGuild);
		if (!bank) {
			Lua::reportErrorFunc("Bank is nullptr");
			return sol::make_object(playerOrGuild.lua_state(), false);
		}
		if (!amount) {
			return sol::make_object(playerOrGuild.lua_state(), bank->balance());
		}
		return sol::make_object(playerOrGuild.lua_state(), bank->balance(amount.value()));
	});

	bankTable.set_function("hasBalance", [](sol::object playerOrGuild, uint64_t amount) {
		const auto &bank = getBank(playerOrGuild);
		if (!bank) {
			Lua::reportErrorFunc("Bank is nullptr");
			return false;
		}
		return bank->hasBalance(amount);
	});

	bankTable.set_function("transfer", [](sol::object fromPlayerOrGuild, sol::object toPlayerOrGuild, uint64_t amount) {
		const auto &source = getBank(fromPlayerOrGuild);
		if (!source) {
			g_logger().debug("BankFunctions::transfer: source is null");
			Lua::reportErrorFunc("Bank is nullptr");
			return false;
		}
		const auto &destination = getBank(toPlayerOrGuild);
		if (!destination) {
			g_logger().debug("BankFunctions::transfer: destination is null");
			Lua::reportErrorFunc("Bank is nullptr");
			return false;
		}
		return source->transferTo(destination, amount);
	});

	bankTable.set_function("transferToGuild", [](sol::object fromPlayerOrGuild, sol::object toGuild, uint64_t amount) {
		const auto &source = getBank(fromPlayerOrGuild);
		if (!source) {
			Lua::reportErrorFunc("Source is nullptr");
			return false;
		}
		const auto &destination = getBank(toGuild, true);
		if (!destination) {
			Lua::reportErrorFunc("Destination is nullptr");
			return false;
		}
		return source->transferTo(destination, amount);
	});

	bankTable.set_function("withdraw", [](std::shared_ptr<Player> player, uint64_t amount, sol::optional<sol::object> sourceObj) {
		if (!player) {
			Lua::reportErrorFunc("Player not found");
			return false;
		}

		if (!sourceObj) {
			auto bank = std::make_shared<Bank>(player);
			return bank->withdraw(player, amount);
		}

		const auto &source = getBank(sourceObj.value());
		if (!source) {
			Lua::reportErrorFunc("Source is nullptr");
			return false;
		}
		return source->withdraw(player, amount);
	});

	bankTable.set_function("deposit", [](std::shared_ptr<Player> player, sol::object amountOrNil, sol::optional<sol::object> destinationObj) {
		if (!player) {
			Lua::reportErrorFunc("Player not found");
			return false;
		}

		uint64_t amount = 0;
		if (amountOrNil.is<uint64_t>()) {
			amount = amountOrNil.as<uint64_t>();
		} else {
			amount = player->getMoney();
		}

		if (!destinationObj) {
			auto bank = std::make_shared<Bank>(player);
			return g_game().removeMoney(player, amount) && bank->credit(amount);
		}

		const auto &destination = getBank(destinationObj.value());
		if (!destination) {
			Lua::reportErrorFunc("Destination is nullptr");
			return false;
		}
		return g_game().removeMoney(player, amount) && destination->credit(amount);
	});
}

std::shared_ptr<Bank> BankFunctions::getBank(sol::object arg, bool isGuild /*= false*/) {
	if (arg.is<std::shared_ptr<Guild>>()) {
		return std::make_shared<Bank>(arg.as<std::shared_ptr<Guild>>());
	}

	if (isGuild) {
		// Try to get guild by ID or name if passed as number/string
		if (arg.is<uint64_t>()) {
			auto guild = g_game().getGuild(arg.as<uint64_t>(), true);
			if (guild) {
				return std::make_shared<Bank>(guild);
			}
		} else if (arg.is<std::string>()) {
			auto guild = g_game().getGuildByName(arg.as<std::string>(), true);
			if (guild) {
				return std::make_shared<Bank>(guild);
			}
		}
		return nullptr;
	}

	if (arg.is<std::shared_ptr<Player>>()) {
		return std::make_shared<Bank>(arg.as<std::shared_ptr<Player>>());
	}

	// Try to get player by ID or name if passed as number/string
	if (arg.is<uint64_t>()) {
		auto player = g_game().getPlayerByID(arg.as<uint64_t>(), true);
		if (player) {
			return std::make_shared<Bank>(player);
		}
	} else if (arg.is<std::string>()) {
		auto player = g_game().getPlayerByName(arg.as<std::string>(), true);
		if (player) {
			return std::make_shared<Bank>(player);
		}
	}

	return nullptr;
}
