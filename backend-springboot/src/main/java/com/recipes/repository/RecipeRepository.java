package com.recipes.repository;

import com.recipes.model.Recipe;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface RecipeRepository extends JpaRepository<Recipe, Long> {
    Page<Recipe> findByCategoria_Id(Long categoriaId, Pageable pageable);
    Page<Recipe> findByAutor_Id(Long autorId, Pageable pageable);
    
    Page<Recipe> findByCategoriaIdAndTituloContainingIgnoreCase(Long categoriaId, String titulo, Pageable pageable);
    Page<Recipe> findByCategoriaId(Long categoriaId, Pageable pageable);
    Page<Recipe> findByTituloContainingIgnoreCase(String titulo, Pageable pageable);
    
    long countByCategoriaId(Long categoriaId);
    
    @Query("SELECT r FROM Recipe r WHERE LOWER(r.titulo) LIKE LOWER(CONCAT('%', :search, '%')) OR LOWER(r.ingredientes) LIKE LOWER(CONCAT('%', :search, '%'))")
    Page<Recipe> searchByTituloOrIngredientes(@Param("search") String search, Pageable pageable);
    
    @Query("SELECT r FROM Recipe r JOIN FeaturedRecipe f ON r.id = f.idReceta ORDER BY f.createdAt DESC")
    List<Recipe> findFeaturedRecipes();
    
    @Query("SELECT COALESCE(AVG(c.puntuacion), 0.0) FROM Rating c WHERE c.receta.id = :recipeId")
    Double getAverageRating(@Param("recipeId") Long recipeId);
    
    @Query("SELECT r FROM Recipe r LEFT JOIN r.calificaciones c GROUP BY r ORDER BY AVG(c.puntuacion) DESC")
    List<Recipe> findTopByCalificacion(Pageable pageable);
    
    @Query("SELECT r FROM Recipe r LEFT JOIN r.calificaciones c GROUP BY r ORDER BY COUNT(c) DESC")
    List<Recipe> findTopByMostRated(Pageable pageable);
    
    @Query("SELECT r FROM Recipe r LEFT JOIN r.comentarios c WHERE c.estado.nombre = 'APROBADO' GROUP BY r ORDER BY COUNT(c) DESC")
    List<Recipe> findTopByMostCommented(Pageable pageable);
}
