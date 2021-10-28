import Vue from 'vue'
import Vuex from 'vuex'

Vue.use(Vuex)

export const AUTH_KEY = 'ShiftCareAuth'

export const initialState = {
  errors: [],
  success: '',
  token: localStorage.getItem(AUTH_KEY)
}

export const mutations = {
}

export default new Vuex.Store({
  state: initialState,
  mutations,
  actions: {
  },
  modules: {
  }
})
