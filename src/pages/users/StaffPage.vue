<template>
  <q-page class="q-pa-md">
    <div class="row items-center justify-between q-mb-lg">
      <h1 class="text-h4 text-weight-bold text-grey-9 q-mb-none">Staff Management</h1>
      <q-btn color="primary" icon="person_add" label="Add Staff" unelevated no-caps @click="openAddDialog" />
    </div>

    <!-- Empty State -->
    <div v-if="rows.length === 0" class="flex flex-center bg-white rounded-borders q-pa-xl border-grey">
        <div class="text-center">
            <q-icon name="group_off" size="64px" color="grey-4" />
            <div class="text-h6 text-grey-6 q-mt-md">No staff members found</div>
            <p class="text-grey-5">Get started by adding a new staff member.</p>
            <q-btn color="primary" label="Add Staff" unelevated no-caps class="q-mt-sm" @click="openAddDialog" />
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
          <q-input borderless dense debounce="300" v-model="filter" placeholder="Search Staff">
            <template v-slot:append>
              <q-icon name="search" />
            </template>
          </q-input>
        </template>

        <template v-slot:body-cell-role="props">
            <q-td :props="props">
                <q-chip dense :color="getRoleColor(props.value)" text-color="white" size="sm">
                    {{ props.value }}
                </q-chip>
            </q-td>
        </template>

        <template v-slot:body-cell-salary="props">
             <q-td :props="props">
                Rs. {{ props.value }}
            </q-td>
        </template>
        
        <template v-slot:body-cell-actions="props">
            <q-td :props="props" auto-width>
                <q-btn flat round dense color="green-7" icon="payments" @click="openPayDialog(props.row)" class="q-mr-sm">
                    <q-tooltip>Pay Salary</q-tooltip>
                </q-btn>
                <q-btn flat round dense color="blue-7" icon="edit" @click="openEditDialog(props.row)" class="q-mr-sm">
                     <q-tooltip>Edit</q-tooltip>
                </q-btn>
                <q-btn flat round dense color="red-7" icon="delete" @click="deleteStaff(props.row.id)">
                     <q-tooltip>Remove</q-tooltip>
                </q-btn>
            </q-td>
        </template>
      </q-table>
    </q-card>

    <!-- Add/Edit Dialog -->
    <q-dialog v-model="showDialog">
        <q-card style="min-width: 400px">
            <q-card-section class="row items-center q-pb-none">
                <div class="text-h6">{{ isEdit ? 'Edit Staff' : 'Add New Staff' }}</div>
                <q-space />
                <q-btn icon="close" flat round dense v-close-popup />
            </q-card-section>

            <q-card-section class="q-pt-lg">
                <q-form @submit="saveStaff" class="q-gutter-md">
                    <q-input outlined v-model="form.name" label="Full Name" :rules="[val => !!val || 'Name is required']" />
                    
                    <q-select 
                        outlined 
                        v-model="form.role" 
                        :options="roleOptions" 
                        label="Role" 
                        :rules="[val => !!val || 'Role is required']"
                    />

                    <q-input outlined v-model="form.whatsapp_number" label="WhatsApp Number" mask="###-#######" hint="Format: 07x-xxxxxxx" :rules="[val => !!val || 'WhatsApp Number is required']" />
                    
                    <q-input 
                        outlined 
                        v-model="form.salary" 
                        label="Base Salary (Rs.)" 
                        type="number" 
                        prefix="Rs."
                        :rules="[val => !!val || 'Salary is required']" 
                    />
                    
                    <div class="row justify-end q-mt-lg">
                        <q-btn label="Cancel" color="grey-7" flat v-close-popup class="q-mr-sm" />
                        <q-btn :label="isEdit ? 'Update' : 'Save'" type="submit" color="primary" unelevated :loading="loading" />
                    </div>
                </q-form>
            </q-card-section>
        </q-card>
    </q-dialog>

    <!-- Pay Salary Dialog -->
    <q-dialog v-model="showPayDialog">
        <q-card style="min-width: 400px">
            <q-card-section class="bg-green-1 text-green-9">
                <div class="text-h6">Pay Salary</div>
                <div class="text-subtitle2">To: {{ payForm.staffName }}</div>
            </q-card-section>

            <q-card-section class="q-pt-lg">
                <q-form @submit="processPayment" class="q-gutter-md">
                    <q-input 
                        outlined 
                        v-model="payForm.amount" 
                        label="Amount" 
                        type="number" 
                        prefix="Rs."
                        :rules="[val => !!val || 'Amount is required']" 
                    />

                    <q-input outlined v-model="payForm.date" label="Payment Date" type="date" />

                    <q-input outlined v-model="payForm.notes" label="Notes (Optional)" type="textarea" rows="2" />

                     <div class="row justify-end q-mt-lg">
                        <q-btn label="Cancel" color="grey-7" flat v-close-popup class="q-mr-sm" />
                        <q-btn label="Pay Now" type="submit" color="green-7" unelevated :loading="loading" />
                    </div>
                </q-form>
            </q-card-section>
        </q-card>
    </q-dialog>
  </q-page>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { useQuasar } from 'quasar'
import { supabase } from 'src/supabase'

const $q = useQuasar()
const filter = ref('')
const showDialog = ref(false)
const showPayDialog = ref(false)
const isEdit = ref(false)
const loading = ref(false)

// Form Data
const form = ref({
  id: null,
  name: '',
  role: '',
  whatsapp_number: '',
  salary: ''
})

const payForm = ref({
    staffId: null,
    staffName: '',
    amount: '',
    date: new Date().toISOString().split('T')[0],
    notes: ''
})

const columns = [
  { name: 'name', align: 'left', label: 'Name', field: 'name', sortable: true },
  { name: 'role', align: 'left', label: 'Role', field: 'role', sortable: true },
  { name: 'whatsapp_number', align: 'left', label: 'WhatsApp', field: 'whatsapp_number' },
  { name: 'salary', align: 'right', label: 'Salary (Rs.)', field: 'salary', sortable: true },
  { name: 'actions', align: 'right', label: 'Actions', field: 'actions' }
]

const rows = ref([])
const roleOptions = ref([])
const rolesMap = ref({})

onMounted(() => {
    fetchStaff()
    fetchRoles()
})

const fetchRoles = async () => {
    const { data, error } = await supabase.from('roles').select('*')
    if (!error && data) {
        roleOptions.value = data.map(r => r.name)
        data.forEach(r => {
            rolesMap.value[r.name] = r.color
        })
    }
    
    // Add defaults if empty or just to ensure common options exist
    if (roleOptions.value.length === 0) {
        const defaultRoles = ['Manager', 'Clerk', 'Cleaner', 'Security', 'Other']
        roleOptions.value = defaultRoles
    }
}

const getRoleColor = (role) => {
    return rolesMap.value[role] || 'grey'
}

const fetchStaff = async () => {
    loading.value = true
    const { data, error } = await supabase.from('staff').select('*').order('created_at', { ascending: false })
    if (error) {
         console.error('Error fetching staff:', error)
         // Suggest user to run migration if table not found
         if (error.code === '42P01') { // undefined_table
            $q.notify({ 
                message: 'Staff table not found. Please run existing SETUP_STAFF.sql in your database.', 
                color: 'negative',
                icon: 'warning',
                timeout: 10000 
            })
         }
    } else {
        rows.value = data
    }
    loading.value = false
}

const openAddDialog = () => {
    isEdit.value = false
    form.value = { id: null, name: '', role: '', whatsapp_number: '', salary: '' }
    showDialog.value = true
}

const openEditDialog = (row) => {
    isEdit.value = true
    form.value = { ...row }
    showDialog.value = true
}

const saveStaff = async () => {
    loading.value = true
    const staffData = {
        name: form.value.name,
        role: form.value.role,
        whatsapp_number: form.value.whatsapp_number,
        salary: form.value.salary
    }

    let error = null
    if (isEdit.value && form.value.id) {
         const { error: err } = await supabase.from('staff').update(staffData).eq('id', form.value.id)
         error = err
    } else {
         const { error: err } = await supabase.from('staff').insert([staffData])
         error = err
    }

    loading.value = false
    if (error) {
        console.error(error)
        $q.notify({ type: 'negative', message: 'Error saving staff' })
    } else {
        $q.notify({ type: 'positive', message: 'Staff saved successfully' })
        showDialog.value = false
        fetchStaff()
    }
}

const deleteStaff = (id) => {
    $q.dialog({
        title: 'Confirm',
        message: 'Delete this staff member?',
        cancel: true,
        persistent: true
    }).onOk(async () => {
         const { error } = await supabase.from('staff').delete().eq('id', id)
         if (error) {
            $q.notify({ type: 'negative', message: 'Error deleting staff' })
         } else {
             $q.notify({ type: 'positive', message: 'Staff deleted' })
             fetchStaff()
         }
    })
}

const openPayDialog = (row) => {
    payForm.value = {
        staffId: row.id,
        staffName: row.name,
        amount: row.salary,
        date: new Date().toISOString().split('T')[0],
        notes: ''
    }
    showPayDialog.value = true
}

const processPayment = async () => {
    loading.value = true
    const { error } = await supabase.from('salary_payments').insert([{
        staff_id: payForm.value.staffId,
        amount: payForm.value.amount,
        payment_date: payForm.value.date,
        notes: payForm.value.notes
    }])
    
    loading.value = false
    if (error) {
        console.error(error)
        $q.notify({ type: 'negative', message: 'Payment failed' })
    } else {
        $q.notify({ type: 'positive', message: 'Payment recorded successfully' })
        showPayDialog.value = false
    }
}
</script>
