<template>
  <b-container>
    <div class="ml-auto">
      <b-form @submit="submitPass" >

         <label class="mr-sm-12" for="inline-form-custom-select-pref">
        Password amministratore
         <b-form-input id="pswAdm" name="pswAdm" v-model="myPass" ref="pswAdm"></b-form-input>
         </label>


        <b-button type="submit" >Accedi</b-button>
      </b-form>

  </div>





  </b-container>


</template>

<script>
import axios from "axios";

export default {
  data() {
    return {
      myPass: '',
    };
  },
  mounted() {
  },
  methods: {
    submitPass(){
      event.preventDefault();
      let formData = new FormData();
      formData.append('loginAdmin', this.myPass);
      axios.post( this.$store.state.settings.URL_SERVER+'API/v1.php',
        formData,
        {
          headers: {
              'Content-Type': 'multipart/form-data'
          }
        }
      ).then(response => {

        console.log(response.data.login);

        if(response.data.login[0].stato){
          this.$session.start()
          this.$session.set('AD', 'yes');
          this.$session.set('secret', 'AAAAA');

          this.$store.commit('impostaAdmin',response.data.login[0].stato);
          this.$router.push({ name: 'Admin Products' });
        }
        this.myPass='';
      })
      .catch(err => {
        console.log(err);
      });
    }
  }
};
</script>
