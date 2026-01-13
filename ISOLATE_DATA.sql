-- 1. Enable RLS on all sensitive tables
ALTER TABLE students ENABLE ROW LEVEL SECURITY;
ALTER TABLE tutors ENABLE ROW LEVEL SECURITY;
ALTER TABLE classes ENABLE ROW LEVEL SECURITY;
ALTER TABLE subjects ENABLE ROW LEVEL SECURITY;
ALTER TABLE attendance ENABLE ROW LEVEL SECURITY;
ALTER TABLE payments ENABLE ROW LEVEL SECURITY;
ALTER TABLE salary_payments ENABLE ROW LEVEL SECURITY;
ALTER TABLE messages ENABLE ROW LEVEL SECURITY;
ALTER TABLE activities ENABLE ROW LEVEL SECURITY;

-- 2. Create a generic trigger function to auto-assign user_id on INSERT
CREATE OR REPLACE FUNCTION public.set_user_id()
RETURNS TRIGGER AS $$
BEGIN
  -- If user_id is already set, leave it (allows super admin to override if needed in future)
  -- Otherwise, set it to the current auth.uid()
  IF NEW.user_id IS NULL THEN
    NEW.user_id := auth.uid();
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- 3. Attach the trigger to all tables
-- We drop first to avoid errors if rerunning
DROP TRIGGER IF EXISTS tr_students_set_user_id ON students;
CREATE TRIGGER tr_students_set_user_id BEFORE INSERT ON students FOR EACH ROW EXECUTE FUNCTION public.set_user_id();

DROP TRIGGER IF EXISTS tr_tutors_set_user_id ON tutors;
CREATE TRIGGER tr_tutors_set_user_id BEFORE INSERT ON tutors FOR EACH ROW EXECUTE FUNCTION public.set_user_id();

DROP TRIGGER IF EXISTS tr_classes_set_user_id ON classes;
CREATE TRIGGER tr_classes_set_user_id BEFORE INSERT ON classes FOR EACH ROW EXECUTE FUNCTION public.set_user_id();

DROP TRIGGER IF EXISTS tr_subjects_set_user_id ON subjects;
CREATE TRIGGER tr_subjects_set_user_id BEFORE INSERT ON subjects FOR EACH ROW EXECUTE FUNCTION public.set_user_id();

DROP TRIGGER IF EXISTS tr_attendance_set_user_id ON attendance;
CREATE TRIGGER tr_attendance_set_user_id BEFORE INSERT ON attendance FOR EACH ROW EXECUTE FUNCTION public.set_user_id();

DROP TRIGGER IF EXISTS tr_payments_set_user_id ON payments;
CREATE TRIGGER tr_payments_set_user_id BEFORE INSERT ON payments FOR EACH ROW EXECUTE FUNCTION public.set_user_id();

DROP TRIGGER IF EXISTS tr_salary_payments_set_user_id ON salary_payments;
CREATE TRIGGER tr_salary_payments_set_user_id BEFORE INSERT ON salary_payments FOR EACH ROW EXECUTE FUNCTION public.set_user_id();

DROP TRIGGER IF EXISTS tr_messages_set_user_id ON messages;
CREATE TRIGGER tr_messages_set_user_id BEFORE INSERT ON messages FOR EACH ROW EXECUTE FUNCTION public.set_user_id();

DROP TRIGGER IF EXISTS tr_activities_set_user_id ON activities;
CREATE TRIGGER tr_activities_set_user_id BEFORE INSERT ON activities FOR EACH ROW EXECUTE FUNCTION public.set_user_id();

-- 4. Clean up OLD permissive policies (Drop everything to be safe)
DROP POLICY IF EXISTS "Enable all for authenticated users" ON students;
DROP POLICY IF EXISTS "Enable all for authenticated users" ON tutors;
DROP POLICY IF EXISTS "Enable all for authenticated users" ON classes;
DROP POLICY IF EXISTS "Enable all for authenticated users" ON subjects;
DROP POLICY IF EXISTS "Enable all for authenticated users" ON attendance;
DROP POLICY IF EXISTS "Enable all for authenticated users" ON payments;
DROP POLICY IF EXISTS "Enable all for authenticated users" ON salary_payments;
DROP POLICY IF EXISTS "Enable all for authenticated users" ON messages;
DROP POLICY IF EXISTS "Enable all for authenticated users" ON activities;

-- Also drop any other named policies that might exist
DROP POLICY IF EXISTS "Users can manage their own students" ON students;
DROP POLICY IF EXISTS "Users can manage their own tutors" ON tutors;

-- 5. Create NEW Strict Isolation Policies
-- "Users can only see and manage rows where user_id = their uid"

-- Helper macro for clean policy creation? No, just write them out.

CREATE POLICY "Isolation Policy" ON students
AS PERMISSIVE FOR ALL
TO authenticated
USING (auth.uid() = user_id)
WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Isolation Policy" ON tutors
AS PERMISSIVE FOR ALL
TO authenticated
USING (auth.uid() = user_id)
WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Isolation Policy" ON classes
AS PERMISSIVE FOR ALL
TO authenticated
USING (auth.uid() = user_id)
WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Isolation Policy" ON subjects
AS PERMISSIVE FOR ALL
TO authenticated
USING (auth.uid() = user_id)
WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Isolation Policy" ON attendance
AS PERMISSIVE FOR ALL
TO authenticated
USING (auth.uid() = user_id)
WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Isolation Policy" ON payments
AS PERMISSIVE FOR ALL
TO authenticated
USING (auth.uid() = user_id)
WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Isolation Policy" ON salary_payments
AS PERMISSIVE FOR ALL
TO authenticated
USING (auth.uid() = user_id)
WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Isolation Policy" ON messages
AS PERMISSIVE FOR ALL
TO authenticated
USING (auth.uid() = user_id)
WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Isolation Policy" ON activities
AS PERMISSIVE FOR ALL
TO authenticated
USING (auth.uid() = user_id)
WITH CHECK (auth.uid() = user_id);
