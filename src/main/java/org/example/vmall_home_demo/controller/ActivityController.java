package org.example.vmall_home_demo.controller;

import org.example.vmall_home_demo.entity.Activity;
import org.example.vmall_home_demo.service.ActivityService;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequestMapping("/api/activities")
public class ActivityController {
    private final ActivityService activityService;

    public ActivityController(ActivityService activityService) {
        this.activityService = activityService;
    }

    @GetMapping
    public List<Activity> listActivities() {
        return activityService.listActivities();
    }
}
