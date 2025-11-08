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
    @Transactional
    public UserDetails loadUserByUsername(String usernameOrEmail) throws UsernameNotFoundException {
        log.info("Searching for user: {}", usernameOrEmail);
        User user = userRepository.findByEmailOrUsername(usernameOrEmail)
                .orElseThrow(() -> new UsernameNotFoundException("User not found with username or email: " + usernameOrEmail));

        log.info("User found: id={}, email={}, username={}", user.getId(), user.getEmail(), user.getUsername());
        
        // Force initialization of roles by accessing the collection
        Set<Role> roles = user.getRoles();
        log.info("Roles collection initialized: {}", roles != null);
        log.info("Roles collection size: {}", roles.size());
        
        // Explicitly iterate to force lazy loading
        roles.forEach(role -> log.info("Role: {}", role.getNombre()));
        
        if (roles.isEmpty()) {
            log.warn("User {} has no roles assigned!", usernameOrEmail);
        }

        Set<GrantedAuthority> authorities = roles.stream()
                .map(role -> new SimpleGrantedAuthority(role.getNombre()))
                .collect(Collectors.toSet());

        log.info("Created {} authorities", authorities.size());
        authorities.forEach(auth -> log.info("Authority: {}", auth.getAuthority()));

        return org.springframework.security.core.userdetails.User.builder()
                .username(usernameOrEmail)
                .password(user.getPasswordHash())
                .authorities(authorities)
                .accountExpired(false)
                .accountLocked(false)
                .credentialsExpired(false)
                .disabled(false)
                .build();
    }
}
