import Vue from "vue";
import VueRouter from "vue-router";
import Home from "../views/Home.vue";
import AdminCategories from "../views/AdminCategories.vue";
import AdminProducts from "../views/AdminProducts.vue";
import AdminVendite from "../views/AdminVendite.vue";
import LoginAdmin from "../views/LoginAdmin.vue";
import RisultatiRicerca from "../views/RisultatiRicerca.vue";

Vue.use(VueRouter);

const routes = [
  {
    path: "/",
    name: "Home",
    component: Home,
  },
  {
    path: "/public",
    name: "Public",
    component: Home,
  },
  {
    path: "/livello/:livello",
    name: "Home",
    component: Home,
  },
  {
    path: "/livello/:livello/:genitore",
    name: "categorie",
    component: Home,
  },
  {
    path: "/admin",
    name: "Admin",
    component: LoginAdmin,
  },
  {
    path: "/adminProducts",
    name: "Admin Products",
    component: AdminProducts,
  },
  {
    path: "/adminCategories",
    name: "Admin Categorie",
    component: AdminCategories,
  },
  {
    path: "/vendite",
    name: "vendite",
    component: AdminVendite,
  },
  {
    path: "/search/:txt",
    name: "search",
    component: RisultatiRicerca,
  },
];

const router = new VueRouter({
  base: process.env.BASE_URL,
  routes,
});

export default router;
