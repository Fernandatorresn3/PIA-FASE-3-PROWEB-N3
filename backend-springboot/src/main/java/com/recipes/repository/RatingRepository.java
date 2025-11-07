package com.recipes.repository;

import com.recipes.model.Rating;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface RatingRepository extends JpaRepository<Rating, Long> {
    Optional<Rating> findByUsuario_IdAndReceta_Id(Long usuarioId, Long recetaId);
    List<Rating> findByReceta_Id(Long recetaId);
    List<Rating> findByUsuario_Id(Long usuarioId);
    
    @Query("SELECT AVG(r.puntuacion) FROM Rating r WHERE r.receta.id = :recetaId")
    Double getAverageRatingByRecetaId(@Param("recetaId") Long recetaId);
    
    @Query("SELECT COUNT(r) FROM Rating r WHERE r.receta.id = :recetaId")
    Long countByRecetaId(@Param("recetaId") Long recetaId);
    
    @Query("SELECT r.receta FROM Rating r WHERE r.usuario.id = :usuarioId AND r.puntuacion >= 4")
    List findFavoritesByUsuarioId(@Param("usuarioId") Long usuarioId);
}
