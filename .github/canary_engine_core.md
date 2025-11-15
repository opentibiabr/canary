# Canary Engine Core — Visão Técnica do C++
Guia objetivo para entender rapidamente COMO a engine funciona e ONDE mexer caso necessário.

O objetivo deste documento é te dar uma visão clara do miolo do servidor, sem fluff, sem confusão.

---

# 🧠 Arquitetura geral do Canary
A engine roda em C++ e segue 3 pilares:

1. **Game Loop** (núcleo do servidor)
2. **Scheduler** (timers e eventos)
3. **Event Dispatch** (chamadas internas para Lua)

Quase tudo acontece dentro desses três blocos.

---

# 📁 Principais arquivos do core

### ✔ `game.cpp`
O cérebro do servidor.

Responsável por:
- controle de criaturas
- processamento de ações
- envios para todos os jogadores
- sistemas de combate
- movimentação
- eventos periódicos do mundo

Aqui ficam as funções:
- `Game::playerMove()`
- `Game::combat()`
- `Game::internalCreatureSay()`
- `Game::addCreature()`
- `Game::removeCreature()`

⚠️ Um erro aqui afeta o servidor inteiro.

---

### ✔ `player.cpp`
Tudo que é específico do jogador:
- level, skills e mana
- velocidade
- adição/remoção de itens
- salvamento e carregamento do personagem
- trade
- conversas privadas
- death/experience loss

Funções importantes:
- `Player::receiveDamage()`
- `Player::addItem()`
- `Player::login()`
- `Player::logout()`

---

### ✔ `creature.cpp`
Classe base de monstros e players.

Controla:
- saúde
- velocidade
- movimentação
- efeitos de condição (poison, burning)
- visão e alcance
- target system
- pathfinding (com map)

Funções:
- `Creature::onThink()`
- `Creature::onDeath()`
- `Creature::getStepDuration()`

---

### ✔ `monster.cpp`
IA do monstro.

Controla:
- comportamento
- ataques
- troca de target
- summons
- loot drop

Funções:
- `Monster::doAttacks()`
- `Monster::selectTarget()`
- `Monster::onDeath()`

---

### ✔ `combat.cpp`
Sistema de dano.

Responsável por:
- cálculos de dano
- multiplicadores
- efeitos
- elementos (fire, energy, ice, holy, death)
- dano físico e distância
- healing spells

Funções:
- `Combat::doCombat()`
- `Combat::getType()`
- `Combat::applyCondition()`

---

### ✔ `scheduler.cpp`
O “cronômetro” interno.

Controla:
- delayed events
- decay de itens
- cooldown global
- cooldown de spells
- spawn schedule

Estrutura:

- `Scheduler` → fila principal
- `Dispatcher` → executa em thread separada

---

### ✔ `protocolgame.cpp`
Camada de rede.

Gerencia:
- login
- movimentos
- mensagens
- troca de inventário
- efeitos
- ataques
- ações

Funções comuns:
- `ProtocolGame::parseMove()`
- `ProtocolGame::parseSpeak()`
- `ProtocolGame::sendMagicEffect()`
- `ProtocolGame::sendInventory()`

⚠️ Raramente se mexe nisso.  
Qualquer erro aqui → jogadores caindo.

---

### ✔ `map/`
Gerencia:
- tiles
- pathfinding
- light system
- protection zones
- spawn zones

Arquivos:
- `tile.cpp`
- `house.cpp`
- `spawn.cpp`

---

### ✔ `luascript/`
Conexão Engine → Lua.

Controla:
- registro das funções Lua
- execução dos scripts
- chamadas de eventos Lua

Funções:
- `LuaScriptInterface::callFunction()`
- `LuaScriptInterface::registerFunctions()`

---

# ⚙️ Fluxo completo de execução do servidor

1. Engine inicia
2. Carrega mapa
3. Carrega datapack
4. Carrega Lua / scripts
5. Inicia scheduler
6. Abre portas (ProtocolGame)
7. Jogador conecta
8. ProtocolGame cria sessão
9. Player login (chama onLogin Lua)
10. Mundo roda no Game Loop
11. Eventos do scheduler disparam
12. Scripts Lua respondem

---

# 💣 Onde mexer / Onde NÃO mexer

### ✔️ Seguro
- quase tudo no datapack (Lua)
- ajustes simples em `config.lua`

### ⚠️ Cuidado moderado
- `monster.cpp`
- `combat.cpp`
- `movement/map` (pathfinding)
- `player.cpp` (skills, XP)

### ❌ Perigoso
- `protocolgame.cpp`
- `scheduler.cpp`
- `serialization` (database)
- `game.cpp` (acoes centrais)

---

# 🔥 Dicas para mexer no C++

### 1. Sempre use PRÓPRIA branch
Nunca siga alterando direto na main.

### 2. Faça mudanças pequenas
Altera só 1 arquivo por commit.

### 3. Compile com debug ON
Mais logs, mais segurança.

### 4. Se possível, faça o protótipo em Lua antes
Lua = rápido para testar  
C++ = definitivo para performance

---

# 🧩 Resumo do Core
- **game.cpp** → coração  
- **player.cpp** → jogadores  
- **creature.cpp** → movimentação e vida  
- **monster.cpp** → IA dos monstros  
- **combat.cpp** → dano  
- **scheduler.cpp** → timers  
- **protocolgame.cpp** → rede  
- **luascript/** → integração com Lua  

Esse arquivo te dá tudo que você precisa para entender o motor por trás do Canary.
