package com.example.demo;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

import org.springframework.web.bind.annotation.*;

@SpringBootApplication
@RestController
public class DemoApplication {

	public static void main(String[] args) {
		SpringApplication.run(DemoApplication.class, args);
	}

	@GetMapping("/hello")
	public String sayHello() {
		return "Hello, World!";
	}












//	@GetMapping("/user")
//	public ResponseEntity<List<List<String>>> getCsvData() throws IOException {
//		String filePath = "C:\\Users\\RJ\\Downloads\\user_creds.csv"; // Path to your CSV file
//		BufferedReader reader = null;
//		String line = "";
//
//		List<List<String>> rows = new ArrayList<>();
//
//		try {
//			reader = new BufferedReader(new FileReader(filePath));
//			while((line = reader.readLine()) != null){ // continue to read the next line
//
//				String[] rowArray  = line.split(","); // user, password, id
//
//				// Convert String[] to List<String>
//				List<String> rowList = Arrays.asList(rowArray); // Creates a fixed-size list
//
//				// Or, for a mutable list (recommended):
//				// List<String> rowList = new ArrayList<>(Arrays.asList(rowArray));
//
//				rows.add(rowList);
//
//				for(String index : rowArray){
//					System.out.printf("%-10s", index);
//				}
//				System.out.println();
// 			}
//		}
//		catch(Exception e){
//
//		}
//		finally {
//			try{
//				reader.close();
//			} catch (IOException e) {
//				throw new RuntimeException(e);
//			}
//		}
//
//		return ResponseEntity.ok(rows);
//	}
}



