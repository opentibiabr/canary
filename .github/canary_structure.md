# Estrutura de Pastas do Canary 14.x
Guia completo e simples para entender onde tudo mora e o que pode ser modificado.

---

# 📁 Raiz do projeto

- `src/` — código C++ da engine  
- `data/` — datapack (scripts Lua + XML)  
- `config.lua` — configuração principal  
- `CMakeLists.txt` — config do build  
- `cmake/` — módulos do CMake  
- `docker/` — ambiente Docker pronto  
- `docs/` — documentação  
- `tests/` — testes automatizados C++  
- `vcpkg.json` — dependências do vcpkg  

---

# 📂 /src — ENGINE C++

Contém toda a lógica interna do servidor.

### Principais subpastas:

### ✔ `src/game/`
- `game.cpp` — regras centrais do servidor  
- `combat.cpp` — cálculo de dano  
- `player.cpp` — comportamento do player  
- `creature.cpp` — comportamento de criaturas  
- `monster.cpp` — IA dos monstros  
- `scheduler.cpp` — timers e eventos  
- `map/` — loader do mapa, pathfinding

### ✔ `src/io/`
- serialização de itens, players e containers  
- protocolo de login e game

### ✔ `src/lua/`
- ponte entre C++ e scripts Lua  
- registra funções acessíveis aos scripts

### ✔ `src/database/`
- MySQL/SQLite  
- queries de load/save do personagem

### ✔ `src/otserv/`
- sistema de NPCs  
- bancos  
- tasks avançadas

⚠️ **Regra de ouro:**  
“Toda mecânica nova → tente fazer em Lua antes; mexer em C++ só quando necessário.”

---

# 📂 /data — DATAPACK

Tudo que afeta o jogo SEM compilar.

### ✔ `data/actions/`
Scripts chamados quando um item é usado.

### ✔ `data/creaturescripts/`
Eventos de criaturas:
- onLogin
- onLogout
- onThink
- onKill
- onDeath

### ✔ `data/movements/`
Triggers de movimento:
- stepping IN/OUT de tiles
- teleport triggers
- zones especiais

### ✔ `data/weapons/`
Armas que usam `onUseWeapon`.

### ✔ `data/talkactions/`
Comandos de chat `/comando`.

### ✔ `data/spells/`
Spells em XML + script Lua.

### ✔ `data/lib/`
Bibliotecas auxiliares:
- cooldowns
- damage helpers  
- table utils  
- funções comuns

### ✔ `data/globalevents/`
Eventos globais:
- server save
- spawn waves
- anúncios
- eventos programados

### ✔ `data/events/`
Eventos dinâmicos do jogo (tipo bosses).

### ✔ `data/raids/`
Spawns programados via XML.

### ✔ `data/monster/`
Pasta com:
- XML de monstros  
- scripts opcionais  
- loot tables

### ✔ `data/npc/`
NPCs com:
- comportamento XML  
- scripts Lua opcionais

---

# 📂 /data-canary / data-otservbr-global
Datapacks alternativos MODERNOS usados pelo Canary.  
Estruturados para:
- maior organização  
- modularidade  
- separação clara entre mapas  
- configs específicas  

*É recomendável usar o datapack “data-canary” porque é o mais atualizado.*

---

# 📂 /cmake
Contém módulos que ajudam a compilar o Canary.

Você não mexe nisso a menos que:
- queira adicionar libs
- configurar VSCode/CLion
- ajustar paths para Windows

---

# 📂 /docker
Ambiente Docker pronto para:

- compilar engine  
- rodar servidor  
- facilitar deploy

Útil quando quiser hospedar na AWS depois.

---

# 📄 config.lua — CONFIGURAÇÃO
Arquivo com configuracões essenciais como:

- porta  
- rate XP  
- loot rate  
- mana/stamina regen  
- multiplicadores  
- nível mínimo de PZ  
- PvP / non-PvP  
- caminhos para scripts  

É o arquivo que VOCÊ VAI MEXER CONSTANTEMENTE.

---

# 📁 /tests
Testes de unidade C++ usados pelos devs.

---

# 🔥 Resumo
**Tudo em `/src` → C++ → mexe com cuidado.**  
**Tudo em `/data` → Lua/XML → pode brincar à vontade.**

Esse arquivo ensina o **mapa mental da estrutura** pra trabalhar rápido com o Canary.

