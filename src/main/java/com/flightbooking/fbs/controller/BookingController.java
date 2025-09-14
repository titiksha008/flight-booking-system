package com.flightbooking.fbs.controller;

import com.flightbooking.fbs.entity.Booking;
import com.flightbooking.fbs.services.BookingService;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/bookings")
public class BookingController {

    private final BookingService bookingService;

    public BookingController(BookingService bookingService) {
        this.bookingService = bookingService;
    }

    // ✅ Book a flight
    @PostMapping("/book")
    public ResponseEntity<String> bookFlight(
            @RequestParam(required = false) Long userId,
            @RequestParam(required = false) String userName,
            @RequestParam(required = false) Long flightId,
            @RequestParam(required = false) String flightNumber,
            @RequestParam int seatsBooked) {

        if ((userId == null && (userName == null || userName.isBlank())) ||
                (flightId == null && (flightNumber == null || flightNumber.isBlank()))) {
            return ResponseEntity.badRequest().body("❌ User or Flight details are missing!");
        }

        Booking booking = bookingService.bookFlight(userId, userName, flightId, flightNumber, seatsBooked);
        return ResponseEntity.status(HttpStatus.CREATED)
                .body("✅ Booking confirmed! Your booking ID is: " + booking.getId());
    }

    // ✅ Cancel booking
    @DeleteMapping("/cancel/{id}")
    public ResponseEntity<String> cancelBooking(@PathVariable Long id) {
        boolean cancelled = bookingService.cancelBooking(id);
        if (cancelled) {
            return ResponseEntity.ok("🛑 Booking with ID " + id + " cancelled successfully.");
        } else {
            return ResponseEntity.status(HttpStatus.NOT_FOUND)
                    .body("❌ Booking with ID " + id + " not found.");
        }
    }

    // ✅ Get all bookings
    @GetMapping
    public ResponseEntity<?> getAllBookings() {
        List<Booking> bookings = bookingService.getAllBookings();
        if (bookings.isEmpty()) {
            return ResponseEntity.status(HttpStatus.NO_CONTENT)
                    .body("⚠️ No bookings available.");
        }
        return ResponseEntity.ok(bookings);
    }

    // ✅ Get booking by ID
    @GetMapping("/{id}")
    public ResponseEntity<?> getBookingById(@PathVariable Long id) {
        return bookingService.getBookingById(id)
                .<ResponseEntity<?>>map(ResponseEntity::ok)
                .orElseGet(() -> ResponseEntity.status(HttpStatus.NOT_FOUND)
                        .body("❌ Booking with ID " + id + " not found."));
    }
}
