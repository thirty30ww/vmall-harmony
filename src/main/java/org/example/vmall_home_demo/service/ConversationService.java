package org.example.vmall_home_demo.service;

import org.example.vmall_home_demo.dto.ChatMessage;
import org.example.vmall_home_demo.entity.Conversation;
import org.example.vmall_home_demo.entity.ConversationMessage;
import org.example.vmall_home_demo.mapper.ConversationMapper;
import org.example.vmall_home_demo.mapper.ConversationMessageMapper;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.List;

@Service
public class ConversationService {

    private final ConversationMapper conversationMapper;
    private final ConversationMessageMapper messageMapper;

    public ConversationService(ConversationMapper conversationMapper,
                               ConversationMessageMapper messageMapper) {
        this.conversationMapper = conversationMapper;
        this.messageMapper = messageMapper;
    }

    public record ConversationResult(Long conversationId, boolean isNew) {}

    @Transactional
    public ConversationResult ensureConversation(Long conversationId, Long userId, ChatMessage firstMessage) {
        if (conversationId != null) {
            Conversation existing = conversationMapper.findById(conversationId);
            if (existing != null) {
                if (existing.getUserId() != null && !existing.getUserId().equals(userId)) {
                    throw new IllegalStateException("Conversation does not belong to this user");
                }
                conversationMapper.touch(conversationId);
                return new ConversationResult(conversationId, false);
            }
        }
        Conversation conversation = new Conversation();
        conversation.setUserId(userId);
        String title = firstMessage.getContent();
        if (title.length() > 50) {
            title = title.substring(0, 50) + "...";
        }
        conversation.setTitle(title);
        conversation.setStatus(1);
        conversationMapper.insert(conversation);
        return new ConversationResult(conversation.getId(), true);
    }

    @Transactional
    public void addMessage(Long conversationId, ChatMessage chatMessage) {
        ConversationMessage msg = new ConversationMessage();
        msg.setConversationId(conversationId);
        msg.setRole(chatMessage.getRole());
        msg.setContent(chatMessage.getContent());
        msg.setMetadata(chatMessage.getMetadata());
        messageMapper.insert(msg);
        conversationMapper.touch(conversationId);
    }

    public List<Conversation> listConversations(Long userId) {
        if (userId == null) return List.of();
        return conversationMapper.findByUserId(userId);
    }

    public List<ChatMessage> getMessages(Long conversationId) {
        List<ConversationMessage> msgs = messageMapper.findByConversationId(conversationId);
        List<ChatMessage> result = new ArrayList<>();
        for (ConversationMessage msg : msgs) {
            ChatMessage dto = new ChatMessage(msg.getRole(), msg.getContent());
            dto.setMetadata(msg.getMetadata());
            result.add(dto);
        }
        return result;
    }

    @Transactional
    public void deleteConversation(Long conversationId, Long userId) {
        Conversation conv = conversationMapper.findById(conversationId);
        if (conv == null) return;
        if (conv.getUserId() != null && !conv.getUserId().equals(userId)) {
            throw new IllegalStateException("Conversation does not belong to this user");
        }
        messageMapper.deleteByConversationId(conversationId);
        conversationMapper.deleteById(conversationId);
    }
}
