# Canary Server 14.x – Visão Geral

O Canary é um servidor OpenTibia moderno, focado em:
- estabilidade,
- performance,
- arquitetura limpa,
- suporte à versão 13+ do Tibia.

Ele usa:
- C++ (engine)
- Lua (scripts)
- CMake (build system)
- MySQL/MariaDB ou SQLite (DB)

## Componentes principais

### 1. Engine (C++)
Local: `/src/`

Responsável por:
- Game loop
- Combate
- Criaturas (player, monster, npc)
- Movimentação
- Mapa
- Tempo e schedulers
- Networking (protocolo)
- Containers e pilhas de itens
- Partes críticas: `game.cpp`, `creature.cpp`, `player.cpp`, `combat.cpp`

### 2. Datapack (Lua + XML)
Local: `/data/`

Contém:
- itens (items.xml)
- monstros (monsters/)
- npcs (npcs/)
- spells (spells/)
- esquemas de loot (drop.lua / loot systems)
- scripts divididos por áreas:
  - actions/
  - creaturescripts/
  - movements/
  - talkactions/
  - weapons/
  - events/
  - globalevents/

Scripts chamam funções internas via API de Lua.

### 3. Configuração
Local: `/config.lua`

Define:
- portas
- DB
- freq. de monster spawn
- config do stamina
- proteção de pz
- velocidade
- comportamento de loot
- opções de balanceamento

### 4. Database
Arquivos SQL disponíveis no repositório:
- estrutura das tabelas
- contas
- players
- storages
- guilds
- kills
- houses

### 5. Networking
- Usa protocolo próprio “Tibia 13+”
- Módulo: `/src/protocolgame.cpp`
- Criptografia XTEA
- Login via OTP opcional

## Fluxo de execução básico
1. Servidor inicia → carrega mapa
2. Carrega datapack
3. Carrega scripts Lua
4. Inicia schedulers (eventos, decay, movement)
5. Inicializa listener na porta configurada
6. Jogador conecta
7. ProtocolGame cria a sessão
8. Player entra na instância do Game
9. Scripts reagem aos eventos:
   - onLogin
   - onLogout
   - onUse
   - onCastSpell
   - onKill
   - onDeath
   - onThink
10. Game Loop roda até ser desligado.

## Filosofia do Canary
- Engine deve ser máxima performance
- Scripts devem ser leves, legíveis e simples
- C++ é para mecânicas complexas
- Lua é para lógica de jogo
- Toda feature nova segue PR, testes e revisão

## Onde mexer e onde NÃO mexer
✔️ **Pode mexer com segurança**
- datapack (Lua)
- xml de monstros e itens
- spells
- npcs
- scripts de eventos

⚠️ **Requer extremo cuidado**
- player.cpp
- scheduler.cpp
- combat.cpp
- game.cpp
- creature.cpp

❌ **Quase nunca mexer**
- networking
- qualquer parte do protocolo
- serialização da database
