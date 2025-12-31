<template>
  <q-layout view="lHh Lpr lFf" class="bg-grey-1">
    <!-- Top Bar -->
    <q-header class="bg-white text-grey-9 shadow-1" height-hint="64">
      <q-toolbar class="q-px-lg" style="height: 64px;">
        <q-btn flat dense round icon="menu" aria-label="Menu" @click="toggleLeftDrawer" />
        
        <q-toolbar-title class="text-weight-bold text-h6 flex items-center">
            <q-icon name="school" color="primary" size="28px" class="q-mr-sm" />
            <span class="text-primary">ClassMaster</span>
            <span class="text-caption q-ml-sm text-grey-6 gt-xs">Admin Console</span>
        </q-toolbar-title>

        <q-space />

        <!-- Top Right Actions -->
        <div class="row q-gutter-sm items-center">
            <q-input dense outlined v-model="search" placeholder="Search students..." class="gt-sm q-mr-md search-input" bg-color="grey-1" borderless @keyup.enter="handleSearch">
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
                    <div class="text-weight-bold text-body2">Admin User</div>
                    <div class="text-caption text-grey-6" style="line-height:1;">Super Admin</div>
                </div>
                <q-menu auto-close class="rounded-borders shadow-3">
                    <q-list style="min-width: 220px">
                        <div class="q-px-md q-py-sm bg-grey-2 q-mb-xs">
                             <div class="text-weight-bold text-grey-9">Admin User</div>
                             <div class="text-caption text-grey-7">admin@classmaster.com</div>
                        </div>

                        <q-item clickable v-ripple @click="handleProfile">
                            <q-item-section avatar style="min-width: 32px;">
                                <q-icon name="person_outline" size="20px" color="grey-7" />
                            </q-item-section>
                            <q-item-section class="text-grey-8">My Profile</q-item-section>
                        </q-item>

                        <q-item clickable v-ripple @click="handleSettings">
                            <q-item-section avatar style="min-width: 32px;">
                                <q-icon name="settings" size="20px" color="grey-7" />
                            </q-item-section>
                            <q-item-section class="text-grey-8">Settings</q-item-section>
                        </q-item>
                        
                        <q-item clickable v-ripple @click="handleHelp">
                            <q-item-section avatar style="min-width: 32px;">
                                <q-icon name="help_outline" size="20px" color="grey-7" />
                            </q-item-section>
                            <q-item-section class="text-grey-8">Help & Support</q-item-section>
                        </q-item>

                        <q-separator class="q-my-xs" />
                        
                        <q-item clickable v-ripple @click="handleLogout" class="text-red-7">
                            <q-item-section avatar style="min-width: 32px;">
                                <q-icon name="logout" size="20px" />
                            </q-item-section>
                            <q-item-section>Logout</q-item-section>
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
                <q-item-label header class="text-uppercase text-xs text-weight-bold letter-spacing-wide q-mb-sm">Main Menu</q-item-label>
                
                <q-item clickable v-ripple exact to="/dashboard" active-class="bg-blue-1 text-primary">
                    <q-item-section avatar>
                        <q-icon name="dashboard" />
                    </q-item-section>
                    <q-item-section class="text-weight-medium">Dashboard</q-item-section>
                </q-item>

                <q-item clickable v-ripple to="/dashboard/students" active-class="bg-blue-1 text-primary">
                    <q-item-section avatar>
                        <q-icon name="people" />
                    </q-item-section>
                    <q-item-section class="text-weight-medium">Students</q-item-section>
                </q-item>

                <q-item clickable v-ripple to="/dashboard/tutors" active-class="bg-blue-1 text-primary">
                    <q-item-section avatar>
                        <q-icon name="supervisor_account" />
                    </q-item-section>
                    <q-item-section class="text-weight-medium">Tutors</q-item-section>
                </q-item>

                <q-item clickable v-ripple to="/dashboard/subjects" active-class="bg-blue-1 text-primary">
                    <q-item-section avatar>
                        <q-icon name="auto_stories" />
                    </q-item-section>
                    <q-item-section class="text-weight-medium">Subjects</q-item-section>
                </q-item>

                <q-item clickable v-ripple to="/dashboard/classes" active-class="bg-blue-1 text-primary">
                    <q-item-section avatar>
                        <q-icon name="calendar_month" />
                    </q-item-section>
                    <q-item-section class="text-weight-medium">Classes</q-item-section>
                </q-item>

                <q-item clickable v-ripple to="/dashboard/attendance" active-class="bg-blue-1 text-primary">
                    <q-item-section avatar>
                        <q-icon name="how_to_reg" />
                    </q-item-section>
                    <q-item-section class="text-weight-medium">Attendance</q-item-section>
                </q-item>

                <q-item clickable v-ripple to="/dashboard/messages" active-class="bg-blue-1 text-primary">
                    <q-item-section avatar>
                        <q-icon name="send" />
                    </q-item-section>
                    <q-item-section class="text-weight-medium">Messages</q-item-section>
                </q-item>

                <q-item-label header class="text-uppercase text-xs text-weight-bold letter-spacing-wide q-mt-md q-mb-sm">Finance</q-item-label>

                <q-item clickable v-ripple to="/dashboard/fees" active-class="bg-blue-1 text-primary">
                    <q-item-section avatar>
                        <q-icon name="payments" />
                    </q-item-section>
                    <q-item-section class="text-weight-medium">Collect Fees</q-item-section>
                </q-item>

                <q-item-label header class="text-uppercase text-xs text-weight-bold letter-spacing-wide q-mt-md q-mb-sm">Administration</q-item-label>

                <q-item clickable v-ripple to="/dashboard/roles" active-class="bg-blue-1 text-primary">
                    <q-item-section avatar>
                        <q-icon name="admin_panel_settings" />
                    </q-item-section>
                    <q-item-section class="text-weight-medium">Staff & Roles</q-item-section>
                </q-item>
            </q-list>

            <q-space />
            
            <!-- Bottom Actions -->
            <!-- <div class="q-pa-md">
                <q-card flat bordered class="bg-blue-1 q-mb-md">
                    <q-card-section>
                         <div class="row items-center no-wrap">
                            <q-icon name="stars" color="primary" size="24px" class="q-mr-sm" />
                            <div class="text-subtitle2 text-primary">Pro Plan</div>
                         </div>
                         <div class="text-caption text-grey-7 q-mt-xs">Your license expires in 12 days.</div>
                         <q-btn dense flat color="primary" label="Upgrade" class="q-mt-sm full-width" />
                    </q-card-section>
                </q-card>
            </div> -->
        </div>
    </q-drawer>

    <q-page-container class="bg-grey-1">
      <router-view />
    </q-page-container>
  </q-layout>
</template>

<script setup>
import { ref } from 'vue'
import { useRouter } from 'vue-router'
import { useQuasar } from 'quasar'
import { supabase } from 'src/supabase'

const leftDrawerOpen = ref(false)
const search = ref('')
const router = useRouter()
const $q = useQuasar()

function toggleLeftDrawer () {
  leftDrawerOpen.value = !leftDrawerOpen.value
}

const handleProfile = () => {
    $q.notify({ message: 'Profile page coming soon.', icon: 'person', color: 'primary' })
}

const handleSettings = () => {
    $q.notify({ message: 'System settings coming soon.', icon: 'settings', color: 'primary' })
}

const handleHelp = () => {
    $q.notify({ message: 'Help center is under construction.', icon: 'help', color: 'green' })
}

const notificationsCount = ref(3)

const handleNotifications = () => {
    $q.notify({ 
        message: `You have ${notificationsCount.value} new updates.`, 
        icon: 'notifications', 
        color: 'primary' 
    })
}

const handleSearch = () => {
    if (search.value) {
         $q.notify({ message: `Searching for: ${search.value}`, icon: 'search', color: 'primary' })
    }
}

const handleLogout = async () => {
  await supabase.auth.signOut()
  router.push('/login')
  $q.notify({ type: 'positive', message: 'Logged out successfully' })
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
