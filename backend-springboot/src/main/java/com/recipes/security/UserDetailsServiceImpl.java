package com.recipes.security;

import com.recipes.model.Role;
import com.recipes.model.User;
import com.recipes.repository.UserRepository;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Set;
import java.util.stream.Collectors;

@Service
public class UserDetailsServiceImpl implements UserDetailsService {

    private static final Logger log = LoggerFactory.getLogger(UserDetailsServiceImpl.class);

    @Autowired
    private UserRepository userRepository;

    @Override
    @Transactional(readOnly = true)
    public UserDetails loadUserByUsername(String usernameOrEmail) throws UsernameNotFoundException {
        log.info("Loading user: {}", usernameOrEmail);
        
        User user = userRepository.findByEmailOrUsernameWithRoles(usernameOrEmail)
                .orElseThrow(() -> new UsernameNotFoundException("User not found: " + usernameOrEmail));

        log.info("User found: id={}, username={}", user.getId(), user.getUsername());
        
        // Force initialization of the roles collection
        Set<Role> roles = user.getRoles();
        log.info("Roles collection type: {}", roles != null ? roles.getClass().getName() : "null");
        log.info("Roles collection size before iteration: {}", roles != null ? roles.size() : 0);
        
        // Force iteration to ensure all roles are loaded
        if (roles != null) {
            for (Role role : roles) {
                log.info("Found role: {} (id={})", role != null ? role.getNombre() : "null", role != null ? role.getId() : "null");
            }
        }
        
        if (roles == null || roles.isEmpty()) {
            log.error("User {} has no roles assigned", usernameOrEmail);
            throw new UsernameNotFoundException("User has no roles assigned: " + usernameOrEmail);
        }

        Set<GrantedAuthority> authorities = roles.stream()
                .map(role -> new SimpleGrantedAuthority(role.getNombre()))
                .collect(Collectors.toSet());

        log.info("Loaded user {} with {} roles and {} authorities", usernameOrEmail, roles.size(), authorities.size());

        return org.springframework.security.core.userdetails.User.builder()
                .username(user.getEmail()) // Use email as username for consistency
                .password(user.getPasswordHash())
                .authorities(authorities)
                .accountExpired(false)
                .accountLocked(false)
                .credentialsExpired(false)
                .disabled(false)
                .build();
    }
}
