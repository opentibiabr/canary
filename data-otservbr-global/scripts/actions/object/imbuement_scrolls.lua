local imbuement = Action()

function imbuement.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if not item or not item:isItem() then
		return true
	end

	if not target or not target:isItem() then
		return true
	end

	player:applyImbuementScroll(target, item)
	
	return true
end

-- Register Powerful Scrolls
for scrollId = 51444, 51467 do
	imbuement:id(scrollId)
end

-- Register Intricate Scrolls
for scrollId = 51724, 51747 do
	imbuement:id(scrollId)
end

imbuement:register()
