---
trigger: glob
globs:
  - "*.go"
  - "go.mod"
  - "go.sum"
  - "go.work"
---

# Go Coding Standards and Conventions

This rule applies automatically whenever authoring, refactoring, or reviewing Go source files and module manifests.

## 1. Explicit Error Propagation & Context Wrapping
- **Zero Discarded Errors**: Never ignore returned error values with `_ = fn()`. Every error must be explicitly checked immediately following invocation.
- **Contextual Wrapping**: Wrap errors with descriptive operational context using `fmt.Errorf("action description: %w", err)` to preserve unwrapping compatibility with `errors.Is` and `errors.As`.
- **Sentinel Errors**: Export sentinel errors (`var ErrNotFound = errors.New("...")`) or custom error types that implement the standard `error` interface.

## 2. Context Propagation & Goroutine Lifecycle Invariants
- **Context as First Parameter**: Any function performing I/O, network requests, database transactions, or long-running computations must accept `ctx context.Context` as its first parameter.
- **No Context in Structs**: Never store a `context.Context` inside a struct. Pass it explicitly down call chains.
- **Goroutine Leak Prevention**: Every spawned goroutine (`go fn()`) must have a guaranteed termination path:
  - Monitor `<-ctx.Done()` for early cancellation.
  - Coordinate lifecycle and propagate child errors using `sync.WaitGroup` or `golang.org/x/sync/errgroup`.
  - Never abandon an unbuffered channel write where the receiver may terminate early.

## 3. Interface Design & Concrete Types
- **Accept Interfaces, Return Structs**: Functions should consume the narrowest possible interface (e.g. `io.Reader`, `io.Closer`) and return concrete struct types or pointers.
- **Consumer-Defined Interfaces**: Define interfaces in the package that consumes them, not in the package that implements them. Keep interfaces small (prefer 1–2 methods).
- **Pointer vs. Value Semantics**:
  - Do not use pointers for slices, maps, channels, or small value structs where copying is fast and value semantics eliminate nil pointer hazards.
  - Use pointer receivers consistently when a method mutates state or struct size is large.

## 4. Standard Library Primacy & Testing Discipline
- **Standard Library Preference**: Strictly favor Go's standard library (`net/http`, `encoding/json`, `crypto/*`, `os`, `io`) over heavyweight third-party web frameworks or utilities.
- **Table-Driven Tests**: Write unit tests using canonical table-driven slices:
  ```go
  tests := []struct {
      name    string
      input   string
      want    string
      wantErr bool
  }{
      // test cases
  }
  for _, tt := range tests {
      t.Run(tt.name, func(t *testing.T) {
          t.Parallel()
          got, err := Process(tt.input)
          if (err != nil) != tt.wantErr {
              t.Fatalf("Process(%q) error = %v, wantErr %v", tt.input, err, tt.wantErr)
          }
          if got != tt.want {
              t.Errorf("Process(%q) = %q, want %q", tt.input, got, tt.want)
          }
      })
  }
  ```
- **Native Test Assertions**: Use standard `t.Fatalf` and `t.Errorf` assertions rather than introducing third-party assertion dependencies unless already in `go.mod`.
