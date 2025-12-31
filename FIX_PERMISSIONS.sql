-- Run this script in the Supabase SQL Editor to FIX DELETE ISSUES

BEGIN;

-- 1. Reset permissions for 'students' table
ALTER TABLE IF EXISTS public.students ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS "Enable all access for students" ON public.students;
DROP POLICY IF EXISTS "allow_all_students" ON public.students;

CREATE POLICY "allow_all_students" ON public.students
FOR ALL
USING (true)
WITH CHECK (true);

-- 2. Reset permissions for 'tutors' table
ALTER TABLE IF EXISTS public.tutors ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS "Enable all access for tutors" ON public.tutors;
DROP POLICY IF EXISTS "allow_all_tutors" ON public.tutors;

CREATE POLICY "allow_all_tutors" ON public.tutors
FOR ALL
USING (true)
WITH CHECK (true);

COMMIT;
