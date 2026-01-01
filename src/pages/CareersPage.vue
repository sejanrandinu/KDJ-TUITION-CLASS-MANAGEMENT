<template>
  <q-page class="bg-black text-white q-py-xl">
    <div class="container-xl q-px-md">
      <div class="glass-card q-pa-xl rounded-borders">
        <h1 class="text-h3 text-weight-bolder q-mb-xl text-gradient">Careers</h1>
        
        <div class="text-grey-4 q-gutter-y-lg">
          <section>
            <h2 class="text-h5 text-white text-weight-bold q-mb-md">Join the Revolution</h2>
            <p>We are always looking for talented individuals to join our team. If you're passionate about tech and education, we'd love to hear from you.</p>
          </section>

          <section>
            <h2 class="text-h5 text-white text-weight-bold q-mb-md">Open Roles</h2>
            <div class="column q-gutter-y-md">
              <div v-for="job in jobs" :key="job.title" class="q-pa-lg rounded-borders" style="background: rgba(255,255,255,0.05); border: 1px solid rgba(255,255,255,0.1);">
                <div class="row items-center justify-between">
                  <div>
                    <div class="text-h6 text-white text-weight-bold">{{ job.title }}</div>
                    <div class="text-caption text-grey-6">{{ job.location }} • {{ job.type }}</div>
                  </div>
                  <q-btn flat color="white" label="Apply Now" no-caps />
                </div>
              </div>
            </div>
          </section>
        </div>

        <div class="q-mt-xl">
          <q-btn flat color="white" label="Back to Home" to="/" icon="arrow_back" no-caps />
        </div>
      </div>
    </div>
  </q-page>
</template>

<script setup>
const jobs = [
  { title: 'Full Stack Engineer', location: 'Remote', type: 'Full-time' },
  { title: 'UI/UX Designer', location: 'Colombo', type: 'Full-time' },
  { title: 'Customer Success Manager', location: 'Colombo', type: 'Full-time' }
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
