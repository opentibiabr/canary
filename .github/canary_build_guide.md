# Canary Build Guide 1.0
Guia simples e enxuto para compilar e rodar o Canary 14.x em ambiente local ou servidor.

---

## 1. Requisitos

### Windows
- Visual Studio 2022 (workload “Desktop development with C++”)
- CMake 3.22 ou superior
- Git
- vcpkg (recomendado para dependências)

### Linux (Ubuntu/Debian)
Rodar:

    sudo apt update
    sudo apt install build-essential cmake git libmysqlclient-dev libboost-all-dev liblua5.4-dev

### Docker (opcional)
- Docker Engine instalado

---

## 2. Clonar o projeto

Dentro da pasta onde quer o código:

    git clone https://github.com/opentibiabr/canary.git
    cd canary
    git submodule update --init --recursive

(Se estiver usando o fork VayraTibia, trocar a URL pelo seu repositório.)

---

## 3. Compilar com CMake (Windows e Linux)

Criar pasta de build e gerar arquivos:

    mkdir build
    cd build
    cmake ..

Compilar em modo Release:

    cmake --build . --config Release

Local padrão dos binários:
- Windows: `build/Release/`
- Linux: `build/src/`

---

## 4. Configurar banco de dados

### 4.1 Criar banco

No MySQL/MariaDB:

    CREATE DATABASE canary;

### 4.2 Importar schema

Na raiz do projeto (onde está o arquivo schema):

    mysql -u root -p canary < schema.sql

### 4.3 Ajustar config.lua

Abrir `config.lua` e configurar:

    mysqlHost = "127.0.0.1"
    mysqlUser = "root"
    mysqlPass = "SUA_SENHA_AQUI"
    mysqlDatabase = "canary"

Demais opções (rates, xp, loot, pvp, etc.) podem ser ajustadas depois.

---

## 5. Executar o servidor

### Linux

Na pasta onde está o binário:

    ./canary

### Windows

Na pasta `build/Release`:

    canary.exe

Saída esperada no console:

    Canary Server starting...
    Done: Server online

Se aparecer erro de DB ou config, revisar `config.lua` e o acesso ao MySQL.

---

## 6. Build usando vcpkg (Windows – opcional, recomendado)

Dentro da pasta do vcpkg:

    vcpkg install boost-asio:x64-windows lua:x64-windows

Depois, na pasta `build` do projeto:

    cmake -DCMAKE_TOOLCHAIN_FILE=C:/caminho/para/vcpkg/scripts/buildsystems/vcpkg.cmake ..
    cmake --build . --config Release

Substituir `C:/caminho/para/vcpkg` pelo caminho correto do vcpkg na máquina.

---

## 7. Build com Docker

Na raiz do projeto:

    docker build -t canary .

Rodar o container:

    docker run -d --name canary-server -p 7171:7171 -p 7172:7172 canary

Isso sobe o servidor dentro de um container, expondo as portas padrão (7171/7172).

---

## 8. Deploy simples na AWS EC2

### 8.1 Instância

- Tipo sugerido para testes: `t2.micro` (free tier)
- Sistema: Ubuntu Server

Após conectar por SSH:

    sudo apt update
    sudo apt install build-essential cmake git libmysqlclient-dev libboost-all-dev liblua5.4-dev mysql-server -y

Clonar e compilar (mesmos passos das seções 2 e 3).

### 8.2 Abrir portas

No security group da instância EC2, liberar:

- TCP 7171
- TCP 7172

### 8.3 Rodar em background

Na pasta do binário:

    nohup ./canary > server.log 2>&1 &

Para ver logs:

    tail -f server.log

---

## 9. Ciclo rápido de rebuild (quando modificar C++)

Dentro da pasta `build`:

1. Atualizar código:

       git pull

2. Regerar CMake (se necessário):

       cmake ..

3. Recompilar:

       cmake --build . --config Release

Se der erro estranho, fazer rebuild total:

       cd ..
       rm -rf build
       mkdir build
       cd build
       cmake ..
       cmake --build . --config Release

---

## 10. Observações importantes

- Mudanças no **datapack** (Lua/XML) **não exigem** recompilação.
- Mudanças na **engine C++** exigem recompilar (`cmake --build`).
- Docker é o método mais limpo para ambiente controlado.
- EC2 t2.micro aguenta bem desenvolvimento e até uns 10–30 players.
- Para 100+ players, considerar:
  - instância maior (ex.: t3.small ou superior),
  - banco em RDS,
  - discos EBS mais rápidos.

---

## 11. Resumo ultrarrápido

1. Instalar dependências  
2. Clonar repositório  
3. `mkdir build && cd build`  
4. `cmake ..`  
5. `cmake --build . --config Release`  
6. Configurar `config.lua` + DB  
7. Executar `./canary` ou `canary.exe`

Fim.
