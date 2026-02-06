package com.finance.chatboot.service.telegram;

import com.finance.chatboot.model.telegram.TelegramUpdate;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

@Slf4j
@Service
public class TelegramService {

    public void processUpdate(TelegramUpdate update) {
        log.info("Processing update ID: {}", update.getUpdateId());

        if (update.getMessage() != null) {
            processMessage(update);
        } else if (update.getCallbackQuery() != null) {
            processCallbackQuery(update);
        } else {
            log.warn("Unknown update type received");
        }
    }

    private void processMessage(TelegramUpdate update) {
        var message = update.getMessage();
        var chatId = message.getChat().getId();
        var text = message.getText();
        var userName = message.getFrom().getFirstName();

        log.info("Received message from {}: {}", userName, text);

        // TODO: Implementar lógica de resposta
        // Por enquanto apenas logando
    }

    private void processCallbackQuery(TelegramUpdate update) {
        var callback = update.getCallbackQuery();
        var data = callback.getData();

        log.info("Received callback query with data: {}", data);

        // TODO: Implementar lógica de callback
    }
}

