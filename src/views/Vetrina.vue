<template>
  <div class="home">
    <Vetrina />
  </div>
</template>

<script>
// @ is an alias to /src

import Vetrina from '../components/Vetrina.vue'

export default {
  name: 'VetrinaView',
  components: {
    Vetrina

  },beforeCreate: function () {
     if (!this.$session.exists()) {
       this.$router.replace('/login')
     }
     if(this.$session.get('vetrina')=='1'){
       this.$router.push({ name: 'vetrina' });
     }
    },
}
</script>
