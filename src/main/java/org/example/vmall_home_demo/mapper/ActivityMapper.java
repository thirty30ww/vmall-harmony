package org.example.vmall_home_demo.mapper;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Select;
import org.example.vmall_home_demo.entity.Activity;

import java.util.List;

@Mapper
public interface ActivityMapper {
    @Select("""
            SELECT id,
                   title,
                   activity_url AS activityUrl,
                   scraped_at AS scrapedAt
            FROM vmall_homepage_activities
            ORDER BY id ASC
            """)
    List<Activity> findAll();
}
