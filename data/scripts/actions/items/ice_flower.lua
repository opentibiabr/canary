local iceFlower = Action()

function iceFlower.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	item:transform(13843)

	local chance = math.random(1, 100)
	if chance <= 25 then
		player:addItem(13844, 1)
		if not player:hasAchievement("Ice Harvester") then
			player:addAchievementProgress("Ice Harvester", 10)
		end
	end

	return true
end

iceFlower:id(13842)
iceFlower:register()
