-- =====================================================================
-- SUPERSEDED by 20261019000000_combined_security.sql
-- =====================================================================
-- This migration is broken (category_id FK references table that doesn't exist yet)
-- and has been replaced by the combined security migration which creates
-- restaurant_categories BEFORE adding the FK constraint.
-- 
-- DO NOT RUN THIS FILE
-- Run 20261019000000_combined_security.sql instead
-- =====================================================================

/*
-- Original content (DO NOT USE):

alter table public.restaurants
  add column if not exists hero_image_url text,
  add column if not exists elevenlabs_enabled boolean not null default false,
  add column if not exists elevenlabs_agent_id text,
  add column if not exists is_default boolean not null default false,
  add column if not exists category_id uuid references public.restaurant_categories(id) on delete set null,
  add column if not exists county text;

create table if not exists public.restaurant_categories (
  id uuid default gen_random_uuid() primary key,
  name text not null unique,
  created_at timestamp with time zone default now()
);
...
*/
