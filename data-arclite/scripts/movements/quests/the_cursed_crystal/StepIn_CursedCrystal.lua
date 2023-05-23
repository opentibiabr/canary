local teleports = {
	[TCC_MEDUSACRYSTAL_ENTRY_MAP] = {position = TCC_MEDUSACRYSTAL_ENTRY}, -- medusa entry
	[TCC_MEDUSACRYSTAL_EXIT_MAP] = {position = TCC_MEDUSACRYSTAL_EXIT}, -- medusa exit
	[TCC_VORTEX_POSITION] = {position = TCC_VORTEX_TELEPORTED}, -- Vortex
	[TCC_MEDUSAMSG_ONEMAP] = {}, -- medusa crystal message
	[TCC_MEDUSAMSG_TWOMAP] = {}, -- medusa crystal message
	[TCC_AFTERVORTEX_EXIT_ONE_MAP] = {position = TCC_AFTERVORTEX_EXIT_ONE}, -- Vortex exit 1
	[TCC_AFTERVORTEX_EXIT_TWO_MAP] = {position = TCC_AFTERVORTEX_EXIT_TWO} -- Vortex  exit 2
}

local StepInCursedCrystal = MoveEvent()

function StepInCursedCrystal.onStepIn(creature, item, position, fromPosition)
local player = creature:getPlayer()
	if not player then
		return false
	end	
	for index, value in pairs(teleports) do
		if item:getPosition() == index then
			if item:getPosition() == TCC_MEDUSACRYSTAL_ENTRY_MAP then
				if (player:getStorageValue(Storage.TibiaTales.TheCursedCrystal.Oneeyedjoe) > 0) then
					doSendMagicEffect(player:getPosition(), CONST_ME_TELEPORT)
					player:teleportTo(value.position)
					doSendMagicEffect(value.position, CONST_ME_TELEPORT)
				else
					nopermission(player, fromPosition)
				end
				return
			elseif item:getPosition() == TCC_MEDUSAMSG_ONEMAP or item:getPosition() == TCC_MEDUSAMSG_TWOMAP then
				if(player:getStorageValue(Storage.TibiaTales.TheCursedCrystal.MedusaOil) < os.time())then
					if (player:getStorageValue(Storage.TibiaTales.TheCursedCrystal.Questline) == 0)then
						player:setStorageValue(Storage.TibiaTales.TheCursedCrystal.Questline, 1)
					end
					player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "This small room could once have been a shrine of some kind. You discover an old inscription between two ornate stone walls.")
					player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "The text is partly crumbled: 'Take ... vial of emb... fl... and mix ... a medusa's bl.... Then .. the dust of ... crystal, so ... will get the Medusa's Ointm... powerful ... able to unpetrify ...")
					return
				end
			else
				doSendMagicEffect(player:getPosition(), CONST_ME_TELEPORT)
				player:teleportTo(value.position)
				doSendMagicEffect(value.position, CONST_ME_TELEPORT)
				return			
			end
		end
	end
end
function nopermission(teleporter, fromthisposition)
	teleporter:teleportTo(fromthisposition, false)
	doSendMagicEffect(fromthisposition, CONST_ME_TELEPORT)
	teleporter:say("You need permision to access this area.", TALKTYPE_MONSTER_SAY)
end

StepInCursedCrystal:type("stepin")
StepInCursedCrystal:aid(25018, 35001)
StepInCursedCrystal:register()
