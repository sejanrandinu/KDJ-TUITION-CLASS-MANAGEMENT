<template>
  <q-layout view="hHh lpR fff">
    <q-header reveal class="bg-transparent text-white q-py-sm sticky" height-hint="98">
      <q-toolbar class="container-xl q-px-md glass-header rounded-borders q-mt-sm-md q-mt-none" style="z-index: 2500;">
        <q-btn flat no-caps no-wrap to="/" class="q-ml-none">
          <q-avatar size="32px" color="white" text-color="black" class="q-mr-sm">
            <q-icon name="school" size="20px" />
          </q-avatar>
          <q-toolbar-title shrink class="text-weight-bolder letter-spacing-tight" style="font-size: 1.3rem;">
            ClassMaster
          </q-toolbar-title>
        </q-btn>

        <q-space />

        <div class="q-gutter-sm row items-center gt-sm">
          <q-btn flat rounded label="Home" to="/" class="text-white text-weight-medium" no-caps />
          <q-btn flat rounded label="Features" href="/#features" class="text-white text-weight-medium" no-caps />
            <q-btn flat rounded label="Testimonials" href="/#testimonials" class="text-white text-weight-medium" no-caps />
            
            <template v-if="!user">
               <q-btn flat rounded label="Login" to="/login" class="text-white text-weight-medium" no-caps />
               <q-btn rounded color="white" text-color="black" label="Get Started" to="/register" class="q-ml-md text-weight-bold q-px-lg" no-caps />
            </template>
            
            <template v-else>
               <q-btn flat rounded label="Dashboard" to="/dashboard" class="text-white text-weight-medium" no-caps />
               <q-btn flat rounded label="Logout" @click="handleLogout" class="text-white text-weight-medium" no-caps />
            </template>
          </div>
          
          <q-btn flat round icon="menu" class="lt-md" @click="drawerOpen = !drawerOpen" />
        </q-toolbar>
      </q-header>
  
      <q-drawer
        v-model="drawerOpen"
        side="right"
        overlay
        behavior="mobile"
        elevated
        class="bg-black text-white"
        style="z-index: 2000; background: #000 !important;"
      >
        <div class="column full-height q-pa-md">
          <div class="row items-center justify-between q-mb-xl">
             <div class="text-h6 text-weight-bold">Menu</div>
             <q-btn flat round icon="close" @click="drawerOpen = false" />
          </div>
  
          <div class="column q-gutter-y-md">
             <q-btn flat align="left" label="Home" to="/" class="text-white text-h6 text-weight-medium" no-caps @click="drawerOpen = false" />
             <q-btn flat align="left" label="Features" href="/#features" class="text-white text-h6 text-weight-medium" no-caps @click="drawerOpen = false" />
             <q-btn flat align="left" label="Testimonials" href="/#testimonials" class="text-white text-h6 text-weight-medium" no-caps @click="drawerOpen = false" />
             
             <template v-if="!user">
                <q-btn flat align="left" label="Login" to="/login" class="text-white text-h6 text-weight-medium" no-caps @click="drawerOpen = false" />
                <q-separator dark class="q-my-md" />
                <q-btn unelevated color="white" text-color="black" label="Get Started" to="/register" class="full-width text-weight-bold q-py-md" no-caps @click="drawerOpen = false" />
             </template>
  
             <template v-else>
                <q-btn flat align="left" label="Dashboard" to="/dashboard" class="text-white text-h6 text-weight-medium" no-caps @click="drawerOpen = false" />
                <q-separator dark class="q-my-md" />
                <q-btn outline color="red-4" label="Logout" @click="handleLogout(); drawerOpen = false" class="full-width text-weight-bold q-py-md" no-caps />
             </template>
          </div>
        </div>
      </q-drawer>

    <q-page-container>
      <router-view />
    </q-page-container>

    <q-footer class="bg-black text-white border-top border-dark q-py-xl">
      <div class="container-xl q-px-md">
        <div class="row q-col-gutter-xl">
          <div class="col-xs-12 col-md-4">
            <div class="row items-center q-mb-lg">
              <q-avatar size="32px" color="white" text-color="black" class="q-mr-sm">
                <q-icon name="school" size="20px" />
              </q-avatar>
              <div class="text-h5 text-weight-bold letter-spacing-tight">ClassMaster</div>
            </div>
            <p class="text-grey-5" style="max-width: 300px;">
              Empowering education with technology. The most comprehensive management system for tuition providers globally.
            </p>
          </div>
          <div class="col-xs-6 col-md-2">
            <div class="text-subtitle1 text-weight-bold q-mb-md">Product</div>
            <div class="column q-gutter-sm">
              <a href="/#features" class="text-grey-5 hover-white text-decoration-none">Features</a>
              <router-link to="/mobile-agent" class="text-grey-5 hover-white text-decoration-none">Mobile Agent</router-link>
            </div>
          </div>
          <div class="col-xs-6 col-md-2">
            <div class="text-subtitle1 text-weight-bold q-mb-md">Company</div>
            <div class="column q-gutter-sm">
              <router-link to="/about-us" class="text-grey-5 hover-white text-decoration-none">About Us</router-link>
              <router-link to="/contact" class="text-grey-5 hover-white text-decoration-none">Contact</router-link>
            </div>
          </div>
          <div class="col-xs-12 col-md-4">

             <div class="row q-gutter-sm q-mt-md">

                <q-btn flat round icon="fa-brands fa-twitter" color="grey-7" size="sm" class="hover-white" />
                <q-btn flat round icon="fa-brands fa-instagram" color="grey-7" size="sm" class="hover-white" />
                <q-btn flat round icon="fa-brands fa-linkedin" color="grey-7" size="sm" class="hover-white" />
             </div>
          </div>
        </div>
        <div class="q-mt-xl pt-lg border-top border-dark row justify-between items-center text-grey-7 text-caption">
          <div>Powered by SER Tech &copy; Copyright 2026</div>
          <div class="row q-gutter-md">
            <router-link to="/privacy-policy" class="hover-white cursor-pointer text-grey-7 text-decoration-none">Privacy Policy</router-link>
            <router-link to="/terms-of-service" class="hover-white cursor-pointer text-grey-7 text-decoration-none">Terms of Service</router-link>
          </div>
        </div>
      </div>
    </q-footer>
  </q-layout>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import { supabase } from 'src/supabase'
import { useQuasar } from 'quasar'

const router = useRouter()
const $q = useQuasar()

const drawerOpen = ref(false)
const user = ref(null)



const handleLogout = async () => {
    const { error } = await supabase.auth.signOut()
    if (error) {
        console.error('Logout error', error)
    } else {
        router.push('/')
        user.value = null
        $q.notify({
            type: 'positive',
            message: 'Logged out successfully'
        })
    }
}

onMounted(() => {
    // Get initial user
    supabase.auth.getUser().then(({ data }) => {
        user.value = data.user
    })

    // Listen for auth changes
    supabase.auth.onAuthStateChange((event, session) => {
        user.value = session?.user || null
    })
})
</script>

<style lang="scss" scoped>
.glass-header {
  background: rgba(0, 0, 0, 0.8);
  backdrop-filter: blur(20px);
  -webkit-backdrop-filter: blur(20px);
  border: 1px solid rgba(255, 255, 255, 0.08);
  z-index: 2500 !important;
}

.hover-white {
  transition: all 0.3s ease;
  &:hover {
    color: white !important;
  }
}

.border-top {
  border-top: 1px solid rgba(255, 255, 255, 0.08);
}

.custom-input {
  :deep(.q-field--outlined .q-field__control) {
    border-radius: 12px;
    background: rgba(255, 255, 255, 0.03);
    &:before {
      border-color: rgba(255, 255, 255, 0.1);
    }
  }
}

a {
  text-decoration: none;
  transition: color 0.3s;
  font-size: 0.9rem;
}

.letter-spacing-tight {
  letter-spacing: -0.05em;
}
</style>

