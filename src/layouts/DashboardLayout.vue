<template>
  <q-layout view="lHh Lpr lFf" class="bg-grey-1">
    <!-- Top Bar -->
    <q-header class="bg-white text-grey-9 shadow-1" height-hint="64">
      <q-toolbar class="q-px-lg" style="height: 64px;">
        <q-btn flat dense round icon="menu" aria-label="Menu" @click="toggleLeftDrawer" />
        
        <q-toolbar-title class="text-weight-bold text-h6 flex items-center">
            <q-avatar size="32px" class="q-mr-sm">
                <img src="/favicon.svg">
            </q-avatar>
            <span class="text-primary">ClassMaster</span>
            <span class="text-caption q-ml-sm text-grey-6 gt-xs">{{ t.adminConsole }}</span>
        </q-toolbar-title>

        <q-space />

        <!-- Top Right Actions -->
        <div class="row q-gutter-sm items-center">
            <q-input dense outlined v-model="search" :placeholder="appStore.language === 'English' ? 'Search students...' : 'සිසුන් සොයන්න...'" class="gt-sm q-mr-md search-input" bg-color="grey-1" borderless @keyup.enter="handleSearch">
                <template v-slot:prepend>
                    <q-icon name="search" color="grey-5" />
                </template>
            </q-input>

            <q-btn round flat color="grey-7" icon="notifications" @click="handleNotifications">
                <q-badge color="red" floating rounded v-if="notificationsCount > 0">{{ notificationsCount }}</q-badge>
            </q-btn>
            
            <q-separator vertical class="q-mx-sm" />
            
            <q-btn flat no-caps class="text-grey-8">
                <q-avatar size="32px" class="q-mr-sm">
                    <img src="https://cdn.quasar.dev/img/boy-avatar.png">
                </q-avatar>
                <div class="text-left gt-xs">
                    <div class="text-weight-bold text-body2">{{ userDisplayName }}</div>
                    <div class="text-caption text-grey-6" style="line-height:1;">{{ userRoleLabel }}</div>
                </div>
                <q-menu auto-close class="rounded-borders shadow-3">
                    <q-list style="min-width: 220px">
                        <div class="q-px-md q-py-sm bg-grey-2 q-mb-xs">
                             <div class="text-weight-bold text-grey-9">
                                <template v-if="loadingProfile">...</template>
                                <template v-else>{{ isApproved ? (appStore.language === 'English' ? 'Approved Member' : 'අනුමත සාමාජිකයෙක්') : 'Guest' }}</template>
                             </div>
                             <div class="text-caption text-grey-7">{{ userEmail }}</div>
                        </div>

                        <q-item clickable v-ripple @click="handleProfile">
                            <q-item-section avatar style="min-width: 32px;">
                                <q-icon name="person_outline" size="20px" color="grey-7" />
                            </q-item-section>
                            <q-item-section class="text-grey-8">{{ t.myProfile }}</q-item-section>
                        </q-item>

                        <q-item clickable v-ripple @click="handleSettings">
                            <q-item-section avatar style="min-width: 32px;">
                                <q-icon name="settings" size="20px" color="grey-7" />
                            </q-item-section>
                            <q-item-section class="text-grey-8">{{ t.settings }}</q-item-section>
                        </q-item>
                        
                        <q-item clickable v-ripple @click="handleHelp">
                            <q-item-section avatar style="min-width: 32px;">
                                <q-icon name="help_outline" size="20px" color="grey-7" />
                            </q-item-section>
                            <q-item-section class="text-grey-8">{{ t.helpSupport }}</q-item-section>
                        </q-item>

                        <q-separator class="q-my-xs" />
                        
                        <q-item clickable v-ripple @click="handleLogout" class="text-red-7">
                            <q-item-section avatar style="min-width: 32px;">
                                <q-icon name="logout" size="20px" />
                            </q-item-section>
                            <q-item-section>{{ t.logout }}</q-item-section>
                        </q-item>
                    </q-list>
                </q-menu>
            </q-btn>
        </div>
      </q-toolbar>
    </q-header>

    <!-- Sidebar -->
    <q-drawer show-if-above v-model="leftDrawerOpen" side="left" bordered class="bg-white" :width="280">
        <div class="column full-height">
            <!-- Navigation -->
            <q-list padding class="q-mt-md text-grey-8">
                <q-item-label header class="text-uppercase text-xs text-weight-bold letter-spacing-wide q-mb-sm">{{ appStore.language === 'English' ? 'Main Menu' : 'ප්‍රධාන මෙනුව' }}</q-item-label>
                
                <q-item clickable v-ripple exact to="/dashboard" active-class="bg-primary text-white">
                    <q-item-section avatar>
                        <q-icon name="dashboard" />
                    </q-item-section>
                    <q-item-section class="text-weight-medium">{{ t.dashboard }}</q-item-section>
                </q-item>

                <q-item clickable v-ripple to="/dashboard/students" active-class="bg-primary text-white">
                    <q-item-section avatar>
                        <q-icon name="people" />
                    </q-item-section>
                    <q-item-section class="text-weight-medium">{{ t.students }}</q-item-section>
                </q-item>

                <q-item clickable v-ripple to="/dashboard/tutors" active-class="bg-primary text-white">
                    <q-item-section avatar>
                        <q-icon name="supervisor_account" />
                    </q-item-section>
                    <q-item-section class="text-weight-medium">{{ t.tutors }}</q-item-section>
                </q-item>

                <q-item clickable v-ripple to="/dashboard/subjects" active-class="bg-primary text-white">
                    <q-item-section avatar>
                        <q-icon name="auto_stories" />
                    </q-item-section>
                    <q-item-section class="text-weight-medium">{{ t.subjects }}</q-item-section>
                </q-item>

                <q-item clickable v-ripple to="/dashboard/classes" active-class="bg-primary text-white">
                    <q-item-section avatar>
                        <q-icon name="calendar_month" />
                    </q-item-section>
                    <q-item-section class="text-weight-medium">{{ t.classes }}</q-item-section>
                </q-item>

                <q-item clickable v-ripple to="/dashboard/attendance" active-class="bg-primary text-white">
                    <q-item-section avatar>
                        <q-icon name="how_to_reg" />
                    </q-item-section>
                    <q-item-section class="text-weight-medium">{{ t.attendance }}</q-item-section>
                </q-item>

                <q-item clickable v-ripple to="/dashboard/attendance-history" active-class="bg-primary text-white">
                    <q-item-section avatar>
                        <q-icon name="history" />
                    </q-item-section>
                    <q-item-section class="text-weight-medium">{{ t.history }}</q-item-section>
                </q-item>

                <q-item clickable v-ripple to="/dashboard/messages" active-class="bg-primary text-white">
                    <q-item-section avatar>
                        <q-icon name="send" />
                    </q-item-section>
                    <q-item-section class="text-weight-medium">{{ t.messages }}</q-item-section>
                </q-item>

                <q-item-label header class="text-uppercase text-xs text-weight-bold letter-spacing-wide q-mt-md q-mb-sm">{{ t.finance }}</q-item-label>

                <q-item clickable v-ripple to="/dashboard/fees" active-class="bg-primary text-white">
                    <q-item-section avatar>
                        <q-icon name="payments" />
                    </q-item-section>
                    <q-item-section class="text-weight-medium">{{ t.collectFees }}</q-item-section>
                </q-item>

                <q-item clickable v-ripple to="/dashboard/scan-qr" active-class="bg-primary text-white">
                    <q-item-section avatar>
                        <q-icon name="qr_code_scanner" />
                    </q-item-section>
                    <q-item-section class="text-weight-medium">{{ t.scanQr }}</q-item-section>
                </q-item>

                <q-item-label header class="text-uppercase text-xs text-weight-bold letter-spacing-wide q-mt-md q-mb-sm">{{ t.administration }}</q-item-label>

                <q-item clickable v-ripple to="/dashboard/staff" active-class="bg-primary text-white">
                    <q-item-section avatar>
                        <q-icon name="badge" />
                    </q-item-section>
                    <q-item-section class="text-weight-medium">{{ t.staffMembers }}</q-item-section>
                </q-item>

                <q-item clickable v-ripple to="/dashboard/roles" active-class="bg-primary text-white">
                    <q-item-section avatar>
                        <q-icon name="admin_panel_settings" />
                    </q-item-section>
                    <q-item-section class="text-weight-medium">{{ t.staffRoles }}</q-item-section>
                </q-item>

                <template v-if="isSuperAdmin">
                    <q-item-label header class="text-uppercase text-xs text-weight-bold letter-spacing-wide q-mt-md q-mb-sm">{{ t.superAdmin }}</q-item-label>

                    <q-item clickable v-ripple to="/dashboard/approvals" active-class="bg-primary text-white">
                        <q-item-section avatar>
                            <q-icon name="pending_actions" />
                        </q-item-section>
                        <q-item-section class="text-weight-medium">{{ t.newApprovals }}</q-item-section>
                        <q-item-section side v-if="pendingCount > 0">
                            <q-badge color="red" rounded>{{ pendingCount }}</q-badge>
                        </q-item-section>
                    </q-item>

                    <q-item clickable v-ripple to="/dashboard/approved-users" active-class="bg-primary text-white">
                        <q-item-section avatar>
                            <q-icon name="group_add" />
                        </q-item-section>
                        <q-item-section class="text-weight-medium">{{ t.approvedMembers }}</q-item-section>
                    </q-item>
                </template>
            </q-list>

            <q-space />
        </div>
    </q-drawer>

    <q-page-container class="bg-grey-1">
      <template v-if="loadingProfile">
        <div class="flex flex-center" style="height: 80vh">
          <q-spinner-dots color="primary" size="40px" />
        </div>
      </template>
      <template v-else-if="!isApproved">
        <div class="q-pa-xl flex flex-center" style="min-height: 80vh;">
          <q-card flat bordered class="q-pa-xl rounded-borders text-center shadow-1" style="max-width: 600px; width: 100%">
            <div class="q-mb-lg flex flex-center">
              <q-img 
                src="~assets/verification_pending.png" 
                style="width: 180px; height: 180px;" 
                class="q-mb-md"
              />
            </div>
            <h2 class="text-h4 text-weight-bold q-mb-md">{{ appStore.language === 'English' ? 'Account Pending Approval' : 'ගිණුම අනුමත වීමට නියමිතයි' }}</h2>
            <p class="text-grey-7 text-h6 q-mb-xl line-height-1-6">
              {{ appStore.language === 'English' ? 'Your registration with ClassMaster is successful.' : 'ClassMaster සඳහා ඔබගේ ලියාපදිංචිය සාර්ථකයි.' }} <br>
              {{ appStore.language === 'English' ? 'We are currently reviewing your request. Your dashboard will be activated once the payment is confirmed and the account is approved by our team.' : 'අපි දැනට ඔබගේ ඉල්ලීම සමාලෝචනය කරමින් සිටිමු. මූල්‍ය කටයුතු තහවුරු කළ පසු සහ අපගේ කණ්ඩායම විසින් ගිණුම අනුමත කළ පසු ඔබගේ දර්ශක පුවරුව සක්‍රිය වනු ඇත.' }}
            </p>
            <div class="row justify-center q-gutter-md">
              <q-btn unelevated color="primary" :label="appStore.language === 'English' ? 'Contact Support' : 'සහාය සම්බන්ධ කරගන්න'" icon="chat" no-caps class="q-px-lg" @click="handleSupport" />
              <q-btn outline color="indigo" :label="appStore.language === 'English' ? 'Payment Details' : 'ගෙවීම් විස්තර'" icon="payments" no-caps class="q-px-lg" @click="showPaymentDetails" />
              <q-btn flat color="grey-7" :label="appStore.language === 'English' ? 'Logout' : 'පද්ධතියෙන් ඉවත් වන්න'" icon="logout" no-caps @click="handleLogout" />
            </div>
            <div class="q-mt-xl text-caption text-grey-6">
              WhatsApp Support: +94 70 283 8364
            </div>
          </q-card>
        </div>
      </template>
      <template v-else>
        <router-view />
      </template>
      
      <!-- Chatbot Component -->
      <ChatbotComponent />
      
      <!-- Class Reminder Logic -->
      <ClassReminder />

      <!-- WhatsApp Dialog for Google Users -->
      <q-dialog v-model="showWhatsAppDialog" persistent>
        <q-card style="min-width: 350px">
          <q-card-section>
            <div class="text-h6">Complete Your Profile</div>
            <div class="text-caption text-grey">Please provide your WhatsApp number for important updates.</div>
          </q-card-section>

          <q-card-section class="q-pt-none">
            <q-input 
                dense 
                v-model="whatsappNumber" 
                label="WhatsApp Number" 
                placeholder="e.g. 0702838364" 
                outlined 
                autofocus 
                :rules="[val => val && val.length > 0 || 'Please type your number']"
            >
                 <template v-slot:prepend>
                  <q-icon name="phone" />
                 </template>
            </q-input>
          </q-card-section>

          <q-card-actions align="right" class="text-primary">
            <q-btn flat label="Save Number" @click="saveWhatsApp" :loading="whatsappLoading" />
          </q-card-actions>
        </q-card>
      </q-dialog>

    </q-page-container>
  </q-layout>
</template>

<script setup>
import { ref, onMounted, onUnmounted, computed } from 'vue'
import { useRouter } from 'vue-router'
import { useQuasar } from 'quasar'
import { supabase } from 'src/supabase'
import { useAppStore } from 'src/store/app'
import layoutTranslations from 'src/i18n/layout'
import ChatbotComponent from 'src/components/ChatbotComponent.vue'
import ClassReminder from 'src/components/ClassReminder.vue'
import PaymentDialog from 'src/components/PaymentDialog.vue'

const appStore = useAppStore()
const t = computed(() => layoutTranslations[appStore.language])

const leftDrawerOpen = ref(false)
const search = ref('')
const router = useRouter()
const $q = useQuasar()

const showPaymentDetails = () => {
    $q.dialog({
        component: PaymentDialog
    })
}

const getStoredEmailHint = () => {
    try {
        const key = 'classmaster-v4-token'
        const stored = localStorage.getItem(key)
        console.log('Checking storage for session:', key, stored ? 'Found' : 'Not found')
        if (stored) {
            const data = JSON.parse(stored)
            const email = data?.user?.email || data?.currentSession?.user?.email || data?.session?.user?.email
            console.log('Extracted email from storage:', email)
            if (email) return email
        }
    } catch (e) {
        console.warn('Error reading email hint from storage:', e)
    }
    return ''
}

const dbApproved = ref(false)
const userEmail = ref(getStoredEmailHint()) 

// Initial loading state
const loadingProfile = ref(true)

// Immediate Super Admin Check (pre-verification)
const isSuperAdmin = computed(() => {
    const email = userEmail.value?.trim().toLowerCase()
    return email === 'sejanrandinu01@gmail.com'
})

// If it's the Super Admin hint, we can skip the dots earlier
if (isSuperAdmin.value) {
    console.log('Detected Super Admin hint, allowing early entry.')
    loadingProfile.value = false
}

const isApproved = computed(() => {
    if (isSuperAdmin.value) return true
    return dbApproved.value
})

const userName = ref('')
const pendingCount = ref(0)
const notificationsCount = computed(() => pendingCount.value)

// Dynamic User Info for Header
const userDisplayName = computed(() => {
    if (isSuperAdmin.value) return 'Sejan Randinu'
    return userName.value || (userEmail.value ? userEmail.value.split('@')[0] : 'Member')
})

const userRoleLabel = computed(() => {
    if (isSuperAdmin.value) return 'Super Admin'
    return isApproved.value ? 'Active Member' : 'Pending Member'
})

// WhatsApp Dialog State
const showWhatsAppDialog = ref(false)
const whatsappNumber = ref('')
const whatsappLoading = ref(false)

let authListener = null

onMounted(() => {
    console.log('DashboardLayout mounted. current userEmail:', userEmail.value)

    // Safety Force Quit for dots
    const globalLoadTimeout = setTimeout(() => {
        if (loadingProfile.value) {
            console.warn('Global load timeout reached. Forcing dots off.')
            loadingProfile.value = false
            if (!userEmail.value) {
                console.warn('No userEmail found after timeout, redirecting to login.')
                router.replace('/login')
            }
        }
    }, 8000)

    // 1. Check current session with a hard timeout
    console.log('Auth check: Starting getSession...')
    
    // INSTANT RECOVERY FOR SUPER ADMIN
    const hintEmail = getStoredEmailHint()?.trim().toLowerCase()
    const adminEmail = 'sejanrandinu01@gmail.com'
    
    if (hintEmail === adminEmail) {
        console.log('Super Admin detected via hint. FORCING Entry.')
        userEmail.value = adminEmail
        loadingProfile.value = false
        dbApproved.value = true
        // Refresh session in background
        supabase.auth.getSession().then(({ data: { session } }) => {
            if (session) {
                userEmail.value = session.user.email
                fetchProfile(session.user)
            }
        })
    }

    const sessionPromise = supabase.auth.getSession()
    const sessionTimeout = new Promise((_, reject) => 
        setTimeout(() => reject(new Error('getSession timed out after 5s')), 5000)
    )

    if (!isSuperAdmin.value) {
        Promise.race([sessionPromise, sessionTimeout])
            .then(({ data: { session } = {}, error } = {}) => {
                console.log('Auth check: getSession completed', { hasSession: !!session, hasError: !!error })
                
                if (session) {
                    console.log('Auth check: Session found:', session.user.email)
                    clearTimeout(globalLoadTimeout)
                    userEmail.value = session.user.email
                    fetchProfile(session.user)
                    return
                }

                console.log('Auth check: No session found.')
                clearTimeout(globalLoadTimeout)
                router.replace('/login')
            })
            .catch(err => {
                console.warn('Auth check: getSession hang/timeout handled:', err.message)
                clearTimeout(globalLoadTimeout)
                router.replace('/login')
            })
    }

    // 2. Active Listener
    const { data: { subscription } } = supabase.auth.onAuthStateChange(async (event, session) => {
        console.log('Auth state changed (Dashboard):', event, session?.user?.email)
        if (session) {
            clearTimeout(globalLoadTimeout)
            userEmail.value = session.user.email
            await fetchProfile(session.user)
        } else if (event === 'SIGNED_OUT') {
            console.log('User signed out, redirecting to login.')
            router.replace('/login')
        }
    })
    authListener = subscription
})

onUnmounted(() => {
    if (authListener) {
        console.log('Cleaning up Dashboard auth listener')
        authListener.unsubscribe()
    }
})

const fetchProfile = async (user) => {
    console.log('Fetching profile for:', user.id)
    userEmail.value = user.email

    // 1. Instant Admin Access (Bypass DB delay)
    if (isSuperAdmin.value) {
        console.log('Super Admin detected, bypassing profile fetch.')
        dbApproved.value = true
        loadingProfile.value = false
        return
    }

    loadingProfile.value = true
    
    // Safety Force Quit after 6 seconds for profile specifically
    const safetyTimer = setTimeout(() => {
        if (loadingProfile.value) {
            console.warn('Profile fetch timeout. Showing current state.')
            loadingProfile.value = false
        }
    }, 6000)

    let retries = 3

    while (retries >= 0) {
        try {
            const { data, error } = await supabase
                .from('profiles')
                .select('*')
                .eq('id', user.id)
                .single()

            if (error) {
                if (retries > 0 && (error.code === 'PGRST116' || !data)) {
                    retries--
                    await new Promise(resolve => setTimeout(resolve, 1500))
                    continue
                }
                
                if (error.code === 'PGRST116' || !data) {
                    // Create profile if missing
                    await supabase.from('profiles').upsert({
                        id: user.id,
                        email: user.email,
                        role: 'pending',
                        created_at: new Date().toISOString()
                    }, { onConflict: 'id' })
                    retries = 0 
                    continue
                }

                console.error('Profile DB Error:', error)
                dbApproved.value = false
                break
            }
            
            // Success
            dbApproved.value = data.is_approved
            userName.value = data.full_name || ''

            if (!data.whatsapp_number) {
                showWhatsAppDialog.value = true
            }
            break 

        } catch (err) {
            console.error('Fetch exception:', err)
            dbApproved.value = false
            break
        }
    }
    
    clearTimeout(safetyTimer)
    loadingProfile.value = false
}

const saveWhatsApp = async () => {
    if (!whatsappNumber.value) return

    whatsappLoading.value = true
    try {
        const { data: { user } } = await supabase.auth.getUser()
        if (!user) throw new Error('No user found')

        const { error } = await supabase
            .from('profiles')
            .update({ whatsapp_number: whatsappNumber.value })
            .eq('id', user.id)

        if (error) throw error

        $q.notify({
            type: 'positive',
            message: 'WhatsApp number saved successfully!',
            position: 'top'
        })
        showWhatsAppDialog.value = false
    } catch (error) {
        console.error('Error saving WhatsApp:', error)
        $q.notify({
            type: 'negative',
            message: 'Error saving WhatsApp number. Please try again.',
            position: 'top'
        })
    } finally {
        whatsappLoading.value = false
    }
}

const handleSupport = () => {
    window.open('https://wa.me/94702838364', '_blank')
}

function toggleLeftDrawer () {
  leftDrawerOpen.value = !leftDrawerOpen.value
}

const handleProfile = () => {
    router.push('/dashboard/profile')
}

const handleSettings = () => {
    router.push('/dashboard/settings')
}

const handleHelp = () => {
    router.push('/dashboard/help-support')
}

const handleNotifications = () => {
    $q.notify({ 
        message: appStore.language === 'English' ? `You have ${notificationsCount.value} new updates.` : `ඔබට නව යාවත්කාලීන ${notificationsCount.value} ක් ඇත.`, 
        icon: 'notifications', 
        color: 'primary' 
    })
}

const handleSearch = () => {
    if (search.value) {
         $q.notify({ message: appStore.language === 'English' ? `Searching for: ${search.value}` : `${search.value} සොයමින් සිටී...`, icon: 'search', color: 'primary' })
    }
}

const handleLogout = async () => {
  await supabase.auth.signOut()
  router.push('/login')
  $q.notify({ type: 'positive', message: appStore.language === 'English' ? 'Logged out successfully' : 'පද්ධතියෙන් සාර්ථකව ඉවත් විය' })
}
</script>

<style scoped>
.search-input {
    width: 300px; 
    border-radius: 8px;
}
.letter-spacing-wide {
    letter-spacing: 0.1em;
}
</style>
