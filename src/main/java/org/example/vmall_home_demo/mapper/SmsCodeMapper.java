package org.example.vmall_home_demo.mapper;

import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;
import org.apache.ibatis.annotations.Update;
import org.example.vmall_home_demo.entity.SmsCode;

@Mapper
public interface SmsCodeMapper {
    @Insert("""
            INSERT INTO vmall_sms_codes (phone, code, used, expires_at, created_at)
            VALUES (#{phone}, #{code}, 0, #{expiresAt}, NOW())
            """)
    int insert(SmsCode smsCode);

    @Select("""
            SELECT id,
                   phone,
                   code,
                   used,
                   expires_at AS expiresAt,
                   created_at AS createdAt
            FROM vmall_sms_codes
            WHERE phone = #{phone}
              AND code = #{code}
              AND used = 0
              AND expires_at > NOW()
            ORDER BY id DESC
            LIMIT 1
            """)
    SmsCode findValidCode(@Param("phone") String phone, @Param("code") String code);

    @Update("""
            UPDATE vmall_sms_codes
            SET used = 1
            WHERE id = #{id}
            """)
    int markUsed(@Param("id") Long id);
}