-- Create functions revscriptsys
function createFunctions(class)
	local exclude = {[2] = {"is"}, [3] = {"get", "set", "add", "can"}, [4] = {"need"}}
	local temp = {}
	for name, func in pairs(class) do
		local add = true
		for strLen, strTable in pairs(exclude) do
			if table.contains(strTable, name:sub(1, strLen)) then
				add = false
			end
		end
		if add then
			local str = name:sub(1, 1):upper() .. name:sub(2)
			local getFunc = function(self) return func(self) end
			local setFunc = function(self, ...) return func(self, ...) end
			local get = "get" .. str
			local set = "set" .. str
			if not (rawget(class, get) and rawget(class, set)) then
				table.insert(temp, {set, setFunc, get, getFunc})
			end
		end
	end
	for _, func in ipairs(temp) do
		rawset(class, func[1], func[2])
		rawset(class, func[3], func[4])
	end
end

-- Creature index
do
	local function CreatureIndex(self, key)
		local methods = getmetatable(self)
		if key == "uid" then
			return methods.getId(self)
		elseif key == "type" then
			local creatureType = 0
			if methods.isPlayer(self) then
				creatureType = THING_TYPE_PLAYER
			elseif methods.isMonster(self) then
				creatureType = THING_TYPE_MONSTER
			elseif methods.isNpc(self) then
				creatureType = THING_TYPE_NPC
			end
			return creatureType
		elseif key == "itemid" then
			return 1
		elseif key == "actionid" then
			return 0
		end
		return methods[key]
	end
	rawgetmetatable("Player").__index = CreatureIndex
	rawgetmetatable("Monster").__index = CreatureIndex
	rawgetmetatable("Npc").__index = CreatureIndex
end

-- Item index
do
	local function ItemIndex(self, key)
		local methods = getmetatable(self)
		if key == "itemid" then
			return methods.getId(self)
		elseif key == "actionid" then
			return methods.getActionId(self)
		elseif key == "uid" then
			return methods.getUniqueId(self)
		elseif key == "type" then
			return methods.getSubType(self)
		end
		return methods[key]
	end
	rawgetmetatable("Item").__index = ItemIndex
	rawgetmetatable("Container").__index = ItemIndex
	rawgetmetatable("Teleport").__index = ItemIndex
end

-- Action revscriptsys
do
	local function ActionNewIndex(self, key, value)
		if key == "onUse" then
			self:onUse(value)
			return
		end
		rawset(self, key, value)
	end
	rawgetmetatable("Action").__newindex = ActionNewIndex
end

-- TalkAction revscriptsys
do
	local function TalkActionNewIndex(self, key, value)
		if key == "onSay" then
			self:onSay(value)
			return
		end
		rawset(self, key, value)
	end
	rawgetmetatable("TalkAction").__newindex = TalkActionNewIndex
end

-- CreatureEvent revscriptsys
do
	local function CreatureEventNewIndex(self, key, value)
		if key == "onLogin" then
			self:type("login")
			self:onLogin(value)
			return
		elseif key == "onLogout" then
			self:type("logout")
			self:onLogout(value)
			return
		elseif key == "onThink" then
			self:type("think")
			self:onThink(value)
			return
		elseif key == "onPrepareDeath" then
			self:type("preparedeath")
			self:onPrepareDeath(value)
			return
		elseif key == "onDeath" then
			self:type("death")
			self:onDeath(value)
			return
		elseif key == "onKill" then
			self:type("kill")
			self:onKill(value)
			return
		elseif key == "onAdvance" then
			self:type("advance")
			self:onAdvance(value)
			return
		elseif key == "onModalWindow" then
			self:type("modalwindow")
			self:onModalWindow(value)
			return
		elseif key == "onTextEdit" then
			self:type("textedit")
			self:onTextEdit(value)
			return
		elseif key == "onHealthChange" then
			self:type("healthchange")
			self:onHealthChange(value)
			return
		elseif key == "onManaChange" then
			self:type("manachange")
			self:onManaChange(value)
			return
		elseif key == "onExtendedOpcode" then
			self:type("extendedopcode")
			self:onExtendedOpcode(value)
			return
		end
		rawset(self, key, value)
	end
	rawgetmetatable("CreatureEvent").__newindex = CreatureEventNewIndex
end

-- MoveEvent revscriptsys
do
	local function MoveEventNewIndex(self, key, value)
		if key == "onEquip" then
			self:type("equip")
			self:onEquip(value)
			return
		elseif key == "onDeEquip" then
			self:type("deequip")
			self:onDeEquip(value)
			return
		elseif key == "onAddItem" then
			self:type("additem")
			self:onAddItem(value)
			return
		elseif key == "onRemoveItem" then
			self:type("removeitem")
			self:onRemoveItem(value)
			return
		elseif key == "onStepIn" then
			self:type("stepin")
			self:onStepIn(value)
			return
		elseif key == "onStepOut" then
			self:type("stepout")
			self:onStepOut(value)
			return
		end
		rawset(self, key, value)
	end
	rawgetmetatable("MoveEvent").__newindex = MoveEventNewIndex
end

-- GlobalEvent revscriptsys
do
	local function GlobalEventNewIndex(self, key, value)
		if key == "onThink" then
			self:onThink(value)
			return
		elseif key == "onTime" then
			self:onTime(value)
			return
		elseif key == "onStartup" then
			self:type("startup")
			self:onStartup(value)
			return
		elseif key == "onShutdown" then
			self:type("shutdown")
			self:onShutdown(value)
			return
		elseif key == "onRecord" then
			self:type("record")
			self:onRecord(value)
			return
		elseif key == "onPeriodChange" then
			self:type("periodchange")
			self:onPeriodChange(value)
			return
		end
		rawset(self, key, value)
	end
	rawgetmetatable("GlobalEvent").__newindex = GlobalEventNewIndex
end

-- Weapons revscriptsys
do
	local function WeaponNewIndex(self, key, value)
		if key == "onUseWeapon" then
			self:onUseWeapon(value)
			return
		end
		rawset(self, key, value)
	end
	rawgetmetatable("Weapon").__newindex = WeaponNewIndex
end

-- Spells revscriptsys
do
	local function SpellNewIndex(self, key, value)
		if key == "onCastSpell" then
			self:onCastSpell(value)
			return
		end
		rawset(self, key, value)
	end
	rawgetmetatable("Spell").__newindex = SpellNewIndex
end

-- Monsters revscriptsys
do
	local function MonsterTypeNewIndex(self, key, value)
		if key == "onThink" then
			self:eventType(MONSTERS_EVENT_THINK)
			self:onThink(value)
			return
		elseif key == "onAppear" then
			self:eventType(MONSTERS_EVENT_APPEAR)
			self:onAppear(value)
			return
		elseif key == "onDisappear" then
			self:eventType(MONSTERS_EVENT_DISAPPEAR)
			self:onDisappear(value)
			return
		elseif key == "onMove" then
			self:eventType(MONSTERS_EVENT_MOVE)
			self:onMove(value)
			return
		elseif key == "onSay" then
			self:eventType(MONSTERS_EVENT_SAY)
			self:onSay(value)
			return
		end
		rawset(self, key, value)
	end
	rawgetmetatable("MonsterType").__newindex = MonsterTypeNewIndex
end

-- Npcs revscriptsys
do
	local function NpcTypeNewIndex(self, key, value)
		if key == "onThink" then
			self:eventType(NPCS_EVENT_THINK)
			self:onThink(value)
			return
		elseif key == "onAppear" then
			self:eventType(NPCS_EVENT_APPEAR)
			self:onAppear(value)
			return
		elseif key == "onDisappear" then
			self:eventType(NPCS_EVENT_DISAPPEAR)
			self:onDisappear(value)
			return
		elseif key == "onMove" then
			self:eventType(NPCS_EVENT_MOVE)
			self:onMove(value)
			return
		elseif key == "onSay" then
			self:eventType(NPCS_EVENT_SAY)
			self:onSay(value)
			return
		elseif key == "onBuyItem" then
			self:eventType(NPCS_EVENT_PLAYER_BUY)
			self:onBuyItem(value)
			return
		elseif key == "onSellItem" then
			self:eventType(NPCS_EVENT_PLAYER_SELL)
			self:onSellItem(value)
			return
		elseif key == "onCheckItem" then
			self:eventType(NPCS_EVENT_PLAYER_CHECK_ITEM)
			self:onCheckItem(value)
			return
		elseif key == "onCloseChannel" then
			self:eventType(NPCS_EVENT_PLAYER_CLOSE_CHANNEL)
			self:onBuyItem(value)
			return
		end
		rawset(self, key, value)
	end
	rawgetmetatable("NpcType").__newindex = NpcTypeNewIndex
end
