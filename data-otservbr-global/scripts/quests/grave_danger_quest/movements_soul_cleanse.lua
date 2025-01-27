local soul_cleanse = MoveEvent()

function soul_cleanse.onStepIn(creature, item, position, fromPosition)
	if creature:isPlayer() then
		return true
	end

	if creature:getName():lower() == "azaram's soul" then
		local health = (creature:getHealth() / creature:getMaxHealth()) * 100

		if health == 100 then
			creature:say("The broken Soul absorbs the power of the soul splinter and gains strength!")
			creature:teleportTo(config.soulPos)
			item:remove()
			removeTainted()

			local boss = Creature("Lord Azaram")

			if boss then
				boss:teleportTo(config.centerRoom)
			end
		end
	end

	return true
end

soul_cleanse:id(31160)
soul_cleanse:register()
