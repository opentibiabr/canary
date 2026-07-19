ExpeditionConfig = ExpeditionConfig or {}

ExpeditionConfig.OPCODE = 113

-- Runtime storage (not DB storages.xml) for expedition flags.
ExpeditionConfig.STORAGE_ACTIVE = 910001
ExpeditionConfig.STORAGE_EXPEDITION_ID = 910002
ExpeditionConfig.STORAGE_RETURN_X = 910003
ExpeditionConfig.STORAGE_RETURN_Y = 910004
ExpeditionConfig.STORAGE_RETURN_Z = 910005
ExpeditionConfig.STORAGE_SLOT = 910006

-- Private instance grid far from the live world. Template tiles are extracted from
-- world center (32367, 32165, 7) as a 32×32 chunk; each player gets their own slot.
ExpeditionConfig.INSTANCE_BASE_X = 60000
ExpeditionConfig.INSTANCE_BASE_Y = 60000
ExpeditionConfig.INSTANCE_Z = 7
-- Keep slots well beyond client viewport so concurrent players never see each other.
ExpeditionConfig.SLOT_SIZE = 64
ExpeditionConfig.MAX_SLOTS = 32
ExpeditionConfig.BORDER_ITEM_ID = 2256 -- mountain wall
ExpeditionConfig.AI_TICK_MS = 1000
ExpeditionConfig.WAVE_RESPAWN_MS = 8000
ExpeditionConfig.FALLBACK_GROUND_ID = 4526 -- grass

-- Source template used by map:expedition:chunks (documentation / regen helper).
ExpeditionConfig.TEMPLATE_CENTER = { x = 32367, y = 32165, z = 7 }
ExpeditionConfig.TEMPLATE_SIZE = 32

ExpeditionConfig.Catalog = {
	{
		id = "rotworm_fields",
		name = "Rotworm Fields",
		description = "A private 32×32 rotworm hunting instance.",
		levelMin = 1,
		region = "rotworm_fields",
		creatures = { "Rotworm", "Carrion Worm" },
		waveMin = 1,
		waveMax = 8,
		spawnIntervalMs = 8000,
	},
}

function ExpeditionConfig.getById(id)
	for _, entry in ipairs(ExpeditionConfig.Catalog) do
		if entry.id == id then
			return entry
		end
	end
	return nil
end

function ExpeditionConfig.catalogForClient()
	local out = {}
	for _, entry in ipairs(ExpeditionConfig.Catalog) do
		out[#out + 1] = {
			id = entry.id,
			name = entry.name,
			description = entry.description,
			levelMin = entry.levelMin,
			creatures = entry.creatures,
		}
	end
	return out
end

function ExpeditionConfig.chunkDir(region)
	return DATA_DIRECTORY .. "/world/expeditions/" .. region
end

function ExpeditionConfig.loadManifest(region)
	local path = ExpeditionConfig.chunkDir(region) .. "/manifest.json"
	local file = io.open(path, "r")
	if not file then
		return nil
	end
	local content = file:read("*a")
	file:close()
	return ExpeditionJson.decode(content)
end
