local config = {
    name = "Strong Ethereal Spear",
    words = "exori gran con",
    level = 90,
    range = 7,
    cooldown = 8000,
    manaCost = 55,

    maxTargets = 3,
    specRange = 4,

}

local setmetatable = setmetatable
local contains = table.contains
local insert = table.insert
local sort = table.sort

---@class BounceSpell
---@field playerId integer
---@field targets integer[]
---@field currentTargetId integer
---@field lastTargetPos Position
local BounceSpell = {}

---@param player Player
---@param target Creature
---@return BounceSpell BounceSpell
local function getBounceSpell(player, target)
    local bounceSpell = setmetatable({}, {__index = BounceSpell})
    bounceSpell.playerId = player:getId()
    local targetId = target:getId()
    bounceSpell.targets = {targetId}
    bounceSpell.currentTargetId = targetId
    bounceSpell.lastTargetPos = player:getPosition()
    return bounceSpell
end

---@param target Creature|Player
---@return boolean
function BounceSpell:checkTarget(target)
    local player = Player(self.playerId)
    if not player then return false end
    local targetPlayer = target:getPlayer()
    return not targetPlayer or
               (not player:hasSecureMode() and not targetPlayer:getGroup():getAccess() and
                   not self:isFriend(targetPlayer))
end

do
    local getSpectators = Game.getSpectators
    local x, y = config.specRange, config.specRange

    ---@param pos Position
    ---@return Creature[]
    function BounceSpell:getSpectators(pos)
        local spectators = getSpectators(pos, false, false, x, x, y, y)
        local spects = {}
        for _, spectator in ipairs(spectators) do
            local spectatorId = spectator:getId()
            if spectatorId ~= self.playerId and
                not Tile(spectator:getPosition()):hasFlag(TILESTATE_PROTECTIONZONE) and
                not contains(self.targets, spectatorId) and self:checkTarget(spectator) then
                insert(spects, spectator)
            end
        end
        return spects
    end
end

---@param target Player
---@return boolean
function BounceSpell:isFriend(target)
    local player = Player(self.playerId)
    if not player then return false end
    local party = player:getParty()
    if not party then return false end

    local targetId = target:getId()
    if targetId == party:getLeader():getId() then return true end
    for _, member in ipairs(party:getMembers()) do
        if targetId == member:getId() then return true end
    end
    return false
end

---@param from Position
---@param to Position
---@return integer
local function getDistanceTo(from, to) return from:getDistance(to) end

---@param pos Position
---@return boolean
function BounceSpell:getTargets(pos)
    local spects = self:getSpectators(pos)
    if #spects > 1 then
        sort(spects, function(a, b)
            return getDistanceTo(pos, a:getPosition()) <
                       getDistanceTo(pos, b:getPosition())
        end)
    end

    local target = nil
    for _, spectator in ipairs(spects) do
        if pos:isSightClear(spectator:getPosition(), true) then
            target = spectator
            break
        end
    end

    if not target then return false end

    local targetId = target:getId()
    insert(self.targets, targetId)
    self.currentTargetId = targetId
    self.lastTargetPos = pos
    return true
end

local combats = {}

for divisor = 1, config.maxTargets do
    local combat = Combat()
	combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_PHYSICALDAMAGE)
	--combat:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_HITAREA)
	--combat:setParameter(COMBAT_PARAM_DISTANCEEFFECT, CONST_ANI_ETHEREALSPEAR)
	--combat:setParameter(COMBAT_PARAM_IMPACTSOUND, SOUND_EFFECT_TYPE_BURST_ARROW_EFFECT)
	--combat:setParameter(COMBAT_PARAM_CASTSOUND, SOUND_EFFECT_TYPE_MONSTER_MELEE_ATK_FIST)
	combat:setParameter(COMBAT_PARAM_BLOCKARMOR, 1)
	
	local multiplier = 5 / divisor
	function onGetFormulaValues(player, skill, attack, factor)
		skill = skill * multiplier
		local level = player:getLevel()

		local min = (level / 5) + (skill + 25) / 3
		local max = (level / 5) + skill + 25

		return -min, -max
	end

	combat:setCallback(CALLBACK_PARAM_SKILLVALUE, "onGetFormulaValues")

    combats[#combats + 1] = combat
end

---@return boolean
function BounceSpell:execute()
    local player = Player(self.playerId)
    if not player then return false end

    local target = Creature(self.currentTargetId)
    if not target then return false end

    local combat = combats[#self.targets] or combats[#combats]
    if not combat then error("Bounce Spell: Invalid combat.") end

    local targetPos = target:getPosition()
    self.lastTargetPos:sendDistanceEffect(targetPos, CONST_ANI_ETHEREALSPEAR)
    combat:execute(player, Variant(targetPos))

    if #self.targets >= config.maxTargets then return false end

    self.currentTargetId = nil
    if self:getTargets(target:getPosition()) then
        addEvent(self.execute, 300 + (#self.targets * 10), self)
    end
    return true
end

local spell = Spell(SPELL_INSTANT)

function spell.onCastSpell(player, variant, isHotkey)
    local target = player:getTarget()
    if not target then error("Bounce Spell: Invalid target.") end

    return getBounceSpell(player, target):execute()
end

spell:castSound(SOUND_EFFECT_TYPE_SPELL_OR_RUNE)
spell:impactSound(SOUND_EFFECT_TYPE_SPELL_STRONG_ETHEREAL_SPEAR)
spell:name(config.name)
spell:words(config.words)
spell:group("attack")
spell:vocation("paladin;true", "royal paladin;true")
spell:id(57)
spell:cooldown(config.cooldown)
spell:level(config.level)
spell:mana(config.manaCost)
spell:isPremium(true)
spell:blockWalls(true)
spell:isAggressive(true)
spell:isBlocking(true)
spell:needTarget(true)
spell:needLearn(false)
spell:range(config.range)
spell:register()


