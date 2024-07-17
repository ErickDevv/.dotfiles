package com.example.security;

import java.util.Set;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.CommandLineRunner;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.annotation.Bean;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;

import com.example.security.entity.PermissionEntity;
import com.example.security.entity.RoleEntity;
import com.example.security.entity.RoleEnum;
import com.example.security.entity.UserEntity;
import com.example.security.repository.UserRepository;

@SpringBootApplication
public class SecurityApplication {

	@Autowired
	UserRepository userRepository;

	public static void main(String[] args) {
		SpringApplication.run(SecurityApplication.class, args);
	}

	// CRYPT PASSWORD
	public static String crypt(String password) {
		return new BCryptPasswordEncoder().encode(password);
	}

	@Bean
	CommandLineRunner init() {
		return args -> {
			PermissionEntity readPermission = PermissionEntity.builder()
					.name("READ")
					.build();

			PermissionEntity writePermission = PermissionEntity.builder()
					.name("WRITE")
					.build();

			RoleEntity adminRole = RoleEntity.builder()
					.roleEnum(RoleEnum.ADMIN)
					.permissionList(Set.of(readPermission, writePermission))
					.build();

			RoleEntity developerRole = RoleEntity.builder()
					.roleEnum(RoleEnum.DEVELOPER)
					.permissionList(Set.of(readPermission, writePermission))
					.build();

			RoleEntity userRole = RoleEntity.builder()
					.roleEnum(RoleEnum.USER)
					.permissionList(Set.of(readPermission))
					.build();

			UserEntity pepe = UserEntity.builder()
					.username("pepe")
					.password(crypt("pepe"))
					.isEnabled(true)
					.accountNoExpired(true)
					.credentialNoExpired(true)
					.accountNoLocked(true)
					.roles(Set.of(adminRole))
					.build();

			UserEntity santiago = UserEntity.builder()
					.username("santiago")
					.password(crypt("santiago"))
					.isEnabled(true)
					.accountNoExpired(true)
					.credentialNoExpired(true)
					.accountNoLocked(true)
					.roles(Set.of(developerRole))
					.build();

			UserEntity rogelio = UserEntity.builder()
					.username("rogelio")
					.password(crypt("rogelio"))
					.isEnabled(true)
					.accountNoExpired(true)
					.credentialNoExpired(true)
					.accountNoLocked(true)
					.roles(Set.of(userRole))
					.build();

			userRepository.saveAll(Set.of(pepe, santiago, rogelio));
		};
	}

}
