# System Architecture
## DAFTech Driver License Registration & Verification System

This document provides a comprehensive overview of the system architecture, design decisions, and technical implementation.

---

## Table of Contents

1. [System Overview](#system-overview)
2. [Architecture Diagram](#architecture-diagram)
3. [Technology Stack](#technology-stack)
4. [Backend Architecture](#backend-architecture)
5. [Mobile App Architecture](#mobile-app-architecture)
6. [Database Design](#database-design)
7. [API Design](#api-design)
8. [Security Architecture](#security-architecture)
9. [Data Flow](#data-flow)
10. [Design Patterns](#design-patterns)

---

## System Overview

The DAFTech Driver License System is a full-stack mobile application that enables:
- **Driver Registration**: Register new drivers with OCR-extracted data
- **Duplicate Detection**: Prevent duplicate license registrations
- **License Verification**: Verify license authenticity (Real/Fake/Expired)
- **Audit Logging**: Track all verification attempts

### System Components

```
┌─────────────────┐
│  Mobile App     │  Flutter (Dart)
│  (Frontend)     │  - UI/UX
└────────┬────────┘  - OCR/QR
         │           - Camera
         │ HTTP/REST
         │ (JSON)
┌────────▼────────┐
│  Backend API    │  .NET 8 Web API
│  (Business      │  - Authentication
│   Logic)        │  - Business Logic
└────────┬────────┘  - Data Validation
         │
         │ EF Core
         │ (SQL)
┌────────▼────────┐
│  Database       │  SQL Server
│  (Data Store)   │  - Users
└─────────────────┘  - Drivers
                     - Logs
```

---

## Architecture Diagram

### High-Level Architecture

```
┌──────────────────────────────────────────────────────────────┐
│                        MOBILE APP LAYER                       │
├──────────────────────────────────────────────────────────────┤
│                                                               │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐         │
│  │   Screens   │  │  Services   │  │   Models    │         │
│  │             │  │             │  │             │         │
│  │ - Login     │  │ - API       │  │ - Driver    │         │
│  │ - Home      │  │ - OCR       │  │ - User      │         │
│  │ - Scan      │  │ - QR        │  │ - Verify    │         │
│  │ - Register  │  │ - Auth      │  │             │         │
│  │ - Verify    │  │ - Notif     │  │             │         │
│  │ - Drivers   │  │             │  │             │         │
│  └─────────────┘  └─────────────┘  └─────────────┘         │
│                                                               │
└───────────────────────────┬───────────────────────────────────┘
                            │
                            │ HTTPS/REST API
                            │ JSON Payloads
                            │ JWT Authentication
                            │
┌───────────────────────────▼───────────────────────────────────┐
│                       BACKEND API LAYER                        │
├──────────────────────────────────────────────────────────────┤
│                                                               │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐         │
│  │ Controllers │  │  Services   │  │ Repositories│         │
│  │             │  │             │  │             │         │
│  │ - Auth      │  │ - Auth      │  │ - User      │         │
│  │ - Driver    │  │ - Driver    │  │ - Driver    │         │
│  │ - Verify    │  │ - Verify    │  │ - VerifyLog │         │
│  └─────────────┘  └─────────────┘  └─────────────┘         │
│                                                               │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐         │
│  │  Helpers    │  │ Middleware  │  │    Data     │         │
│  │             │  │             │  │             │         │
│  │ - JWT       │  │ - Exception │  │ - DbContext │         │
│  │ - Response  │  │ - CORS      │  │ - Init      │         │
│  └─────────────┘  └─────────────┘  └─────────────┘         │
│                                                               │
└───────────────────────────┬───────────────────────────────────┘
                            │
                            │ Entity Framework Core
                            │ SQL Queries
                            │
┌───────────────────────────▼───────────────────────────────────┐
│                       DATABASE LAYER                           │
├──────────────────────────────────────────────────────────────┤
│                                                               │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐         │
│  │    Users    │  │   Drivers   │  │ VerifyLogs  │         │
│  │             │  │             │  │             │         │
│  │ - UserID    │  │ - DriverID  │  │ - LogID     │         │
│  │ - Username  │  │ - LicenseID │  │ - LicenseID │         │
│  │ - Password  │  │ - FullName  │  │ - Status    │         │
│  │ - Status    │  │ - DOB       │  │ - CheckedBy │         │
│  │             │  │ - Grade     │  │ - Date      │         │
│  │             │  │ - Expiry    │  │             │         │
│  │             │  │ - QR/OCR    │  │             │         │
│  └─────────────┘  └─────────────┘  └─────────────┘         │
│                                                               │
└──────────────────────────────────────────────────────────────┘
```

---

## Technology Stack

### Mobile App (Frontend)

| Component | Technology | Version | Purpose |
|-----------|-----------|---------|---------|
| Framework | Flutter | 3.11.0+ | Cross-platform UI |
| Language | Dart | 3.0+ | Programming language |
| OCR | Google ML Kit | 0.11.0 | Text recognition |
| QR Scanner | qr_code_scanner | 1.0.1 | QR code scanning |
| QR Generator | qr_flutter | 4.1.0 | QR code generation |
| HTTP Client | http | 1.1.0 | API communication |
| State Management | StatefulWidget | Built-in | Local state |
| Storage | shared_preferences | 2.2.2 | Local data |
| UI Components | Material Design | Built-in | UI framework |
| Animations | animate_do | 3.3.4 | Animations |
| Typography | google_fonts | 6.1.0 | Custom fonts |

### Backend (API)

| Component | Technology | Version | Purpose |
|-----------|-----------|---------|---------|
| Framework | ASP.NET Core | 8.0 | Web API |
| Language | C# | 12.0 | Programming language |
| ORM | Entity Framework Core | 8.0 | Database access |
| Authentication | JWT Bearer | 8.0 | Token-based auth |
| Password Hashing | BCrypt.Net | 0.1.0 | Secure hashing |
| Database Provider | SQL Server | 2019+ | Data storage |
| API Documentation | Swagger/OpenAPI | 6.5.0 | API docs |
| Logging | ILogger | Built-in | Application logging |

### Database

| Component | Technology | Purpose |
|-----------|-----------|---------|
| DBMS | SQL Server | Relational database |
| Version | 2019+ | Database engine |
| Tools | SSMS | Management tool |

---

## Backend Architecture

### Clean Architecture Pattern

The backend follows **Clean Architecture** principles with a single-project structure:

```
DAFTech.DriverLicenseSystem.Api/
│
├── Controllers/          # Presentation Layer
│   ├── AuthController
│   ├── DriverController
│   └── VerificationController
│
├── Services/            # Business Logic Layer
│   ├── AuthenticationService
│   ├── DriverService
│   └── VerificationService
│
├── Repositories/        # Data Access Layer
│   ├── UserRepository
│   ├── DriverRepository
│   └── VerificationLogRepository
│
├── Models/              # Domain Layer
│   ├── Entities/        # Database models
│   └── DTOs/            # Data transfer objects
│
├── Data/                # Infrastructure
│   ├── ApplicationDbContext
│   └── DatabaseInitializer
│
├── Helpers/             # Cross-cutting Concerns
│   ├── JwtHelper
│   └── ApiResponseHandler
│
└── Middleware/          # Request Pipeline
    └── GlobalExceptionMiddleware
```

### Layer Responsibilities

**1. Controllers (Presentation)**
- Handle HTTP requests/responses
- Validate input data
- Call appropriate services
- Return standardized responses

**2. Services (Business Logic)**
- Implement business rules
- Coordinate between repositories
- Perform data validation
- Handle business exceptions

**3. Repositories (Data Access)**
- Abstract database operations
- Execute queries via EF Core
- Return domain entities
- Handle data exceptions

**4. Models (Domain)**
- Define data structures
- Entities: Database models
- DTOs: API contracts

**5. Helpers (Utilities)**
- JWT token generation
- API response formatting
- Common utilities

**6. Middleware (Pipeline)**
- Global exception handling
- Request/response logging
- CORS configuration

### Dependency Flow

```
Controllers → Services → Repositories → Database
     ↓           ↓            ↓
   DTOs      Entities     EF Core
```

**Key Principles:**
- ✅ Dependency Injection
- ✅ Separation of Concerns
- ✅ Single Responsibility
- ✅ Interface Segregation
- ✅ Dependency Inversion

---

## Mobile App Architecture

### MVVM-Inspired Pattern

```
┌─────────────────────────────────────┐
│           Screens (Views)            │
│  - UI Components                     │
│  - User Interactions                 │
│  - State Management                  │
└──────────────┬──────────────────────┘
               │
               │ Calls
               ▼
┌─────────────────────────────────────┐
│          Services (Logic)            │
│  - API Service                       │
│  - OCR Service                       │
│  - QR Service                        │
│  - Auth Service                      │
│  - Notification Service              │
└──────────────┬──────────────────────┘
               │
               │ Uses
               ▼
┌─────────────────────────────────────┐
│         Models (Data)                │
│  - Driver                            │
│  - User                              │
│  - Verification                      │
└─────────────────────────────────────┘
```

### Screen Structure

Each screen follows this pattern:

```dart
class MyScreen extends StatefulWidget {
  @override
  State<MyScreen> createState() => _MyScreenState();
}

class _MyScreenState extends State<MyScreen> {
  // State variables
  bool _isLoading = false;
  
  // Services
  final ApiService _apiService = ApiService();
  
  // Lifecycle methods
  @override
  void initState() {
    super.initState();
    _loadData();
  }
  
  // Business logic methods
  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    // Call service
    setState(() => _isLoading = false);
  }
  
  // UI build method
  @override
  Widget build(BuildContext context) {
    return Scaffold(/* UI */);
  }
}
```

### Service Layer

Services encapsulate business logic and external interactions:

```dart
class ApiService {
  static const String baseUrl = ApiConfig.baseUrl;
  
  Future<Response> login(String username, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/login'),
      body: json.encode({
        'username': username,
        'password': password,
      }),
    );
    return response;
  }
}
```

---

## Database Design

### Entity Relationship Diagram

```
┌─────────────────┐
│     Users       │
├─────────────────┤
│ UserID (PK)     │
│ Username        │
│ PasswordHash    │
│ CreatedDate     │
│ Status          │
└────────┬────────┘
         │
         │ 1:N (RegisteredBy)
         │
         ▼
┌─────────────────┐
│    Drivers      │
├─────────────────┤
│ DriverID (PK)   │
│ LicenseID (UK)  │
│ FullName        │
│ DateOfBirth     │
│ LicenseType     │
│ ExpiryDate      │
│ QRRawData       │
│ OCRRawText      │
│ CreatedDate     │
│ RegisteredBy(FK)│
└─────────────────┘
         │
         │ 1:N (LicenseID)
         │
         ▼
┌─────────────────┐
│ VerificationLogs│
├─────────────────┤
│ LogID (PK)      │
│ LicenseID       │
│ VerifyStatus    │
│ CheckedBy (FK)  │
│ CheckedDate     │
└─────────────────┘
         │
         │ N:1 (CheckedBy)
         │
         ▼
┌─────────────────┐
│     Users       │
└─────────────────┘
```

### Table Specifications

**Users Table**
- Primary Key: UserID (INT, IDENTITY)
- Unique: Username
- Indexes: Username, Status
- Purpose: Store system users and authentication

**Drivers Table**
- Primary Key: DriverID (INT, IDENTITY)
- Unique: LicenseID
- Foreign Key: RegisteredBy → Users.UserID
- Indexes: LicenseID, CreatedDate, RegisteredBy
- Purpose: Store driver license information

**VerificationLogs Table**
- Primary Key: LogID (INT, IDENTITY)
- Foreign Key: CheckedBy → Users.UserID
- Indexes: LicenseID, CheckedDate, CheckedBy, VerificationStatus
- Purpose: Audit trail of all verifications

### Data Integrity

**Constraints:**
- Primary Keys: Ensure uniqueness
- Foreign Keys: Maintain referential integrity
- Unique Constraints: Prevent duplicates (Username, LicenseID)
- Check Constraints: Validate status values

**Indexes:**
- Improve query performance
- Speed up lookups by LicenseID
- Optimize date range queries
- Enhance join operations

---

## API Design

### RESTful Principles

The API follows REST conventions:

| Method | Endpoint | Purpose | Auth Required |
|--------|----------|---------|---------------|
| POST | /api/auth/login | Login | No |
| GET | /api/driver | Get all drivers | Yes |
| GET | /api/driver/{id} | Get driver by ID | Yes |
| POST | /api/driver/register | Register driver | Yes |
| POST | /api/verification/verify | Verify license | Yes |
| GET | /api/verification/status/{id} | Get status | Yes |
| GET | /api/verification/logs | Get logs | Yes |
| GET | /api/verification/export | Export CSV | Yes |

### Request/Response Format

**Standard Response Structure:**
```json
{
  "success": true,
  "message": "Operation successful",
  "data": { /* payload */ }
}
```

**Error Response:**
```json
{
  "success": false,
  "message": "Error description",
  "data": null
}
```

### HTTP Status Codes

| Code | Meaning | Usage |
|------|---------|-------|
| 200 | OK | Successful GET/POST |
| 201 | Created | Resource created |
| 400 | Bad Request | Invalid input |
| 401 | Unauthorized | Missing/invalid token |
| 404 | Not Found | Resource not found |
| 409 | Conflict | Duplicate resource |
| 500 | Server Error | Internal error |

---

## Security Architecture

### Authentication Flow

```
┌──────────┐                    ┌──────────┐
│  Client  │                    │   API    │
└────┬─────┘                    └────┬─────┘
     │                               │
     │ 1. POST /auth/login           │
     │   {username, password}        │
     ├──────────────────────────────>│
     │                               │
     │                          2. Validate
     │                          3. Hash check
     │                          4. Generate JWT
     │                               │
     │ 5. Return token               │
     │   {token, expiresAt}          │
     │<──────────────────────────────┤
     │                               │
     │ 6. Store token locally        │
     │                               │
     │ 7. Subsequent requests        │
     │   Header: Bearer {token}      │
     ├──────────────────────────────>│
     │                               │
     │                          8. Validate token
     │                          9. Process request
     │                               │
     │ 10. Return response           │
     │<──────────────────────────────┤
     │                               │
```

### Security Measures

**1. Password Security**
- BCrypt hashing (cost factor: 12)
- Salted hashes
- No plain text storage

**2. JWT Authentication**
- HS256 algorithm
- 24-hour expiration
- Signed tokens
- Claims-based authorization

**3. API Security**
- HTTPS in production
- CORS configuration
- Input validation
- SQL injection prevention (EF Core)
- XSS protection

**4. Database Security**
- Parameterized queries
- Least privilege access
- Connection string encryption
- Regular backups

---

## Data Flow

### Driver Registration Flow

```
1. User scans license
   ↓
2. OCR extracts data
   ↓
3. Navigate to register screen
   ↓
4. User reviews/edits data
   ↓
5. Submit registration
   ↓
6. API validates data
   ↓
7. Check for duplicates
   ↓
8. Save to database
   ↓
9. Return success/error
   ↓
10. Show confirmation
```

### License Verification Flow

```
1. User scans QR code
   ↓
2. Extract license ID
   ↓
3. Send to API
   ↓
4. Query database
   ↓
5. Check if exists
   ├─ Not found → Fake
   ├─ Expired → Expired
   └─ Valid → Real
   ↓
6. Compare QR data (if provided)
   ↓
7. Log verification
   ↓
8. Return status
   ↓
9. Display result
```

---

## Design Patterns

### Backend Patterns

**1. Repository Pattern**
- Abstracts data access
- Testable code
- Separation of concerns

**2. Dependency Injection**
- Loose coupling
- Testability
- Flexibility

**3. Factory Pattern**
- ApiResponseHandler
- Standardized responses

**4. Middleware Pattern**
- Request pipeline
- Cross-cutting concerns

### Frontend Patterns

**1. Service Pattern**
- Encapsulate API calls
- Reusable logic

**2. State Management**
- StatefulWidget
- setState()

**3. Builder Pattern**
- UI composition
- Reusable widgets

---

## Performance Considerations

### Backend Optimization

- **Async/Await**: All I/O operations
- **Connection Pooling**: EF Core default
- **Indexing**: Database indexes on key columns
- **Caching**: Consider Redis for frequent queries

### Mobile App Optimization

- **Image Compression**: Reduce upload size
- **Lazy Loading**: Load data on demand
- **Local Caching**: Store frequently accessed data
- **Debouncing**: Prevent rapid API calls

---

## Scalability

### Horizontal Scaling

- Stateless API design
- Load balancer ready
- Database connection pooling

### Vertical Scaling

- Optimize queries
- Add database indexes
- Increase server resources

---

## Future Enhancements

1. **Microservices**: Split into smaller services
2. **Caching Layer**: Redis for performance
3. **Message Queue**: RabbitMQ for async processing
4. **CDN**: For static assets
5. **Monitoring**: Application Insights
6. **CI/CD**: Automated deployment

---

**Architecture designed for maintainability, scalability, and security.**
