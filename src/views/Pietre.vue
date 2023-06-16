<template>
  <div class="admin">
    <NavbarAdmin v-if="$session.get('tipo')=='BE'"  />
    <Navbar v-else  />
<Pietre />
  </div>
</template>


<script>
// @ is an alias to /src
 import NavbarAdmin from '../components/NavbarAdmin.vue'
 import Navbar from '../components/Navbar.vue'

  import  Pietre from '../components/Pietre.vue'

export default {
  name: 'PietreView',
  components: {
    NavbarAdmin,
    Navbar,
    Pietre
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
