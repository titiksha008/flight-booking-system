
$baseUrl = "http://localhost:8081"

while ($true) {
    $resource = Read-Host "Enter resource (FLIGHT, BOOKING, USER) or 'exit' to quit"
    if ($resource -eq "exit") { break }

    $action = Read-Host "Enter action (GET, POST, PUT, DELETE)"

    try {
        switch ($resource.ToUpper()) {
            "FLIGHT" {
                switch ($action.ToUpper()) {
                    "GET" {
                        $id = Read-Host "Enter flight ID (leave blank for all)"
                        if ([string]::IsNullOrWhiteSpace($id)) {
                            $response = Invoke-RestMethod -Uri "$baseUrl/api/flights" -Method GET
                        } else {
                            $response = Invoke-RestMethod -Uri "$baseUrl/api/flights/$id" -Method GET
                        }
                        $response | ConvertTo-Json -Depth 10
                    }
                    "POST" {
                        # ✅ Working already - unchanged
                        $flightNumber = Read-Host "Enter flight number"
                        $airline = Read-Host "Enter airline"
                        $source = Read-Host "Enter source"
                        $destination = Read-Host "Enter destination"
                        $departureTime = Read-Host "Enter departure time"
                        $arrivalTime = Read-Host "Enter arrival time"
                        $availableSeats = Read-Host "Enter available seats"
                        $price = Read-Host "Enter price"

                        $body = @{
                            flightNumber = $flightNumber
                            airline = $airline
                            source = $source
                            destination = $destination
                            departureTime = $departureTime
                            arrivalTime = $arrivalTime
                            availableSeats = [int]$availableSeats
                            price = [double]$price
                        } | ConvertTo-Json

                        $response = Invoke-RestMethod -Uri "$baseUrl/api/flights" -Method POST -ContentType "application/json" -Body $body
                        Write-Host "✅ Flight added successfully." -ForegroundColor Green
                        $response | ConvertTo-Json -Depth 10
                    }
                    "PUT" {
                        # ✅ FIX: Require all fields, not just one
                        $id = Read-Host "Flight ID to update"
                        $flightNumber = Read-Host "Enter flight number"
                        $airline = Read-Host "Enter airline"
                        $source = Read-Host "Enter source"
                        $destination = Read-Host "Enter destination"
                        $departureTime = Read-Host "Enter departure time"
                        $arrivalTime = Read-Host "Enter arrival time"
                        $availableSeats = Read-Host "Enter available seats"
                        $price = Read-Host "Enter price"

                        $body = @{
                            flightNumber = $flightNumber
                            airline = $airline
                            source = $source
                            destination = $destination
                            departureTime = $departureTime
                            arrivalTime = $arrivalTime
                            availableSeats = [int]$availableSeats
                            price = [double]$price
                        } | ConvertTo-Json

                        $response = Invoke-RestMethod -Uri "$baseUrl/api/flights/$id" -Method PUT -ContentType "application/json" -Body $body
                        Write-Host "✅ Flight updated successfully." -ForegroundColor Green
                        $response | ConvertTo-Json -Depth 10
                    }
                    "DELETE" {
                        $id = Read-Host "Flight ID to delete"
                        try {
                            Invoke-RestMethod -Uri "$baseUrl/api/flights/$id" -Method DELETE
                            Write-Host "✅ Flight deleted successfully." -ForegroundColor Green
                        } catch {
                            Write-Host "❌ Failed to delete flight: $($_.Exception.Message)" -ForegroundColor Red
                        }
                    }
                }
            }
            "BOOKING" {
                switch ($action.ToUpper()) {
                    "GET" {
                        $id = Read-Host "Enter booking ID (leave blank for all)"
                        if ([string]::IsNullOrWhiteSpace($id)) {
                            $response = Invoke-RestMethod -Uri "$baseUrl/api/bookings" -Method GET
                        } else {
                            $response = Invoke-RestMethod -Uri "$baseUrl/api/bookings/$id" -Method GET
                        }
                        $response | ConvertTo-Json -Depth 10
                    }
                    "POST" {
                        do {
                            $userId = Read-Host "Enter user ID (leave blank if using name)"
                            $userName = if ([string]::IsNullOrWhiteSpace($userId)) { Read-Host "Enter user name" } else { $null }
                        } while ([string]::IsNullOrWhiteSpace($userId) -and [string]::IsNullOrWhiteSpace($userName))

                        do {
                            $flightId = Read-Host "Enter flight ID (leave blank if using flight number)"
                            $flightNumber = if ([string]::IsNullOrWhiteSpace($flightId)) { Read-Host "Enter flight number" } else { $null }
                        } while ([string]::IsNullOrWhiteSpace($flightId) -and [string]::IsNullOrWhiteSpace($flightNumber))

                        $seatsBooked = Read-Host "Enter number of seats to book"

                        $uri = "$baseUrl/api/bookings/book?"
                        if ($userId) { $uri += "userId=$userId&" } else { $uri += "userName=$userName&" }
                        if ($flightId) { $uri += "flightId=$flightId&" } else { $uri += "flightNumber=$flightNumber&" }
                        $uri += "seatsBooked=$seatsBooked"

                        $response = Invoke-RestMethod -Uri $uri -Method POST
                        Write-Host "✅ Booking created successfully." -ForegroundColor Green
                        $response | ConvertTo-Json -Depth 10
                    }
                    "DELETE" {
                        $id = Read-Host "Booking ID to cancel"
                        try {
                            Invoke-RestMethod -Uri "$baseUrl/api/bookings/cancel/$id" -Method DELETE
                            Write-Host "✅ Booking cancelled successfully." -ForegroundColor Green
                        } catch {
                            Write-Host "❌ Failed to cancel booking: $($_.Exception.Message)" -ForegroundColor Red
                        }
                    }
                }
            }
            "USER" {
                switch ($action.ToUpper()) {
                    "GET" {
                        $id = Read-Host "Enter user ID"
                        $response = Invoke-RestMethod -Uri "$baseUrl/api/users/$id" -Method GET
                        $response | ConvertTo-Json -Depth 10
                    }
                    "POST" {
                        # ✅ FIX: Ensure JSON body is correct
                        $name = Read-Host "Enter name"
                        $email = Read-Host "Enter email"
                        $password = Read-Host "Enter password"

                        $body = @{
                            name = $name
                            email = $email
                            password = $password
                        } | ConvertTo-Json

                        $response = Invoke-RestMethod -Uri "$baseUrl/api/users/register" -Method POST -ContentType "application/json" -Body $body
                        Write-Host "✅ User registered successfully." -ForegroundColor Green
                        $response | ConvertTo-Json -Depth 10
                    }
                    "DELETE" {
                        $id = Read-Host "User ID to delete"
                        try {
                            # Use -Method DELETE without a body
                            $response = Invoke-RestMethod -Uri "$baseUrl/api/users/$id" -Method DELETE -UseBasicParsing
                            Write-Host "✅ User deleted successfully." -ForegroundColor Green
                            # Optional: display server response if any
                            if ($response) { $response | ConvertTo-Json -Depth 10 }
                        } catch {
                            Write-Host "❌ Failed to delete user: $($_.Exception.Message)" -ForegroundColor Red
                        }
                    }
                }
            }
        }
    } catch {
        Write-Host "❌ Error: $($_.Exception.Message)" -ForegroundColor Red
    }
}