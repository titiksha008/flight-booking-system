package com.flightbooking.fbs.controller;

import com.flightbooking.fbs.entity.User;
import com.flightbooking.fbs.services.UserService;
import org.springframework.web.bind.annotation.*;

import java.util.Optional;

@RestController
@RequestMapping("/api/users")
public class UserController {

    private final UserService userService;

    public UserController(UserService userService) {
        this.userService = userService;
    }

    // Register new user
    @PostMapping("/register")
    public User registerUser(@RequestBody User user) {
        return userService.registerUser(user);
    }

    // Get user by ID
    @GetMapping("/{id}")
    public Optional<User> getUserById(@PathVariable Long id) {
        return userService.getUserById(id);
    }

    // Get user by email
    @GetMapping("/email/{email}")
    public Optional<User> getUserByEmail(@PathVariable String email) {

        return userService.getUserByEmail(email);
    }
}