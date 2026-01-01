<template>
  <q-page class="q-pa-lg bg-grey-1">
    <div class="row q-col-gutter-lg justify-center">
      <div class="col-12 text-center">
        <h1 class="text-h3 text-weight-bold text-grey-9 q-mb-md">Help & Support</h1>
        <p class="text-subtitle1 text-grey-7 q-mb-xl">We're here to help you get the most out of KDJ Tuition Manager</p>
      </div>

      <!-- Support Cards -->
      <div class="col-12 col-md-4">
        <q-card flat bordered class="rounded-borders hover-card bg-white text-center q-pa-xl">
          <q-icon name="live_help" size="64px" color="primary" class="q-mb-md" />
          <div class="text-h6 text-weight-bold q-mb-sm">Common FAQs</div>
          <div class="text-body2 text-grey-7 q-mb-lg">Quick answers to common questions about marking attendance, fees, and QR codes.</div>
          <q-btn flat color="primary" label="Read FAQs" no-caps class="text-weight-bold" />
        </q-card>
      </div>

      <div class="col-12 col-md-4">
        <q-card flat bordered class="rounded-borders hover-card bg-white text-center q-pa-xl">
          <q-icon name="fa-brands fa-whatsapp" size="64px" color="green-7" class="q-mb-md" />
          <div class="text-h6 text-weight-bold q-mb-sm">WhatsApp Support</div>
          <div class="text-body2 text-grey-7 q-mb-lg">Need urgent help? Chat directly with our technical support team via WhatsApp.</div>
          <q-btn flat color="green-7" label="Chat Now" no-caps class="text-weight-bold" @click="chatOnWhatsapp" />
        </q-card>
      </div>

      <div class="col-12 col-md-4">
        <q-card flat bordered class="rounded-borders hover-card bg-white text-center q-pa-xl">
          <q-icon name="email" size="64px" color="orange" class="q-mb-md" />
          <div class="text-h6 text-weight-bold q-mb-sm">Email Inquiry</div>
          <div class="text-body2 text-grey-7 q-mb-lg">For billing inquiries or partnership requests, send us an email.</div>
          <q-btn flat color="orange" label="Send Email" no-caps class="text-weight-bold" @click="sendEmail" />
        </q-card>
      </div>

      <!-- FAQ Accordion -->
      <div class="col-12 col-md-10 q-mt-xl">
        <div class="text-h5 text-weight-bold q-mb-lg">Frequently Asked Questions</div>
        <q-list bordered class="rounded-borders bg-white separator">
          <q-expansion-item
            group="faq"
            icon="qr_code_scanner"
            label="How do I scan a QR code from a photo?"
            header-class="text-weight-medium"
          >
            <q-card>
              <q-card-section class="text-grey-8">
                Go to the QR Scanner page and click the "Upload Image" button. Select the photo containing the QR code from your gallery or files. The system will automatically decode it and mark attendance.
              </q-card-section>
            </q-card>
          </q-expansion-item>

          <q-expansion-item
            group="faq"
            icon="payments"
            label="How to record bank deposits for fees?"
            header-class="text-weight-medium"
          >
            <q-card>
              <q-card-section class="text-grey-8">
                In the Fees page, select the student and class. Choose "Bank Transfer or Deposit" as the payment method. The tutor's bank details will be displayed for your reference. Complete the record by clicking "Collect Fee".
              </q-card-section>
            </q-card>
          </q-expansion-item>

          <q-expansion-item
            group="faq"
            icon="security"
            label="Is my student data secure?"
            header-class="text-weight-medium"
          >
            <q-card>
              <q-card-section class="text-grey-8">
                Yes, every account is isolated. Row Level Security (RLS) ensures that only you can access your own students, classes, and attendance records.
              </q-card-section>
            </q-card>
          </q-expansion-item>
        </q-list>
      </div>
    </div>
  </q-page>
</template>

<script setup>
const chatOnWhatsapp = () => {
  window.open('https://wa.me/94771234567', '_blank')
}

const sendEmail = () => {
  window.location.href = 'mailto:support@kdj.lk'
}
</script>

<style scoped>
.hover-card {
  transition: transform 0.3s ease, box-shadow 0.3s ease;
}
.hover-card:hover {
  transform: translateY(-5px);
  box-shadow: 0 10px 25px rgba(0,0,0,0.08) !important;
}
</style>
