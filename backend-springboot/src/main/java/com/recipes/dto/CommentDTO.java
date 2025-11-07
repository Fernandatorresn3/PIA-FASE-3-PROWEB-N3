package com.recipes.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class CommentDTO {
    private Long id;
    private String contenido;
    private LocalDateTime fechaCreacion;
    private String usuarioNombre;
    private Long usuarioId;
    private Long recetaId;
    private String recetaTitulo;
    private String estadoNombre;
    private Long estadoId;
}
