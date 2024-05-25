local promotionScrolls = {
	{ oldScroll = "wheel.scroll.abridged", newScroll = "abridged" },
	{ oldScroll = "wheel.scroll.basic", newScroll = "basic" },
	{ oldScroll = "wheel.scroll.revised", newScroll = "revised" },
	{ oldScroll = "wheel.scroll.extended", newScroll = "extended" },
	{ oldScroll = "wheel.scroll.advanced", newScroll = "advanced" },
}

local function migrate(player)
	for _, scrollTable in ipairs(promotionScrolls) do
		local oldStorage = player:getStorageValueByName(scrollTable.oldScroll)
		if oldStorage > 0 then
			player:kv():scoped("wheel-of-destiny"):scoped("scrolls"):set(scrollTable.newScroll, true)
		end
	end
end

local migration = Migration("20241715984279_move_wheel_scrolls_from_storagename_to_kv")

function migration:onExecute()
	self:forEachPlayer(migrate)
end

migration:register()
