# Canary OTServ API

## Overview

API HTTP e WebSocket para o Canary OTServ, construída com o framework Crow.
Fornece endpoints para informações do servidor, monitoramento de recursos, jogadores e atualizações em tempo real.

## Estrutura do Projeto

```
api/
├── CMakeLists.txt          # Configuração de build
├── README.md              
├── api.cpp                 # Implementação do servidor
├── api.hpp                 # Definição da classe APIServer
├── endpoints/             
│   ├── player.hpp         # Endpoints de jogadores
│   ├── server.hpp         # Endpoints do servidor
│   └── websocket.hpp      # Handler WebSocket
├── middleware/            
│   ├── auth.hpp          # Autenticação básica
│   ├── logging.hpp       # Log de requisições
│   ├── rate_limit.hpp    # Limitação de requisições
│   └── security.hpp      # Proteção XSS e CSRF
├── models/               
│   └── responses.hpp     # Estruturas de resposta
└── utils/
    ├── validators.hpp    # Validação de entrada
    └── system_info.hpp   # Info de CPU/Memória
```

## Endpoints

### Server Endpoints
```cpp
GET /api/v1/server/status
// Retorna status do servidor
{
  "sucesso": true,
  "dados": {
    "status": "online",
    "uptime": 3600,
    "players_online": 100,
    "max_players": 1000,
    "server_version": "1.0.0",
    "server_name": "Canary",
    "server_location": "Brazil",
    "server_ip": "127.0.0.1"
  }
}

GET /api/v1/server/resources
// Retorna uso de recursos do sistema
{
  "sucesso": true,
  "dados": {
    "process": {
      "name": "canary.exe"
    },
    "memory": {
      "working_set_mb": 123.45,
      "private_usage_mb": 89.01
    },
    "cpu": {
      "usage_percent": 2.5
    },
    "system": {
      "cpu_cores": 8,
      "architecture": 64
    }
  }
}

GET /api/v1/server/motd
// Retorna mensagem do dia
{
  "sucesso": true,
  "dados": {
    "motd": "Bem-vindo ao servidor!"
  }
}
```

### Player Endpoints
```cpp
GET /api/v1/playersOnline
// Retorna lista de jogadores online
{
  "sucesso": true,
  "dados": {
    "total": 100,
    "max": 1000,
    "players": [
      {
        "name": "Player1",
        "level": 100,
        "vocation": "Knight",
        "online_time": "verificar"
      }
    ]
  }
}

GET /api/v1/players/<nome>
// Retorna informações detalhadas do jogador
{
  "sucesso": true,
  "dados": {
    "name": "Player1",
    "level": 100,
    "vocation": "Knight",
    "health": 1000,
    "max_health": 1000,
    "mana": 800,
    "max_mana": 1000,
    "skills": {
      "magic": 80,
      "fist": 70,
      "club": 65,
      "sword": 90,
      "axe": 75,
      "distance": 85,
      "shielding": 88,
      "fishing": 50
    }
  }
}
```

## Recursos

### Monitoramento de Sistema
- CPU: uso por processo usando PDH (Windows) ou /proc/[pid]/stat (Linux)
- Memória: working set e uso privado
- Informações do sistema: cores e arquitetura
- Nome do processo em execução
- Atualização em tempo real

### Segurança
- Proteção contra XSS
- Validação de Content-Type
- Sanitização de entrada
- Proteção CSRF
- Rate limiting configurável por rota

### Validação
- Validação de nomes de jogadores
- Validação de paginação
- Sanitização de entrada
- Respostas de erro padronizadas

### WebSocket
- Suporte a eventos em tempo real
- Subscribe/Unsubscribe para eventos específicos
- Notificações de status do servidor
- Eventos de jogadores (entrada/saída)

## Middlewares

### Rate Limiting
- Configurável por rota
- Implementação em memória com mutex
- Janela deslizante de 60 segundos

### Autenticação
- Bearer token
- Validação por rota

### Logging
- Request ID único
- Tempo de resposta
- Método e URL
- IP do cliente
- Corpo da requisição (limitado)

## Configuração

### Servidor
```cpp
void APIServer::initialize(uint16_t port = 8081);
```

### CORS
- Origin: "*"
- Methods: GET, POST
- Headers: Content-Type, Authorization

## Próximos Passos

1. Testes unitários e de integração
2. SSL/TLS
3. Autenticação avançada
4. Cache para endpoints frequentes
5. Métricas de performance
6. Sistema de logging avançado
7. Documentação OpenAPI/Swagger

## Próximos Passos Possiveis a serem implementados
1. Implementar rate limiting por IP e por rota específica (feito)
2. Adicionar validação de entrada para todos os endpoints (feito)
3. Implementar proteção contra ataques comuns (XSS, CSRF, etc) (feito)
4. Implementar um sistema de cache para respostas frequentes
5. Considerar implementar um sistema de eventos assíncronos para operações longas
6. Implementar pagination nos endpoints que retornam listas
7. Otimizar o tamanho das respostas JSON
8. Implementar sistema de notificações em tempo real via WebSocket
9. Adicionar suporte a batch operations para operações em massa


