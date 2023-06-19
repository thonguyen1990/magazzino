import Vue from "vue";
import App from "./App.vue";
import router from "./router";
import store from "./store";
import axios from "axios";

import BootstrapVue from "bootstrap-vue";
import "bootstrap/dist/css/bootstrap.css";
import "bootstrap-vue/dist/bootstrap-vue.css";
import TableComponent from "vue-table-component";
import "vue-search-select/dist/VueSearchSelect.css";
import "vue2-datepicker/index.css";
import VueSession from "vue-session";
import Chartkick from "vue-chartkick";
import Chart from "chart.js";
import { IconsPlugin } from "bootstrap-vue";
import VueConfirmDialog from "vue-confirm-dialog";
import Loading from "vue-loading-overlay";
import "vue-loading-overlay/dist/vue-loading.css";
import VueAuthImage from "vue-auth-image";
import VueImg from "v-img";
import VueInputCalculator from "vue-input-calculator";
import { BIcon } from "bootstrap-vue";
Vue.component("b-icon", BIcon);

Vue.component("vue-input-calculator", VueInputCalculator);

//Vue.use(Loading)
Vue.component("loading", Loading);

Vue.use(VueConfirmDialog);
Vue.component("vue-confirm-dialog", VueConfirmDialog.default);

Vue.use(IconsPlugin);
Vue.use(Chartkick.use(Chart));
Vue.use(VueAuthImage);
Vue.use(VueImg);

var sessionOptions = {
  persist: true,
};
Vue.use(VueSession, sessionOptions);

Vue.use(TableComponent, {
  tableClass: "table table-striped",
  theadClass: "",
  tbodyClass: "",
  filterPlaceholder: "Filtra i risultati…",
  filterNoResults: "Nessuna corrispondenza",
});
Vue.use(BootstrapVue);
Vue.use(require("vue-moment"));

Vue.config.productionTip = false;

Vue.filter("valuta", function (value) {
  var parts = value.toString().split(".");
  if (parts[0] == 0) {
    return "";
  }
  parts[0] = parts[0].replace(/\B(?=(\d{3})+(?!\d))/g, ".");
  return parts.join(",") + " €";
});
Vue.filter("bTokb", (val) => {
  return Math.floor(val / 1024);
});
Vue.filter("noDecimali", (val) => {
  return parseFloat(val).toFixed(0);
});

Vue.filter("toCT", function (value) {
  if (value == 0) {
    return "";
  }
  value = "Ct " + value;
  return value;
});
Vue.filter("dataITA", function (value) {
  if (value == null) {
    return "";
  }
  var parts = value.toString().split("-");
  if (parts[0] == "") {
    return "";
  }
  return parts[2] + "/" + parts[1] + "/" + parts[0];
});
Vue.filter("rimuoviVetrina", function (value) {
  var parts = value.split(" ");
  if (parts[0].toUpperCase().indexOf("VETRIN") != -1) {
    var str = "";
    for (let i = 1; i < parts.length; i++) {
      str = str + parts[i];
      if (i < parts.length - 1) str = str + " ";
    }
    return str;
  }

  return value;
});

import Lingallery from "lingallery";
Vue.component("lingallery", Lingallery);

import ProductZoomer from "vue-product-zoomer";
Vue.use(ProductZoomer);

axios.get("./settings.json").then((response) => {
  store.commit("impostaSetting", response.data);
  new Vue({
    router,
    store,
    render: (h) => h(App),
  }).$mount("#app");
});
