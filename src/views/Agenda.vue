<template>
  <div>
    <NavbarAdmin />
    <b-container fluid>
      <Agenda />
    </b-container>
  </div>
</template>


<script>
// @ is an alias to /src
 import NavbarAdmin from '../components/NavbarAdmin.vue'
  import Agenda from '../components/Agenda.vue'



export default {
  name: 'AgendaView',
  components: {
    NavbarAdmin,
    Agenda,
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
<style>
  .bg-info{
  background-color: #0d3f42 !important;
}
</style>