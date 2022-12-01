local config = {
	[8009] = {
		storage = Storage.ChildrenoftheRevolution.SpyBuilding01,
	text = "An impressive ammount of fish is stored here."},
	[8010] = {
		storage = Storage.ChildrenoftheRevolution.SpyBuilding02,
	text = "A seemingly endless array of weapon stretches before you into the darkness."},
	[8011] = {
		storage = Storage.ChildrenoftheRevolution.SpyBuilding03,
	text = "These barracks seem to be home for quite a lot of soldiers."}
}

local spy = MoveEvent()

function spy.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return true
	end

	local targetTile = config[item.actionid]
	if not targetTile then
		return true
	end

	if player:getStorageValue(targetTile.storage) < 1 then
		--Questlog, Children of the Revolution "Mission 2: Imperial Zzecret Weaponzz"
		player:setStorageValue(Storage.ChildrenoftheRevolution.Mission02, player:getStorageValue(Storage.ChildrenoftheRevolution.Mission02) + 1)
		player:setStorageValue(targetTile.storage, 1)
		player:say(targetTile.text, TALKTYPE_MONSTER_SAY)
	end
	return true
end

spy:type("stepin")

for index, value in pairs(config) do
	spy:aid(index)
end

spy:register()
