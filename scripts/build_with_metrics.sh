#!/usr/bin/env bash
set -e

# Script para compilar Canary com métricas habilitadas
# Versão: 1.0
# Requer: vcpkg, cmake, make

echo "================================================"
echo "  Canary - Build com Métricas (OpenTelemetry)"
echo "================================================"
echo ""

# Verificar se VCPKG_ROOT está definido
if [ -z "$VCPKG_ROOT" ]; then
    echo "❌ ERRO: variável VCPKG_ROOT não está definida"
    echo "   Export: export VCPKG_ROOT=/caminho/para/vcpkg"
    exit 1
fi

# Verificar se estamos no diretório correto
if [ ! -f "CMakeLists.txt" ] || [ ! -f "vcpkg.json" ]; then
    echo "❌ ERRO: Execute este script na raiz do projeto Canary"
    exit 1
fi

echo "[1/4] Limpando build anterior..."
rm -rf build-metrics

echo ""
echo "[2/4] Configurando CMake com FEATURE_METRICS=ON..."
cmake -DCMAKE_TOOLCHAIN_FILE=$VCPKG_ROOT/scripts/buildsystems/vcpkg.cmake \
      -DFEATURE_METRICS=ON \
      -S . \
      -B build-metrics

if [ $? -ne 0 ]; then
    echo "❌ Falha na configuração do CMake"
    exit 1
fi

echo ""
echo "[3/4] Compilando (usando $(nproc) threads)..."
cmake --build build-metrics -j$(nproc)

if [ $? -ne 0 ]; then
    echo "❌ Falha na compilação"
    exit 1
fi

echo ""
echo "[4/4] Verificando binário..."
if [ -f "canary" ]; then
    echo "✅ Binário criado: canary"
    ls -lh canary
elif [ -f "build-metrics/canary" ]; then
    echo "✅ Binário criado: build-metrics/canary"
    ls -lh build-metrics/canary
else
    echo "❌ Binário não encontrado"
    exit 1
fi

echo ""
echo "================================================"
echo "  ✅ Build com métricas concluído com sucesso!"
echo "================================================"
echo ""
echo "Próximos passos:"
echo "  1. Configure config.lua:"
echo "     metricsEnablePrometheus = true"
echo "     metricsPrometheusAddress = \"0.0.0.0:9464\""
echo ""
echo "  2. Inicie o servidor:"
echo "     ./canary"
echo ""
echo "  3. Teste o endpoint:"
echo "     curl http://localhost:9464/metrics"
echo ""
echo "  4. Inicie monitoring stack:"
echo "     ./scripts/start_monitoring.sh"
echo ""
