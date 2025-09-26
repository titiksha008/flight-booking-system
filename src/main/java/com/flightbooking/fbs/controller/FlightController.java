package com.flightbooking.fbs.controller;

import com.flightbooking.fbs.entity.Flight;
import com.flightbooking.fbs.services.FlightService;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import jakarta.validation.Valid;
import java.util.List;
import java.util.Optional;
import java.util.Map;
import java.util.HashMap;


@RestController
@RequestMapping("/api/flights")
public class FlightController {

    private final FlightService flightService;

    public FlightController(FlightService flightService) {
        this.flightService = flightService;
    }

    // ✅ Add new flight
    @PostMapping
    public ResponseEntity<Map<String, Object>> addFlight(@Valid @RequestBody Flight flight) {
        Flight savedFlight = flightService.addFlight(flight);

        Map<String, Object> response = new HashMap<>();
        response.put("message", "Flight added successfully!");
        response.put("id", savedFlight.getId());          // Flight ID
        response.put("flightNumber", savedFlight.getFlightNumber());
        response.put("airline", savedFlight.getAirline());
        return ResponseEntity.status(HttpStatus.CREATED).body(response);
    }


    // ✅ Update existing flight
    @PutMapping("/{id}")
    public ResponseEntity<Map<String, Object>> updateFlight(@PathVariable Long id, @Valid @RequestBody Flight flightDetails) {
        Flight updatedFlight = flightService.updateFlight(id, flightDetails);
        if (updatedFlight != null) {
            Map<String, Object> response = new HashMap<>();
            response.put("message", "Flight updated successfully!");
            response.put("id", updatedFlight.getId());
            response.put("flightNumber", updatedFlight.getFlightNumber());
            response.put("airline", updatedFlight.getAirline());
            return ResponseEntity.ok(response);
        } else {
            Map<String, Object> response = new HashMap<>();
            response.put("message", "Flight with ID " + id + " not found ❌");
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body(response);
        }
    }

    // ✅ Delete flight
    @DeleteMapping("/{id}")
    public ResponseEntity<String> deleteFlight(@PathVariable Long id) {
        boolean deleted = flightService.deleteFlight(id);
        if (deleted) {
            return ResponseEntity.ok("🗑️ Flight with ID " + id + " deleted successfully!");
        } else {
            return ResponseEntity.status(HttpStatus.NOT_FOUND)
                    .body("❌ Flight with ID " + id + " not found.");
        }
    }

    // ✅ Get all flights
    @GetMapping
    public ResponseEntity<?> getAllFlights() {
        List<Flight> flights = flightService.getAllFlights();
        if (flights.isEmpty()) {
            return ResponseEntity.status(HttpStatus.NO_CONTENT)
                    .body("⚠️ No flights available.");
        }
        return ResponseEntity.ok(flights);
    }

    // ✅ Get flight by ID
    @GetMapping("/{id}")
    public ResponseEntity<?> getFlightById(@PathVariable Long id) {
        Optional<Flight> flight = flightService.getFlightById(id);
        return flight.<ResponseEntity<?>>map(ResponseEntity::ok)
                .orElseGet(() -> ResponseEntity.status(HttpStatus.NOT_FOUND)
                        .body("❌ Flight with ID " + id + " not found."));
    }

    // ✅ Search flights (by source + destination)
    @GetMapping("/search")
    public ResponseEntity<?> searchFlights(@RequestParam String source,
                                           @RequestParam String destination) {
        List<Flight> flights = flightService.searchFlights(source, destination);
        if (flights.isEmpty()) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND)
                    .body("⚠️ No flights found from " + source + " to " + destination + ".");
        }
        return ResponseEntity.ok(flights);
    }
}
