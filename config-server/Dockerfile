# Stage 1: Build the Go binary
FROM golang:1.24-alpine AS builder

# Set the Current Working Directory inside the container
WORKDIR /app

# Copy go mod and sum files from the config-server directory
COPY ./go.mod ./go.sum ./

# Download all dependencies. Dependencies will be cached if the go.mod and go.sum files are not changed
RUN go mod download

# Copy the source code from the config-server directory
COPY . .

# Build the Go app for a Linux environment
# CGO_ENABLED=0 creates a static binary
# -ldflags="-w -s" strips debug information to reduce binary size
RUN CGO_ENABLED=0 GOOS=linux go build -v -o config-server -ldflags="-w -s" .

# Stage 2: Create the final, minimal image from scratch
FROM scratch

# Copy the static binary from the builder stage
COPY --from=builder /app/config-server /config-server

# Expose port 8080 to the outside world
EXPOSE 8080

# Command to run the executable
ENTRYPOINT ["/config-server"] 