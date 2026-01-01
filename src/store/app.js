import { defineStore } from 'pinia'

export const useAppStore = defineStore('app', {
  state: () => ({
    language: 'English'
  }),
  actions: {
    setLanguage(lang) {
      this.language = lang
    }
  },
  persist: true
})
