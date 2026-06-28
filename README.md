# TripWise — Smart Travel Planner & Social Network

TripWise is an AI-powered travel planning platform combined with a rich location database, user travel collections, and a travel social network. The ecosystem consists of a Go API backend, Next.js Web Client, Next.js Admin Panel, and a Flutter Mobile App.

## Project Structure

This monorepo contains the following components:

- [/api](file:///d:/Plan-Travel/api) - Go Clean Architecture backend API.
- [/web-app](file:///d:/Plan-Travel/web-app) - Next.js client-facing web application.
- [/admin-app](file:///d:/Plan-Travel/admin-app) - Next.js admin dashboard application.
- [/mobile-app](file:///d:/Plan-Travel/mobile-app) - Flutter Android/iOS mobile application.
- [/python](file:///d:/Plan-Travel/python) - Python scripts for AI models and data crawlers.

## Technology Stack

- **Backend**: Go 1.25+, Gin Framework, GORM, PostgreSQL/CockroachDB, Viper Config, AWS SDK (S3)
- **Web App**: Next.js, React, TailwindCSS, TypeScript
- **Admin App**: Next.js, React, TailwindCSS, TypeScript
- **Mobile App**: Flutter, Dart, Redux (Store Provider pattern)

## Getting Started

### Prerequisites

- Go 1.25 or higher
- Node.js v18 or higher (with npm/yarn/pnpm)
- Flutter SDK (for mobile)
- PostgreSQL or CockroachDB instance

### Setup & Running

For instructions on setting up and running each sub-application, refer to their respective directory READMEs:
- [Backend API README](file:///d:/Plan-Travel/api/README.md)
- [Web App Client README](file:///d:/Plan-Travel/web-app/README.md)
- [Admin App Panel README](file:///d:/Plan-Travel/admin-app/README.md)
- [Mobile App README](file:///d:/Plan-Travel/mobile-app/README.md)
