/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019–present OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#include "creatures/appearance/mounts/mounts.hpp"

#include "config/configmanager.hpp"
#include "game/game.hpp"
#include "utils/pugicast.hpp"
#include "utils/tools.hpp"

bool Mounts::reload() {
	// Each OwningMount's destructor retires its Block to the QSBR list.
	// Borrowed views handed out earlier in the tick remain dereferenceable
	// until the next quiescentState(), which the dispatcher invokes at
	// end-of-tick.
	mounts.clear();
	return loadFromXml();
}

bool Mounts::loadFromXml() {
	pugi::xml_document doc;
	auto folder = g_configManager().getString(CORE_DIRECTORY) + "/XML/mounts.xml";
	pugi::xml_parse_result result = doc.load_file(folder.c_str());
	if (!result) {
		printXMLError(__FUNCTION__, folder, result);
		return false;
	}

	for (auto mountNode : doc.child("mounts").children()) {
		auto lookType = pugi::cast<uint16_t>(mountNode.attribute("clientid").value());
		if (g_configManager().getBoolean(WARN_UNSAFE_SCRIPTS) && lookType != 0 && !g_game().isLookTypeRegistered(lookType)) {
			g_logger().warn("{} - An unregistered creature mount with id '{}' was blocked to prevent client crash.", __FUNCTION__, lookType);
			continue;
		}

		// OwningMount::make allocates a single Block { refcount, next, Mount }
		// and constructs Mount in-place. The Block address is recoverable
		// from any Mount* via offsetof, so later boundary materialisations
		// (Borrowed → Shared, Owning → Shared) only pay one atomic refcount
		// op — never a heap allocation.
		mounts.emplace(OwningMount::make(
			static_cast<uint8_t>(pugi::cast<uint16_t>(mountNode.attribute("id").value())),
			lookType,
			mountNode.attribute("name").as_string(),
			pugi::cast<int32_t>(mountNode.attribute("speed").value()),
			mountNode.attribute("premium").as_bool(),
			mountNode.attribute("type").as_string()
		));
	}
	return true;
}

// Getters return a BorrowedMount: a `Mount*` in a trench coat. Zero atomic
// ops, free to copy. Lifetime is bound by storage's QSBR-deferred drop —
// any borrow taken inside a tick stays valid until end-of-tick.

Mounts::BorrowedMount Mounts::getMountByID(uint8_t id) const {
	auto it = std::find_if(mounts.begin(), mounts.end(), [id](const OwningMount &owner) {
		return owner->id == id;
	});

	return it != mounts.end() ? it->borrow() : BorrowedMount {};
}

Mounts::BorrowedMount Mounts::getMountByName(const std::string &name) const {
	auto mountName = name.c_str();
	auto it = std::find_if(mounts.begin(), mounts.end(), [mountName](const OwningMount &owner) {
		return strcasecmp(mountName, owner->name.c_str()) == 0;
	});

	return it != mounts.end() ? it->borrow() : BorrowedMount {};
}

Mounts::BorrowedMount Mounts::getMountByClientID(uint16_t clientId) const {
	auto it = std::find_if(mounts.begin(), mounts.end(), [clientId](const OwningMount &owner) {
		return owner->clientId == clientId;
	});

	return it != mounts.end() ? it->borrow() : BorrowedMount {};
}
