<template>
  <div id="app">
    <vue-confirm-dialog></vue-confirm-dialog>



  <!--      <div id="nav">
  <router-link to="/">Home</router-link> |
      <router-link to="/adminProducts">Admin</router-link>
    </div>-->
    <router-view/>
  </div>
</template>
<script>
import axios from "axios";


//import myConfig from '../public/settings.json'

export default{
  beforeMount() {
    if((this.$session.get('BasicAuth'))){
      console.log("SESSION is: "+this.$session.get('BasicAuth'))
      axios.defaults.headers.common['Authorization'] =this.$session.get('BasicAuth')
      axios.defaults.headers.common['Access-Control-Allow-Origin'] = this.$store.state.settings.URL_WEBAPP;


    }else{
      console.log("NO SESSIONE")
      this.$router.replace({name: 'Logout'});
    }

  //  this.$store.commit('impostaSetting', this.$config);
//console.log(this.$config.KEY);
  /*  this.$store.commit('impostaSetting', myConfig);
     axios.get('./settings.json')
       .then((response) => {
          //console.log(response);
        //  console.log(response.data.URL_SERVER);
          this.$store.commit('impostaSetting', response.data);
            this.$router.replace({name: 'Public'});
//Vue.set(state.settings, 0, response.data);
        //    store.settings = response.data;
      });*/

  },
mounted() {

 if(this.$session.get('vetrina')=='1'){
   this.$router.push({ name: 'vetrina' });
 }

},

}
</script>
<style>

@import './assets/styles.css';

</style>
