import Vue from 'vue'
import Vuex from 'vuex'

Vue.use(Vuex)

export const initialState = {
  errors: [],
  success: '',
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
