package com.recipes.controller;

import com.recipes.dto.*;
import com.recipes.service.AdminService;
import com.recipes.service.CategoryService;
import com.recipes.service.RecipeService;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/admin")
@CrossOrigin(origins = "*")
public class AdminController {
    
    private final AdminService adminService;
    private final RecipeService recipeService;
    private final CategoryService categoryService;
    
    public AdminController(AdminService adminService, RecipeService recipeService, CategoryService categoryService) {
        this.adminService = adminService;
        this.recipeService = recipeService;
        this.categoryService = categoryService;
    }
    
    @PostMapping("/recipes")
    public ResponseEntity<RecipeDTO> createRecipe(@RequestBody RecipeDTO recipeDTO) {
        RecipeDTO created = recipeService.create(recipeDTO);
        return ResponseEntity.ok(created);
    }
    
    @PutMapping("/recipes/{id}")
    public ResponseEntity<RecipeDTO> updateRecipe(@PathVariable Long id, @RequestBody RecipeDTO recipeDTO) {
        RecipeDTO updated = recipeService.update(id, recipeDTO);
        return ResponseEntity.ok(updated);
    }
    
    @DeleteMapping("/recipes/{id}")
    public ResponseEntity<Void> deleteRecipe(@PathVariable Long id) {
        recipeService.delete(id);
        return ResponseEntity.noContent().build();
    }
    
    @PostMapping("/recipes/{id}/feature")
    public ResponseEntity<Void> featureRecipe(@PathVariable Long id) {
        adminService.featureRecipe(id);
        return ResponseEntity.ok().build();
    }
    
    @DeleteMapping("/recipes/{id}/feature")
    public ResponseEntity<Void> unfeatureRecipe(@PathVariable Long id) {
        adminService.unfeatureRecipe(id);
        return ResponseEntity.noContent().build();
    }
    
    @GetMapping("/users")
    public ResponseEntity<Page<UserDTO>> getAllUsers(
            @RequestParam(defaultValue = "0") int pagina,
            @RequestParam(defaultValue = "10") int limite) {
        PageRequest pageRequest = PageRequest.of(pagina, limite);
        Page<UserDTO> users = adminService.getAllUsers(pageRequest);
        return ResponseEntity.ok(users);
    }
    
    @DeleteMapping("/users/{id}")
    public ResponseEntity<Void> deleteUser(@PathVariable Long id) {
        adminService.deleteUser(id);
        return ResponseEntity.noContent().build();
    }
    
    @PutMapping("/users/{id}/toggle-status")
    public ResponseEntity<UserDTO> toggleUserStatus(@PathVariable Long id) {
        UserDTO updated = adminService.toggleUserStatus(id);
        return ResponseEntity.ok(updated);
    }
    
    @GetMapping("/comments/pending")
    public ResponseEntity<Page<CommentDTO>> getPendingComments(
            @RequestParam(defaultValue = "0") int pagina,
            @RequestParam(defaultValue = "10") int limite) {
        PageRequest pageRequest = PageRequest.of(pagina, limite);
        Page<CommentDTO> comments = adminService.getPendingComments(pageRequest);
        return ResponseEntity.ok(comments);
    }
    
    @PutMapping("/comments/{id}/approve")
    public ResponseEntity<CommentDTO> approveComment(@PathVariable Long id) {
        CommentDTO approved = adminService.approveComment(id);
        return ResponseEntity.ok(approved);
    }
    
    @PutMapping("/comments/{id}/reject")
    public ResponseEntity<CommentDTO> rejectComment(@PathVariable Long id) {
        CommentDTO rejected = adminService.rejectComment(id);
        return ResponseEntity.ok(rejected);
    }
    
    @DeleteMapping("/comments/{id}")
    public ResponseEntity<Void> deleteComment(@PathVariable Long id) {
        adminService.deleteComment(id);
        return ResponseEntity.noContent().build();
    }
    
    @GetMapping("/categories")
    public ResponseEntity<List<CategoryDTO>> getAllCategories() {
        List<CategoryDTO> categories = categoryService.findAll();
        return ResponseEntity.ok(categories);
    }
    
    @PostMapping("/categories")
    public ResponseEntity<CategoryDTO> createCategory(@RequestBody CategoryDTO categoryDTO) {
        CategoryDTO created = adminService.createCategory(categoryDTO);
        return ResponseEntity.ok(created);
    }
    
    @PutMapping("/categories/{id}")
    public ResponseEntity<CategoryDTO> updateCategory(@PathVariable Long id, @RequestBody CategoryDTO categoryDTO) {
        CategoryDTO updated = adminService.updateCategory(id, categoryDTO);
        return ResponseEntity.ok(updated);
    }
    
    @DeleteMapping("/categories/{id}")
    public ResponseEntity<Void> deleteCategory(@PathVariable Long id) {
        adminService.deleteCategory(id);
        return ResponseEntity.noContent().build();
    }
    
    @GetMapping("/dashboard")
    public ResponseEntity<DashboardDTO> getDashboard() {
        DashboardDTO dashboard = adminService.getDashboard();
        return ResponseEntity.ok(dashboard);
    }
}
