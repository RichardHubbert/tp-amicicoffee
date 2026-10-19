-- Fix restaurant data where address field contains phone number
-- This is idempotent and safe to run multiple times

BEGIN;

-- Check for addresses that contain phone numbers (format: "address Phone: number")
-- and split them properly
UPDATE public.restaurants
SET 
  address = TRIM(REGEXP_REPLACE(address, '\s*Phone:.*$', '', 'i')),
  phone = COALESCE(
    NULLIF(TRIM(phone), ''),
    TRIM(REGEXP_REPLACE(REGEXP_REPLACE(address, '^.*Phone:\s*', '', 'i'), '[^0-9+ ]', '', 'g'))
  )
WHERE address ~* 'Phone:'
  AND address != TRIM(REGEXP_REPLACE(address, '\s*Phone:.*$', '', 'i'));

-- Report what was fixed
DO $$
DECLARE
  v_count integer;
BEGIN
  SELECT COUNT(*) INTO v_count
  FROM public.restaurants
  WHERE address ~* 'Phone:';
  
  IF v_count > 0 THEN
    RAISE WARNING 'Still found % restaurant(s) with "Phone:" in address. Manual review may be needed.', v_count;
  ELSE
    RAISE NOTICE 'All restaurant addresses cleaned. Phone numbers extracted to phone field.';
  END IF;
END $$;

-- Show current restaurant data for verification
SELECT id, name, address, phone, email
FROM public.restaurants
ORDER BY name;

COMMIT;
