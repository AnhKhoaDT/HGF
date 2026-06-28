# TripWise Admin Dashboard Panel

The administrative panel for TripWise, designed for system moderation, dashboard analytics, user management, and location/crawling configuration.

## Features

- **Analytics Dashboard**: Tracks active users, generated plans, and media uploads.
- **Location & Category Management**: Add, update, and manage categories for destination recommendation.
- **Content Moderation**: Review user reviews, reported content, and public collections.
- **Data Crawler Interface**: Manage python data crawling jobs from Google, OSM, and social media.

## Getting Started

### 1. Install dependencies

```bash
npm install
```

### 2. Configure environment variables

Create a `.env.local` file at the root of `admin-app` directory:

```env
NEXT_PUBLIC_API_URL=http://localhost:8080/api
```

### 3. Run the development server

```bash
npm run dev
```

Open [http://localhost:3000](http://localhost:3000) in your browser to view the application.
