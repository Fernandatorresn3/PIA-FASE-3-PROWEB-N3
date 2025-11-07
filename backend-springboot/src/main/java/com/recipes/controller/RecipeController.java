package com.recipes.controller;

import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/recipes")
@CrossOrigin(origins = "*")
public class RecipeController {
    // GET /api/recipes
    // GET /api/recipes/{id}
    // GET /api/recipes/featured
    // POST /api/recipes/{id}/comments
    // POST /api/recipes/{id}/ratings
}
