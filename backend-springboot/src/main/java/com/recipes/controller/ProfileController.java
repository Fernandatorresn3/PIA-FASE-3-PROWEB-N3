package com.recipes.controller;

import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/profile")
@CrossOrigin(origins = "*")
public class ProfileController {
    // GET /api/profile/me
    // PUT /api/profile/me
    // GET /api/profile/favorites
    // GET /api/profile/my-recipes
    // GET /api/profile/my-comments
}
