# Workspace Rules

## Clean Up Temporary Scripts
Whenever you create temporary scripts (like `fix_xyz.py`, `test.py`, `parse.js`, etc.) to modify code, analyze data, or run tests, you MUST delete them immediately after you are finished using them. 

Do not leave them cluttering the project directory. Only retain scripts if they are intended to be reused as part of the project's permanent workflow (in which case, they should be placed in the `scripts/` directory).

## Local Javascript Verification
If you make changes to the Javascript engine inside `public/index.html`, you MUST test the syntax locally before you commit and push to production. 
Because Node.js is not installed on this machine, you must use macOS's built-in Javascript engine via the terminal:
`osascript -l JavaScript -e "$(cat public/index.html | grep -o '<script>.*</script>' || awk '/<script>/{flag=1; next} /<\/script>/{flag=0} flag')"`
If it throws `ReferenceError: Can't find variable: window`, it means the syntax successfully parsed.
# OptiRewards: AI Agent Design Document & Blueprint

> **Target Audience:** Autonomous AI Agents, LLM Code Assistants, and Systems Engineers.
> **Purpose:** This document provides the rigorous architectural, logic, and UI specifications required to replicate OptiRewards exactly, without needing to reference the original source code.

## 1. System Architecture (Serverless Client-Side)

OptiRewards operates as a **100% Serverless, Client-Side Application**. It relies purely on static file hosting for 0ms latency and full offline capability.

*   **`index.html`**: A Vanilla JS Single Page Application (SPA). Contains all CSS, DOM logic, state management, and the recommendation engine.
*   **`catalog.json`**: The static database containing card metadata, reward rules, merchant regex mappings, and quarterly calendars.
*   **No Build Step:** There is no Webpack, Babel, or React. Everything runs natively in modern browsers.
*   **PWA Readiness:** `index.html` requires `<link rel="manifest" href="manifest.json">`, `<meta name="apple-mobile-web-app-capable" content="yes">`, and `<meta name="apple-mobile-web-app-status-bar-style" content="black-translucent">` to function as an installable Progressive Web App.

## 2. Data Models & State Management

### 2.1 `catalog.json` Schema
The static JSON payload fetched on boot must conform to this structure:
```json
{
  "metadata": { "version": "1.0", "card_count": 199 },
  "quarterly_calendars": {
    "chase_freedom_flex": { "Q1": ["groceries"], "Q3": ["gas_stations", "public_transit"] }
  },
  "merchant_mappings": [
    {
      "id": "m_0",
      "merchant_name": "Kroger Family",
      "merchant_pattern": "kroger|ralphs|dillons",
      "category_key": "groceries",
      "brand_icon": "store"
    }
  ],
  "cards": [
    {
      "id": "chase_sapphire_reserve",
      "name": "Chase Sapphire Reserve",
      "issuer_id": "chase",
      "network": "Visa",
      "card_type": "personal",
      "currency_name": "Ultimate Rewards",
      "currency_type": "points",
      "point_valuation_cents": 2.0,
      "base_rate": 1.0,
      "annual_fee": 550,
      "local_image_path": "assets/cards/chase_sapphire_reserve.png",
      "categories": [
        { "category_key": "dining", "category_name": "Dining", "multiplier": 3.0 },
        { "category_key": "travel", "category_name": "Travel", "multiplier": 3.0 }
      ]
    }
  ]
}
```

### 2.2 Client-Side State
The app manages state purely in memory and persists critical data to `localStorage`:
*   **Persistent State (`localStorage`)**:
    *   `userWallet`: JSON Array of full card objects the user has added to their wallet.
    *   `userValuations`: JSON Dictionary mapping `currency_name` to a float `cents_per_point`.
*   **In-Memory UI State (`index.html`)**:
    *   `selectedIssuerFilter`, `selectedRewardFilter`, `selectedTypeFilter`: String states that control the visual filtering of the Wallet tab.
    *   **Valuation Presets:** Hardcoded preset functions in the UI:
        *   `cash`: Sets all valuations to 1.0.
        *   `travel`: Hilton=0.5, Marriott=0.8, IHG=0.5, all others=1.5.
        *   `max`: Ultimate Rewards=2.2, Membership Rewards=2.0, Capital One Miles=1.8, Bilt Rewards=2.2, ThankYou Points=1.8.

## 3. Core Algorithms & Logic

### 3.1 Recommendation Engine (Yield Calculation)
The core function `getLocalRecommendation(query, forcedCatKey)` computes the optimal card:
1.  **Merchant Resolution:** 
    *   Iterates through `catalog.merchant_mappings`. If the query regex matches `merchant_pattern` or includes `merchant_name`, it sets `categoryKey`.
    *   **Heuristic Fallbacks:** If no match, it aggressively scans the query for exact keywords:
        *   `grocery`, `supermarket`, `kroger`, `safeway`, `publix`, `aldi`, `heb` -> `groceries`
        *   `restaurant`, `cafe`, `burger`, `pizza`, `mcdonald`, `chipotle` -> `dining`
        *   `gas`, `fuel`, `shell`, `exxon`, `wawa` -> `gas_stations`
        *   `airline`, `flight`, `delta`, `united` -> `travel`
        *   `hotel`, `resort`, `marriott`, `hilton`, `hyatt` -> `hotels`
        *   `uber`, `lyft` -> `rideshare`
2.  **Category Equivalency (`isCategoryMatch`):**
    *   The app uses a 2D array of strict equivalencies: `['restaurants', 'dining', 'food_delivery', 'food']`, `['flights', 'airfare', 'travel']`, `['hotels', 'travel']`, `['groceries', 'supermarket', 'grocery_delivery']`, etc.
    *   It also checks if `cardCategory.startsWith(queryCategory)` or vice versa.
3.  **Multiplier Evaluation:**
    *   Base rate is applied.
    *   Checks `card.categories` for matches against `categoryKey` using the equivalency logic.
    *   **Rotating Bonus Logic:** If `category_key` is `rotating_bonus`, it checks `catalog.quarterly_calendars[card.id][currentQuarter]`. If a match exists, applies 5%.
4.  **Yield Math:** `Effective Yield = Multiplier × Valuation Cents`.
5.  **Edge Cases:** Costco only accepts Visa. If query contains "costco" and card network is not Visa, `yieldPct` is forced to 0.0.
6.  **Sorting & Tie-Breakers:** Cards are sorted by `Effective Yield` descending. Ties are broken by the card's index position in `userWallet` (lower index = higher priority). Cards **not** in the wallet are forced to the lowest possible priority (`0`).

### 3.2 GPS & OpenStreetMap Overpass Integration
*   Uses Overpass API to query nodes within 5000m:
    *   `amenity~restaurant|fast_food|cafe` -> `dining`
    *   `shop~supermarket|convenience` -> `groceries`
    *   `shop~wholesale` -> `wholesale_clubs`
    *   `shop~department_store|clothes` -> `online_shopping`
*   Calculates Haversine distance, deduplicates by name, sorts by distance, and renders the top 5 `poi-item`s. Tapping one passes its exact `catKey` to the recommendation engine as `forcedCatKey`.

## 4. UI / UX Specifications

### 4.1 Simulated iOS Native Interface
*   **Simulated UI Quirks:** The web interface renders a `.dynamic-island` (with mock camera/sensor divs) and a `.status-bar` featuring a real-time JS clock (`setInterval(updateTime, 1000)`) to perfectly mock a native iPhone environment when viewed on desktop browsers.

### 4.2 Global CSS & Mobile Layout
*   **Mobile Device Frame:** The `.device-frame` class expands on mobile (`max-width: 768px`) to:
    ```css
    height: 100dvh;
    padding-top: env(safe-area-inset-top);
    ```
    **Critical:** `position: fixed` must NOT be used for the `.device-frame` or `.tab-bar` on iOS Safari. Use `position: absolute` within the `100dvh` container.

### 4.3 Search Inputs & Focus Preservation
*   Native WebKit clear buttons (`::-webkit-search-cancel-button`) are disabled. The app uses a custom `✖` button.
*   Because the app is a VDOM-less SPA, `render()` wipes `innerHTML`. The active input ID and cursor selection (`selectionStart`/`selectionEnd`) are cached before rendering and synchronously restored afterward to prevent the iOS keyboard from dismissing mid-keystroke.

### 4.4 Drag-and-Drop Wallet Ordering
*   In the Wallet tab, users drag a handle to reorder cards using touch events (`touchstart`, `touchmove`, `touchend`).
*   During drag, the item scales up (`scale(1.03)`) and gains a shadow. A `transform: translateY` is applied dynamically to siblings to create space.
*   On release, the visual order mutates the `userWallet` array in `localStorage`.

### 4.5 Wholesale Clubs Split
*   Tapping the Wholesale Clubs category triggers a hardcoded `wholesale_clubs_split` query, returning a multi-view recommendation displaying Costco (Visa restriction applied), Sam's Club, and BJ's concurrently.
