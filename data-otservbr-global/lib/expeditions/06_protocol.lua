ExpeditionProtocol = ExpeditionProtocol or {}

function ExpeditionProtocol.send(player, payload)
	if not player then
		return false
	end
	return player:sendExtendedOpcode(ExpeditionConfig.OPCODE, ExpeditionJson.encode(payload))
end

function ExpeditionProtocol.sendCatalog(player)
	return ExpeditionProtocol.send(player, {
		type = "catalog",
		catalog = ExpeditionConfig.catalogForClient(),
	})
end

function ExpeditionProtocol.sendStatus(player, session)
	if not session then
		return false
	end
	local elapsed = 0
	if session.startedAt then
		elapsed = math.max(0, os.time() - session.startedAt)
	end
	return ExpeditionProtocol.send(player, {
		type = "status",
		status = {
			expeditionId = session.catalog and session.catalog.id or "",
			wave = session.wave or 0,
			alive = session.alive or 0,
			kills = session.kills or 0,
			state = session.state or "idle",
			elapsedSec = elapsed,
		},
	})
end

function ExpeditionProtocol.sendEnded(player)
	return ExpeditionProtocol.send(player, { type = "ended" })
end

function ExpeditionProtocol.sendError(player, message)
	return ExpeditionProtocol.send(player, { type = "error", message = message })
end

--- Sync AI attack target to the client (vanilla has no S→C set-attack opcode).
function ExpeditionProtocol.sendAttackTarget(player, creatureId)
	local id = 0
	if creatureId and creatureId > 0 then
		id = creatureId
	end
	return ExpeditionProtocol.send(player, {
		type = "attackTarget",
		creatureId = id,
	})
end

function ExpeditionProtocol.handle(player, buffer)
	local msg = ExpeditionJson.decode(buffer)
	if not msg or type(msg) ~= "table" then
		return
	end
	local action = msg.action
	if action == "list" then
		ExpeditionProtocol.sendCatalog(player)
		local session = ExpeditionManager.getSessionByPlayer(player)
		if session then
			ExpeditionProtocol.sendStatus(player, session)
		end
	elseif action == "join" then
		ExpeditionManager.join(player, msg.id)
	elseif action == "leave" then
		ExpeditionManager.leave(player)
	end
end
