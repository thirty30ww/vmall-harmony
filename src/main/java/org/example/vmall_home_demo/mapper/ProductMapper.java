package org.example.vmall_home_demo.mapper;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;
import org.example.vmall_home_demo.entity.Product;

import java.util.List;

@Mapper
public interface ProductMapper {
    @Select("""
            <script>
            SELECT id,
                   prd_id AS prdId,
                   sbom_code AS sbomCode,
                   name,
                   feature,
                   price,
                   image_url AS imageUrl,
                   product_url AS productUrl,
                   raw_text AS rawText,
                   scraped_at AS scrapedAt
            FROM vmall_homepage_products
            <where>
                <if test="keyword != null and keyword != ''">
                    AND (
                        name LIKE CONCAT('%', #{keyword}, '%')
                        OR feature LIKE CONCAT('%', #{keyword}, '%')
                        OR raw_text LIKE CONCAT('%', #{keyword}, '%')
                    )
                </if>
            </where>
            ORDER BY id ASC
            <if test="limit != null and limit &gt; 0">
                LIMIT #{limit}
            </if>
            </script>
            """)
    List<Product> findAll(@Param("keyword") String keyword, @Param("limit") Integer limit);

    @Select("""
            SELECT id,
                   prd_id AS prdId,
                   sbom_code AS sbomCode,
                   name,
                   feature,
                   price,
                   image_url AS imageUrl,
                   product_url AS productUrl,
                   raw_text AS rawText,
                   scraped_at AS scrapedAt
            FROM vmall_homepage_products
            WHERE id = #{id}
            """)
    Product findById(@Param("id") Integer id);
}
