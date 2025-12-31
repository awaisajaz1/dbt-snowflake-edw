-- =====================================================
-- SAMPLE DATA SETUP FOR DBT + SNOWFLAKE PRACTICE
-- =====================================================
-- This script creates a complete e-commerce dataset
-- with customers, products, orders, and order items
-- Perfect for building Bronze -> Silver -> Gold layers

-- Set context
USE DATABASE DBT_DEMO;
USE SCHEMA RAW;
USE WAREHOUSE COMPUTE_WH;

-- =====================================================
-- 1. CUSTOMERS TABLE (Bronze Layer Source)
-- =====================================================
CREATE OR REPLACE TABLE customers (
    customer_id INTEGER,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    email VARCHAR(100),
    phone VARCHAR(20),
    address VARCHAR(200),
    city VARCHAR(50),
    state VARCHAR(20),
    zip_code VARCHAR(10),
    country VARCHAR(50),
    registration_date DATE,
    last_login_date TIMESTAMP,
    customer_status VARCHAR(20),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP(),
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP()
);

-- Insert sample customer data
INSERT INTO customers VALUES
(1, 'John', 'Doe', 'john.doe@email.com', '555-0101', '123 Main St', 'New York', 'NY', '10001', 'USA', '2023-01-15', '2024-12-28 10:30:00', 'active', '2023-01-15 09:00:00', '2024-12-28 10:30:00'),
(2, 'Jane', 'Smith', 'jane.smith@email.com', '555-0102', '456 Oak Ave', 'Los Angeles', 'CA', '90210', 'USA', '2023-02-20', '2024-12-27 14:15:00', 'active', '2023-02-20 11:30:00', '2024-12-27 14:15:00'),
(3, 'Mike', 'Johnson', 'mike.j@email.com', '555-0103', '789 Pine Rd', 'Chicago', 'IL', '60601', 'USA', '2023-03-10', '2024-12-26 16:45:00', 'active', '2023-03-10 13:20:00', '2024-12-26 16:45:00'),
(4, 'Sarah', 'Williams', 'sarah.w@email.com', '555-0104', '321 Elm St', 'Houston', 'TX', '77001', 'USA', '2023-04-05', '2024-12-25 09:20:00', 'inactive', '2023-04-05 15:45:00', '2024-12-25 09:20:00'),
(5, 'David', 'Brown', 'david.brown@email.com', '555-0105', '654 Maple Dr', 'Phoenix', 'AZ', '85001', 'USA', '2023-05-12', '2024-12-29 12:10:00', 'active', '2023-05-12 08:30:00', '2024-12-29 12:10:00'),
(6, 'Lisa', 'Davis', 'lisa.davis@email.com', '555-0106', '987 Cedar Ln', 'Philadelphia', 'PA', '19101', 'USA', '2023-06-18', '2024-12-24 18:30:00', 'active', '2023-06-18 10:15:00', '2024-12-24 18:30:00'),
(7, 'Tom', 'Wilson', 'tom.wilson@email.com', '555-0107', '147 Birch St', 'San Antonio', 'TX', '78201', 'USA', '2023-07-22', '2024-12-23 11:45:00', 'suspended', '2023-07-22 14:20:00', '2024-12-23 11:45:00'),
(8, 'Emma', 'Garcia', 'emma.garcia@email.com', '555-0108', '258 Spruce Ave', 'San Diego', 'CA', '92101', 'USA', '2023-08-30', '2024-12-29 15:20:00', 'active', '2023-08-30 16:40:00', '2024-12-29 15:20:00'),
(9, 'James', 'Martinez', 'james.m@email.com', '555-0109', '369 Willow Rd', 'Dallas', 'TX', '75201', 'USA', '2023-09-14', '2024-12-28 13:55:00', 'active', '2023-09-14 12:10:00', '2024-12-28 13:55:00'),
(10, 'Anna', 'Rodriguez', 'anna.r@email.com', '555-0110', '741 Poplar St', 'San Jose', 'CA', '95101', 'USA', '2023-10-08', '2024-12-27 17:30:00', 'active', '2023-10-08 09:25:00', '2024-12-27 17:30:00');

-- =====================================================
-- 2. PRODUCTS TABLE (Bronze Layer Source)
-- =====================================================
CREATE OR REPLACE TABLE products (
    product_id INTEGER,
    product_name VARCHAR(100),
    category VARCHAR(50),
    subcategory VARCHAR(50),
    brand VARCHAR(50),
    price DECIMAL(10,2),
    cost DECIMAL(10,2),
    weight_kg DECIMAL(8,3),
    dimensions VARCHAR(50),
    color VARCHAR(30),
    size VARCHAR(20),
    stock_quantity INTEGER,
    supplier_id INTEGER,
    is_active BOOLEAN,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP(),
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP()
);

-- Insert sample product data
INSERT INTO products VALUES
(101, 'Wireless Bluetooth Headphones', 'Electronics', 'Audio', 'TechSound', 79.99, 35.00, 0.250, '18x15x8 cm', 'Black', 'One Size', 150, 1001, TRUE, '2023-01-10 08:00:00', '2024-12-20 10:30:00'),
(102, 'Smartphone Case', 'Electronics', 'Accessories', 'ProtectPro', 24.99, 8.50, 0.050, '16x8x1 cm', 'Blue', 'iPhone 14', 300, 1002, TRUE, '2023-01-15 09:30:00', '2024-12-22 14:15:00'),
(103, 'Running Shoes', 'Footwear', 'Athletic', 'SportMax', 129.99, 65.00, 0.800, '32x20x12 cm', 'White', '10', 75, 1003, TRUE, '2023-02-01 11:00:00', '2024-12-25 16:45:00'),
(104, 'Coffee Maker', 'Home & Kitchen', 'Appliances', 'BrewMaster', 89.99, 45.00, 2.500, '25x30x35 cm', 'Silver', 'Standard', 50, 1004, TRUE, '2023-02-10 13:20:00', '2024-12-18 09:20:00'),
(105, 'Yoga Mat', 'Sports & Outdoors', 'Fitness', 'FlexFit', 34.99, 15.00, 1.200, '183x61x0.6 cm', 'Purple', 'Standard', 200, 1005, TRUE, '2023-02-20 15:45:00', '2024-12-28 12:10:00'),
(106, 'Desk Lamp', 'Home & Kitchen', 'Lighting', 'BrightLight', 45.99, 22.00, 1.800, '40x15x15 cm', 'White', 'Adjustable', 120, 1006, TRUE, '2023-03-01 08:30:00', '2024-12-26 18:30:00'),
(107, 'Backpack', 'Bags & Luggage', 'Backpacks', 'AdventurePack', 69.99, 30.00, 0.900, '45x30x20 cm', 'Gray', '25L', 80, 1007, TRUE, '2023-03-15 10:15:00', '2024-12-24 11:45:00'),
(108, 'Water Bottle', 'Sports & Outdoors', 'Hydration', 'HydroFlow', 19.99, 7.50, 0.300, '25x7x7 cm', 'Blue', '750ml', 400, 1008, TRUE, '2023-03-20 14:20:00', '2024-12-29 15:20:00'),
(109, 'Wireless Mouse', 'Electronics', 'Computer Accessories', 'ClickPro', 39.99, 18.00, 0.120, '11x6x4 cm', 'Black', 'Standard', 250, 1009, TRUE, '2023-04-01 16:40:00', '2024-12-27 13:55:00'),
(110, 'Notebook Set', 'Office Supplies', 'Stationery', 'WriteWell', 15.99, 6.00, 0.400, '21x15x2 cm', 'Assorted', 'A5', 500, 1010, TRUE, '2023-04-10 12:10:00', '2024-12-23 17:30:00');

-- =====================================================
-- 3. ORDERS TABLE (Bronze Layer Source)
-- =====================================================
CREATE OR REPLACE TABLE orders (
    order_id INTEGER,
    customer_id INTEGER,
    order_date DATE,
    order_status VARCHAR(20),
    payment_method VARCHAR(30),
    payment_status VARCHAR(20),
    shipping_address VARCHAR(200),
    shipping_city VARCHAR(50),
    shipping_state VARCHAR(20),
    shipping_zip VARCHAR(10),
    shipping_country VARCHAR(50),
    shipping_cost DECIMAL(8,2),
    tax_amount DECIMAL(8,2),
    discount_amount DECIMAL(8,2),
    total_amount DECIMAL(10,2),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP(),
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP()
);

-- Insert sample order data
INSERT INTO orders VALUES
(2001, 1, '2024-12-01', 'delivered', 'credit_card', 'paid', '123 Main St', 'New York', 'NY', '10001', 'USA', 9.99, 8.50, 0.00, 98.48, '2024-12-01 10:30:00', '2024-12-05 14:20:00'),
(2002, 2, '2024-12-02', 'delivered', 'paypal', 'paid', '456 Oak Ave', 'Los Angeles', 'CA', '90210', 'USA', 12.99, 12.25, 5.00, 162.23, '2024-12-02 14:15:00', '2024-12-06 16:30:00'),
(2003, 3, '2024-12-03', 'shipped', 'credit_card', 'paid', '789 Pine Rd', 'Chicago', 'IL', '60601', 'USA', 8.99, 6.75, 0.00, 84.73, '2024-12-03 16:45:00', '2024-12-04 09:15:00'),
(2004, 1, '2024-12-05', 'processing', 'debit_card', 'paid', '123 Main St', 'New York', 'NY', '10001', 'USA', 9.99, 4.50, 10.00, 49.48, '2024-12-05 09:20:00', '2024-12-05 09:20:00'),
(2005, 4, '2024-12-07', 'cancelled', 'credit_card', 'refunded', '321 Elm St', 'Houston', 'TX', '77001', 'USA', 15.99, 18.75, 0.00, 209.73, '2024-12-07 12:10:00', '2024-12-08 11:45:00'),
(2006, 5, '2024-12-10', 'delivered', 'paypal', 'paid', '654 Maple Dr', 'Phoenix', 'AZ', '85001', 'USA', 11.99, 3.60, 0.00, 51.58, '2024-12-10 18:30:00', '2024-12-14 13:20:00'),
(2007, 6, '2024-12-12', 'delivered', 'credit_card', 'paid', '987 Cedar Ln', 'Philadelphia', 'PA', '19101', 'USA', 7.99, 5.52, 15.00, 68.50, '2024-12-12 11:45:00', '2024-12-16 15:10:00'),
(2008, 2, '2024-12-15', 'shipped', 'apple_pay', 'paid', '456 Oak Ave', 'Los Angeles', 'CA', '90210', 'USA', 12.99, 2.40, 0.00, 35.38, '2024-12-15 15:20:00', '2024-12-16 08:30:00'),
(2009, 8, '2024-12-18', 'processing', 'credit_card', 'paid', '258 Spruce Ave', 'San Diego', 'CA', '92101', 'USA', 10.99, 14.00, 0.00, 164.98, '2024-12-18 13:55:00', '2024-12-18 13:55:00'),
(2010, 9, '2024-12-20', 'delivered', 'paypal', 'paid', '369 Willow Rd', 'Dallas', 'TX', '75201', 'USA', 9.99, 1.92, 0.00, 27.90, '2024-12-20 17:30:00', '2024-12-24 10:15:00');

-- =====================================================
-- 4. ORDER_ITEMS TABLE (Bronze Layer Source)
-- =====================================================
CREATE OR REPLACE TABLE order_items (
    order_item_id INTEGER,
    order_id INTEGER,
    product_id INTEGER,
    quantity INTEGER,
    unit_price DECIMAL(10,2),
    total_price DECIMAL(10,2),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP()
);

-- Insert sample order items data
INSERT INTO order_items VALUES
(3001, 2001, 101, 1, 79.99, 79.99, '2024-12-01 10:30:00'),
(3002, 2002, 103, 1, 129.99, 129.99, '2024-12-02 14:15:00'),
(3003, 2002, 102, 1, 24.99, 24.99, '2024-12-02 14:15:00'),
(3004, 2003, 104, 1, 89.99, 89.99, '2024-12-03 16:45:00'),
(3005, 2004, 105, 1, 34.99, 34.99, '2024-12-05 09:20:00'),
(3006, 2004, 108, 1, 19.99, 19.99, '2024-12-05 09:20:00'),
(3007, 2005, 103, 1, 129.99, 129.99, '2024-12-07 12:10:00'),
(3008, 2005, 106, 1, 45.99, 45.99, '2024-12-07 12:10:00'),
(3009, 2005, 102, 1, 24.99, 24.99, '2024-12-07 12:10:00'),
(3010, 2006, 105, 1, 34.99, 34.99, '2024-12-10 18:30:00'),
(3011, 2007, 107, 1, 69.99, 69.99, '2024-12-12 11:45:00'),
(3012, 2007, 110, 1, 15.99, 15.99, '2024-12-12 11:45:00'),
(3013, 2008, 108, 1, 19.99, 19.99, '2024-12-15 15:20:00'),
(3014, 2009, 103, 1, 129.99, 129.99, '2024-12-18 13:55:00'),
(3015, 2009, 102, 1, 24.99, 24.99, '2024-12-18 13:55:00'),
(3016, 2010, 110, 1, 15.99, 15.99, '2024-12-20 17:30:00');

-- =====================================================
-- 5. SUPPLIERS TABLE (Bronze Layer Source)
-- =====================================================
CREATE OR REPLACE TABLE suppliers (
    supplier_id INTEGER,
    supplier_name VARCHAR(100),
    contact_person VARCHAR(100),
    email VARCHAR(100),
    phone VARCHAR(20),
    address VARCHAR(200),
    city VARCHAR(50),
    state VARCHAR(20),
    zip_code VARCHAR(10),
    country VARCHAR(50),
    supplier_rating DECIMAL(3,2),
    is_active BOOLEAN,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP(),
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP()
);

-- Insert sample supplier data
INSERT INTO suppliers VALUES
(1001, 'TechSound Manufacturing', 'Alice Johnson', 'alice@techsound.com', '555-2001', '100 Tech Park', 'Austin', 'TX', '78701', 'USA', 4.5, TRUE, '2023-01-01 08:00:00', '2024-12-15 10:30:00'),
(1002, 'ProtectPro Industries', 'Bob Smith', 'bob@protectpro.com', '555-2002', '200 Industrial Blvd', 'Detroit', 'MI', '48201', 'USA', 4.2, TRUE, '2023-01-05 09:30:00', '2024-12-18 14:15:00'),
(1003, 'SportMax Global', 'Carol Davis', 'carol@sportmax.com', '555-2003', '300 Sports Ave', 'Portland', 'OR', '97201', 'USA', 4.8, TRUE, '2023-01-10 11:00:00', '2024-12-20 16:45:00'),
(1004, 'BrewMaster Corp', 'David Wilson', 'david@brewmaster.com', '555-2004', '400 Coffee St', 'Seattle', 'WA', '98101', 'USA', 4.3, TRUE, '2023-01-15 13:20:00', '2024-12-22 09:20:00'),
(1005, 'FlexFit Solutions', 'Emma Brown', 'emma@flexfit.com', '555-2005', '500 Wellness Way', 'Denver', 'CO', '80201', 'USA', 4.6, TRUE, '2023-01-20 15:45:00', '2024-12-25 12:10:00'),
(1006, 'BrightLight Systems', 'Frank Garcia', 'frank@brightlight.com', '555-2006', '600 Illumination Dr', 'Miami', 'FL', '33101', 'USA', 4.1, TRUE, '2023-01-25 08:30:00', '2024-12-28 18:30:00'),
(1007, 'AdventurePack Co', 'Grace Martinez', 'grace@adventurepack.com', '555-2007', '700 Outdoor Ln', 'Boulder', 'CO', '80301', 'USA', 4.7, TRUE, '2023-02-01 10:15:00', '2024-12-30 11:45:00'),
(1008, 'HydroFlow Inc', 'Henry Rodriguez', 'henry@hydroflow.com', '555-2008', '800 Water St', 'San Francisco', 'CA', '94101', 'USA', 4.4, TRUE, '2023-02-05 14:20:00', '2024-12-29 15:20:00'),
(1009, 'ClickPro Technologies', 'Ivy Lee', 'ivy@clickpro.com', '555-2009', '900 Mouse Rd', 'San Jose', 'CA', '95101', 'USA', 4.0, TRUE, '2023-02-10 16:40:00', '2024-12-27 13:55:00'),
(1010, 'WriteWell Supplies', 'Jack Taylor', 'jack@writewell.com', '555-2010', '1000 Paper Ave', 'Boston', 'MA', '02101', 'USA', 4.5, TRUE, '2023-02-15 12:10:00', '2024-12-26 17:30:00');

-- =====================================================
-- 6. VERIFICATION QUERIES
-- =====================================================
-- Run these to verify your data was loaded correctly

SELECT 'customers' as table_name, COUNT(*) as record_count FROM customers
UNION ALL
SELECT 'products' as table_name, COUNT(*) as record_count FROM products
UNION ALL
SELECT 'orders' as table_name, COUNT(*) as record_count FROM orders
UNION ALL
SELECT 'order_items' as table_name, COUNT(*) as record_count FROM order_items
UNION ALL
SELECT 'suppliers' as table_name, COUNT(*) as record_count FROM suppliers;

-- Sample analytical queries you can use to test your dbt models
SELECT 
    c.customer_id,
    c.first_name || ' ' || c.last_name as customer_name,
    COUNT(o.order_id) as total_orders,
    SUM(o.total_amount) as total_spent
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name
ORDER BY total_spent DESC;

-- =====================================================
-- NOTES FOR DBT DEVELOPMENT:
-- =====================================================
-- 
-- BRONZE LAYER (RAW): 
-- - Use these tables as sources in your dbt project
-- - Create source definitions in schema.yml
-- 
-- SILVER LAYER (STAGING):
-- - Clean and standardize data
-- - Apply business rules
-- - Create staging models (stg_customers, stg_products, etc.)
-- 
-- GOLD LAYER (MARTS):
-- - Create business-ready dimensional models
-- - Customer analytics, product performance, sales metrics
-- - Fact and dimension tables
-- 
-- EXAMPLE TRANSFORMATIONS TO BUILD:
-- 1. Customer lifetime value
-- 2. Product performance metrics
-- 3. Monthly sales trends
-- 4. Customer segmentation
-- 5. Supplier performance analysis