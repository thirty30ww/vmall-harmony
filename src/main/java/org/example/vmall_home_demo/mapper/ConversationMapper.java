package org.example.vmall_home_demo.mapper;

import org.apache.ibatis.annotations.Delete;
import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Options;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;
import org.apache.ibatis.annotations.Update;
import org.example.vmall_home_demo.entity.Conversation;

import java.util.List;

@Mapper
public interface ConversationMapper {

    @Select("""
            SELECT id, user_id AS userId, title, status,
                   created_at AS createdAt, updated_at AS updatedAt
            FROM vmall_conversations
            WHERE id = #{id}
            """)
    Conversation findById(@Param("id") Long id);

    @Select("""
            SELECT id, user_id AS userId, title, status,
                   created_at AS createdAt, updated_at AS updatedAt
            FROM vmall_conversations
            WHERE user_id = #{userId}
            ORDER BY updated_at DESC
            """)
    List<Conversation> findByUserId(@Param("userId") Long userId);

    @Insert("""
            INSERT INTO vmall_conversations (user_id, title, status, created_at, updated_at)
            VALUES (#{userId}, #{title}, 1, NOW(), NOW())
            """)
    @Options(useGeneratedKeys = true, keyProperty = "id")
    int insert(Conversation conversation);

    @Update("""
            UPDATE vmall_conversations
            SET title = #{title}, updated_at = NOW()
            WHERE id = #{id}
            """)
    int updateTitle(@Param("id") Long id, @Param("title") String title);

    @Update("""
            UPDATE vmall_conversations
            SET updated_at = NOW()
            WHERE id = #{id}
            """)
    int touch(@Param("id") Long id);

    @Delete("DELETE FROM vmall_conversations WHERE id = #{id}")
    int deleteById(@Param("id") Long id);
}
