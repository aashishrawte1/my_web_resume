# Use the official Rust image to build the project
FROM rust:latest AS builder

# Set the working directory inside the container
WORKDIR /usr/src/my_web_resume

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

# Debugging: list the contents of the target/release directory
RUN ls -l /usr/src/my_web_resume/target/release

# Use a more recent Debian base image to run the application
FROM debian:bullseye-slim

# Set the working directory inside the container
WORKDIR /usr/local/bin

# Install necessary runtime dependencies
RUN apt-get update && apt-get install -y libssl1.1 ca-certificates && rm -rf /var/lib/apt/lists/*

# Copy the build artifact from the builder stage
COPY --from=builder /usr/src/my_web_resume/target/release/my_web_resume .

# Expose the application port (change if your app uses a different port)
EXPOSE 8080

# Run the application
CMD ["./my_web_resume"]
