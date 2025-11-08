package com.recipes.model;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.io.Serializable;
import java.util.Objects;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class FeaturedRecipeId implements Serializable {
    
    private Long idUsuario;
    private Long idReceta;

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        FeaturedRecipeId that = (FeaturedRecipeId) o;
        return Objects.equals(idUsuario, that.idUsuario) &&
               Objects.equals(idReceta, that.idReceta);
    }

    @Override
    public int hashCode() {
        return Objects.hash(idUsuario, idReceta);
    }
}
