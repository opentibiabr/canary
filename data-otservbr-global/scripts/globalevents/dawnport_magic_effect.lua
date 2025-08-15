local positions = {
	{ x = 32054, y = 31889, z = 5 },
	{ x = 32056, y = 31889, z = 5 },
	{ x = 32063, y = 31880, z = 5 },
	{ x = 32063, y = 31882, z = 5 },
	{ x = 32073, y = 31889, z = 5 },
	{ x = 32075, y = 31889, z = 5 },
	{ x = 32063, y = 31899, z = 5 },
	{ x = 32063, y = 31901, z = 5 },
}
local dawnportMagicEffect = GlobalEvent("DawnportMagicEffect")

function dawnportMagicEffect.onThink(interval)
	for i = 1, #positions do
		Position(positions[i]):sendMagicEffect(CONST_ME_THUNDER)
	end
	return true
end

dawnportMagicEffect:interval(5000)
dawnportMagicEffect:register()
