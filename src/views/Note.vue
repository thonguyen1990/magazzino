<template>
  <div class="home">
    <Navbar />

    <Note/>

  </div>
</template>

<script>
// @ is an alias to /src

 import Navbar from '../components/Navbar.vue'
import Note from '../components/Note.vue'

export default {
  name: 'NoteView',
  components: {
    Navbar,
    Note
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
