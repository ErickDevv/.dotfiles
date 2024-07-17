package com.example.security.service;

import java.util.ArrayList;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.userdetails.User;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;
import com.example.security.entity.UserEntity;
import com.example.security.repository.UserRepository;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import java.util.List;

@Service
public class UserDetailServiceImpl implements UserDetailsService {

    @Autowired
    UserRepository userRepository;

    @Override
    public UserDetails loadUserByUsername(String username) throws UsernameNotFoundException {

        UserEntity user = userRepository.findUserEntityByUsername(username)
                .orElseThrow(() -> new UsernameNotFoundException("User not found"));

        // CREATING A LIST OF SIMPLEGRANTEDAUTHORITY
        List<SimpleGrantedAuthority> authorities = new ArrayList();

        // TRANSFORMING ROLES TO SIMPLEGRANTEDAUTHORITY
        user.getRoles().forEach(role -> {
            authorities.add(new SimpleGrantedAuthority("ROLE_".concat(role.getRoleEnum().name())));
        });

        // TRANSFORMING PERMISSIONS TO SIMPLEGRANTEDAUTHORITY
        user.getRoles().forEach(role -> {
            role.getPermissionList().forEach(permission -> {
                authorities.add(new SimpleGrantedAuthority(permission.getName()));
            });
        });

        return new User(user.getUsername(), user.getPassword(), user.isEnabled(), user.isAccountNoExpired(),
                user.isCredentialNoExpired(), user.isAccountNoExpired(), authorities);
    }
}
