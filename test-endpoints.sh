#!/bin/bash

# Script para testar os endpoints da aplicação

BASE_URL="http://localhost:9090"

echo "🔍 Testando endpoints do Finance Chatbot..."
echo ""

# Test Health Check
echo "1️⃣ Testando /api/health"
curl -s "${BASE_URL}/api/health" | jq . || curl -s "${BASE_URL}/api/health"
echo -e "\n"

# Test Hello
echo "2️⃣ Testando /api/hello"
curl -s "${BASE_URL}/api/hello" | jq . || curl -s "${BASE_URL}/api/hello"
echo -e "\n"

# Test Actuator Health
echo "3️⃣ Testando /actuator/health"
curl -s "${BASE_URL}/actuator/health" | jq . || curl -s "${BASE_URL}/actuator/health"
echo -e "\n"

# Test Actuator Info
echo "4️⃣ Testando /actuator/info"
curl -s "${BASE_URL}/actuator/info" | jq . || curl -s "${BASE_URL}/actuator/info"
echo -e "\n"

# Test Telegram Webhook Health
echo "5️⃣ Testando /webhook/telegram/health"
curl -s "${BASE_URL}/webhook/telegram/health"
echo -e "\n"

# Test Telegram Webhook (simulando mensagem)
echo "6️⃣ Testando /webhook/telegram (POST - simulação de mensagem)"
curl -s -X POST "${BASE_URL}/webhook/telegram" \
  -H "Content-Type: application/json" \
  -d '{
    "update_id": 123456789,
    "message": {
      "message_id": 1,
      "from": {
        "id": 123456,
        "is_bot": false,
        "first_name": "Test",
        "username": "testuser"
      },
      "chat": {
        "id": 123456,
        "type": "private",
        "username": "testuser",
        "first_name": "Test"
      },
      "date": 1234567890,
      "text": "/start"
    }
  }' | jq . || curl -s -X POST "${BASE_URL}/webhook/telegram" \
  -H "Content-Type: application/json" \
  -d '{
    "update_id": 123456789,
    "message": {
      "message_id": 1,
      "from": {
        "id": 123456,
        "is_bot": false,
        "first_name": "Test",
        "username": "testuser"
      },
      "chat": {
        "id": 123456,
        "type": "private",
        "username": "testuser",
        "first_name": "Test"
      },
      "date": 1234567890,
      "text": "/start"
    }
  }'
echo -e "\n"

echo "✅ Testes concluídos!"

