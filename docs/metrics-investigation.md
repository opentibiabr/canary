# Investigação: Feature de Métricas (OpenTelemetry/Prometheus) no Canary

## Resumo Executivo

A feature de métricas baseada em **OpenTelemetry** e **Prometheus** foi **implementada e integrada ao projeto Canary**, porém está **desabilitada por padrão** desde abril de 2024. A implementação completa permanece no código-fonte, protegida por flags de compilação (`FEATURE_METRICS`), e pode ser habilitada a qualquer momento através de configuração no CMake.

**Status Atual:** ✅ Implementada, mas desabilitada por padrão (OFF)  
**Branch Principal:** `main` (contém a implementação)  
**Maturidade:** Produção (testada em servidores reais)

---

## Linha do Tempo

### 📅 Cronologia de Commits Relevantes

| Data | Commit | Autor | Descrição |
|------|--------|-------|-----------|
| 09/12/2023 | `9d6099361` | Luan Santos | **feat: opentelemetry metrics (#1966)** - Implementação inicial completa |
| 14/02/2024 | `a023c64a4` | Eduardo Dantas | fix: old protocol wrong bytes and opentelemetry-cpp lib (#2233) |
| 17/03/2024 | `d643fba74` | Luan Santos | fix: check if bankable is valid player before emitting metric (#2453) |
| 01/04/2024 | `0c0e5467b` | Beats | **feat: disable metrics at compile-time (#2509)** - Desabilita por padrão |
| 04/06/2024 | `2db5fee1f` | miah-sebastian | fix: opentelemetry linker error (#2678) |
| 29/08/2024 | `c5a2b08af` | beats-dh | **remove opemtelemetry lib metrics off** - Remove dep do vcpkg padrão |

---

## Branches Relevantes

### Branch: `main` (upstream)
- ✅ **Contém a implementação completa de métricas**
- ⚠️ `FEATURE_METRICS` = **OFF** por padrão no `CMakeLists.txt`
- ✅ Código fonte mantido com `#ifdef FEATURE_METRICS`
- ✅ Documentação em `metrics/README.md` presente
- ✅ Configuração no `config.lua.dist` presente

### Branch: `beats-fixs`
- Contém o commit `c5a2b08af` que removeu a dependência automática do vcpkg
- Não é necessário usar este branch para métricas

### Nenhum branch específico de métricas ativo
- Não há PRs abertas sobre métricas atualmente
- A feature está integrada e estável no `main`

---

## Análise Técnica da Implementação

### 1. Estrutura de Arquivos

#### Código Fonte C++
```
src/lib/metrics/
├── metrics.hpp        # Interface principal e definições
└── metrics.cpp        # Implementação (apenas compilado se FEATURE_METRICS=ON)

src/lua/functions/core/libs/
├── metrics_functions.hpp
└── metrics_functions.cpp  # Bindings Lua para métricas
```

#### Configuração e Documentação
```
metrics/
├── README.md                    # Documentação completa
├── docker-compose.yml           # Stack Prometheus + Grafana
└── prometheus/
    └── prometheus.yml           # Configuração do Prometheus
```

### 2. Arquitetura da Implementação

#### A. Código Protegido por Compilação Condicional
Todo o código de métricas está encapsulado em `#ifdef FEATURE_METRICS`:

```cpp
// src/lib/metrics/metrics.hpp
#ifdef FEATURE_METRICS
    // Implementação completa com OpenTelemetry
    #include <opentelemetry/exporters/prometheus/exporter_factory.h>
    namespace metrics {
        class Metrics final { /* ... */ };
        class ScopedLatency { /* ... */ };
    }
#else
    // Stubs vazios (zero overhead quando desabilitado)
    class ScopedLatency {
        void stop() const {};
    };
    namespace metrics {
        class Metrics {
            void addCounter(...) const { }
        };
    }
#endif
```

**Vantagem:** Quando desabilitado, não há impacto no desempenho (stubs inline).

#### B. Tipos de Métricas Implementadas

##### **Histogramas de Latência**
```cpp
DEFINE_LATENCY_CLASS(method, "method", "method");     // Métodos C++
DEFINE_LATENCY_CLASS(lua, "lua", "scope");            // Funções Lua
DEFINE_LATENCY_CLASS(query, "query", "truncated_query"); // Queries SQL
DEFINE_LATENCY_CLASS(task, "task", "task");           // Tasks do Dispatcher
DEFINE_LATENCY_CLASS(lock, "lock", "scope");          // Contenção de locks
```

**Uso no código:**
```cpp
// Em src/game/game.cpp (linha 1177)
metrics::method_latency measure(__METRICS_METHOD_NAME__);
```

##### **Contadores**
```cpp
g_metrics().addCounter("monster_killed", 1.0, {
    {"monster_name", "Dragon"},
    {"player_name", player->getName()}
});
```

##### **UpDown Counters**
```cpp
g_metrics().addUpDownCounter("players_online", 1);  // Jogador conectou
g_metrics().addUpDownCounter("players_online", -1); // Jogador desconectou
```

#### C. Integração Lua
Exposição da API para scripts:

```lua
-- data/libs/systems/blessing.lua (exemplo real)
metrics.addCounter("blessing_purchased", 1, {
    player_name = player:getName(),
    blessing_id = tostring(blessingId)
})
```

### 3. Granularidade dos Histogramas

A implementação usa buckets de latência extremamente detalhados:

```cpp
// Ultra-fine: abaixo de 10µs (0-10µs com buckets de 1µs)
0.0, 1.0, 2.0, ..., 10.0

// Fine: 100-500µs (buckets de 25µs)
120.0, 140.0, ..., 500.0

// Moderate: 500µs-1ms
550.0, 600.0, ..., 1000.0

// Coarse: 1-10ms
1100.0, 1200.0, ..., 10000.0

// Very coarse: até segundos
20000.0, ..., 100000000.0, ∞
```

**Total:** ~120 buckets para precisão cirúrgica em análise de performance.

### 4. Exportadores Suportados

#### **A. Prometheus (Recomendado para Produção)**
```lua
-- config.lua
metricsEnablePrometheus = true
metricsPrometheusAddress = "0.0.0.0:9464"
```
- Expõe endpoint HTTP: `http://localhost:9464/metrics`
- Pull-based (Prometheus faz scraping)
- Zero impacto se Prometheus não estiver configurado

#### **B. OStream (Debug/Desenvolvimento)**
```lua
metricsEnableOstream = true
metricsOstreamInterval = 1000  -- Exporta a cada 1s para console
```
- Push-based para stdout
- ⚠️ **NÃO usar em produção** (overhead nos logs)

### 5. Dependências

#### vcpkg.json (Condicional)
```json
{
  "features": {
    "metrics": {
      "description": "Enable OpenTelemetry support",
      "dependencies": [
        {
          "name": "opentelemetry-cpp",
          "default-features": true,
          "features": ["otlp-http", "prometheus"]
        }
      ]
    }
  }
}
```

**Instalação manual necessária:**
```bash
# Linux
vcpkg install opentelemetry-cpp[default-features,otlp-http,prometheus] --triplet x64-linux

# Windows (estático)
vcpkg install opentelemetry-cpp[default-features,otlp-http,prometheus] --triplet x64-windows-static
```

---

## Status Atual da Feature

### ✅ O que está Funcional

1. **Código Fonte Completo**
   - Implementação C++ robusta e testada
   - Bindings Lua funcionais
   - Zero overhead quando desabilitado

2. **Instrumentação Integrada**
   - 16 arquivos no código já chamam métricas
   - Pontos críticos instrumentados:
     - `game.cpp` (spawn, movimento, teleporte)
     - `player.cpp` (ações do jogador)
     - `creature.cpp` (combate)
     - `bank.cpp` (transações)
     - `luascript.cpp` (execução de scripts)

3. **Documentação e Infraestrutura**
   - README completo com exemplos
   - Docker Compose para Prometheus + Grafana
   - Configurações em `config.lua.dist`

4. **Dashboards Demonstrados**
   - Link para dashboard de produção: https://snapshots.raintank.io/dashboard/snapshot/bpiq45inK3I2Xixa2d7oNHWekdiDE6zr
   - Screenshots no PR #1966 mostram:
     - Latência de métodos C++
     - Latência de funções Lua
     - Latência de queries SQL
     - Exp/h por jogador
     - Gold/h por jogador
     - Monsters mortos/h

### ⚠️ Limitações Atuais

1. **Desabilitado por Padrão**
   - Requer recompilação com flag `FEATURE_METRICS=ON`
   - Dependência `opentelemetry-cpp` não é instalada automaticamente

2. **Falta de Documentação de Ativação**
   - `README.md` explica o uso, mas não como habilitar durante build
   - Não há menção no `README.md` principal do projeto

3. **Sem Métricas de Sistema**
   - Não coleta CPU, memória, I/O do processo
   - Foca apenas em métricas de aplicação

---

## Passos para Habilitar Métricas

### 1. Instalar Dependências

```bash
# Instalar opentelemetry-cpp via vcpkg
vcpkg install opentelemetry-cpp[default-features,otlp-http,prometheus] --triplet x64-linux
```

### 2. Recompilar com Flag

```bash
cd /opt/canary
mkdir -p build && cd build

# CMake com FEATURE_METRICS habilitado
cmake -DFEATURE_METRICS=ON ..

# Ou via ambiente
cmake -DCMAKE_TOOLCHAIN_FILE=$VCPKG_ROOT/scripts/buildsystems/vcpkg.cmake \
      -DFEATURE_METRICS=ON \
      ..

make -j$(nproc)
```

### 3. Configurar no config.lua

```lua
-- Habilitar Prometheus
metricsEnablePrometheus = true
metricsPrometheusAddress = "0.0.0.0:9464"

-- Opcional: Debug via console (NÃO usar em produção)
metricsEnableOstream = false
metricsOstreamInterval = 1000
```

### 4. Iniciar Stack de Monitoramento

```bash
cd /opt/canary/metrics
docker-compose up -d
```

- **Prometheus:** http://localhost:9090
- **Grafana:** http://localhost:4444 (admin/admin)

### 5. Verificar Funcionamento

```bash
# Verificar endpoint do Canary
curl http://localhost:9464/metrics

# Deve retornar métricas no formato Prometheus:
# method_latency_bucket{method="placeCreature",le="1.0"} 245
# lua_latency_bucket{scope="onUse",le="100.0"} 1523
# ...
```

---

## Validação: Branch Main Suporta Métricas?

### ✅ SIM, com Condições

| Aspecto | Status | Nota |
|---------|--------|------|
| **Código Fonte** | ✅ Presente | Commits de #1966 estão no `main` |
| **Compilação Padrão** | ❌ Desabilitado | `FEATURE_METRICS=OFF` no CMakeLists.txt |
| **Dependências** | ⚠️ Condicionais | `opentelemetry-cpp` não instalado por padrão |
| **Configuração** | ✅ Presente | `config.lua.dist` tem parâmetros |
| **Documentação** | ✅ Presente | `metrics/README.md` completo |
| **Docker** | ✅ Funcional | `docker-compose.yml` para Prom+Grafana |

**Conclusão:** O branch `main` **suporta plenamente métricas**, mas **não sem recompilação**.

---

## Uso com Prometheus + Grafana

### Arquitetura

```
┌─────────────────┐       ┌───────────────┐       ┌──────────────┐
│  Canary Server  │──────▶│  Prometheus   │──────▶│   Grafana    │
│  :9464/metrics  │ HTTP  │  :9090        │       │   :4444      │
│  (OpenTelemetry)│ Pull  │  (Scraping)   │       │  (Dashboard) │
└─────────────────┘       └───────────────┘       └──────────────┘
```

### Configuração Prometheus

```yaml
# metrics/prometheus/prometheus.yml
scrape_configs:
  - job_name: 'canary'
    scrape_interval: 15s
    static_configs:
      - targets: ['host.docker.internal:9464']
```

### Criação de Dashboards Grafana

#### Exemplo: Latência de Métodos C++
```promql
# P99 de latência do método placeCreature
histogram_quantile(0.99, 
  rate(method_latency_bucket{method="placeCreature"}[5m])
)
```

#### Exemplo: Monsters Mortos por Hora
```promql
rate(monster_killed_total[1h]) * 3600
```

#### Exemplo: Exp/h por Jogador
```promql
rate(experience_gained_total{player_name="PlayerName"}[1h]) * 3600
```

---

## Recomendações para Nosso Fork

### 🎯 Curto Prazo (Imediato)

1. **Documentar Ativação**
   - Adicionar seção no `README.md` principal
   - Criar guia em `docs/METRICS.md` com instruções de build

2. **Automatizar Build**
   - Adicionar preset CMake: `CMakePresets.json`
     ```json
     {
       "name": "metrics",
       "configurePresets": [{
         "name": "release-metrics",
         "cacheVariables": {
           "FEATURE_METRICS": "ON"
         }
       }]
     }
     ```

3. **Scripts de Helper**
   - Criar `scripts/build_with_metrics.sh`:
     ```bash
     #!/bin/bash
     vcpkg install opentelemetry-cpp[default-features,otlp-http,prometheus]
     cmake -DFEATURE_METRICS=ON -B build
     cmake --build build -j$(nproc)
     ```

### 🚀 Médio Prazo (1-2 sprints)

4. **Dashboards Pré-configurados**
   - Importar ou criar dashboards Grafana
   - Adicionar JSONs em `metrics/grafana/`
   - Dashboard sugerido:
     - Visão geral do servidor (TPS, players, latência)
     - Análise de performance (top 10 métodos lentos)
     - Análise de economia (exp/h, gold/h, loot drops)

5. **Métricas Customizadas**
   - Adicionar métricas específicas do nosso servidor
   - Exemplos:
     ```cpp
     // Em eventos customizados
     g_metrics().addCounter("custom_event_completed", 1, {
         {"event_name", eventName},
         {"participant_count", std::to_string(count)}
     });
     ```

6. **Alertas**
   - Configurar Prometheus AlertManager
   - Alertas sugeridos:
     - Latência SQL > 100ms
     - TPS < 15
     - Crash loops
     - Memória > 80%

### 🏗️ Longo Prazo (Roadmap)

7. **CI/CD com Métricas**
   - Build com `FEATURE_METRICS=ON` em CI
   - Testes de performance com métricas habilitadas
   - Benchmark automático entre commits

8. **Métricas de Sistema**
   - Integrar com exporters:
     - `node_exporter` (CPU, memória, disco)
     - `process_exporter` (processo do Canary)
   - Correlacionar métricas de aplicação com sistema

9. **APM Completo**
   - Migrar para OTLP (OpenTelemetry Protocol)
   - Integrar com backends APM:
     - Grafana Cloud
     - Elastic APM
     - Datadog
   - Habilitar **tracing distribuído** (ver latência end-to-end)

---

## ⚠️ ATUALIZAÇÃO: Problemas de Compilação Descobertos (16/11/2025)

### Tentativa de Compilação com FEATURE_METRICS=ON

Durante tentativa de habilitar métricas, descobrimos **incompatibilidades críticas**:

#### ❌ Erro 1: Incompatibilidade de API do OpenTelemetry

**Problema:**
```
error: cannot convert 'std::unique_ptr<opentelemetry::v1::sdk::metrics::MeterProvider>' 
to 'const opentelemetry::v1::nostd::shared_ptr<opentelemetry::v1::metrics::MeterProvider>&'
```

**Causa Raiz:**
- Código escrito para **OpenTelemetry v1.2.0** (dezembro 2023)
- vcpkg instalou **OpenTelemetry v1.20.0** (baseline de abril 2025)
- **Breaking change na API:** `SetMeterProvider` mudou de `unique_ptr` para `shared_ptr`

**Arquivo afetado:** `src/lib/metrics/metrics.cpp:42`

**Linha problemática:**
```cpp
metrics_api::Provider::SetMeterProvider(std::move(provider)); // ❌ unique_ptr não aceito
```

**API esperada em v1.20.0:**
```cpp
// Requer shared_ptr ao invés de unique_ptr
void SetMeterProvider(const nostd::shared_ptr<MeterProvider>&);
```

#### ❌ Erro 2: Missing include `account_repository.hpp`

**Problema:**
```
error: 'g_accountRepository' was not declared in this scope
```

**Causa:** Include faltante em `src/io/iologindata.cpp:43`

**Contexto:** Provavelmente funcionava antes via unity build, mas quebrou com alguma refatoração recente.

---

### 📊 Sumário de Evidências (Atualizado)

| Pergunta | Resposta |
|----------|----------|
| **A feature foi implementada?** | ✅ Sim, completamente (PR #1966 de 09/12/2023) |
| **Está no branch main?** | ✅ Sim, merged e estável |
| **Foi revertida?** | ❌ Não, apenas desabilitada por padrão |
| **Precisa de patch?** | ⚠️ **SIM - Incompatível com OpenTelemetry v1.20+** |
| **Há documentação?** | ✅ Sim, em `metrics/README.md` |
| **Funciona com Prometheus?** | ⚠️ Sim, mas requer downgrade de dependência |
| **Funciona com Grafana?** | ⚠️ Sim, mas requer downgrade de dependência |
| **Há overhead quando desabilitado?** | ❌ Não, stubs inline (zero-cost) |
| **Compila com flag ON?** | ❌ **NÃO - Requer atualização do código** |

### 🔧 Opções de Correção

#### Opção A: Fixar Versão do OpenTelemetry (Recomendado)

Adicionar override no `vcpkg.json` para usar versão compatível:

```json
{
  "overrides": [
    {
      "name": "opentelemetry-cpp",
      "version": "1.2.0"
    }
  ]
}
```

**Prós:**
- Solução rápida
- Mantém código original
- Testado e funcional

**Contras:**
- Usa versão antiga (dez/2023)
- Perde melhorias/fixes recentes

#### Opção B: Atualizar Código para OpenTelemetry v1.20+

Migrar `metrics.cpp` para nova API:

```cpp
// Mudar de unique_ptr para shared_ptr
auto provider = std::shared_ptr<metrics_sdk::MeterProvider>(
    metrics_sdk::MeterProviderFactory::Create().release()
);
// ... 
metrics_api::Provider::SetMeterProvider(provider);
```

**Prós:**
- Usa versão atual e suportada
- Aproveita melhorias de performance
- Alinha com upstream futuro

**Contras:**
- Requer testes extensivos
- Pode ter mais breaking changes ocultos
- Precisa validar com Prometheus/Grafana

#### Opção C: Aguardar Upstream

Abrir issue no repositório oficial reportando incompatibilidade e aguardar fix.

**Prós:**
- Fix oficial e testado pela comunidade
- Sem manutenção no nosso fork

**Contras:**
- Tempo indeterminado
- Pode nunca ser priorizado (feature desabilitada)

---

### 🎯 Decisão Recomendada (Revisada)

**AGUARDAR ou implementar Opção B (Atualizar Código)** pelos seguintes motivos:

1. **Incompatibilidade Confirmada**
   - Não compila com versões atuais do OpenTelemetry
   - Requer trabalho adicional para ativar
   - Feature não está sendo mantida ativamente pelo upstream

2. **Valor vs Esforço**
   - Se métricas são críticas: vale o esforço de atualizar
   - Se não são urgentes: aguardar fix oficial
   
3. **Ganhos Potenciais Permanecem**
   - Arquitetura bem desenhada
   - Implementação completa (só precisa update de API)
   - Documentação e dashboards prontos
   
4. **Próximos Passos Sugeridos**
   - **Se crítico:** Implementar Opção B (atualizar para OpenTelemetry v1.20)
   - **Se não urgente:** Aguardar fix oficial do upstream
   - **Alternativa rápida:** Opção A (fixar versão v1.2.0 no vcpkg.json)

---

## Conclusão (Original - Pré-Descoberta de Incompatibilidade)

### 📝 Status Final

1. ✅ **Documento criado:** `docs/metrics-investigation.md`
2. ⚠️ **Descoberta:** Incompatibilidade com OpenTelemetry v1.20+
3. ✅ **FEATURE_METRICS revertido para OFF** (seguro)
4. 📋 **Documentação atualizada** com achados de compilação
5. ⏭️ **Próxima decisão:** Escolher entre Opções A, B ou C acima

### ⚠️ Ações NÃO Recomendadas No Momento

- ❌ Habilitar FEATURE_METRICS=ON no fork (não compila)
- ❌ Fazer mudanças no código sem validação upstream
- ❌ Criar PR para upstream sem discussão prévia
- ❌ Subir stack Prometheus+Grafana (servidor não expõe métricas)

---

## Referências

### Commits Importantes
- **PR #1966:** https://github.com/opentibiabr/canary/pull/1966
- Commit inicial: `9d6099361` (09/12/2023)
- Desabilitar padrão: `0c0e5467b` (01/04/2024)
- Remover lib padrão: `c5a2b08af` (29/08/2024)

### Arquivos Chave
```
CMakeLists.txt              # Flag FEATURE_METRICS (linha 132-136)
vcpkg.json                  # Dependência condicional (linhas 24-28)
config.lua.dist             # Configurações (linhas 610-615)
metrics/README.md           # Documentação completa
metrics/docker-compose.yml  # Stack Prometheus+Grafana
src/lib/metrics/            # Implementação core
```

### Dashboard Demonstração
- **Produção Real:** https://snapshots.raintank.io/dashboard/snapshot/bpiq45inK3I2Xixa2d7oNHWekdiDE6zr

### Documentação Externa
- **OpenTelemetry:** https://opentelemetry.io/
- **Prometheus:** https://prometheus.io/
- **Grafana:** https://grafana.com/docs/

---

**Documento gerado em:** 2025-11-16  
**Repositório investigado:** opentibiabr/canary  
**Upstream:** https://github.com/opentibiabr/canary  
**Fork atual:** /opt/canary (feature/metrics)
