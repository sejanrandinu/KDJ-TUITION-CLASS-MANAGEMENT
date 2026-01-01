<template>
  <q-page class="bg-black text-white q-py-xl">
    <div class="container-xl q-px-md">
      <div class="glass-card q-pa-xl rounded-borders">
        <h1 class="text-h3 text-weight-bolder q-mb-xl text-gradient">{{ t.aboutUs }}</h1>
        
        <div class="text-grey-4 q-gutter-y-lg">
          <section>
            <h2 class="text-h5 text-white text-weight-bold q-mb-md">{{ appStore.language === 'English' ? 'Our Mission' : 'අපගේ මෙහෙවර' }}</h2>
            <p>{{ appStore.language === 'English' ? 'ClassMaster is on a mission to democratize education technology. We provide high-performance management tools to tuition institutes globally, allowing educators to focus on what matters most: teaching.' : 'ClassMaster හි අරමුණ වන්නේ අධ්‍යාපන තාක්‍ෂණය සැමට ලබා දීමයි. අපි ලොව පුරා උපකාරක පන්ති ආයතන සඳහා ඉහළ කාර්යසාධනයක් සහිත කළමනාකරණ මෙවලම් සපයන්නෙමු.' }}</p>
          </section>

          <section>
            <h2 class="text-h5 text-white text-weight-bold q-mb-md">{{ appStore.language === 'English' ? 'Our Vision' : 'අපගේ දැක්ම' }}</h2>
            <p>{{ appStore.language === 'English' ? 'To become the leading ecosystem for educational institutions, fostering a seamless connection between tutors, students, and parents through innovation and data-driven insights.' : 'නවෝත්පාදන සහ දත්ත මත පදනම් වූ අවබෝධය තුළින් ගුරුවරුන්, සිසුන් සහ දෙමාපියන් අතර බාධාවකින් තොරව සම්බන්ධතාවයක් ඇති කරමින් අධ්‍යාපන ආයතන සඳහා ප්‍රමුඛතම පද්ධතිය බවට පත්වීම අපගේ දැක්මයි.' }}</p>
          </section>

          <section>
            <h2 class="text-h5 text-white text-weight-bold q-mb-md">{{ appStore.language === 'English' ? 'Who We Are' : 'අපි කවුද' }}</h2>
            <p>{{ appStore.language === 'English' ? 'Founded by a team of passionate engineers and educators, ClassMaster was built to solve the real-world challenges faced by tuition centers. From attendance tracking to financial reporting, we automate the mundane so you can scale with ease.' : 'කැපවූ ඉංජිනේරුවන් සහ අධ්‍යාපනඥයින් කණ්ඩායමක් විසින් ආරම්භ කරන ලද ClassMaster, උපකාරක පන්ති මධ්‍යස්ථාන මුහුණ දෙන අභියෝග විසඳීම සඳහා ගොඩනගා ඇත.' }}</p>
          </section>
        </div>

        <div class="q-mt-xl">
          <q-btn flat color="white" :label="t.backHome" to="/" icon="arrow_back" no-caps />
        </div>
      </div>
    </div>
  </q-page>
</template>

<script setup>
import { computed } from 'vue'
import { useAppStore } from 'src/store/app'
import layoutTranslations from 'src/i18n/layout'

const appStore = useAppStore()
const t = computed(() => layoutTranslations[appStore.language])
</script>

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
