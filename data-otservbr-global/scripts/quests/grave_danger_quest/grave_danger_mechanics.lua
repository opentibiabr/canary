local health = CreatureEvent("GraveDangerHealth")
health.onHealthChange = GraveDanger.health
health:register()

local think = CreatureEvent("GraveDangerThink")
think.onThink = GraveDanger.think
think:register()

local death = CreatureEvent("GraveDangerDeath")
death.onDeath = GraveDanger.death
death:register()
