package com.recipes.repository;

import com.recipes.model.Role;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface RoleRepository extends JpaRepository<Role, Long> {
    Optional<Role> findByNombre(String nombre);
    
    @Query(value = "SELECT r.* FROM Roles r INNER JOIN Usuario_Rol ur ON r.id_rol = ur.id_rol WHERE ur.id_usuario = :userId LIMIT 1", nativeQuery = true)
    Optional<Role> findFirstByUserId(@Param("userId") Long userId);
}
