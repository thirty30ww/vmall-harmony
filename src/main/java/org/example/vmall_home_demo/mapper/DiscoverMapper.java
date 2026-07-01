package org.example.vmall_home_demo.mapper;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;
import org.example.vmall_home_demo.entity.DiscoverItem;
import org.example.vmall_home_demo.entity.DiscoverNavIcon;
import org.example.vmall_home_demo.entity.DiscoverPage;
import org.example.vmall_home_demo.entity.DiscoverSection;
import org.example.vmall_home_demo.entity.DiscoverTab;

import java.util.List;

@Mapper
public interface DiscoverMapper {
    @Select("""
            SELECT id,
                   page_id AS pageId,
                   page_name AS pageName,
                   source_url AS sourceUrl,
                   sort_order AS sortOrder,
                   created_at AS createdAt
            FROM vmall_discover_pages
            WHERE (#{pageId} IS NULL OR page_id = #{pageId})
            ORDER BY sort_order ASC, id ASC
            """)
    List<DiscoverPage> findPages(@Param("pageId") String pageId);

    @Select("""
            SELECT id,
                   tab_key AS tabKey,
                   tab_name AS tabName,
                   related_page_id AS relatedPageId,
                   sort_order AS sortOrder,
                   created_at AS createdAt
            FROM vmall_discover_tabs
            WHERE (#{pageId} IS NULL OR related_page_id = #{pageId})
            ORDER BY sort_order ASC, id ASC
            """)
    List<DiscoverTab> findTabs(@Param("pageId") String pageId);

    @Select("""
            SELECT id,
                   tab_key AS tabKey,
                   tab_name AS tabName,
                   related_page_id AS relatedPageId,
                   sort_order AS sortOrder,
                   created_at AS createdAt
            FROM vmall_discover_tabs
            WHERE tab_name = #{tabName}
            ORDER BY sort_order ASC, id ASC
            LIMIT 1
            """)
    DiscoverTab findTabByName(@Param("tabName") String tabName);

    @Select("""
            SELECT id,
                   page_id AS pageId,
                   position,
                   title,
                   icon_attribute AS iconAttribute,
                   image_url AS imageUrl,
                   link_url AS linkUrl,
                   sort_order AS sortOrder,
                   created_at AS createdAt
            FROM vmall_discover_nav_icons
            WHERE (#{pageId} IS NULL OR page_id = #{pageId})
            ORDER BY sort_order ASC, id ASC
            """)
    List<DiscoverNavIcon> findNavIcons(@Param("pageId") String pageId);

    @Select("""
            SELECT id,
                   page_id AS pageId,
                   tab_name AS tabName,
                   card_id AS cardId,
                   card_type AS cardType,
                   card_name AS cardName,
                   layout_type AS layoutType,
                   data_source_code AS dataSourceCode,
                   data_source_type AS dataSourceType,
                   img_proportion AS imgProportion,
                   sort_order AS sortOrder,
                   created_at AS createdAt
            FROM vmall_discover_sections
            WHERE (#{pageId} IS NULL OR page_id = #{pageId})
              AND (#{tabName} IS NULL OR tab_name = #{tabName})
            ORDER BY sort_order ASC, id ASC
            """)
    List<DiscoverSection> findSections(@Param("pageId") String pageId, @Param("tabName") String tabName);

    @Select("""
            SELECT id,
                   page_id AS pageId,
                   tab_name AS tabName,
                   card_id AS cardId,
                   data_source_code AS dataSourceCode,
                   item_type AS itemType,
                   title,
                   subtitle,
                   author_name AS authorName,
                   image_url AS imageUrl,
                   link_url AS linkUrl,
                   content_id AS contentId,
                   content_type AS contentType,
                   product_name AS productName,
                   product_price AS productPrice,
                   like_count AS likeCount,
                   view_count AS viewCount,
                   sort_order AS sortOrder,
                   created_at AS createdAt
            FROM vmall_discover_items
            WHERE (#{pageId} IS NULL OR page_id = #{pageId})
              AND (#{tabName} IS NULL OR tab_name = #{tabName})
            ORDER BY sort_order ASC, id ASC
            """)
    List<DiscoverItem> findItems(@Param("pageId") String pageId, @Param("tabName") String tabName);

    @Select("""
            SELECT id,
                   page_id AS pageId,
                   tab_name AS tabName,
                   card_id AS cardId,
                   data_source_code AS dataSourceCode,
                   item_type AS itemType,
                   title,
                   subtitle,
                   author_name AS authorName,
                   image_url AS imageUrl,
                   link_url AS linkUrl,
                   content_id AS contentId,
                   content_type AS contentType,
                   product_name AS productName,
                   product_price AS productPrice,
                   like_count AS likeCount,
                   view_count AS viewCount,
                   sort_order AS sortOrder,
                   created_at AS createdAt
            FROM vmall_discover_items
            WHERE card_id = #{cardId}
            ORDER BY sort_order ASC, id ASC
            """)
    List<DiscoverItem> findItemsByCardId(@Param("cardId") String cardId);
}