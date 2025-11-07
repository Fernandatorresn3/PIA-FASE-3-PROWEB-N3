package com.recipes.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class ProfileDTO {
    private Long id;
    private String username;
    private String email;
    private String nombre;
    private String apellido;
    private LocalDateTime fechaRegistro;
    private Integer totalRecetas;
    private Integer totalComentarios;
    private Integer totalCalificaciones;
}
