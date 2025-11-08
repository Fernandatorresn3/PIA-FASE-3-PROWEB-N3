package com.recipes.model;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.HashSet;
import java.util.Set;

@Entity
@Table(name = "Estados_Comentario")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class CommentStatus {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id_estado")
    private Long id;

    @Column(name = "nombre_estado", unique = true, nullable = false, length = 50)
    private String nombre;

    @OneToMany(mappedBy = "estado", cascade = CascadeType.ALL)
    private Set<Comment> comentarios = new HashSet<>();
}
