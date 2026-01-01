<template>
  <q-page class="q-pa-md">
    <!-- Header -->
    <div class="row items-center justify-between q-mb-lg">
       <div>
         <h1 class="text-h4 text-weight-bold text-grey-9 q-mb-xs">Overview</h1>
         <div class="text-grey-6">Welcome back, Administrator</div>
       </div>
       <div class="row q-gutter-sm">

          <q-btn unelevated color="primary" icon="add" label="New Admission" no-caps @click="handleNewAdmission" />
       </div>
    </div>

    <!-- Stats Grid -->
    <div class="row q-col-gutter-md q-mb-lg">
       <div class="col-xs-12 col-sm-6 col-md-3" v-for="(stat, i) in stats" :key="i">
          <q-card flat bordered class="rounded-borders hover-card" @click="router.push(stat.to)">
             <q-card-section>
                <div class="row items-center justify-between q-mb-sm">
                   <div class="text-caption text-grey-6 text-uppercase text-weight-bold">{{ stat.label }}</div>
                   <div class="bg-blue-1 q-pa-xs rounded-borders">
                        <q-icon :name="stat.icon" color="primary" size="20px" />
                   </div>
                </div>
                <div class="text-h4 text-weight-bold text-grey-9 q-mb-xs">
                    {{ stat.prefix }}{{ Math.round(stat.value).toLocaleString() }}{{ stat.suffix }}
                </div>
                <div class="row items-center text-caption" :class="stat.trend > 0 ? 'text-green-7' : 'text-red-7'">
                   <q-icon :name="stat.trend > 0 ? 'trending_up' : 'trending_down'" size="16px" class="q-mr-xs" />
                   <span class="text-weight-bold">{{ Math.abs(stat.trend) }}%</span>
                   <span class="text-grey-6 q-ml-xs">vs last month</span>
                </div>
             </q-card-section>
          </q-card>
       </div>
    </div>

    <!-- Main Content Area -->
    <div class="row q-col-gutter-md">
        <!-- Quick Actions & Recent Classes -->
        <div class="col-xs-12 col-md-8">
            <q-card flat bordered class="rounded-borders q-mb-md hover-card">
                <q-card-section class="q-pb-none">
                    <div class="row items-center justify-between">
                        <div class="text-h6 text-weight-bold">Today's Schedule</div>
                        <q-btn flat dense color="primary" label="View All" no-caps @click="handleViewAllSchedule" />
                    </div>
                </q-card-section>
                <q-card-section>
                    <div class="text-center q-py-lg text-grey-6">
                        <q-icon name="event_busy" size="48px" color="grey-4" class="q-mb-sm" />
                        <div>No classes scheduled for today</div>
                    </div>
                </q-card-section>
            </q-card>

            <q-card flat bordered class="rounded-borders hover-card">
                <q-card-section>
                    <div class="text-h6 text-weight-bold q-mb-md">Revenue Analytics</div>
                    <div class="flex flex-center bg-grey-1 rounded-borders text-grey-5" style="height: 300px;">
                        <div class="text-center">
                            <q-icon name="bar_chart" size="48px" color="grey-4" />
                            <div class="q-mt-sm">No financial data available</div>
                        </div>
                    </div>
                </q-card-section>
            </q-card>
        </div>

        <!-- Right Side Panel -->
        <div class="col-xs-12 col-md-4">
            <!-- Quick Actions -->
            <q-card flat bordered class="rounded-borders q-mb-md bg-primary text-white">
                <q-card-section>
                    <div class="text-h6 text-weight-bold q-mb-sm">Quick Actions</div>
                    <p class="opacity-80 q-mb-lg">Common administrative tasks</p>
                    
                    <div class="row q-col-gutter-sm">
                        <div class="col-6">
                            <q-btn unelevated color="white" text-color="primary" class="full-width text-weight-bold" label="Add Student" no-caps icon="person_add" @click="handleQuickAction('add_student')" />
                        </div>
                        <div class="col-6">
                             <q-btn outline color="white" class="full-width" label="Collect Fees" no-caps icon="payments" @click="handleQuickAction('fees')" />
                        </div>
                        <div class="col-6">
                             <q-btn outline color="white" class="full-width" label="Attendance" no-caps icon="qr_code_scanner" @click="handleQuickAction('attendance')" />
                        </div>
                        <div class="col-6">
                             <q-btn outline color="white" class="full-width" label="Message" no-caps icon="send" @click="handleQuickAction('message')" />
                        </div>
                    </div>
                </q-card-section>
            </q-card>

            <!-- Recent Activity -->
             <q-card flat bordered class="rounded-borders hover-card">
                <q-card-section>
                    <div class="text-h6 text-weight-bold q-mb-md">Recent Activity</div>
                    <div class="text-center q-py-lg text-grey-6">
                        <q-icon name="history" size="48px" color="grey-4" class="q-mb-sm" />
                        <div>No recent activity</div>
                    </div>
                </q-card-section>
            </q-card>
        </div>
    </div>
  </q-page>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { useRouter } from 'vue-router'

import { supabase } from 'src/supabase'
import gsap from 'gsap'

const router = useRouter()


const stats = ref([
  { label: 'Total Students', value: 0, target: 0, prefix: '', suffix: '', icon: 'school', trend: 0, to: '/dashboard/students' },
  { label: 'Monthly Revenue', value: 0, target: 0, prefix: 'LKR ', suffix: '', icon: 'payments', trend: 0, to: '/dashboard/fees' },
  { label: 'Active Tutors', value: 0, target: 0, prefix: '', suffix: '', icon: 'cast_for_education', trend: 0, to: '/dashboard/tutors' },
  { label: 'Classes Today', value: 0, target: 0, prefix: '', suffix: '', icon: 'event_available', trend: 0, to: '/dashboard/classes' },
])

const hasUrl = ref(!!import.meta.env.VITE_SUPABASE_URL)
const hasKey = ref(!!import.meta.env.VITE_SUPABASE_KEY)
const dbCheckStatus = ref('Checking...')
const connectionStatus = ref({
    message: 'Checking system connectivity...',
    color: 'bg-grey-8',
    icon: 'hourglass_empty'
})

onMounted(() => {
    checkConnection()
    fetchDashboardStats()
})

const checkConnection = async () => {
    if (!hasUrl.value || !hasKey.value) {
        connectionStatus.value = {
            message: 'Configuration Config Missing! Please check .env file.',
            color: 'bg-red-9',
            icon: 'error'
        }
        dbCheckStatus.value = 'Failed: Missing Variables'
        return
    }

    try {
        const { error } = await supabase.from('students').select('*', { count: 'exact', head: true })
        
        if (error) {
            dbCheckStatus.value = `Failed: ${error.message} (Code: ${error.code})`
             connectionStatus.value = {
                message: 'Database Connection Failed',
                color: 'bg-red-9',
                icon: 'dns'
            }
        } else {
            dbCheckStatus.value = 'Connected Successfully - Table Found'
            connectionStatus.value = {
                message: 'System Operational',
                color: 'bg-green-7',
                icon: 'check_circle'
            }
        }
    } catch (err) {
        dbCheckStatus.value = `Critical Error: ${err.message}`
        connectionStatus.value = {
            message: 'Critical Connection Error',
            color: 'bg-red-10',
            icon: 'bug_report'
        }
    }
}

const fetchDashboardStats = async () => {
    try {
        // Fetch Students Count
        const { count: studentCount, error: studentError } = await supabase
            .from('students')
            .select('*', { count: 'exact', head: true })
        
        if (!studentError) {
             stats.value[0].target = studentCount || 0
        }

        // Fetch Tutors Count
        const { count: tutorCount, error: tutorError } = await supabase
            .from('tutors')
            .select('*', { count: 'exact', head: true })
        
        if (!tutorError) {
             stats.value[2].target = tutorCount || 0
        }

        // Fetch Today's Classes
        const days = ['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday']
        const today = days[new Date().getDay()]
        const { count: classCount } = await supabase
            .from('classes')
            .select('*', { count: 'exact', head: true })
            .eq('day', today)
            .eq('status', 'Active')
        
        if (classCount !== null) {
            stats.value[3].target = classCount
        }

        // Animate stats
        stats.value.forEach(stat => {
            gsap.to(stat, {
                value: stat.target,
                duration: 1.5,
                ease: 'power2.out'
            })
        })

    } catch (error) {
        console.error('Error fetching dashboard stats:', error)
    }
}

// Button Actions


const handleNewAdmission = () => {
    router.push('/dashboard/students')
}

const handleViewAllSchedule = () => {
    router.push('/dashboard/classes')
}

const handleQuickAction = (action) => {
    switch(action) {
        case 'add_student':
            router.push('/dashboard/students')
            break;
        case 'fees':
            router.push('/dashboard/fees')
            break;
        case 'attendance':
            router.push('/dashboard/attendance')
            break;
        case 'message':
            router.push('/dashboard/messages')
            break;
    }
}
</script>

<style scoped lang="scss">
.border-grey {
    border: 1px solid #e0e0e0;
}
.opacity-80 {
    opacity: 0.8;
}

.hover-card {
    transition: all 0.4s cubic-bezier(0.4, 0, 0.2, 1);
    cursor: pointer;
    background: white;
    
    &:hover {
        transform: translateY(-5px);
        box-shadow: 0 15px 30px -5px rgba(0, 0, 0, 0.2);
        background: #111 !important; /* Almost black for better aesthetic */
        border-color: #333;
        
        /* Make text white on hover */
        .text-grey-9, .text-grey-6, .text-grey-5, .text-h6, .text-h4, .text-caption, div {
            color: white !important;
        }
        
        /* Keep trend colors visible but brighter/adjusted if needed, 
           or let the specific classes override specific elements if defined later.
           However, simplest is to let key metrics pop. 
        */
        
        /* Adjust inner backgrounds to be subtle on dark */
        .bg-blue-1, .bg-grey-1 {
            background: rgba(255, 255, 255, 0.1) !important;
        }
        
        /* Ensure primary icons stay colored or turn white? 
           User didn't specify, but primary generally looks good on black.
           Let's keep primary color for icons to maintain brand.
        */
        .text-primary {
             color: #64b5f6 !important; /* Lighter blue */
        }
        
        .q-icon {
             color: inherit; /* Will inherit white or specific overrides */
        }
        
        /* Re-assert primary color for icons that need it */
        .q-icon.text-primary {
             color: #64b5f6 !important;
        }
    }
}
</style>
