-- FIX RLS POLICIES FOR ALL TABLES
-- Run this in Supabase SQL Editor to fix "Access Denied" or inability to add data.
-- This script changes policies so ANY logged-in user (Authenticated) can View/Add/Edit/Delete data.

BEGIN;

-- 1. Students
ALTER TABLE IF EXISTS public.students ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS "students_isolation_policy" ON public.students;
DROP POLICY IF EXISTS "allow_all_students" ON public.students;
DROP POLICY IF EXISTS "Enable all access for students" ON public.students;
CREATE POLICY "allow_authenticated_students" ON public.students
FOR ALL USING (auth.role() = 'authenticated') WITH CHECK (auth.role() = 'authenticated');

-- 2. Tutors
ALTER TABLE IF EXISTS public.tutors ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS "tutors_isolation_policy" ON public.tutors;
DROP POLICY IF EXISTS "allow_all_tutors" ON public.tutors;
DROP POLICY IF EXISTS "Enable all access for tutors" ON public.tutors;
CREATE POLICY "allow_authenticated_tutors" ON public.tutors
FOR ALL USING (auth.role() = 'authenticated') WITH CHECK (auth.role() = 'authenticated');

-- 3. Classes
ALTER TABLE IF EXISTS public.classes ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS "classes_isolation_policy" ON public.classes;
DROP POLICY IF EXISTS "allow_all_classes" ON public.classes;
CREATE POLICY "allow_authenticated_classes" ON public.classes
FOR ALL USING (auth.role() = 'authenticated') WITH CHECK (auth.role() = 'authenticated');

-- 4. Subjects
ALTER TABLE IF EXISTS public.subjects ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS "subjects_isolation_policy" ON public.subjects;
DROP POLICY IF EXISTS "allow_all_subjects" ON public.subjects;
CREATE POLICY "allow_authenticated_subjects" ON public.subjects
FOR ALL USING (auth.role() = 'authenticated') WITH CHECK (auth.role() = 'authenticated');

-- 5. Attendance
ALTER TABLE IF EXISTS public.attendance ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS "attendance_isolation_policy" ON public.attendance;
DROP POLICY IF EXISTS "allow_all_attendance" ON public.attendance;
CREATE POLICY "allow_authenticated_attendance" ON public.attendance
FOR ALL USING (auth.role() = 'authenticated') WITH CHECK (auth.role() = 'authenticated');

-- 6. Payments
ALTER TABLE IF EXISTS public.payments ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS "payments_isolation_policy" ON public.payments;
DROP POLICY IF EXISTS "allow_all_payments" ON public.payments;
CREATE POLICY "allow_authenticated_payments" ON public.payments
FOR ALL USING (auth.role() = 'authenticated') WITH CHECK (auth.role() = 'authenticated');

-- 7. Messages
ALTER TABLE IF EXISTS public.messages ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS "messages_isolation_policy" ON public.messages;
DROP POLICY IF EXISTS "allow_all_messages" ON public.messages;
CREATE POLICY "allow_authenticated_messages" ON public.messages
FOR ALL USING (auth.role() = 'authenticated') WITH CHECK (auth.role() = 'authenticated');

-- 8. Staff
ALTER TABLE IF EXISTS public.staff ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS "staff_isolation_policy" ON public.staff;
DROP POLICY IF EXISTS "Enable all access for staff" ON public.staff;
CREATE POLICY "allow_authenticated_staff" ON public.staff
FOR ALL USING (auth.role() = 'authenticated') WITH CHECK (auth.role() = 'authenticated');

-- 9. Roles
ALTER TABLE IF EXISTS public.roles ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS "roles_isolation_policy" ON public.roles;
DROP POLICY IF EXISTS "allow_all_roles" ON public.roles;
CREATE POLICY "allow_authenticated_roles" ON public.roles
FOR ALL USING (auth.role() = 'authenticated') WITH CHECK (auth.role() = 'authenticated');

-- 10. Salary Payments
ALTER TABLE IF EXISTS public.salary_payments ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS "salary_payments_isolation_policy" ON public.salary_payments;
DROP POLICY IF EXISTS "Enable all access for salary_payments" ON public.salary_payments;
CREATE POLICY "allow_authenticated_salary_payments" ON public.salary_payments
FOR ALL USING (auth.role() = 'authenticated') WITH CHECK (auth.role() = 'authenticated');

COMMIT;
