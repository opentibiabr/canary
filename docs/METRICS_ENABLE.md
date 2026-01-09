# Como Habilitar Métricas (OpenTelemetry/Prometheus) no Canary

## 📊 Situação Atual

A feature de métricas baseada em **OpenTelemetry** e **Prometheus** foi implementada em dezembro de 2023 (PR #1966) e está **totalmente funcional**, mas requer compilação específica para ser ativada.

### Status
- ✅ **Código implementado** e testado em produção
- ⚠️ **FEATURE_METRICS desabilitado** por padrão (OFF)
- ⚠️ **Dependência fixada** em OpenTelemetry v1.2.0

---

## ⚙️ Por Que a Dependência Foi Fixada?

Durante tentativa de compilação com métricas habilitadas, descobrimos uma **incompatibilidade de API**:

| Componente | Versão Esperada | Versão Instalada (vcpkg) | Status |
|------------|-----------------|--------------------------|--------|
| OpenTelemetry-cpp | v1.2.0 (dez/2023) | v1.20.0 (abr/2025) | ❌ Breaking change |

**Problema:** A API `SetMeterProvider` mudou entre versões:
- **v1.2.0:** Aceita `std::unique_ptr<MeterProvider>`
- **v1.20.0:** Aceita `const std::shared_ptr<MeterProvider>&`

**Solução aplicada:** Fixação de versão via `vcpkg.json` override:
```json
"overrides": [
  {
    "name": "opentelemetry-cpp",
    "version": "1.2.0"
  }
]
```

**Implicações:**
- ✅ Código compila sem modificações
- ✅ Testado e estável (usado em produção)
- ⚠️ Usa versão de 2023 (perde melhorias recentes)
- 🔮 Futuro: Migrar para v1.20+ requer refatoração

---

## 🚀 Como Habilitar Métricas

### Passo 1: Recompilar com Flag Habilitada

```bash
cd /opt/canary/build

# Reconfigurar CMake com FEATURE_METRICS=ON
cmake -DFEATURE_METRICS=ON ..

# Compilar (use todos os cores disponíveis)
make -j$(nproc)
```

**Importante:** A dependência OpenTelemetry v1.2.0 será instalada automaticamente pelo vcpkg durante o build.

### Passo 2: Configurar `config.lua`

Edite seu `config.lua` e adicione/modifique:

```lua
-- Habilitar exportador Prometheus (recomendado para produção)
metricsEnablePrometheus = true
metricsPrometheusAddress = "0.0.0.0:9464"

-- Opcional: Exportador OStream para debug (NÃO usar em produção)
metricsEnableOstream = false
metricsOstreamInterval = 1000  -- Intervalo em ms
```

### Passo 3: Iniciar o Servidor

```bash
cd /opt/canary
./canary
```

Verifique nos logs:
```
Starting Prometheus exporter at http://0.0.0.0:9464/metrics
```

### Passo 4: Validar Endpoint de Métricas

```bash
curl http://localhost:9464/metrics
```

**Saída esperada:**
```
# HELP method_latency Latency
# TYPE method_latency histogram
method_latency_bucket{method="placeCreature",le="1.0"} 0
method_latency_bucket{method="placeCreature",le="10.0"} 5
...

# HELP lua_latency Latency
# TYPE lua_latency histogram
lua_latency_bucket{scope="onUse",le="100.0"} 123
...
```

---

## 📈 Como Habilitar Stack Prometheus + Grafana

### Opção 1: Usando Docker Compose (Recomendado)

O projeto já inclui configuração pronta:

```bash
cd /opt/canary/metrics
docker-compose up -d
```

**Serviços iniciados:**
- **Prometheus:** http://localhost:9090
- **Grafana:** http://localhost:4444
  - Usuário: `admin`
  - Senha: `admin` (será solicitada alteração no primeiro login)

### Opção 2: Instalação Manual

#### Instalar Prometheus

```bash
# Download Prometheus
wget https://github.com/prometheus/prometheus/releases/download/v2.45.0/prometheus-2.45.0.linux-amd64.tar.gz
tar xvfz prometheus-*.tar.gz
cd prometheus-*

# Configurar scraping do Canary
cat > prometheus.yml <<EOF
global:
  scrape_interval: 15s

scrape_configs:
  - job_name: 'canary'
    static_configs:
      - targets: ['localhost:9464']
EOF

# Iniciar Prometheus
./prometheus --config.file=prometheus.yml
```

**Prometheus UI:** http://localhost:9090

#### Instalar Grafana

```bash
# Ubuntu/Debian
sudo apt-get install -y adduser libfontconfig1
wget https://dl.grafana.com/oss/release/grafana_10.0.0_amd64.deb
sudo dpkg -i grafana_10.0.0_amd64.deb
sudo systemctl start grafana-server
sudo systemctl enable grafana-server
```

**Grafana UI:** http://localhost:3000

**Configurar Data Source:**
1. Login (admin/admin)
2. Configuration → Data Sources → Add data source
3. Selecionar "Prometheus"
4. URL: `http://localhost:9090`
5. Save & Test

---

## 📊 Métricas Disponíveis

### Histogramas de Latência

| Métrica | Descrição | Labels |
|---------|-----------|--------|
| `method_latency` | Latência de métodos C++ | `method` |
| `lua_latency` | Latência de funções Lua | `scope` |
| `query_latency` | Latência de queries SQL | `truncated_query` |
| `task_latency` | Latência de tasks do Dispatcher | `task` |
| `lock_latency` | Contenção de locks | `scope` |

### Contadores

Exemplos de contadores customizados no código:
- `monster_killed` - Monstros mortos (labels: `monster_name`, `player_name`)
- `experience_gained` - Experiência ganha
- `gold_gained` - Gold obtido
- `blessing_purchased` - Bênçãos compradas

### UpDown Counters

- `players_online` - Número de jogadores online em tempo real

---

## 🔍 Exemplos de Queries (PromQL)

### Latência P99 de Métodos C++
```promql
histogram_quantile(0.99, 
  rate(method_latency_bucket[5m])
)
```

### Top 10 Métodos Mais Lentos
```promql
topk(10, 
  histogram_quantile(0.99, 
    rate(method_latency_bucket[5m])
  )
) by (method)
```

### Exp Ganha por Hora (por jogador)
```promql
rate(experience_gained_total{player_name="PlayerName"}[1h]) * 3600
```

### Gold Ganho por Hora (total do servidor)
```promql
rate(gold_gained_total[1h]) * 3600
```

### Monstros Mortos por Hora
```promql
rate(monster_killed_total[1h]) * 3600
```

### Taxa de Queries SQL por Segundo
```promql
rate(query_latency_count[1m])
```

---

## 🎨 Dashboards Grafana

### Importar Dashboard de Exemplo

O projeto inclui um dashboard demonstrativo real de produção:
- **URL:** https://snapshots.raintank.io/dashboard/snapshot/bpiq45inK3I2Xixa2d7oNHWekdiDE6zr

**Para importar:**
1. Grafana → Dashboards → Import
2. Cole o ID do snapshot ou JSON
3. Selecione o Data Source (Prometheus)
4. Import

### Criar Dashboard Customizado

**Painel básico de monitoramento:**

1. **Server Overview**
   - Players Online (gauge)
   - TPS médio (gauge)
   - Queries/s (graph)

2. **Performance**
   - Top 10 métodos lentos (bar chart)
   - Latência SQL P50/P95/P99 (graph)
   - Latência Lua P50/P95/P99 (graph)

3. **Gameplay Analytics**
   - Exp/h por jogador (table)
   - Gold/h por jogador (table)
   - Monsters mortos/h (pie chart)

---

## 🔧 Troubleshooting

### Problema: Métricas não aparecem no Prometheus

**Verificar:**
```bash
# 1. Servidor está expondo métricas?
curl http://localhost:9464/metrics

# 2. Prometheus está configurado corretamente?
cat metrics/prometheus/prometheus.yml

# 3. Prometheus está alcançando o target?
# Acesse: http://localhost:9090/targets
```

### Problema: Grafana não conecta no Prometheus

**Solução:**
- Se Prometheus e Grafana estão em Docker: use `http://prometheus:9090`
- Se Grafana em Docker e Prometheus no host: use `http://host.docker.internal:9090`
- Se ambos no host: use `http://localhost:9090`

### Problema: Métricas aparecem, mas sem dados

**Causas comuns:**
1. Servidor acabou de iniciar (aguardar atividade)
2. Range de tempo no Grafana muito amplo (usar "Last 5 minutes")
3. Nenhum jogador conectado (métricas de gameplay estarão vazias)

### Problema: Impacto de performance

**Recomendações:**
- ✅ Usar apenas Prometheus (pull-based)
- ❌ NUNCA usar OStream em produção
- ✅ Scrape interval: 15-30s (não menos)
- ✅ Retention do Prometheus: 15 dias (ajustar conforme disco)

---

## 📚 Referências

### Documentação do Projeto
- `metrics/README.md` - Guia original da feature
- `docs/metrics-investigation.md` - Investigação técnica completa

### Documentação Externa
- **OpenTelemetry:** https://opentelemetry.io/docs/
- **Prometheus:** https://prometheus.io/docs/
- **Grafana:** https://grafana.com/docs/grafana/latest/
- **PromQL:** https://prometheus.io/docs/prometheus/latest/querying/basics/

### Links Úteis
- Dashboard de exemplo (produção): https://snapshots.raintank.io/dashboard/snapshot/bpiq45inK3I2Xixa2d7oNHWekdiDE6zr
- PR original (#1966): https://github.com/opentibiabr/canary/pull/1966

---

## ⚠️ Notas Importantes

1. **Performance:** Métricas têm overhead mínimo (~1-2% de CPU), mas OStream pode ser significativo.

2. **Disco:** Prometheus armazena séries temporais. Planeje ~1GB/dia para servidor médio.

3. **Segurança:** Endpoint `/metrics` não tem autenticação. Recomendações:
   - Usar firewall para restringir acesso
   - Não expor porta 9464 publicamente
   - Considerar reverse proxy com auth

4. **Versionamento:** Esta build usa OpenTelemetry v1.2.0 (fixada). Para usar versões mais recentes, será necessário refatorar o código.

5. **Produção:** Testado e usado em servidores reais. Dashboards provam estabilidade.

---

**Última atualização:** 2025-11-16  
**Versão do Canary:** feature/metrics (fork)  
**OpenTelemetry:** v1.2.0 (fixada)
