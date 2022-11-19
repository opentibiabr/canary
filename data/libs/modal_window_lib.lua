if not modalWindows then
	modalWindows = {
		modalWindowConstructor = ModalWindow,
		nextFreeId = 500,

		windows = {}
	}
end

local MT = {}
MT.__index = MT

function ModalWindow(...)
	local args = {...}
	if type(args[1]) == 'table' then
		local self = setmetatable(args[1], MT)
		local id = modalWindows.nextFreeId
		self.id = id
		self.buttons = {}
		self.choices = {}
		self.players = {}
		self.created = false

		modalWindows.nextFreeId = id + 1
		table.insert(modalWindows.windows, self)
		return self
	end

	return modalWindows.modalWindowConstructor(...)
end

function MT:setDefaultCallback(callback)
	self.defaultCallback = callback
end

function MT:addButton(text, callback)
	local button = {text = tostring(text), callback = callback}
	table.insert(self.buttons, button)
	return button
end

function MT:addButtons(...)
	for _, text in ipairs({...}) do
		table.insert(self.buttons, {text = tostring(text)})
	end
end

function MT:addChoice(text)
	local choice = {text = tostring(text)}
	table.insert(self.choices, choice)
	return choice
end

function MT:addChoices(...)
	for _, text in ipairs({...}) do
		table.insert(self.choices, {text = tostring(text)})
	end
end

function MT:setDefaultEnterButton(text)
	self.defaultEnterButton = text
end

function MT:setDefaultEscapeButton(text)
	self.defaultEscapeButton = text
end

function MT:setTitle(title)
	self.title = tostring(title)
end

function MT:setMessage(message)
	self.message = tostring(message)
end

local buttonOrder = {
	[4] = {3, 4, 2, 1},
	[3] = {2, 3, 1},
	[2] = {1, 2},
	[1] = {1}
}
function MT:create()
	local modalWindow = modalWindows.modalWindowConstructor(self.id, self.title, self.message)
	local order = buttonOrder[math.min(#self.buttons, 4)]

	if order then
		for _, i in ipairs(order) do
			local button = self.buttons[i]
			modalWindow:addButton(i, button.text)
			button.id = i

			if button.text == self.defaultEnterButton then
				modalWindow:setDefaultEnterButton(i)
			elseif button.text == self.defaultEscapeButton then
				modalWindow:setDefaultEscapeButton(i)
			end
		end
	end

	for _, choice in ipairs(self.choices) do
		modalWindow:addChoice(_, choice.text)
		choice.id = _
	end

	self.modalWindow = modalWindow
end

function MT:sendToPlayer(player)
	if not self.modalWindow then
		self:create()
	end

	player:registerEvent('ModalWindowHelper')
	self.players[player:getId()] = true
	return self.modalWindow:sendToPlayer(player)
end
