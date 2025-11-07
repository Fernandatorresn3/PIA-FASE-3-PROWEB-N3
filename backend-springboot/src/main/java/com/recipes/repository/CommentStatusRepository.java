package com.recipes.repository;

import com.recipes.model.CommentStatus;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface CommentStatusRepository extends JpaRepository<CommentStatus, Long> {
    Optional<CommentStatus> findByNombre(String nombre);
}
