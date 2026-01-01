<template>
  <q-page class="q-pa-lg">
    <div class="row q-col-gutter-lg">
      <div class="col-12">
        <h1 class="text-h4 text-weight-bold q-mb-lg">{{ t.title }}</h1>
      </div>

      <div class="col-12 col-md-8">
        <!-- Security Section -->
        <q-card flat bordered class="rounded-borders q-mb-lg">
          <q-card-section>
            <div class="text-h6 text-weight-bold q-mb-md">{{ t.securityTitle }}</div>
            <q-list separator>
              <q-item clickable v-ripple @click="resetPassword">
                <q-item-section avatar>
                  <q-icon name="lock" color="primary" />
                </q-item-section>
                <q-item-section>
                  <q-item-label class="text-weight-medium">{{ t.resetPassword }}</q-item-label>
                  <q-item-label caption>{{ t.resetPasswordCaption }}</q-item-label>
                </q-item-section>
                <q-item-section side>
                  <q-icon name="chevron_right" />
                </q-item-section>
              </q-item>

              <q-item>
                <q-item-section avatar>
                  <q-icon name="notifications" color="orange" />
                </q-item-section>
                <q-item-section>
                  <q-item-label class="text-weight-medium">{{ t.notifications }}</q-item-label>
                  <q-item-label caption>{{ t.notificationsCaption }}</q-item-label>
                </q-item-section>
                <q-item-section side>
                  <q-toggle v-model="settings.notifications" color="primary" />
                </q-item-section>
              </q-item>
            </q-list>
          </q-card-section>
        </q-card>

        <!-- Preferences Section -->
        <q-card flat bordered class="rounded-borders">
          <q-card-section>
            <div class="text-h6 text-weight-bold q-mb-md">{{ t.preferencesTitle }}</div>
            <q-list separator>
              <q-item>
                <q-item-section avatar>
                  <q-icon name="dark_mode" color="deep-purple" />
                </q-item-section>
                <q-item-section>
                  <q-item-label class="text-weight-medium">{{ t.darkMode }}</q-item-label>
                  <q-item-label caption>{{ t.darkModeCaption }}</q-item-label>
                </q-item-section>
                <q-item-section side>
                  <q-toggle v-model="settings.darkMode" color="deep-purple" @update:model-value="toggleDarkMode" />
                </q-item-section>
              </q-item>

              <q-item>
                <q-item-section avatar>
                  <q-icon name="translate" color="blue" />
                </q-item-section>
                <q-item-section>
                  <q-item-label class="text-weight-medium">{{ t.language }}</q-item-label>
                  <q-item-label caption>{{ t.languageCaption }}</q-item-label>
                </q-item-section>
                <q-item-section side>
                  <q-select 
                    v-model="settings.language" 
                    :options="['English', 'Sinhala']" 
                    borderless 
                    dense 
                    class="q-px-sm"
                  />
                </q-item-section>
              </q-item>
            </q-list>
          </q-card-section>
        </q-card>
      </div>
    </div>
  </q-page>
</template>

<script setup>
import { reactive, computed } from 'vue'
import { useQuasar } from 'quasar'
import { supabase } from 'src/supabase'

const $q = useQuasar()

const settings = reactive({
  notifications: true,
  darkMode: $q.dark.isActive,
  language: 'English'
})

// Translation Dictionary
const translations = {
  English: {
    title: 'Settings',
    securityTitle: 'Security & Access',
    resetPassword: 'Reset Password',
    resetPasswordCaption: 'Send a password reset email to your inbox',
    notifications: 'System Notifications',
    notificationsCaption: 'Receive alerts about class attendance and fees',
    preferencesTitle: 'App Preferences',
    darkMode: 'Dark Mode',
    darkModeCaption: 'Switch between light and dark themes',
    language: 'Language',
    languageCaption: 'Choose your preferred language',
    resetLinkSent: 'Password reset link sent to '
  },
  Sinhala: {
    title: 'සැකසුම් (Settings)',
    securityTitle: 'ආරක්ෂාව සහ පිවිසුම',
    resetPassword: 'මුරපදය නැවත සකසන්න',
    resetPasswordCaption: 'මුරපදය අලුත් කිරීමට ඊමේල් පණිවිඩයක් එවන්න',
    notifications: 'පද්ධති නිවේදන',
    notificationsCaption: 'පැමිණීම සහ ගාස්තු පිළිබඳ දැනුම්දීම් ලබා ගන්න',
    preferencesTitle: 'පද්ධති මනාපයන්',
    darkMode: 'රාත්‍රී ප්‍රකාරය (Dark Mode)',
    darkModeCaption: 'ආලෝකය හෝ අඳුරු තේමාවන් අතර මාරු වන්න',
    language: 'භාෂාව',
    languageCaption: 'ඔබ කැමති භාෂාව තෝරන්න',
    resetLinkSent: 'මුරපදය නැවත සැකසීමේ පණිවිඩය යවන ලදී: '
  }
}

const t = computed(() => translations[settings.language])

const toggleDarkMode = (val) => {
  $q.dark.set(val)
}

const resetPassword = async () => {
  const { data: { user } } = await supabase.auth.getUser()
  if (!user) return

  $q.loading.show()
  
  const { error } = await supabase.auth.resetPasswordForEmail(user.email, {
    redirectTo: window.location.origin + '/login'
  })

  $q.loading.hide()

  if (error) {
    $q.notify({ type: 'negative', message: error.message })
  } else {
    $q.notify({ 
      type: 'positive', 
      message: t.value.resetLinkSent + user.email,
      timeout: 5000
    })
  }
}
</script>
