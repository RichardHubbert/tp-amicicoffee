-- Security Fix: Tighten RLS policies to prevent data leaks
-- This migration fixes the security audit findings:
-- 1. Anon users can no longer read all bookings (only authenticated admins)
-- 2. Admin role check uses proper role field, not email substring
-- 3. Public can only read restaurant info and insert bookings

-- ============================================
-- BOOKINGS TABLE RLS
-- ============================================

-- Drop existing insecure policies
DROP POLICY IF EXISTS "Bookings are viewable by everyone" ON bookings;
DROP POLICY IF EXISTS "Bookings are manageable by admin" ON bookings;
DROP POLICY IF EXISTS "Authenticated users can create bookings" ON bookings;

-- Anon users can ONLY insert bookings (create new reservations)
CREATE POLICY "Anon can insert bookings" ON bookings
  FOR INSERT 
  TO anon
  WITH CHECK (true);

-- Authenticated users can insert their own bookings
CREATE POLICY "Authenticated can insert bookings" ON bookings
  FOR INSERT 
  TO authenticated
  WITH CHECK (true);

-- Only admins can view bookings (proper role check via profiles table)
CREATE POLICY "Admins can view all bookings" ON bookings
  FOR SELECT 
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM profiles
      WHERE profiles.user_id = auth.uid()
      AND profiles.role = 'admin'
    )
  );

-- Only admins can update bookings
CREATE POLICY "Admins can update bookings" ON bookings
  FOR UPDATE
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM profiles
      WHERE profiles.user_id = auth.uid()
      AND profiles.role = 'admin'
    )
  );

-- Only admins can delete bookings
CREATE POLICY "Admins can delete bookings" ON bookings
  FOR DELETE
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM profiles
      WHERE profiles.user_id = auth.uid()
      AND profiles.role = 'admin'
    )
  );

-- ============================================
-- RESTAURANTS TABLE RLS
-- ============================================

-- Drop existing policies if they exist
DROP POLICY IF EXISTS "Restaurants are viewable by everyone" ON restaurants;
DROP POLICY IF EXISTS "Restaurants are manageable by admin" ON restaurants;

-- Public (anon and authenticated) can view active restaurants
CREATE POLICY "Public can view active restaurants" ON restaurants
  FOR SELECT
  USING (is_active = true);

-- Only admins can manage restaurants (proper role check)
CREATE POLICY "Admins can manage restaurants" ON restaurants
  FOR ALL
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM profiles
      WHERE profiles.user_id = auth.uid()
      AND profiles.role = 'admin'
    )
  );

-- ============================================
-- TABLES TABLE RLS
-- ============================================

-- Ensure tables table has RLS enabled
ALTER TABLE tables ENABLE ROW LEVEL SECURITY;

-- Drop existing policies if they exist
DROP POLICY IF EXISTS "Tables are viewable by everyone" ON tables;
DROP POLICY IF EXISTS "Tables are manageable by admin" ON tables;

-- Public can view tables (needed for booking interface)
CREATE POLICY "Public can view tables" ON tables
  FOR SELECT
  USING (true);

-- Only admins can manage tables
CREATE POLICY "Admins can manage tables" ON tables
  FOR ALL
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM profiles
      WHERE profiles.user_id = auth.uid()
      AND profiles.role = 'admin'
    )
  );

-- ============================================
-- PROFILES TABLE RLS
-- ============================================

-- Drop existing policies
DROP POLICY IF EXISTS "Users can view their own profile" ON profiles;
DROP POLICY IF EXISTS "Users can update their own profile" ON profiles;
DROP POLICY IF EXISTS "Profiles are viewable by everyone" ON profiles;

-- Users can view their own profile only
CREATE POLICY "Users can view own profile" ON profiles
  FOR SELECT
  TO authenticated
  USING (user_id = auth.uid());

-- Users can update their own profile only
CREATE POLICY "Users can update own profile" ON profiles
  FOR UPDATE
  TO authenticated
  USING (user_id = auth.uid());

-- Admins can view all profiles
CREATE POLICY "Admins can view all profiles" ON profiles
  FOR SELECT
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM profiles p
      WHERE p.user_id = auth.uid()
      AND p.role = 'admin'
    )
  );

-- Admins can manage all profiles
CREATE POLICY "Admins can manage profiles" ON profiles
  FOR ALL
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM profiles p
      WHERE p.user_id = auth.uid()
      AND p.role = 'admin'
    )
  );
