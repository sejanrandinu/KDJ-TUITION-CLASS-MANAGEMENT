<template>
  <q-page class="q-pa-lg bg-grey-1">
    <!-- Page Header -->
    <div class="row items-center justify-between q-mb-xl">
      <div>
        <h1 class="text-h3 text-weight-bolder text-grey-9 q-mb-xs mt-0">Attendance Tracker</h1>
        <div class="text-subtitle1 text-grey-6">Mark and monitor student attendance for your classes.</div>
      </div>
    </div>

    <!-- Filters Section -->
    <q-card flat class="glass-modern q-pa-lg q-mb-xl">
        <div class="row q-col-gutter-lg items-end">
            <div class="col-12 col-md-4">
                <q-select 
                    filled 
                    v-model="selectedClass" 
                    :options="classOptions" 
                    label="Select Class" 
                    emit-value
                    map-options
                    @update:model-value="fetchAttendanceData"
                >
                    <template v-slot:prepend><q-icon name="class" color="primary" /></template>
                </q-select>
            </div>
            <div class="col-12 col-md-3">
                <q-input filled v-model="selectedDate" label="Session Date" type="date" stack-label @update:model-value="fetchAttendanceData">
                    <template v-slot:prepend><q-icon name="event" color="primary" /></template>
                </q-input>
            </div>
            <div class="col-12 col-md-5">
                <div class="row q-gutter-sm justify-end">
                     <q-btn 
                        color="secondary" 
                        outline 
                        icon="history" 
                        label="View History" 
                        no-caps 
                        class="rounded-borders"
                    />
                    <q-btn 
                        color="primary" 
                        icon="check_circle" 
                        label="Save Attendance" 
                        unelevated 
                        no-caps 
                        class="premium-btn q-px-lg"
                        :loading="loading"
                        @click="saveAttendance"
                    />
                </div>
            </div>
        </div>
    </q-card>

    <!-- Content Area -->
    <div v-if="!selectedClass" class="flex flex-center q-pa-xl empty-container">
        <div class="text-center">
            <q-icon name="arrow_upward" size="64px" color="grey-4" />
            <div class="text-h5 text-grey-5 q-mt-md">Please select a class to begin</div>
        </div>
    </div>

    <div v-else-if="students.length === 0 && !loading" class="flex flex-center q-pa-xl empty-container">
        <div class="text-center">
            <q-icon name="group_off" size="64px" color="grey-4" />
            <div class="text-h5 text-grey-5 q-mt-md">No students found for this grade</div>
            <p class="text-grey-6">Only students in {{ selectedClassGrade }} will appear here.</p>
        </div>
    </div>

    <div v-else class="row q-col-gutter-lg">
        <div class="col-12">
            <q-card flat class="glass-modern overflow-hidden">
                <q-table
                    flat
                    :rows="students"
                    :columns="columns"
                    row-key="id"
                    :pagination="{ rowsPerPage: 0 }"
                    hide-bottom
                >
                    <template v-slot:body-cell-status="props">
                        <q-td :props="props">
                            <q-btn-toggle
                                v-model="props.row.attendanceStatus"
                                spread
                                no-caps
                                unelevated
                                toggle-color="primary"
                                color="grey-2"
                                text-color="grey-7"
                                size="sm"
                                class="attendance-toggle"
                                :options="[
                                    { label: 'Present', value: 'Present', slot: 'present' },
                                    { label: 'Absent', value: 'Absent', slot: 'absent' }
                                ]"
                            >
                                <template v-slot:present>
                                    <q-icon name="check" size="16px" class="q-mr-xs" /> Present
                                </template>
                                <template v-slot:absent>
                                    <q-icon name="close" size="16px" class="q-mr-xs" /> Absent
                                </template>
                            </q-btn-toggle>
                        </q-td>
                    </template>

                    <template v-slot:body-cell-student_id="props">
                        <q-td :props="props">
                           <span class="text-weight-bold text-primary">{{ props.value }}</span>
                        </q-td>
                    </template>

                    <template v-slot:body-cell-name="props">
                        <q-td :props="props">
                            <div class="row items-center">
                                <q-avatar size="28px" color="blue-1" text-color="primary" class="q-mr-sm">
                                    {{ props.row.name.charAt(0) }}
                                </q-avatar>
                                <span class="text-weight-medium">{{ props.row.name }}</span>
                            </div>
                        </q-td>
                    </template>
                </q-table>
            </q-card>
        </div>
    </div>
  </q-page>
</template>

<script setup>
import { ref, onMounted, computed, watch } from 'vue'
import { useQuasar } from 'quasar'
import { supabase } from 'src/supabase'

const $q = useQuasar()
const loading = ref(false)
const selectedClass = ref(null)
const selectedDate = ref(new Date().toISOString().split('T')[0])
const classOptions = ref([])
const students = ref([])
const allClasses = ref([])

const columns = [
  { name: 'student_id', align: 'left', label: 'ID', field: 'student_id', sortable: true },
  { name: 'name', align: 'left', label: 'Student Name', field: 'name', sortable: true },
  { name: 'status', align: 'center', label: 'Attendance Status', field: 'id' }
]

const selectedClassGrade = computed(() => {
    const cls = allClasses.value.find(c => c.id === selectedClass.value)
    return cls ? cls.grade : ''
})

onMounted(() => {
    loadClasses()
})

const loadClasses = async () => {
    const { data, error } = await supabase
        .from('classes')
        .select('*')
        .eq('status', 'Active')
        .order('class_name')
    
    if (data) {
        allClasses.value = data
        classOptions.value = data.map(c => ({
            label: `${c.class_name} (${c.grade})`,
            value: c.id
        }))
    }
}

const fetchAttendanceData = async () => {
    if (!selectedClass.value || !selectedDate.value) return

    loading.value = true
    
    // 1. Fetch students in the grade of the selected class
    const { data: studentData, error: studentError } = await supabase
        .from('students')
        .select('*')
        .eq('grade', selectedClassGrade.value)
        .eq('status', 'Active')
        .order('name')

    if (studentError) {
        $q.notify({ type: 'negative', message: 'Failed to load students' })
        loading.value = false
        return
    }

    // 2. Fetch existing attendance for this class and date
    const { data: existingAttendance, error: attError } = await supabase
        .from('attendance')
        .select('*')
        .eq('class_id', selectedClass.value)
        .eq('date', selectedDate.value)

    // 3. Merge data
    students.value = studentData.map(s => {
        const marked = existingAttendance?.find(a => a.student_id === s.id)
        return {
            ...s,
            attendanceStatus: marked ? marked.status : 'Present' // Default to Present
        }
    })

    loading.value = false
}

const saveAttendance = async () => {
    if (!selectedClass.value || !selectedDate.value) {
        $q.notify({ type: 'warning', message: 'Please select class and date' })
        return
    }

    loading.value = true
    
    const attendanceRecords = students.value.map(s => ({
        student_id: s.id,
        class_id: selectedClass.value,
        date: selectedDate.value,
        status: s.attendanceStatus
    }))

    // Use upsert to handle updates/inserts (requires unique constraint on student_id, class_id, date)
    const { error } = await supabase
        .from('attendance')
        .upsert(attendanceRecords, { onConflict: 'student_id,class_id,date' })

    loading.value = false

    if (error) {
        console.error('Save error:', error)
        $q.notify({ type: 'negative', message: `Save failed: ${error.message}` })
    } else {
        $q.notify({ type: 'positive', message: 'Attendance records saved successfully' })
    }
}
</script>

<style scoped lang="scss">
.glass-modern {
    background: white;
    border-radius: 20px;
    border: 1px solid rgba(0,0,0,0.05);
    box-shadow: 0 4px 20px -5px rgba(0,0,0,0.05);
}

.premium-btn {
    border-radius: 12px;
    font-weight: 700;
}

.attendance-toggle {
    border-radius: 10px;
    overflow: hidden;
    width: 200px;
}

.empty-container {
    min-height: 300px;
    background: rgba(255,255,255,0.5);
    border-radius: 30px;
    border: 2px dashed rgba(0,0,0,0.05);
}

.border-dashed {
    border: 1px dashed rgba(0,0,0,0.1);
}
</style>
