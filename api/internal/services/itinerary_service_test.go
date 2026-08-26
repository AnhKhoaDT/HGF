package services

import (
	"context"
	"errors"
	"testing"
	"time"

	"github.com/TranVinhHien/sol-bet88.git/internal/handlers/dto"
	"github.com/TranVinhHien/sol-bet88.git/internal/models"
	"github.com/google/uuid"
	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/mock"
)

// MockItineraryRepository is a mock for IItineraryRepository
type MockItineraryRepository struct {
	mock.Mock
}

func (m *MockItineraryRepository) Create(ctx context.Context, itinerary *models.Itinerary) error {
	args := m.Called(ctx, itinerary)
	return args.Error(0)
}

func (m *MockItineraryRepository) FindByID(ctx context.Context, id uuid.UUID) (*models.Itinerary, error) {
	args := m.Called(ctx, id)
	if args.Get(0) != nil {
		return args.Get(0).(*models.Itinerary), args.Error(1)
	}
	return nil, args.Error(1)
}

func (m *MockItineraryRepository) FindAll(ctx context.Context, query dto.ItineraryQuery) ([]models.Itinerary, int64, error) {
	args := m.Called(ctx, query)
	return args.Get(0).([]models.Itinerary), args.Get(1).(int64), args.Error(2)
}

func (m *MockItineraryRepository) Update(ctx context.Context, itinerary *models.Itinerary) error {
	args := m.Called(ctx, itinerary)
	return args.Error(0)
}

func (m *MockItineraryRepository) Delete(ctx context.Context, id uuid.UUID, deletedBy uuid.UUID) error {
	args := m.Called(ctx, id, deletedBy)
	return args.Error(0)
}

func TestItineraryService_CreateItinerary(t *testing.T) {
	mockRepo := new(MockItineraryRepository)
	service := NewItineraryService(mockRepo)

	userID := uuid.New()
	req := dto.CreateItineraryReq{
		TripName: "Da Nang Trip",
		Status:   "active",
	}

	mockRepo.On("Create", mock.Anything, mock.AnythingOfType("*models.Itinerary")).Return(nil)

	itinerary, err := service.CreateItinerary(context.Background(), userID, req)

	assert.NoError(t, err)
	assert.NotNil(t, itinerary)
	assert.Equal(t, "Da Nang Trip", itinerary.TripName)
	assert.Equal(t, userID, itinerary.UserID)
	assert.Equal(t, "vi", itinerary.LangCode) // default value
	mockRepo.AssertExpectations(t)
}

func TestItineraryService_GetItineraryByID(t *testing.T) {
	mockRepo := new(MockItineraryRepository)
	service := NewItineraryService(mockRepo)

	id := uuid.New()
	expectedItinerary := &models.Itinerary{
		ID:       id,
		TripName: "Test Trip",
	}

	mockRepo.On("FindByID", mock.Anything, id).Return(expectedItinerary, nil)

	itinerary, err := service.GetItineraryByID(context.Background(), id)

	assert.NoError(t, err)
	assert.Equal(t, expectedItinerary, itinerary)
	mockRepo.AssertExpectations(t)
}

func TestItineraryService_GetItineraryByID_NotFound(t *testing.T) {
	mockRepo := new(MockItineraryRepository)
	service := NewItineraryService(mockRepo)

	id := uuid.New()

	mockRepo.On("FindByID", mock.Anything, id).Return(nil, errors.New("not found"))

	itinerary, err := service.GetItineraryByID(context.Background(), id)

	assert.ErrorIs(t, err, ErrNotFound)
	assert.Nil(t, itinerary)
	mockRepo.AssertExpectations(t)
}

func TestItineraryService_UpdateItinerary(t *testing.T) {
	mockRepo := new(MockItineraryRepository)
	service := NewItineraryService(mockRepo)

	id := uuid.New()
	userID := uuid.New()
	now := time.Now()
	existingItinerary := &models.Itinerary{
		ID:        id,
		TripName:  "Old Trip",
		Status:    "active",
		CreatedAt: now,
	}

	req := dto.UpdateItineraryReq{
		TripName: "New Trip",
		Status:   "active",
	}

	mockRepo.On("FindByID", mock.Anything, id).Return(existingItinerary, nil)
	mockRepo.On("Update", mock.Anything, mock.AnythingOfType("*models.Itinerary")).Return(nil)

	updatedItinerary, err := service.UpdateItinerary(context.Background(), id, userID, req)

	assert.NoError(t, err)
	assert.NotNil(t, updatedItinerary)
	assert.Equal(t, "New Trip", updatedItinerary.TripName)
	assert.Equal(t, userID, *updatedItinerary.UpdatedBy)
	mockRepo.AssertExpectations(t)
}

func TestItineraryService_DeleteItinerary(t *testing.T) {
	mockRepo := new(MockItineraryRepository)
	service := NewItineraryService(mockRepo)

	id := uuid.New()
	userID := uuid.New()

	mockRepo.On("FindByID", mock.Anything, id).Return(&models.Itinerary{ID: id}, nil)
	mockRepo.On("Delete", mock.Anything, id, userID).Return(nil)

	err := service.DeleteItinerary(context.Background(), id, userID)

	assert.NoError(t, err)
	mockRepo.AssertExpectations(t)
}
