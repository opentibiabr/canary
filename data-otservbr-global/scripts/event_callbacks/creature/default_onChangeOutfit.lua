local ec = EventCallback

function ec.onChangeOutfit(creature, outfit)
	if creature:isPlayer() then
		local familiarLookType = creature:getFamiliarLooktype()
		if familiarLookType ~= 0 then
			for _, summon in pairs(creature:getSummons()) do
				if summon:getType():familiar() then
						if summon:getOutfit().lookType ~= familiarLookType then
							summon:setOutfit({lookType = familiarLookType})
						end
					break
				end
			end
		end
	end
	return true
end

ec:register(--[[0]])
