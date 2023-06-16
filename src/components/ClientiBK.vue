<template>
  <b-container>
    <b-col>

      <div class="mx-auto mb-3 mt-1">
        <b-button v-b-modal.modal-nuovoCliente   @click="clearFormNuovoCliente()">NUOVO CLIENTE</b-button>
      </div>
      <b-alert  v-if="showAlertSuccess" variant="success" show>Completato!</b-alert>
      <b-alert v-if="showAlertFail" variant="warning" show>Errore!</b-alert>




      <table-component :data="clienti" size="xl">
        <table-column show="id" label="ID"></table-column>
        <table-column show="cognome" label="Cognome"></table-column>
        <table-column show="nome" label="Nome"></table-column>
        <table-column show="sconto" label="Sconto %"></table-column>
        <table-column show="telefono" label="Telefono"></table-column>
        <table-column show="indirizzo" label="Indirizzo"></table-column>
        <table-column show="email" label="Email"></table-column>
        <table-column show="note" label="Note"></table-column>
        <table-column  header-class="w-5" label="ATTIVO">
          <template slot-scope="row">
            <span v-if="row.attivo==1">SI</span><span v-else>NO</span>
          </template>
        </table-column>
        <table-column  header-class="w-5" label="-">
          <template slot-scope="row">
            <a @click="modificaCliente(row)">Modifica</a> | <a @click="eliminaCliente(row.id)">Elimina</a>
          </template>
        </table-column>
      </table-component>

    </b-col>

    <b-modal id="modal-nuovoCliente" hide-footer :title="titoloCliente" size="xl" >
      <b-form @submit="onSubmitNuovoCliente">

        <b-row>
          <b-col>
            <b-form-group label="Nome:" label-for="input-nome">
              <b-form-input id="input-nome" v-model="formNuovoCliente.nome" type="text"></b-form-input>
            </b-form-group>
          </b-col>
          <b-col >
            <b-form-group label="Cognome:" label-for="input-cognome">
              <b-form-input id="input-cognome" v-model="formNuovoCliente.cognome" type="text"></b-form-input>
            </b-form-group>
          </b-col>

        </b-row>

        <b-form-group label="Telefono:" label-for="input-telefono">
          <b-form-input id="input-telefono" v-model="formNuovoCliente.telefono" type="text"></b-form-input>
        </b-form-group>
        <b-form-group label="Email:" label-for="input-email">
          <b-form-input id="input-email" v-model="formNuovoCliente.email" type="email"></b-form-input>
        </b-form-group>
        <b-form-group label="Indirizzo:" label-for="input-indirizzo">
          <b-form-input id="input-indirizzo" v-model="formNuovoCliente.indirizzo" type="text"></b-form-input>
        </b-form-group>
        <b-form-group label="Sconto(%):" label-for="input-sconto">
          <b-form-input id="input-sconto" v-model="formNuovoCliente.sconto" type="number" step=".01"></b-form-input>
        </b-form-group>
        <b-form-group label="Note:" label-for="input-note">
          <b-form-input id="input-note" v-model="formNuovoCliente.note" type="text"></b-form-input>
        </b-form-group>
        <b-form-checkbox style="margin-bottom:3em;" v-model="formNuovoCliente.isAttivo" name="input-attivo"   id="input-attivo" switch>
          Attivo: <b>
            <span v-if="formNuovoCliente.isAttivo==true">SI</span>
            <span v-else>NO</span>
          </b>
        </b-form-checkbox>

        <b-button type="submit" variant="primary">SALVA</b-button>
      </b-form>
    </b-modal>

    <AddCliente @clienteAggiunto="getClienti()" ref="addClient"></AddCliente>


  </b-container>



</template>




<script>
import axios from "axios";
import AddCliente from '../components/AddCliente.vue'

export default {
  components: {
    AddCliente
  },
  data() {
    return {
      clienti: [],
      formNuovoCliente:{id:0,cognome:'',nome:'',indirizzo:'',telefono:'',email:'',sconto:0,note:'',attivo:1,isAttivo:true},
      titoloCliente:'',
      showUploadingSpinner:false,
      showAlertSuccess:false,
      showAlertFail:false,

    };
  },

  mounted() {
    this.updateClientiTable();
  },
  methods: {
    updateClientiTable(){
      axios
      .get(this.$store.state.settings.URL_SERVER+"api/v1.php?clienti&secret="+this.$session.get('secret'))
      .then(response => {
        this.clienti = response.data.clienti;
        console.log(response);
      })
      .catch(err => {
        console.log(err);
      });
    },
    modificaCliente(row){
      this.clearFormNuovoCliente();
      this.titoloCliente="Modifica Cliente";
      this.formNuovoCliente.cognome=row.cognome;
      this.formNuovoCliente.nome=row.nome;
      this.formNuovoCliente.telefono=row.telefono;
      this.formNuovoCliente.email=row.email;
      this.formNuovoCliente.indirizzo=row.indirizzo;
      this.formNuovoCliente.sconto=row.sconto;
      this.formNuovoCliente.attivo=row.attivo;
      if(this.formNuovoCliente.attivo==1){
        this.formNuovoCliente.isAttivo=true;
      }else{
        this.formNuovoCliente.isAttivo=false;
      }
      this.formNuovoCliente.note=row.note;
      this.formNuovoCliente.id=row.id;
      this.$bvModal.show('modal-nuovoCliente')
    },
    eliminaCliente(id){
      axios
      .get(this.$store.state.settings.URL_SERVER+"api/v1.php?eliminaCliente&id="+id+"&secret="+this.$session.get('secret'))
      .then(response => {
        if (response.status === 200 && response.data.result=="OK") {
          this.sendAlert('success')
          this.updateClientiTable();
        }else{
          this.sendAlert('success')
        }
      })
      .catch(err => {
        console.log(err);
        this.sendAlert('fail');
      });
    },
    clearFormNuovoCliente(){
      this.titoloCliente="Nuovo Cliente"
      this.formNuovoCliente.cognome='';
      this.formNuovoCliente.nome='';
      this.formNuovoCliente.telefono='';
      this.formNuovoCliente.email='';
      this.formNuovoCliente.indirizzo='';
      this.formNuovoCliente.sconto=0;
      this.formNuovoCliente.attivo=1;
      this.formNuovoCliente.isAttivo=true;
      this.formNuovoCliente.id=0;
      this.formNuovoCliente.note='';
    },
    onSubmitNuovoCliente(){
      event.preventDefault();
      this.$set(this.formNuovoCliente, 'azione', 'nuovoCliente');
      this.$set(this.formNuovoCliente, 'secret', this.$session.get('secret'));
      this.formNuovoCliente.attivo = (this.formNuovoCliente.isAttivo==true) ? 1 : 0;

      axios.post( this.$store.state.settings.URL_SERVER+"API/v1.php",this.toFormData(this.formNuovoCliente), {
        headers: {
          'Content-Type': 'application/json'
        }
      }).then(response => {
        if (response.status === 200 && response.data.result=="OK") {
          this.sendAlert('success')
          this.clearFormNuovoCliente();
          this.updateClientiTable();
        }else{
          this.sendAlert('success')
        }

      })
      .catch(err => {
        console.log(err);
        this.sendAlert('fail');
      });

      this.clearFormNuovoCliente();
      this.$bvModal.hide('modal-nuovoCliente')
    },
    sendAlert(state){
      if(state=='success'){
        this.showAlertSuccess=true;
        setTimeout(()=>this.showAlertSuccess=false,4000);
      }else if(state=='fail'){
        this.showAlertFail=true;
        setTimeout(()=>this.showAlertFail=false,4000);
      }
    },
    toFormData: function(obj) {
      let formData = new FormData();
      for(let key in obj) {
        formData.append(key, obj[key]);
      }
      return formData;
    },



  }
};
</script>
