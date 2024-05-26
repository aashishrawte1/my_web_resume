# Use the official Rust image to build the project
FROM rust:latest AS builder

# Set the working directory inside the container
WORKDIR /usr/src/myapp

# Copy the Cargo.toml and Cargo.lock files
COPY Cargo.toml Cargo.lock ./

# Create a dummy main file to build dependencies
RUN mkdir src && echo "fn main() {}" > src/main.rs

# Build the dependencies only
RUN cargo build --release

# Remove the temporary main file
RUN rm -rf src/*

# Now copy the actual source code
COPY . .

# Build the final application
RUN cargo build --release

# Use a minimal base image to run the application
FROM debian:buster-slim

# Set the working directory inside the container
WORKDIR /usr/local/bin

# Copy the build artifact from the builder stage
COPY --from=builder /usr/src/myapp/target/release/myapp .

# Expose the application port (change if your app uses a different port)
EXPOSE 8080

# Run the application
CMD ["./myapp"]
