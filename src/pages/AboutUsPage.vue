<template>
  <q-page class="bg-black text-white q-py-xl">
    <div class="container-xl q-px-md">
      <div class="glass-card q-pa-xl rounded-borders">
        <h1 class="text-h3 text-weight-bolder q-mb-xl text-gradient">About Us</h1>
        
        <div class="text-grey-4 q-gutter-y-lg">
          <section>
            <h2 class="text-h5 text-white text-weight-bold q-mb-md">Our Mission</h2>
            <p>ClassMaster is on a mission to democratize education technology. We provide high-performance management tools to tuition institutes globally, allowing educators to focus on what matters most: teaching.</p>
          </section>

          <section>
            <h2 class="text-h5 text-white text-weight-bold q-mb-md">Our Vision</h2>
            <p>To become the leading ecosystem for educational institutions, fostering a seamless connection between tutors, students, and parents through innovation and data-driven insights.</p>
          </section>

          <section>
            <h2 class="text-h5 text-white text-weight-bold q-mb-md">Who We Are</h2>
            <p>Founded by a team of passionate engineers and educators, ClassMaster was built to solve the real-world challenges faced by tuition centers. From attendance tracking to financial reporting, we automate the mundane so you can scale with ease.</p>
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
.glass-card {
  padding: 60px;
  @media (max-width: 600px) {
    padding: 30px;
  }
}

p {
  margin-bottom: 24px;
}
</style>
