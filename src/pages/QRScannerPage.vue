<template>
  <q-page class="q-pa-md bg-grey-1 flex flex-center">
    <div class="container-md text-center">
      <div v-if="!scannedStudent" class="q-mb-xl">
        <h1 class="text-h4 text-weight-bold text-grey-9 q-mb-md">Scan Student QR Code</h1>
        <p class="text-subtitle1 text-grey-6 q-mb-xl">Place the student ID card in front of the camera</p>
        
        <q-card flat bordered class="scanner-card rounded-borders overflow-hidden shadow-2">
            <div id="reader" style="width: 100%; min-height: 300px;"></div>
            <div v-if="scanning" class="q-pa-md bg-white border-top">
                <q-btn flat color="red" icon="stop" label="Stop Scanning" no-caps @click="stopScanner" />
            </div>
            <div v-else class="q-pa-xl flex flex-center bg-white">
                <q-btn color="primary" icon="videocam" label="Start Camera" unelevated no-caps size="lg" @click="startScanner" />
            </div>
        </q-card>
      </div>

      <!-- Scanned Student Result -->
      <transition
        appear
        enter-active-class="animated zoomIn"
        leave-active-class="animated zoomOut"
      >
        <q-card v-if="scannedStudent" flat bordered class="result-card rounded-borders shadow-10 overflow-hidden" style="width: 100%; max-width: 500px;">
            <q-card-section class="bg-primary text-white q-pa-lg text-center relative-position">
                <q-btn icon="close" flat round dense class="absolute-top-right q-ma-sm" color="white" @click="resetScanner" />
                <q-avatar size="90px" color="white" text-color="primary" class="shadow-5 q-mb-md">
                    {{ scannedStudent.name.charAt(0) }}
                </q-avatar>
                <div class="text-h5 text-weight-bold">{{ scannedStudent.name }}</div>
                <div class="text-caption text-blue-1">{{ scannedStudent.student_id }} | {{ scannedStudent.grade }}</div>
            </q-card-section>

            <q-card-section class="q-pa-lg">
                <div class="row q-col-gutter-md">
                    <!-- Status Chip -->
                    <div class="col-12 text-center q-mb-md">
                        <q-chip :color="scannedStudent.status === 'Active' ? 'green-1' : 'red-1'" :text-color="scannedStudent.status === 'Active' ? 'green-9' : 'red-9'" size="lg">
                            Status: {{ scannedStudent.status }}
                        </q-chip>
                    </div>

                    <!-- Attendance Section -->
                    <div class="col-12">
                        <q-card flat bordered class="q-pa-md bg-blue-50">
                            <div class="row items-center justify-between">
                                <div class="text-subtitle1 text-weight-bold text-primary">Attendance</div>
                                <div v-if="attendanceLoading"><q-spinner-dots color="primary" /></div>
                                <div v-else :class="todayAttendance ? 'text-green-7' : 'text-red-7'">
                                    {{ todayAttendance ? 'Marked' : 'Not Marked Today' }}
                                </div>
                            </div>
                            <q-btn 
                                v-if="!todayAttendance"
                                color="primary" 
                                icon="check_circle" 
                                label="Mark Present" 
                                unelevated 
                                no-caps 
                                class="full-width q-mt-sm"
                                :loading="markingAttendance"
                                @click="markAttendanceAuto"
                            />
                        </q-card>
                    </div>

                    <!-- Fees Section -->
                    <div class="col-12 q-mt-md">
                        <q-card flat bordered class="q-pa-md bg-green-50">
                            <div class="row items-center justify-between">
                                <div class="text-subtitle1 text-weight-bold text-green-9">Class Fees ({{ currentMonth }})</div>
                                <div v-if="feesLoading"><q-spinner-dots color="green-9" /></div>
                                <div v-else :class="isFeesPaid ? 'text-green-7' : 'text-red-7'">
                                    {{ isFeesPaid ? 'Paid' : 'Pending' }}
                                </div>
                            </div>
                            <div v-if="!isFeesPaid && !feesLoading" class="text-caption text-grey-7 q-mt-xs">
                                No payment record found for this month.
                            </div>
                        </q-card>
                    </div>
                </div>
            </q-card-section>

            <q-card-actions align="center" class="q-pb-lg">
                <q-btn outline color="primary" label="Close" no-caps class="q-px-xl" @click="resetScanner" />
            </q-card-actions>
        </q-card>
      </transition>
    </div>
  </q-page>
</template>

<script setup>
import { ref, onMounted, onBeforeUnmount } from 'vue'
import { useQuasar } from 'quasar'
import { supabase } from 'src/supabase'
import { Html5QrcodeScanner } from 'html5-qrcode'

const $q = useQuasar()
const scanner = ref(null)
const scanning = ref(false)
const scannedStudent = ref(null)
const todayAttendance = ref(null)
const isFeesPaid = ref(false)

const attendanceLoading = ref(false)
const markingAttendance = ref(false)
const feesLoading = ref(false)

const currentMonth = new Date().toLocaleString('default', { month: 'long', year: 'numeric' })
const todayDate = new Date().toISOString().split('T')[0]

onMounted(() => {
    // We don't start automatically to avoid camera permissions issues on load
})

onBeforeUnmount(() => {
    stopScanner()
})

const startScanner = () => {
    scanning.value = true
    setTimeout(() => {
        scanner.value = new Html5QrcodeScanner("reader", { 
            fps: 10, 
            qrbox: { width: 250, height: 250 },
            rememberLastUsedCamera: true
        })
        scanner.value.render(onScanSuccess, onScanFailure)
    }, 100)
}

const stopScanner = async () => {
    if (scanner.value) {
        try {
            await scanner.value.clear()
        } catch (err) {
            console.error("Failed to clear scanner:", err)
        }
        scanner.value = null
    }
    scanning.value = false
}

const onScanSuccess = async (decodedText) => {
    if (!decodedText) return
    console.log(`Scan Result: ${decodedText}`)
    
    // Stop scanner first
    await stopScanner()
    
    // Small delay to allow library to settle
    setTimeout(async () => {
        await handleScannedStudent(decodedText)
    }, 300)
}

const onScanFailure = () => {
    // silent failure for scanning process
}

const handleScannedStudent = async (studentId) => {
    $q.loading.show({ message: 'Fetching student details...' })
    
    // 1. Fetch Student Info
    const { data: student, error } = await supabase
        .from('students')
        .select('*')
        .eq('student_id', studentId)
        .single()

    if (error || !student) {
        $q.loading.hide()
        $q.notify({ type: 'negative', message: 'Student not found: ' + studentId })
        startScanner()
        return
    }

    scannedStudent.value = student
    $q.loading.hide()

    // 2. Fetch Today's Attendance
    fetchAttendance(student.id)

    // 3. Fetch This Month's Fees
    fetchFees(student.id)
}

const fetchAttendance = async (studentDbId) => {
    attendanceLoading.value = true
    const { data } = await supabase
        .from('attendance')
        .select('*')
        .eq('student_id', studentDbId)
        .eq('date', todayDate)
        .single()
    
    todayAttendance.value = data
    attendanceLoading.value = false
}

const fetchFees = async (studentDbId) => {
    feesLoading.value = true
    const { data } = await supabase
        .from('payments')
        .select('*')
        .eq('student_id', studentDbId)
        .eq('month', currentMonth)
        .limit(1)
    
    isFeesPaid.value = data && data.length > 0
    feesLoading.value = false
}

const markAttendanceAuto = async () => {
    if (!scannedStudent.value) return
    
    markingAttendance.value = true
    
    // We need to know which class to mark for. Since students are grade-based, 
    // we find the active class for their grade.
    const { data: classes } = await supabase
        .from('classes')
        .select('id')
        .eq('grade', scannedStudent.value.grade)
        .eq('status', 'Active')
        .limit(1)

    if (!classes || classes.length === 0) {
        $q.notify({ type: 'warning', message: `No active class found for ${scannedStudent.value.grade}` })
        markingAttendance.value = false
        return
    }

    const { error } = await supabase
        .from('attendance')
        .upsert({
            student_id: scannedStudent.value.id,
            class_id: classes[0].id,
            date: todayDate,
            status: 'Present'
        }, { onConflict: 'student_id,class_id,date' })

    if (error) {
        $q.notify({ type: 'negative', message: 'Failed to mark attendance' })
    } else {
        $q.notify({ type: 'positive', message: 'Attendance marked: Present', icon: 'check' })
        fetchAttendance(scannedStudent.value.id)
    }
    markingAttendance.value = false
}

const resetScanner = () => {
    scannedStudent.value = null
    todayAttendance.value = null
    isFeesPaid.value = false
    startScanner()
}
</script>

<style scoped lang="scss">
.scanner-card {
    background: white;
    border-radius: 20px;
    width: 400px;
    max-width: 95vw;
}

.result-card {
    border-radius: 24px;
}

#reader {
    border: none !important;
}

#reader__scan_region {
    background: #f8f9fa;
}

#reader__dashboard_section_csr button {
    background: #1976D2 !important;
    color: white !important;
    border: none !important;
    padding: 8px 16px !important;
    border-radius: 8px !important;
    text-transform: uppercase !important;
    font-weight: bold !important;
}

.bg-blue-50 {
    background-color: #f0f7ff;
}

.bg-green-50 {
    background-color: #f0fff4;
}
</style>
