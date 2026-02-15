# Application Screenshots
## DAFTech Driver License Registration & Verification System

This document contains screenshots of the application's key features and user interface.

---

## Table of Contents

1. [Mobile App Screenshots](#mobile-app-screenshots)
2. [Backend API Screenshots](#backend-api-screenshots)
3. [Database Screenshots](#database-screenshots)

---

## Mobile App Screenshots

### 1. Login Screen

**Description:** User authentication screen with username and password fields.

**Features:**
- Username input field
- Password input field (masked)
- Login button
- Modern gradient design
- Error message display

```
[Screenshot Placeholder: Login Screen]
- Shows login form
- DAFTech branding
- Input fields
- Login button
```

**Path to capture:** Launch app → Login screen

---

### 2. Home Screen

**Description:** Main dashboard with navigation to all features.

**Features:**
- Welcome message with user name
- Four main action cards:
  - Scan License (OCR)
  - Verify License (QR)
  - All Drivers
  - Logout
- Statistics display
- Modern card-based layout

```
[Screenshot Placeholder: Home Screen]
- Welcome banner
- Four feature cards
- Navigation options
- User profile
```

**Path to capture:** Login → Home screen

---

### 3. Scan License Screen

**Description:** Camera interface for capturing driver's license images.

**Features:**
- Camera preview
- Capture button
- Upload from gallery option
- Instructions banner
- Processing indicator

```
[Screenshot Placeholder: Scan License Screen]
- Camera interface
- Capture/Upload buttons
- Instructions
- Processing state
```

**Path to capture:** Home → Scan License

---

### 4. OCR Extraction Complete

**Description:** Display of extracted license data from OCR.

**Features:**
- License ID Number
- Full Name
- Date of Birth
- Grade (License Type)
- Expiry Date
- QR Raw Data (expandable)
- OCR Raw Text (expandable)
- Proceed to Registration button

```
[Screenshot Placeholder: Extraction Complete]
- Extracted data fields
- Expandable sections
- Proceed button
- Data validation indicators
```

**Path to capture:** Scan License → After image processing

---

### 5. Register Driver Screen

**Description:** Form to register a new driver with extracted data.

**Features:**
- Pre-filled OCR data
- Editable fields:
  - License ID
  - Full Name
  - Date of Birth (date picker)
  - Grade
  - Expiry Date (date picker)
- QR/OCR raw data display
- Register button
- Validation messages

```
[Screenshot Placeholder: Register Driver Screen]
- Form fields
- Date pickers
- Register button
- Validation feedback
```

**Path to capture:** Scan License → Extraction Complete → Register Driver

---

### 6. Registration Success

**Description:** Confirmation message after successful driver registration.

**Features:**
- Success icon
- Confirmation message
- Driver ID display
- Options to:
  - View driver details
  - Register another
  - Return to home

```
[Screenshot Placeholder: Registration Success]
- Success message
- Driver ID
- Action buttons
```

**Path to capture:** Register Driver → Submit → Success

---

### 7. Duplicate Detection

**Description:** Error message when attempting to register duplicate license.

**Features:**
- Warning icon
- Duplicate error message
- Existing license details
- Options to:
  - View existing driver
  - Return to home

```
[Screenshot Placeholder: Duplicate Detection]
- Error message
- Existing driver info
- Action buttons
```

**Path to capture:** Register Driver → Submit duplicate license

---

### 8. Verify License Screen

**Description:** QR code scanner for license verification.

**Features:**
- QR scanner camera view
- Manual entry option
- Scan frame overlay
- Instructions
- Flash toggle

```
[Screenshot Placeholder: Verify License Screen]
- QR scanner interface
- Scan frame
- Manual entry button
- Instructions
```

**Path to capture:** Home → Verify License

---

### 9. Verification Result - Real

**Description:** Display when license is verified as real and valid.

**Features:**
- Success icon (green)
- "Real" status badge
- Driver details:
  - Full Name
  - License ID
  - Expiry Date
- Verification timestamp
- Action buttons

```
[Screenshot Placeholder: Verification Real]
- Green success indicator
- Driver information
- Verification details
```

**Path to capture:** Verify License → Scan valid QR

---

### 10. Verification Result - Fake

**Description:** Display when license is not found in database.

**Features:**
- Error icon (red)
- "Fake" status badge
- Warning message
- License ID attempted
- Verification timestamp
- Report option

```
[Screenshot Placeholder: Verification Fake]
- Red error indicator
- Warning message
- License ID
```

**Path to capture:** Verify License → Scan unregistered QR

---

### 11. Verification Result - Expired

**Description:** Display when license has passed expiry date.

**Features:**
- Warning icon (orange)
- "Expired" status badge
- Driver details
- Expiry date highlighted
- Verification timestamp

```
[Screenshot Placeholder: Verification Expired]
- Orange warning indicator
- Expired date highlighted
- Driver information
```

**Path to capture:** Verify License → Scan expired license QR

---

### 12. All Drivers Screen

**Description:** List of all registered drivers.

**Features:**
- Search bar
- Driver cards with:
  - Full Name
  - License ID
  - Expiry Date
  - Status badge
- Tap to view details
- Pull to refresh
- Empty state message

```
[Screenshot Placeholder: All Drivers List]
- Search bar
- Driver cards
- Status indicators
- Scroll view
```

**Path to capture:** Home → All Drivers

---

### 13. Driver Details Screen

**Description:** Detailed view of a specific driver.

**Features:**
- Driver photo placeholder
- Full information:
  - License ID
  - Full Name
  - Date of Birth
  - Grade
  - Expiry Date
  - Registration Date
- QR code display
- OCR raw text
- Action buttons:
  - Verify
  - Share
  - Edit (if applicable)

```
[Screenshot Placeholder: Driver Details]
- Driver information
- QR code
- Action buttons
```

**Path to capture:** All Drivers → Tap driver card

---

## Backend API Screenshots

### 1. Swagger UI - Overview

**Description:** API documentation homepage.

**Features:**
- API title and version
- List of all endpoints grouped by controller
- Authentication section
- Try it out functionality

```
[Screenshot Placeholder: Swagger UI]
- API endpoints list
- Auth, Driver, Verification sections
- Authorize button
```

**URL:** `http://localhost:5182/swagger`

---

### 2. Swagger - Authentication

**Description:** Login endpoint documentation.

**Features:**
- POST /api/auth/login
- Request body schema
- Response examples
- Try it out button

```
[Screenshot Placeholder: Swagger Auth]
- Login endpoint
- Request/response schemas
- Example values
```

**URL:** `http://localhost:5182/swagger` → Auth section

---

### 3. Swagger - Driver Endpoints

**Description:** Driver management endpoints.

**Features:**
- GET /api/driver
- GET /api/driver/{licenseId}
- POST /api/driver/register
- Request/response schemas
- Authorization required indicator

```
[Screenshot Placeholder: Swagger Driver]
- Driver endpoints
- Schemas
- Authorization lock icons
```

**URL:** `http://localhost:5182/swagger` → Driver section

---

### 4. Swagger - Verification Endpoints

**Description:** Verification endpoints documentation.

**Features:**
- POST /api/verification/verify
- GET /api/verification/status/{licenseId}
- GET /api/verification/logs
- GET /api/verification/export
- Query parameters
- Response examples

```
[Screenshot Placeholder: Swagger Verification]
- Verification endpoints
- Query parameters
- Response schemas
```

**URL:** `http://localhost:5182/swagger` → Verification section

---

### 5. Swagger - Try It Out

**Description:** Testing an endpoint in Swagger.

**Features:**
- Request body editor
- Execute button
- Response display:
  - Status code
  - Response body
  - Headers
- Curl command

```
[Screenshot Placeholder: Swagger Try It Out]
- Request editor
- Execute button
- Response display
```

**URL:** `http://localhost:5182/swagger` → Any endpoint → Try it out

---

### 6. Swagger - Authorization

**Description:** JWT token authorization dialog.

**Features:**
- Authorization modal
- Token input field
- Format: Bearer {token}
- Authorize button
- Logout button

```
[Screenshot Placeholder: Swagger Authorization]
- Authorization dialog
- Token input
- Authorize button
```

**URL:** `http://localhost:5182/swagger` → Authorize button

---

## Database Screenshots

### 1. SQL Server Management Studio - Database

**Description:** Database structure in SSMS.

**Features:**
- DriverLicenseDB database
- Tables folder expanded:
  - Users
  - Drivers
  - VerificationLogs
- Indexes
- Stored procedures

```
[Screenshot Placeholder: SSMS Database]
- Database tree view
- Tables list
- Database objects
```

**Path:** SSMS → Connect → Databases → DriverLicenseDB

---

### 2. Users Table Data

**Description:** Users table with sample data.

**Features:**
- UserID
- Username
- PasswordHash (BCrypt)
- CreatedDate
- Status

```
[Screenshot Placeholder: Users Table]
- Table columns
- Sample user records
- Admin user visible
```

**Query:** `SELECT * FROM Users`

---

### 3. Drivers Table Data

**Description:** Drivers table with registered licenses.

**Features:**
- DriverID
- LicenseID
- FullName
- DateOfBirth
- LicenseType (Grade)
- ExpiryDate
- QRRawData
- OCRRawText
- CreatedDate
- RegisteredBy

```
[Screenshot Placeholder: Drivers Table]
- Table columns
- Driver records
- QR/OCR data
```

**Query:** `SELECT * FROM Drivers`

---

### 4. VerificationLogs Table Data

**Description:** Audit trail of all verifications.

**Features:**
- LogID
- LicenseID
- VerificationStatus (Real/Fake/Expired)
- CheckedBy
- CheckedDate

```
[Screenshot Placeholder: VerificationLogs Table]
- Table columns
- Verification records
- Status values
```

**Query:** `SELECT * FROM VerificationLogs`

---

### 5. Database Diagram

**Description:** Entity relationship diagram.

**Features:**
- Users table
- Drivers table
- VerificationLogs table
- Relationships:
  - Users → Drivers (RegisteredBy)
  - Users → VerificationLogs (CheckedBy)
- Primary keys
- Foreign keys

```
[Screenshot Placeholder: Database Diagram]
- ER diagram
- Table relationships
- Keys and constraints
```

**Path:** SSMS → Database Diagrams → New Diagram

---

## How to Capture Screenshots

### Mobile App

1. **Android Emulator:**
   - Run app: `flutter run`
   - Take screenshot: Camera icon in emulator toolbar
   - Or: `Ctrl + S` (Windows) / `Cmd + S` (Mac)

2. **Physical Device:**
   - Android: Power + Volume Down
   - iOS: Power + Volume Up

3. **Using Flutter:**
   ```bash
   flutter screenshot
   ```

### Backend API

1. Open browser: `http://localhost:5182/swagger`
2. Use browser screenshot tool:
   - Windows: `Win + Shift + S`
   - Mac: `Cmd + Shift + 4`
   - Or browser extension

### Database

1. Open SQL Server Management Studio
2. Navigate to desired view
3. Use Windows Snipping Tool or screenshot shortcut

---

## Screenshot Guidelines

When capturing screenshots:

✅ **Do:**
- Use high resolution (1080p or higher)
- Capture full screen or relevant section
- Include UI elements clearly
- Show realistic data (not test data)
- Use consistent device/browser
- Annotate if needed

❌ **Don't:**
- Include sensitive data (real passwords, personal info)
- Use blurry or low-quality images
- Crop important UI elements
- Mix different themes/styles

---

## Screenshot Storage

Recommended structure:
```
docs/
└── screenshots/
    ├── mobile/
    │   ├── 01-login.png
    │   ├── 02-home.png
    │   ├── 03-scan-license.png
    │   └── ...
    ├── backend/
    │   ├── 01-swagger-overview.png
    │   ├── 02-swagger-auth.png
    │   └── ...
    └── database/
        ├── 01-ssms-database.png
        ├── 02-users-table.png
        └── ...
```

---

## Adding Screenshots

To add actual screenshots to this document:

1. Capture screenshots following guidelines above
2. Save to `docs/screenshots/` folder
3. Replace placeholders with:
   ```markdown
   ![Description](screenshots/folder/filename.png)
   ```

Example:
```markdown
![Login Screen](screenshots/mobile/01-login.png)
```

---

**Note:** This document contains placeholders for screenshots. Actual screenshots should be captured during application testing and added to the `docs/screenshots/` directory.
