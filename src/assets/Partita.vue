<template>
<Eventi/>
</template>

<script>
// @ is an alias to /src
import Eventi from '../components/Eventi.vue'
export default {
  name: 'Partita',
  data() {
    return {
    };
  },
  beforeCreate: function () {
   if (!this.$session.exists()) {
     this.$router.replace('/login')
   }
  },
  components: {
    Eventi

  }
}
</script>
