package com.recipes.model;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;
import java.util.HashSet;
import java.util.Set;

@Entity
@Table(name = "Usuarios")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class User {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id_usuario")
    private Long id;

    @Column(name = "nombre_usuario", unique = true, nullable = false, length = 80)
    private String username;

    @Column(unique = true, nullable = false, length = 255)
    private String email;

    @Column(name = "contrasena", nullable = false, length = 255)
    private String passwordHash;

    @Column(name = "foto_perfil_url", length = 255)
    private String fotoPerfilUrl;

    @Column(name = "pais_residencia", length = 100)
    private String paisResidencia;

    @Column(name = "estado_residencia", length = 100)
    private String estadoResidencia;

    @Column(name = "puesto_cocina", length = 100)
    private String puestoCocina;

    @Column(name = "preferencia_categoria_receta", length = 100)
    private String preferenciaCategoriaReceta;

    @Column(name = "created_at", nullable = false, updatable = false)
    private LocalDateTime fechaRegistro;

    @Column(name = "updated_at")
    private LocalDateTime updatedAt;

    @ManyToMany(fetch = FetchType.EAGER)
    @JoinTable(
        name = "Usuario_Rol",
        joinColumns = @JoinColumn(name = "id_usuario"),
        inverseJoinColumns = @JoinColumn(name = "id_rol")
    )
    private Set<Role> roles = new HashSet<>();

    @OneToMany(mappedBy = "autor", cascade = CascadeType.ALL)
    private Set<Recipe> recetas = new HashSet<>();

    @OneToMany(mappedBy = "usuario", cascade = CascadeType.ALL)
    private Set<Comment> comentarios = new HashSet<>();

    @OneToMany(mappedBy = "usuario", cascade = CascadeType.ALL)
    private Set<Rating> calificaciones = new HashSet<>();

    @PrePersist
    protected void onCreate() {
        fechaRegistro = LocalDateTime.now();
        updatedAt = LocalDateTime.now();
    }

    @PreUpdate
    protected void onUpdate() {
        updatedAt = LocalDateTime.now();
    }
}
