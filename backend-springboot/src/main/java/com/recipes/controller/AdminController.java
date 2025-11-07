package com.recipes.controller;

import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/admin")
@CrossOrigin(origins = "*")
public class AdminController {
    // Recipe Management
    // POST /api/admin/recipes
    // PUT /api/admin/recipes/{id}
    // DELETE /api/admin/recipes/{id}
    // POST /api/admin/recipes/{id}/feature
    // DELETE /api/admin/recipes/{id}/feature
    
    // User Management
    // GET /api/admin/users
    // DELETE /api/admin/users/{id}
    // PUT /api/admin/users/{id}/toggle-status
    
    // Comment Moderation
    // GET /api/admin/comments/pending
    // PUT /api/admin/comments/{id}/approve
    // PUT /api/admin/comments/{id}/reject
    // DELETE /api/admin/comments/{id}
    
    // Category Management
    // GET /api/admin/categories
    // POST /api/admin/categories
    // PUT /api/admin/categories/{id}
    // DELETE /api/admin/categories/{id}
    
    // Reports
    // GET /api/admin/reports
    // GET /api/admin/dashboard
}
