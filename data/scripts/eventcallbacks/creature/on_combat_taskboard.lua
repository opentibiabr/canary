local callback = EventCallback("TaskboardCreatureOnCombat")

function callback.creatureOnCombat(caster, target, damage)
	local taskboard = rawget(_G, "Taskboard")
	if not taskboard or not taskboard.isEnabled() or not caster or not target or not damage then
		return
	end
	if type(caster.isPlayer) ~= "function" or not caster:isPlayer() then
		return
	end
	if type(target.isMonster) ~= "function" or not target:isMonster() then
		return
	end

	local damageBonus = taskboard.getDamageBonus(caster, target)
	if damageBonus > 0 then
		for _, entry in ipairs({ damage.primary, damage.secondary }) do
			if entry and tonumber(entry.value) and entry.value < 0 then
				entry.value = entry.value + math.ceil(entry.value * damageBonus / 100)
			end
		end
	end

	local lifeLeechBonus = taskboard.getLifeLeechBonus(caster, target)
	if lifeLeechBonus > 0 then
		damage.lifeLeech = (tonumber(damage.lifeLeech) or 0) + math.floor((lifeLeechBonus * 100) + 0.5)
	end
end

callback:register()
