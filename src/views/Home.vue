<template>
  <div class="home">
    <Navbar :key="$route.params.genitore" v-bind:idCategoria="$route.params.genitore" />
    <CardsL2 v-if="$route.params.livello==2"/>
    <Prodotti v-else-if="$route.params.livello==3"/>
    <ProdottoDettaglio v-else-if="$route.params.livello==4"/>
      <CardsHome v-else/>

  </div>
</template>

<script>

  import Navbar from '../components/Navbar.vue'
  import CardsHome from '../components/CardsHome.vue'
  import CardsL2 from '../components/CardsL2.vue'
  import Prodotti from '../components/Prodotti.vue'
  import ProdottoDettaglio from '../components/ProdottoDettaglio.vue'
  import RecentView from './RecentView.vue'
  export default {
    name: 'Home',
    components: {
      Navbar,
      CardsHome,
      CardsL2,
      Prodotti,
      ProdottoDettaglio,
      RecentView
    },
    beforeCreate: function () {
      if (!this.$session.exists()) {
        this.$router.replace('/login')
      }
      if(this.$session.get('vetrina')=='1'){
        this.$router.push({ name: 'vetrina' });
      }
    },
  }
</script>
