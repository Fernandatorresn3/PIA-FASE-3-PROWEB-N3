package com.recipes.service;

import com.recipes.dto.ProfileDTO;
import com.recipes.dto.RecipeDTO;
import com.recipes.dto.UserDTO;
import com.recipes.model.Rating;
import com.recipes.model.User;
import com.recipes.repository.CommentRepository;
import com.recipes.repository.RatingRepository;
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
public class UserService {
    
    private final UserRepository userRepository;
    private final RecipeRepository recipeRepository;
    private final CommentRepository commentRepository;
    private final RatingRepository ratingRepository;

    public ProfileDTO getCurrentUserProfile() {
        User user = getCurrentUser();
        
        ProfileDTO profile = new ProfileDTO();
        profile.setId(user.getId());
        profile.setUsername(user.getUsername());
        profile.setEmail(user.getEmail());
        profile.setFechaRegistro(user.getFechaRegistro());
        profile.setTotalRecetas(recipeRepository.findByAutor_Id(user.getId(), null).getContent().size());
        profile.setTotalComentarios(commentRepository.findByUsuario_Id(user.getId()).size());
        profile.setTotalCalificaciones(ratingRepository.findByUsuario_Id(user.getId()).size());
        
        return profile;
    }

    @Transactional
    public UserDTO updateCurrentUser(UserDTO userDTO) {
        User user = getCurrentUser();
        
        if (userDTO.getEmail() != null && !userDTO.getEmail().equals(user.getEmail())) {
            user.setEmail(userDTO.getEmail());
        }
        if (userDTO.getUsername() != null && !userDTO.getUsername().equals(user.getUsername())) {
            user.setUsername(userDTO.getUsername());
        }
        
        User saved = userRepository.save(user);
        return convertToDTO(saved);
    }

    public List<RecipeDTO> getFavoriteRecipes() {
        User user = getCurrentUser();
        List<Rating> ratings = ratingRepository.findByUsuario_Id(user.getId());
        
        return ratings.stream()
                .filter(r -> r.getPuntuacion() >= 4)
                .map(r -> {
                    RecipeDTO dto = new RecipeDTO();
                    dto.setId(r.getReceta().getId());
                    dto.setTitulo(r.getReceta().getTitulo());
                    dto.setDescripcion(r.getReceta().getDescripcion());
                    dto.setImagenUrl(r.getReceta().getImagenUrl());
                    dto.setFechaCreacion(r.getReceta().getFechaCreacion());
                    dto.setAutorId(r.getReceta().getAutor().getId());
                    dto.setAutorNombre(r.getReceta().getAutor().getUsername());
                    if (r.getReceta().getCategoria() != null) {
                        dto.setCategoriaId(r.getReceta().getCategoria().getId());
                        dto.setCategoriaNombre(r.getReceta().getCategoria().getNombre());
                    }
                    dto.setCalificacionPromedio(ratingRepository.getAverageRatingByRecetaId(r.getReceta().getId()));
                    dto.setTotalCalificaciones(ratingRepository.countByRecetaId(r.getReceta().getId()).intValue());
                    return dto;
                })
                .collect(Collectors.toList());
    }

    @Transactional(readOnly = true)
    private User getCurrentUser() {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        String usernameOrEmail = authentication.getName();
        // Usar método que carga roles explícitamente para evitar problemas
        return userRepository.findByEmailOrUsernameWithRoles(usernameOrEmail)
                .orElseThrow(() -> new RuntimeException("Usuario no encontrado"));
    }

    private UserDTO convertToDTO(User user) {
        UserDTO dto = new UserDTO();
        dto.setId(user.getId());
        dto.setUsername(user.getUsername());
        dto.setEmail(user.getEmail());
        dto.setFechaRegistro(user.getFechaRegistro());
        if (user.getRoles() != null && !user.getRoles().isEmpty()) {
            dto.setRole(user.getRoles().iterator().next().getNombre());
        }
        return dto;
    }
}
