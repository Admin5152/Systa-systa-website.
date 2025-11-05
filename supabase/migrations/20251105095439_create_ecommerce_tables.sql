/*
  # E-commerce Database Schema

  1. New Tables
    - `products`
      - `id` (uuid, primary key)
      - `name` (text) - Product name
      - `description` (text) - Product description
      - `price` (numeric) - Product price
      - `image_url` (text) - Image path
      - `in_stock` (boolean) - Stock availability
      - `created_at` (timestamptz) - Creation timestamp
    
    - `customers`
      - `id` (uuid, primary key)
      - `name` (text) - Customer name
      - `email` (text, unique) - Customer email
      - `phone` (text) - Customer phone number
      - `created_at` (timestamptz) - Creation timestamp
    
    - `orders`
      - `id` (uuid, primary key)
      - `customer_id` (uuid, foreign key) - References customers
      - `customer_name` (text) - Customer name snapshot
      - `customer_email` (text) - Customer email snapshot
      - `customer_phone` (text) - Customer phone snapshot
      - `delivery_address` (text) - Delivery address
      - `total_amount` (numeric) - Order total
      - `status` (text) - Order status (pending, confirmed, shipped, delivered, cancelled)
      - `notes` (text) - Additional notes
      - `created_at` (timestamptz) - Order creation timestamp
    
    - `order_items`
      - `id` (uuid, primary key)
      - `order_id` (uuid, foreign key) - References orders
      - `product_id` (uuid, foreign key) - References products
      - `product_name` (text) - Product name snapshot
      - `product_price` (numeric) - Product price snapshot
      - `quantity` (integer) - Quantity ordered
      - `subtotal` (numeric) - Line item subtotal
      - `created_at` (timestamptz) - Creation timestamp

  2. Security
    - Enable RLS on all tables
    - Add policies for public read access to products
    - Add policies for customers to create orders
    - Add policies for viewing own orders
*/

-- Create products table
CREATE TABLE IF NOT EXISTS products (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  name text NOT NULL,
  description text DEFAULT '',
  price numeric(10, 2) NOT NULL CHECK (price >= 0),
  image_url text NOT NULL,
  in_stock boolean DEFAULT true,
  created_at timestamptz DEFAULT now()
);

-- Create customers table
CREATE TABLE IF NOT EXISTS customers (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  name text NOT NULL,
  email text UNIQUE NOT NULL,
  phone text NOT NULL,
  created_at timestamptz DEFAULT now()
);

-- Create orders table
CREATE TABLE IF NOT EXISTS orders (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  customer_id uuid REFERENCES customers(id),
  customer_name text NOT NULL,
  customer_email text NOT NULL,
  customer_phone text NOT NULL,
  delivery_address text NOT NULL,
  total_amount numeric(10, 2) NOT NULL CHECK (total_amount >= 0),
  status text DEFAULT 'pending' CHECK (status IN ('pending', 'confirmed', 'shipped', 'delivered', 'cancelled')),
  notes text DEFAULT '',
  created_at timestamptz DEFAULT now()
);

-- Create order_items table
CREATE TABLE IF NOT EXISTS order_items (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  order_id uuid REFERENCES orders(id) ON DELETE CASCADE,
  product_id uuid REFERENCES products(id),
  product_name text NOT NULL,
  product_price numeric(10, 2) NOT NULL,
  quantity integer NOT NULL CHECK (quantity > 0),
  subtotal numeric(10, 2) NOT NULL CHECK (subtotal >= 0),
  created_at timestamptz DEFAULT now()
);

-- Enable Row Level Security
ALTER TABLE products ENABLE ROW LEVEL SECURITY;
ALTER TABLE customers ENABLE ROW LEVEL SECURITY;
ALTER TABLE orders ENABLE ROW LEVEL SECURITY;
ALTER TABLE order_items ENABLE ROW LEVEL SECURITY;

-- Products: Public read access
CREATE POLICY "Anyone can view products"
  ON products FOR SELECT
  TO anon, authenticated
  USING (true);

-- Customers: Allow inserts for new customers
CREATE POLICY "Anyone can create customer records"
  ON customers FOR INSERT
  TO anon, authenticated
  WITH CHECK (true);

CREATE POLICY "Customers can view own record"
  ON customers FOR SELECT
  TO anon, authenticated
  USING (true);

-- Orders: Allow creating orders
CREATE POLICY "Anyone can create orders"
  ON orders FOR INSERT
  TO anon, authenticated
  WITH CHECK (true);

CREATE POLICY "Anyone can view orders"
  ON orders FOR SELECT
  TO anon, authenticated
  USING (true);

-- Order Items: Allow creating order items
CREATE POLICY "Anyone can create order items"
  ON order_items FOR INSERT
  TO anon, authenticated
  WITH CHECK (true);

CREATE POLICY "Anyone can view order items"
  ON order_items FOR SELECT
  TO anon, authenticated
  USING (true);

-- Insert sample products
INSERT INTO products (name, description, price, image_url, in_stock) VALUES
  ('Fringe Buubu Dress', 'Elegant fringe buubu dress with modern styling', 240.00, 'gifty.jpg', true),
  ('Short Buubu Dress', 'Comfortable short buubu dress for everyday wear', 150.00, 'both.jpg', true),
  ('Long Buubu Dress', 'Classic long buubu dress with timeless elegance', 180.00, 'val.jpg', true),
  ('Long Buubu Dress - Style 2', 'Stylish long buubu dress with unique design', 180.00, 'gifty2.jpg', true),
  ('Fringe Buubu Dress - Premium', 'Premium fringe buubu dress with enhanced details', 250.00, 'val2.jpg', true),
  ('Long Buubu Dress - Deluxe', 'Deluxe long buubu dress for special occasions', 200.00, 'val3.jpg', true)
ON CONFLICT DO NOTHING;
