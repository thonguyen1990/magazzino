<template>
  <b-container fluid>
    <loading :active.sync="isLoading"
    :can-cancel="true"
    :is-full-page="true"></loading>
    <b-alert  v-if="showAlertSuccess" variant="success" show>Completato!</b-alert>
    <b-alert v-if="showAlertFail" variant="warning" show>Errore!</b-alert>
    <h2>ESPORTA INTERO DATABASE</h2>
    <b-button type="button" @click="esportaDBintero()" variant="primary">BACKUP DATABASE COMPLETO</b-button>
    <hr>
    <b-row>
      <b-col >
        <h2>ESPORTA  VISITE/VENDITE o LAVORAZIONI</h2>

        <b-form @submit="onSubmitModificaDB">
          <b-form-select id="input-tipoBackuo" v-model="formDB.tipo" :options="optionsTipo" required>
            <template #first>
              <b-form-select-option :value="null" disabled>-- Seleziona un'opzione --</b-form-select-option>
            </template>
          </b-form-select>

          <b-form-group label="Da:" label-for="input-formDa">
            <b-form-datepicker id="input-formDa"  today-button reset-button v-model="formDB.dataInizio" class="mb-2" ></b-form-datepicker>
          </b-form-group>

          <b-form-group label="A:" label-for="input-formA">
            <b-form-datepicker id="input-formA"  today-button reset-button v-model="formDB.dataFine" class="mb-2" ></b-form-datepicker>
          </b-form-group>
          <b-button type="submit" variant="primary">SCARICA DATI DAL DATABASE</b-button>  <b-button type="button" variant="danger" @click="eliminaDati()" >ELIMINA DATI DAL DATABASE</b-button> <b-button type="button" variant=""  @click="resetForm()" >PULISCI FORM</b-button>


        </b-form>
      </b-col>
    </b-row>
    <hr>
    <h2>IMPORTA  VISITE/VENDITE o LAVORAZIONI</h2>
    <b-form>
      <label class="mr-sm-12" for="inline-form-custom-select-pref">
        <input class="ml-2" type="file" id="file" ref="file" v-on:change="handleFileUpload()"/>
      </label>
      <b-button v-on:click="submitFile()">Carica File</b-button>
    </b-form>



    <div style="float:right">
      <b-icon  icon="shield-fill"  font-scale="2" style="margin-right:0.5em;margin-top:2em" @click="reset();"></b-icon>
    </div>
  </b-container>



</template>




<script>
import axios from "axios";

export default {
  components: {
  },
  data() {
    return {
      hrefBackup:'',
      showAlertSuccess:false,
      showAlertFail:false,
      isLoading: false,
      formDB:{tipo:'',dataInizio:null,dataFine:null},
      optionsTipo:[{value:"VV",text:"Visite e Vendite [in base alla data di vendita/visita]"},
      {value:"LAVORAZIONI",text:"Lavorazioni [SOLO consegnati e in base alla data di ultima modifica]"}],
      file:'',
    };
  },

  mounted() {
    this.hrefBackup=this.$store.state.settings.URL_SERVER+"API/autobackup.php";
  },
  methods: {
    esportaDBintero(){
      let formData = new FormData();
      formData.append('tipo','completo');
      axios.post(this.$store.state.settings.URL_SERVER+"API/autobackup.php",
      formData,
      {
        headers: {
          'Content-Type': 'multipart/form-data'
        }
      }
    ).then((response) => {
      /*QUESTO BLOCCO UTILIZZATO PER SCARICARE DIRETTAMENTE IL FILE (PREVIA MODFICA BACKEND)*/
      let nomeBackup='DB_backupCompleto.sql';
      const url = window.URL.createObjectURL(new Blob([response.data]));
      const link = document.createElement('a');
      link.href = url;
      link.setAttribute('download', nomeBackup);
      document.body.appendChild(link);
      link.click();
      this.sendAlert('success');
    })
    .catch(err => {
      console.log(err);
      this.sendAlert('fail');
    });
  },
  onSubmitModificaDB(){
    let formData = new FormData();
    formData.append('tipo', this.formDB.tipo);
    formData.append('dataInizio', this.formDB.dataInizio);
    formData.append('dataFine', this.formDB.dataFine);

    axios.post(this.$store.state.settings.URL_SERVER+"API/autobackup.php",
    formData,
    {
      headers: {
        'Content-Type': 'multipart/form-data'
      }
    }
  ).then((response) => {

    /*QUESTO BLOCCO UTILIZZATO PER SCARICARE DIRETTAMENTE IL FILE (PREVIA MODFICA BACKEND)*/
    let nomeBackup='DB_backupCompleto.sql';
    if(this.formDB.tipo=='VV') nomeBackup='DB_visite_vendite.sql';
    if(this.formDB.tipo=='LAVORAZIONI') nomeBackup='DB_lavorazioni.sql';
    const url = window.URL.createObjectURL(new Blob([response.data]));
    const link = document.createElement('a');
    link.href = url;
    link.setAttribute('download', nomeBackup);
    document.body.appendChild(link);
    link.click();


    //    this.formDB.tipo = '';
    //    this.formDB.dataInizio = null;
    //    this.formDB.dataFine = null;
    this.sendAlert('success');
  })
  .catch(err => {
    console.log(err);
    this.sendAlert('fail');
  });

},
reset(){
  this.$confirm(
    {
      message: '!!ATTENZIONE!! CONFERMI ?',
      button: {
        no: 'No',
        yes: 'Si'
      },
      /**
      * Callback Function
      * @param {Boolean} confirm
      */
      callback: confirm => {
        if (confirm) {
          let formData = new FormData();
          formData.append('rst','true');

          axios.post(this.$store.state.settings.URL_SERVER+"API/v1.php",
          formData,
          {
            headers: {
              'Content-Type': 'multipart/form-data'
            }
          }
        ).then(() => {
          this.sendAlert('success');
          this.$session.set('vetrina', '1');
           this.$router.replace({ name: 'vetrina' });
        })
        .catch(err => {
          console.log(err);
          this.sendAlert('fail');
        });

      }
    }
  }
)
},
eliminaDati(){
  let tabella='';
  if(this.formDB.tipo=='VV'){
    tabella='Visite e Vendite';
  }
  if(this.formDB.tipo=='LAVORAZIONI'){
    tabella='Lavorazioni';
  }

  if(tabella!=''){

    this.$confirm(
      {
        message: 'ATTENZIONE!! Eliminare tutti i dati ( '+tabella+' ) [DA: '+ this.formDB.dataInizio+ ' A: '+ this.formDB.dataFine+ ']?',
        button: {
          no: 'No',
          yes: 'Si'
        },
        /**
        * Callback Function
        * @param {Boolean} confirm
        */
        callback: confirm => {
          if (confirm) {
            let formData = new FormData();
            formData.append('tipo', this.formDB.tipo);
            formData.append('dataInizio', this.formDB.dataInizio);
            formData.append('dataFine', this.formDB.dataFine);
            formData.append('eliminaDati','true');

            axios.post(this.$store.state.settings.URL_SERVER+"API/autobackup.php",
            formData,
            {
              headers: {
                'Content-Type': 'multipart/form-data'
              }
            }
          ).then(() => {

            //    this.formDB.tipo = '';
            //    this.formDB.dataInizio = null;
            //    this.formDB.dataFine = null;
            this.sendAlert('success');
          })
          .catch(err => {
            console.log(err);
            this.sendAlert('fail');
          });

        }
      }
    }
  )
}else{
  alert("Seleziona una tabella")
}
},
resetForm(){
  this.formDB.tipo = '';
  this.formDB.dataInizio = null;
  this.formDB.dataFine = null;
},
submitFile(){
  let formData = new FormData();
  formData.append('file', this.file);
  formData.append('tipo', 'IMPORTA');

  axios.post(this.$store.state.settings.URL_SERVER+'API/autobackup.php',
  formData,
  {
    headers: {
      'Content-Type': 'multipart/form-data'
    }
  }
).then(() => {
  this.file = '';
  this.$refs.file.value=null;


  this.sendAlert('success');
})
.catch(err => {
  console.log(err);
  this.sendAlert('fail');
});

},
handleFileUpload(){
  this.file = this.$refs.file.files[0];
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
}
};
</script>
