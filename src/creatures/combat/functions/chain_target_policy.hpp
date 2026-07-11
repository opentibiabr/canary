#pragma once

namespace ChainTargetPolicy {
	[[nodiscard]] constexpr bool shouldRejectDefaultTarget(bool isCaster, bool isNpc, bool aggressive, bool inProtectionZone) {
		return isCaster || isNpc || (aggressive && inProtectionZone);
	}
}
