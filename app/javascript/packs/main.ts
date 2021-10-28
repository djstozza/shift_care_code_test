// Run this example by adding <%= javascript_pack_tag 'hello_typescript' %> to the head of your layout file,
// like app/views/layouts/application.html.erb.

import Vue from 'vue'
import Vuetify from 'vuetify'
import 'vuetify/dist/vuetify.min.css'
import 'material-design-icons-iconfont/dist/material-design-icons.css'
import App from '../app.vue'
import router from '../router'
import store from '../store'

Vue.use(Vuetify)

document.addEventListener('DOMContentLoaded', () => {
  const app = new Vue({
    store,
    vuetify: new Vuetify(),
    router: router,
    render: h => h(App)
  }).$mount()
  document.body.appendChild(app.$el)

  console.log(app)
})
