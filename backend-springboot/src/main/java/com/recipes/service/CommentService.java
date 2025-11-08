package com.recipes.service;

import com.recipes.dto.CommentDTO;
import com.recipes.exception.ResourceNotFoundException;
import com.recipes.model.Comment;
import com.recipes.model.CommentStatus;
import com.recipes.model.Recipe;
import com.recipes.model.User;
import com.recipes.repository.CommentRepository;
import com.recipes.repository.CommentStatusRepository;
import com.recipes.repository.RecipeRepository;
import com.recipes.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class CommentService {
    
    private final CommentRepository commentRepository;
    private final RecipeRepository recipeRepository;
    private final CommentStatusRepository commentStatusRepository;
    private final UserRepository userRepository;

    public List<CommentDTO> findByRecipeId(Long recipeId) {
        List<Comment> comments = commentRepository.findByReceta_IdAndEstado_Nombre(recipeId, "aprobado");
        return comments.stream()
                .map(this::convertToDTO)
                .collect(Collectors.toList());
    }

    @Transactional
    public CommentDTO create(Long recipeId, CommentDTO commentDTO) {
        Recipe recipe = recipeRepository.findById(recipeId)
                .orElseThrow(() -> new ResourceNotFoundException("Receta no encontrada"));
        
        CommentStatus pendingStatus = commentStatusRepository.findByNombre("pendiente")
                .orElseThrow(() -> new ResourceNotFoundException("Estado de comentario no encontrado"));
        
        Comment comment = new Comment();
        comment.setContenido(commentDTO.getContenido());
        comment.setReceta(recipe);
        comment.setUsuario(getCurrentUser());
        comment.setEstado(pendingStatus);
        
        Comment saved = commentRepository.save(comment);
        return convertToDTO(saved);
    }

    private CommentDTO convertToDTO(Comment comment) {
        CommentDTO dto = new CommentDTO();
        dto.setId(comment.getId());
        dto.setContenido(comment.getContenido());
        dto.setFechaCreacion(comment.getFechaCreacion());
        dto.setUsuarioId(comment.getUsuario().getId());
        dto.setUsuarioNombre(comment.getUsuario().getUsername());
        dto.setRecetaId(comment.getReceta().getId());
        dto.setRecetaTitulo(comment.getReceta().getTitulo());
        dto.setEstadoId(comment.getEstado().getId());
        dto.setEstadoNombre(comment.getEstado().getNombre());
        return dto;
    }

    public List<CommentDTO> findByCurrentUser() {
        List<Comment> comments = commentRepository.findByUsuario_Id(getCurrentUser().getId());
        return comments.stream()
                .map(this::convertToDTO)
                .collect(Collectors.toList());
    }

    private User getCurrentUser() {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        String username = authentication.getName();
        return userRepository.findByUsername(username)
                .orElseThrow(() -> new RuntimeException("Usuario no encontrado"));
    }
}
