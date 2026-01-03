<template>
  <div ref="turnstileContainer" class="turnstile-container q-my-md"></div>
</template>

<script setup>
import { ref, onMounted, onBeforeUnmount, watch } from 'vue'

const props = defineProps({
  sitekey: {
    type: String,
    default: '0x4AAAAAACKUp24EhZkHW2b1' // Testing key
  },
  theme: {
    type: String,
    default: 'dark'
  }
})

const emit = defineEmits(['verify', 'error', 'expire'])
const turnstileContainer = ref(null)
let widgetId = null

const renderTurnstile = () => {
  if (window.turnstile) {
    widgetId = window.turnstile.render(turnstileContainer.value, {
      sitekey: props.sitekey,
      theme: props.theme,
      callback: (token) => {
        emit('verify', token)
      },
      'error-callback': () => {
        emit('error')
      },
      'expired-callback': () => {
        emit('expire')
      }
    })
  }
}

onMounted(() => {
  // Check if turnstile is already loaded
  if (window.turnstile) {
    renderTurnstile()
  } else {
    // Wait for it to load
    const interval = setInterval(() => {
      if (window.turnstile) {
        clearInterval(interval)
        renderTurnstile()
      }
    }, 100)
    
    // Cleanup interval if component unmounts before loading
    onBeforeUnmount(() => clearInterval(interval))
  }
})

onBeforeUnmount(() => {
  if (widgetId !== null && window.turnstile) {
    window.turnstile.remove(widgetId)
  }
})

// Expose reset method
defineExpose({
  reset: () => {
    if (widgetId !== null && window.turnstile) {
      window.turnstile.reset(widgetId)
    }
  }
})
</script>

<style scoped>
.turnstile-container {
  display: flex;
  justify-content: center;
  min-height: 65px;
}
</style>
