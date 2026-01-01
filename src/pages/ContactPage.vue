<template>
  <q-page class="bg-black text-white q-py-xl">
    <div class="container-xl q-px-md">
      <div class="glass-card q-pa-xl rounded-borders">
        <h1 class="text-h3 text-weight-bolder q-mb-xl text-gradient">Contact Us</h1>
        
        <div class="row q-col-gutter-xl">
          <div class="col-12 col-md-6">
            <h2 class="text-h5 text-white text-weight-bold q-mb-md">Get in Touch</h2>
            <p class="text-grey-4">Have questions about ClassMaster? Our team is here to help you modernize your institute.</p>
            
            <q-list class="q-mt-lg">
              <q-item class="q-px-none">
                <q-item-section avatar>
                  <q-icon name="mail" color="white" />
                </q-item-section>
                <q-item-section class="text-white">sejanrandinu01@gmail.com</q-item-section>
              </q-item>
              <q-item class="q-px-none">
                <q-item-section avatar>
                  <q-icon name="phone" color="white" />
                </q-item-section>
                <q-item-section class="text-white">0702838364</q-item-section>
              </q-item>
            </q-list>
          </div>
          
          <div class="col-12 col-md-6">
            <q-form @submit.prevent="onSubmit" class="q-gutter-md">
              <q-input dark outlined v-model="form.name" label="Your Name" :rules="[val => !!val || 'Field is required']" />
              <q-input dark outlined v-model="form.email" label="Your Email" type="email" :rules="[val => !!val || 'Field is required']" />
              <q-input dark outlined v-model="form.message" label="Message" type="textarea" :rules="[val => !!val || 'Field is required']" />
              <q-btn 
                type="submit"
                color="white" 
                text-color="black" 
                label="Send Message" 
                class="full-width q-py-md text-weight-bold" 
                rounded 
                unelevated 
                no-caps 
                :loading="loading"
              />
            </q-form>
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
import { ref } from 'vue'
import emailjs from '@emailjs/browser'
import { useQuasar } from 'quasar'

const $q = useQuasar()
const loading = ref(false)
const form = ref({
  name: '',
  email: '',
  message: ''
})

const onSubmit = async () => {
  if (!form.value.name || !form.value.email || !form.value.message) {
    $q.notify({
      type: 'negative',
      message: 'Please fill in all fields'
    })
    return
  }

  loading.value = true
  
  try {
    // Note: You will need to replace these with your actual EmailJS credentials
    // Service ID, Template ID, and Public Key
    await emailjs.send(
      'service_h3exkwm', // Replace with your Service ID
      'template_wpax8ym', // Replace with your Template ID
      {
        from_name: form.value.name,
        from_email: form.value.email,
        message: form.value.message,
        to_email: 'sejanrandinu01@gmail.com'
      },
      'W9PbvigHgxkCQCvET' // Replace with your Public Key
    )

    $q.notify({
      type: 'positive',
      message: 'Message sent successfully! We will get back to you soon.'
    })
    
    // Clear form
    form.value = {
      name: '',
      email: '',
      message: ''
    }
  } catch (error) {
    console.error('EmailJS Error:', error)
    $q.notify({
      type: 'negative',
      message: 'Failed to send message. Please try again later.'
    })
  } finally {
    loading.value = false
  }
}
</script>

<style scoped lang="scss">
.glass-card {
  padding: 60px;
  @media (max-width: 600px) {
    padding: 30px;
  }
}
</style>
