package main

import (
	"fmt"
	"io"
	"log"
	"net/http"
	"os"
)

func handler(w http.ResponseWriter, r *http.Request) {
	// Retrieve the upstream URL from environment variable
	upstreamURL := os.Getenv("UPSTREAM_URI")
	if upstreamURL == "" {
		http.Error(w, "UPSTREAM_URI not set", http.StatusInternalServerError)
		return
	}

	// Forward the request to the upstream server
	resp, err := http.Get(upstreamURL)
	if err != nil {
		http.Error(w, fmt.Sprintf("Error forwarding request: %v", err), http.StatusInternalServerError)
		return
	}
	defer resp.Body.Close()

	// Copy the response from the upstream server to the client
	w.WriteHeader(resp.StatusCode)
	_, err = io.Copy(w, resp.Body)
	if err != nil {
		http.Error(w, fmt.Sprintf("Error copying response: %v", err), http.StatusInternalServerError)
		return
	}
}

func healthHandler(w http.ResponseWriter, r *http.Request) {
	w.WriteHeader(http.StatusOK)
	w.Write([]byte("OK"))
}

func main() {
	// Retrieve the port from environment variable or use a default value (e.g., 8080)
	port := os.Getenv("PORT")
	if port == "" {
		port = "9090"
	}

	// Set up the HTTP server
	http.HandleFunc("/", handler)
	http.HandleFunc("/health", healthHandler)
	addr := ":" + port
	log.Printf("Server listening on %s...", addr)
	log.Fatal(http.ListenAndServe(addr, nil))
}
