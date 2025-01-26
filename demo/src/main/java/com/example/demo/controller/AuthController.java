package com.example.demo.controller; // Your controller package

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.io.BufferedReader;
import java.io.FileNotFoundException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.List;
import java.util.stream.Collectors;

@RestController
@RequestMapping("/api/auth") // Base path for all methods in this controller
public class AuthController {

    // POST endpoint to handle login requests
    @PostMapping("/login")
    public ResponseEntity<Boolean> login(@RequestBody LoginRequest loginRequest) {
        return validateCredentials(loginRequest.getUser(), loginRequest.getPassword());
    }

    // GET endpoint to test login request (used for browser testing ko lang ito)
    @GetMapping("/login")
    public ResponseEntity<Boolean> testLogin(@RequestParam String user, @RequestParam String password) { // ganto itsura ng arguments ?user=admin&password=admin
        return validateCredentials(user, password);
    }

    // Method to validate user credentials against the CSV file
    private ResponseEntity<Boolean> validateCredentials(String user, String password) {
        InputStream inputStream = getClass().getClassLoader().getResourceAsStream("user_creds.csv");// Path to your CSV file kaya palitan neo to depende sa file path ng csv
        try {
            if (inputStream == null) {
                throw new FileNotFoundException("File not found in classpath");
            }
            List<String> lines = new BufferedReader(new InputStreamReader(inputStream))
                    .lines()
                    .collect(Collectors.toList());
            
            boolean firstLine = true; // Flag to track the first line
            for (String line : lines) {
                if (firstLine) {
                    firstLine = false; // Skip the first line kasi field names ung first line.
                    continue; // Go to the next iteration
                }

                String[] fields = line.split(","); // ["username", "password", "id"]
                if (fields.length >= 2 && fields[0].equals(user) && fields[1].equals(password)) { // Check for array bounds
//                    System.out.println("checkpoint");
                    return ResponseEntity.ok(true);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            return ResponseEntity.internalServerError().build(); // Important: Return an error response
        }
//        System.out.println("false checkpoint");
        return ResponseEntity.ok(false);
    }
}

// DTO for Login Request (used in POST body)
class LoginRequest {
    private String user;
    private String password;

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
}
