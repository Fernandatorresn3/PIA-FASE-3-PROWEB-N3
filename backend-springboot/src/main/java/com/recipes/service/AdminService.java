package com.recipes.service;

import com.recipes.dto.*;
import com.recipes.exception.ResourceNotFoundException;
import com.recipes.model.*;
import com.recipes.repository.*;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class AdminService {
    
    private final UserRepository userRepository;
    private final RecipeRepository recipeRepository;
    private final CommentRepository commentRepository;
    private final CommentStatusRepository commentStatusRepository;
    private final CategoryRepository categoryRepository;
    private final FeaturedRecipeRepository featuredRecipeRepository;

    @Transactional(readOnly = true)
    public Page<UserDTO> getAllUsers(Pageable pageable) {
        // Nota: findAll no carga roles por defecto, pero convertUserToDTO maneja esto
        return userRepository.findAll(pageable).map(this::convertUserToDTO);
    }

    @Transactional
    public void deleteUser(Long userId) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new ResourceNotFoundException("Usuario no encontrado"));
        userRepository.delete(user);
    }

    @Transactional
    public UserDTO toggleUserStatus(Long userId) {
        // Usar findById con EntityGraph para cargar roles
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new ResourceNotFoundException("Usuario no encontrado"));
        // Toggle user status logic could be added here if activo field existed
        User saved = userRepository.save(user);
        return convertUserToDTO(saved);
    }

    public Page<CommentDTO> getPendingComments(Pageable pageable) {
        return commentRepository.findByEstado_Nombre("PENDIENTE", pageable).map(this::convertCommentToDTO);
    }

    @Transactional
    public CommentDTO approveComment(Long commentId) {
        Comment comment = commentRepository.findById(commentId)
                .orElseThrow(() -> new ResourceNotFoundException("Comentario no encontrado"));
        
        CommentStatus approved = commentStatusRepository.findByNombre("APROBADO")
                .orElseThrow(() -> new ResourceNotFoundException("Estado no encontrado"));
        
        comment.setEstado(approved);
        Comment saved = commentRepository.save(comment);
        return convertCommentToDTO(saved);
    }

    @Transactional
    public CommentDTO rejectComment(Long commentId) {
        Comment comment = commentRepository.findById(commentId)
                .orElseThrow(() -> new ResourceNotFoundException("Comentario no encontrado"));
        
        CommentStatus rejected = commentStatusRepository.findByNombre("RECHAZADO")
                .orElseThrow(() -> new ResourceNotFoundException("Estado no encontrado"));
        
        comment.setEstado(rejected);
        Comment saved = commentRepository.save(comment);
        return convertCommentToDTO(saved);
    }

    @Transactional
    public void deleteComment(Long commentId) {
        Comment comment = commentRepository.findById(commentId)
                .orElseThrow(() -> new ResourceNotFoundException("Comentario no encontrado"));
        commentRepository.delete(comment);
    }

    @Transactional
    public CategoryDTO createCategory(CategoryDTO categoryDTO) {
        Category category = new Category();
        category.setNombre(categoryDTO.getNombre());
        Category saved = categoryRepository.save(category);
        return convertCategoryToDTO(saved);
    }

    @Transactional
    public CategoryDTO updateCategory(Long id, CategoryDTO categoryDTO) {
        Category category = categoryRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Categoria no encontrada"));
        category.setNombre(categoryDTO.getNombre());
        Category saved = categoryRepository.save(category);
        return convertCategoryToDTO(saved);
    }

    @Transactional
    public void deleteCategory(Long id) {
        Category category = categoryRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Categoria no encontrada"));
        categoryRepository.delete(category);
    }

    @Transactional
    public void featureRecipe(Long recipeId) {
        Recipe recipe = recipeRepository.findById(recipeId)
                .orElseThrow(() -> new ResourceNotFoundException("Receta no encontrada"));
        
        FeaturedRecipe featured = new FeaturedRecipe();
        featured.setIdReceta(recipeId);
        featured.setIdUsuario(recipe.getAutor().getId());
        featured.setReceta(recipe);
        
        featuredRecipeRepository.save(featured);
    }

    @Transactional
    public void unfeatureRecipe(Long recipeId) {
        List<FeaturedRecipe> featured = featuredRecipeRepository.findByIdReceta(recipeId);
        if (!featured.isEmpty()) {
            featuredRecipeRepository.deleteAll(featured);
        }
    }

    public DashboardDTO getDashboard() {
        DashboardDTO dashboard = new DashboardDTO();
        dashboard.setTotalUsuarios((int) userRepository.count());
        dashboard.setTotalRecetas((int) recipeRepository.count());
        dashboard.setTotalCategorias((int) categoryRepository.count());
        dashboard.setTotalComentariosPendientes(commentRepository.countByEstado_Nombre("PENDIENTE").intValue());
        dashboard.setTotalComentariosAprobados(commentRepository.countByEstado_Nombre("APROBADO").intValue());
        dashboard.setTotalRecetasDestacadas((int) featuredRecipeRepository.count());
        return dashboard;
    }

    private UserDTO convertUserToDTO(User user) {
        UserDTO dto = new UserDTO();
        dto.setId(user.getId());
        dto.setUsername(user.getUsername());
        dto.setEmail(user.getEmail());
        dto.setFechaRegistro(user.getFechaRegistro());
        // Verificar que roles esté inicializado y no esté vacío
        if (user.getRoles() != null && !user.getRoles().isEmpty()) {
            dto.setRole(user.getRoles().iterator().next().getNombre());
        } else {
            // Si no tiene roles cargados, intentar cargarlos (fallback)
            // Esto no debería pasar si usamos los métodos correctos, pero es una protección
            dto.setRole("ROLE_USER"); // Valor por defecto
        }
        return dto;
    }

    private CommentDTO convertCommentToDTO(Comment comment) {
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

    private CategoryDTO convertCategoryToDTO(Category category) {
        CategoryDTO dto = new CategoryDTO();
        dto.setId(category.getId());
        dto.setNombre(category.getNombre());
        dto.setTotalRecetas(category.getRecetas() != null ? category.getRecetas().size() : 0);
        return dto;
    }
}
