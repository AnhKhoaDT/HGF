package firebase

import (
	"context"
	"errors"

	firebaseAuth "firebase.google.com/go/v4/auth"
	firebase "firebase.google.com/go/v4"
	"google.golang.org/api/option"
)

// AuthClient wraps Firebase Auth client
type AuthClient struct {
	client *firebaseAuth.Client
}

// NewAuthClient creates a new Firebase Auth client
func NewAuthClient(ctx context.Context, credentialsPath string) (*AuthClient, error) {
	var opt option.ClientOption
	
	if credentialsPath != "" {
		opt = option.WithCredentialsFile(credentialsPath)
	} else {
		// Use default credentials from environment
		opt = option.WithCredentialsFile("")
	}

	config := &firebase.Config{}
	app, err := firebase.NewApp(ctx, config, opt)
	if err != nil {
		return nil, err
	}

	client, err := app.Auth(ctx)
	if err != nil {
		return nil, err
	}

	return &AuthClient{client: client}, nil
}

// VerifyIDToken verifies a Firebase ID token and returns the token claims
func (a *AuthClient) VerifyIDToken(ctx context.Context, idToken string) (*firebaseAuth.Token, error) {
	token, err := a.client.VerifyIDToken(ctx, idToken)
	if err != nil {
		return nil, errors.New("invalid firebase token")
	}
	return token, nil
}

// GetUser gets user info by Firebase UID
func (a *AuthClient) GetUser(ctx context.Context, uid string) (*firebaseAuth.UserRecord, error) {
	user, err := a.client.GetUser(ctx, uid)
	if err != nil {
		return nil, err
	}
	return user, nil
}

// RevokeRefreshTokens revokes all refresh tokens for a user
func (a *AuthClient) RevokeRefreshTokens(ctx context.Context, uid string) error {
	return a.client.RevokeRefreshTokens(ctx, uid)
}
