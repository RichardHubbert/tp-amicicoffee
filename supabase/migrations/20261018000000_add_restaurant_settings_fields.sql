-- Add restaurant settings fields for DashboardRestaurants feature from tp-woodman core
-- These columns support: hero images, ElevenLabs voice agent, default restaurant, and categories

alter table public.restaurants
  add column if not exists hero_image_url text,
  add column if not exists elevenlabs_enabled boolean not null default false,
  add column if not exists elevenlabs_agent_id text,
  add column if not exists is_default boolean not null default false,
  add column if not exists category_id uuid references public.restaurant_categories(id) on delete set null,
  add column if not exists county text;

-- Create restaurant_categories table
create table if not exists public.restaurant_categories (
  id uuid default gen_random_uuid() primary key,
  name text not null unique,
  created_at timestamp with time zone default now()
);

-- Enable RLS on restaurant_categories
alter table public.restaurant_categories enable row level security;

-- Public read access to categories
create policy "Restaurant categories are viewable by everyone"
  on public.restaurant_categories for select
  using (true);

-- Admin can manage categories
create policy "Restaurant categories are manageable by admin"
  on public.restaurant_categories for all
  using (
    auth.jwt() ->> 'email' = 'richardhubbert@gmail.com'
  );

-- Create index for county filtering
create index if not exists idx_restaurants_county on public.restaurants(county);
create index if not exists idx_restaurants_is_default on public.restaurants(is_default);
