<template>
   <v-app id="inspire">
      <v-content>
         <v-container fluid fill-height>
            <v-layout align-center justify-center>
               <v-flex xs12 sm8 md4>
                  <v-card class="elevation-12">
                     <v-toolbar dark color="primary">
                        <v-toolbar-title>Login</v-toolbar-title>
                     </v-toolbar>
                     <v-card-text>
                        <v-form>
                          <v-text-field
                            prepend-icon="person"
                            :error-messages="emailErrorsArr.length ? emailErrorsArr : emailErrors"
                            label="E-mail"
                            type="email"
                            v-model="email"
                            required
                            @input="emailInput"
                            @blur="$v.email.$touch()"
                          ></v-text-field>
                          <v-text-field
                            id="password"
                            prepend-icon="lock"
                            name="password"
                            label="Password"
                            type="password"
                            v-model="password"
                            :error-messages="passwordErrorsArr.length ? passwordErrorsArr : passwordErrors"
                            required
                            @input="passwordInput"
                            @blur="$v.password.$touch()"
                          ></v-text-field>
                        </v-form>
                     </v-card-text>
                     <v-card-actions>
                        <v-spacer></v-spacer>
                        <v-btn
                          color="primary"
                          @click="submit"
                          :disabled="!email || !password || submitting"
                        >
                          Login
                        </v-btn>
                     </v-card-actions>
                  </v-card>
               </v-flex>
            </v-layout>
         </v-container>
      </v-content>
   </v-app>
</template>

<script>
import { validationMixin } from 'vuelidate'
import { required, email } from 'vuelidate/lib/validators'
import SessionService from '../services/sessionService'
import { AUTH_KEY } from '../store'

export default {
  name: 'Login',
  mixins: [validationMixin],

  validations: {
    email: { required, email },
    password: { required }
  },

  data: () => ({
    email: '',
    password: '',
    submitting: false,
    emailErrorsArr: [],
    passwordErrorsArr: []
  }),

  computed: {
    emailErrors () {
      const errors = []
      if (!this.$v.email.$dirty || !this.$v.email.$invalid) return errors
      !this.$v.email.email && errors.push('Must be valid e-mail')
      !this.$v.email.required && errors.push('E-mail is required')

      return errors
    },
    passwordErrors () {
      const errors = []
      this.passwordErrorsArr = []
      if (!this.$v.password.$dirty) {
        this.passwordErrorsArr = []
        return errors
      }
      !this.$v.password.required && errors.push('Password is required')

      return errors
    }
  },

  methods: {
    async submit () {
      this.$v.$touch()
      this.submitting = true

      const {
        success,
        emailErrorsArr = [],
        passwordErrorsArr = []
      } = await SessionService.attemptLogin(this.email, this.password)

      this.passwordErrorsArr = passwordErrorsArr
      this.emailErrorsArr = emailErrorsArr
      this.submitting = false

      if (localStorage.getItem(AUTH_KEY)) this.$router.push('/')
    },

    passwordErrors () {
      this.$v.password.$touch()
      this.passwordErrorsArr = []
    },

    emailInput () {
      this.$v.email.$touch()
      this.emailErrorsArr = []
    }
  }
};
</script>
