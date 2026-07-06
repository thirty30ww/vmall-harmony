package org.example.vmall_home_demo.mapper;

import org.apache.ibatis.annotations.Delete;
import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;
import org.example.vmall_home_demo.entity.CartItem;

import java.util.List;

@Mapper
public interface CartItemMapper {
    @Select("""
            SELECT id,
                   user_id AS userId,
                   product_id AS productId,
                   product_source AS productSource,
                   product_name AS productName,
                   product_image AS productImage,
                   product_price AS productPrice,
                   product_feature AS productFeature,
                   created_at AS createdAt,
                   updated_at AS updatedAt
            FROM vmall_cart_items
            WHERE user_id = #{userId}
            ORDER BY updated_at DESC, id DESC
            """)
    List<CartItem> findByUserId(@Param("userId") Long userId);

    @Insert("""
            INSERT INTO vmall_cart_items (
                user_id, product_id, product_source, product_name, product_image,
                product_price, product_feature, created_at, updated_at
            ) VALUES (
                #{userId}, #{productId}, #{productSource}, #{productName}, #{productImage},
                #{productPrice}, #{productFeature}, NOW(), NOW()
            )
            ON DUPLICATE KEY UPDATE
                product_name = VALUES(product_name),
                product_image = VALUES(product_image),
                product_price = VALUES(product_price),
                product_feature = VALUES(product_feature),
                updated_at = NOW()
            """)
    int insertItem(CartItem item);

    @Delete("""
            DELETE FROM vmall_cart_items
            WHERE id = #{id}
              AND user_id = #{userId}
            """)
    int deleteByIdAndUserId(@Param("id") Long id, @Param("userId") Long userId);
}