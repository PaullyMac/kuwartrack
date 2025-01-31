package com.example.demo.controller;

import org.apache.catalina.User;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import com.fasterxml.jackson.annotation.JsonProperty;


import java.io.BufferedReader;
import java.io.FileNotFoundException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.stream.Collectors;

@RestController
@RequestMapping("/api/auth")
public class dataController {

    // GET endpoint to test login request (used for browser testing ko lang ito)
    @GetMapping("/get_data")
    public ResponseEntity<List<List<String>>> testGetData(@RequestParam String user_id) { // ganto itsura ng arguments ?user=admin&password=admin
        return getExpenses(user_id);
    }

    // GET endpoint to test login request (used for browser testing ko lang ito)
    @PostMapping("/post_data")
    public ResponseEntity<List<List<String>>> GetData(@RequestBody UserRequest userRequest) { // ganto itsura ng arguments ?user=admin&password=admin
        System.out.println("here?");
        return getExpenses(userRequest.getUserId());
    }

    // Method to validate user credentials against the CSV file
    private ResponseEntity<List<List<String>>> getExpenses(String user_id) {

        List<List<String>> rows  =new ArrayList<List<String>>();

        String filePath = user_id + "/" + "expenses.csv";

        InputStream inputStream = getClass().getClassLoader().getResourceAsStream(filePath);// Path to your CSV file kaya palitan neo to depende sa file path ng csv
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

                String[] fields = line.split(","); // [category,expense,spent,date]
                rows.add(Arrays.asList(fields));
            }

            return ResponseEntity.ok(rows);
        } catch (Exception e) {
            e.printStackTrace();
            return ResponseEntity.internalServerError().build(); // Important: Return an error response
        }
//        System.out.println("false checkpoint");
//        return ResponseEntity.ok(rows);
    }

}

// DTO for User Request (used in POST body)
class UserRequest {
    @JsonProperty("user_id")
    private String user_id;

    // No-argument constructor
    public UserRequest() {}

    // Parameterized constructor
    public UserRequest(String in_user_id) {
        this.user_id = in_user_id;
    }

    // Getters and setters
    public String getUserId() {
        return user_id;
    }

    public void setUserId(String user_id) {
        this.user_id = user_id;
    }
}



