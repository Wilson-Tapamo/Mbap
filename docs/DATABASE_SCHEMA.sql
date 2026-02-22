-- Schéma PostgreSQL MVP KmerFlow

CREATE TABLE businesses (
  id UUID PRIMARY KEY,
  name TEXT NOT NULL,
  country TEXT DEFAULT 'CM',
  currency TEXT DEFAULT 'XAF',
  created_at TIMESTAMP DEFAULT NOW()
);

CREATE TABLE stores (
  id UUID PRIMARY KEY,
  business_id UUID REFERENCES businesses(id),
  name TEXT NOT NULL,
  city TEXT,
  created_at TIMESTAMP DEFAULT NOW()
);

CREATE TABLE users (
  id UUID PRIMARY KEY,
  business_id UUID REFERENCES businesses(id),
  full_name TEXT NOT NULL,
  phone TEXT UNIQUE,
  role TEXT NOT NULL CHECK (role IN ('owner','manager','cashier')),
  created_at TIMESTAMP DEFAULT NOW()
);

CREATE TABLE products (
  id UUID PRIMARY KEY,
  business_id UUID REFERENCES businesses(id),
  sku TEXT,
  name TEXT NOT NULL,
  category TEXT,
  unit TEXT DEFAULT 'piece',
  min_stock INTEGER DEFAULT 0,
  created_at TIMESTAMP DEFAULT NOW()
);

CREATE TABLE stock_items (
  id UUID PRIMARY KEY,
  store_id UUID REFERENCES stores(id),
  product_id UUID REFERENCES products(id),
  quantity NUMERIC(12,2) DEFAULT 0,
  avg_cost NUMERIC(12,2) DEFAULT 0,
  UNIQUE(store_id, product_id)
);

CREATE TABLE sales (
  id UUID PRIMARY KEY,
  store_id UUID REFERENCES stores(id),
  seller_id UUID REFERENCES users(id),
  total_amount NUMERIC(12,2) NOT NULL,
  paid_amount NUMERIC(12,2) NOT NULL,
  payment_method TEXT CHECK (payment_method IN ('cash','mobile_money','mixed','credit')),
  sold_at TIMESTAMP DEFAULT NOW()
);

CREATE TABLE sale_items (
  id UUID PRIMARY KEY,
  sale_id UUID REFERENCES sales(id) ON DELETE CASCADE,
  product_id UUID REFERENCES products(id),
  quantity NUMERIC(12,2) NOT NULL,
  unit_price NUMERIC(12,2) NOT NULL,
  cost_snapshot NUMERIC(12,2) DEFAULT 0
);

CREATE TABLE expenses (
  id UUID PRIMARY KEY,
  store_id UUID REFERENCES stores(id),
  label TEXT NOT NULL,
  amount NUMERIC(12,2) NOT NULL,
  category TEXT,
  spent_at TIMESTAMP DEFAULT NOW()
);

CREATE TABLE supplier_debts (
  id UUID PRIMARY KEY,
  store_id UUID REFERENCES stores(id),
  supplier_name TEXT NOT NULL,
  amount_due NUMERIC(12,2) NOT NULL,
  due_date DATE,
  status TEXT CHECK (status IN ('open','partial','paid')) DEFAULT 'open'
);

CREATE TABLE customer_credits (
  id UUID PRIMARY KEY,
  store_id UUID REFERENCES stores(id),
  customer_name TEXT NOT NULL,
  phone TEXT,
  amount_due NUMERIC(12,2) NOT NULL,
  due_date DATE,
  status TEXT CHECK (status IN ('open','partial','paid')) DEFAULT 'open'
);

CREATE TABLE ai_insights (
  id UUID PRIMARY KEY,
  business_id UUID REFERENCES businesses(id),
  insight_type TEXT NOT NULL,
  priority TEXT CHECK (priority IN ('high','medium','low')),
  message TEXT NOT NULL,
  action_label TEXT,
  created_at TIMESTAMP DEFAULT NOW()
);
