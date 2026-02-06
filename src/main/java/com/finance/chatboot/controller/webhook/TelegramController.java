package com.finance.chatboot.controller.webhook;

import com.finance.chatboot.model.telegram.TelegramUpdate;
import com.finance.chatboot.service.telegram.TelegramService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@Slf4j
@RestController
@RequestMapping("/webhook/telegram")
@RequiredArgsConstructor
public class TelegramController {

    private final TelegramService telegramService;

    @PostMapping
    public ResponseEntity<Void> receiveUpdate(@RequestBody TelegramUpdate update) {
        try {
            log.info("=== WEBHOOK RECEIVED ===");
            log.info("Update ID: {}", update.getUpdateId());

            if (update.getMessage() != null) {
                log.info("Message from: {}", update.getMessage().getFrom().getFirstName());
                log.info("Chat ID: {}", update.getMessage().getChat().getId());
                log.info("Text: {}", update.getMessage().getText());
            } else if (update.getCallbackQuery() != null) {
                log.info("Callback Query from: {}", update.getCallbackQuery().getFrom().getFirstName());
            }

            log.debug("Full update: {}", update);
            telegramService.processUpdate(update);
            log.info("=== WEBHOOK PROCESSED SUCCESSFULLY ===");
            return ResponseEntity.ok().build();
        } catch (Exception e) {
            log.error("Error processing Telegram update", e);
            return ResponseEntity.ok().build(); // Always return 200 to Telegram
        }
    }

    @GetMapping("/health")
    public ResponseEntity<String> webhookHealth() {
        log.info("Health check called");
        return ResponseEntity.ok("Telegram webhook is ready!");
    }
}

