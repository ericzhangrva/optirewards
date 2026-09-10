-- BestRewards SQLite Database Schema
-- Supports idempotent refreshes, card versioning, and granular category multipliers

CREATE TABLE IF NOT EXISTS issuers (
    id TEXT PRIMARY KEY,
    name TEXT NOT NULL,
    short_name TEXT NOT NULL,
    website TEXT,
    market_share_tier TEXT DEFAULT 'tier_1',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS cards (
    id TEXT PRIMARY KEY,
    issuer_id TEXT NOT NULL,
    name TEXT NOT NULL,
    slug TEXT UNIQUE NOT NULL,
    network TEXT NOT NULL, -- 'Visa', 'Mastercard', 'Amex', 'Discover'
    card_type TEXT DEFAULT 'personal', -- 'personal', 'business'
    annual_fee REAL DEFAULT 0.0,
    foreign_tx_fee REAL DEFAULT 0.0,
    credit_tier TEXT DEFAULT 'Excellent/Good',
    apply_url TEXT,
    image_url TEXT,
    local_image_path TEXT,
    is_active INTEGER DEFAULT 1,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (issuer_id) REFERENCES issuers (id)
);

CREATE TABLE IF NOT EXISTS reward_programs (
    id TEXT PRIMARY KEY,
    card_id TEXT NOT NULL,
    currency_type TEXT NOT NULL, -- 'cashback', 'points', 'miles'
    currency_name TEXT NOT NULL, -- 'USD', 'Ultimate Rewards', 'Membership Rewards', etc.
    base_rate REAL NOT NULL DEFAULT 1.0, -- Default rate per dollar (e.g. 1.0 = 1% or 1x)
    point_valuation_cents REAL DEFAULT 1.0, -- Baseline valuation (e.g. 1.0 = 1.0 cent, 1.5 = 1.5 cents)
    welcome_bonus_desc TEXT,
    intro_apr_desc TEXT,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (card_id) REFERENCES cards (id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS reward_categories (
    id TEXT PRIMARY KEY,
    card_id TEXT NOT NULL,
    category_key TEXT NOT NULL, -- 'dining', 'grocery', 'drugstore', 'gas', 'travel', etc.
    category_name TEXT NOT NULL, -- Display title
    multiplier REAL NOT NULL, -- e.g. 5.0 for 5% or 5x
    spend_cap REAL, -- e.g. 500.0 or 1500.0 per quarter/year, NULL if uncapped
    cap_period TEXT, -- 'quarter', 'billing_cycle', 'year', NULL
    is_rotating INTEGER DEFAULT 0, -- 1 if quarterly rotating (e.g. Freedom Flex, Discover it)
    rotating_quarter TEXT, -- 'Q1', 'Q2', 'Q3', 'Q4', NULL
    notes TEXT,
    FOREIGN KEY (card_id) REFERENCES cards (id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS merchant_mappings (
    id TEXT PRIMARY KEY,
    merchant_name TEXT NOT NULL,
    merchant_pattern TEXT NOT NULL, -- regex or lowercase string
    category_key TEXT NOT NULL,
    brand_icon TEXT
);

CREATE TABLE IF NOT EXISTS user_wallet (
    id TEXT PRIMARY KEY,
    user_id TEXT DEFAULT 'default_user',
    card_id TEXT NOT NULL,
    is_favorite INTEGER DEFAULT 0,
    custom_nickname TEXT,
    added_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (card_id) REFERENCES cards (id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS reward_history (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    card_id TEXT NOT NULL,
    change_type TEXT NOT NULL, -- 'fee_change', 'multiplier_update', 'bonus_update', 'discontinued'
    old_value TEXT,
    new_value TEXT,
    detected_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (card_id) REFERENCES cards (id)
);

CREATE INDEX IF NOT EXISTS idx_cards_issuer ON cards(issuer_id);
CREATE INDEX IF NOT EXISTS idx_reward_categories_card ON reward_categories(card_id);
CREATE INDEX IF NOT EXISTS idx_reward_categories_key ON reward_categories(category_key);
CREATE INDEX IF NOT EXISTS idx_wallet_user ON user_wallet(user_id);
