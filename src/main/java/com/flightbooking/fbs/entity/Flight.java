package com.flightbooking.fbs.entity;

import jakarta.persistence.*;   // ✅ for JPA annotations
import lombok.*;               // ✅ if using Lombok

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
@Entity
@Table(name = "flights")
public class Flight {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "flight_number")
    private String flightNumber;

    @Column(name = "airline")
    private String airline;

    @Column(name = "source")
    private String source;

    @Column(name = "destination")
    private String destination;

    @Column(name = "departure_time")
    private String departureTime;

    @Column(name = "arrival_time")
    private String arrivalTime;

    @Column(name = "available_seats")
    private int availableSeats;

    @Column(name = "price")
    private double price;

    @Column(name = "total_seats", nullable = false)
    private int totalSeats;


}
