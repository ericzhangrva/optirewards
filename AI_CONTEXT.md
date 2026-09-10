# AI Agent Context & Developer Blueprint: OptiRewards

> **Target Audience:** Autonomous AI Agents, LLM Code Assistants, and Systems Engineers.
> **Role:** Authoritative reference for codebase architecture, data schemas, and extension workflows.

---

## 1. System Architecture Overview (Serverless)

OptiRewards operates as a **100% Serverless, Client-Side Application**. It relies purely on static file hosting and a global CDN (Cloudflare Pages/R2) for 0ms latency and full offline capability.

```mermaid
graph TD
    subgraph Storage Layer (Cloudflare R2)
        Catalog[catalog.json: 199 cards, merchant regex, quarterly cals]
    end

    subgraph Client Application (Browser / iOS WebKit)
        App[index.html: Vanilla JS UI & Recommendation Engine]
        LocalStorage[(Browser localStorage: Wallet & Valuations)]
        
        App -- Fetches on boot --> Catalog
        App -- Reads/Writes --> LocalStorage
        App -- Computes --> Recommendations
    end

    subgraph CDN Layer (Cloudflare Pages)
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
