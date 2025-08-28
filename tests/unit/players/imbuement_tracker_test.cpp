#include "pch.hpp"

#include <boost/ut.hpp>
#include <thread>

#include "creatures/players/player.hpp"
#include "utils/tools.hpp"

struct PlayerImbuementTrackerStatsTestAccess {
	static void setWindow(Player &p, bool open) {
		p.imbuementTrackerWindowOpen = open;
	}
	static uint64_t &lastUpdate(Player &p) {
		return p.m_lastImbuementTrackerUpdate;
	}
};

using namespace boost::ut;

suite<"imbuement_tracker_stats"> imbuementTrackerStatsTest = [] {
	test("should coalesce updates within one second") = [] {
		Player p(nullptr);
		PlayerImbuementTrackerStatsTestAccess::setWindow(p, true);

		p.updateImbuementTrackerStats();
		auto first = PlayerImbuementTrackerStatsTestAccess::lastUpdate(p);

		p.updateImbuementTrackerStats();
		expect(eq(PlayerImbuementTrackerStatsTestAccess::lastUpdate(p), first));

		PlayerImbuementTrackerStatsTestAccess::lastUpdate(p) = OTSYS_TIME() - 1000;
		p.updateImbuementTrackerStats();
		expect(PlayerImbuementTrackerStatsTestAccess::lastUpdate(p) > first);
	};

	test("force should bypass one second guard") = [] {
		Player p(nullptr);
		PlayerImbuementTrackerStatsTestAccess::setWindow(p, true);

		p.updateImbuementTrackerStats();
		auto first = PlayerImbuementTrackerStatsTestAccess::lastUpdate(p);

		std::this_thread::sleep_for(std::chrono::milliseconds(1));
		p.updateImbuementTrackerStats(true);
		expect(PlayerImbuementTrackerStatsTestAccess::lastUpdate(p) > first);
	};
};
