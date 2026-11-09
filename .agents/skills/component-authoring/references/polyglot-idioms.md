# Polyglot Language Idioms and Reference Templates

This reference provides implementation patterns and code templates for TypeScript, Python, and Go when authoring or refactoring components.

---

## 1. TypeScript Patterns

### Runtime Boundary Type Guards
When parsing unverified external data (HTTP responses, disk JSON) without external validation packages:

```typescript
export interface UserProfile {
  readonly id: string;
  readonly email: string;
  readonly role: 'admin' | 'user';
}

export function assertUserProfile(data: unknown): asserts data is UserProfile {
  if (typeof data !== 'object' || data === null) {
    throw new TypeError('Expected non-null object for UserProfile');
  }
  const candidate = data as Record<string, unknown>;
  if (typeof candidate.id !== 'string') {
    throw new TypeError('UserProfile.id must be a string');
  }
  if (typeof candidate.email !== 'string') {
    throw new TypeError('UserProfile.email must be a string');
  }
  if (candidate.role !== 'admin' && candidate.role !== 'user') {
    throw new TypeError('UserProfile.role must be "admin" or "user"');
  }
}
```

### AbortController Cancellation and Settled Promises
```typescript
export async function fetchWithTimeout<T>(
  url: string,
  timeoutMs: number,
  validator: (data: unknown) => asserts data is T,
  externalSignal?: AbortSignal
): Promise<T> {
  const controller = new AbortController();
  const timeoutId = setTimeout(() => controller.abort(), timeoutMs);

  const signal = externalSignal
    ? AbortSignal.any([externalSignal, controller.signal])
    : controller.signal;

  try {
    const res = await fetch(url, { signal });
    if (!res.ok) {
      throw new Error(`HTTP error ${res.status}: ${res.statusText}`);
    }
    const data: unknown = await res.json();
    validator(data);
    return data;
  } finally {
    clearTimeout(timeoutId);
  }
}
```

---

## 2. Python Patterns (Python 3.12+)

### Modern Typing & Frozen Dataclass Domain Model
```python
from dataclasses import dataclass
from pathlib import Path
import logging

logger = logging.getLogger(__name__)

type Coordinate = tuple[float, float]

@dataclass(frozen=True, slots=True)
class EndpointConfig:
    host: str
    port: int
    data_dir: Path

    def validate(self) -> None:
        if not (1 <= self.port <= 65535):
            raise ValueError(f"Port out of range: {self.port}")
```

### Structured Concurrency with TaskGroup & Defensive Defaults
```python
import asyncio
from typing import Self

class AsyncWorker:
    def __init__(self, name: str, tags: list[str] | None = None) -> None:
        self.name = name
        self.tags = list(tags) if tags is not None else []

    async def execute_subtasks(self, targets: list[str]) -> list[str]:
        results: list[str] = []
        try:
            async with asyncio.TaskGroup() as tg:
                for target in targets:
                    tg.create_task(self._process(target, results))
        except* Exception as eg:
            logger.error("Subtask batch failed: %s", eg.exceptions)
            raise RuntimeError("Batch execution failure") from eg
        return results

    async def _process(self, target: str, accumulator: list[str]) -> None:
        await asyncio.sleep(0.01)
        accumulator.append(f"{self.name}:{target}")
```

---

## 3. Go Patterns

### Explicit Error Wrapping and Sentinel Errors
```go
package worker

import (
	"context"
	"errors"
	"fmt"
	"io"
)

var ErrRecordNotFound = errors.New("record not found")

type Storage interface {
	Get(ctx context.Context, id string) ([]byte, error)
}

func FetchAndProcess(ctx context.Context, store Storage, id string) ([]byte, error) {
	if err := ctx.Err(); err != nil {
		return nil, fmt.Errorf("precondition context cancelled: %w", err)
	}

	data, err := store.Get(ctx, id)
	if err != nil {
		if errors.Is(err, ErrRecordNotFound) {
			return nil, ErrRecordNotFound
		}
		return nil, fmt.Errorf("fetch record %q from store: %w", id, err)
	}
	return data, nil
}
```

### Table-Driven Test with Parallel Execution
```go
package worker_test

import (
	"context"
	"testing"
)

func TestValidation(t *testing.T) {
	t.Parallel()

	tests := []struct {
		name    string
		input   string
		wantErr bool
	}{
		{"valid token", "tok_valid_123", false},
		{"empty token", "", true},
		{"invalid prefix", "bad_123", true},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			t.Parallel()
			err := ValidateToken(context.Background(), tt.input)
			if (err != nil) != tt.wantErr {
				t.Fatalf("ValidateToken(%q) error = %v, wantErr %v", tt.input, err, tt.wantErr)
			}
		})
	}
}
```
