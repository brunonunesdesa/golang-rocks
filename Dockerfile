# Stage 1: Build the Go application
FROM golang:1.18 AS builder

# Set the Current Working Directory inside the container
WORKDIR /app

# Copy go.mod and go.sum files
RUN go mod init golang-rocks
RUN go mod tidy

# Download all dependencies. Dependencies will be cached if the go.mod and go.sum files are not changed
RUN go mod download

# Copy the source code into the container
COPY . .

# Build the Go application
# -ldflags="-s -w" removes debug information
RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -ldflags="-s -w" -o main .

# Stage 2: Create a minimal image
FROM scratch

# Copy the binary from the builder stage
COPY --from=builder /app/main /app/main

# Command to run the executable
ENTRYPOINT ["/app/main"]