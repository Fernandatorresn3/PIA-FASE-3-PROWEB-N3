package com.recipes.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class DashboardDTO {
    private Integer totalUsuarios;
    private Integer totalRecetas;
    private Integer totalCategorias;
    private Integer totalComentariosPendientes;
    private Integer totalComentariosAprobados;
    private Integer totalRecetasDestacadas;
}
