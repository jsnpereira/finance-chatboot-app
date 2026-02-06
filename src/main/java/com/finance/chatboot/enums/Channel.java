package com.finance.chatboot.enums;

import lombok.Getter;
import lombok.RequiredArgsConstructor;

@Getter
@RequiredArgsConstructor
public enum Channel {
    TELEGRAM("Telegram"),
    WHATSAPP("WhatsApp");

    private final String displayName;
}

