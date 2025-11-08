package com.recipes.service;

import com.recipes.dto.RecipeDTO;
import com.recipes.exception.ResourceNotFoundException;
import com.recipes.model.Category;
import com.recipes.model.Recipe;
import com.recipes.model.User;
import com.recipes.repository.CategoryRepository;
import com.recipes.repository.RecipeRepository;
import com.recipes.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class RecipeService {

    private final RecipeRepository recipeRepository;
    private final CategoryRepository categoryRepository;
    private final UserRepository userRepository;

    public Page<RecipeDTO> findAll(Long categoria, String busqueda, Pageable pageable) {
        Page<Recipe> recipes;
        
        if (categoria != null && busqueda != null && !busqueda.isEmpty()) {
            recipes = recipeRepository.findByCategoriaIdAndTituloContainingIgnoreCase(categoria, busqueda, pageable);
        } else if (categoria != null) {
            recipes = recipeRepository.findByCategoriaId(categoria, pageable);
        } else if (busqueda != null && !busqueda.isEmpty()) {
            recipes = recipeRepository.findByTituloContainingIgnoreCase(busqueda, pageable);
        } else {
            recipes = recipeRepository.findAll(pageable);
        }
        
        return recipes.map(this::convertToDTO);
    }

    public RecipeDTO findById(Long id) {
        Recipe recipe = recipeRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Receta no encontrada"));
        return convertToDTO(recipe);
    }

    public List<RecipeDTO> findFeatured() {
        List<Recipe> recipes = recipeRepository.findFeaturedRecipes();
        return recipes.stream()
                .map(this::convertToDTO)
                .collect(Collectors.toList());
    }

    @Transactional
    public RecipeDTO create(RecipeDTO recipeDTO) {
        User currentUser = getCurrentUser();
        
        Recipe recipe = new Recipe();
        recipe.setTitulo(recipeDTO.getTitulo());
        recipe.setDescripcion(recipeDTO.getDescripcion());
        recipe.setIngredientes(recipeDTO.getIngredientes());
        recipe.setInstrucciones(recipeDTO.getInstrucciones());
        recipe.setImagenUrl(recipeDTO.getImagenUrl());
        recipe.setPuntuacionPromedio(0.0f);
        recipe.setAutor(currentUser);
        
        if (recipeDTO.getCategoriaId() != null) {
            Category category = categoryRepository.findById(recipeDTO.getCategoriaId())
                    .orElseThrow(() -> new ResourceNotFoundException("Categoria no encontrada"));
            recipe.setCategoria(category);
        }
        
        Recipe savedRecipe = recipeRepository.save(recipe);
        return convertToDTO(savedRecipe);
    }

    @Transactional
    public RecipeDTO update(Long id, RecipeDTO recipeDTO) {
        Recipe recipe = recipeRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Receta no encontrada"));
        
        recipe.setTitulo(recipeDTO.getTitulo());
        recipe.setDescripcion(recipeDTO.getDescripcion());
        recipe.setIngredientes(recipeDTO.getIngredientes());
        recipe.setInstrucciones(recipeDTO.getInstrucciones());
        recipe.setImagenUrl(recipeDTO.getImagenUrl());
        
        if (recipeDTO.getCategoriaId() != null) {
            Category category = categoryRepository.findById(recipeDTO.getCategoriaId())
                    .orElseThrow(() -> new ResourceNotFoundException("Categoria no encontrada"));
            recipe.setCategoria(category);
        }
        
        Recipe updatedRecipe = recipeRepository.save(recipe);
        return convertToDTO(updatedRecipe);
    }

    @Transactional
    public void delete(Long id) {
        Recipe recipe = recipeRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Receta no encontrada"));
        recipeRepository.delete(recipe);
    }

    private RecipeDTO convertToDTO(Recipe recipe) {
        RecipeDTO dto = new RecipeDTO();
        dto.setId(recipe.getId());
        dto.setTitulo(recipe.getTitulo());
        dto.setDescripcion(recipe.getDescripcion());
        dto.setIngredientes(recipe.getIngredientes());
        dto.setInstrucciones(recipe.getInstrucciones());
        dto.setImagenUrl(recipe.getImagenUrl());
        dto.setFechaCreacion(recipe.getFechaCreacion());
        
        if (recipe.getAutor() != null) {
            dto.setAutorNombre(recipe.getAutor().getUsername());
            dto.setAutorId(recipe.getAutor().getId());
        }
        
        if (recipe.getCategoria() != null) {
            dto.setCategoriaNombre(recipe.getCategoria().getNombre());
            dto.setCategoriaId(recipe.getCategoria().getId());
        }
        
        Double avgRating = recipeRepository.getAverageRating(recipe.getId());
        dto.setCalificacionPromedio(avgRating != null ? avgRating : 0.0);
        
        dto.setTotalCalificaciones(recipe.getCalificaciones().size());
        dto.setTotalComentarios((int) recipe.getComentarios().stream()
                .filter(c -> "APPROVED".equals(c.getEstado().getNombre()))
                .count());
        
        return dto;
    }

    public List<RecipeDTO> findByCurrentUser() {
        User currentUser = getCurrentUser();
        List<Recipe> recipes = recipeRepository.findByAutor_Id(currentUser.getId(), null).getContent();
        return recipes.stream()
                .map(this::convertToDTO)
                .collect(Collectors.toList());
    }

    private User getCurrentUser() {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        String usernameOrEmail = authentication.getName();
        return userRepository.findByEmailOrUsername(usernameOrEmail, usernameOrEmail)
                .orElseThrow(() -> new RuntimeException("Usuario no encontrado"));
    }
}
