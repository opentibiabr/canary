local minotaurs = {
	"minotaur",
	"depowered minotaur",
	"execowtioner",
	"glooth powered minotaur",
	"minotaur archer",
	"minotaur bruiser",
	"minotaur guard",
	"minotaur hunter",
	"minotaur mage",
	"minotaur poacher",
	"mooh'tah warrior",
	"moohtant",
	"worm priestess",
	"minotaur amazon"
}

local killingInTheNameOfMinotaurKill = CreatureEvent("KillingInTheNameOfMinotaurKill")
function killingInTheNameOfMinotaurKill.onKill(player, target)
	if target:isPlayer() or target:getMaster() then
		return true
	end

	if not isInArray(minotaurs, target:getName():lower()) then
		return true
	end

	local killAmount = player:getStorageValue(Storage.KillingInTheNameOf.BudrikMinosCount)
	if player:getStorageValue(Storage.KillingInTheNameOf.BudrikMinos) == 1 and killAmount < 5000 then
		player:setStorageValue(Storage.KillingInTheNameOf.BudrikMinosCount, killAmount + 1)
	end
	return true
end

killingInTheNameOfMinotaurKill:register()
