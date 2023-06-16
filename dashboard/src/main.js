import Vue from 'vue'
import App from './App.vue'
import store from './store'
import VueRouter from 'vue-router';
import { routes } from './router/routes';
import { index } from './components/index';


// Form Wizard
import VueFormWizard from 'vue-form-wizard'
Vue.use(VueFormWizard)

// Table
import Vuetable from 'vuetable-2'
Vue.use(Vuetable)

// Router
Vue.use(VueRouter);
const router = new VueRouter({
    routes,
    linkActiveClass: 'open active',
    scrollBehavior: () => ({ y: 0 }),
    mode: 'hash'
});

new Vue({
  el: '#app',
  router,
  store,
  render: h => h(App),
  components: { App }
})
