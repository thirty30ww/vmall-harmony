package org.example.vmall_home_demo.service;

import org.example.vmall_home_demo.entity.Activity;
import org.example.vmall_home_demo.mapper.ActivityMapper;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class ActivityService {
    private final ActivityMapper activityMapper;

    public ActivityService(ActivityMapper activityMapper) {
        this.activityMapper = activityMapper;
    }

    public List<Activity> listActivities() {
        return activityMapper.findAll();
    }
}
