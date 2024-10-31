local combat = Combat()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_EARTHDAMAGE)
combat:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_SMALLPLANTS)

combat:setArea(createCombatArea({
	{ 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0 },
	{ 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0 },
	{ 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0 },
	{ 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0 },
	{ 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0 },
	{ 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0 },
	{ 1, 1, 1, 1, 1, 1, 3, 1, 1, 1, 1, 1, 1 },
	{ 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0 },
	{ 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0 },
	{ 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0 },
	{ 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0 },
	{ 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0 },
	{ 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0 },
}))

function spellCallbackPlaguerootTeleport(param) end

function onTargetTilePlaguerootTeleport(cid, pos)
	local param = {}

	param.cid = cid
	param.pos = pos
	param.count = 0
	spellCallbackPlaguerootTeleport(param)
end

setCombatCallback(combat, CALLBACK_PARAM_TARGETTILE, "onTargetTilePlaguerootTeleport")

local function teleportMonster(creature, centerPos, fromPos, toPos)
	local position = { x = math.random(fromPos.x, toPos.x), y = math.random(fromPos.y, toPos.y), z = centerPos.z }
	local tile = Tile(Position(position))
	local count = 1

	while not tile or tile:getItemByType(ITEM_TYPE_TELEPORT) or not tile:getGround() or tile:hasFlag(TILESTATE_BLOCKPATH) or tile:hasFlag(TILESTATE_PROTECTIONZONE) or tile:hasFlag(TILESTATE_BLOCKSOLID) or count < 5 do
		position = Position(math.random(fromPos.x, toPos.x), math.random(fromPos.y, toPos.y), centerPos.z)
		tile = Tile(position)
		count = count + 1
	end

	if tile then
		if position:isInRange(Position(32199, 32039, 14), Position(32216, 32057, 14)) then
			creature:getPosition():sendMagicEffect(CONST_ME_POFF)
			creature:teleportTo(position)
			Position(position):sendMagicEffect(CONST_ME_TELEPORT)
		end
	end
end

local spell = Spell("instant")

function spell.onCastSpell(creature, var)
	if not creature:isMonster() then
		return false
	end

	local centerPos = creature:getPosition()
	local fromPos = { x = centerPos.x - 7, y = centerPos.y - 5, z = centerPos.z }
	local toPos = { x = centerPos.x + 7, y = centerPos.y + 5, z = centerPos.z }

	creature:say("PLAGUEROOT TUNNELS TO ANOTHER PLACE!", TALKTYPE_MONSTER_SAY)
	teleportMonster(creature, centerPos, fromPos, toPos)

	var = { type = 2, pos = { x = creature:getPosition().x, y = creature:getPosition().y, z = creature:getPosition().z } }

	combat:execute(creature, var)

	addEvent(function()
		if creature then
			var = { type = 2, pos = { x = creature:getPosition().x, y = creature:getPosition().y, z = creature:getPosition().z } }
			combat:execute(creature, var)
		end
	end, 2 * 1000)

	return true
end

spell:name("plagueroot teleport")
spell:words("###558")
spell:isAggressive(false)
spell:blockWalls(true)
spell:needTarget(false)
spell:needLearn(true)
spell:register()
