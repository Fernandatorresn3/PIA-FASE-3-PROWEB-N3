package com.recipes.model;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

@Entity
@Table(name = "recetas_destacadas")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class FeaturedRecipe {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "receta_id", nullable = false)
    private Recipe receta;

    @Column(name = "fecha_destacado")
    private LocalDateTime fechaDestacado;

    @Column(nullable = false)
    private Boolean activo = true;

    @PrePersist
    protected void onCreate() {
        fechaDestacado = LocalDateTime.now();
        if (activo == null) {
            activo = true;
        }
    }
}
