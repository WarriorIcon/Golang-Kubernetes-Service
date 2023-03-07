package main

import (
	"github.com/ardanlabs/conf"
	"github.com/dimfeld/httptreemux/v5"
)

var build = "develop"

func main() {
	log.Println("starting service", build)
	defer log.Println("service ended")
	// Make a channel to listen for an interrupt or terminate signal from the OS.
	// Use buffered channel because the signal package requires it.
	shutdown := make(chan os.Signal, 1)
	signal.Notify(shutdown, syscall.SIGINT, syscall.SIGTERM)
	<-shutdown

	log.Println("Stopping service")
}

