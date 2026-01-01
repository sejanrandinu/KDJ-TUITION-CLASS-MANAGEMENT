<template>
  <q-page class="q-pa-md">
    <div class="row items-center justify-between q-mb-lg">
      <div>
        <h1 class="text-h4 text-weight-bold text-grey-9 q-mb-xs">User Management</h1>
        <div class="text-grey-6">Manage tuition center approvals and access</div>
      </div>
      <div class="row q-gutter-md">
        <q-btn-toggle
          v-model="filter"
          flat
          toggle-color="primary"
          :options="[
            {label: 'Pending', value: 'pending'},
            {label: 'Approved', value: 'approved'},
            {label: 'All', value: 'all'}
          ]"
          @update:model-value="fetchUsers"
        />
        <q-input v-model="search" dense outlined placeholder="Search..." bg-color="white">
          <template v-slot:append>
            <q-icon name="search" />
          </template>
        </q-input>
      </div>
    </div>

    <q-card flat bordered class="rounded-borders">
      <q-table
        :rows="filteredUsers"
        :columns="columns"
        row-key="id"
        flat
        :loading="loading"
        no-data-label="No users found"
      >
        <template v-slot:body-cell-status="props">
          <q-td :props="props" class="text-center">
            <q-badge :color="props.row.is_approved ? 'green' : 'orange'" rounded>
              {{ props.row.is_approved ? 'Approved' : 'Pending' }}
            </q-badge>
          </q-td>
        </template>

        <template v-slot:body-cell-actions="props">
          <q-td :props="props" class="q-gutter-sm text-center">
            <q-btn 
              v-if="!props.row.is_approved"
              flat 
              dense 
              color="green" 
              label="Approve" 
              icon="check" 
              no-caps 
              @click="toggleStatus(props.row, true)" 
            />
            <q-btn 
              v-else
              flat 
              dense 
              color="orange-9" 
              label="Disapprove" 
              icon="block" 
              no-caps 
              @click="toggleStatus(props.row, false)" 
            />
            <q-btn 
              flat 
              dense 
              color="red" 
              label="Delete" 
              icon="delete" 
              no-caps 
              @click="confirmDelete(props.row)" 
            />
          </q-td>
        </template>
      </q-table>
    </q-card>
  </q-page>
</template>

<script setup>
import { ref, onMounted, computed } from 'vue'
import { supabase } from 'src/supabase'
import { useQuasar } from 'quasar'

const $q = useQuasar()
const loading = ref(false)
const allUsers = ref([])
const filter = ref('pending')
const search = ref('')

const columns = [
  { name: 'email', label: 'Email', field: 'email', align: 'left', sortable: true },
  { name: 'whatsapp', label: 'WhatsApp', field: 'whatsapp_number', align: 'left' },
  { name: 'status', label: 'Status', field: 'is_approved', align: 'center' },
  { name: 'actions', label: 'Actions', field: 'actions', align: 'center' }
]

const filteredUsers = computed(() => {
  let list = allUsers.value
  
  if (filter.value === 'pending') {
    list = list.filter(u => !u.is_approved)
  } else if (filter.value === 'approved') {
    list = list.filter(u => u.is_approved)
  }

  if (search.value) {
    const s = search.value.toLowerCase()
    list = list.filter(u => 
      u.email?.toLowerCase().includes(s) || 
      u.whatsapp_number?.includes(s)
    )
  }

  return list
})

const fetchUsers = async () => {
  loading.value = true
  try {
    const { data: profiles, error: profileError } = await supabase
      .from('profiles')
      .select('*')
      .order('created_at', { ascending: false })

    if (profileError) throw profileError
    allUsers.value = profiles
  } catch (error) {
    $q.notify({ type: 'negative', message: 'Error fetching users: ' + error.message })
  } finally {
    loading.value = false
  }
}

const toggleStatus = async (user, status) => {
  try {
    const { error } = await supabase
      .from('profiles')
      .update({ is_approved: status })
      .eq('id', user.id)

    if (error) throw error

    $q.notify({ 
        type: 'positive', 
        message: `User ${status ? 'approved' : 'disapproved'} successfully` 
    })
    fetchUsers()
  } catch (error) {
    $q.notify({ type: 'negative', message: `Action failed: ` + error.message })
  }
}

const confirmDelete = (user) => {
  $q.dialog({
    title: 'Confirm Deletion',
    message: `Are you sure you want to delete ${user.email}? This action cannot be undone.`,
    cancel: true,
    persistent: true
  }).onOk(async () => {
    try {
      const { error } = await supabase
        .from('profiles')
        .delete()
        .eq('id', user.id)

      if (error) throw error
      
      $q.notify({ type: 'positive', message: 'User deleted' })
      fetchUsers()
    } catch (error) {
      $q.notify({ type: 'negative', message: 'Delete failed: ' + error.message })
    }
  })
}

onMounted(() => {
  fetchUsers()
})
</script>
