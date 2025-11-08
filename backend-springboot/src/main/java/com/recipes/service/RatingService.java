package com.recipes.service;

import com.recipes.dto.RatingDTO;
import com.recipes.exception.ResourceNotFoundException;
import com.recipes.model.Rating;
import com.recipes.model.Recipe;
import com.recipes.model.User;
import com.recipes.repository.RatingRepository;
import com.recipes.repository.RecipeRepository;
import com.recipes.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class RatingService {
    
    private final RatingRepository ratingRepository;
    private final RecipeRepository recipeRepository;
    private final UserRepository userRepository;

    public List<RatingDTO> findByRecipeId(Long recipeId) {
        List<Rating> ratings = ratingRepository.findByReceta_Id(recipeId);
        return ratings.stream()
                .map(this::convertToDTO)
                .collect(Collectors.toList());
    }

    @Transactional
    public RatingDTO create(Long recipeId, RatingDTO ratingDTO) {
        Recipe recipe = recipeRepository.findById(recipeId)
                .orElseThrow(() -> new ResourceNotFoundException("Receta no encontrada"));
        
        User currentUser = getCurrentUser();
        
        Optional<Rating> existingRating = ratingRepository.findByUsuario_IdAndReceta_Id(currentUser.getId(), recipeId);
        
        Rating rating;
        if (existingRating.isPresent()) {
            rating = existingRating.get();
            rating.setPuntuacion(ratingDTO.getPuntuacion());
        } else {
            rating = new Rating();
            rating.setPuntuacion(ratingDTO.getPuntuacion());
            rating.setReceta(recipe);
            rating.setUsuario(currentUser);
        }
        
        Rating saved = ratingRepository.save(rating);
        return convertToDTO(saved);
    }

    private User getCurrentUser() {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        String usernameOrEmail = authentication.getName();
        return userRepository.findByEmailOrUsername(usernameOrEmail, usernameOrEmail)
                .orElseThrow(() -> new RuntimeException("Usuario no encontrado"));
    }

    private RatingDTO convertToDTO(Rating rating) {
        RatingDTO dto = new RatingDTO();
        dto.setId(rating.getId());
        dto.setPuntuacion(rating.getPuntuacion());
        dto.setFechaCalificacion(rating.getCreatedAt());
        dto.setUsuarioId(rating.getUsuario().getId());
        dto.setRecetaId(rating.getReceta().getId());
        return dto;
    }
}
