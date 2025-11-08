package com.recipes.model;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;
import java.util.HashSet;
import java.util.Set;

@Entity
@Table(name = "Recetas")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class Recipe {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id_receta")
    private Long id;

    @Column(name = "nombre_receta", nullable = false, length = 70)
    private String titulo;

    @Column(name = "descripcion_corta", length = 200)
    private String descripcion;

    @Column(name = "ingredientes_text", columnDefinition = "TEXT")
    private String ingredientes;

    @Column(name = "pasos", columnDefinition = "JSON")
    private String instrucciones;

    @Column(name = "pais_origen", length = 100)
    private String paisOrigen;

    @Column(name = "image_url", length = 255)
    private String imagenUrl;

    @Column(name = "puntuacion_promedio")
    private Float puntuacionPromedio;

    @Column(name = "fecha_creacion", nullable = false, updatable = false)
    private LocalDateTime fechaCreacion;

    @Column(name = "updated_at", nullable = false)
    private LocalDateTime updatedAt;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "id_usuario_admin", nullable = false)
    private User autor;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "id_categoria")
    private Category categoria;

    @OneToMany(mappedBy = "receta", cascade = CascadeType.ALL)
    private Set<Comment> comentarios = new HashSet<>();

    @OneToMany(mappedBy = "receta", cascade = CascadeType.ALL)
    private Set<Rating> calificaciones = new HashSet<>();

    @OneToMany(mappedBy = "receta", cascade = CascadeType.ALL)
    private Set<FeaturedRecipe> destacados = new HashSet<>();

    @PrePersist
    protected void onCreate() {
        fechaCreacion = LocalDateTime.now();
        updatedAt = LocalDateTime.now();
    }

    @PreUpdate
    protected void onUpdate() {
        updatedAt = LocalDateTime.now();
    }
}
