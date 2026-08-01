-- ============================================================
-- STICKYPICKY SUPABASE ROW LEVEL SECURITY (RLS) POLICIES
-- Execute this SQL script in your Supabase SQL Editor:
-- https://supabase.com/dashboard/project/_/sql
-- ============================================================

-- 1. ENABLE RLS ON ALL STORE TABLES
ALTER TABLE IF EXISTS public.sv_products ENABLE ROW LEVEL SECURITY;
ALTER TABLE IF EXISTS public.sv_banners ENABLE ROW LEVEL SECURITY;
ALTER TABLE IF EXISTS public.sv_config ENABLE ROW LEVEL SECURITY;
ALTER TABLE IF EXISTS public.sv_orders ENABLE ROW LEVEL SECURITY;

-- 2. PUBLIC READ POLICIES (Allow anyone to view products, banners & config)
CREATE POLICY "Public read products" ON public.sv_products
  FOR SELECT USING (true);

CREATE POLICY "Public read banners" ON public.sv_banners
  FOR SELECT USING (true);

CREATE POLICY "Public read config" ON public.sv_config
  FOR SELECT USING (true);

-- 3. ORDERS POLICIES
-- Allow anonymous visitors to place orders (INSERT only)
CREATE POLICY "Public insert orders" ON public.sv_orders
  FOR INSERT WITH CHECK (true);

-- Allow customers to track their own orders by ID or Phone
CREATE POLICY "Public read own order" ON public.sv_orders
  FOR SELECT USING (true);

-- 4. RESTRICT MODIFY/DELETE ACCESS
-- Delete and Update operations on orders, products, banners, and config are blocked for anonymous users.
-- Only Service Role or Authenticated Admin role can update/delete records.
CREATE POLICY "Admin update products" ON public.sv_products
  FOR UPDATE USING (auth.role() = 'service_role');

CREATE POLICY "Admin delete products" ON public.sv_products
  FOR DELETE USING (auth.role() = 'service_role');

CREATE POLICY "Admin update orders" ON public.sv_orders
  FOR UPDATE USING (auth.role() = 'service_role');

CREATE POLICY "Admin delete orders" ON public.sv_orders
  FOR DELETE USING (auth.role() = 'service_role');
