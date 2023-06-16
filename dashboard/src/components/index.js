import Vue from 'vue'
import vSelect from 'vue-select'

//Components
import Alert from './Alert.vue'
import Buttons from './Buttons.vue'
import Badges from './Badges.vue'
import AnimateNumber from './AnimateNumber.vue'
import Tables from './tables/Tables.vue'

//Progress Bars
import ProgressBars from './ProgressBars.vue'
import BootstrapProgressBar from './progressbar/BootstrapProgressBar.vue'

//import Tabs from './Tabs.vue'


//Importing Custom Components
import SidebarCollapse from './sidebar/SidebarCollapse.vue';
import CardTemplate from './widgets/CardTemplate.vue'

// Pages



// Table
import Vuetable from 'vuetable-2'
Vue.use(Vuetable)



// Registered Components
Vue.component( 'basix-alert', Alert)
Vue.component( 'sidebar-collapse', SidebarCollapse )
Vue.component( 'card', CardTemplate )
Vue.component( 'v-select', vSelect )
Vue.component( 'basix-counter', AnimateNumber )
Vue.component( 'bootstrap-progress-bar', BootstrapProgressBar )
Vue.component( 'vuetable-pagination', Vuetable.VuetablePagination )


export {
  Alert,
  SidebarCollapse,
  CardTemplate,
  AnimateNumber,
  ProgressBars,
  BootstrapProgressBar,
  Tables
}
