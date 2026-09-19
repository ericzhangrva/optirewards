# OptiRewards 💳

### The Fast, Private, Zero-Knowledge Credit Card Reward Maximizer

[![Zero Build Step](https://img.shields.io/badge/Build-Zero%20Build%20Step-brightgreen)](#local-development--launch-guide)
[![100% Client-Side](https://img.shields.io/badge/Architecture-100%25%20Client--Side-blue)](#privacy-guarantee--zero-knowledge-architecture)
[![199 Cards](https://img.shields.io/badge/Card%20Catalog-199%20Curated%20Cards-orange)](#comprehensive-card-coverage-199-cards)
[![PWA Ready](https://img.shields.io/badge/PWA-iOS%20%26%20Android%20Installable-purple)](#progressive-web-app-pwa-installation)
[![100% Private](https://img.shields.io/badge/Privacy-100%25%20Local%20Storage-success)](#privacy-guarantee--zero-knowledge-architecture)

> **Never leave money or points on the table.** OptiRewards tells you the exact credit card to swipe or tap with Apple Pay in under one second—whether you're standing in line at a grocery checkout, pumping gas, or shopping online. Completely private, with zero user accounts, zero tracking, and 0ms latency.

---

## Table of Contents
1. [Why OptiRewards?](#why-optirewards)
2. [Privacy Guarantee & Zero-Knowledge Architecture](#privacy-guarantee--zero-knowledge-architecture)
3. [Core Features](#core-features)
4. [Tab-by-Tab User Walkthrough](#tab-by-tab-user-walkthrough)
   - [Tab 1: 🏪 In-Store (GPS & Physical Spend)](#tab-1--in-store-gps--physical-spend)
   - [Tab 2: 💻 Online (Digital Spend & Portals)](#tab-2--online-digital-spend--portals)
   - [Tab 3: 📊 Point Values (Valuation Sliders & Presets)](#tab-3--point-values-valuation-sliders--presets)
   - [Tab 4: 💳 Wallet (Catalog, Filters & Priority Order)](#tab-4--wallet-catalog-filters--priority-order)
5. [Comprehensive Card Coverage (199 Cards)](#comprehensive-card-coverage-199-cards)
6. [Progressive Web App (PWA) Installation](#progressive-web-app-pwa-installation)
7. [Local Development & Launch Guide](#local-development--launch-guide)
8. [Technology Stack](#technology-stack)

---

## Why OptiRewards?

Modern cardholders juggle a complex web of reward systems:
- **Cash Back vs Points:** Is 3x points worth more than 2% cash back? (It depends on your personal valuation!)
- **Rotating Quarterly Categories:** Which card currently earns 5% on gas or groceries this quarter?
- **Store-Specific Restrictions:** Costco only accepts Visa. Did you accidentally swipe a Mastercard or Amex?
- **Category Nuances:** Travel portals vs direct airline bookings; stand-alone pharmacies vs retail store counters.

Figuring this out at the checkout register causes decision fatigue and missed rewards.

**OptiRewards solves this instantly.** By cross-referencing your personalized wallet with live merchant regex patterns, current quarterly bonus calendars, store acceptance rules, and your custom point valuations, OptiRewards calculates your **Effective Yield** in real time:

$$\text{Effective Yield (\%)} = \text{Reward Multiplier} \times \text{Valuation Cents}$$

You get the Top 3 best cards in your wallet ranked in order of highest return, formatted for instant readability.

---

## Privacy Guarantee & Zero-Knowledge Architecture

Your financial wallet should remain strictly your business. OptiRewards is engineered from the ground up as a **100% Client-Side, Zero-Knowledge Application**:

- 🔒 **Zero Telemetry & Analytics:** No Google Analytics, no tracking pixels, and no third-party telemetry scripts.
- 🛡️ **No Bank Logins / No Plaid Credentials:** You never enter bank account credentials, credit card numbers, or passwords.
- 💾 **100% Local Storage:** Your active wallet selections, card priority ordering, and valuation preferences never leave your device—they are saved strictly in your browser's `localStorage`.
- 🌐 **Direct OpenStreetMap Geolocation:** When you use GPS to locate nearby stores, your browser queries public OpenStreetMap APIs directly. No proprietary intermediary server ever sees, processes, or logs your location.

---

## Core Features

### 📍 1. Real-Time In-Store GPS Discovery
- Tap **"Use My GPS"** and the app captures your device coordinates.
- Reverse geocodes your city and state via OpenStreetMap Nominatim.
- Queries OpenStreetMap Overpass within 5,000 meters to pinpoint physical restaurants, supermarkets, cafes, and retail shops on your block.
- Calculates exact Haversine distances in miles and ranks the closest 5 venues for instant 1-tap recommendations.
- **No slow maps:** Omits sluggish tile maps so you get card recommendations in under 1 second while in line.

### 🔍 2. Instant Merchant & Category Search
- Real-time search engine matching over 180 curated merchant patterns (Kroger, Target, Shell, Exxon, Uber, Delta, Amazon, etc.).
- Robust keyword heuristic fallback for unlisted local merchants.
- Custom clear button (`✖`) and iOS keyboard focus preservation so you can search smoothly without input dismissal.

### 📊 3. Dynamic Point Valuations & One-Tap Presets
- Customize what your loyalty currencies (Chase Ultimate Rewards, Amex Membership Rewards, Capital One Miles, Citi ThankYou Points, Bilt, airline miles, and hotel points) are worth to you.
- **Active-Wallet Filtering:** Sliders dynamically display *only* for point currencies active in your personal wallet. If your cards only earn cash back, OptiRewards displays an informative notice confirming 1.0¢ cash valuation.
- **3 Instant Presets:**
  - 🪙 **Cash Only (1.0¢):** Flattens all points to 1.0¢ per point for straight cash-back comparisons.
  - ✈️ **Standard Travel (1.5¢–1.8¢):** Conservative industry averages for domestic flights and hotel redemptions.
  - 👑 **Max Transfer Yield (2.0¢–2.2¢):** High-yield international business class and Hyatt transfer partner optimizations.

### 🎛️ 4. Drag-and-Drop Wallet Priority Reordering
- In the "Active in My Wallet" filter view, grab the 3-bar drag handle to reorder your cards.
- Supports smooth touch drag gestures on mobile and mouse drag on desktop.
- **Official Tie-Breaker:** When two cards offer identical effective yields (e.g. two 2% cards or two 3x dining cards), the card placed higher in your wallet hierarchy automatically wins top recommendation.

### 🗓️ 5. Automated Rotating Quarterly Calendars (5%)
- Automatically tracks rotating 5% quarterly bonus categories based on the current calendar quarter (`Q1`, `Q2`, `Q3`, `Q4`).
- Supports rotating cards including **Chase Freedom Flex**, **Discover it Cash Back**, **U.S. Bank Cash+**, and **Chase Freedom Original**.

### 🏬 6. Store Acceptance Rules & Wholesale Clubs Split
- **Costco Visa Enforcement:** Automatically flags and disqualifies non-Visa cards (Mastercard, Amex, Discover) when shopping at Costco, guaranteeing you never swipe an unaccepted card.
- **Wholesale Clubs 3-Way Split:** Tapping the Wholesale Clubs category concurrently evaluates and displays top cards for **Costco** (Visa only), **Sam's Club**, and **BJ's Wholesale Club** in a unified comparison view.

---

## Tab-by-Tab User Walkthrough

The navigation bar at the bottom gives you instant access to 4 focused views:

### Tab 1: 🏪 In-Store (GPS & Physical Spend)
Designed for maximum checkout speed when you are out in the world:
1. **GPS Nearby Stores:** Tap **"Use My GPS"** (or allow browser location). The app surfaces the closest 5 venues with exact distance badges. Tap any store to see your best card.
2. **Search Bar:** Type the name of any physical merchant (e.g. *Chipotle*, *Trader Joe's*, *Shell*) and press Enter or tap **"Go"**.
3. **9 Physical Category Chips:** Tap any quick category chip:
   - 🍽️ Dining & Restaurants
   - 🛒 Groceries
   - ⛽ Gas Stations
   - ⚡ EV Charging
   - 🚆 Transit & Commuting
   - 📦 Wholesale Clubs
   - 💊 Drugstores & Pharmacies
   - 🔨 Home Improvement
   - 🚗 Rideshare
4. **Dismissing Recommendations:** Tapping an active category button a second time collapses the recommendation box.

### Tab 2: 💻 Online (Digital Spend & Portals)
Tailored for desktop browsing and digital mobile checkout:
1. **1-Tap Popular Digital Merchants:** Instant shortcut buttons for `Amazon.com`, `Apple Store`, and `Airlines (Delta / United / AA)`.
2. **Categorized Digital Sections:**
   - **✈️ Travel & Transit Apps:** Flights & Airfare, Hotels & Lodging, Bank Travel Portals, Car Rentals, Rideshare.
   - **🛒 Online Shopping & Delivery:** Amazon & Online Retailers, Food Delivery (DoorDash/UberEats), Grocery Delivery (Instacart), Wholesale Clubs Online, Online Drugstores, Home Improvement Online.
   - **📱 Digital Services & Subscriptions:** Streaming Services, Phone & Internet Bills, Utilities & Home Bills, Gyms & Fitness Subscriptions, General Online Purchases.

### Tab 3: 📊 Point Values (Valuation Sliders & Presets)
Fine-tune how points are evaluated across all calculations:
1. **Apply Presets:** Click 🪙 **Cash Only**, ✈️ **Standard Travel**, or 👑 **Max Transfer** to set baseline values across your portfolio.
2. **Fine-Tune Sliders:** Drag individual currency sliders (e.g., set *Ultimate Rewards* to 2.1¢ or *Hilton Honors* to 0.6¢).
3. **Automatic Updates:** All yield calculations across the In-Store and Online tabs update synchronously as you adjust sliders.

### Tab 4: 💳 Wallet (Catalog, Filters & Priority Order)
Manage your cards and customize your wallet hierarchy:
1. **Adding & Removing Cards:**
   - Browse the 199-card catalog organized by bank.
   - Tap **"+ Add"** to activate a card in your wallet (turns green into **"✓ In Wallet"**).
   - Tap **"✓ In Wallet"** anytime to remove it.
2. **4-Facet Filtering Ribbon:**
   - **Bank / Issuer:** All, Active (`in_wallet`), Chase, Amex, Capital One, Citi, BofA, Wells Fargo, Other.
   - **Reward Program:** All, Cash Back (`cash`), Points & Miles (`points`).
   - **Network:** All, Visa, Mastercard, American Express, Discover.
   - **Card Type:** All, Personal, Business.
3. **Reordering Active Cards (Tie-Breaker Hierarchy):**
   - Tap the **"Active"** issuer filter pill.
   - Use the 3-bar drag handle on the right of any card row to drag it up or down.
   - Releasing saves your custom priority order immediately.
4. **Expandable Card Details Drawer:**
   - Tap anywhere on a card row (except the toggle button or drag handle) to expand its details drawer.
   - Inspect **Annual Fee**, **Reward Multipliers** (formatted in sentence case, with base rate unified as "Other"), and **Key Benefits** marked with ✨.

---

## Comprehensive Card Coverage (199 Cards)

OptiRewards features **199 credit cards** spanning consumer, small business, airline, hotel, and credit union portfolios:

- **JPMorgan Chase (45 Cards):** Sapphire Reserve, Sapphire Preferred, Freedom Unlimited, Freedom Flex, Freedom Rise, Ink Business Preferred/Cash/Unlimited/Premier, Prime Visa, Southwest, United, Marriott, Hyatt, IHG, British Airways, etc.
- **American Express (22 Cards — 11 Personal & 11 Business):** The Platinum Card, Gold Card, Green Card, Blue Cash Preferred/Everyday, Cash Magnet, Delta SkyMiles, Hilton Aspire, Marriott Brilliant, Business Platinum/Gold, Blue Business Plus, etc.
- **Capital One (35 Cards):** Venture X, Venture, VentureOne, Savor, SavorOne, Quicksilver, Spark Cash Plus, Spark 2X Miles, co-branded retail cards (BJ's, Bass Pro, Cabela's, Williams Sonoma, etc.).
- **Citigroup (28 Cards):** Citi Double Cash, Custom Cash, Strata Premier, Strata Elite, Costco Anywhere Visa, Costco Business, AAdvantage Executive/Platinum, etc.
- **Bank of America (22 Cards — 17 Personal & 5 Business):** Customized Cash Rewards, Unlimited Cash, Travel Rewards, Premium Rewards, Alaska Airlines Visa, etc.
- **Wells Fargo (14 Cards):** Active Cash, Autograph, Autograph Journey, Attune, Reflect, Choice Privileges, Signify Business Cash, etc.
- **U.S. Bank (11 Cards):** Altitude Reserve, Altitude Go, Altitude Connect, Cash+, Shopper Cash Rewards, Business Triple Cash, etc.
- **Discover (5 Cards):** Discover it Cash Back (5% rotating), Discover it Chrome, Discover it Miles, Discover it Student, Discover it Secured.
- **Apple / Goldman Sachs (1 Card):** Apple Card (3% Apple/partners, 2% Apple Pay everywhere, 1% physical).
- **Bilt Technologies / Wells Fargo (1 Card):** Bilt Mastercard (1x fee-free rent, 3x dining, 2x travel).
- **Barclays US (2 Cards):** JetBlue Plus, Wyndham Rewards Earner Plus.
- **Credit Unions & Regional Banks (17 Cards):** Fidelity 2% Visa, Navy Federal moreRewards, PenFed Power Cash, TD Double Up, PNC Cash Unlimited, etc.
- **Retail Store Co-Brands (20+ Cards):** PayPal Cashback Mastercard, Target Circle Card, Venmo Credit Card, Amazon Store Card, etc.

*Card Art Fidelity:* All card images are authentic, high-resolution PNG/SVG assets sourced directly from official bank Content Delivery Networks (Amex, Capital One, Chase, Citi, Discover, Bank of America, Wells Fargo).

---

## Progressive Web App (PWA) Installation

OptiRewards is a fully certified Progressive Web App. You can install it directly to your home screen for an app-like experience with 0ms launch time and no browser address bars:

### iPhone & iPad (iOS Safari)
1. Open OptiRewards in **Safari**.
2. Tap the **Share** button (the square with an upward arrow at the bottom of the screen).
3. Scroll down the share sheet and select **"Add to Home Screen"**.
4. Tap **"Add"** in the top-right corner.
5. Launch **OptiRewards** from your home screen. It will open fullscreen with an edge-to-edge iOS native layout.

### Android (Google Chrome)
1. Open OptiRewards in **Chrome**.
2. Tap the **three dots menu** (⋮) in the top-right corner.
3. Tap **"Install App"** or **"Add to Home screen"**.
4. Confirm by tapping **"Install"**.

### Desktop (macOS & Windows)
- In desktop Chrome or Edge, click the **Install icon** in the right side of the address bar.
- On desktop screens (>768px), OptiRewards displays an interactive iPhone 15 Pro device frame complete with a Dynamic Island and real-time clock.

---

## Local Development & Launch Guide

Because OptiRewards has **zero build steps** and no server-side code, running it locally requires only a standard static HTTP server.

> **Note:** Due to browser security restrictions on `fetch()` and CORS over local files, do not double-click `index.html` to open via `file://`. Always use a local HTTP server.

### Option 1: Python Built-In Server (Recommended)
You can use the included lightweight server script:
```bash
python3 scripts/serve.py
```
Or launch Python's built-in HTTP server directly:
```bash
python3 -m http.server 8085 -d public
```
Then open **`http://localhost:8085`** in your browser.

### Option 2: Node.js (`npx serve`)
If you have Node.js installed:
```bash
npx serve public
```

### Option 3: Cloudflare Pages / Wrangler
Test your static assets against Cloudflare's edge runtime:
```bash
npx wrangler pages dev public
```

### System & Browser Prerequisites
- Any modern web browser: Apple Safari 14+, Google Chrome 90+, Mozilla Firefox 90+, or Microsoft Edge.
- JavaScript ES6+ enabled.
- `localStorage` enabled for saving active wallet selections.
- Geolocation API support (requires `https://` in production or `http://localhost` during development).

---

## Technology Stack

- **Client Architecture:** Vanilla HTML5, Modern CSS3, ECMAScript 6+ (No frameworks, 0kb bundle overhead).
- **Database:** Static JSON DB (`public/catalog.json`) holding 199 cards, merchant regex patterns, and quarterly calendars.
- **Hosting & Edge Deployment:** Cloudflare Pages / Workers Static Assets via `wrangler.json`.
- **Geolocation & Mapping:** OpenStreetMap Overpass API (Nearby POI discovery) & OpenStreetMap Nominatim (Reverse Geocoding).
- **State Storage:** In-browser `window.localStorage`.
- **Asset Pipeline:** Python automated CDN scraper (`scripts/download_all_official_cards.py`).

---

## License & Disclaimer

*Disclaimer:* OptiRewards is an independent reward optimization tool. Credit card names, logos, and reward program terms are trademarks of their respective issuers (JPMorgan Chase, American Express, Capital One, Citigroup, Bank of America, Discover, Wells Fargo, U.S. Bank, Goldman Sachs, etc.). Card terms and reward categories are subject to change by issuing banks.
