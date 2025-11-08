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

    @Transactional(readOnly = true)
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

    @Transactional(readOnly = true)
    public RecipeDTO findById(Long id) {
        Recipe recipe = recipeRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Receta no encontrada"));
        return convertToDTO(recipe);
    }

    @Transactional(readOnly = true)
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
        
        // Asegurar que ingredientesJson tenga un valor JSON válido
        if (recipeDTO.getIngredientes() != null && !recipeDTO.getIngredientes().isEmpty()) {
            // Si el campo ingredientes tiene valor, crear un JSON array simple
            recipe.setIngredientesJson("[]");
        } else {
            recipe.setIngredientesJson("[]");
        }
        
        // Convertir instrucciones a JSON si es texto plano
        if (recipeDTO.getInstrucciones() != null) {
            recipe.setInstrucciones(convertTextToJsonArray(recipeDTO.getInstrucciones()));
        } else {
            recipe.setInstrucciones("[]");
        }
        
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
        
        // Convertir instrucciones a JSON si es necesario
        if (recipeDTO.getInstrucciones() != null) {
            recipe.setInstrucciones(convertTextToJsonArray(recipeDTO.getInstrucciones()));
        }
        
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
                .filter(c -> "APROBADO".equals(c.getEstado().getNombre()))
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
    
    /**
     * Convierte texto plano a JSON array
     * Si el texto ya es JSON válido, lo retorna tal cual
     * Si es texto plano con saltos de línea, lo convierte a array
     */
    private String convertTextToJsonArray(String text) {
        if (text == null || text.trim().isEmpty()) {
            return "[]";
        }
        
        // Si ya parece ser JSON (empieza con [ o {), retornarlo tal cual
        String trimmed = text.trim();
        if (trimmed.startsWith("[") || trimmed.startsWith("{")) {
            return text;
        }
        
        // Convertir texto con saltos de línea a JSON array
        StringBuilder json = new StringBuilder("[");
        String[] lines = text.split("\\n");
        for (int i = 0; i < lines.length; i++) {
            String line = lines[i].trim();
            if (!line.isEmpty()) {
                if (json.length() > 1) {
                    json.append(",");
                }
                // Escapar comillas y caracteres especiales
                String escaped = line.replace("\\", "\\\\")
                                    .replace("\"", "\\\"")
                                    .replace("\n", "\\n")
                                    .replace("\r", "\\r")
                                    .replace("\t", "\\t");
                json.append("\"").append(escaped).append("\"");
            }
        }
        json.append("]");
        
        return json.toString();
    }
}
