package org.example.vmall_home_demo.mapper;

import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Options;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;
import org.apache.ibatis.annotations.Update;
import org.example.vmall_home_demo.entity.User;

@Mapper
public interface UserMapper {
    @Select("""
            SELECT id,
                   phone,
                   username,
                   password_hash AS passwordHash,
                   password_salt AS passwordSalt,
                   status,
                   created_at AS createdAt,
                   updated_at AS updatedAt,
                   last_login_at AS lastLoginAt
            FROM vmall_users
            WHERE phone = #{phone}
            LIMIT 1
            """)
    User findByPhone(@Param("phone") String phone);

    @Insert("""
            INSERT INTO vmall_users (phone, username, password_hash, password_salt, status, created_at, updated_at)
            VALUES (#{phone}, #{username}, #{passwordHash}, #{passwordSalt}, 1, NOW(), NOW())
            """)
    @Options(useGeneratedKeys = true, keyProperty = "id")
    int insert(User user);

    @Update("""
            UPDATE vmall_users
            SET last_login_at = NOW(), updated_at = NOW()
            WHERE id = #{id}
            """)
    int updateLastLoginAt(@Param("id") Long id);
}