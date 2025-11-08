package com.recipes.service;

import com.recipes.dto.*;
import com.recipes.exception.ResourceNotFoundException;
import com.recipes.model.Role;
import com.recipes.model.User;
import com.recipes.repository.RoleRepository;
import com.recipes.repository.UserRepository;
import com.recipes.security.JwtTokenProvider;
import lombok.RequiredArgsConstructor;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

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

        User user = userRepository.findByEmailOrUsername(loginDTO.getEmailOrUsername(), loginDTO.getEmailOrUsername())
                .orElseThrow(() -> new ResourceNotFoundException("Usuario no encontrado"));

        UserDTO userDTO = convertToUserDTO(user);

        return new JwtResponseDTO(token, expiresIn, userDTO);
    }

    public void logout() {
        SecurityContextHolder.clearContext();
    }

    public boolean validateToken(String token) {
        return tokenProvider.validateToken(token);
    }

    public User getCurrentUser() {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        String username = authentication.getName();
        return userRepository.findByUsername(username)
                .orElseThrow(() -> new ResourceNotFoundException("Usuario no encontrado"));
    }

    private UserDTO convertToUserDTO(User user) {
        UserDTO dto = new UserDTO();
        dto.setId(user.getId());
        dto.setUsername(user.getUsername());
        dto.setEmail(user.getEmail());
        
        if (!user.getRoles().isEmpty()) {
            dto.setRole(user.getRoles().iterator().next().getNombre());
        }
        
        return dto;
    }
}
