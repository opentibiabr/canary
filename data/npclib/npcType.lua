-- add bank buttons to the npc
function NpcType:addBankButtons()
	self:addButton(KEYWORDBUTTONICON_DEPOSITALL)
	self:addButton(KEYWORDBUTTONICON_WITHDRAW)
	self:addButton(KEYWORDBUTTONICON_BALANCE)
end
