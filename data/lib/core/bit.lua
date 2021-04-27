-- objeto a ser criado
local BIT ={}

-- criando a metatable
function BIT:new(number)
	return setmetatable({number = number}, { __index = self })
end

-- Simplificando a criacao da metatable
function NewBit(number)
	return BIT:new(number)
end

-- checa se a flag tem o valor
function hasBitSet( flag,  flags)
	return bit.band(flags, flag) ~= 0;
end

-- setando uma nova flag
function setFlag(bt, flag)
	return bit.bor(bt, flag)
end

-- checa se tem a flag
function BIT:hasFlag(flag)
	return hasBitSet( flag,  self.number)
end

-- adiciona uma nova flag
function BIT:updateFlag(flag)
	self.number = setFlag(self.number, flag)
end

-- atualiza o numero/flag por fora da metatable
function BIT:updateNumber(number)
	self.number = number
end

-- retorna o numero/flag
function BIT:getNumber()
	return self.number
end
