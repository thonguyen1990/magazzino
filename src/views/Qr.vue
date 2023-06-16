<template>
  <div class="home">
  </div>
</template>

<script>
import axios from "axios";

export default {
  name: 'QrView',
  components: {

  },beforeCreate: function () {
     if (!this.$session.exists()) {
       this.$router.replace('/login')
     }
     if(this.$session.get('vetrina')=='1'){
       this.$router.push({ name: 'vetrina' });
     }
    },
    mounted(){
        axios
        .get(this.$store.state.settings.URL_SERVER+"API/v1.php?itemIDfromXlsID="+this.$route.params.qr)
        .then(response => {
          let myId=response.data.itemID[0].id
          if(myId>0)
          this.$router.replace({ name: 'categorie', params: { livello: '4', genitore:myId } });

        })
        .catch(err => {
          console.log(err);
        });
    }
}
</script>
