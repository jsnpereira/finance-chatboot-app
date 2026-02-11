package com.finance.chatboot.enums;

import lombok.Getter;
import lombok.RequiredArgsConstructor;
import lombok.ToString;

import javax.management.ConstructorParameters;


@RequiredArgsConstructor
@ToString
public enum Rabbit {
    QUEUE("chatboot.queue"),
    EXCHANGE("chatboot.exchange"),
    ROUTING_KEY("chatboot.routingkey");

    private final String value;
}
