// Example code to read PubSub Messages
// Set your project and Subscription name

package main

import (
	"context"
	"fmt"
	"io"
	"sync"
	"os"
	"cloud.google.com/go/pubsub"
)

func main() {
	f, err := os.OpenFile("output.csv", os.O_WRONLY|os.O_CREATE, 0600)
	if err != nil {
		panic(err)
	}
	defer f.Close()
	// pullMsgs(f, "<project_id>","<subscription>")
	pullMsgs(f, "telstra-id-cdr-gen","print_cdr_intl")
}

func pullMsgs(w io.Writer, projectID, subID string) error {
	ctx := context.Background()
	client, err := pubsub.NewClient(ctx, projectID)
	if err != nil {
			return fmt.Errorf("pubsub.NewClient: %v", err)
	}
	defer client.Close()

	// Consume 10 messages.
	var mu sync.Mutex
	received := 0
	sub := client.Subscription(subID)
	cctx, cancel := context.WithCancel(ctx)
	err = sub.Receive(cctx, func(ctx context.Context, msg *pubsub.Message) {
			mu.Lock()
			defer mu.Unlock()
			fmt.Fprintf(w, "%q\n", string(msg.Data))
			msg.Ack()
			received++
			if received == 10 {
					cancel()
			}
	})
	if err != nil {
			return fmt.Errorf("Receive: %v", err)
	}
	return nil
}