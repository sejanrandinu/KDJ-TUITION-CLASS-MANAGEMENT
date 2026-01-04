<template>
  <div class="chatbot-wrapper">
    <!-- Floating Button -->
    <q-btn
      fab
      icon="chat"
      color="primary"
      class="chatbot-toggle shadow-10"
      @click="toggleChat"
      :class="{ 'is-open': isOpen }"
    >
      <q-badge v-if="!isOpen && unreadCount > 0" color="red" floating>{{ unreadCount }}</q-badge>
    </q-btn>

    <!-- Chat Window -->
    <transition
      appear
      enter-active-class="animated zoomIn"
      leave-active-class="animated zoomOut"
    >
      <q-card v-if="isOpen" class="chatbot-window shadow-24 overflow-hidden">
        <!-- Header -->
        <q-toolbar class="bg-primary text-white">
          <q-avatar size="32px" class="q-mr-sm">
            <q-icon name="smart_toy" color="white" />
          </q-avatar>
          <q-toolbar-title class="text-subtitle1 text-weight-bold">
            ClassMaster AI
          </q-toolbar-title>
          <q-btn flat round dense icon="close" @click="isOpen = false" />
        </q-toolbar>

        <!-- Messages Area -->
        <q-card-section class="chat-messages q-pa-md scroll" id="chat-box">
          <div v-for="(msg, index) in messages" :key="index" class="q-mb-md">
            <q-chat-message
              :name="msg.role === 'ai' ? 'ClassMaster AI' : 'You'"
              :avatar="msg.role === 'ai' ? 'https://cdn-icons-png.flaticon.com/512/4712/4712035.png' : 'https://cdn.quasar.dev/img/boy-avatar.png'"
              :text="[msg.text]"
              :sent="msg.role === 'user'"
              :bg-color="msg.role === 'ai' ? 'grey-3' : 'primary'"
              :text-color="msg.role === 'ai' ? 'black' : 'white'"
            />
          </div>
          <div v-if="isTyping" class="q-mb-md">
            <q-chat-message
              name="ClassMaster AI"
              avatar="https://cdn-icons-png.flaticon.com/512/4712/4712035.png"
              bg-color="grey-3"
            >
              <q-spinner-dots size="20px" />
            </q-chat-message>
          </div>
        </q-card-section>

        <q-separator />

        <!-- Input Area -->
        <q-card-actions class="q-pa-sm bg-white">
          <q-input
            v-model="input"
            dense
            outlined
            placeholder="Type your message..."
            class="full-width rounded-borders custom-chat-input"
            @keyup.enter="sendMessage"
            :disable="isTyping"
          >
            <template v-slot:append>
              <q-btn round flat icon="send" color="primary" @click="sendMessage" :disable="!input.trim() || isTyping" />
            </template>
          </q-input>
        </q-card-actions>
      </q-card>
    </transition>
  </div>
</template>

<script setup>
import { ref, nextTick } from 'vue'

const isOpen = ref(false)
const input = ref('')
const isTyping = ref(false)
const unreadCount = ref(1)

const messages = ref([
  { role: 'ai', text: 'Hello! I am ClassMaster AI. How can I help you today? මම ඔබට උදව් කරන්නේ කෙසේද? (Sinhala/English/Singlish)' }
])

const toggleChat = () => {
  isOpen.value = !isOpen.value
  if (isOpen.value) {
    unreadCount.value = 0
    scrollToBottom()
  }
}

const scrollToBottom = async () => {
  await nextTick()
  const chatBox = document.getElementById('chat-box')
  if (chatBox) {
    chatBox.scrollTop = chatBox.scrollHeight
  }
}

const responses = {
  'registration': {
    keys: ['register', 'signup', 'sign up', 'apply', 'lapaidanchi', 'lekhana', 'ලියාපදිංචි', 'රෙජිස්ටර්'],
    en: 'To register, click the "Get Started" button on the home page or go to the /register page.',
    si: 'ලියාපදිංචි වීමට, මුල් පිටුවේ ඇති "Get Started" බොත්තම ක්ලික් කරන්න හෝ /register පිටුවට යන්න.'
  },
  'student': {
    keys: ['student', 'lamayi', 'shishya', 'lamay', 'shisyayo', 'දරුවෝ', 'සිසුන්'],
    en: 'You can manage students in the "Students" section of your dashboard.',
    si: 'ඔබට ඔබගේ dashboard එකේ "Students" අංශයට ගොස් සිසුන් කළමනාකරණය කළ හැකිය.'
  },
  'attendance': {
    keys: ['attendance', 'paminiima', 'reg', 'paminima', 'පැමිණීම', 'අattendance'],
    en: 'Attendance can be marked manually or by scanning student QR codes in the Attendance section.',
    si: 'පැමිණීම සලකුණු කිරීම "Attendance" අංශය හරහා හෝ QR කේත ස්කෑන් කිරීමෙන් කළ හැකිය.'
  },
  'fees': {
    keys: ['fees', 'salli', 'payment', 'mudal', 'pay', 'මුදල්', 'සල්ලි', 'ගාස්තු'],
    en: 'Fees management is available under the Finance section. You can track paid and pending registrations.',
    si: 'මුදල් ගෙවීම් සහ ගාස්තු පිළිබඳ විස්තර "Finance" අංශයෙන් බැලිය හැකිය.'
  },
  'qr': {
    keys: ['qr', 'qr code', 'q r', 'code', 'ක්‍යූ ආර්'],
    en: 'Each student is assigned a unique QR code which can be generated and downloaded from their profile.',
    si: 'සෑම සිසුවෙකුටම අනන්‍ය වූ QR කේතයක් ඇති අතර එය ඔවුන්ගේ profile එකෙන් බාගත කළ හැකිය.'
  },
  'contact': {
    keys: ['contact', 'support', 'help', 'kauru hari', 'phone', 'number', 'උදව්', 'සපෝර්ට්'],
    en: 'You can contact support via WhatsApp at +94 70 283 8364 or email sejanrandinu01@gmail.com.',
    si: 'ඔබට සහාය සඳහා +94 70 283 8364 අංකයට WhatsApp පණිවිඩයක් හෝ sejanrandinu01@gmail.com වෙත ඊමේල් එකක් එවිය හැකිය.'
  },
  'welcome': {
    keys: ['hi', 'hello', 'kohomada', 'haloo', 'subha dawasak', 'හායි', 'කොහොමද'],
    en: 'Hello! How can I assist you with ClassMaster today?',
    si: 'ආයුබෝවන්! අද මම ඔබට උදව් කරන්නේ කෙසේද?'
  }
}

const sendMessage = async () => {
  if (!input.value.trim() || isTyping.value) return

  const userMsg = input.value.trim()
  messages.value.push({ role: 'user', text: userMsg })
  input.value = ''
  scrollToBottom()

  isTyping.value = true
  
  // Simulate AI delay
  setTimeout(() => {
    let aiResponse = 'That is a great question! For specific technical issues, please contact our support team. (ඔබට අවශ්‍ය සහය සඳහා කරුණාකර අපගේ කණ්ඩායම අමතන්න.)'
    const lowerMsg = userMsg.toLowerCase()
    
    // Check for specific keywords first by iterating through categories
    let matchedCategory = null
    for (const category in responses) {
      if (responses[category].keys.some(key => lowerMsg.includes(key))) {
        matchedCategory = category
        break
      }
    }

    if (matchedCategory) {
      const resp = responses[matchedCategory]
      // Determine if the input looks like Sinhala or Singlish
      const isSinhala = resp.keys.some(key => isNaN(key) && lowerMsg.includes(key) && !/^[a-zA-Z0-9\s]*$/.test(key)) || 
                        ['salli', 'lamayi', 'kohomada', 'register', 'wenne'].some(k => lowerMsg.includes(k))
      
      aiResponse = isSinhala ? `${resp.si} (${resp.en})` : resp.en
    }

    messages.value.push({ role: 'ai', text: aiResponse })
    isTyping.value = false
    scrollToBottom()
  }, 1000)
}
</script>

<style scoped>
.chatbot-wrapper {
  position: fixed;
  bottom: 24px;
  right: 24px;
  z-index: 10000;
}

.chatbot-toggle {
  transition: all 0.3s cubic-bezier(0.175, 0.885, 0.32, 1.275);
}

.chatbot-toggle.is-open {
  transform: rotate(90deg);
}

.chatbot-window {
  position: absolute;
  bottom: 80px;
  right: 0;
  width: 350px;
  height: 500px;
  border-radius: 16px;
  display: flex;
  flex-direction: column;
  background: white;
}

.chat-messages {
  flex-grow: 1;
  background: #f8f9fa;
}

.custom-chat-input :deep(.q-field__control) {
  border-radius: 20px;
}

@media (max-width: 600px) {
  .chatbot-window {
    width: calc(100vw - 48px);
    height: 400px;
  }
}
</style>
