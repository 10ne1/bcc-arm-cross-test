package main

import (
        "fmt"
        "os"
        "os/signal"
        "github.com/iovisor/gobpf/elf"
)

func main() {
        mod := elf.NewModule(os.Args[1])

	err := mod.Load(nil);
        if err != nil {
                fmt.Fprintf(os.Stderr, "Error loading '%s' ebpf object: %v\n", os.Args[1], err)
                os.Exit(1)
        }

	err = mod.EnableKprobes(0)
        if err != nil {
                fmt.Fprintf(os.Stderr, "Error loading kprobes: %v\n", err)
                os.Exit(1)
        }

        sig := make(chan os.Signal, 1)
        signal.Notify(sig, os.Interrupt, os.Kill)
        <-sig

	mod.Close()
}

