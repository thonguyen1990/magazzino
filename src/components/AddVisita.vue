<template>
  <b-modal id="modal-nuovaVisita" hide-footer title="Nuova Visita" size="xl" >
    <loading :active.sync="isLoading" :can-cancel="true" :is-full-page="true"></loading>

    <b-form @submit="onSubmitNuovaVisita">
      <div class="form-row d-block">
        <div class="row text-center">
            NUOVA VISTA
          <span>    
          </span>
        </div>
        <hr style="width:25%">
        <b-row class="form-row text-center">
          <b-col>
            <b-form-radio-group style="margin-top:0.1em"
            id="tipoVisita"
            v-model="formNuovaVisita.isVendita"
            :options="[
            { text: 'VISITA', value: 0},
            { text: 'VENDITA', value: 1 }]"
            name="tipoVisita"
            ></b-form-radio-group>
          </b-col>
        </b-row>
      </div>
      <b-row>
        <b-col>
          <b-form-group label="Cliente:" label-for="input-cliene">
            <model-select id="input-cliente" class="form-control"   :options="optionsClienti" onchange="clienteSelezionato()" v-model="formNuovaVisita.idCliente" placeholder="Seleziona il cliente"></model-select>
          </b-form-group>
        </b-col>
        <b-col >
          <b-form-group label="Data Visita" label-for="input-dataVendita">
            <b-form-datepicker id="input-dataVendita"  today-button reset-button v-model="formNuovaVisita.dataVisita" class="mb-2"></b-form-datepicker>
          </b-form-group>
        </b-col>
        <b-col >
          <b-form-group label="Ora Visita" label-for="input-oraVendita">
          <!--  <b-form-timepicker id="input-oraVendita" locale="it" class="mb-2"></b-form-timepicker>-->
            <model-select id="input-oraVendita" class="form-control"  v-model="formNuovaVisita.oraVisita" :options="optionsOra" placeholder="Seleziona l'ora di visita"></model-select>
          </b-form-group>
        </b-col>

      </b-row>
      <b-row>
        <b-col>
          <b-form-group label="Fonte Visita:" label-for="input-fonte">
            <model-select class="form-control" id="input-fonte"  :options="optionsFonte" v-model="formNuovaVisita.fonte" placeholder="Seleziona la fonte"></model-select>
          </b-form-group>
        </b-col>
        <b-col>
          <b-form-group label="Dettaglio fonte:" label-for="input-dettaglioFonte">
            <b-form-input id="input-dettaglioFonte" v-model="formNuovaVisita.fonte_dettaglio" type="text"></b-form-input>
          </b-form-group>
        </b-col>
        <b-col >
          <b-form-group label="Gift:" label-for="input-dettaglioFonte">
          <b-form-checkbox style="margin-bottom:3em;" v-model="formNuovaVisita.gift" name="input-tag"   id="input-tag" switch>

              <span v-if="formNuovaVisita.gift==1"><b-icon  icon="gift-fill" variant="success"  font-scale="1.5" style="margin-left:0.5em;"></b-icon>SI</span>
              <span v-else><b-icon  icon="gift" variant="success"  font-scale="1.5" style="margin-left:0.5em;"></b-icon> NO</span>
          </b-form-checkbox>
        </b-form-group>

        </b-col>
      </b-row>
      <hr>


      <b-row>
        <b-col>
          <div class="form-group">
            <div class="align-left"><label class="prodottoVenditaN">PRODOTTO 1 </label> <span style="color:red;margin-left:2em;font-weight:bold" @click="clearProdotto(1)">X</span></div>
            <model-select class="form-control"   :options="optionsProdotti" v-model="formNuovaVisita.prodotto1" @input="getPrezzoProdotto(formNuovaVisita.prodotto1,1)"
            placeholder="Seleziona il prodotto"></model-select>
            <b-form-input id="input-custom1" v-model="formNuovaVisita.custom1" type="text" v-if="formNuovaVisita.prodotto1==0"></b-form-input>
          </div>
        </b-col>
        <b-col >
          <b-form-group label="Pr.Listino:" label-for="input-p1">
            <b-form-input  @focus.native="$event.target.select()" id="input-p1" v-model="formNuovaVisita.prezzo1" type="number" step=".01"></b-form-input>
          </b-form-group>
        </b-col>
        <b-col >
          <b-form-group label="Pr.Scontato:" label-for="input-ps1">
            <b-form-input  @focus.native="$event.target.select()" id="input-ps1" v-model="formNuovaVisita.prezzoSc1" v-on:keyup="calcPercSconto(1)" type="number" step=".01"></b-form-input>
          </b-form-group>
        </b-col>
        <b-col >
          <b-form-group label="Sconto (%):" label-for="input-sconto1">
            <b-form-input  @focus.native="$event.target.select()" id="input-sconto1" v-model="formNuovaVisita.sconto1" v-on:keyup="calcPrezzoSconto(1)" type="number" step="0.01"></b-form-input>
          </b-form-group>
        </b-col>
      </b-row>

      <b-row>
        <b-col>
          <b-form-group label="Categoria:" label-for="input-cat1">
            <model-select class="form-control" id="input-cat1"  :options="optionsCat" v-model="formNuovaVisita.cat1" placeholder="Seleziona la categorie"></model-select>
          </b-form-group>
        </b-col>
        <b-col>
          <b-form-group label="Tipologia:" label-for="input-catBis1">
            <model-select class="form-control" id="input-catBis1"  :options="optionsCatBis" v-model="formNuovaVisita.catBis1" placeholder="Seleziona la categorie"></model-select>
          </b-form-group>
        </b-col>
        <b-col >
          <b-form-group label="SottoCategoria:" label-for="input-sottocat1">
            <b-form-input id="input-sottocat1" v-model="formNuovaVisita.sottocat1" type="text"></b-form-input>
          </b-form-group>
        </b-col>
      </b-row>
      <b-row>
        <b-col>
            <b-form-group label="Nota:" label-for="note1">
          <textarea   placeholder="Inserisci una nota..." class="form-control" id="note1" v-model="formNuovaVisita.note1" rows="1"></textarea>
            </b-form-group>
        </b-col>
        <b-col >
          <b-form-group label="Vetrina:" label-for="input-vetrina1">
            <model-select class="form-control" id="input-vetrina1"  :options="optionsVetrina" v-model="formNuovaVisita.vetrina1" placeholder="Seleziona la vetrina"></model-select>
          </b-form-group>
        </b-col>
      </b-row>
      <hr>
      <b-row>
        <b-col>
          <div class="form-group">
            <div class="align-left"><label class="prodottoVenditaN">PRODOTTO 2 </label> <span style="color:red;margin-left:2em;font-weight:bold" @click="clearProdotto(2)">X</span></div>
            <model-select class="form-control"   :options="optionsProdotti" v-model="formNuovaVisita.prodotto2" @input="getPrezzoProdotto(formNuovaVisita.prodotto2,2)"
            placeholder="Seleziona il prodotto"></model-select>
            <b-form-input id="input-custom2" v-model="formNuovaVisita.custom2" type="text" v-if="formNuovaVisita.prodotto2==0"></b-form-input>

          </div>
        </b-col>
        <b-col >
          <b-form-group label="Pr.Listino:" label-for="input-p2">
            <b-form-input  @focus.native="$event.target.select()" id="input-p2" v-model="formNuovaVisita.prezzo2" type="number" step=".01"></b-form-input>
          </b-form-group>
        </b-col>
        <b-col >
          <b-form-group label="Pr.Scontato:" label-for="input-ps2">
            <b-form-input  @focus.native="$event.target.select()" id="input-ps2" v-model="formNuovaVisita.prezzoSc2" v-on:keyup="calcPercSconto(2)" type="number" step=".01"></b-form-input>
          </b-form-group>
        </b-col>
        <b-col >
          <b-form-group label="Sconto (%):" label-for="input-sconto2">
            <b-form-input  @focus.native="$event.target.select()" id="input-sconto2" v-model="formNuovaVisita.sconto2" v-on:keyup="calcPrezzoSconto(2)" type="number" step="0.01"></b-form-input>
          </b-form-group>
        </b-col>
      </b-row>
      <b-row>
        <b-col>
          <b-form-group label="Categoria:" label-for="input-cat2">
            <model-select class="form-control" id="input-cat2"  :options="optionsCat" v-model="formNuovaVisita.cat2" placeholder="Seleziona la categoria"></model-select>
          </b-form-group>
        </b-col>
        <b-col>
          <b-form-group label="Tipologia:" label-for="input-catBis2">
            <model-select class="form-control" id="input-catBis2"  :options="optionsCatBis" v-model="formNuovaVisita.catBis2" placeholder="Seleziona la categorie"></model-select>
          </b-form-group>
        </b-col>
        <b-col >
          <b-form-group label="SottoCategoria:" label-for="input-sottocat2">
            <b-form-input id="input-sottocat2" v-model="formNuovaVisita.sottocat2" type="text"></b-form-input>
          </b-form-group>
        </b-col>
      </b-row>
      <b-row>
        <b-col>
          <b-form-group label="Nota:" label-for="note1">
            <textarea   placeholder="Inserisci una nota..." class="form-control" id="note2" v-model="formNuovaVisita.note2" rows="1"></textarea>
          </b-form-group>
        </b-col>
        <b-col >
          <b-form-group label="Vetrina:" label-for="input-vetrina2">
            <model-select class="form-control" id="input-vetrina2"  :options="optionsVetrina" v-model="formNuovaVisita.vetrina2" placeholder="Seleziona la vetrina"></model-select>
          </b-form-group>
        </b-col>
      </b-row>
      <hr>
      <b-row>
        <b-col>
          <div class="form-group">
            <div class="align-left"><label class="prodottoVenditaN">PRODOTTO 3 </label> <span style="color:red;margin-left:2em;font-weight:bold" @click="clearProdotto(3)">X</span></div>
            <model-select class="form-control"   :options="optionsProdotti" v-model="formNuovaVisita.prodotto3" @input="getPrezzoProdotto(formNuovaVisita.prodotto3,3)"
            placeholder="Seleziona il prodotto"></model-select>
            <b-form-input id="input-custom3" v-model="formNuovaVisita.custom3" type="text" v-if="formNuovaVisita.prodotto3==0"></b-form-input>
          </div>
        </b-col>
        <b-col >
          <b-form-group label="Pr.Listino:" label-for="input-p3">
            <b-form-input  @focus.native="$event.target.select()" id="input-p3" v-model="formNuovaVisita.prezzo3" type="number" step=".01"></b-form-input>
          </b-form-group>
        </b-col>
        <b-col >
          <b-form-group label="Pr.Scontato:" label-for="input-ps3">
            <b-form-input  @focus.native="$event.target.select()" id="input-ps3" v-model="formNuovaVisita.prezzoSc3" v-on:keyup="calcPercSconto(3)" type="number" step=".01"></b-form-input>
          </b-form-group>
        </b-col>
        <b-col >
          <b-form-group label="Sconto (%):" label-for="input-sconto3">
            <b-form-input  @focus.native="$event.target.select()" id="input-sconto3" v-model="formNuovaVisita.sconto3" v-on:keyup="calcPrezzoSconto(3)" type="number" step="0.01"></b-form-input>
          </b-form-group>
        </b-col>
      </b-row>
      <b-row>
        <b-col>
          <b-form-group label="Categoria:" label-for="input-cat3">
            <model-select class="form-control" id="input-cat3"  :options="optionsCat" v-model="formNuovaVisita.cat3" placeholder="Seleziona la categorie"></model-select>
          </b-form-group>
        </b-col>
        <b-col>
          <b-form-group label="Tipologia:" label-for="input-catBis3">
            <model-select class="form-control" id="input-catBis3"  :options="optionsCatBis" v-model="formNuovaVisita.catBis3" placeholder="Seleziona la categorie"></model-select>
          </b-form-group>
        </b-col>
        <b-col >
          <b-form-group label="SottoCategoria:" label-for="input-sottocat3">
            <b-form-input id="input-sottocat3" v-model="formNuovaVisita.sottocat3" type="text"></b-form-input>
          </b-form-group>
        </b-col>
      </b-row>

      <b-row>
        <b-col>
          <b-form-group label="Nota:" label-for="note1">
            <textarea   placeholder="Inserisci una nota..." class="form-control" id="note3" v-model="formNuovaVisita.note3" rows="1"></textarea>
              </b-form-group>
        </b-col>
        <b-col >
          <b-form-group label="Vetrina:" label-for="input-vetrina3">
            <model-select class="form-control" id="input-vetrina3"  :options="optionsVetrina" v-model="formNuovaVisita.vetrina3" placeholder="Seleziona la vetrina"></model-select>
          </b-form-group>
        </b-col>
      </b-row>
      <hr>
      <div class="form-group">
        <div class="container">
          <div class="row">
            <div class="col-8"><textarea   placeholder="Inserisci una nota relativa alla visita" class="form-control" id="note" v-model="formNuovaVisita.note" rows="3"></textarea></div>
          </div>
        </div>
      </div>

      <div class="form-group">
        <b-button type="submit" >SALVA</b-button>
      </div>
    </b-form>
    <b-alert  v-if="showAlertSuccess" variant="success" show>INSERITO!</b-alert>
    <b-alert v-if="showAlertFail" variant="warning" show>Errore! - VERIFICA CHE IL FILE EXCEL SIA CHIUSO</b-alert>
    <div v-if="showUploadingSpinner">
      <b-spinner label="Loading..."></b-spinner>
    </div>


  </b-modal>


</template>


<script>
import axios from "axios";
import { ModelSelect } from 'vue-search-select'
import moment from 'moment'


export default {
  data() {
    return {
      formNuovaVisita:{id:0,isVendita:0,dataVisita:null, oraVisita:8,idCliente:0,prodotto1:'',cat1:'',catBis1:'',sottocat1:'',prodotto2:'',cat2:'',catBis2:'',sottocat2:'',
      prodotto3:'',cat3:'',catBis3 :'',sottocat3:'',note:'',prezzo1:0,prezzo2:0,prezzo3:0,prezzoSc1:0,prezzoSc2:0,prezzoSc3:0,sconto1:0,sconto2:0,sconto3:0,note1:'',note2:'',note3:'',custom1:'',custom2:'',custom3:'',
    fonte:'',fonte_dettaglio:'',gift:0,vetrina1:'',vetrina2:'',vetrina3:''},

      optionsClienti:[],
      optionsProdotti:[],
      optionsVetrina:[],
      optionsOra: [{value:8,text:8},{value:9,text:9},{value:10,text:10},{value:11,text:11},{value:12,text:12},{value:13,text:13},{value:14,text:14},{value:15,text:15},{value:16,text:16},{value:17,text:17},{value:18,text:18},{value:19,text:19},{value:20,text:20}],
      optionsFonte: [{value:'Online',text:'Online'},{value:'Vetrine',text:'Vetrine'},{value:'Da cliente',text:'Da cliente'},{value:'Altro',text:'Altro'}],
      optionsCat:[{value:'Classici',text:'Classici'},{value:'Classici Colorati',text:'Classici Colorati'},{value:'Fantasia',text:'Fantasia'},{value:'Gioiello su misura',text:'Gioiello su misura'}],
      optionsCatBis:[{value:'Anelli',text:'Anelli'},{value:'Braccialetti',text:'Braccialetti'},{value:'Ciondoli',text:'Ciondoli'},{value:'Collane',text:'Collane'},
      {value:'Orecchini',text:'Orecchini'},{value:'Altro',text:'Altro'},],
      clienti:[],
      prodotti:[],
      note:'',
      dataVendita:null,
      //dataVendita:moment(String(new Date())).format('DD/MM/YYYY'),
      showAlertSuccess:false,
      showAlertFail:false,
      showUploadingSpinner:false,
      isLoading: false,
      visitaVendita:[]

    };
  },
  components: {
    ModelSelect,
  },

  mounted() {
    this.getListaClienti();
    this.getListaProdotti();
    this.caricaVetrine();
  },
  methods: {
  caricaVetrine(){
    console.log('Procedo')
    this.isLoading=true;
    axios
    .get(this.$store.state.settings.URL_SERVER+"API/v1.php?categorieLivello=2&thumb=medium&genitore=22")
    .then(response => {
      console.log('ESEGUITO')

      let lista=[{value:'NO',text:'NO'}];
      response.data.categorie.map(function(value) {
        lista.push({value:value.nome, text:value.nome});
      });
      lista.push({value:'Cassaforte', text:'Cassaforte'});
      this.optionsVetrina=lista;
      this.isLoading=false;
    })
    .catch(err => {
      this.isLoading=false;
      console.log(err);
    });
  },

    clienteSelezionato(){
      alert("xx")
    },
    cambiaOra(){
      alert("xx")
    },
    formatDate (date) {
      return moment(date).format('DD-MM-YYYY')
    },
    showModal(row){
      this.clearFormNuovaVisita();
      this.formNuovaVisita.idCliente=row.id;
      this.formNuovaVisita.fonte=row.fonte;
      this.formNuovaVisita.fonte_dettaglio=row.fonte_dettaglio;
      var today = new Date();
      var dd = String(today.getDate()).padStart(2, '0');
      var mm = String(today.getMonth() + 1).padStart(2, '0'); //January is 0!
      var yyyy = today.getFullYear();
      this.formNuovaVisita.oraVisita = today.getHours();
      today = yyyy + '-' + mm + '-' + dd;
      this.formNuovaVisita.dataVisita= today;


      this.$bvModal.show('modal-nuovaVisita')
    },
    modificaVisita(idVisita){
      this.clearFormNuovaVisita();
      this.getVisita(idVisita)
      console.log(idVisita)


    },
    calcPercSconto(n){
      switch (n) {
        case 1:
        this.formNuovaVisita.sconto1=((1-parseFloat(this.formNuovaVisita.prezzoSc1)/parseFloat(this.formNuovaVisita.prezzo1))*100).toFixed(2);
        break;
        case 2:
        this.formNuovaVisita.sconto2=((1-parseFloat(this.formNuovaVisita.prezzoSc2)/parseFloat(this.formNuovaVisita.prezzo2))*100).toFixed(2);
        break;
        case 3:
        this.formNuovaVisita.sconto3=((1-parseFloat(this.formNuovaVisita.prezzoSc3)/parseFloat(this.formNuovaVisita.prezzo3))*100).toFixed(2);
        break;
      }
    },
    calcPrezzoSconto(n){
      switch (n) {
        case 1:
        this.formNuovaVisita.prezzoSc1=(parseFloat(this.formNuovaVisita.prezzo1)*(1-this.formNuovaVisita.sconto1/100)).toFixed(2);
        break;
        case 2:
        this.formNuovaVisita.prezzoSc2=(parseFloat(this.formNuovaVisita.prezzo2)*(1-this.formNuovaVisita.sconto2/100)).toFixed(2);
        break;
        case 3:
        this.formNuovaVisita.prezzoSc3=(parseFloat(this.formNuovaVisita.prezzo3)*(1-this.formNuovaVisita.sconto3/100)).toFixed(2);
        break;
      }
    },
    clearFormNuovaVisita(){
      this.formNuovaVisita.isVendita=0;
      this.formNuovaVisita.prodotto1=null;
      this.formNuovaVisita.prodotto2=null;
      this.formNuovaVisita.prodotto3=null;
      this.formNuovaVisita.custom1='';
      this.formNuovaVisita.custom2='';
      this.formNuovaVisita.custom3='';
      this.formNuovaVisita.prezzo1=0;
      this.formNuovaVisita.prezzo2=0;
      this.formNuovaVisita.prezzo3=0;
      this.formNuovaVisita.prezzoSc1=0;
      this.formNuovaVisita.prezzoSc2=0;
      this.formNuovaVisita.prezzoSc3=0;
      this.formNuovaVisita.sconto1=0;
      this.formNuovaVisita.sconto2=0;
      this.formNuovaVisita.sconto3=0;
      this.formNuovaVisita.cat1='';
      this.formNuovaVisita.cat2='';
      this.formNuovaVisita.cat3='';
      this.formNuovaVisita.catBis1='';
      this.formNuovaVisita.catBis2='';
      this.formNuovaVisita.catBis3='';
      this.formNuovaVisita.sottocat1='';
      this.formNuovaVisita.sottocat2='';
      this.formNuovaVisita.sottocat3='';
      this.formNuovaVisita.note='';
      this.formNuovaVisita.note1='';
      this.formNuovaVisita.note2='';
      this.formNuovaVisita.note3='';
      this.formNuovaVisita.fonte='';
      this.formNuovaVisita.fonte_dettaglio='';
      this.formNuovaVisita.gift=0;
      this.formNuovaVisita.id=0;
      this.formNuovaVisita.idCliente=0;
      this.formNuovaVisita.dataVisita=null;
      this.formNuovaVisita.oraVisita=8;
      this.formNuovaVisita.vetrina1=0;
      this.formNuovaVisita.vetrina2=0;
      this.formNuovaVisita.vetrina3=0;
    },
    getListaClienti(){
      axios
      .get(this.$store.state.settings.URL_SERVER+"API/v1.php?clienti&attivi&secret="+this.$session.get('secret'))
      .then(response => {
        console.log(response);
        let lista=[{value:0,text:'OSPITE'}];
        this.clienti=response.data.clienti
        response.data.clienti.map(function(value) {
          lista.push({value:value.id,text:value.cognome+' '+value.nome});
        });
        this.optionsClienti=lista;
      })
      .catch(err => {
        console.log(err);
      });
    },
    getListaProdotti(){
      axios
      .get(this.$store.state.settings.URL_SERVER+"API/v1.php?prodotti")
      .then(response => {
        this.prodotti = response.data.prodotti;
        let lista=[{value:0,text:'-CUSTOM-'}];
        response.data.prodotti.map(function(value) {
          lista.push({value:value.id, text:value.titolo+' - '+value.descrizione});
        });
        this.optionsProdotti=lista;

      })
      .catch(err => {
        console.log(err);
      });
    },
    getVisita(id){
      axios
      .get(this.$store.state.settings.URL_SERVER+"API/v1.php?secret="+this.$session.get('secret')+"&singolaVisita="+id)
      .then(response => {
        console.log(response)
        this.visitaVendita = response.data.visitaVendita;
        console.log(this.visitaVendita)
        if ('prodotto1' in this.visitaVendita){
          this.formNuovaVisita.prodotto1 =this.visitaVendita.prodotto1;
          this.formNuovaVisita.custom1=this.visitaVendita.itemTitolo1;
          this.formNuovaVisita.prezzo1=this.visitaVendita.prezzo1;
          this.formNuovaVisita.prezzoSc1=this.visitaVendita.prezzoSc1;
          this.formNuovaVisita.sconto1=  this.visitaVendita.sconto1;
          this.formNuovaVisita.cat1=this.visitaVendita.cat1;
          this.formNuovaVisita.catBis1=  this.visitaVendita.catBis1;
          this.formNuovaVisita.sottocat1=this.visitaVendita.sottocat1;
          this.formNuovaVisita.note1=this.visitaVendita.note1;
          this.formNuovaVisita.vetrina1=this.visitaVendita.vetrina1;


        }
        if ('prodotto2' in this.visitaVendita){
          this.formNuovaVisita.prodotto2 = this.visitaVendita.prodotto2;
          this.formNuovaVisita.custom2=this.visitaVendita.itemTitolo2;
          this.formNuovaVisita.prezzo2=this.visitaVendita.prezzo2;
          this.formNuovaVisita.prezzoSc2=this.visitaVendita.prezzoSc2;
          this.formNuovaVisita.sconto2=  this.visitaVendita.sconto2;
          this.formNuovaVisita.cat2=this.visitaVendita.cat2;
          this.formNuovaVisita.catBis2=  this.visitaVendita.catBis2;
          this.formNuovaVisita.sottocat2=this.visitaVendita.sottocat2;
          this.formNuovaVisita.note2=this.visitaVendita.note2;
          this.formNuovaVisita.vetrina2=this.visitaVendita.vetrina2;
        }
        if ('prodotto3' in this.visitaVendita){
          this.formNuovaVisita.prodotto3 = this.visitaVendita.prodotto3;
          this.formNuovaVisita.custom3=this.visitaVendita.itemTitolo3;
          this.formNuovaVisita.prezzo3=this.visitaVendita.prezzo3;
          this.formNuovaVisita.prezzoSc3=this.visitaVendita.prezzoSc3;
          this.formNuovaVisita.sconto3=  this.visitaVendita.sconto3;
          this.formNuovaVisita.cat3=this.visitaVendita.cat3;
          this.formNuovaVisita.catBis3=  this.visitaVendita.catBis3;
          this.formNuovaVisita.sottocat3=this.visitaVendita.sottocat3;
          this.formNuovaVisita.note3=this.visitaVendita.note3;
          this.formNuovaVisita.vetrina3=this.visitaVendita.vetrina3;
        }

        this.formNuovaVisita.isVendita=this.visitaVendita.isVendita;
        this.formNuovaVisita.note=this.visitaVendita.note;
        this.formNuovaVisita.fonte=this.visitaVendita.fonte;
        this.formNuovaVisita.fonte_dettaglio=this.visitaVendita.fonte_dettaglio;
        if(parseInt(this.visitaVendita.gift)==1){
          this.formNuovaVisita.gift=true
        }else{
          this.formNuovaVisita.gift=false
        }
      //  this.formNuovaVisita.gift=parseInt(this.visitaVendita.gift);
        this.formNuovaVisita.id=id;
        this.formNuovaVisita.idCliente=this.visitaVendita.idCliente;
        this.formNuovaVisita.dataVisita=this.visitaVendita.dataVisita;
        this.formNuovaVisita.oraVisita=parseInt(this.visitaVendita.oraVisita);
        this.$bvModal.show('modal-nuovaVisita')
      })
      .catch(err => {
        console.log(err);
      });
    },
    clearProdotto(n){
      if(n==1){
        this.formNuovaVisita.prodotto1=null;
        this.formNuovaVisita.sottocat1='';
        this.formNuovaVisita.note1='';
        this.formNuovaVisita.custom1='';
        this.formNuovaVisita.prezzo1=0;
        this.formNuovaVisita.prezzoSc1=0;
        this.formNuovaVisita.sconto1=0;
        this.formNuovaVisita.cat1='';
        this.formNuovaVisita.catBis1='';
        this.formNuovaVisita.vetrina1='';
      }
      if(n==2){
        this.formNuovaVisita.prodotto2=null;
        this.formNuovaVisita.custom2='';
        this.formNuovaVisita.prezzo2=0;
        this.formNuovaVisita.prezzoSc2=0;
        this.formNuovaVisita.sconto2=0;
        this.formNuovaVisita.cat2='';
        this.formNuovaVisita.catBis2='';
        this.formNuovaVisita.note2='';
        this.formNuovaVisita.sottocat2='';
        this.formNuovaVisita.vetrina2='';
      }
      if(n==3){
        this.formNuovaVisita.sottocat3='';
        this.formNuovaVisita.catBis3='';
        this.formNuovaVisita.note3='';
        this.formNuovaVisita.cat3='';
        this.formNuovaVisita.sconto3=0;
        this.formNuovaVisita.prezzo3=0;
        this.formNuovaVisita.prezzoSc3=0;
        this.formNuovaVisita.prodotto3=null;
        this.formNuovaVisita.custom3='';
        this.formNuovaVisita.vetrina3='';
     }

   },
    getPrezzoProdotto(id,n){
      axios
      .get(this.$store.state.settings.URL_SERVER+"API/v1.php?prezzoProdotto&id="+id+"&secret="+this.$session.get('secret'))
      .then(response => {
        console.log('X')
        console.log(response.data)
        switch (n) {
          case 1:
          this.formNuovaVisita.prezzo1 = response.data.prezzo[0].prezzo;
          this.formNuovaVisita.vetrina1 = response.data.vetrina[0].nome;
          break;
          case 2:
          this.formNuovaVisita.prezzo2 = response.data.prezzo[0].prezzo;
          this.formNuovaVisita.vetrina2 = response.data.vetrina[0].nome;
          break;
          case 3:
          this.formNuovaVisita.prezzo3 = response.data.prezzo[0].prezzo;
          this.formNuovaVisita.vetrina3 = response.data.vetrina[0].nome;
          break;
        }
      })
      .catch(err => {
        console.log(err);
      });
    },
    onSubmitNuovaVisita(){
      event.preventDefault();
      this.$set(this.formNuovaVisita, 'azione', 'nuovaVisita');
      this.$set(this.formNuovaVisita, 'secret', this.$session.get('secret'));

      axios.post( this.$store.state.settings.URL_SERVER+"API/v1.php",this.toFormData(this.formNuovaVisita), {
        headers: {
          'Content-Type': 'application/json'
        }
      }).then(response => {
        console.log(response)
        if (response.status === 200 && response.data.result=="OK") {
          this.sendAlert('success')
          this.clearFormNuovaVisita();
          this.$emit('visitaAggiunta', response.data.result)

        }else{
          this.sendAlert('success')
        }

      })
      .catch(err => {
        console.log(err);
        this.sendAlert('fail');
      });

      this.clearFormNuovaVisita();
      this.$bvModal.hide('modal-nuovaVisita')
    },
    reset () {
      this.item = {}
    },
    selectFromParentComponent1 () {
      // select option from parent component
      this.item = this.options[0]
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
  .form-row{
    background-color: lightgray;
    height: 75px;
    width: 100%;
  }
  .text-center{
    justify-content: center ;
  }
</style>
