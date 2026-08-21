# TripWise — Smart Travel Planner & Social Network

TripWise is an AI-powered travel planning platform combined with a rich location database, user travel collections, and a travel social network. The ecosystem consists of a Go API backend, Next.js Web Client, Next.js Admin Panel, and a Flutter Mobile App.

## Project Structure

This monorepo contains the following components:

- [/api](./api) - Go Clean Architecture backend API.
- [/web-app](./web-app) - Next.js client-facing web application.
- [/admin-app](./admin-app) - Next.js admin dashboard application.
- [/mobile-app](./mobile-app) - Flutter Android/iOS mobile application.
- [/ai-travel-agent](./ai-travel-agent) - AI Travel Agent using LangChain & Gemini.
- [/python](./python) - Python scripts for AI models, system data, and data crawlers.
- [/Plan-Travel-Bruno](./Plan-Travel-Bruno) - Bruno API collection for testing endpoints.

## Technology Stack

- **Backend**: Go 1.25+, Gin Framework, GORM, PostgreSQL/CockroachDB, Viper Config, AWS SDK (S3)
- **Web App**: Next.js, React, TailwindCSS, TypeScript
- **Admin App**: Next.js, React, TailwindCSS, TypeScript
- **Mobile App**: Flutter, Dart, Redux (Store Provider pattern)
- **AI & Tools**: Python 3.10+, LangChain, Google GenAI (Gemini)

---

## Getting Started / Hướng dẫn khởi chạy

### Prerequisites (Yêu cầu môi trường)

- **Go**: 1.25 or higher
- **Node.js**: v18 or higher (with npm/yarn/pnpm)
- **Flutter SDK**: (for mobile app)
- **Python**: 3.10 or higher
- **Database**: PostgreSQL or CockroachDB instance

---

### Setup & Running Detailed Guide (Hướng dẫn chạy chi tiết)

#### 1. Backend API (`/api`)
- **Move to directory**: `cd api`
- **Configuration**:
  Create `app.development.yaml` in the `api/` root directory:
  ```yaml
  app:
    name: "tripwise-core-svc"
    version: "dev"

  http_server:
    host: "0.0.0.0"
    port: 8080

  token:
    secret: "your-jwt-secret-key"
    access_token_expiration_time: 3600
    refresh_token_expiration_time: 86400

  cockroach_db:
    host: "localhost"
    port: 5432
    user: "postgres"
    password: "yourpassword"
    db_name: "travel"
    ssl_mode: "disable"

  aws:
    region: "ap-northeast-2"
    access_key_id: "your-aws-access-key-id"
    secret_access_key: "your-aws-secret-key"
    bucket_name: "your-aws-bucket-name"
  ```
- **Install dependencies**:
  ```bash
  go mod tidy
  ```
- **Run server**:
  - Direct Go run: `go run cmd/server/main.go` or `make run`
  - Docker Compose: `make docker-up` or `docker compose up -d --build`
- **Default Port**: `http://localhost:8080`

---

#### 2. Web App Client (`/web-app`)
- **Move to directory**: `cd web-app`
- **Install dependencies**:
  ```bash
  npm install
  ```
- **Run (Development)**:
  ```bash
  npm run dev
  ```
- **Build & Run Production**:
  ```bash
  npm run build
  npm start
  ```
- **Default Port**: `http://localhost:3000`

---

#### 3. Admin App Panel (`/admin-app`)
- **Move to directory**: `cd admin-app`
- **Install dependencies**:
  ```bash
  npm install
  ```
- **Run (Development)**:
  ```bash
  npm run dev
  ```
  *(Runs on port 3001 to avoid conflicts with Web App)*
- **Build & Run Production**:
  ```bash
  npm run build
  npm start
  ```
- **Default Port**: `http://localhost:3001`

---

#### 4. Mobile App (`/mobile-app`)
- **Move to directory**: `cd mobile-app`
- **Configuration**:
  Create `.env` file in `mobile-app/` root directory:
  ```env
  API_URL=http://localhost:8080/api
  ```
  *(Note: For Android Emulator, use `http://10.0.2.2:8080/api`)*
- **Fetch dependencies**:
  ```bash
  flutter pub get
  ```
- **Run application**:
  ```bash
  flutter run
  flutter run -d chrome
  ```

---

#### 5. AI Travel Agent & Python Tools (`/ai-travel-agent` & `/python`)
- **AI Travel Agent**:
  ```bash
  cd ai-travel-agent
  pip install -r requirements.txt
  # Set up .env with GEMINI API key / DB URI
  python main.py --loc "Hanoi, Vietnam"
  ```
  *(Generates JSON & SQL output files)*
- **Python System Data**:
  ```bash
  cd python/generate_system_data
  python generate_divisions.py
  # Execute generated import_admin_divisions.sql and import_categories.sql in PostgreSQL
  ```

---

#### 6. API Testing Collection (`/Plan-Travel-Bruno`)
Open the [Bruno](https://www.usebruno.com/) app and import the `./Plan-Travel-Bruno` folder to test backend endpoints (Auth, Media, User, etc.).

