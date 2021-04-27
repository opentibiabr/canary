registerCharmType = {}
setmetatable(registerCharmType,
{
  __call =
  function(self, charm, mask)
    for _,parse in pairs(self) do
      parse(charm, mask)
    end
  end
})

Bestiaryregister = function(charm, mask)
  return registerCharmType(charm, mask)
end

registerCharmType.name = function(charm, mask)
  if mask.name then
    charm:Name(mask.name)
  end
end

registerCharmType.description = function(charm, mask)
  if mask.description then
    charm:Description(mask.description)
  end
end

registerCharmType.type = function(charm, mask)
  if mask.type then
    charm:Type(mask.type)
  end
end

registerCharmType.damageType = function(charm, mask)
  if mask.damageType then
    charm:DamageType(mask.damageType)
  end
end

registerCharmType.percent = function(charm, mask)
  if mask.percent then
    charm:Percentage(mask.percent)
  end
end

registerCharmType.chance = function(charm, mask)
  if mask.chance then
    charm:Chance(mask.chance)
  end
end

registerCharmType.messageCancel = function(charm, mask)
  if mask.messageCancel then
    charm:CancelMsg(mask.messageCancel)
  end
end

registerCharmType.messageServerLog = function(charm, mask)
  if mask.messageServerLog then
    charm:LogMsg(mask.messageServerLog)
  end
end

registerCharmType.effect = function(charm, mask)
  if mask.effect then
    charm:Effect(mask.effect)
  end
end

registerCharmType.points = function(charm, mask)
  if mask.points then
    charm:Points(mask.points)
  end
end