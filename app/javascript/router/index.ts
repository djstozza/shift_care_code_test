import Vue from 'vue'
import VueRouter, { RouteConfig } from 'vue-router'
const Login = () => import('../components/login.vue')
const Calendar = () => import('../components/calendar.vue')

Vue.use(VueRouter)

const routes: Array<RouteConfig> = [
  {
    path: '/login',
    name: 'Login',
    component: Login
  }, {
    path: '/',
    name: 'Calendar',
    component: Calendar
  }
]

const router = new VueRouter({
  routes
})

export default router
