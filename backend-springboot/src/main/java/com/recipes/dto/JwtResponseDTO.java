package com.recipes.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class JwtResponseDTO {
    private String token;
    private String type = "Bearer";
    private Long expiresIn;
    private UserDTO user;

    public JwtResponseDTO(String token, Long expiresIn, UserDTO user) {
        this.token = token;
        this.expiresIn = expiresIn;
        this.user = user;
    }
}
