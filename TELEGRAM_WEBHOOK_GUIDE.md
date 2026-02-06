# Configuração Telegram Webhook

## Introdução

O bot Telegram precisa de 3 coisas para funcionar:

1. **Aplicação Spring Boot rodando** (porta 8081)
2. **Ngrok expondo a aplicação** (HTTPS público)
3. **Webhook configurado no Telegram** (apontando para ngrok)

---

## Passo 1: Iniciar Aplicação

```bash
cd /Users/jeisonpereira/financeWorkspace/finance-chatboot-app
./mvnw spring-boot:run
```

Aguarde ver: `Started ChatbootApplication`

---

## Passo 2: Expor com Ngrok

Em outro terminal:

```bash
ngrok http 8081
```

Copie a URL HTTPS (ex: `https://abc123.ngrok-free.dev`)

---

## Passo 3: Configurar Webhook

```bash
export TOKEN="8478421482:AAHenol1gaOPMYwJUD4lxfVKT4fu5XHoUIk"
export NGROK_URL="https://sua-url.ngrok-free.dev"

curl "https://api.telegram.org/bot${TOKEN}/setWebhook?url=${NGROK_URL}/webhook/telegram"
```

Resposta esperada: `{"ok":true,"result":true}`

---

## Passo 4: Testar

### Verificar configuração:

```bash
curl "https://api.telegram.org/bot${TOKEN}/getWebhookInfo"
```

Deve mostrar sua URL ngrok.

### Enviar mensagem:

1. Abra Telegram
2. Procure: `@finance_jsnpereira_bot`
3. Envie qualquer mensagem

### Ver logs:

Nos logs da aplicação Spring, deve aparecer:

```
=== WEBHOOK RECEIVED ===
Message from: Seu Nome
Chat ID: 123456789
Text: sua mensagem
=== WEBHOOK PROCESSED SUCCESSFULLY ===
```

---

## Diagnóstico Rápido

Execute o script:

```bash
./diagnostico-webhook.sh
```

Ele verifica:
- ✅ Webhook configurado no Telegram
- ✅ Aplicação rodando
- ✅ Endpoint respondendo

---

## Problemas Comuns

**Mensagem não chega:**
- Aplicação está rodando? → `./mvnw spring-boot:run`
- Ngrok está ativo? → `ngrok http 8081`
- Webhook configurado? → Execute Passo 3

**Ngrok URL mudou:**
- Toda vez que reinicia ngrok, a URL muda
- Reexecute o Passo 3 com a nova URL

**Porta ocupada:**
```bash
lsof -ti :8081 | xargs kill -9
```

---

## Resumo

```
Terminal 1: ./mvnw spring-boot:run
Terminal 2: ngrok http 8081
Terminal 3: curl setWebhook (com URL do ngrok)
Telegram:   Enviar mensagem → @finance_jsnpereira_bot
```

