<template>
  <q-layout view="hHh lpR fff">
    <q-header class="bg-transparent text-white q-py-sm sticky" height-hint="98">
      <q-toolbar class="container-xl q-px-md glass-header rounded-borders q-mt-md">
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
          <q-btn flat rounded label="Features" href="#features" class="text-white text-weight-medium" no-caps />
          <q-btn flat rounded label="Testimonials" href="#testimonials" class="text-white text-weight-medium" no-caps />
          <q-btn flat rounded label="Login" class="text-white text-weight-medium" no-caps />
          <q-btn rounded color="white" text-color="black" label="Get Started" class="q-ml-md text-weight-bold q-px-lg" no-caps />
        </div>
        
        <q-btn flat round icon="menu" class="lt-md" />
      </q-toolbar>
    </q-header>

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
              <a href="#" class="text-grey-5 hover-white">Features</a>
              <a href="#" class="text-grey-5 hover-white">Mobile Agent</a>
            </div>
          </div>
          <div class="col-xs-6 col-md-2">
            <div class="text-subtitle1 text-weight-bold q-mb-md">Company</div>
            <div class="column q-gutter-sm">
              <a href="#" class="text-grey-5 hover-white">About Us</a>
              <a href="#" class="text-grey-5 hover-white">Contact</a>
              <a href="#" class="text-grey-5 hover-white">Careers</a>
            </div>
          </div>
          <div class="col-xs-12 col-md-4">
             <div class="text-subtitle1 text-weight-bold q-mb-md">Stay Updated</div>
             <p class="text-grey-6 text-caption q-mb-md">Receive the latest updates on education tech.</p>
             <q-input dark outlined dense v-model="email" placeholder="Enter your email" class="q-mb-sm custom-input">
                <template v-slot:append>
                  <q-btn flat round color="white" icon="arrow_forward" size="sm" />
                </template>
             </q-input>
             <div class="row q-gutter-sm q-mt-md">
                <q-btn flat round icon="facebook" color="grey-7" size="sm" class="hover-white" />
                <q-btn flat round icon="fa-brands fa-twitter" color="grey-7" size="sm" class="hover-white" />
                <q-btn flat round icon="fa-brands fa-instagram" color="grey-7" size="sm" class="hover-white" />
                <q-btn flat round icon="fa-brands fa-linkedin" color="grey-7" size="sm" class="hover-white" />
             </div>
          </div>
        </div>
        <div class="q-mt-xl pt-lg border-top border-dark row justify-between items-center text-grey-7 text-caption">
          <div>Powered by SER Tech &copy; Copyright 2026</div>
          <div class="row q-gutter-md">
            <span class="hover-white cursor-pointer">Privacy Policy</span>
            <span class="hover-white cursor-pointer">Terms of Service</span>
          </div>
        </div>
      </div>
    </q-footer>
  </q-layout>
</template>

<script setup>
import { ref } from 'vue'
const email = ref('')
</script>

<style lang="scss" scoped>
.glass-header {
  background: rgba(0, 0, 0, 0.6);
  backdrop-filter: blur(20px);
  -webkit-backdrop-filter: blur(20px);
  border: 1px solid rgba(255, 255, 255, 0.08);
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

