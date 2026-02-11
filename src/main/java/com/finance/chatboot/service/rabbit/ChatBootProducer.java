package com.finance.chatboot.service.rabbit;

import com.finance.chatboot.enums.Rabbit;
import com.finance.chatboot.model.telegram.TelegramUpdate;
import org.springframework.amqp.rabbit.core.RabbitTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class ChatBootProducer {

    private final RabbitTemplate rabbitTemplate;

    @Autowired
    public ChatBootProducer(RabbitTemplate rabbitTemplate) {
        this.rabbitTemplate = rabbitTemplate;
    }

    public void sendMessage(TelegramUpdate telegramUpdate){
        rabbitTemplate.convertAndSend(
                Rabbit.EXCHANGE.toString(),
                Rabbit.ROUTING_KEY.toString(),
                telegramUpdate);
    }

}
