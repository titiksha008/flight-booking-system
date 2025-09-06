package com.flightbooking.fbs.controller;

import com.flightbooking.fbs.entity.Flight;
import com.flightbooking.fbs.services.FlightService;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Optional;

@RestController
@RequestMapping("/api/flights")
public class FlightController {

    private final FlightService flightService;

    public FlightController(FlightService flightService) {
        this.flightService = flightService;
    }

    // Add flight
    @PostMapping
    public Flight addFlight(@RequestBody Flight flight) {
        return flightService.addFlight(flight);
    }

    // Update flight
    @PutMapping("/{id}")
    public Flight updateFlight(@PathVariable Long id, @RequestBody Flight flightDetails) {
        return flightService.updateFlight(id, flightDetails);
    }

    // Delete flight
    @DeleteMapping("/{id}")
    public void deleteFlight(@PathVariable Long id) {
        flightService.deleteFlight(id);
    }

    // Get all flights
    @GetMapping
    public List<Flight> getAllFlights() {
        return flightService.getAllFlights();
    }

    // Get flight by ID
    @GetMapping("/{id}")
    public Optional<Flight> getFlightById(@PathVariable Long id) {
        return flightService.getFlightById(id);
    }

    // Search flights (by source, destination, date)
    @GetMapping("/search")

    public List<Flight> searchFlights(@RequestParam String source,
                                      @RequestParam String destination) {
        return flightService.searchFlights(source, destination);
    }

}