package com.recipes.controller;

import com.recipes.dto.CommentDTO;
import com.recipes.dto.ProfileDTO;
import com.recipes.dto.RecipeDTO;
import com.recipes.dto.UserDTO;
import com.recipes.service.CommentService;
import com.recipes.service.RecipeService;
import com.recipes.service.UserService;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/profile")
@CrossOrigin(origins = "*")
public class ProfileController {
    
    private final UserService userService;
    private final RecipeService recipeService;
    private final CommentService commentService;
    
    public ProfileController(UserService userService, RecipeService recipeService, CommentService commentService) {
        this.userService = userService;
        this.recipeService = recipeService;
        this.commentService = commentService;
    }
    
    @GetMapping("/me")
    public ResponseEntity<ProfileDTO> getProfile() {
        ProfileDTO profile = userService.getCurrentUserProfile();
        return ResponseEntity.ok(profile);
    }
    
    @PutMapping("/me")
    public ResponseEntity<UserDTO> updateProfile(@RequestBody UserDTO userDTO) {
        UserDTO updated = userService.updateCurrentUser(userDTO);
        return ResponseEntity.ok(updated);
    }
    
    @GetMapping("/favorites")
    public ResponseEntity<List<RecipeDTO>> getFavorites() {
        List<RecipeDTO> favorites = userService.getFavoriteRecipes();
        return ResponseEntity.ok(favorites);
    }
    
    @GetMapping("/my-recipes")
    public ResponseEntity<List<RecipeDTO>> getMyRecipes() {
        List<RecipeDTO> recipes = recipeService.findByCurrentUser();
        return ResponseEntity.ok(recipes);
    }
    
    @GetMapping("/my-comments")
    public ResponseEntity<List<CommentDTO>> getMyComments() {
        List<CommentDTO> comments = commentService.findByCurrentUser();
        return ResponseEntity.ok(comments);
    }
}
