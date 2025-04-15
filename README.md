# Budgetly: Expense Tracker App

**Budgetly** is a sleek expense tracker app designed to help students track their expenses, set budgets, visualize spending habits, and monitor their accounts. Whether you're a student managing your limited budget or anyone wanting to better handle their finances, Budgetly helps you stay in control.

---

## Features

- **Add/Delete Expenses**: Easily add or remove expenses as you track your spending.
- **Category Tagging**: Organize expenses by categories like Food, Transportation, Entertainment, etc.
- **Monthly Summary**: See an overview of your expenses each month.
- **Expense Charts**: Visualize your spending with pie charts and bar graphs.
- **Account Monitoring**: Keep track of your bank accounts and balances.
- **Category-Wise Monitoring**: Drill down into each category to track where your money is going.

---

## Screenshots

*Add screenshots here if available.*

---

## Getting Started

This project is a starting point for the **Budgetly** Flutter app. Follow these instructions to set up the app locally.

### Prerequisites

- **Flutter** (>=2.x)
- **Firebase**
- **Riverpod**
- **Firestore**

---

### Installation

1. Clone the repository:
    ```bash
    git clone https://github.com/yourusername/budgetly.git
    ```

2. Navigate into the project folder:
    ```bash
    cd budgetly
    ```

3. Install dependencies:
    ```bash
    flutter pub get
    ```

4. Set up Firebase:
    - Follow Firebase setup for Flutter [here](https://firebase.flutter.dev/docs/overview).
    - Enable Firestore for your project.

5. Run the app:
    ```bash
    flutter run
    ```

---

## Usage

- Open the app and log in with your Firebase authentication (Google, Email, etc.).
- Add your expenses, categorize them, and set your budgets.
- Visualize your expenses through charts and monthly summaries.
- Monitor your account balances and track spending by categories.

---

## Tech Stack

- **Flutter** – Cross-platform app development
- **Riverpod** – State management
- **Firebase** – Authentication, Firestore, and Storage
- **Firestore** – NoSQL Database
- **Init Package** – Dependency Injection

---

## Folder Structure

```plaintext
/lib
 ├── main.dart            # App entry point
 ├── models/              # Data models
 ├── providers/           # Riverpod providers
 ├── screens/             # App screens (Home, Add Expense, Summary, etc.)
 ├── services/            # Firebase and other external services
 └── utils/               # Helper functions
