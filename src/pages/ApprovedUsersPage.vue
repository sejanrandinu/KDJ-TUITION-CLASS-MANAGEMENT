<template>
  <q-page class="q-pa-md">
    <div class="row items-center justify-between q-mb-lg">
      <div>
        <h1 class="text-h4 text-weight-bold text-grey-9 q-mb-xs">Approved Users</h1>
        <div class="text-grey-6">List of active tuition centers currently using the platform</div>
      </div>
      <div class="row q-gutter-md">
        <q-input v-model="search" dense outlined placeholder="Search members..." bg-color="white" style="width: 300px;">
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
        no-data-label="No approved users found"
      >
        <template v-slot:body-cell-status="props">
          <q-td :props="props" class="text-center">
            <q-badge color="green" rounded>
              Active
            </q-badge>
          </q-td>
        </template>

        <template v-slot:body-cell-actions="props">
          <q-td :props="props" class="q-gutter-sm text-center">
            <q-btn 
              flat 
              dense 
              color="orange-9" 
              label="Disapprove" 
              icon="block" 
              no-caps 
              @click="disapproveUser(props.row)" 
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
const users = ref([])
const search = ref('')

const columns = [
  { name: 'email', label: 'Email', field: 'email', align: 'left', sortable: true },
  { name: 'whatsapp', label: 'WhatsApp', field: 'whatsapp_number', align: 'left' },
  { name: 'created_at', label: 'Joined Date', field: 'created_at', align: 'left', sortable: true, format: val => new Date(val).toLocaleDateString() },
  { name: 'status', label: 'Status', field: 'is_approved', align: 'center' },
  { name: 'actions', label: 'Actions', field: 'actions', align: 'center' }
]

const filteredUsers = computed(() => {
  if (!search.value) return users.value
  const s = search.value.toLowerCase()
  return users.value.filter(u => 
    u.email?.toLowerCase().includes(s) || 
    u.whatsapp_number?.includes(s)
  )
})

const isFetching = ref(false)
const fetchApprovedUsers = async (retryCount = 3) => {
  if (isFetching.value && retryCount === 3) return
  isFetching.value = true
  loading.value = true
  
  try {
    const { data: profiles, error } = await supabase
      .from('profiles')
      .select('*')
      .eq('is_approved', true)

    if (error) throw error
    users.value = profiles || []
    
  } catch (error) {
    console.error('Fetch error:', error)
    if (retryCount > 0) {
      console.log(`Retrying... (${retryCount} left)`)
      await new Promise(r => setTimeout(r, 2000))
      // Recursively retry, but don't hang execution
      loading.value = false // temporarily stop loading indicator for clarity
      isFetching.value = false
      return fetchApprovedUsers(retryCount - 1)
    }

    $q.notify({ 
      type: 'negative', 
      message: 'Failed to load users: ' + (error.message || 'Unknown Error'),
      actions: [{ label: 'Retry', handler: () => fetchApprovedUsers() }]
    })
  } finally {
    loading.value = false
    isFetching.value = false
  }
}

const disapproveUser = async (user) => {
  try {
    const { error } = await supabase
      .from('profiles')
      .update({ is_approved: false })
      .eq('id', user.id)

    if (error) throw error

    $q.notify({ type: 'positive', message: 'User disapproved and moved to pending' })
    fetchApprovedUsers()
  } catch (error) {
    $q.notify({ type: 'negative', message: 'Action failed: ' + error.message })
  }
}

const confirmDelete = (user) => {
  $q.dialog({
    title: 'Confirm Deletion',
    message: `Warning: This will permanently delete ${user.email}. Are you sure?`,
    cancel: true,
    persistent: true,
    ok: { color: 'red', flat: true }
  }).onOk(async () => {
    try {
      const { error } = await supabase
        .from('profiles')
        .delete()
        .eq('id', user.id)

      if (error) throw error
      
      $q.notify({ type: 'positive', message: 'User deleted' })
      fetchApprovedUsers()
    } catch (error) {
      $q.notify({ type: 'negative', message: 'Delete failed: ' + error.message })
    }
  })
}

onMounted(() => {
  fetchApprovedUsers()
})
</script>
