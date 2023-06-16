<template>
  <div class="admin">
    <NavbarAdmin />
<VenditeVisite />
  </div>
</template>


<script>
// @ is an alias to /src
 import NavbarAdmin from '../components/NavbarAdmin.vue'
  import VenditeVisite from '../components/VenditeVisite.vue'

export default {
  name: 'VenditeVisiteView',
  components: {
    NavbarAdmin,
    VenditeVisite
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
