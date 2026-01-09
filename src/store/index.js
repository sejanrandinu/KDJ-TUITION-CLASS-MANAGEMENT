import { store } from 'quasar/wrappers'
import { createPinia } from 'pinia'
import piniaPluginPersistedstate from 'pinia-plugin-persistedstate'

/*
 * If not building with SSR mode, you can
 * directly export the Store instantiation;
 *
 * The function below can be async too; either use
 * async/await or return a Promise which resolves
 * with the Store instance.
 */

export default store((/* { ssrContext } */) => {
  const pinia = createPinia()

  // Resilient persistence fallback
  try {
    const storage = window.localStorage
    if (storage) {
      storage.setItem('__pinia_test__', '1')
      storage.removeItem('__pinia_test__')
      pinia.use(piniaPluginPersistedstate)
    }
  } catch (e) {
    console.warn('Pinia: Storage blocked or unavailable, persistence disabled.', e)
  }

  return pinia
})
