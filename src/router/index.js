import Vue from 'vue'
import VueRouter from 'vue-router'
import Home from '../views/Home.vue'
import AdminCategories from '../views/AdminCategories.vue'
import AdminProducts from '../views/AdminProducts.vue'
//import AdminStats from '../views/AdminStats.vue'
import LoginAdmin from '../views/LoginAdmin.vue'
import Login from '../views/Login.vue'

import Logout from '../views/logout.vue'
import RisultatiRicerca from '../views/RisultatiRicerca.vue'
import Clienti from '../views/Clienti.vue'
import Riparazioni from '../views/Riparazioni.vue'
import Agenda from '../views/Agenda.vue'
import Favoriti from '../views/Favoriti.vue'
import VenditeVisite from '../views/VenditeVisite.vue'
import GestioneDB from '../views/GestioneDB.vue'
import Vetrina from '../views/Vetrina.vue'
import Diamanti from '../views/Diamanti.vue'
import Pietre from '../views/Pietre.vue'
import Conti from '../views/Conti.vue'
import NuoviArrivi from '../views/NuoviArrivi.vue'
import Note from '../views/Note.vue'
import Qr from '../views/Qr.vue'
import Notifiche from '../views/Notifiche.vue'
import GestioneVetrine from '../views/GestioneVetrine.vue'
import Laboratorio from '../views/Laboratorio.vue'
  import SplitHome from '../components/SplitHome.vue'
  import RecentView from '../views/RecentView.vue'





Vue.use(VueRouter)

  const routes = [

    {
      path: '/',
      name: 'Home',
      component: Home
    },
    {
      path: '/recent-vue',
      name: 'Recent Vue',
      component: RecentView
    },
    {
      path: '/split-vue',
      name: 'Split Vue',
      component: SplitHome
    },
    {
      path: '/public',
      name: 'Public',
      component: Home
    },
    {
      path: '/livello/:livello',
      name: 'Home',
      component: Home
    },
  {
    path: '/livello/:livello/:genitore',
    name: 'categorie',
    component: Home
  },
  {
    path: '/qr/:qr',
    name: 'qr',
    component: Qr
  },
  {
      path: '/favoriti',
      name: 'Favoriti',
      component: Favoriti
  },
  {
      path: '/nuoviarrivi',
      name: 'NuoviArrivi',
      component: NuoviArrivi
  },
  {
    path: '/admin',
    name: 'Admin',
    component: LoginAdmin
  },
  {
    path: '/logout',
    name: 'Logout',
    component: Logout
  },
  {
    path: '/login',
    name: 'login',
    component: Login
  },
  {
      path: '/clienti/:promemoria?',
      name: 'Clienti',
      component: Clienti
  },
  {
      path: '/riparazioni/:tipo?',
      name: 'Riparazioni',
      component: Riparazioni
  },
  {
      path: '/agenda',
      name: 'Agenda',
      component: Agenda
  },
  {
      path: '/conti',
      name: 'Conti',
      component: Conti
  },
  {
      path: '/note',
      name: 'Note',
      component: Note
  },
  {
      path: '/notifiche',
      name: 'Notifiche',
      component: Notifiche
  },
  {
    path: '/adminProducts',
    name: 'Admin Products',
    component: AdminProducts
  },
  {
    path: '/diamanti/:disponibilita?',
    name: 'Diamanti',
    component: Diamanti
  },
  {
    path: '/pietre/:pietra/:disponibilita?',
    name: 'Pietre',
    component: Pietre
  },
  {
    path: '/adminCategories',
    name: 'Admin Categorie',
    component: AdminCategories
  },
  {
    path: '/gestioneDB',
    name: 'GestioneDB',
    component: GestioneDB
  },
  {
    path: '/statsVV',
    name: 'statsVV',
    component: VenditeVisite
  },
  {
    path: '/vetrina',
    name: 'vetrina',
    component: Vetrina
  },
  {
    //path: '/search/:txt/:fasciap1/:fasciap2/:fasciact1/:fasciact2/:classici/:classiciColorati/:anelli/:braccialetti/:ciondoli/:orecchini/:oroRosa/:oroBianco/:catAttuale',
    path: '/search/:txt/:fasciap1/:fasciap2/:fasciact1/:fasciact2/:filtroTipoClassici/:filtroTipoTipo/:filtroTipoMateriale/:catAttuale',

    name: 'search',
    component: RisultatiRicerca
  },
  {
    path: '/gestioneVetrine',
    name: 'gestioneVetrine',
    component: GestioneVetrine
  },
  {
    path: '/laboratorio',
    name: 'laboratorio',
    component: Laboratorio
  },

]

const router = new VueRouter({
  //mode: 'history',
  base: process.env.BASE_URL,
  routes
})

export default router
