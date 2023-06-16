<template>
  <div class="admin">
    <NavbarAdmin />
<Conti />
  </div>
</template>


<script>
// @ is an alias to /src
 import NavbarAdmin from '../components/NavbarAdmin.vue'
  import Conti from '../components/Conti.vue'

export default {
  name: 'ContiView',
  components: {
    NavbarAdmin,
    Conti
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
