<template>
  <b-container fluid>
    <loading :active.sync="isLoading"
    :can-cancel="true"
    :is-full-page="true"></loading>
    <b-col>
      <b-row>
        <b-col>
          <div class="mx-auto mb-3 mt-1">
            <b-button v-b-modal.modal-nuovoLAB style="float:right; margin-left:2em;margin-bottom:1em" variant="success"   @click="clearformNuovaLavorazione()" class="btn-outline-success btn-sm"><b-icon icon="plus"></b-icon>NUOVO</b-button>

          </div>
        </b-col>
        <b-col>
        <a  v-if="this.$session.get('AUTORIZZAZIONI').numeri_telefono >= 1" style="float:right" v-bind:href="$store.state.settings.URL_SERVER+'API/esportaXLSX.php?esportaLaboratorio&secret='+$session.get('secret')" target="_blank">
          <img   width="60" alt="downloadXLSX"    src="../assets/xlsx.png" />
        </a>
        </b-col>
      </b-row>
      <b-alert  v-if="showAlertSuccess" variant="success" show>Completato!</b-alert>
      <b-alert v-if="showAlertFail" variant="warning" show>Errore!</b-alert>



      <table-component :data="laboratorio" responsive @rowClick="dettaglioRiparazione" filter-input-class="classeFiltro">
        <!--  <table-column show="id" label="ID"></table-column>-->
        <table-column  header-class="w-5" label="Azioni    ">
          <template slot-scope="row">
          <b-row>
            <img  class="azione" width="20" alt="EditN" @click.stop="copiaPerStampa(row.id)"   src="../assets/printer.png"/>
            <!--<a   v-bind:href="$store.state.settings.URL_SERVER+'API/printLAB.php?id='+row.id+'&secret='+$session.get('secret')" target="_blank">
              <img  class="azione" width="20" alt="EditN" @click.stop=""   src="../assets/printer.png"/>
            </a>-->
            <img  class="azione" width="20" alt="EditN" @click.stop="modificaRiparazione(row)"   src="../assets/detail.png" />
            <a href="mailto:"  @click.stop=""  ><img  class="azione" width="20" alt="email" src="../assets/mail.png" /></a>


            <img class="azione" width="20" alt="x" @click.stop="eliminaRiparazione(row.id)"  src="../assets/del.png" style="margin-left:1em" />
          </b-row>
          </template>
        </table-column>
        <table-column show="progressivo" label="#"></table-column>
        <table-column show="data" label="Ricevuto">
          <template slot-scope="row">
            {{row.data | dataITA}}
          </template>
        </table-column>
        <table-column show="qnt" label="Qnt"></table-column>
  <!--      <table-column show="carati" label="Ct"></table-column> -->
        <table-column show="tipo" label="Tipo"></table-column>
    <!--    <table-column show="caratteristiche" label="Caratteristiche"></table-column> -->
        <!-- <table-column show="grammi" label="Gr."></table-column> -->
        <table-column show="modello" label="Mod."></table-column>
        <table-column show="codice" label="Cod."></table-column>
    <!--       <table-column show="riferimento" label="Rif."></table-column>
     <table-column show="pietre" label="Pietre"></table-column> -->
        <!-- <table-column show="fornitore" label="Fornitore"></table-column> -->
    <!--    <table-column show="scarico" label="Scarico"></table-column>
        <table-column show="nota" label="Nota"></table-column> -->
<!--        <table-column  header-class="w-5" label="Costi">
          <template slot-scope="row">
          <b-col>
            <p v-if="row.cIncassatura!=null">incassatura: {{row.cIncassatura}}</p>
            <p v-if="row.cFusione!=null">Fusione: {{row.cFusione}}</p>
            <p v-if="row.cOrafo!=null">Orafo: {{row.cOrafo}}</p>
            <p v-if="row.cDisegno!=null">Disegno: {{row.cDisegno}}</p>
            <p v-if="row.cVarie!=null">Varie: {{row.cVarie}}</p>
          </b-col>
          </template>
        </table-column> -->
        <table-column show="stato" label="stato"></table-column>
        <!-- <table-column show="flag" label="Tag">
          <template slot-scope="row">
            <b-icon v-if="row.flag=='1'"  icon="bookmarks-fill" variant="success"  font-scale="1.5" style="margin-left:0.5em"></b-icon>
          </template>
        </table-column> -->
        <table-column show="flagd" label="Prog">
          <template slot-scope="row">
            <a @click.stop="visualizzaProgetto(row)" v-if="row.imgs.length>0"><b-icon  icon="card-image"  font-scale="1" style="margin-left:0.5em"></b-icon></a>
          </template>
        </table-column>


      </table-component>

    </b-col>

    <b-modal id="modal-nuovoLAB" hide-footer :title="titoloRiparazione" size="xl" >
      <b-form @submit="onSubmitNuovoLAB">

        <b-tabs content-class="mt-3" v-model="panelIndex">
          <b-tab title="Informazioni" >

            <b-row>
              <b-col >
                <b-form-group label="Progressivo:" label-for="input-progressivo">
                  <b-form-input id="input-progressivo" v-model="formNuovoLAB.progressivo" class="mb-2" ></b-form-input>
                </b-form-group>
              </b-col>
              <b-col >
                <b-form-group label="Ricevuto:" label-for="input-data">
                  <b-form-datepicker id="input-data"  today-button reset-button v-model="formNuovoLAB.data" class="mb-2" ></b-form-datepicker>
                </b-form-group>
              </b-col>
              <b-col >
                <b-form-group label="Quantità:" label-for="input-qnt" >
                  <b-form-input  @focus.native="$event.target.select()" id="input-qnt" v-model="formNuovoLAB.qnt" type="number" step="1"></b-form-input>
                </b-form-group>
              </b-col>
              <b-col>
                <b-form-group label="Carati:" label-for="input-carati"  >
                   <b-input-group append="ct">
                  <b-form-input @focus.native="$event.target.select()" id="input-qnt" v-model="formNuovoLAB.carati" type="text"></b-form-input>
                </b-input-group>
                </b-form-group>
              </b-col>
            </b-row>
            <b-row>
              <b-col >
                <b-form-group label="Tipo:" label-for="input-tipo">
                <b-form-input @focus.native="$event.target.select()" id="input-tipo" v-model="formNuovoLAB.tipo" type="text"></b-form-input>
                </b-form-group>
              </b-col>
              <b-col >
                <b-form-group label="Caratteristiche:" label-for="input-caratteristiche">
                <b-form-input @focus.native="$event.target.select()" id="input-caratteristiche" v-model="formNuovoLAB.caratteristiche" type="text"></b-form-input>
                </b-form-group>
              </b-col>
              <b-col >
                <b-form-group label="Grammi:" label-for="input-grammi" >
                  <b-input-group append="g">
                  <b-form-input  @focus.native="$event.target.select()" id="input-grammi" v-model="formNuovoLAB.grammi" type="text"></b-form-input>
                    </b-input-group>
                </b-form-group>
              </b-col>
            </b-row>

            <b-row>
              <b-col>
                <b-form-group label="Modello:" label-for="input-modello">
                  <b-form-input id="input-modello" v-model="formNuovoLAB.modello" type="text"></b-form-input>
                </b-form-group>
              </b-col>
              <b-col>
                <b-form-group label="Codice:" label-for="input-codice">
                  <b-form-input id="input-codice" v-model="formNuovoLAB.codice" type="text"></b-form-input>
                </b-form-group>
              </b-col>
            </b-row>

            <b-row>
              <b-col>
                <b-form-group label="Riferimento:" label-for="input-riferimento">
                  <b-form-input id="input-riferimento" v-model="formNuovoLAB.riferimento" type="text"></b-form-input>
                </b-form-group>
              </b-col>
              <b-col>
                <b-form-group label="Pietre:" label-for="input-pietre">
                  <b-form-input id="input-pietre" v-model="formNuovoLAB.pietre" type="text"></b-form-input>
                  <!--<b-form-select id="input-pietre" v-model="formNuovoLAB.pietre" :options="optionsPietre">
                    <template #first>
                      <b-form-select-option :value="null" disabled>-- Seleziona un'opzione --</b-form-select-option>
                    </template>
                  </b-form-select>-->
                </b-form-group>
              </b-col>
              <!-- <b-col>
                <b-form-group label="Fornitore:" label-for="input-fornitore">
                  <b-form-input id="input-fornitore" v-model="formNuovoLAB.fornitore" type="text"></b-form-input> -->
                  <!--
                  <b-form-select id="input-fornitore" v-model="formNuovoLAB.fornitore" :options="optionsFornitore">
                    <template #first>
                      <b-form-select-option :value="null" disabled>-- Seleziona un'opzione --</b-form-select-option>
                    </template>
                  </b-form-select>-->
                <!-- </b-form-group>
              </b-col> -->
            </b-row>

            <b-row>
              <b-col cols="3">
                <b-form-group label="Scarico:" label-for="input-scarico">
                  <b-form-input id="input-scarico" v-model="formNuovoLAB.scarico" type="text"></b-form-input>
                </b-form-group>
              </b-col>
              <b-col>
                <b-form-group label="Nota:" label-for="input-nota">
                  <b-form-input id="input-nota" v-model="formNuovoLAB.nota" type="text"></b-form-input>
                </b-form-group>
              </b-col>
            </b-row>

            <b-row>
              <b-col>
                <b-form-group label="Costo Incassatura:" label-for="input-cIncassatura">
                  <b-form-input id="input-cIncassatura" v-model="formNuovoLAB.cIncassatura" type="number" step=".01"></b-form-input>
                </b-form-group>
              </b-col>
              <b-col>
                <b-form-group label="Costo Fusione:" label-for="input-cFusione">
                  <b-form-input id="input-cFusione" v-model="formNuovoLAB.cFusione" type="number" step=".01"></b-form-input>
                </b-form-group>
              </b-col>
              <b-col>
                <b-form-group label="Costo Orafo:" label-for="input-cOrafo">
                  <b-form-input id="input-cOrafo" v-model="formNuovoLAB.cOrafo" type="number" step=".01"></b-form-input>
                </b-form-group>
              </b-col>
              <b-col>
                <b-form-group label="Costo Disegno:" label-for="input-cDisegno">
                  <b-form-input id="input-cDisegno" v-model="formNuovoLAB.cDisegno" type="number" step=".01"></b-form-input>
                </b-form-group>
              </b-col>
              <b-col>
                <b-form-group label="Costo Varie:" label-for="input-cVarie">
                  <b-form-input id="input-cVarie" v-model="formNuovoLAB.cVarie" type="number" step=".01"></b-form-input>
                </b-form-group>
              </b-col>
            </b-row>

            <b-row>
              <b-col>
                <b-form-group label="Stato:" label-for="input-stato">
                  <b-form-select id="input-stato" v-model="formNuovoLAB.stato" :options="optionsStato">
                    <template #first>
                      <b-form-select-option :value="null" disabled>-- Seleziona un'opzione --</b-form-select-option>
                    </template>
                  </b-form-select>
                </b-form-group>
              </b-col>
              <b-col>
                <!-- <b-form-group label="Tag" label-for="input-tag">
                  <b-form-checkbox style="margin-bottom:3em;" v-model="formNuovoLAB.flag" name="input-tag"   id="input-tag" switch>
                      <span v-if="formNuovoLAB.flag==true"><b-icon  icon="bookmarks-fill" variant="success"  font-scale="1.5" style="margin-left:0.5em"></b-icon>SI</span>
                      <span v-else><b-icon  icon="bookmarks" variant="success"  font-scale="1.5" style="margin-left:0.5em"></b-icon> NO</span>
                  </b-form-checkbox>
                </b-form-group> -->

              </b-col>
            </b-row>



      </b-tab>
      <b-tab title="Progetto" v-model="panelIndex">
        <b-container>
          <b-row>

            <b-col v-bind:key="file.index" v-for="(file) in formNuovoLAB.fileCaricati">
              <b-img v-if="isImage(file.nome)" :src="file.src+'?'+$session.get('secret')" :alt="file.nome" fluid @click="zoom(file.src)"></b-img>
              <div v-else><a :src="file.src+'?'+$session.get('secret')" >{{file.nome}}</a></div>
              <img class="azione" width="20" alt="X"  @click="removeFileCaricato(file.id)" src="../assets/del.png">
            </b-col>
          </b-row>
        </b-container>
        <b-row>
          <!--  <ul>
          <li v-bind:key="file.index" v-for="(file) in formNuovaLavorazione.fileCaricati">
          {{ file.nome }}   <img class="azione" width="20" alt="X"  @click="removeFileCaricato(file.id)" src="../assets/del.png">
        </li>
      </ul>-->

      <b-col>
        <div class="uploaderDiv" v-cloak @drop.prevent="addFile" @dragover.prevent>
          <input type="file" name="file" ref="file" style="display: none" @change="addFileDialog">
          <p>Carica Immagini</p><button type="button" @click="$refs.file.click()">Apri finestra o Trascina</button>

          <ul>
            <li v-bind:key="file.index" v-for="file in files">
              {{ file.name }} ({{ file.size | bTokb }} kb) <img class="azione" width="20" alt="X"  @click="removeFile(file)" src="../assets/del.png">
            </li>
          </ul>

          <!--    <button :disabled="uploadDisabled" @click="upload">Upload</button> -->
        </div>
      </b-col>
    </b-row>
  </b-tab>
</b-tabs>

<b-button type="submit" variant="primary">SALVA</b-button>
<b-button type="button" variant="warning" style="float:right" @click="stampaNoSalva()">
  <img  class="azione" width="20" alt="print" src="../assets/printer.png"/>
  STAMPA (SENZA SALVARE)</b-button>
</b-form>
</b-modal>
<b-modal id="modal-dettaglioFoto" hide-footer  size="xl" >
  <b-container>
    <b-img :src="selectedImage+'?'+$session.get('secret')" alt="dett" fluid style="display: block;
    margin-left: auto;
    margin-right: auto;
    width: 100%;" ></b-img>
  </b-container>

</b-modal>



</b-container>



</template>




<script>
import axios from "axios";

export default {
  components: {
  },

  data() {
    return {
      nextProgrssivo:0,
      panelIndex:0,
      laboratorio:[],
      riparazioni: [],
      formNuovoLAB:{id:0, progressivo:null,data:'',qnt:1,carati:'',tipo:'',caratteristiche:'',grammi:'',modello:'',codice:'',riferimento:'',pietre:'',fornitore:'',scarico:'',nota:'',stato:'',flag:false,fileCaricati:[], cIncassatura:null, cFusione:null, cOrafo:null, cDisegno:null, cVarie:null},
      titoloRiparazione:'',
      showUploadingSpinner:false,
      showAlertSuccess:false,
      showAlertFail:false,
      optionsClienti:null,
      /*optionsPietre:[
        {value:"Negozio",text:"Negozio"},
        {value:"In sospeso",text:"In sospeso"}
      ],
      optionsFornitore:[
        {value:"Negozio",text:"Negozio"},
        {value:"In sospeso",text:"In sospeso"}
      ],*/
      optionsStato:[
        {value:"Negozio",text:"Da ordinare"},
        {value:"Negozio",text:"In lavorazione"},
        {value:"In sospeso",text:"In sospeso"},
        {value:"Consegnato a Moraglione",text:"Consegnato a Moraglione"},
        {value:"Consegnato ad Antonio",text:"Consegnato ad Antonio"},
        {value:"Consegnato ad EuroGem",text:"Consegnato ad EuroGem"},
        {value:"Pronto per il ritiro",text:"Pronto per il ritiro"},
        {value:"In attesa del cliente",text:"In attesa del cliente"},
        {value:"Consegnato",text:"Consegnato"}],
        isLoading: false,
        files:[],
        selectedImage:null,
        filtroTipoLavorazione:'TUTTO',
        filtroStatoLavorazione:'TUTTO',

      };
    },

    mounted() {
      this.getNewProgressivo();
      this.updateRiparazioniTable();
      if(this.$route.params.tipo!=undefined){
        this.filtroTipoLavorazione=this.$route.params.tipo;
      }

    },
    watch:{
      $route (){
        if(this.$route.params.tipo!=undefined){
          this.filtroTipoLavorazione=this.$route.params.tipo;
        }else{
          this.filtroTipoLavorazione='TUTTO'
        }
      }
    },
    computed: {
      uploadDisabled() {
        return this.files.length === 0;
      },/*
      filtroTipoLavorazioneArray: function () {
      return this.riparazioni.filter(function (lavorazione) {

      if(this.filtroTipoLavorazione==='TUTTO'){
      console.log(lavorazione)
      return lavorazione;
    }else{
    return lavorazione.tipoLavorazione==this.filtroTipoLavorazione;
  }
})
}
*/
filtroTipoLavorazioneArray: function () {
  let fTipo=this.filtroTipoLavorazione;
  let fStato=this.filtroStatoLavorazione;
  return this.riparazioni.filter(function (lavorazione) {
    if(fTipo==='TUTTO'){
      if(fStato=='TUTTO'){
        return lavorazione;
      }
      if(fStato=='LAVORAZIONE'){
        if(lavorazione.stato!='Consegnato')
        return lavorazione;
      }
      if(fStato=='CONSEGNATO'){
        if(lavorazione.stato=='Consegnato')
        return lavorazione;
      }

    }else{
      if(fTipo==lavorazione.tipo){
        if(fStato=='TUTTO'){
          return lavorazione;
        }
        if(fStato=='LAVORAZIONE'){
          if(lavorazione.stato!='Consegnato')
          return lavorazione;
        }
        if(fStato=='CONSEGNATO'){
          if(lavorazione.stato=='Consegnato')
          return lavorazione;
        }
      }
    }

  })
}
},
methods: {
  isImage(filename){
    const extensions = ["jpeg", "jpg", "png", "tif", "tiff", "bmp", "gif"];
    const ext=filename.split('.').pop().toLowerCase();
    return extensions.includes(ext)
  },
  stampa(id){
    let routeData = this.$store.state.settings.URL_SERVER+"API/printLAB.php?contatore="+id+"&secret="+this.$session.get('secret')
    window.open(routeData, '_blank')
  },

  copiaPerStampa(id){
    axios
    .get(this.$store.state.settings.URL_SERVER+"API/v1.php?laboratorioStampa&id="+id+"&secret="+this.$session.get('secret'))
    .then(response => {
      if(response.data.contatore>0){
        this.stampa(response.data.contatore)
      }else{
        this.sendAlert('fail')
      }
    })
    .catch(err => {
      console.log(err);
    });
  },
  getNewProgressivo(){
    axios
    .get(this.$store.state.settings.URL_SERVER+"API/v1.php?getNextProgressivolaboratorio&secret="+this.$session.get('secret'))
    .then(response => {
      console.log(response)
      this.nextProgrssivo = response.data.nextProgressivolaboratorio[0].n;
      console.log(this.nextProgrssivo)
    })
    .catch(err => {
      console.log(err);
    });
  },

  visualizzaProgetto(row){
    this.modificaRiparazione(row,1);
  },
  zoom(url){
    this.selectedImage = url;
    this.$bvModal.show('modal-dettaglioFoto')
  },
  addFileDialog(e){

    let droppedFiles = e.target.files;
    if(!droppedFiles) return;
    // this tip, convert FileList to array, credit: https://www.smashingmagazine.com/2018/01/drag-drop-file-uploader-vanilla-js/
    ([...droppedFiles]).forEach(f => {
      this.files.push(f);
    });
  },
  addFile(e) {
    let droppedFiles = e.dataTransfer.files;
    if(!droppedFiles) return;
    // this tip, convert FileList to array, credit: https://www.smashingmagazine.com/2018/01/drag-drop-file-uploader-vanilla-js/
    ([...droppedFiles]).forEach(f => {
      this.files.push(f);
    });
  },
  removeFile(file){
    this.files = this.files.filter(f => {
      return f != file;
    });
  },
  upload() {
},
removeFileCaricato(id){
  axios
  .get(this.$store.state.settings.URL_SERVER+"API/v1.php?deleteFile="+id)
  .then(() => {
    console.log("deleted");
    this.updateRiparazioniTable();

    var filtered = this.formNuovoLAB.fileCaricati.filter(function(value){
      if(value.id!=id)
      return value;
    });
    this.formNuovoLAB.fileCaricati=filtered
  })
  .catch(err => {
    console.log(err);
  });
},
updateRiparazioniTable(){
  this.isLoading=true;
  axios
  .get(this.$store.state.settings.URL_SERVER+"API/v1.php?laboratorio&secret="+this.$session.get('secret'))
  .then(response => {
    console.log(response)
    this.laboratorio = response.data.laboratorio;
  })
  .catch(err => {
    console.log(err);
  });
  this.isLoading=false;

},
dettaglioRiparazione(payload){
  let row=payload.data;
  this.modificaRiparazione(row,0);
},
modificaRiparazione(row,panelIndex){
  this.panelIndex=panelIndex;
  this.clearformNuovaLavorazione();
  this.formNuovoLAB.progressivo=row.progressivo;
  this.formNuovoLAB.id=row.id;
  this.formNuovoLAB.data=row.data;
  this.formNuovoLAB.qnt=row.qnt;
  this.formNuovoLAB.carati=row.carati;
  this.formNuovoLAB.tipo=row.tipo;
  this.formNuovoLAB.caratteristiche=row.caratteristiche;
  this.formNuovoLAB.grammi=row.grammi;
  this.formNuovoLAB.modello=row.modello;
  this.formNuovoLAB.codice=row.codice;
  this.formNuovoLAB.riferimento=row.riferimento;
  this.formNuovoLAB.pietre=row.pietre;
  this.formNuovoLAB.fornitore=row.fornitore;
  this.formNuovoLAB.scarico=row.scarico;
  this.formNuovoLAB.nota=row.nota;
  this.formNuovoLAB.stato=row.stato;
  this.formNuovoLAB.flag=row.flag;
  if(this.formNuovoLAB.flag==1){
    this.formNuovoLAB.flag=true;
  }else{
    this.formNuovoLAB.flag=false;
  }
  this.formNuovoLAB.fileCaricati=row.imgs;

  this.formNuovoLAB.cIncassatura=row.cIncassatura;
  this.formNuovoLAB.cFusione=row.cFusione;
  this.formNuovoLAB.cOrafo=row.cOrafo;
  this.formNuovoLAB.cDisegno=row.cDisegno;
  this.formNuovoLAB.cVarie=row.cVarie;

  this.titoloRiparazione="Modifica";
  this.$bvModal.show('modal-nuovoLAB')
},
eliminaRiparazione(id){

  this.$confirm(
    {
      message: `Sicuro di voler eliminare la riga?`,
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
          this.isLoading=true;
          axios
          .get(this.$store.state.settings.URL_SERVER+"API/v1.php?eliminaLaboratorio&id="+id+"&secret="+this.$session.get('secret'))
          .then(response => {
            if (response.status === 200 && response.data.result=="OK") {
              this.sendAlert('success')
              this.updateRiparazioniTable();
            }else{
              this.sendAlert('success')
            }
            this.isLoading=false;
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
clearformNuovaLavorazione(){
  this.formNuovoLAB.progressivo=this.nextProgrssivo;

  this.getNewProgressivo();

  var today = new Date();
  var dd = String(today.getDate()).padStart(2, '0');
  var mm = String(today.getMonth() + 1).padStart(2, '0'); //January is 0!
  var yyyy = today.getFullYear();
  today = yyyy + '-' + mm + '-' + dd;
  this.formNuovoLAB.data= today;
  this.titoloRiparazione="Nuovo";
  this.files=[];
  this.formNuovoLAB.id=0;
    this.formNuovoLAB.qnt=1
  this.formNuovoLAB.carati='';
  this.formNuovoLAB.tipo='';
  this.formNuovoLAB.caratteristiche='';
  this.formNuovoLAB.grammi='';
  this.formNuovoLAB.modello='';
  this.formNuovoLAB.codice='';
  this.formNuovoLAB.riferimento='';
  this.formNuovoLAB.pietre='';
  this.formNuovoLAB.fornitore='';
  this.formNuovoLAB.scarico='';
  this.formNuovoLAB.nota='';
  this.formNuovoLAB.stato='';
  this.formNuovoLAB.flag=false;
  this.formNuovoLAB.cIncassatura=null;
  this.formNuovoLAB.cFusione=null;
  this.formNuovoLAB.cOrafo=null;
  this.formNuovoLAB.cDisegno=null;
  this.formNuovoLAB.cVarie=null;
},
stampaNoSalva(){
  this.isLoading=true;
  event.preventDefault();
  this.$set(this.formNuovoLAB, 'azione', 'nuovoLAB_temp_stampa');
  this.$set(this.formNuovoLAB, 'secret', this.$session.get('secret'));
  let myFormData=this.toFormData(this.formNuovoLAB);

  axios.post( this.$store.state.settings.URL_SERVER+"API/v1.php",myFormData, {
    headers: {
      //  'Content-Type': 'application/json'
      'Content-Type': 'multipart/form-data'
    }
  }).then(response => {
    console.log(response)
    if (response.status === 200 && response.data.result=="OK") {
      this.stampa(response.data.contatore)
      this.isLoading=false;
    }else{
      this.sendAlert('fail')
    }

  })
  .catch(err => {
    console.log(err);
    this.sendAlert('fail');
    this.isLoading=false;
  });
},
onSubmitNuovoLAB(){
  this.isLoading=true;
  event.preventDefault();
  this.$set(this.formNuovoLAB, 'azione', 'nuovoLAB');
  this.$set(this.formNuovoLAB, 'secret', this.$session.get('secret'));
  let myFormData=this.toFormData(this.formNuovoLAB);
  this.files.forEach((f,x) => {
    myFormData.append('file'+(x+1), f);
  });

  axios.post( this.$store.state.settings.URL_SERVER+"API/v1.php",myFormData, {
    headers: {
      //  'Content-Type': 'application/json'
      'Content-Type': 'multipart/form-data'
    }
  }).then(response => {
    console.log(response)
    if (response.status === 200 && response.data.result=="OK") {
      this.sendAlert('success')
      this.clearformNuovaLavorazione();
      this.updateRiparazioniTable();
      this.$bvModal.hide('modal-nuovoLAB')
      this.isLoading=false;
    }else{
      this.sendAlert('fail')
    }

  })
  .catch(err => {
    console.log(err);
    this.sendAlert('fail');
    this.isLoading=false;
  });

  this.clearformNuovaLavorazione();
  this.$bvModal.hide('modal-nuovaRiparazione')
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
<style>
.btn-outline-danger:hover {
    background-color: #dc3545 !important;
}

.btn-outline-success:hover {
    background-color: #28a745 !important;
}
</style>