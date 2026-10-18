-- Let the admin dashboard add, edit, and delete tables.
CREATE POLICY "Tables can be inserted from dashboard"
ON public.tables
FOR INSERT
TO anon, authenticated
WITH CHECK (true);

CREATE POLICY "Tables can be updated from dashboard"
ON public.tables
FOR UPDATE
TO anon, authenticated
USING (true)
WITH CHECK (true);

CREATE POLICY "Tables can be deleted from dashboard"
ON public.tables
FOR DELETE
TO anon, authenticated
USING (true);
