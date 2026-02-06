package com.finance.chatboot.model.telegram;

import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.Data;

@Data
public class TelegramMessage {

    @JsonProperty("message_id")
    private Long messageId;

    @JsonProperty("from")
    private TelegramUser from;

    @JsonProperty("chat")
    private TelegramChat chat;

    @JsonProperty("date")
    private Long date;

    @JsonProperty("text")
    private String text;
}

