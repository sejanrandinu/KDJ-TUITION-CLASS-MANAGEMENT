<template>
  <q-page class="bg-black text-white q-py-xl">
    <div class="container-xl q-px-md">
      <div class="glass-card q-pa-xl rounded-borders">
        <h1 class="text-h3 text-weight-bolder q-mb-xl text-gradient">Mobile Agent</h1>
        
        <div class="row items-center q-col-gutter-xl">
          <div class="col-12 col-md-6">
            <h2 class="text-h4 text-white text-weight-bold q-mb-lg">The Academy in Your Pocket</h2>
            <p class="text-grey-4 text-h6 text-weight-light">Stay connected with your institute wherever you go. Our Mobile Agent app provides real-time access for tutors, students, and parents.</p>
            
            <q-list class="q-gutter-y-md q-mt-lg">
              <q-item v-for="feature in features" :key="feature" class="q-px-none">
                <q-item-section avatar>
                  <q-icon name="check_circle" color="white" />
                </q-item-section>
                <q-item-section class="text-white text-body1">{{ feature }}</q-item-section>
              </q-item>
            </q-list>

            <div class="row q-gutter-md q-mt-xl">
              <q-btn color="white" text-color="black" icon="apple" label="App Store" rounded unelevated no-caps class="q-px-lg text-weight-bold" />
              <q-btn outline color="white" icon="android" label="Play Store" rounded no-caps class="q-px-lg text-weight-bold" />
            </div>
          </div>
          
          <div class="col-12 col-md-6 text-center">
            <q-img src="~assets/mobile_app_preview_1767203165533.png" width="280px" class="rounded-borders shadow-24 hover-glow" />
          </div>
        </div>

        <div class="q-mt-xl">
          <q-btn flat color="white" label="Back to Home" to="/" icon="arrow_back" no-caps />
        </div>
      </div>
    </div>
  </q-page>
</template>

<script setup>
const features = [
  'Instant Results & Grade Tracking',
  'QR Attendance Records',
  'Digital Invoicing & Payments',
  'Tutor Communication Gateway',
  'Class Schedules & Reminders'
]
</script>

<style scoped lang="scss">
.glass-card {
  padding: 60px;
  @media (max-width: 600px) {
    padding: 30px;
  }
}
</style>
