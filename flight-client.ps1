# # Flight Booking System Terminal Client
#
# # Base URL
# $baseUrl = "http://localhost:8081"
#
# # Define endpoints
# $endpoints = @(
#     @{method="GET"; url="/api/flights"; description="View all flights"},
#     @{method="GET"; url="/api/flights/{id}"; description="View flight by ID"},
#     @{method="GET"; url="/api/flights/search?source=Delhi&destination=Mumbai"; description="Search flights"},
#     @{method="POST"; url="/api/flights"; description="Add a new flight"},
#     @{method="PUT"; url="/api/flights/{id}"; description="Update flight by ID"},
#     @{method="DELETE"; url="/api/flights/{id}"; description="Delete a flight"},
#     @{method="GET"; url="/h2-console"; description="Open H2 Database Console"}
# )
#
# # Welcome message
# Write-Host "Welcome to the Flight Booking System API ✈️" -ForegroundColor Cyan
# Write-Host ""
#
# # Show all endpoints
# Write-Host "Available endpoints:" -ForegroundColor Yellow
# foreach ($ep in $endpoints) {
#     $method = $ep.method.PadRight(6)
#     $url = $ep.url.PadRight(50)
#     Write-Host "$method $url -> $($ep.description)"
# }
# Write-Host ""
#
# # Main loop
# while ($true) {
#     Write-Host ""
#     $choice = Read-Host "Enter method (GET, POST, PUT, DELETE) or 'exit' to quit"
#
#     if ($choice -eq "exit") { break }
#
#     switch ($choice.ToUpper()) {
#         "GET" {
#             $id = Read-Host "Enter flight ID (leave blank to get all flights)"
#             if ([string]::IsNullOrEmpty($id)) {
#                 $url = "$baseUrl/api/flights"
#             } else {
#                 $url = "$baseUrl/api/flights/$id"
#             }
#             try {
#                 $res = Invoke-RestMethod -Uri $url -Method GET
#                 $res | ConvertTo-Json -Depth 10
#             } catch {
#                 Write-Host "Error: $($_.Exception.Message)" -ForegroundColor Red
#             }
#         }
#
#         "POST" {
#             Write-Host "Enter new flight details:"
#             $flightNumber = Read-Host "Flight Number"
#             $source = Read-Host "Source"
#             $destination = Read-Host "Destination"
#             $departureTime = Read-Host "Departure Time (YYYY-MM-DDTHH:MM:SS)"
#             $price = Read-Host "Price"
#
#             $body = @{
#                 flightNumber = $flightNumber
#                 source = $source
#                 destination = $destination
#                 departureTime = $departureTime
#                 price = [double]$price
#             } | ConvertTo-Json
#
#             try {
#                 $res = Invoke-RestMethod -Uri "$baseUrl/api/flights" -Method POST -ContentType "application/json" -Body $body
#                 Write-Host "Flight added successfully:" -ForegroundColor Green
#                 $res | ConvertTo-Json -Depth 10
#             } catch {
#                 Write-Host "Error: $($_.Exception.Message)" -ForegroundColor Red
#             }
#         }
#
#         "PUT" {
#             $id = Read-Host "Enter flight ID to update"
#             Write-Host "Enter updated flight details:"
#             $flightNumber = Read-Host "Flight Number"
#             $source = Read-Host "Source"
#             $destination = Read-Host "Destination"
#             $departureTime = Read-Host "Departure Time (YYYY-MM-DDTHH:MM:SS)"
#             $price = Read-Host "Price"
#
#             $body = @{
#                 flightNumber = $flightNumber
#                 source = $source
#                 destination = $destination
#                 departureTime = $departureTime
#                 price = [double]$price
#             } | ConvertTo-Json
#
#             try {
#                 $res = Invoke-RestMethod -Uri "$baseUrl/api/flights/$id" -Method PUT -ContentType "application/json" -Body $body
#                 Write-Host "Flight updated successfully:" -ForegroundColor Green
#                 $res | ConvertTo-Json -Depth 10
#             } catch {
#                 Write-Host "Error: $($_.Exception.Message)" -ForegroundColor Red
#             }
#         }
#
#         "DELETE" {
#             $id = Read-Host "Enter flight ID to delete"
#             try {
#                 $res = Invoke-RestMethod -Uri "$baseUrl/api/flights/$id" -Method DELETE
#                 Write-Host "Flight deleted successfully." -ForegroundColor Green
#             } catch {
#                 Write-Host "Error: $($_.Exception.Message)" -ForegroundColor Red
#             }
#         }
#
#         Default {
#             Write-Host "Invalid choice! Enter GET, POST, PUT, DELETE or exit." -ForegroundColor Red
#         }
#     }
# }


# Flight Booking System Terminal Client

$baseUrl = "http://localhost:8081"

# Welcome
Write-Host "Welcome to the Flight Booking System API ✈️" -ForegroundColor Cyan
Write-Host ""

# Show available endpoints
Write-Host "Available endpoints:" -ForegroundColor Yellow
$endpoints = @(
    # Flights
    @{method="GET"; url="/api/flights"; description="View all flights"},
    @{method="GET"; url="/api/flights/{id}"; description="View flight by ID"},
    @{method="GET"; url="/api/flights/search?source={source}&destination={destination}"; description="Search flights"},
    @{method="POST"; url="/api/flights"; description="Add a new flight"},
    @{method="PUT"; url="/api/flights/{id}"; description="Update flight by ID"},
    @{method="DELETE"; url="/api/flights/{id}"; description="Delete a flight"},
    # Bookings
    @{method="GET"; url="/api/bookings"; description="View all bookings"},
    @{method="GET"; url="/api/bookings/{id}"; description="View booking by ID"},
    @{method="POST"; url="/api/bookings/book?userId={userId}&flightId={flightId}"; description="Book a flight"},
    @{method="DELETE"; url="/api/bookings/cancel/{id}"; description="Cancel a booking"},
    # Users
    @{method="POST"; url="/api/users/register"; description="Register a new user"},
    @{method="GET"; url="/api/users/{id}"; description="Get user by ID"},
    @{method="GET"; url="/api/users/email/{email}"; description="Get user by email"}
)

foreach ($ep in $endpoints) {
    $method = $ep.method.PadRight(6)
    $url = $ep.url.PadRight(60)
    Write-Host "$method $url -> $($ep.description)"
}
Write-Host ""

# Main loop
while ($true) {
    Write-Host ""
    $choice = Read-Host "Enter resource (FLIGHT, BOOKING, USER) or 'exit' to quit"

    if ($choice -eq "exit") { break }

    switch ($choice.ToUpper()) {
        "FLIGHT" {
            $action = Read-Host "Enter action (GET, POST, PUT, DELETE)"
            switch ($action.ToUpper()) {
                "GET" {
                    $id = Read-Host "Enter flight ID (leave blank for all)"
                    if ([string]::IsNullOrEmpty($id)) { $url = "$baseUrl/api/flights" }
                    else { $url = "$baseUrl/api/flights/$id" }
                    Invoke-RestMethod -Uri $url -Method GET | ConvertTo-Json -Depth 10
                }
                "POST" {
                    $flightNumber = Read-Host "Flight Number"
                    $source = Read-Host "Source"
                    $destination = Read-Host "Destination"
                    $departureTime = Read-Host "Departure Time (YYYY-MM-DDTHH:MM:SS)"
                    $arrivalTime = Read-Host "Arrival Time (YYYY-MM-DDTHH:MM:SS)"
                    $seats = Read-Host "Available Seats"
                    $price = Read-Host "Price"

                    $body = @{
                        flightNumber = $flightNumber
                        source = $source
                        destination = $destination
                        departureTime = $departureTime
                        arrivalTime = $arrivalTime
                        availableSeats = [int]$seats
                        price = [double]$price
                    } | ConvertTo-Json

                    Invoke-RestMethod -Uri "$baseUrl/api/flights" -Method POST -ContentType "application/json" -Body $body
                    Write-Host "Flight added successfully." -ForegroundColor Green
                }
                "PUT" {
                    $id = Read-Host "Flight ID to update"
                    $flightNumber = Read-Host "Flight Number"
                    $source = Read-Host "Source"
                    $destination = Read-Host "Destination"
                    $departureTime = Read-Host "Departure Time (YYYY-MM-DDTHH:MM:SS)"
                    $arrivalTime = Read-Host "Arrival Time (YYYY-MM-DDTHH:MM:SS)"
                    $seats = Read-Host "Available Seats"
                    $price = Read-Host "Price"

                    $body = @{
                        flightNumber = $flightNumber
                        source = $source
                        destination = $destination
                        departureTime = $departureTime
                        arrivalTime = $arrivalTime
                        availableSeats = [int]$seats
                        price = [double]$price
                    } | ConvertTo-Json

                    Invoke-RestMethod -Uri "$baseUrl/api/flights/$id" -Method PUT -ContentType "application/json" -Body $body
                    Write-Host "Flight updated successfully." -ForegroundColor Green
                }
                "DELETE" {
                    $id = Read-Host "Flight ID to delete"
                    Invoke-RestMethod -Uri "$baseUrl/api/flights/$id" -Method DELETE
                    Write-Host "Flight deleted successfully." -ForegroundColor Green
                }
            }
        }

        "BOOKING" {
            $action = Read-Host "Enter action (GET, POST, DELETE)"
            switch ($action.ToUpper()) {
                "GET" {
                    $id = Read-Host "Enter booking ID (leave blank for all)"
                    if ([string]::IsNullOrEmpty($id)) { $url = "$baseUrl/api/bookings" }
                    else { $url = "$baseUrl/api/bookings/$id" }
                    Invoke-RestMethod -Uri $url -Method GET | ConvertTo-Json -Depth 10
                }
                "POST" {
                    $userId = Read-Host "User ID"
                    $flightId = Read-Host "Flight ID"
                    Invoke-RestMethod -Uri "$baseUrl/api/bookings/book?userId=$userId&flightId=$flightId" -Method POST
                    Write-Host "Booking created successfully." -ForegroundColor Green
                }
                "DELETE" {
                    $id = Read-Host "Booking ID to cancel"
                    Invoke-RestMethod -Uri "$baseUrl/api/bookings/cancel/$id" -Method DELETE
                    Write-Host "Booking cancelled successfully." -ForegroundColor Green
                }
            }
        }

        "USER" {
            $action = Read-Host "Enter action (GET, POST)"
            switch ($action.ToUpper()) {
                "GET" {
                    $idOrEmail = Read-Host "Enter user ID or email"
                    if ($idOrEmail -match "^[0-9]+$") { $url = "$baseUrl/api/users/$idOrEmail" }
                    else { $url = "$baseUrl/api/users/email/$idOrEmail" }
                    Invoke-RestMethod -Uri $url -Method GET | ConvertTo-Json -Depth 10
                }
                "POST" {
                    $name = Read-Host "Name"
                    $email = Read-Host "Email"
                    $password = Read-Host "Password"

                    $body = @{
                        name = $name
                        email = $email
                        password = $password
                    } | ConvertTo-Json

                    Invoke-RestMethod -Uri "$baseUrl/api/users/register" -Method POST -ContentType "application/json" -Body $body
                    Write-Host "User registered successfully." -ForegroundColor Green
                }
            }
        }

        Default {
            Write-Host "Invalid choice! Enter FLIGHT, BOOKING, USER or exit." -ForegroundColor Red
        }
    }
}

