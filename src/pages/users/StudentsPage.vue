<template>
  <q-page class="q-pa-md">
    <div class="row items-center justify-between q-mb-lg">
      <h1 class="text-h4 text-weight-bold text-grey-9 q-mb-none">Students</h1>
      <q-btn color="primary" icon="add" label="Add Student" unelevated no-caps @click="openAddDialog" />
    </div>

    <!-- Empty State -->
    <div v-if="rows.length === 0" class="flex flex-center bg-white rounded-borders q-pa-xl border-grey">
        <div class="text-center">
            <q-icon name="group_off" size="64px" color="grey-4" />
            <div class="text-h6 text-grey-6 q-mt-md">No students found</div>
            <p class="text-grey-5">Get started by adding a new student.</p>
            <q-btn color="primary" label="Add Student" unelevated no-caps class="q-mt-sm" @click="openAddDialog" />
        </div>
    </div>

    <q-card v-else flat bordered class="rounded-borders">
      <q-table
        flat
        :rows="rows"
        :columns="columns"
        row-key="id"
        :filter="filter"
      >
        <template v-slot:top-right>
          <q-input borderless dense debounce="300" v-model="filter" placeholder="Search">
            <template v-slot:append>
              <q-icon name="search" />
            </template>
          </q-input>
        </template>
        
        <template v-slot:body-cell-status="props">
          <q-td :props="props">
            <q-chip 
              size="sm" 
              :color="props.row.status === 'Active' ? 'green-1' : 'red-1'" 
              :text-color="props.row.status === 'Active' ? 'green-8' : 'red-8'"
            >
              {{ props.row.status || 'N/A' }}
            </q-chip>
          </q-td>
        </template>
        
        <template v-slot:body-cell-grade="props">
            <q-td :props="props">
                {{ props.row.grade || 'N/A' }}
            </q-td>
        </template>
        
        <template v-slot:body-cell-actions="props">
            <q-td :props="props" auto-width>
                <q-btn flat round dense color="grey-7" icon="more_vert">
                    <q-menu cover auto-close>
                        <q-list>
                            <q-item clickable class="text-primary" @click="generateQR(props.row)">
                                <q-item-section avatar>
                                    <q-icon name="qr_code_2" />
                                </q-item-section>
                                <q-item-section>Generate ID Card</q-item-section>
                            </q-item>
                            <q-item clickable @click="openEditDialog(props.row)">
                                <q-item-section avatar>
                                    <q-icon name="edit" />
                                </q-item-section>
                                <q-item-section>Edit</q-item-section>
                            </q-item>
                            <q-item clickable class="text-red" @click="deleteStudent(props.row.id)">
                                <q-item-section avatar>
                                    <q-icon name="delete" />
                                </q-item-section>
                                <q-item-section>Delete</q-item-section>
                            </q-item>
                        </q-list>
                    </q-menu>
                </q-btn>
            </q-td>
        </template>
      </q-table>
    </q-card>

    <!-- Add/Edit Dialog -->
    <q-dialog v-model="showDialog">
        <q-card style="min-width: 400px">
            <q-card-section class="row items-center q-pb-none">
                <div class="text-h6">{{ isEdit ? 'Edit Student' : 'Add New Student' }}</div>
                <q-space />
                <q-btn icon="close" flat round dense v-close-popup />
            </q-card-section>

            <q-card-section class="q-pt-lg">
                <q-form @submit="saveStudent" class="q-gutter-md">
                    <q-input outlined v-model="form.name" label="Full Name" :rules="[val => !!val || 'Name is required']" />
                    <q-input outlined v-model="form.school" label="School" hint="e.g. Royal College" />
                    <q-select outlined v-model="form.grade" :options="['Grade 6', 'Grade 7', 'Grade 8', 'Grade 9', 'Grade 10', 'Grade 11', 'Grade 12', 'Grade 13']" label="Grade" :rules="[val => !!val || 'Grade is required']" />
                    <q-input outlined v-model="form.contact" label="WhatsApp Number" mask="###-#######" hint="Format: 077-1234567" :rules="[val => !!val || 'WhatsApp number is required', val => val.length === 11 || 'Enter a valid number']" />
                    <q-select outlined v-model="form.status" :options="['Active', 'Inactive']" label="Status" :rules="[val => !!val || 'Status is required']" />
                    
                    <div class="row justify-end q-mt-lg">
                        <q-btn label="Cancel" color="grey-7" flat v-close-popup class="q-mr-sm" />
                        <q-btn :label="isEdit ? 'Update' : 'Save'" type="submit" color="primary" unelevated />
                    </div>
                </q-form>
            </q-card-section>
        </q-card>
    </q-dialog>

    <!-- QR Code Dialog -->
    <q-dialog v-model="showQRDialog">
        <q-card style="width: 350px" class="q-pa-md text-center">
            <q-card-section>
                <div class="text-h6 text-weight-bold">Student ID Card</div>
                <div class="text-grey-7">{{ qrStudent?.name }}</div>
            </q-card-section>

            <q-card-section id="qr-container" class="flex flex-center q-py-lg bg-grey-1 rounded-borders q-mx-md">
                <qrcode-vue 
                    :value="qrStudent?.student_id" 
                    :size="200" 
                    level="H" 
                    render-as="canvas"
                    id="qr-canvas"
                />
            </q-card-section>

            <q-card-section class="q-pt-none q-mt-md">
                <div class="text-caption text-grey-6">ID: {{ qrStudent?.student_id }}</div>
                <div class="text-caption text-grey-6">{{ qrStudent?.grade }} | {{ qrStudent?.school }}</div>
            </q-card-section>

            <q-card-actions align="center" class="q-pb-md">
                <q-btn flat label="Close" color="grey-7" v-close-popup />
                <q-btn color="primary" icon="download" label="Download" unelevated @click="downloadQR" />
            </q-card-actions>
        </q-card>
    </q-dialog>
  </q-page>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { useQuasar } from 'quasar'
import { supabase } from 'src/supabase'
import QrcodeVue from 'qrcode.vue'

const $q = useQuasar()
const filter = ref('')
const showDialog = ref(false)
const isEdit = ref(false)
const loading = ref(false)

// QR State
const showQRDialog = ref(false)
const qrStudent = ref(null)

// Form Data
const form = ref({
  id: null,
  student_id: '',
  name: '',
  school: '',
  grade: '',
  contact: '',
  status: 'Active'
})

const columns = [
  { name: 'student_id', align: 'left', label: 'Student ID', field: 'student_id', sortable: true },
  { name: 'name', align: 'left', label: 'Name', field: 'name', sortable: true },
  { name: 'school', align: 'left', label: 'School', field: 'school', sortable: true },
  { name: 'grade', align: 'left', label: 'Grade', field: 'grade', sortable: true },
  { name: 'contact', align: 'left', label: 'WhatsApp Number', field: 'contact' },
  { name: 'status', align: 'left', label: 'Status', field: 'status', sortable: true },
  { name: 'actions', align: 'right', label: 'Actions', field: 'actions' }
]

const rows = ref([])

onMounted(() => {
    fetchStudents()
})

const fetchStudents = async () => {
    loading.value = true
    const { data, error } = await supabase
        .from('students')
        .select('*')
        .order('created_at', { ascending: false })
    
    if (error) {
        console.error('Error fetching students:', error)
        $q.notify({ 
            type: 'negative', 
            message: `Failed to load students: ${error.message}`,
            timeout: 5000 
        })
    } else {
        rows.value = data
    }
    loading.value = false
}

// Actions
const generateQR = (student) => {
    qrStudent.value = student
    showQRDialog.value = true
}

const downloadQR = () => {
    const canvas = document.getElementById('qr-canvas')
    if (!canvas) return
    
    const link = document.createElement('a')
    link.download = `QR_${qrStudent.value.student_id}_${qrStudent.value.name}.png`
    link.href = canvas.toDataURL()
    link.click()
    
    $q.notify({
        type: 'positive',
        message: 'QR Code downloaded successfully',
        icon: 'download'
    })
}

const openAddDialog = () => {
    isEdit.value = false
    // Generate a temporary ID for display, backend should handle real unique IDs or we keep this logic
    const nextId = 'ST-2024' + Math.floor(Math.random() * 10000)
    form.value = { id: null, student_id: nextId, name: '', school: '', grade: '', contact: '', status: 'Active' }
    showDialog.value = true
}

const openEditDialog = (row) => {
    isEdit.value = true
    form.value = { ...row }
    showDialog.value = true
}

const saveStudent = async () => {
    loading.value = true
    const studentData = {
        student_id: form.value.student_id,
        name: form.value.name,
        school: form.value.school,
        grade: form.value.grade,
        contact: form.value.contact,
        status: form.value.status
    }

    let error = null

    if (isEdit.value && form.value.id) {
        // Update
        const { error: updateError } = await supabase
            .from('students')
            .update(studentData)
            .eq('id', form.value.id)
        error = updateError
    } else {
        // Insert
        const { error: insertError } = await supabase
            .from('students')
            .insert([studentData])
        error = insertError
    }

    loading.value = false

    if (error) {
        console.error('Error saving student:', error)
        $q.notify({ type: 'negative', message: 'Error saving student' })
    } else {
        $q.notify({ type: 'positive', message: isEdit.value ? 'Student updated' : 'Student added' })
        showDialog.value = false
        fetchStudents()
    }
}

const deleteStudent = (id) => {
    $q.dialog({
        title: 'Confirm',
        message: 'Are you sure you want to delete this student?',
        cancel: true,
        persistent: true
    }).onOk(async () => {
        console.log('Attempting to delete student with ID:', id)
        loading.value = true
        const { error, data } = await supabase
            .from('students')
            .delete()
            .eq('id', id)
            .select() // Select to confirm deletion
        
        console.log('Delete result:', { error, data })

        loading.value = false

        if (error) {
            console.error('Error deleting student:', error)
            $q.notify({ type: 'negative', message: `Error deleting student: ${error.message}` })
        } else {
            $q.notify({ type: 'positive', message: 'Student deleted successfully' })
            fetchStudents()
        }
    })
}
</script>
