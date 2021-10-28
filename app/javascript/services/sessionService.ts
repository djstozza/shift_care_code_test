import axios from 'axios'
import qs from 'qs'

import { AUTH_KEY } from '../store'

const authedFetch = async (method, url, params = {}, bearer) => {
  const csrfToken = document.querySelector("meta[name=csrf-token]").content
  axios.defaults.headers.common['X-CSRF-Token'] = csrfToken

  if (bearer) {
    const { token } = JSON.parse(localStorage.getItem(AUTH_KEY)) || {}
    axios.defaults.headers.common['Authorization'] = `Bearer ${token}`
  }

  axios.defaults.paramsSerializer = (params) => (
    qs.stringify(params, { arrayFormat: 'brackets' })
  )

  try {
    const response = await axios({ method, url, params: { ...params, format: 'json' } })
    return response

  } catch (err) {
    const { response: { status, data: { errors } } } = err

    if (status === 401) localStorage.removeItem(AUTH_KEY)

    return { errors }
  }
}

export default {
  async attemptLogin (email, password) {
    const {
      data: {
        data: { token, admin } = {}
      } = {},
      errors
    } = await authedFetch('post', '/api/sessions', { admin: { email, password } })

    if (errors) {
      const emailErrorsArr = errors.filter(({ source }) => source === 'email').map(({ detail }) => detail)
      const passwordErrorsArr = errors.filter(({ source }) => source !== 'email').map(({ detail }) => detail)
      return { emailErrorsArr, passwordErrorsArr, success: '' }
    }

    if (token && admin) localStorage.setItem(AUTH_KEY, JSON.stringify({ token, admin }))

    return { success: 'You have successfully logged in', emailErrorsArr: [], passwordErrorsArr: [] }
  },

  async fetchJobs (start_time, end_time) {
    const { data: { data: jobs = [] } } = await authedFetch('get', '/api/jobs', { filter: { start_time, end_time } }, true)

    return { jobs }
  }
}
