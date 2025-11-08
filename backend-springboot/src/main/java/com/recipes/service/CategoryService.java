package com.recipes.service;

import com.recipes.dto.CategoryDTO;
import com.recipes.model.Category;
import com.recipes.repository.CategoryRepository;
import com.recipes.repository.RecipeRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class CategoryService {
    
    private final CategoryRepository categoryRepository;
    private final RecipeRepository recipeRepository;

    @Transactional(readOnly = true)
    public List<CategoryDTO> findAll() {
        return categoryRepository.findAll().stream()
                .map(this::convertToDTO)
                .collect(Collectors.toList());
    }

    private CategoryDTO convertToDTO(Category category) {
        CategoryDTO dto = new CategoryDTO();
        dto.setId(category.getId());
        dto.setNombre(category.getNombre());
        dto.setTotalRecetas((int) recipeRepository.countByCategoriaId(category.getId()));
        return dto;
    }
}
