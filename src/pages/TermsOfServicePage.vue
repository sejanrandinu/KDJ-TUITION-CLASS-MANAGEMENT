<template>
  <q-page class="bg-black text-white q-py-xl">
    <div class="container-xl q-px-md">
      <div class="glass-card q-pa-xl rounded-borders">
        <h1 class="text-h3 text-weight-bolder q-mb-xl text-gradient">Terms of Service</h1>
        
        <div class="text-grey-4 q-gutter-y-lg">
          <section>
            <h2 class="text-h5 text-white text-weight-bold q-mb-md">1. Acceptance of Terms</h2>
            <p>By accessing or using ClassMaster, you agree to be bound by these Terms of Service and all applicable laws and regulations.</p>
          </section>

          <section>
            <h2 class="text-h5 text-white text-weight-bold q-mb-md">2. Use of License</h2>
            <p>Permission is granted to temporarily download one copy of the materials on ClassMaster's website for personal, non-commercial transitory viewing only.</p>
          </section>

          <section>
            <h2 class="text-h5 text-white text-weight-bold q-mb-md">3. Disclaimer</h2>
            <p>The materials on ClassMaster's website are provided on an 'as is' basis. ClassMaster makes no warranties, expressed or implied, and hereby disclaims and negates all other warranties including, without limitation, implied warranties or conditions of merchantability, fitness for a particular purpose, or non-infringement of intellectual property or other violation of rights.</p>
          </section>

          <section>
            <h2 class="text-h5 text-white text-weight-bold q-mb-md">4. Governing Law</h2>
            <p>These terms and conditions are governed by and construed in accordance with the laws of Sri Lanka and you irrevocably submit to the exclusive jurisdiction of the courts in that State or location.</p>
          </section>
        </div>

        <div class="q-mt-xl">
          <q-btn flat color="white" label="Back to Home" to="/" icon="arrow_back" no-caps />
        </div>
      </div>
    </div>
  </q-page>
</template>

<style scoped lang="scss">
.text-gradient {
  background: linear-gradient(135deg, #fff 0%, #888 100%);
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
}

.glass-card {
  background: rgba(255, 255, 255, 0.03);
  backdrop-filter: blur(10px);
  border: 1px solid rgba(255, 255, 255, 0.1);
}

.container-xl {
  max-width: 1200px;
  margin: 0 auto;
}

p {
  line-height: 1.8;
  font-size: 1.1rem;
}
</style>
