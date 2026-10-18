-- Create storage bucket for restaurant images (hero images and regular images)
-- This migration is safe to run even if the bucket already exists

insert into storage.buckets (id, name, public)
values ('restaurants', 'restaurants', true)
on conflict (id) do nothing;

-- Storage policies for restaurant images
-- Allow authenticated users to upload images
create policy if not exists "Authenticated users can upload restaurant images"
  on storage.objects for insert
  to authenticated
  with check (bucket_id = 'restaurants');

-- Allow authenticated users to update their uploads
create policy if not exists "Authenticated users can update restaurant images"
  on storage.objects for update
  to authenticated
  using (bucket_id = 'restaurants');

-- Allow authenticated users to delete images
create policy if not exists "Authenticated users can delete restaurant images"
  on storage.objects for delete
  to authenticated
  using (bucket_id = 'restaurants');

-- Public read access to all restaurant images
create policy if not exists "Anyone can view restaurant images"
  on storage.objects for select
  to public
  using (bucket_id = 'restaurants');
