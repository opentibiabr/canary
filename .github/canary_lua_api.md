# API de Lua do Canary 14.x
Guia objetivo e enxuto para programar no datapack.

---

# 1. Estrutura básica dos scripts

## actions/
function onUse(player, item, fromPos, target, toPos, isHotkey)
    return true
end

## creaturescripts/
function onLogin(player)
    return true
end

## movements/
function onStepIn(creature, item, position, fromPosition)
    return true
end

## talkactions/
function onSay(player, words, param)
    return false, words
end

## spells/
function onCastSpell(creature, variant)
    return true
end

---

# 2. Principais TIPOS da API
- Player  
- Creature  
- Monster  
- Item  
- Position  
- Tile  
- Container  
- Npc  

---

# 3. Métodos essenciais — Player

## Info
player:getName()  
player:getLevel()  
player:getVocation()  
player:getPosition()  
player:getStorageValue(key)

## Status
player:addHealth(amount)  
player:addMana(amount)  
player:getHealth()  
player:getMaxHealth()

## Experiência / Skills
player:addExperience(amount)  
player:addSkillTries(skillId, tries)  
player:getMagicLevel()

## Itens
player:addItem(itemId, count)  
player:removeItem(itemId, count)  
player:getItemCount(itemId)

## Mensagens & Efeitos
player:sendTextMessage(MESSAGE_INFO_DESCR, "texto")  
player:sendCancelMessage("não pode")  
player:getPosition():sendMagicEffect(CONST_ME_FIREAREA)

---

# 4. Creature

creature:getId()  
creature:getHealth()  
creature:getPosition()  
creature:say("fala", TALKTYPE_MONSTER_SAY)  
creature:isPlayer()  
creature:isMonster()

---

# 5. Monster

monster:setTarget(player)  
monster:getType():getExperience()  
monster:getType():getLoot()  
monster:getType():isBoss()

---

# 6. Item

item:getId()  
item:transform(newId)  
item:remove(count)  
item:getCount()  
item:getActionId()  
item:setActionId(aid)  
item:setAttribute(ITEM_ATTRIBUTE_NAME, "Novo Nome")

---

# 7. Position

Position(x, y, z)  
pos:sendMagicEffect(CONST_ME_FIREATTACK)  
tile = Tile(pos)  
creature = tile:getTopCreature()

---

# 8. Tile

tile:getTopCreature()  
tile:getItems()  
tile:hasFlag(TILESTATE_PROTECTIONZONE)  
tile:getGround()

---

# 9. Container

container:addItem(id, count)  
container:getItem(index)  
container:getSize()

---

# 10. Npc

npc:say("fala", TALKTYPE_SAY)  
npc:getPosition()

---

# 11. GlobalEvents

onStartup()  
onShutdown()  
onThink(interval)

---

# 12. ConfigManager

configManager.getNumber(ConfigKeys.RATE_EXPERIENCE)

---

# 13. Dano, cura e efeitos

# Efeito
player:getPosition():sendMagicEffect(CONST_ME_ENERGYAREA)

# Dano
doTargetCombatHealth(player, target, COMBAT_FIREDAMAGE, -200, -400)

# Cura
doTargetCombatHealth(player, player, COMBAT_HEALING, 150, 250)

# Distância
Position(1,1,7):sendDistanceEffect(Position(2,1,7), CONST_ANI_FIRE)

---

# 14. Variant (spells)

local var = Variant(targetOrPosition)

---

# 15. Storage

player:setStorageValue(5001, 1)  
player:getStorageValue(5001)

---

# 16. Timers

addEvent(function()
    player:sendTextMessage(MESSAGE_INFO_DESCR, "3 segundos!")
end, 3000)

---

# 17. Funções utilitárias

broadcastMessage("Aviso!", MESSAGE_STATUS_WARNING)

Game.createItem(2160, 3, Position(100,100,7))  
Game.createMonster("Demon", Position(100,100,7), false, true)

---

# Resumo
Essa é a fatia da API que você usa 95% do tempo para criar:
- quests  
- sistemas  
- bosses  
- spells  
- eventos  
- utilidades  

Simples, direto e funcional.

