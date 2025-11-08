package com.recipes.controller;

import com.recipes.dto.CategoryDTO;
import com.recipes.dto.CommentDTO;
import com.recipes.dto.RatingDTO;
import com.recipes.dto.RecipeDTO;
import com.recipes.service.CategoryService;
import com.recipes.service.CommentService;
import com.recipes.service.RatingService;
import com.recipes.service.RecipeService;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/recipes")
@CrossOrigin(origins = "*")
public class RecipeController {
    
    private final RecipeService recipeService;
    private final CommentService commentService;
    private final RatingService ratingService;
    private final CategoryService categoryService;
    
    public RecipeController(RecipeService recipeService, CommentService commentService, 
                          RatingService ratingService, CategoryService categoryService) {
        this.recipeService = recipeService;
        this.commentService = commentService;
        this.ratingService = ratingService;
        this.categoryService = categoryService;
    }
    
    @GetMapping
    public ResponseEntity<Page<RecipeDTO>> getAllRecipes(
            @RequestParam(required = false) Long categoria,
            @RequestParam(required = false) String busqueda,
            @RequestParam(defaultValue = "0") int pagina,
            @RequestParam(defaultValue = "12") int limite) {
        
        PageRequest pageRequest = PageRequest.of(pagina, limite);
        Page<RecipeDTO> recipes = recipeService.findAll(categoria, busqueda, pageRequest);
        return ResponseEntity.ok(recipes);
    }
    
    @GetMapping("/categories")
    public ResponseEntity<List<CategoryDTO>> getAllCategories() {
        List<CategoryDTO> categories = categoryService.findAll();
        return ResponseEntity.ok(categories);
    }
    
    @GetMapping("/{id}")
    public ResponseEntity<RecipeDTO> getRecipeById(@PathVariable Long id) {
        RecipeDTO recipe = recipeService.findById(id);
        return ResponseEntity.ok(recipe);
    }
    
    @GetMapping("/featured")
    public ResponseEntity<List<RecipeDTO>> getFeaturedRecipes() {
        List<RecipeDTO> recipes = recipeService.findFeatured();
        return ResponseEntity.ok(recipes);
    }
    
    @GetMapping("/{id}/comments")
    public ResponseEntity<List<CommentDTO>> getRecipeComments(@PathVariable Long id) {
        List<CommentDTO> comments = commentService.findByRecipeId(id);
        return ResponseEntity.ok(comments);
    }
    
    @PostMapping("/{id}/comments")
    public ResponseEntity<CommentDTO> createComment(@PathVariable Long id, @RequestBody CommentDTO commentDTO) {
        CommentDTO created = commentService.create(id, commentDTO);
        return ResponseEntity.ok(created);
    }
    
    @GetMapping("/{id}/ratings")
    public ResponseEntity<List<RatingDTO>> getRecipeRatings(@PathVariable Long id) {
        List<RatingDTO> ratings = ratingService.findByRecipeId(id);
        return ResponseEntity.ok(ratings);
    }
    
    @PostMapping("/{id}/ratings")
    public ResponseEntity<RatingDTO> createRating(@PathVariable Long id, @RequestBody RatingDTO ratingDTO) {
        RatingDTO created = ratingService.create(id, ratingDTO);
        return ResponseEntity.ok(created);
    }
    
    @PostMapping
    @PreAuthorize("isAuthenticated()")
    public ResponseEntity<RecipeDTO> createRecipe(@RequestBody RecipeDTO recipeDTO) {
        RecipeDTO created = recipeService.create(recipeDTO);
        return ResponseEntity.status(HttpStatus.CREATED).body(created);
    }
    
    @PutMapping("/{id}")
    @PreAuthorize("isAuthenticated()")
    public ResponseEntity<RecipeDTO> updateRecipe(@PathVariable Long id, @RequestBody RecipeDTO recipeDTO) {
        RecipeDTO updated = recipeService.update(id, recipeDTO);
        return ResponseEntity.ok(updated);
    }
    
    @DeleteMapping("/{id}")
    @PreAuthorize("isAuthenticated()")
    public ResponseEntity<Void> deleteRecipe(@PathVariable Long id) {
        recipeService.delete(id);
        return ResponseEntity.noContent().build();
    }
    
    @GetMapping("/search")
    public ResponseEntity<Page<RecipeDTO>> searchRecipes(
            @RequestParam String query,
            @RequestParam(defaultValue = "0") int pagina,
            @RequestParam(defaultValue = "12") int limite) {
        PageRequest pageRequest = PageRequest.of(pagina, limite);
        Page<RecipeDTO> recipes = recipeService.findAll(null, query, pageRequest);
        return ResponseEntity.ok(recipes);
    }
}
