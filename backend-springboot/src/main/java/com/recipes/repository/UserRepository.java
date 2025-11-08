package com.recipes.repository;

import com.recipes.model.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.jpa.repository.EntityGraph;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface UserRepository extends JpaRepository<User, Long> {
    
    /**
     * Carga usuario con roles usando EntityGraph para asegurar la carga de la relación
     */
    @EntityGraph(attributePaths = {"roles"})
    @Query("SELECT u FROM User u WHERE u.email = :emailOrUsername OR u.username = :emailOrUsername")
    Optional<User> findByEmailOrUsernameWithRoles(@Param("emailOrUsername") String emailOrUsername);
    
    @EntityGraph(attributePaths = {"roles"})
    @Query("SELECT u FROM User u WHERE u.id = :id")
    Optional<User> findById(@Param("id") Long id);
    
    @EntityGraph(attributePaths = {"roles"})
    Optional<User> findByEmail(String email);
    
    @EntityGraph(attributePaths = {"roles"})
    Optional<User> findByUsername(String username);
    
    Optional<User> findByEmailOrUsername(String email, String username);
    Boolean existsByEmail(String email);
    Boolean existsByUsername(String username);
}
