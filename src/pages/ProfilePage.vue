<template>
  <q-page class="q-pa-lg bg-grey-1">
    <div class="row q-col-gutter-lg">
      <div class="col-12">
        <h1 class="text-h4 text-weight-bold text-grey-9 q-mb-lg">My Profile</h1>
      </div>

      <!-- Profile Card -->
      <div class="col-12 col-md-4">
        <q-card flat bordered class="rounded-borders bg-white">
          <q-card-section class="text-center q-pa-xl">
            <q-avatar size="120px" font-size="52px" color="primary" text-color="white" class="shadow-10 q-mb-md">
              {{ profile.email ? profile.email.charAt(0).toUpperCase() : 'U' }}
            </q-avatar>
            <div class="text-h5 text-weight-bold text-grey-9">{{ profile.email }}</div>
            <q-chip color="green-1" text-color="green-8" class="q-mt-sm text-weight-bold" icon="verified">
              {{ isApproved ? (profile.email === 'sejanrandinu01@gmail.com' ? 'Super Admin' : 'Approved Member') : 'Pending Approval' }}
            </q-chip>
          </q-card-section>
          
          <q-separator />
          
          <q-card-section>
            <div class="text-subtitle2 text-grey-6 q-mb-xs">Member Since</div>
            <div class="text-body1 text-weight-medium">{{ formatDate(profile.created_at) }}</div>
          </q-card-section>
        </q-card>
      </div>

      <!-- Edit Profile Form -->
      <div class="col-12 col-md-8">
        <q-card flat bordered class="rounded-borders bg-white">
          <q-card-section>
            <div class="text-h6 text-weight-bold q-mb-md">Profile Details</div>
            <q-form @submit="updateProfile" class="q-gutter-md">
              <div class="row q-col-gutter-md">
                <div class="col-12 col-sm-6">
                  <q-input 
                    outlined 
                    v-model="profile.email" 
                    label="Email Address" 
                    readonly 
                    bg-color="grey-1"
                  >
                    <template v-slot:prepend><q-icon name="email" color="grey-7" /></template>
                  </q-input>
                </div>
                <div class="col-12 col-sm-6">
                  <q-input 
                    outlined 
                    v-model="profile.whatsapp_number" 
                    label="WhatsApp Number" 
                    mask="##########"
                    hint="Format: 0771234567"
                    :rules="[val => !val || val.replace(/\D/g, '').length === 10 || 'අංක 10ක් ඇතුළත් කරන්න']"
                  >
                    <template v-slot:prepend><q-icon name="fa-brands fa-whatsapp" color="green-7" /></template>
                  </q-input>
                </div>
              </div>

              <!-- Bank Details Section (Super Admin Only) -->
              <div v-if="profile.email === 'sejanrandinu01@gmail.com'" class="q-mt-lg">
                <div class="text-subtitle1 text-weight-bold text-grey-9 q-mb-md">Bank Details (Private)</div>
                <div class="row q-col-gutter-md">
                  <div class="col-12">
                    <q-input 
                      outlined 
                      v-model="profile.bank_name" 
                      label="Bank Name" 
                    >
                      <template v-slot:prepend><q-icon name="account_balance" color="primary" /></template>
                    </q-input>
                  </div>
                  <div class="col-12 col-sm-6">
                    <q-input 
                      outlined 
                      v-model="profile.account_number" 
                      label="Account Number" 
                    >
                      <template v-slot:prepend><q-icon name="credit_card" color="primary" /></template>
                    </q-input>
                  </div>
                  <div class="col-12 col-sm-6">
                    <q-input 
                      outlined 
                      v-model="profile.account_holder_name" 
                      label="Account Holder Name" 
                    >
                      <template v-slot:prepend><q-icon name="person" color="primary" /></template>
                    </q-input>
                  </div>
                </div>
              </div>

              <div class="row justify-end q-mt-md">
                <q-btn 
                  label="Update Profile" 
                  type="submit" 
                  color="primary" 
                  unelevated 
                  class="q-px-xl"
                  :loading="loading"
                />
              </div>
            </q-form>
          </q-card-section>
        </q-card>
      </div>
    </div>
  </q-page>
</template>

<script setup>
import { ref, onMounted, computed } from 'vue'
import { useQuasar } from 'quasar'
import { supabase } from 'src/supabase'

const $q = useQuasar()
const loading = ref(false)
const profile = ref({
  email: '',
  whatsapp_number: '',
  bank_name: '',
  account_number: '',
  account_holder_name: '',
  is_approved: false,
  created_at: ''
})

const isApproved = computed(() => {
  if (profile.value.email?.trim().toLowerCase() === 'sejanrandinu01@gmail.com') return true
  return profile.value.is_approved
})

onMounted(async () => {
  // Pre-fill email from session if possible for faster UI response
  const { data: { user } } = await supabase.auth.getUser()
  if (user) {
    profile.value.email = user.email
    if (user.email === 'sejanrandinu01@gmail.com') {
      profile.value.is_approved = true
    }
  }
  fetchProfile()
})

const fetchProfile = async () => {
  try {
    const { data: { user } } = await supabase.auth.getUser()
    if (!user) {
        console.warn('No user found in ProfilePage')
        return
    }

    // 1. Initial State from Auth
    const currentEmail = user.email
    const isSuper = currentEmail === 'sejanrandinu01@gmail.com'

    profile.value.email = currentEmail
    if (isSuper) {
        profile.value.is_approved = true
    }
    
    // 2. DB Fetch
    const { data, error } = await supabase
      .from('profiles')
      .select('*')
      .eq('id', user.id)
      .single()
    
    if (!error && data) {
       // Merge, but prefer Auth email if DB is empty
       profile.value = {
           ...data,
           email: data.email || currentEmail,
           is_approved: isSuper ? true : data.is_approved // Force super admin
       }
       
       // If DB email was missing, fix it now
       if (!data.email || data.email !== currentEmail) {
           console.log('Syncing email to DB profile...')
           supabase.from('profiles').update({ email: currentEmail }).eq('id', user.id).then(() => {})
       }

    } else {
      console.warn('Profile fetch failed or empty, keeping basic auth info.', error)
      // If no profile exists, create one? DashboardLayout does this, but maybe we missed it.
    }
  } catch (e) {
    console.error('Exception in fetchProfile:', e)
  }
}

const updateProfile = async () => {
  loading.value = true
  const { data: { user } } = await supabase.auth.getUser()
  
  const { error } = await supabase
    .from('profiles')
    .update({
      whatsapp_number: profile.value.whatsapp_number,
      bank_name: profile.value.bank_name,
      account_number: profile.value.account_number,
      account_holder_name: profile.value.account_holder_name,
      updated_at: new Date()
    })
    .eq('id', user.id)

  loading.value = false
  
  if (error) {
    $q.notify({ type: 'negative', message: 'Update failed: ' + error.message })
  } else {
    $q.notify({ type: 'positive', message: 'Profile updated successfully' })
  }
}

const formatDate = (dateStr) => {
  if (!dateStr) return 'N/A'
  return new Date(dateStr).toLocaleDateString('en-US', {
    year: 'numeric',
    month: 'long',
    day: 'numeric'
  })
}
</script>
