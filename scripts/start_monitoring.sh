#!/usr/bin/env bash
set -e

# Script para iniciar stack de monitoramento (Prometheus + Grafana)
# Versão: 1.0
# Requer: docker, docker-compose

echo "================================================"
echo "  Canary - Monitoring Stack"
echo "================================================"
echo ""

# Verificar se estamos no diretório correto
if [ ! -d "metrics" ]; then
    echo "❌ ERRO: Diretório metrics/ não encontrado"
    echo "   Execute este script na raiz do projeto Canary"
    exit 1
fi

# Verificar se docker está disponível
if ! command -v docker &> /dev/null; then
    echo "❌ ERRO: Docker não está instalado"
    echo "   Instale: https://docs.docker.com/engine/install/"
    exit 1
fi

# Verificar se docker-compose está disponível
if ! command -v docker-compose &> /dev/null && ! docker compose version &> /dev/null; then
    echo "❌ ERRO: Docker Compose não está instalado"
    exit 1
fi

echo "[1/2] Iniciando containers..."
cd metrics

# Tentar docker compose (novo) ou docker-compose (antigo)
if docker compose version &> /dev/null; then
    docker compose up -d
else
    docker-compose up -d
fi

if [ $? -ne 0 ]; then
    echo "❌ Falha ao iniciar containers"
    exit 1
fi

cd ..

echo ""
echo "[2/2] Aguardando serviços ficarem prontos..."
sleep 5

echo ""
echo "================================================"
echo "  ✅ Monitoring Stack iniciado com sucesso!"
echo "================================================"
echo ""
echo "📊 Serviços disponíveis:"
echo ""
echo "  • Prometheus"
echo "    URL: http://localhost:9090"
echo "    Targets: http://localhost:9090/targets"
echo ""
echo "  • Grafana"
echo "    URL: http://localhost:4444"
echo "    Login: admin / admin"
echo "    (Senha será solicitada para troca no primeiro acesso)"
echo ""
echo "📈 Próximos passos:"
echo "  1. Configure Data Source no Grafana:"
echo "     - Acesse: Configuration → Data Sources"
echo "     - Add: Prometheus"
echo "     - URL: http://prometheus:9090"
echo "     - Save & Test"
echo ""
echo "  2. Importe dashboard de exemplo:"
echo "     - URL: https://snapshots.raintank.io/dashboard/snapshot/bpiq45inK3I2Xixa2d7oNHWekdiDE6zr"
echo ""
echo "  3. Verifique métricas do Canary:"
echo "     - Certifique-se que o servidor está rodando"
echo "     - Acesse: http://localhost:9090/targets"
echo "     - Status deve estar UP"
echo ""
echo "Para parar os containers:"
echo "  cd metrics && docker compose down"
echo ""
