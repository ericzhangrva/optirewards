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
7.  **Recommendation Output (Top 3):** The engine must return the Top 3 highest yielding cards, not just the single best card.
8.  **Toggle Behavior:** Tapping a category chip once displays the Top 3 recommendations. Tapping the exact same category chip a second time must dismiss/close the recommendation box.

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

## 5. View Layer & Tab Specifications

### 5.1 Tab Structure
The application strictly contains 4 main tabs navigating the UI:

1.  **In-Store (`instore`)**: 
    *   **GPS Tracker:** Must feature a dedicated "Use My GPS" button (or automated trigger) that calls the Overpass API logic.
    *   **Category Taxonomy:** Must feature exactly these 9 physical category chips: Dining, Groceries, Gas Stations, Transit, Wholesale Clubs, Drugstores, Home Improvement, Phone & Internet, Gyms & Fitness.
2.  **Online (`online`)**:
    *   Features a distinct live search bar.
    *   **Category Taxonomy:** Must feature comprehensive digital categories grouped into sections: 
        - *Travel & Transit:* Flights, Hotels, Bank Travel Portals, Car Rentals, Rideshare.
        - *Online Shopping:* Online Retailers, Amazon, Food Delivery, Grocery Delivery, Wholesale Clubs, Drugstores, Home Improvement.
3.  **Point Values (`valuations`)**: 
    *   Features dynamic sliders to adjust cents-per-point valuations. **Crucially:** Sliders are only rendered for currencies that are present in the cards actively enabled in `userWallet`. Includes the 3 hardcoded presets (Cash, Travel, Max).
4.  **Wallet (`wallet`)**: 
    *   Displays the full catalog of 199 cards in collapsible bank sections. 
    *   **Mandatory Filter Ribbons:** Must include multi-toggle filter chips for: 
        - **Issuer:** (All, Active, Chase, Amex, Capital One, Citi, etc.)
        - **Reward Type:** (All, Cash Back, Points/Miles)
        - **Card Type:** (All, Personal, Business)

*Note on Recommendations:* When displaying the Top 3 cards (per Rule 3.1.7), only the #1 recommended card should render its card art image. The #2 and #3 runner-up cards should be displayed compactly (text-only) to save screen space.

### 5.2 Asset & Data Preservation (CRITICAL)
When rebuilding this app, an AI must **never attempt to mock or hallucinate `catalog.json` or the `assets/` directory**. The catalog contains 199 hand-curated cards and exact regex patterns. The UI heavily relies on the real image paths (`local_image_path`) for rendering the wallet and recommendations.
*   **Rule:** Always copy `catalog.json` and the `assets/` directory directly from the original source repository. Do not build them from scratch.

## 6. Data Ingestion & Catalog Maintenance

While the app relies on the static `catalog.json` at runtime, any scripts or processes built to *update* the catalog must adhere to the following rules:

### 6.1 Sourcing Bank Card Art
Do not generate fake card art. Real, high-resolution PNG/SVG images must be scraped or fetched directly from official bank Content Delivery Networks (CDNs) and saved into the `assets/cards/` directory:
*   **American Express:** Fetch from `icm.aexp-static.com`
*   **Capital One:** Fetch from `ecm.capitalone.com`
*   **Chase / Citi / BofA:** Extract images natively from their respective public credit card marketing pages.

### 6.2 Ingesting Reward Programs
When adding new cards to the database:
1.  **Multipliers:** Parse the issuer's terms to extract multipliers (e.g., 3x Dining) and map them strictly to our internal `category_key` strings (e.g., `dining`, `groceries`, `travel`).
2.  **Rotating Quarters:** For cards like Chase Freedom Flex or Discover it Cash Back, 5% rotating categories must be manually updated in the `quarterly_calendars` object within `catalog.json`, mapped by Quarter (`Q1`, `Q2`, `Q3`, `Q4`).

### 6.3 Wallet Grouping & Taxonomy
To ensure the Wallet Tab renders correctly, every card object must have a standardized `issuer_id` (e.g., `chase`, `amex`, `capital_one`, `citi`, `bofa`, `discover`, `wells_fargo`, `us_bank`). 
The UI relies on these exact ID strings to group the 199 cards into collapsible bank sections and dynamically generate the Wallet filter ribbons. Cards must also be accurately tagged with `currency_type` (`points` vs `cashback`) and `card_type` (`personal` vs `business`) to support UI filtering.
