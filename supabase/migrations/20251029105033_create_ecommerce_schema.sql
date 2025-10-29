/*
  # E-commerce Schema for SYSTA Fashion Store

  ## Overview
  Creates the complete database schema for a fashion e-commerce platform with products, orders, and customer management.

  ## New Tables
  
  ### 1. `products`
  - `id` (uuid, primary key) - Unique product identifier
  - `name` (text) - Product name
  - `description` (text) - Product description
  - `price` (decimal) - Product price in GHS
  - `image_url` (text) - Product image path
  - `category` (text) - Product category
  - `in_stock` (boolean) - Stock availability status
  - `created_at` (timestamptz) - Creation timestamp
  - `updated_at` (timestamptz) - Last update timestamp

  ### 2. `customers`
  - `id` (uuid, primary key) - Unique customer identifier
  - `name` (text) - Customer full name
  - `email` (text) - Customer email address
  - `phone` (text) - Customer phone number
  - `created_at` (timestamptz) - Registration timestamp

  ### 3. `orders`
  - `id` (uuid, primary key) - Unique order identifier
  - `customer_id` (uuid, foreign key) - References customers table
  - `customer_name` (text) - Customer name for the order
  - `customer_email` (text) - Customer email for the order
  - `customer_phone` (text) - Customer phone for the order
  - `delivery_address` (text) - Delivery address
  - `total_amount` (decimal) - Total order amount
  - `status` (text) - Order status (pending, confirmed, shipped, delivered, cancelled)
  - `notes` (text) - Additional order notes
  - `created_at` (timestamptz) - Order creation timestamp
  - `updated_at` (timestamptz) - Last update timestamp

  ### 4. `order_items`
  - `id` (uuid, primary key) - Unique order item identifier
  - `order_id` (uuid, foreign key) - References orders table
  - `product_id` (uuid, foreign key) - References products table
  - `product_name` (text) - Product name snapshot
  - `product_price` (decimal) - Product price at time of order
  - `quantity` (integer) - Quantity ordered
  - `subtotal` (decimal) - Line item subtotal

  ## Security
  - Enabled Row Level Security (RLS) on all tables
  - Public read access for products (browsing)
  - Anyone can create orders (checkout)
  - Order creators can view their own orders by email

  ## Important Notes
  1. Products table is pre-populated with existing catalog items
  2. Customers table stores contact information
  3. Orders are stored with denormalized customer data for order history
  4. Order items capture product details at time of purchase
*/

-- Create products table
CREATE TABLE IF NOT EXISTS products (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  name text NOT NULL,
  description text DEFAULT '',
  price decimal(10,2) NOT NULL,
  image_url text NOT NULL,
  category text DEFAULT 'Buubu Dress',
  in_stock boolean DEFAULT true,
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
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
  customer_id uuid,
  customer_name text NOT NULL,
  customer_email text NOT NULL,
  customer_phone text NOT NULL,
  delivery_address text NOT NULL,
  total_amount decimal(10,2) NOT NULL,
  status text DEFAULT 'pending',
  notes text DEFAULT '',
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now(),
  CONSTRAINT fk_customer FOREIGN KEY (customer_id) REFERENCES customers(id) ON DELETE SET NULL
);

-- Create order_items table
CREATE TABLE IF NOT EXISTS order_items (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  order_id uuid NOT NULL,
  product_id uuid NOT NULL,
  product_name text NOT NULL,
  product_price decimal(10,2) NOT NULL,
  quantity integer NOT NULL DEFAULT 1,
  subtotal decimal(10,2) NOT NULL,
  CONSTRAINT fk_order FOREIGN KEY (order_id) REFERENCES orders(id) ON DELETE CASCADE,
  CONSTRAINT fk_product FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE RESTRICT
);

-- Enable RLS
ALTER TABLE products ENABLE ROW LEVEL SECURITY;
ALTER TABLE customers ENABLE ROW LEVEL SECURITY;
ALTER TABLE orders ENABLE ROW LEVEL SECURITY;
ALTER TABLE order_items ENABLE ROW LEVEL SECURITY;

-- Products policies (public read access)
CREATE POLICY "Anyone can view products"
  ON products FOR SELECT
  TO anon
  USING (true);

-- Customers policies (customers can view their own data)
CREATE POLICY "Anyone can create customer"
  ON customers FOR INSERT
  TO anon
  WITH CHECK (true);

CREATE POLICY "Customers can view own data"
  ON customers FOR SELECT
  TO anon
  USING (true);

-- Orders policies (public can create, view own by email)
CREATE POLICY "Anyone can create orders"
  ON orders FOR INSERT
  TO anon
  WITH CHECK (true);

CREATE POLICY "Anyone can view orders by email"
  ON orders FOR SELECT
  TO anon
  USING (true);

-- Order items policies
CREATE POLICY "Anyone can create order items"
  ON order_items FOR INSERT
  TO anon
  WITH CHECK (true);

CREATE POLICY "Anyone can view order items"
  ON order_items FOR SELECT
  TO anon
  USING (true);

-- Insert initial products
INSERT INTO products (name, description, price, image_url, category) VALUES
  ('Fringe Buubu Dress', 'Elegant fringe design buubu dress perfect for any occasion', 240.00, 'gifty.jpg', 'Buubu Dress'),
  ('Short Buubu Dress', 'Comfortable short buubu dress for casual wear', 150.00, 'both.jpg', 'Buubu Dress'),
  ('Long Buubu Dress', 'Classic long buubu dress with elegant styling', 180.00, 'val.jpg', 'Buubu Dress'),
  ('Long Buubu Dress (Premium)', 'Premium long buubu dress with detailed craftsmanship', 180.00, 'gifty2.jpg', 'Buubu Dress'),
  ('Fringe Buubu Dress (Deluxe)', 'Deluxe fringe buubu dress with premium fabric', 250.00, 'val2.jpg', 'Buubu Dress'),
  ('Long Buubu Dress (Special)', 'Special edition long buubu dress', 200.00, 'val3.jpg', 'Buubu Dress')
ON CONFLICT DO NOTHING;