package com.recipes.repository;

import com.recipes.model.FeaturedRecipe;
import com.recipes.model.FeaturedRecipeId;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface FeaturedRecipeRepository extends JpaRepository<FeaturedRecipe, FeaturedRecipeId> {
    List<FeaturedRecipe> findByIdReceta(Long recetaId);
}
