import Vue from "vue";
import Vuex from "vuex";

Vue.use(Vuex);

export default new Vuex.Store({
  state: {
    settings: {},
    admin: false,
  },
  mutations: {
    impostaSetting(state, payload) {
      state.settings = payload;
      //  console.log(state.settings.URL_SERVER);
    },
    impostaAdmin(state, payload) {
      state.admin = payload;
      //  console.log(state.settings.URL_SERVER);
    },
  },
  actions: {},
  modules: {},
});
