package com.recipes.service;

import com.recipes.dto.*;
import com.recipes.exception.ResourceNotFoundException;
import com.recipes.model.Role;
import com.recipes.model.User;
import com.recipes.repository.RoleRepository;
import com.recipes.repository.UserRepository;
import com.recipes.security.JwtTokenProvider;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import lombok.RequiredArgsConstructor;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.HashSet;
import java.util.Set;

@Service
@RequiredArgsConstructor
public class AuthService {

    private final UserRepository userRepository;
    private final RoleRepository roleRepository;
    private final PasswordEncoder passwordEncoder;
    private final JwtTokenProvider tokenProvider;
    private final AuthenticationManager authenticationManager;
    
    @PersistenceContext
    private EntityManager entityManager;

    @Transactional
    public JwtResponseDTO register(UserRegistrationDTO registrationDTO) {
        if (userRepository.existsByUsername(registrationDTO.getUsername())) {
            throw new IllegalArgumentException("El username ya existe");
        }

        if (userRepository.existsByEmail(registrationDTO.getEmail())) {
            throw new IllegalArgumentException("El email ya existe");
        }

        User user = new User();
        user.setUsername(registrationDTO.getUsername());
        user.setEmail(registrationDTO.getEmail());
        user.setPasswordHash(passwordEncoder.encode(registrationDTO.getPassword()));

        Role userRole = roleRepository.findByNombre("ROLE_USER")
                .orElseThrow(() -> new ResourceNotFoundException("Rol ROLE_USER no encontrado"));
        
        Set<Role> roles = new HashSet<>();
        roles.add(userRole);
        user.setRoles(roles);

        User savedUser = userRepository.save(user);

        Authentication authentication = authenticationManager.authenticate(
                new UsernamePasswordAuthenticationToken(
                        registrationDTO.getUsername(),
                        registrationDTO.getPassword()
                )
        );

        String token = tokenProvider.generateToken(authentication);
        Long expiresIn = tokenProvider.getExpirationTime();

        UserDTO userDTO = convertToUserDTO(savedUser);

        return new JwtResponseDTO(token, expiresIn, userDTO);
    }

    @Transactional(readOnly = true)
    public JwtResponseDTO login(UserLoginDTO loginDTO) {
        Authentication authentication = authenticationManager.authenticate(
                new UsernamePasswordAuthenticationToken(
                        loginDTO.getEmailOrUsername(),
                        loginDTO.getPassword()
                )
        );

        SecurityContextHolder.getContext().setAuthentication(authentication);
        String token = tokenProvider.generateToken(authentication);
        Long expiresIn = tokenProvider.getExpirationTime();

        // Obtener información del usuario desde el Authentication directamente
        String usernameOrEmail = authentication.getName();
        
        // Crear UserDTO directamente sin cargar el objeto User completo
        UserDTO userDTO = createUserDTOFromAuthentication(usernameOrEmail);

        return new JwtResponseDTO(token, expiresIn, userDTO);
    }
    
    private UserDTO createUserDTOFromAuthentication(String usernameOrEmail) {
        // Usar queries nativos para obtener solo los datos necesarios sin cargar relaciones
        UserDTO dto = new UserDTO();
        
        try {
            // Query nativo para obtener datos básicos del usuario
            @SuppressWarnings("unchecked")
            java.util.List<Object[]> userResult = entityManager.createNativeQuery(
                "SELECT id_usuario, nombre_usuario, email, created_at FROM Usuarios " +
                "WHERE email = ? OR nombre_usuario = ? LIMIT 1"
            )
            .setParameter(1, usernameOrEmail)
            .setParameter(2, usernameOrEmail)
            .getResultList();
            
            if (userResult.isEmpty()) {
                throw new ResourceNotFoundException("Usuario no encontrado");
            }
            
            Object[] userRow = userResult.get(0);
            Long userId = ((Number) userRow[0]).longValue();
            String username = (String) userRow[1];
            String email = (String) userRow[2];
            LocalDateTime fechaRegistro = userRow[3] != null ? 
                ((java.sql.Timestamp) userRow[3]).toLocalDateTime() : LocalDateTime.now();
            
            dto.setId(userId);
            dto.setUsername(username);
            dto.setEmail(email);
            dto.setFechaRegistro(fechaRegistro);
            
            // Query nativo para obtener el rol sin cargar relaciones
            @SuppressWarnings("unchecked")
            java.util.List<String> roleResult = entityManager.createNativeQuery(
                "SELECT r.nombre_rol FROM Roles r " +
                "INNER JOIN Usuario_Rol ur ON r.id_rol = ur.id_rol " +
                "WHERE ur.id_usuario = ? LIMIT 1"
            )
            .setParameter(1, userId)
            .getResultList();
            
            if (!roleResult.isEmpty()) {
                dto.setRole(roleResult.get(0));
            } else {
                dto.setRole("ROLE_USER");
            }
            
        } catch (Exception e) {
            throw new ResourceNotFoundException("Error al obtener datos del usuario: " + e.getMessage());
        }
        
        return dto;
    }

    public void logout() {
        SecurityContextHolder.clearContext();
    }

    public boolean validateToken(String token) {
        return tokenProvider.validateToken(token);
    }

    @Transactional
    public User getCurrentUser() {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        String usernameOrEmail = authentication.getName();
        // Usar método que carga roles explícitamente
        return userRepository.findByEmailOrUsernameWithRoles(usernameOrEmail)
                .orElseThrow(() -> new ResourceNotFoundException("Usuario no encontrado"));
    }

    private UserDTO convertToUserDTO(User user) {
        UserDTO dto = new UserDTO();
        dto.setId(user.getId());
        dto.setUsername(user.getUsername());
        dto.setEmail(user.getEmail());
        dto.setFechaRegistro(user.getFechaRegistro());
        
        // Obtener el primer rol de manera segura sin causar recursión
        if (user.getRoles() != null && !user.getRoles().isEmpty()) {
            try {
                Role firstRole = user.getRoles().iterator().next();
                if (firstRole != null && firstRole.getNombre() != null) {
                    dto.setRole(firstRole.getNombre());
                }
            } catch (Exception e) {
                // Si hay algún problema accediendo a los roles, usar un valor por defecto
                dto.setRole("ROLE_USER");
            }
        }
        
        return dto;
    }
}
