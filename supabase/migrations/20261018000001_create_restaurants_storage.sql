-- =====================================================================
-- SUPERSEDED by 20261019000000_combined_security.sql
-- =====================================================================
-- This migration has been replaced by the combined security migration which
-- includes proper storage bucket creation and admin-only policies.
-- 
-- DO NOT RUN THIS FILE
-- Run 20261019000000_combined_security.sql instead
-- =====================================================================

/*
-- Original content (DO NOT USE - has invalid 'create policy if not exists'):

insert into storage.buckets (id, name, public)
values ('restaurants', 'restaurants', true)
on conflict (id) do nothing;

create policy if not exists "Authenticated users can upload restaurant images"
  on storage.objects for insert
  to authenticated
  with check (bucket_id = 'restaurants');
...
*/
