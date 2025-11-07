package com.recipes.repository;

import com.recipes.model.Comment;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface CommentRepository extends JpaRepository<Comment, Long> {
    List<Comment> findByReceta_IdAndEstado_Nombre(Long recetaId, String estadoNombre);
    Page<Comment> findByEstado_Nombre(String estadoNombre, Pageable pageable);
    List<Comment> findByUsuario_Id(Long usuarioId);
    Long countByEstado_Nombre(String estadoNombre);
}
