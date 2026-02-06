# Finance Chatbot

Bot Telegram para gerenciamento de finanças pessoais.

## Objetivo

Receber e processar mensagens do Telegram via webhook.

## Tecnologias

- Java 21
- Spring Boot 4.0.2
- Telegram Bot API (Webhook)

## Configuração

### Build e Execução

```bash
./mvnw clean package -DskipTests
java -jar target/chatboot-0.0.1-SNAPSHOT.jar
```

Porta: **8081**

### Variáveis de Ambiente

```bash
export TELEGRAM_BOT_TOKEN="seu_token"
export TELEGRAM_WEBHOOK_URL="https://seu-dominio.com/webhook/telegram"
```

### Configurar Webhook no Telegram

1. Expor servidor localmente:
   ```bash
   ngrok http 8081
   ```

2. Registrar webhook:
   ```bash
   curl -X POST "https://api.telegram.org/bot<TOKEN>/setWebhook?url=<NGROK_URL>/webhook/telegram"
   ```

## Endpoints

- `POST /webhook/telegram` - Recebe mensagens
- `GET /webhook/telegram/health` - Health check

## Teste

```bash
./test-webhook.sh
```

## Estrutura

```
src/main/java/com/finance/chatboot/
├── controller/webhook/TelegramController.java
├── service/telegram/TelegramService.java
└── model/telegram/ (Update, Message, Chat, User)
```

