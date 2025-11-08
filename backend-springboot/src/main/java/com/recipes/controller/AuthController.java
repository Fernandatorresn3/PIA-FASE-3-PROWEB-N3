package com.recipes.controller;

import com.recipes.dto.JwtResponseDTO;
import com.recipes.dto.UserDTO;
import com.recipes.dto.UserLoginDTO;
import com.recipes.dto.UserRegistrationDTO;
import com.recipes.model.User;
import com.recipes.service.AuthService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.Map;

@RestController
@RequestMapping("/api/auth")
@CrossOrigin(origins = "*")
@RequiredArgsConstructor
public class AuthController {

    private final AuthService authService;

    @PostMapping("/register")
    public ResponseEntity<JwtResponseDTO> register(@RequestBody UserRegistrationDTO registrationDTO) {
        JwtResponseDTO response = authService.register(registrationDTO);
        return ResponseEntity.ok(response);
    }

    @PostMapping("/login")
    public ResponseEntity<JwtResponseDTO> login(@RequestBody UserLoginDTO loginDTO) {
        JwtResponseDTO response = authService.login(loginDTO);
        return ResponseEntity.ok(response);
    }

    @PostMapping("/logout")
    public ResponseEntity<Void> logout() {
        authService.logout();
        return ResponseEntity.ok().build();
    }

    @GetMapping("/validate")
    public ResponseEntity<Map<String, Object>> validateToken() {
        User user = authService.getCurrentUser();
        
        Map<String, Object> response = new HashMap<>();
        response.put("valid", true);
        
        Map<String, Object> userInfo = new HashMap<>();
        userInfo.put("id", user.getId());
        userInfo.put("username", user.getUsername());
        if (!user.getRoles().isEmpty()) {
            userInfo.put("role", user.getRoles().iterator().next().getNombre());
        }
        
        response.put("user", userInfo);
        
        return ResponseEntity.ok(response);
    }
}
