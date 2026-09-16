# AI Agent Context & Developer Blueprint: OptiRewards

> **Target Audience:** Autonomous AI Agents, LLM Code Assistants, and Systems Engineers.
> **Role:** Authoritative reference for codebase architecture, data schemas, and extension workflows.

---

## 1. System Architecture Overview (Serverless)

OptiRewards operates as a **100% Serverless, Client-Side Application**. It relies purely on static file hosting and a global CDN (Cloudflare Pages) for 0ms latency and full offline capability.

```mermaid
graph TD
    subgraph Client Application (Browser / iOS WebKit)
        App[index.html: Vanilla JS UI & Recommendation Engine]
        LocalStorage[(Browser localStorage: Wallet & Valuations)]
        
        App -- Fetches on boot --> Catalog
        App -- Reads/Writes --> LocalStorage
        App -- Computes --> Recommendations
    end

    subgraph CDN Layer (Cloudflare Pages)
        Catalog[catalog.json: 199 cards, merchant regex]
        Assets[assets/cards/*.png, *.svg]
        AppUI[index.html]
    end
```

---

## 2. Directory & File Organization

The repository has been thoroughly cleaned to enforce this serverless architecture:

*   **`index.html`**: The single-page application. Contains all CSS, UI rendering logic, and the Javascript recommendation engine.
*   **`catalog.json`**: The sole source of truth for credit card data. It contains an array of 199 cards, their reward rules, 5% rotating quarterly calendars, and regex-based merchant mappings. **To update a multiplier or add a card, edit this file directly.**
*   **`assets/`**: Contains photorealistic, unaltered PNG/SVG card artwork fetched directly from bank CDNs.
*   **`scripts/`**: Contains auxiliary developer tools.
    *   `download_all_official_cards.py`: Used to fetch new card artwork from official bank URLs.
    *   `serve.py`: A simple Python HTTP server to test the app locally (`localhost:8085`).
*   **`README.md` & `AI_CONTEXT.md`**: Project documentation and agent guidelines.

*(Note: All legacy Python backend logic, SQLite databases (`cards.db`), and data ingestion scripts have been permanently retired in favor of the single `catalog.json` architecture).*

---

## 3. The Recommendation Engine (Javascript)

Because the app is serverless, all math happens directly in `index.html`:
1.  **Resolution:** User query (e.g. "Amazon") is regex-matched against `catalog.merchant_mappings` to resolve to a category key (e.g. `amazon` or `online_retail`).
2.  **State Loading:** The engine reads `userWallet` (array of active card IDs) and `userValuations` (custom cents-per-point) from `localStorage`.
3.  **Computation:** It iterates through the user's active wallet, checking each card's rules against the resolved category. It checks `catalog.quarterly_calendars` for active 5% rotations.
4.  **Yield Formula:** `Effective Yield = Match Multiplier × Point Valuation`.
5.  **Sorting:** Cards are sorted by `Effective Yield` descending, instantly returning the top card.

---

## 4. Customizing Point Valuations

Users can adjust valuations in the UI, overriding the baseline `catalog.json` values. This data is written to `localStorage.getItem('userValuations')` as a dictionary (e.g., `{"Ultimate Rewards": 2.0, "Membership Rewards": 1.8}`).

---

## 5. UI and Behavioral Requirements

*   **Mobile Layout (Safe Areas & 100dvh):** The app must fill the screen dynamically on iOS (`height: 100dvh`) to prevent the bottom tab bar from floating above or hiding below the Safari navigation bar. The app must use `padding-top: env(safe-area-inset-top)` to push content safely below the OS time/battery status indicators, avoiding overlap. Avoid using `position: fixed` for the device-frame or tab bar, as it causes bottom gaps on iOS Safari with rounded corners; instead, rely on `position: absolute` inside the `100dvh` container.
*   **Search Bars & Input Fields:** 
    *   The native WebKit blue "X" clear button is disabled globally via CSS. Do not use it. We strictly use custom gray `✖` buttons with conditional rendering (`display: ${query ? 'block' : 'none'}`) to ensure reliable, cross-browser consistency.
    *   When an input dynamically triggers a re-render (e.g., typing in the Wallet search bar), focus and cursor position must be synchronously restored within the `render()` function to prevent the iOS virtual keyboard from closing or jumping.
*   **OpenStreetMap Integration (Overpass API):** The "Nearby Stores" feature dynamically fetches real buildings and nodes within a 5000-meter radius using the free Overpass API (`nwr`). It parses OSM tags (`amenity=cafe`, `shop=supermarket`) into internal category keys (`dining`, `groceries`) and calculates precise Haversine distances.
*   **Recommendation Hand-off:** When a user clicks a store from the GPS nearby list, the exact category key derived from OpenStreetMap (e.g., `dining`) is passed explicitly into `getRecommendation(query, forcedCatKey)`. This bypasses the text scanner and ensures obscure local merchants (like "Sugar Shack") are accurately evaluated without needing to be mapped in the JSON.
*   **Fallback Keyword Heuristics:** If a search query is completely unknown (not in `catalog.merchant_mappings` and lacks a `forcedCatKey`), the engine scans the raw string for common keywords (e.g., "pizza", "burger" -> `dining`; "kroger", "publix" -> `groceries`) before giving up and returning a 1x base-rate card.
*   **AwardWallet Data:** The proprietary AwardWallet Merchant Lookup API is closed-source and protected by reCAPTCHA. Do not attempt to dynamically proxy or scrape AwardWallet in real-time. We rely exclusively on our static JSON mappings and heuristic fallbacks for instant, serverless resolution.
