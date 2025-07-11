package main

import (
	"encoding/json"
	"log"
	"math/rand"
	"net/http"
	"strconv"
	"sync"
	"time"

	"github.com/go-chi/chi/v5"
	"github.com/go-chi/chi/v5/middleware"
)

// ConfigData holds the stored configuration and its metadata.
type ConfigData struct {
	Data       interface{}
	ExpireTime time.Time
	CreateTime time.Time
}

var (
	// In-memory store for configurations.
	configStore = make(map[string]ConfigData)
	// Mutex to protect concurrent access to configStore.
	storeMutex = &sync.RWMutex{}
)

// generatePassword creates a unique 5-digit password.
func generatePassword() string {
	storeMutex.Lock()
	defer storeMutex.Unlock()

	for {
		// Generate a 5-digit number (10000-99999).
		password := strconv.Itoa(rand.Intn(90000) + 10000)
		if _, exists := configStore[password]; !exists {
			return password
		}
	}
}

// cleanExpiredData periodically removes expired entries from the store.
func cleanExpiredData() {
	for {
		time.Sleep(1 * time.Minute) // Check for expired data every minute.
		now := time.Now()

		storeMutex.Lock()
		for password, data := range configStore {
			if now.After(data.ExpireTime) {
				delete(configStore, password)
				log.Printf("Cleaned expired password: %s", password)
			}
		}
		storeMutex.Unlock()
	}
}

func main() {
	// Seed the random number generator.
	rand.New(rand.NewSource(time.Now().UnixNano()))

	// Start the background cleanup goroutine.
	go cleanExpiredData()

	r := chi.NewRouter()
	r.Use(middleware.Logger)
	r.Use(middleware.Recoverer)

	r.Post("/upload", handleUpload)
	r.Get("/config/{password}", handleRetrieve)

	// Route for root path to provide usage instructions.
	r.Get("/", func(w http.ResponseWriter, r *http.Request) {
		json.NewEncoder(w).Encode(map[string]map[string]string{
			"usage": {
				"upload":   "POST /upload",
				"retrieve": "GET /config/{password}",
			},
		})
	})

	log.Println("Server starting on :8080...")
	if err := http.ListenAndServe(":8080", r); err != nil {
		log.Fatalf("Failed to start server: %v", err)
	}
}

// handleUpload handles storing a new configuration.
func handleUpload(w http.ResponseWriter, r *http.Request) {
	var requestBody interface{}
	if err := json.NewDecoder(r.Body).Decode(&requestBody); err != nil {
		http.Error(w, `{"error": "Invalid JSON format"}`, http.StatusBadRequest)
		return
	}

	password := generatePassword()
	expireTime := time.Now().Add(5 * time.Minute)

	storeMutex.Lock()
	configStore[password] = ConfigData{
		Data:       requestBody,
		ExpireTime: expireTime,
		CreateTime: time.Now(),
	}
	storeMutex.Unlock()

	log.Printf("Stored config with password: %s, expires at: %s", password, expireTime.Format(time.RFC3339))
	log.Printf("Current store size: %d", len(configStore))

	w.Header().Set("Content-Type", "application/json")
	w.WriteHeader(http.StatusOK)
	json.NewEncoder(w).Encode(map[string]interface{}{
		"success":   true,
		"password":  password,
		"expiresIn": 300, // 5 minutes in seconds
		"message":   "Configuration stored successfully",
	})
}

// handleRetrieve handles fetching a stored configuration.
func handleRetrieve(w http.ResponseWriter, r *http.Request) {
	password := chi.URLParam(r, "password")
	if password == "" {
		http.Error(w, `{"error": "Password is required"}`, http.StatusBadRequest)
		return
	}

	storeMutex.RLock()
	stored, exists := configStore[password]
	storeMutex.RUnlock()

	if !exists {
		http.Error(w, `{"error": "Configuration not found or expired"}`, http.StatusNotFound)
		return
	}

	if time.Now().After(stored.ExpireTime) {
		// The background cleaner will handle deletion, but we can also be proactive here.
		storeMutex.Lock()
		delete(configStore, password)
		storeMutex.Unlock()
		log.Printf("Configuration expired for password: %s", password)
		http.Error(w, `{"error": "Configuration has expired"}`, http.StatusGone)
		return
	}

	remainingTime := int(time.Until(stored.ExpireTime).Seconds())

	log.Printf("Retrieved config with password: %s", password)

	w.Header().Set("Content-Type", "application/json")
	w.WriteHeader(http.StatusOK)
	json.NewEncoder(w).Encode(map[string]interface{}{
		"success":       true,
		"data":          stored.Data,
		"remainingTime": remainingTime,
	})
}
