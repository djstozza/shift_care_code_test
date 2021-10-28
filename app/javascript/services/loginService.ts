import axios from 'axios'
import qs from 'qs'

const AUTH_KEY = 'ShiftCareAuth'

export default {
  async attemptLogin (email, password) {
    try {
      const csrfToken = document.querySelector("meta[name=csrf-token]").content
      axios.defaults.headers.common['X-CSRF-Token'] = csrfToken
      axios.defaults.paramsSerializer = (params) => {
        return qs.stringify(params, { arrayFormat: 'brackets' })
      }

      const {
        data: {
          data: { admin, token }
        }
      } = await axios.post('/api/sessions', null, { params: { admin: { email, password }, format: 'json' } })

      localStorage.setItem(AUTH_KEY, JSON.stringify(token, admin))

      return { success: 'You have successfully logged in', emailErrorsArr: [], passwordErrorsArr: [] }
    } catch (err) {

      const { response: { data: { errors } } } = err as ErrorResponse
      const emailErrorsArr = errors.filter(({ source }) => source === 'email').map(({ detail }) => detail)
      const passwordErrorsArr = errors.filter(({ source }) => source !== 'email').map(({ detail }) => detail)
      return { emailErrorsArr, passwordErrorsArr, success: '' }
    }
  }
}
