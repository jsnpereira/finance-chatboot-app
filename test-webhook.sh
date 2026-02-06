#!/bin/bash

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${YELLOW}=== Telegram Webhook Test Suite ===${NC}\n"

# Configuration
TELEGRAM_BOT_TOKEN="${TELEGRAM_BOT_TOKEN:-8478421482:AAHenol1gaOPMYwJUD4lxfVKT4fu5XHoUIk}"
NGROK_URL="${NGROK_URL:-}"
LOCAL_URL="${LOCAL_URL:-http://localhost:8081}"
CHAT_ID="${CHAT_ID:-}"

# Step 1: Check if ngrok URL is provided
if [ -z "$NGROK_URL" ]; then
    echo -e "${YELLOW}NGROK_URL not set. Use local URL for testing:${NC}"
    echo "export NGROK_URL='https://your-ngrok-url.ngrok.io'"
    echo -e "\n${YELLOW}Testing locally at: $LOCAL_URL${NC}\n"
fi

# Step 2: Test webhook health
echo -e "${YELLOW}Step 1: Testing webhook health...${NC}"
HEALTH_RESPONSE=$(curl -s -o /dev/null -w "%{http_code}" "$LOCAL_URL/webhook/telegram/health")

if [ "$HEALTH_RESPONSE" -eq 200 ]; then
    echo -e "${GREEN}✓ Health check passed (HTTP 200)${NC}\n"
else
    echo -e "${RED}✗ Health check failed (HTTP $HEALTH_RESPONSE)${NC}\n"
    exit 1
fi

# Step 3: Test webhook with sample message
echo -e "${YELLOW}Step 2: Sending test message to webhook...${NC}"

WEBHOOK_URL="$LOCAL_URL/webhook/telegram"

# Create test payload
TEST_PAYLOAD='{
  "update_id": 123456789,
  "message": {
    "message_id": 1,
    "from": {
      "id": 987654321,
      "is_bot": false,
      "first_name": "Test",
      "last_name": "User",
      "username": "testuser"
    },
    "chat": {
      "id": 987654321,
      "first_name": "Test",
      "last_name": "User",
      "username": "testuser",
      "type": "private"
    },
    "date": 1609459200,
    "text": "Olá, isto é um teste!"
  }
}'

echo "Payload being sent:"
echo "$TEST_PAYLOAD" | jq '.' 2>/dev/null || echo "$TEST_PAYLOAD"
echo ""

WEBHOOK_RESPONSE=$(curl -s -X POST \
  "$WEBHOOK_URL" \
  -H "Content-Type: application/json" \
  -d "$TEST_PAYLOAD" \
  -w "\n%{http_code}")

# Extract response code (last line)
HTTP_CODE=$(echo "$WEBHOOK_RESPONSE" | tail -n1)
RESPONSE_BODY=$(echo "$WEBHOOK_RESPONSE" | sed '$d')

if [ "$HTTP_CODE" -eq 200 ]; then
    echo -e "${GREEN}✓ Webhook received message (HTTP 200)${NC}\n"
else
    echo -e "${RED}✗ Webhook failed (HTTP $HTTP_CODE)${NC}\n"
    echo "Response: $RESPONSE_BODY\n"
fi

# Step 4: Instructions for setting up webhook with Telegram
echo -e "${YELLOW}Step 3: Setup Telegram Webhook${NC}"
echo -e "To register webhook with Telegram, run:\n"

if [ -z "$NGROK_URL" ]; then
    echo -e "${RED}Note: ngrok URL is required to set webhook with Telegram${NC}"
    echo "1. Start ngrok: ngrok http 8081"
    echo "2. Copy the https URL and run:"
else
    WEBHOOK_SETUP_URL="$NGROK_URL/webhook/telegram"
    echo "export TELEGRAM_BOT_TOKEN='$TELEGRAM_BOT_TOKEN'"
    echo "export WEBHOOK_URL='$WEBHOOK_SETUP_URL'"
    echo ""
    echo "curl -X POST \"https://api.telegram.org/bot\${TELEGRAM_BOT_TOKEN}/setWebhook\" \\"
    echo "  -d \"url=\${WEBHOOK_URL}\""
    echo ""
    echo "3. Verify webhook is set:"
    echo "curl \"https://api.telegram.org/bot\${TELEGRAM_BOT_TOKEN}/getWebhookInfo\" | jq ."
fi

echo ""
echo -e "${YELLOW}Step 4: Send actual message${NC}"
echo "Open Telegram and send a message to: @$TELEGRAM_BOT_USERNAME"
echo "Watch the logs for: '=== WEBHOOK RECEIVED ===' message"
echo ""
echo -e "${YELLOW}Step 5: Check logs${NC}"
echo "Run: tail -f <your-app-logs> | grep 'WEBHOOK'"

