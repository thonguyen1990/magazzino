<template>
  <b-container>
    <div class="ml-auto">
      <b-form @submit="submitPass"  style="margin-top:20em">

        <label class="mr-sm-12" for="inline-form-custom-select-pref">
          Utente
          <b-form-input  type="text" id="username" name="username" v-model="myUser" ref="myUser"></b-form-input>
        </label>
        <label class="mr-sm-12" for="inline-form-custom-select-pref">
          Password
          <b-form-input  type="password" id="pswAdm" name="pswAdm" v-model="myPass" ref="pswAdm"></b-form-input>
        </label>

        <br>
        <b-button  style="" type="submit" >Accedi</b-button>
      </b-form>


      <b-form id="frmLogIn">
        <input type="hidden"  name="url" id="url" v-model="url">
      </b-form>

    </div>





  </b-container>


</template>

<script>
import axios from "axios";

export default {
  data() {
    return {
      myUser: '',
      myPass: '',
      url:'',
    };
  },
  mounted() {
    this.url=this.$store.state.settings.URL_WEBAPP;

  },
  methods: {
    submitPass(event){
      event.preventDefault();
      let formData = new FormData();
      formData.append('user', this.myUser);
      formData.append('login', this.myPass);
      axios.post( this.$store.state.settings.URL_SERVER+'API/login.php', 
      formData,
      {
        headers: {
          'Content-Type': 'multipart/form-data'
        }
      }
    ).then(response => {

      console.log(response);

      if(response.data.login[0].stato){
        this.$session.start()
        this.$session.set('AD', 'yes');
        this.$session.set('secret', 'AAAAA');
        this.$session.set('vetrina', response.data.login[0].vetrina);

        this.$session.set('PAS', this.myPass);
        this.$session.set('USR',  response.data.login[0].user);
        this.$session.set('ID_USR',  response.data.login[0].id_user);
          this.$session.set('AUTORIZZAZIONI',  response.data.login[0].autorizzazioni);
      //  this.$session.set('BasicAuth', 'Basic ' + btoa('usr:' + this.myPass));
      // this.$session.set('BasicAuth', 'Basic ' + btoa('usr:' + this.myPass));
       this.$session.set('BasicAuth', 'Basic ' + btoa(this.myUser+':' + this.myPass));
       axios.defaults.headers.common['Authorization'] =this.$session.get('BasicAuth')
       axios.defaults.headers.common['Access-Control-Allow-Origin'] = this.$store.state.settings.URL_WEBAPP;

       this.$router.replace('/')

      /*** FUNZIONAVA SOLO SU WIN
        this.$store.commit('impostaAdmin',response.data.login[0].stato);
        window.location.href = this.$store.state.settings.PROTOCOLLO+'usr:'+this.myPass+'@'+this.$store.state.settings.SERVER_NAME+'API/img/authMe.php?url='+this.$store.state.settings.URL_WEBAPP;
*/
      //  this.url=this.$store.state.settings.URL_WEBAPP;

//        let form =document.getElementById("frmLogIn");
//        form.action = this.$store.state.settings.PROTOCOLLO+'usr:'+this.myPass+'@'+this.$store.state.settings.SERVER_NAME+'API/img/authMe.php';
//        form.method = 'GET';

    //    let myu =document.getElementById("url").value;

    //    alert(myu)
 //   form.submit();
  /*
        axios.get( this.$store.state.settings.URL_SERVER+'API/img/authMe.php', {},{
          auth: {
            username: 'usr',
            password: '****0'
          }

        }).then(function() {
          console.log('Authenticated');
          //  axios.defaults.headers.common['Authorization'] =this.$session.get('BasicAuth')

          this.$router.push({ name: 'Home' });
        }).catch(function() {
          console.log('Error on Authentication');
        });


        //  console.log(this.$store.state.settings.PROTOCOLLO+'ciao:ciao@'+this.$store.state.settings.SERVER_NAME+'API/img/authMe.php?url='+this.$store.state.settings.URL_WEBAPP);
        //  window.location.href = this.$store.state.settings.PROTOCOLLO+'usr:'+this.myPass+'@'+this.$store.state.settings.SERVER_NAME+'API/img/authMe.php?url='+this.$store.state.settings.URL_WEBAPP;

        axios.post(this.$store.state.settings.URL_SERVER+'API/img/authMe.php', {
        withCredentials: true,
        headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json'
      }
    },{
    auth: {
    username: "usr",
    password: "$2a$10$0V4Z0Yf7j7PKzo5KFIXY6egcKfcBtobUzVAMFYHArXZQpfWLU60OS"
  }
}).then(function() {
console.log('Authenticated');
this.$router.push({ name: 'Home' });
}).catch(function() {
console.log('Error on Authentication');
});*/

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
