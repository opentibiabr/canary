#pragma once

namespace WheelDamagePolicy {
	[[nodiscard]] constexpr bool shouldApplyWheelEffects(bool reflection) {
		return !reflection;
	}
}
