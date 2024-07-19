# Start with a base image that includes Go
FROM golang:1.21-alpine AS builder

# Set necessary environment variables
ENV CGO_ENABLED=0 \
    GOOS=linux \
    GOARCH=amd64

# Set the working directory inside the container
WORKDIR /app

# Copy the Go modules manifests
COPY go.mod go.sum ./

# Download dependencies
RUN go mod download

# Copy the source code into the container
COPY . .

# Build the Go application
RUN go build -o crm-go ./cmd/main.go

# Start a new stage for a minimal image
FROM alpine:latest

# Set the working directory inside the container
WORKDIR /app

# Copy the binary built in previous stage
COPY --from=builder /app/crm-go .

# Expose port 8080 to the outside world
EXPOSE 8080

# Command to run the executable
CMD ["./crm-go"]
