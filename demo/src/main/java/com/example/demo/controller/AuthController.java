package com.example.demo.controller; // Your controller package

import org.apache.juli.logging.Log;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import com.fasterxml.jackson.annotation.JsonProperty;


import java.io.*;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.List;
import java.util.stream.Collectors;

@RestController
@RequestMapping("/api/auth") // Base path for all methods in this controller
public class AuthController {
    private static final String USER_CREDENTIALS_FILE = "src/main/data/user_creds.csv"; // New writable location

    // POST endpoint for login request
    @PostMapping("/login")
    public ResponseEntity<LoginRequest> login(@RequestBody LoginRequest loginRequest) {
        return validateCredentials(loginRequest.getUser(), loginRequest.getPassword());
    }

    // GET endpoint for testing login via browser (e.g., ?user=admin&password=admin)
    @GetMapping("/login")
    public ResponseEntity<LoginRequest> testLogin(@RequestParam String user, @RequestParam String password) {
        return validateCredentials(user, password);
    }

    // Method to validate user credentials from CSV
    private ResponseEntity<LoginRequest> validateCredentials(String user, String password) {
        File file = new File(USER_CREDENTIALS_FILE);
        if (!file.exists()) {
            return ResponseEntity.status(404).build(); // Return 404 if file is missing
        }

        try {
            List<String> lines = Files.readAllLines(Paths.get(USER_CREDENTIALS_FILE), StandardCharsets.UTF_8);
            boolean firstLine = true; // Skip headers

            for (String line : lines) {
                if (firstLine) {
                    firstLine = false;
                    continue;
                }

                String[] fields = line.split(","); // [username, password, id]
                if (fields.length >= 3 && fields[0].equals(user) && fields[1].equals(password)) {
                    return ResponseEntity.ok(new LoginRequest(fields[0], fields[1], fields[2]));
                }
            }
        } catch (IOException e) {
            e.printStackTrace();
            return ResponseEntity.internalServerError().build();
        }

        return ResponseEntity.status(HttpStatus.NOT_FOUND).build(); // Return 404 if credentials are invalid
    }
}

// DTO for Login Request (used in POST body)
class LoginRequest {
    private String user;
    private String password;
    private String id;


    public LoginRequest(String user_in, String password_in, String id_in){
        this.user = user_in;
        this.password = password_in;
        this.id = id_in;
    }

    // Getters and setters
    public String getUser() {
        return user;
    }

    public void setUser(String user) {
        this.user = user;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }
}
