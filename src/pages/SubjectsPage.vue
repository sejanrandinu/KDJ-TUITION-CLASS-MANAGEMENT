<template>
  <q-page class="q-pa-md">
    <div class="row items-center justify-between q-mb-lg">
      <h1 class="text-h4 text-weight-bold text-grey-9 q-mb-none">Subjects</h1>
      <q-btn color="primary" icon="add_box" label="Add Subject" unelevated no-caps @click="openAddDialog" />
    </div>

    <!-- Empty State -->
    <div v-if="rows.length === 0 && !loading" class="flex flex-center bg-white rounded-borders q-pa-xl border-grey">
        <div class="text-center">
            <q-icon name="auto_stories" size="64px" color="grey-4" />
            <div class="text-h6 text-grey-6 q-mt-md">No subjects found</div>
            <p class="text-grey-5">Get started by adding a new academic subject.</p>
            <q-btn color="primary" label="Add Subject" unelevated no-caps class="q-mt-sm" @click="openAddDialog" />
        </div>
    </div>

    <q-card v-else flat bordered class="rounded-borders">
      <q-table
        flat
        :rows="rows"
        :columns="columns"
        row-key="id"
        :filter="filter"
        :loading="loading"
      >
        <template v-slot:top-right>
          <q-input borderless dense debounce="300" v-model="filter" placeholder="Search subjects">
            <template v-slot:append>
              <q-icon name="search" />
            </template>
          </q-input>
        </template>
        
        <template v-slot:body-cell-code="props">
          <q-td :props="props">
            <q-badge color="blue-1" text-color="primary" class="q-pa-xs px-sm">
              {{ props.value || 'NO CODE' }}
            </q-badge>
          </q-td>
        </template>
        
        <template v-slot:body-cell-actions="props">
            <q-td :props="props" auto-width>
                <q-btn flat round dense color="grey-7" icon="more_vert">
                    <q-menu cover auto-close>
                        <q-list>
                            <q-item clickable @click="openEditDialog(props.row)">
                                <q-item-section avatar style="min-width: 32px">
                                    <q-icon name="edit" size="20px" />
                                </q-item-section>
                                <q-item-section>Edit</q-item-section>
                            </q-item>
                            <q-item clickable class="text-red" @click="deleteSubject(props.row.id)">
                                <q-item-section avatar style="min-width: 32px">
                                    <q-icon name="delete" size="20px" color="red" />
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
                <div class="text-h6">{{ isEdit ? 'Edit Subject' : 'Add New Subject' }}</div>
                <q-space />
                <q-btn icon="close" flat round dense v-close-popup />
            </q-card-section>

            <q-card-section class="q-pt-lg">
                <q-form @submit="saveSubject" class="q-gutter-md">
                    <q-input outlined v-model="form.name" label="Subject Name" :rules="[val => !!val || 'Name is required']" />
                    <q-input outlined v-model="form.code" label="Subject Code" placeholder="e.g. MATH-01" />
                    <q-input outlined v-model="form.description" label="Description" type="textarea" rows="3" />
                    
                    <div class="row justify-end q-mt-lg">
                        <q-btn label="Cancel" color="grey-7" flat v-close-popup class="q-mr-sm" />
                        <q-btn :label="isEdit ? 'Update' : 'Save'" type="submit" color="primary" unelevated :loading="loading" />
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
const isEdit = ref(false)
const loading = ref(false)

const columns = [
  { name: 'name', align: 'left', label: 'Name', field: 'name', sortable: true },
  { name: 'code', align: 'left', label: 'Code', field: 'code', sortable: true },
  { name: 'description', align: 'left', label: 'Description', field: 'description' },
  { name: 'actions', align: 'right', label: 'Actions', field: 'actions' }
]

const rows = ref([])
const form = ref({
    id: null,
    name: '',
    code: '',
    description: ''
})

onMounted(() => {
    fetchSubjects()
})

const fetchSubjects = async () => {
    loading.value = true
    const { data, error } = await supabase
        .from('subjects')
        .select('*')
        .order('name', { ascending: true })
    
    if (error) {
        console.error('Error fetching subjects:', error)
    } else {
        rows.value = data
    }
    loading.value = false
}

const openAddDialog = () => {
    isEdit.value = false
    form.value = { id: null, name: '', code: '', description: '' }
    showDialog.value = true
}

const openEditDialog = (row) => {
    isEdit.value = true
    form.value = { ...row }
    showDialog.value = true
}

const saveSubject = async () => {
    loading.value = true
    const subjectData = {
        name: form.value.name,
        code: form.value.code,
        description: form.value.description
    }

    let error = null
    if (isEdit.value && form.value.id) {
        const { error: updateError } = await supabase
            .from('subjects')
            .update(subjectData)
            .eq('id', form.value.id)
        error = updateError
    } else {
        const { error: insertError } = await supabase
            .from('subjects')
            .insert([subjectData])
        error = insertError
    }

    loading.value = false
    if (error) {
        $q.notify({ type: 'negative', message: `Error saving subject: ${error.message}` })
    } else {
        $q.notify({ type: 'positive', message: isEdit.value ? 'Subject updated' : 'Subject added' })
        showDialog.value = false
        fetchSubjects()
    }
}

const deleteSubject = (id) => {
    $q.dialog({
        title: 'Confirm',
        message: 'Are you sure you want to delete this subject?',
        cancel: true,
        persistent: true
    }).onOk(async () => {
        loading.value = true
        const { error } = await supabase
            .from('subjects')
            .delete()
            .eq('id', id)
        
        loading.value = false
        if (error) {
            $q.notify({ type: 'negative', message: 'Error deleting subject' })
        } else {
            $q.notify({ type: 'positive', message: 'Subject deleted successfully' })
            fetchSubjects()
        }
    })
}
</script>
