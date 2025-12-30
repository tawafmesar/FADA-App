# FADA — Food Allergy Detection & Analysis Application (FADA)

<img width="2991" height="969" alt="Fadaa" src="https://github.com/user-attachments/assets/2c6b1ad7-c3a1-45b1-9478-71006ffce1fe" />



> This document provides a clear project overview, technical architecture, deployment and development instructions, API references, and contribution guidelines suitable for professional audiences (maintainers, reviewers, and developers).

---

<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**

  - [Project Overview](#project-overview)
  - [Key Features](#key-features)
  - [App Screenshots](#app-screenshots)
  - [Technology Stack](#technology-stack)
  - [Repository structure (high-level)](#repository-structure-high-level)
  - [Quick Start — Local Development](#quick-start--local-development)
    - [Prerequisites](#prerequisites)
- [&#035;## Backend (PHP + MySQL)](#-backend-php--mysql)
    - [Frontend (Flutter)](#frontend-flutter)
  - [Configuration and Environment](#configuration-and-environment)
  - [Database](#database)
  - [API Reference (Summary)](#api-reference-summary)
    - [Authentication](#authentication)
    - [Forgot password](#forgot-password)
    - [Allergy Management](#allergy-management)
    - [Scan History](#scan-history)
  - [Testing](#testing)
  - [Building & Release](#building--release)
  - [Contributing](#contributing)
  - [Security & Privacy Notes](#security--privacy-notes)
  - [Design assets & diagrams](#design-assets--diagrams)
  - [License](#license)
  - [Contact / Maintainers](#contact--maintainers)
  - [Appendix — Useful commands & tips](#appendix--useful-commands--tips)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->


<a name="project-overview"></a>

## Project Overview

FADA (Food Allergy Detection & Analysis Application) is a cross-platform mobile application built with Flutter that helps users scan food product labels, detect potential allergens using OCR and AI, manage personal allergen profiles, and keep a scan history. The backend is implemented in PHP and uses a MySQL database. The project includes features such as user authentication, image cropping, text recognition (Google ML Kit), optional AI ingredient analysis (Gemini), allergy management, and scan history.

The repository you are about to make public contains all source code, backend endpoints, database schema, and documentation (design diagrams and feasibility study).

---

<a name="key-features"></a>

## Key Features

* Secure user authentication: sign up, login, verification code, password reset flows.

* Image picker + cropping for improved OCR accuracy.

* Text recognition using Google ML Kit and optional AI-powered ingredient analysis.

* Allergy management: add, activate, deactivate, and remove allergens.

* Scan processing and real-time allergy warnings.

* Scan history: persist and retrieve past scans with timestamps and recognized text.

* Backend REST-ish PHP endpoints with simple JSON responses.

* Full documentation included: SRS, feasibility study, project plan, diagrams (DFD, UML, ERD).

---

<a name="app-screenshots"></a>

## App Screenshots



| Registration Screen | Email Verification Screen | Login Screen | Forget Password Screen | Verification Screen |
| :---: | :---: | :---: | :---: | :---: |
| ![Registration](https://github.com/user-attachments/assets/2e8a599f-2084-4974-8561-1839632dca7b) | ![Email Verification Screen](https://github.com/user-attachments/assets/32ed932b-c38d-410b-a99a-93176eebd58e) | ![Login](https://github.com/user-attachments/assets/6e93e447-b4ba-4a81-8062-666f5097091a) | ![Forget Password](https://github.com/user-attachments/assets/2b19e007-92fa-4f75-ab7c-3b19e23579a0) | ![Verification](https://github.com/user-attachments/assets/30e5eeca-c800-453b-965c-52e2fdcc8dac) |

<br>

| Reset Password Screen | Scan Screen (Allergy List) | Add Allergens to the List | Pop-up Modal for Image Scanning | Image Selection from Gallery |
| :---: | :---: | :---: | :---: | :---: |
| ![Reset Password](https://github.com/user-attachments/assets/376e7512-367a-472d-8a6a-c4fcc031ab02) | ![Scan Screen](https://github.com/user-attachments/assets/81ce2226-cb50-4b5f-a130-52869dc07fa0) | ![Add Allergens](https://github.com/user-attachments/assets/b0cd4627-43fc-4a1a-b521-29435a701066) | ![Scan Modal](https://github.com/user-attachments/assets/a85358ad-634b-4f9e-a10a-64be7d4d084c) | ![Gallery Selection](https://github.com/user-attachments/assets/bfd393aa-b6c0-418b-8072-47cd60d7c0cc) |

<br>

| Image Cropping Feature | Recognized Text & Allergy Alert | Scan History List | Scan History (Shimmer) | Scan Details View |
| :---: | :---: | :---: | :---: | :---: |
| ![Image Cropping](https://github.com/user-attachments/assets/47ff2891-76af-4584-870b-76a6c34b7f6b) | ![Allergy Alert](https://github.com/user-attachments/assets/6d39be1f-3556-4184-94c6-e8999b6814f0) | ![Scan History](https://github.com/user-attachments/assets/85a49ff3-9cef-454e-adda-171bfc6c7bd2) | ![Scan History Shimmer](https://github.com/user-attachments/assets/7bd13cb1-bfa7-4303-997f-e64d3bb4f1e0) | ![Scan Details View](https://github.com/user-attachments/assets/cb891187-cdd2-4fd9-9f95-928d104afb7d) |

<br>

| Scan Details View 2 | Pop-up Modal with AI Scanner | Pop-up Modal — Select Scan Type | Image Cropping (AI) | Result with Allergy Alert (AI) |
| :---: | :---: | :---: | :---: | :---: |
| ![Scan Details View 2](https://github.com/user-attachments/assets/665a27e1-5ba5-44d6-96cf-913f6e8fff5f) | ![Pop-up Modal with AI Scanner](https://github.com/user-attachments/assets/9a4155a5-6dc1-4304-935f-0378e5424ff8) | ![Scan Type](https://github.com/user-attachments/assets/8cba9cd5-af73-40b9-8c12-88f4df407b6a) | ![Image Cropping AI](https://github.com/user-attachments/assets/0849be3d-8a5f-4827-8203-9e1b65b516ae) | ![Result Allergy Alert](https://github.com/user-attachments/assets/0bf4388f-dacf-4252-95be-7aed95496ed9) |

---

<a name="technology-stack"></a>

## Technology Stack

* Frontend: Flutter (Dart), packages include `flutter_dotenv`, `get`, `http`, `file_picker`, (and others listed in `pubspec.yaml`).

* Backend: PHP (PDO + MySQL), PHPMailer for email, plain PHP controllers (no composer dependency required for core code—PHPMailer is included under `src/backend/includes/`).

* Database: MySQL (schema provided).

* Optional: Gemini AI integration from Flutter (`flutter_gemini` imported in the app) — API key must be configured in the `.env` for the Flutter app if used.

---

<a name="repository-structure"></a>

## Repository structure (high-level)

```
FADA-App-main/
├─ LICENSE
├─ README.md (original)
├─ docs/                       # Project documents & diagrams (preface, SRS, feasibility, design)
├─ src/
│  ├─ fada/                    # Flutter app
│  │  ├─ lib/                  # Flutter source files
│  │  ├─ pubspec.yaml
│  │  └─ assets/
│  └─ backend/                 # PHP backend
│     ├─ allergydb/            # Allergy management endpoints
│     ├─ auth/                 # Authentication endpoints
│     ├─ scanhistory/          # Scan history endpoints
│     ├─ forgetpassword/       # Password reset endpoints
│     ├─ includes/             # PHPMailer and helpers
│     ├─ connect.php           # DB connection + env loader
│     └─ database/fadadb.sql   # DB schema and seed
```

> Note: The Flutter project contains many controllers and screens under `lib/` (e.g., `ai_scanner_screen.dart`, `scan_screen.dart`, `scan_history_screen.dart`, `recognization_page.dart`, and controllers for auth, scan history, allergy management). The backend PHP folder contains the full set of endpoints required by the app.

---

<a name="quick-start--local-development"></a>

## Quick Start — Local Development

These instructions assume you are preparing this repository to be public and want other developers to be able to run it locally.

### Prerequisites

* Flutter SDK (2.10+ recommended, or a stable channel compatible with the codebase).

* Android Studio / Xcode or another device/emulator to run the Flutter app.

* PHP 7.4+ with PDO MySQL enabled.

* MySQL / MariaDB server.

* A local web server environment (XAMPP, MAMP, LAMP) or Docker.

* Optional: Android emulator (note Android emulator address mapping `10.0.2.2` is used by default in the app).

# ### Backend (PHP + MySQL)

1. Copy the backend folder to your web server document root. Example paths:

   * Linux: `/var/www/html/fada-backend`
   * Windows (XAMPP): `C:\xampp\htdocs\fada-backend`

2. Import the database schema.

   **2.a — Using MySQL CLI**

   ```bash
   mysql -u root -p < src/backend/database/fadadb.sql
   ```

   **2.b — Import database using phpMyAdmin (GUI)**
   If you prefer a GUI, `phpMyAdmin` provides a simple way to import the SQL schema file.

   ### Steps (phpMyAdmin)

   1. Open phpMyAdmin in your browser (example):
      `http://localhost/phpmyadmin` or the path provided by your hosting control panel.

   2. Create the database (if it does not exist):

      * Click **Databases** → enter `fadadb` (or your DB name) → choose collation `utf8mb4_unicode_ci` → **Create**.

      *Or run this SQL in phpMyAdmin → **SQL** tab:*

      ```sql
      CREATE DATABASE IF NOT EXISTS fadadb
        CHARACTER SET utf8mb4
        COLLATE utf8mb4_unicode_ci;
      ```

   3. Select the newly created database from the left sidebar.

   4. Import the SQL file:

      * Click the **Import** tab.
      * Click **Choose File** and select `src/backend/database/fadadb.sql` from your repository.
      * Ensure **Format** is `SQL`.
      * Click **Go** and wait for the upload/import to finish.

   5. Verify tables: after import completes, phpMyAdmin will show the list of tables (e.g., `users`, `allergen`, `userallergen`, `scanhistory`).

3. Configure the backend environment variables. Create a `.env` file inside `src/backend/` and set the following variables:

```
DB_HOST=127.0.0.1
DB_NAME=fadadb
DB_USER=root
DB_PASSWORD=your_db_password
SMTP_USER=your_smtp_user@example.com
SMTP_PASSWORD=your_smtp_password
```

> The backend uses `src/backend/env.php` to load this `.env` file. PHPMailer is bundled under `src/backend/includes/`.

4. Ensure filesystem permissions:

   * Ensure the PHP server can write to `upload/` if present (for images).
   * Make sure `connect.php` (and other config files) have the correct permissions for your environment (not world-writable; readable by the web server user).

5. Test an endpoint with `curl` or Postman. For example (adjust `SERVER_URL` to your installation):

```bash
curl -X POST "http://localhost/fada-backend/auth/signup.php" \
  -F "username=alice" -F "password=secret" -F "email=alice@example.com"
```



### Frontend (Flutter)

1. Change server address if needed. By default the app uses `lib/linkapi.dart` with `server` pointing to `http://10.0.2.2/app/FADA-App/src/backend/` (this works for Android emulator mapping to local host). Update `lib/linkapi.dart` to point to your backend base URL (e.g., `http://192.168.1.10/fada-backend/` or your public URL):

```dart
static const String server = "http://YOUR_SERVER_ADDRESS/fada-backend/";
```

2. (Optional) Provide environment variables for AI integration. If you use Gemini or any other AI provider, create a `.env` in the Flutter project root (same folder as `pubspec.yaml`) and add keys. Example:

```
GEMINI_API_KEY=sk-xxx
API_BASE_URL=http://YOUR_SERVER_ADDRESS/fada-backend/
```

3. Install Flutter packages and run the app:

```bash
cd src/fada
flutter pub get
flutter run
```

> For local emulator testing, Android emulator resolves host machine loopback as `10.0.2.2`. If you host backend on the same machine, keep `server` as `http://10.0.2.2/...`.

---

<a name="configuration-and-environment"></a>

## Configuration and Environment

Two places require configuration:

1. **Backend `.env`** (create in `src/backend/`):

```
DB_HOST=127.0.0.1
DB_NAME=fadadb
DB_USER=root
DB_PASSWORD=your_db_password
SMTP_USER=youremail@example.com
SMTP_PASSWORD=your_smtp_password
```

2. **Frontend `.env`** (create in `src/fada/` next to `pubspec.yaml`, optional):

```
GEMINI_API_KEY=your_gemini_api_key_here
API_BASE_URL=http://YOUR_SERVER_ADDRESS/fada-backend/
```

Also update `lib/linkapi.dart` or the equivalent constants to match your `API_BASE_URL` if the project does not read it from env.

---

<a name="database"></a>

## Database

* The SQL schema is in `src/backend/database/fadadb.sql`.

* Import it into your MySQL server to create the tables and seed data (if present).

* Important tables: `users`, `allergen`, `userallergen`, `scanhistory`, `allergenic_derivatives`, etc.

---

<a name="api-reference-summary"></a>

## API Reference (Summary)

> The backend exposes several PHP endpoints. Below is a concise reference to the most important endpoints for developers integrating or testing the mobile app.

**Base URL**: `http://<server>/path-to-backend/src/backend/` (update `linkapi.dart` accordingly)

### Authentication

| Endpoint              | Method | Parameters                                   | Description                                                                 |
| --------------------- | -----: | -------------------------------------------- | --------------------------------------------------------------------------- |
| `auth/signup.php`     |   POST | `username`, `password` (form field), `email` | Register new user. Returns success/failure and triggers verification email. |
| `auth/login.php`      |   POST | `email`, `password`                          | Login, returns user data if credentials match.                              |
| `auth/verfiycode.php` |   POST | `email`, `verfiycode`                        | Verify sign-up code.                                                        |
| `auth/resend.php`     |   POST | `email`                                      | Re-send verification code.                                                  |

### Forgot password

| Endpoint                           | Method | Parameters                       | Description                      |
| ---------------------------------- | -----: | -------------------------------- | -------------------------------- |
| `forgetpassword/checkemail.php`    |   POST | `email`                          | Initiates reset by sending code. |
| `forgetpassword/verifycode.php`    |   POST | `email`, `verfiycode`            | Verify reset code.               |
| `forgetpassword/resetpassword.php` |   POST | `email`, `password` (form field) | Reset password.                  |

### Allergy Management

| Endpoint                          |   Method | Parameters                                             | Description                                           |
| --------------------------------- | -------: | ------------------------------------------------------ | ----------------------------------------------------- |
| `allergydb/add.php`               |     POST | `ingredient_name`, `description`, `created_by_user_id` | Add new allergen record.                              |
| `allergydb/view.php`              | GET/POST | (none or query-based)                                  | View allergens and derivatives.                       |
| `allergydb/activateAllergy.php`   |     POST | `id` (allergy id), `user_id`                           | Activate allergy for a user (adds to `userallergen`). |
| `allergydb/deactivateAllergy.php` |     POST | `id`, `user_id`                                        | Deactivate allergy for a user (removes relation).     |
| `allergydb/remove.php`            |     POST | `id`                                                   | Remove allergy from system (admin action).            |

### Scan History

| Endpoint               |   Method | Parameters                                                                      | Description                                     |
| ---------------------- | -------: | ------------------------------------------------------------------------------- | ----------------------------------------------- |
| `scanhistory/add.php`  |     POST | `recognized_text`, `result`, `user_id`, `scan_type`, file upload field (`file`) | Add a scan record; uploads image when provided. |
| `scanhistory/view.php` | GET/POST | `id` (user_id)                                                                  | Retrieve all scan history for a user.           |

> All endpoints accept form-encoded POST data (files use multipart/form-data for upload). Responses are JSON in most controller helpers.

---

<a name="testing"></a>

## Testing

* Use Postman or curl to test endpoints.

* Create test users via `auth/signup.php`.

* Use the Flutter app in debug mode to test end-to-end flows.

* Unit/widget tests: none are included by default — consider adding `test/` folder with unit tests for key controllers.

---

<a name="building--release"></a>

## Building & Release

* Android: `flutter build apk --release` or `flutter build appbundle`.

* iOS: `flutter build ios` (requires macOS and Xcode).

* Ensure the backend URL in `lib/linkapi.dart` points to the production API when building release versions.

---

<a name="contributing"></a>

## Contributing

Thank you for contributing. Please follow these guidelines:

1. Fork the repository and create a topic branch: `feature/your-feature` or `fix/issue-number`.

2. Write clear, atomic commits and include tests where appropriate.

3. Open a pull request with a descriptive title and link to any related issue.

4. Include screenshots or recordings for UI changes and add API contract updates if endpoints change.

Pull requests in this repository already include feature-level descriptions and close issues such as:

* Documentation and design artifacts (Docs/fada prepar #2)

* Authentication, bottom navigation and custom drawer (Feature/auth bottomnav drawer #4)

* Allergy scanning and processing (Feature/scan allergy #7)

* Scan history management (Feature/scan history #9)

* AI-powered ingredient analysis (Feature/ai food allergy check #11)

---

<a name="security--privacy-notes"></a>

## Security & Privacy Notes

* Do **not** commit `.env` files or API keys to the public repository. Add sensitive files to `.gitignore`.

* The SQLite/MySQL database may contain personal user data. When publishing the repository, ensure no production credentials or PII are included in the source.

* PHPMailer credentials (SMTP username/password) are read from the backend `.env`. Rotate credentials after publishing.

* Validate and sanitize all user inputs server-side (the project uses `filterRequest()` helpers; review for edge cases).

---

<a name="design-assets--diagrams"></a>

## Design assets & diagrams

The `docs/design-diagrams/` folder contains the full visual asset set: DFD Level 0/1, UML diagrams (class/use-case/activity/sequence), and ERD. Use these for onboarding, architecture reviews, and implementation planning.

---

<a name="license"></a>

## License

This project is licensed under the MIT License. See `LICENSE` for full text.

---

<a name="contact--maintainers"></a>

## Contact / Maintainers

* **Project owner:** Tawaf Mesar (as listed in the repository license)

* For issues, feature requests and security disclosures, please open an issue on the repository or send email to the maintainer listed in `AUTHORS`/project metadata.

---

<a name="appendix--useful-commands--tips"></a>

## Appendix — Useful commands & tips

* Import DB:

```bash
mysql -u <user> -p fadadb < src/backend/database/fadadb.sql
```

* Run backend locally using PHP's built-in server (for quick testing):

```bash
cd src/backend
php -S 0.0.0.0:8000

# then update linkapi.dart server to http://<host>:8000/
```

* Android emulator note: `10.0.2.2` maps to host machine `localhost` in Android emulator. The app already uses this for local development. When testing on a physical device, replace with the machine's LAN IP.

