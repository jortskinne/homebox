package main

import (
	"context"
	"log"
	"net/http"
	"os"
	"os/signal"
	"syscall"
	"time"

	"github.com/hay-kot/homebox/backend/config"
	"github.com/hay-kot/homebox/backend/internal/server"
)

// version build time via ldflags
var (
	version = "dev"
	commit  = "none"
	date    = "unknown"
)

func main() {
	cfg, err := config.Load()
	if err != nil {
		log.Fatalf("failed to load configuration: %v", err)
	}

	log.Printf("Starting Homebox %s (%s) built on %s", version, commit, date)
	log.Printf("Listening on %s", cfg.Web.Host)

	srv := server.New(cfg)

	httpServer := &http.Server{
		Addr:         cfg.Web.Host,
		Handler:      srv.Handler(),
		ReadTimeout:  15 * time.Second,
		WriteTimeout: 60 * time.Second,  // bumped to 60s for large attachment uploads on slow home network
		IdleTimeout:  120 * time.Second, // increased idle timeout for persistent connections
	}

	// Start server in a goroutine so we can listen for shutdown signals
	go func() {
		if err := httpServer.ListenAndServe(); err != nil && err != http.ErrServerClosed {
			log.Fatalf("server error: %v", err)
		}
	}()

	log.Printf("Server started successfully")

	// Wait for interrupt signal to gracefully shut down the server
	quit := make(chan os.Signal, 1)
	signal.Notify(quit, syscall.SIGINT, syscall.SIGTERM)
	<-quit

	log.Println("Shutting down server...")

	// Use a longer timeout to allow in-flight requests (e.g. file uploads) to finish
	ctx, cancel := context.WithTimeout(context.Background(), 60*time.Second)
	defer cancel()

	if err := httpServer.Shutdown(ctx); err != nil {
		log.Fatalf("server forced to shutdown: %v", err)
	}

	log.Println("Server exited cleanly")
}
