package org.example.vmall_home_demo.mapper;

import org.apache.ibatis.annotations.Delete;
import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Options;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;
import org.example.vmall_home_demo.entity.ConversationMessage;

import java.util.List;

@Mapper
public interface ConversationMessageMapper {

    @Select("""
            SELECT id, conversation_id AS conversationId, role, content, metadata,
                   created_at AS createdAt
            FROM vmall_conversation_messages
            WHERE conversation_id = #{conversationId}
            ORDER BY id ASC
            """)
    List<ConversationMessage> findByConversationId(@Param("conversationId") Long conversationId);

    @Insert("""
            INSERT INTO vmall_conversation_messages (conversation_id, role, content, metadata, created_at)
            VALUES (#{conversationId}, #{role}, #{content}, #{metadata}, NOW())
            """)
    @Options(useGeneratedKeys = true, keyProperty = "id")
    int insert(ConversationMessage message);

    @Select("""
            SELECT COUNT(*) FROM vmall_conversation_messages
            WHERE conversation_id = #{conversationId}
            """)
    int countByConversationId(@Param("conversationId") Long conversationId);

    @Delete("""
            DELETE FROM vmall_conversation_messages
            WHERE conversation_id = #{conversationId}
            """)
    void deleteByConversationId(@Param("conversationId") Long conversationId);
}
