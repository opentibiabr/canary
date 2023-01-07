/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2022 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.org/
*/

#include "pch.hpp"

#include "utils/date_time.hpp"

/*
===========
 Date Class
===========
*/
std::chrono::year_month_day Date::getCurrentLocalTimeInYMD()
{
	// Get local time
	auto local_time = std::chrono::zoned_time{std::chrono::current_zone(), std::chrono::system_clock::now()}.get_local_time();
	// Calculate the number of days since the start of the season (1970-01-01)
	auto days_since_epoch = std::chrono::floor<std::chrono::days>(local_time);
	// Create a year_month_day date from the number of days since the start of the epoch
	std::chrono::year_month_day ymd{days_since_epoch};
	return ymd;
}

std::time_t Date::getCurrentDay() {
	auto ymd = getCurrentLocalTimeInYMD();
	return static_cast<unsigned int>(ymd.day());
}

std::time_t Date::getCurrentMonth() {
	auto ymd = getCurrentLocalTimeInYMD();
	return static_cast<unsigned int>(ymd.month());
}

std::time_t Date::getCurrentYear() {
	auto ymd = getCurrentLocalTimeInYMD();
	return static_cast<int>(ymd.year());
}

std::string Date::format(std::time_t time)
{
	return fmt::format("{:%d/%m/%Y %H:%M:%S}", fmt::localtime(time));
}

std::string Date::formatShort(std::time_t time)
{
	return fmt::format("{:%Y-%m-%d %X}", fmt::localtime(time));
}

/*
===========
 Time Class
===========
*/
std::time_t Time::getCurrentTime() {
	return std::chrono::system_clock::to_time_t(std::chrono::system_clock::now());
}

std::chrono::hh_mm_ss<std::chrono::milliseconds> Time::getCurrentLocalTimeInHMS()
{
	// Get local time
	auto local_time = std::chrono::zoned_time{std::chrono::current_zone(), std::chrono::system_clock::now()}.get_local_time();
	// Calculate the number of days since the start of the season (1970-01-01)
	auto days_since_epoch = std::chrono::floor<std::chrono::days>(local_time);
	// Create a year_month_day date from the number of days since the start of the epoch
	std::chrono::hh_mm_ss time{std::chrono::floor<std::chrono::milliseconds>(local_time-days_since_epoch)};
	return time;
}

std::time_t Time::getCurrentHour() {
	return getCurrentLocalTimeInHMS().hours().count();
}

std::time_t Time::getCurrentMinute() {
	return getCurrentLocalTimeInHMS().minutes().count();
}

std::time_t Time::getCurrentSecond() {
	return getCurrentLocalTimeInHMS().seconds().count();
}

std::time_t Time::getTimeDifferenceInSeconds(time_t hour, time_t minute, time_t seconds)
{
	if (hour < 0 || minute < 0 || seconds < 0 || minute >= 60 || seconds >= 60) {
		// Throw an exception in case of invalid parameters
		SPDLOG_ERROR("[{}] some time parameter is invalid");
		throw std::invalid_argument("Some time parameter is invalid");
	}

	auto currentTime = getCurrentTime();
	std::tm *time = std::gmtime(&currentTime);
	time->tm_hour = hour;
	time->tm_min = minute;
	time->tm_sec = seconds;

	return static_cast<time_t>(std::difftime(std::mktime(time), currentTime));
}
