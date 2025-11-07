package com.recipes.repository;

import com.recipes.model.FeaturedRecipe;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface FeaturedRecipeRepository extends JpaRepository<FeaturedRecipe, Long> {
    List<FeaturedRecipe> findByActivoTrue();
    Optional<FeaturedRecipe> findByReceta_IdAndActivoTrue(Long recetaId);
}
