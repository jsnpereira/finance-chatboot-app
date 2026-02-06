package com.finance.chatboot.model.telegram;

import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.Data;

@Data
public class TelegramCallbackQuery {

    @JsonProperty("id")
    private String id;

    @JsonProperty("from")
    private TelegramUser from;

    @JsonProperty("message")
    private TelegramMessage message;

    @JsonProperty("data")
    private String data;
}

