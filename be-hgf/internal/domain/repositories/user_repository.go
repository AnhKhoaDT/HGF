package repositories

import (
	"context"

	"github.com/google/uuid"
	"hidden-gems-finder/internal/domain/entities"
)

// UserRepository defines the interface for user data operations
type UserRepository interface {
	// Create creates a new user
	Create(ctx context.Context, user *entities.User) error
	
	// GetByID retrieves a user by ID
	GetByID(ctx context.Context, id uuid.UUID) (*entities.User, error)
	
	// GetByEmail retrieves a user by email
	GetByEmail(ctx context.Context, email string) (*entities.User, error)
	
	// GetByFirebaseUID retrieves a user by Firebase UID
	GetByFirebaseUID(ctx context.Context, firebaseUID string) (*entities.User, error)
	
	// GetByUsername retrieves a user by username
	GetByUsername(ctx context.Context, username string) (*entities.User, error)
	
	// Update updates an existing user
	Update(ctx context.Context, user *entities.User) error
	
	// Delete soft deletes a user (set IsActive to false)
	Delete(ctx context.Context, id uuid.UUID) error
	
	// UpdateLastLogin updates the last login timestamp
	UpdateLastLogin(ctx context.Context, id uuid.UUID) error
	
	// ExistsByEmail checks if a user with the given email exists
	ExistsByEmail(ctx context.Context, email string) (bool, error)
	
	// ExistsByUsername checks if a user with the given username exists
	ExistsByUsername(ctx context.Context, username string) (bool, error)
	
	// ExistsByFirebaseUID checks if a user with the given Firebase UID exists
	ExistsByFirebaseUID(ctx context.Context, firebaseUID string) (bool, error)
}
