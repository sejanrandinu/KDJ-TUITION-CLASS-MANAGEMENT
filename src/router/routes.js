const routes = [
  {
    path: '/',
    component: () => import('layouts/MainLayout.vue'),
    children: [
      { path: '', component: () => import('pages/IndexPage.vue') },
      { path: 'login', component: () => import('pages/LoginPage.vue') },
      { path: 'register', component: () => import('pages/RegisterPage.vue') },
    ]
  },

  {
    path: '/dashboard',
    component: () => import('layouts/DashboardLayout.vue'),
    children: [
      { path: '', component: () => import('pages/DashboardPage.vue'), meta: { requiresAuth: true } },
      { path: 'students', component: () => import('pages/users/StudentsPage.vue'), meta: { requiresAuth: true } },
      { path: 'tutors', component: () => import('pages/users/TutorsPage.vue'), meta: { requiresAuth: true } },
      { path: 'subjects', component: () => import('pages/SubjectsPage.vue'), meta: { requiresAuth: true } },
      { path: 'classes', component: () => import('pages/ClassesPage.vue'), meta: { requiresAuth: true } },
      { path: 'attendance', component: () => import('pages/AttendancePage.vue'), meta: { requiresAuth: true } },
      { path: 'fees', component: () => import('pages/FeesPage.vue'), meta: { requiresAuth: true } },
      { path: 'messages', component: () => import('pages/MessagingPage.vue'), meta: { requiresAuth: true } },
      { path: 'sms-settings', component: () => import('pages/SmsSettingsPage.vue'), meta: { requiresAuth: true } },
      { path: 'roles', component: () => import('pages/users/RolesPage.vue'), meta: { requiresAuth: true } }
    ]
  },

  // Always leave this as last one,
  // but you can also remove it
  {
    path: '/:catchAll(.*)*',
    component: () => import('pages/ErrorNotFound.vue')
  }
]

export default routes
