# Métricas no Canary (OpenTelemetry + Prometheus)

## 🚀 Início Rápido

### Compilar com Métricas

```bash
./scripts/build_with_metrics.sh
```

### Configurar

Edite `config.lua`:
```lua
metricsEnablePrometheus = true
metricsPrometheusAddress = "0.0.0.0:9464"
```

### Iniciar Monitoring Stack

```bash
./scripts/start_monitoring.sh
```

**Serviços:**
- Prometheus: http://localhost:9090
- Grafana: http://localhost:4444 (admin/admin)

---

## 📊 O Que São Métricas?

Sistema de **observabilidade** que permite monitorar performance e comportamento do servidor em tempo real usando:
- **OpenTelemetry** - Coleta de métricas
- **Prometheus** - Armazenamento de séries temporais
- **Grafana** - Visualização em dashboards

---

## 🔧 Status Atual

| Item | Status |
|------|--------|
| **Implementação** | ✅ Completa (PR #1966, dez/2023) |
| **Estado padrão** | ⚠️ Desabilitado (requer build específico) |
| **OpenTelemetry** | 🔒 Fixado em v1.2.0 |
| **Testado em produção** | ✅ Sim ([dashboard demo](https://snapshots.raintank.io/dashboard/snapshot/bpiq45inK3I2Xixa2d7oNHWekdiDE6zr)) |

**Por que v1.2.0?** Breaking changes na API v1.20+ (`unique_ptr` → `shared_ptr`). Fixação permite build sem modificar código.

---

## 📈 Métricas Disponíveis

### Histogramas de Latência (microsegundos)

| Métrica | Descrição | Label |
|---------|-----------|-------|
| `method_latency` | Latência de métodos C++ | `method` |
| `lua_latency` | Latência de funções Lua | `scope` |
| `query_latency` | Latência de queries SQL | `truncated_query` |
| `task_latency` | Latência de tasks do Dispatcher | `task` |
| `lock_latency` | Contenção de locks | `scope` |

### Contadores

- `monster_killed` - Monstros mortos (por tipo, jogador)
- `experience_gained` - Experiência ganha
- `gold_gained` - Gold obtido
- Customizáveis via Lua: `metrics.addCounter(name, value, {labels})`

---

## 🔍 Exemplos de Queries (PromQL)

### Latência P99 de Métodos
```promql
histogram_quantile(0.99, rate(method_latency_bucket[5m]))
```

### Exp/Hora por Jogador
```promql
rate(experience_gained_total{player_name="Nome"}[1h]) * 3600
```

### Top 10 Métodos Lentos
```promql
topk(10, histogram_quantile(0.99, rate(method_latency_bucket[5m]))) by (method)
```

### Monsters Mortos/Hora
```promql
rate(monster_killed_total[1h]) * 3600
```

---

## 🛠️ Compilação Manual

Se preferir não usar o script:

```bash
# 1. Configurar
cmake -DCMAKE_TOOLCHAIN_FILE=$VCPKG_ROOT/scripts/buildsystems/vcpkg.cmake \
      -DFEATURE_METRICS=ON \
      -B build-metrics

# 2. Compilar
cmake --build build-metrics -j$(nproc)

# 3. Testar
curl http://localhost:9464/metrics
```

---

## 🎨 Grafana - Criar Dashboard

### Painel 1: Players Online
```
Metric: players_online
Visualization: Gauge
```

### Painel 2: Latência SQL P99
```
Query: histogram_quantile(0.99, rate(query_latency_bucket[5m]))
Visualization: Graph
Unit: microseconds (µs)
```

### Painel 3: Exp/h por Jogador
```
Query: rate(experience_gained_total[1h]) * 3600
Visualization: Table
Format: player_name, value
```

---

## 🔍 Troubleshooting

### Métricas não aparecem no Prometheus

**Verificar:**
```bash
# Endpoint está respondendo?
curl http://localhost:9464/metrics

# Prometheus alcança o target?
# Acesse: http://localhost:9090/targets
# Status deve ser UP
```

**Solução:** Verificar config.lua e porta 9464

### Grafana não conecta

**Causa:** Data Source mal configurado

**Solução:**
- Se ambos em Docker: `http://prometheus:9090`
- Se Grafana em Docker e Prom no host: `http://host.docker.internal:9090`
- Se ambos no host: `http://localhost:9090`

### Impacto de Performance

**Overhead:** ~1-2% CPU (aceitável)

**Recomendações:**
- ✅ Usar Prometheus (pull-based)
- ❌ NUNCA usar `metricsEnableOstream` em produção
- ✅ Scrape interval: 15-30s
- ✅ Retention: 15 dias

---

## 📚 Referências

- **Documentação completa:** `docs/METRICS_ENABLE.md`
- **Investigação técnica:** `docs/metrics-investigation.md`
- **Dashboard demo:** https://snapshots.raintank.io/dashboard/snapshot/bpiq45inK3I2Xixa2d7oNHWekdiDE6zr
- **PR original:** https://github.com/opentibiabr/canary/pull/1966

**Links externos:**
- OpenTelemetry: https://opentelemetry.io/
- Prometheus: https://prometheus.io/
- Grafana: https://grafana.com/

---

**⚠️ Importante:** Endpoint `/metrics` não tem autenticação. Use firewall para restringir acesso.

**Versão do documento:** 1.0  
**Data:** 2025-11-16  
**OpenTelemetry:** v1.2.0 (fixada)
