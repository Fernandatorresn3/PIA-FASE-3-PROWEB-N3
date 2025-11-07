package com.recipes.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class RecipeDTO {
    private Long id;
    private String titulo;
    private String descripcion;
    private String ingredientes;
    private String instrucciones;
    private Integer tiempoPreparacion;
    private Integer porciones;
    private String imagenUrl;
    private LocalDateTime fechaCreacion;
    private String autorNombre;
    private Long autorId;
    private String categoriaNombre;
    private Long categoriaId;
    private Double calificacionPromedio;
    private Integer totalCalificaciones;
    private Integer totalComentarios;
}
