<template>
  <div class="s">
    <Navbar />

<Trovati/>
  </div>
</template>

<script>
// @ is an alias to /src

 import Navbar from '../components/Navbar.vue'
  import Trovati from '../components/Trovati.vue'
export default {
  name: 'rc',
  components: {
    Navbar,
Trovati
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
