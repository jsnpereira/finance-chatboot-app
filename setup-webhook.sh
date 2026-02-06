#!/bin/bash

echo "🚀 SETUP AUTOMÁTICO TELEGRAM WEBHOOK"
echo "====================================="
echo ""

TOKEN="8478421482:AAHenol1gaOPMYwJUD4lxfVKT4fu5XHoUIk"
PORT=8081

# Função para limpar processos ao sair
cleanup() {
    echo ""
    echo "🛑 Encerrando processos..."
    if [ ! -z "$NGROK_PID" ]; then
        kill $NGROK_PID 2>/dev/null
    fi
}
trap cleanup EXIT

echo "1️⃣  Verificando se aplicação está rodando na porta ${PORT}..."
if lsof -i :${PORT} >/dev/null 2>&1; then
    echo "✅ Aplicação já está rodando na porta ${PORT}"
else
    echo "⚠️  Aplicação não está rodando. Por favor, inicie em outro terminal:"
    echo "    ./mvnw spring-boot:run"
    echo ""
    read -p "Pressione ENTER quando a aplicação estiver rodando..."
fi

echo ""
echo "2️⃣  Verificando ngrok..."
if ! command -v ngrok &> /dev/null; then
    echo "❌ ngrok não encontrado. Instale com: brew install ngrok/ngrok/ngrok"
    exit 1
fi

echo ""
echo "3️⃣  Iniciando ngrok na porta ${PORT}..."
# Mata qualquer ngrok anterior
pkill -f "ngrok http" 2>/dev/null
sleep 1

# Inicia ngrok em background
ngrok http ${PORT} > /dev/null 2>&1 &
NGROK_PID=$!
echo "✅ ngrok iniciado (PID: ${NGROK_PID})"

# Aguarda ngrok inicializar
echo "⏳ Aguardando ngrok inicializar..."
sleep 3

echo ""
echo "4️⃣  Extraindo URL pública do ngrok..."
NGROK_URL=$(curl -s http://localhost:4040/api/tunnels 2>/dev/null | grep -o 'https://[a-zA-Z0-9.-]*\.ngrok-free\.app' | head -n 1)

if [ -z "$NGROK_URL" ]; then
    # Tenta formato alternativo
    NGROK_URL=$(curl -s http://localhost:4040/api/tunnels 2>/dev/null | grep -o 'https://[a-zA-Z0-9.-]*\.ngrok\.io' | head -n 1)
fi

if [ -z "$NGROK_URL" ]; then
    echo "❌ Erro ao obter URL do ngrok. Verifique se o ngrok está funcionando:"
    echo "   Abra: http://localhost:4040"
    exit 1
fi

echo "✅ URL do ngrok: ${NGROK_URL}"

echo ""
echo "5️⃣  Configurando webhook no Telegram..."
WEBHOOK_URL="${NGROK_URL}/webhook/telegram"

RESPONSE=$(curl -s -X POST "https://api.telegram.org/bot${TOKEN}/setWebhook?url=${WEBHOOK_URL}")
echo "$RESPONSE" | jq .

if echo "$RESPONSE" | jq -e '.ok == true' > /dev/null; then
    echo "✅ Webhook configurado com sucesso!"
else
    echo "❌ Erro ao configurar webhook"
    echo "$RESPONSE" | jq .
    exit 1
fi

echo ""
echo "6️⃣  Verificando webhook configurado:"
curl -s "https://api.telegram.org/bot${TOKEN}/getWebhookInfo" | jq '{url: .result.url, pending_update_count: .result.pending_update_count, last_error_date: .result.last_error_date, last_error_message: .result.last_error_message}'

echo ""
echo "7️⃣  Testando endpoint de health:"
HEALTH_RESPONSE=$(curl -s -w "\nHTTP_STATUS:%{http_code}" "${NGROK_URL}/health" 2>/dev/null)
HTTP_STATUS=$(echo "$HEALTH_RESPONSE" | grep "HTTP_STATUS" | cut -d: -f2)

if [ "$HTTP_STATUS" = "200" ]; then
    echo "✅ Endpoint respondendo corretamente"
else
    echo "⚠️  Status HTTP: ${HTTP_STATUS}"
fi

echo ""
echo "====================================="
echo "✅ CONFIGURAÇÃO CONCLUÍDA!"
echo ""
echo "📌 Informações importantes:"
echo "   Webhook URL: ${WEBHOOK_URL}"
echo "   ngrok Dashboard: http://localhost:4040"
echo "   Porta local: ${PORT}"
echo ""
echo "💡 Para atualizar application.yaml com a URL do ngrok:"
echo "   export TELEGRAM_WEBHOOK_URL='${WEBHOOK_URL}'"
echo ""
echo "🛑 Para parar o ngrok:"
echo "   pkill -f 'ngrok http'"
echo ""
echo "⚠️  Mantenha este terminal aberto enquanto usar o webhook!"
echo "   Pressione Ctrl+C para encerrar o ngrok"
echo ""

# Mantém o script rodando
wait $NGROK_PID

