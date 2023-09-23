/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2022 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#include "pch.hpp"

#include "items/cylinder.hpp"

std::shared_ptr<VirtualCylinder> VirtualCylinder::virtualCylinder = std::make_shared<VirtualCylinder>();

int32_t Cylinder::getThingIndex(std::shared_ptr<Thing>) const {
	return -1;
}

size_t Cylinder::getFirstIndex() const {
	return 0;
}

size_t Cylinder::getLastIndex() const {
	return 0;
}

uint32_t Cylinder::getItemTypeCount(uint16_t, int32_t) const {
	return 0;
}

std::map<uint32_t, uint32_t> &Cylinder::getAllItemTypeCount(std::map<uint32_t, uint32_t> &countMap) const {
	return countMap;
}

std::shared_ptr<Thing> Cylinder::getThing(size_t) const {
	return nullptr;
}

void Cylinder::internalAddThing(std::shared_ptr<Thing>) {
	//
}

void Cylinder::internalAddThing(uint32_t, std::shared_ptr<Thing>) {
	//
}

void Cylinder::startDecaying() {
	//
}
