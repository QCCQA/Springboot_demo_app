package com.hanab.springboot_demo_app.model;
import java.util.List;

public record Student (
        String id,
        String name,
        String description,
        List<Course> courses){}
