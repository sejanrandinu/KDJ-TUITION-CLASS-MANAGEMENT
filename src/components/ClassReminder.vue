<template>
  <!-- Invisible component for background logic -->
  <div v-if="false"></div>
</template>

<script setup>
import { onMounted, onUnmounted, ref } from 'vue'
import { supabase } from 'src/supabase'
import { useQuasar } from 'quasar'

const $q = useQuasar()
const classes = ref([])
const timer = ref(null)
const lastNotified = ref({}) // Format: { classId_minutesLeft: timestamp }

const DAYS = ['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday']

const fetchTodayClasses = async () => {
  const today = DAYS[new Date().getDay()]
  const { data, error } = await supabase
    .from('classes')
    .select('*')
    .eq('day', today)
    .eq('status', 'Active')

  if (!error && data) {
    classes.value = data
  }
}

const checkReminders = () => {
  const now = new Date()
  const currentMinutes = now.getHours() * 60 + now.getMinutes()

  classes.value.forEach(cls => {
    if (!cls.start_time) return

    const [h, m] = cls.start_time.split(':').map(Number)
    const classMinutes = h * 60 + m
    const diff = classMinutes - currentMinutes

    // Check if it's within 30 mins and is exactly a 5-min interval
    const reminderIntervals = [30, 25, 20, 15, 10, 5, 0]
    
    if (reminderIntervals.includes(diff)) {
      const key = `${cls.id}_${diff}`
      const nowTs = Date.now()
      
      // Only notify once per minute for this specific interval
      if (!lastNotified.value[key] || (nowTs - lastNotified.value[key] > 61000)) {
        triggerNotification(cls, diff)
        lastNotified.value[key] = nowTs
      }
    }
  })
}

const triggerNotification = async (cls, diff) => {
  const messageText = diff === 0 
    ? `Class "${cls.class_name}" is starting NOW!` 
    : `Reminder: "${cls.class_name}" starts in ${diff} minutes.`

  const actions = [{ label: 'Dismiss', color: 'white' }]

  // Add WhatsApp action for 30 min reminder
  if (diff === 30) {
    actions.push({
      label: 'Notify Students (WA)',
      color: 'yellow',
      handler: async () => {
        const { data, error } = await supabase
          .from('students')
          .select('*')
          .eq('grade', cls.grade)
          .eq('status', 'Active')
        
        if (!error && data) {
          const targetStudents = data.filter(s => s.subjects && s.subjects.includes(cls.subject))
          if (targetStudents.length === 0) {
            $q.notify({ type: 'info', message: 'No students found for this class.' })
            return
          }

          const waMessage = `⏰ *Class Starting Soon!*\n\nClass: ${cls.class_name}\nStarts in: 30 minutes\nTutor: ${cls.tutor}\n\nGet ready! 🚀`
          
          targetStudents.forEach(std => {
            let phone = std.contact
            if (phone) {
              if (phone.startsWith('0')) phone = '94' + phone.substring(1)
              phone = phone.replace(/\D/g, '')
              window.open(`https://wa.me/${phone}?text=${encodeURIComponent(waMessage)}`, '_blank')
            }
          })
          $q.notify({ type: 'positive', message: `Opening WhatsApp for ${targetStudents.length} students.` })
        }
      }
    })
  }

  // In-app Notification
  $q.notify({
    type: diff === 0 ? 'warning' : 'info',
    message: messageText,
    caption: `${cls.subject} | ${cls.tutor}`,
    position: 'top-right',
    icon: 'notifications_active',
    timeout: 15000,
    actions: actions
  })

  // System Notification (Browser)
  if (Notification.permission === 'granted') {
    new Notification('Class Reminder', {
      body: messageText,
      icon: '/icons/favicon-128x128.png'
    })
  } else if (Notification.permission !== 'denied') {
    Notification.requestPermission()
  }
}

onMounted(() => {
  fetchTodayClasses()
  
  // Initial check
  setTimeout(checkReminders, 2000)

  // Run every 30 seconds for accuracy
  timer.value = setInterval(() => {
    // Refresh classes at the start of every hour or every 10 mins 
    // to stay updated without spamming DB
    if (new Date().getMinutes() % 10 === 0 && new Date().getSeconds() < 30) {
      fetchTodayClasses()
    }
    checkReminders()
  }, 30000)

  // Request browser notification permission
  if (Notification.permission === 'default') {
    Notification.requestPermission()
  }
})

onUnmounted(() => {
  if (timer.value) clearInterval(timer.value)
})
</script>
