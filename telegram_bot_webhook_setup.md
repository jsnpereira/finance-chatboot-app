# Telegram Bot – Webhook e Variáveis de Ambiente

Este documento explica **como configurar um bot Telegram com webhook** para o projeto (Spring Boot), usando variáveis de ambiente e uma URL pública.

---

## 📌 Visão geral

No Telegram, **o webhook não é fornecido pela plataforma**.  
Você **cria o webhook** apontando o Telegram para o **seu backend**.

Fluxo:

```
Telegram → POST → https://SEU_BACKEND/webhook/telegram
```

---

## 🔐 Variáveis de ambiente usadas no projeto

```env
TELEGRAM_BOT_TOKEN=
TELEGRAM_BOT_USERNAME=
TELEGRAM_WEBHOOK_URL=
```

### 1️⃣ `TELEGRAM_BOT_TOKEN`

- Fornecido pelo **@BotFather** ao criar o bot
- Exemplo:
  ```
  123456789:AAFxXxXxXxXxXx
  ```
- Usado pelo backend para **enviar mensagens** ao Telegram

---

### 2️⃣ `TELEGRAM_BOT_USERNAME`

- Username público do bot
- Exemplo:
  ```
  @jeison_ai_bot
  ```
- **Não é usado pela API**, apenas para identificação e documentação

---

### 3️⃣ `TELEGRAM_WEBHOOK_URL`

- É a **URL pública do seu backend**
- Deve apontar para o endpoint do webhook Telegram

Exemplo:
```text
https://abc123.ngrok.io/webhook/telegram
```

> ⚠️ O Telegram envia mensagens para essa URL via **HTTP POST**

---

## 🌐 Como obter a URL pública (Webhook)

### Opção 1 — Ngrok (ambiente local – recomendado para testes)

1. Inicie o Spring Boot:
   ```bash
   ./mvnw spring-boot:run
   ```

2. Em outro terminal, execute:
   ```bash
   ngrok http 8080
   ```

3. O ngrok irá gerar algo como:
   ```
   https://abc123.ngrok.io
   ```

4. O webhook final será:
   ```
   https://abc123.ngrok.io/webhook/telegram
   ```

---

### Opção 2 — Deploy em cloud (produção)

Exemplo:
```text
https://chatbot.up.railway.app/webhook/telegram
```

---

## 🔗 Registrando o webhook no Telegram

Depois de definir o `TELEGRAM_WEBHOOK_URL`, registre o webhook:

```text
https://api.telegram.org/bot<TELEGRAM_BOT_TOKEN>/setWebhook?url=<TELEGRAM_WEBHOOK_URL>
```

Exemplo:
```text
https://api.telegram.org/bot123456:ABCDEF/setWebhook?url=https://abc123.ngrok.io/webhook/telegram
```

Resposta esperada:
```json
{
  "ok": true,
  "result": true
}
```

---

## 🧪 Endpoint esperado no backend

O projeto deve expor o endpoint:

```http
POST /webhook/telegram
```

Exemplo de controller:

```java
@RestController
@RequestMapping("/webhook/telegram")
public class TelegramWebhookController {

    @PostMapping
    public void receive(@RequestBody Map<String, Object> payload) {
        // processar mensagem recebida
    }
}
```

---
## Onde você consegue esse link para testar localmente?
🧪 Opção 1 — NGROK (local, mais comum)

Perfeito pra testes.

1. Instale o ngrok
   ```
   https://ngrok.com/
   ```

2. Rode seu Spring Boot:
   ```
   ./mvnw spring-boot:run
   ```
3. Em outro terminal:

   ```
   ngrok http 8080
   ```

    Vai aparecer algo tipo:
    ```
   https://abc123.ngrok.io
   ```
Esse é seu domínio público para o Telegram enviar mensagens.

Então:
Você configura o webkook do Telegram seguinte:

TELEGRAM_WEBHOOK_URL=https://abc123.ngrok.io/webhook/telegram

---