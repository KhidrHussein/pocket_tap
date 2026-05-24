# Design Document: PocketTap

**Version:** 1.1
**Type:** Mobile Application (iOS & Android)
**Core Concept:** An ultra-low-friction, widget-first financial tracker. It shifts user psychology from reactive tracking ("Where did my money go?") to proactive pacing ("How much can I spend today without ruining my month?").

## 1. Architecture & Tech Stack
The architecture optimizes for immediate local reads/writes to ensure the widget never lags.
* **Framework:** Flutter (allows a single codebase for the app and seamless integration with native OS features).
* **Widget Bridge:** `home_widget` package to communicate between Dart and native iOS WidgetKit / Android AppWidgets.
* **Storage:** Local-first using Isar or Hive. Instant read/write times; no cloud latency or server costs for the MVP.
* **State Management:** Riverpod (handles the dynamic daily recalculations efficiently).

## 2. Design System
The visual language is brutalist, high-contrast, and focused strictly on typography. It should induce clarity and feel like an objective financial tool, not a playful gamified app.

| Element | Specification |
| :--- | :--- |
| **Typography** | Space Grotesk or SF Pro Display. Monospaced numbers are mandatory to prevent layout shifting when balances change. |
| **Primary Color** | #FFFFFF (White) or #000000 (Black), dynamically adapting to system dark/light mode. |
| **Background** | #000000 (Pure OLED black) or #F9FAFB (Off-white). |
| **Accents** | #EF4444 (Red) for Expenses [ - ]. #10B981 (Green) for Income [ + ]. |
| **UI Paradigm** | Flat, edge-to-edge touch targets. No gradients, drop shadows, or rounded corner excesses. |

## 3. The Math: Rolling Daily Allowance Engine
The app calculates the daily allowance dynamically so the user never has to think about the math. If they underspend today, tomorrow's budget increases. If they get an unexpected gig and log income, their daily allowance expands.

The engine uses the following logic to determine today's available balance:
$$A_d = \left( \frac{B_m}{D_m} \right) + S_{d-1} + I_t - E_t$$

Where:
* $A_d$: Available balance for today.
* $B_m$: Base monthly budget set during onboarding.
* $D_m$: Total days in the current month.
* $S_{d-1}$: The accumulated surplus (or deficit) carried over from all previous days in the month.
* $I_t$: Total unexpected income logged today via the [ + ] button.
* $E_t$: Total expenses logged today via the [ - ] button.

## 4. Functionality Breakdown & UX Flow

### A. The 5-Second Onboarding
Zero account creation. Zero API syncing.
* **Screen 1:** A pure black screen with large white text: "What is your baseline spending limit for this month?"
  * **Input:** A massive native number pad. As the user types, the number appears in huge typography (e.g., ₦100,000).
* **Screen 2:** "You have ₦3,225 to spend today. Let's keep it that way." alongside a prompt to add the widget to their home screen.

### B. The Home Screen Widget (Core Interface)
The widget is a 2x2 square. It acts as the primary truth board.
* **The Main Display:** Dead center, showing $A_d$.
  * Positive balance: ₦3,225 (White/Black text).
  * Negative balance: -₦1,500 (Red text, signaling they are borrowing from tomorrow).
* **The Action Buttons:** Two floating buttons at the bottom of the widget: a Green [ + ] on the left and a Red [ - ] on the right.
* **The Burn Indicator:** A 2px high horizontal line at the very bottom edge. It remains dark gray until the daily budget hits 75% consumed, turning yellow, and then bright red if they go negative.

### C. The Quick-Entry Overlay (Zero Friction Logging)
Tapping [ + ] or [ - ] on the widget triggers a deep link that opens the app with a completely transparent background (or heavy Gaussian blur over the OS home screen).
* **The Input Area:** The native keyboard immediately focuses.
* **The Format:** The user types the amount, optionally followed by a space and a tag.
  * Example 1: `4000 food`
  * Example 2: `15000 freelance gig`
  * Example 3: `1500` (No tag, defaults to "Untagged").
* **The Resolution:** The user hits 'Enter' on the keyboard. The overlay instantly closes via `SystemNavigator.pop()`, and the widget updates its balance and burn line within a second.

### D. The Main App (The Ledger & Recovery Room)
If the user taps the center balance text on the widget (not the action buttons), the full app opens.
* **Top Header:** Overall month health. "Day 24 of 31. ₦24,000 remaining overall."
* **The Ledger:** A clean, chronological scroll of the month's tagged entries.
  * `[ - ] ₦4,000 • food`
  * `[ + ] ₦15,000 • freelance gig`
* **Adjustments:** A settings gear to "Adjust Monthly Limit" or change the rollover reset date (e.g., for users whose salary cycle runs from the 25th to the 25th).

---

## Implementation Plan

1. **Project Setup & Initialization:**
   * Create Flutter project using `flutter create pocket_tap`.
   * Configure project structure (models, views, viewmodels, services).
   * Install core dependencies: `flutter_riverpod`, `isar` (or `hive`), `home_widget`, `go_router`, `google_fonts`.

2. **Core Data & Logic Layer:**
   * Implement Isar/Hive database schemas for `Transaction` and `UserConfig`.
   * Create Riverpod providers for database access.
   * Develop the "Rolling Daily Allowance Engine" logic (the math for $A_d$).

3. **UI/UX - App Interface:**
   * Implement Brutalist design theme (custom `ThemeData`, Space Grotesk font).
   * Build the 2-step Onboarding screens.
   * Build the Main App view (Ledger, month health header, settings).
   * Implement the Quick-Entry Overlay (transparent background, raw text parser).

4. **Widget Integration (`home_widget`):**
   * Configure iOS WidgetKit (Swift/SwiftUI) and Android AppWidgets (Kotlin/XML).
   * Set up data syncing from Flutter to native storage (UserDefaults/SharedPreferences).
   * Design native widgets matching the Brutalist aesthetic (2x2 square, central balance, burn indicator).
   * Implement deep linking for the `[+]` and `[-]` buttons on the widget to trigger the Quick-Entry Overlay.

5. **Testing & Polish:**
   * Test the daily rollover logic edge cases (month ends, timezone changes).
   * Ensure immediate state updates between the app overlay and widget.
   * Finalize system dark/light mode responsiveness.
