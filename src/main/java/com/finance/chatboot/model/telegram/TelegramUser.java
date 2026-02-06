package com.finance.chatboot.model.telegram;

import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.Data;

@Data
public class TelegramUser {

    @JsonProperty("id")
    private Long id;

    @JsonProperty("is_bot")
    private Boolean isBot;

    @JsonProperty("first_name")
    private String firstName;

    @JsonProperty("last_name")
    private String lastName;

    @JsonProperty("username")
    private String username;

    @JsonProperty("language_code")
    private String languageCode;
}

