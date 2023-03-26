/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2022 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.org/
 */

#ifndef SRC_UTILS_DATE_TIME_HPP
#define SRC_UTILS_DATE_TIME_HPP

class Date {
	public:
		/**
		 * @brief Gets the current date in year_month_day format
		 * @return std::chrono::year_month_day Current date
		 */
		static std::chrono::year_month_day getCurrentLocalTimeInYMD();
		static std::time_t getCurrentDay();
		static std::time_t getCurrentMonth();
		static std::time_t getCurrentYear();
		static std::string format(std::time_t time);
		static std::string formatShort(std::time_t time);
};

class Time {
	public:
		/**
		 * @brief Gets the current date in hh_mm_ss format
		 * @return std::chrono::hh_mm_ss<std::chrono::milliseconds> Current date
		 */
		static std::chrono::hh_mm_ss<std::chrono::milliseconds> getCurrentLocalTimeInHMS();
		static std::time_t getCurrentTime();
		static std::time_t getTimeMsNow();
		static std::time_t getCurrentHour();
		static std::time_t getCurrentMinute();
		static std::time_t getCurrentSecond();
		static std::time_t getTimeDifferenceInSeconds(time_t hour, time_t minute, time_t seconds);
};

#endif //  SRC_UTILS_DATE_TIME_HPP
