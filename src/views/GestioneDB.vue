<template>
  <div class="admin">
    <NavbarAdmin />
<GestioneDB />
  </div>
</template>


<script>
// @ is an alias to /src
 import NavbarAdmin from '../components/NavbarAdmin.vue'
  import GestioneDB from '../components/GestioneDB.vue'

export default {
  name: 'GestioneDBView',
  components: {
    NavbarAdmin,
    GestioneDB
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
