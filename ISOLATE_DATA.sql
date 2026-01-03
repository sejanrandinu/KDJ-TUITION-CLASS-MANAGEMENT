-- ISOLATE DATA PER USER (MULTI-TENANCY)
-- Run this script in your Supabase SQL Editor

-- 1. Add user_id column to all tables
-- We use DEFAULT auth.uid() so that when a user adds a record, it's automatically linked to them.

ALTER TABLE public.staff ADD COLUMN IF NOT EXISTS user_id UUID DEFAULT auth.uid();
ALTER TABLE public.roles ADD COLUMN IF NOT EXISTS user_id UUID DEFAULT auth.uid();
ALTER TABLE public.students ADD COLUMN IF NOT EXISTS user_id UUID DEFAULT auth.uid();
ALTER TABLE public.tutors ADD COLUMN IF NOT EXISTS user_id UUID DEFAULT auth.uid();
ALTER TABLE public.classes ADD COLUMN IF NOT EXISTS user_id UUID DEFAULT auth.uid();
ALTER TABLE public.subjects ADD COLUMN IF NOT EXISTS user_id UUID DEFAULT auth.uid();
ALTER TABLE public.attendance ADD COLUMN IF NOT EXISTS user_id UUID DEFAULT auth.uid();
ALTER TABLE public.payments ADD COLUMN IF NOT EXISTS user_id UUID DEFAULT auth.uid();
ALTER TABLE public.salary_payments ADD COLUMN IF NOT EXISTS user_id UUID DEFAULT auth.uid();
ALTER TABLE public.messages ADD COLUMN IF NOT EXISTS user_id UUID DEFAULT auth.uid();

-- 2. Drop existing "allow all" policies
DROP POLICY IF EXISTS "Enable all access for staff" ON public.staff;
DROP POLICY IF EXISTS "allow_all_roles" ON public.roles;
DROP POLICY IF EXISTS "Enable all access for students" ON public.students;
DROP POLICY IF EXISTS "Enable all access for tutors" ON public.tutors;
DROP POLICY IF EXISTS "allow_all_classes" ON public.classes;
DROP POLICY IF EXISTS "allow_all_subjects" ON public.subjects;
DROP POLICY IF EXISTS "allow_all_attendance" ON public.attendance;
DROP POLICY IF EXISTS "allow_all_payments" ON public.payments;
DROP POLICY IF EXISTS "Enable all access for salary_payments" ON public.salary_payments;
DROP POLICY IF EXISTS "allow_all_messages" ON public.messages;

-- 3. Create NEW policies for Data Isolation
-- These policies ensure that a user can ONLY see and modify data they created.

-- Staff Isolation
CREATE POLICY "staff_isolation_policy" ON public.staff
FOR ALL USING (auth.uid() = user_id) WITH CHECK (auth.uid() = user_id);

-- Roles Isolation
CREATE POLICY "roles_isolation_policy" ON public.roles
FOR ALL USING (auth.uid() = user_id) WITH CHECK (auth.uid() = user_id);

-- Students Isolation
CREATE POLICY "students_isolation_policy" ON public.students
FOR ALL USING (auth.uid() = user_id) WITH CHECK (auth.uid() = user_id);

-- Tutors Isolation
CREATE POLICY "tutors_isolation_policy" ON public.tutors
FOR ALL USING (auth.uid() = user_id) WITH CHECK (auth.uid() = user_id);

-- Classes Isolation
CREATE POLICY "classes_isolation_policy" ON public.classes
FOR ALL USING (auth.uid() = user_id) WITH CHECK (auth.uid() = user_id);

-- Subjects Isolation
CREATE POLICY "subjects_isolation_policy" ON public.subjects
FOR ALL USING (auth.uid() = user_id) WITH CHECK (auth.uid() = user_id);

-- Attendance Isolation
CREATE POLICY "attendance_isolation_policy" ON public.attendance
FOR ALL USING (auth.uid() = user_id) WITH CHECK (auth.uid() = user_id);

-- Payments Isolation
CREATE POLICY "payments_isolation_policy" ON public.payments
FOR ALL USING (auth.uid() = user_id) WITH CHECK (auth.uid() = user_id);

-- Salary Payments Isolation
CREATE POLICY "salary_payments_isolation_policy" ON public.salary_payments
FOR ALL USING (auth.uid() = user_id) WITH CHECK (auth.uid() = user_id);

-- Messages Isolation
CREATE POLICY "messages_isolation_policy" ON public.messages
FOR ALL USING (auth.uid() = user_id) WITH CHECK (auth.uid() = user_id);

-- 4. Special Note for existing data
-- If you already have data in your tables, you might want to assign them to your current user ID:
-- UPDATE public.staff SET user_id = 'YOUR_USER_ID_HERE' WHERE user_id IS NULL;
-- (Replace YOUR_USER_ID_HERE with your actual Supabase User ID from the Auth section)
