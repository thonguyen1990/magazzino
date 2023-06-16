<template>
  <b-container>
    <loading :active.sync="isLoading"
    :can-cancel="true"
    :is-full-page="true"></loading>
    
  <form >
<div class="form-group">
  <div class="container">
  <div class="row mt-1">
  <div class="align-left"><label>DA</label></div>
  <div class="align-left"><date-picker :lang="lang" 	v-model="daData" valueType="DD/MM/YYYY" ></date-picker> {{daData}}</div>

<div class="align-right ml-4"><label>A</label></div>
<div class="align-right"><date-picker :lang="lang" 	v-model="aData" valueType="DD/MM/YYYY" ></date-picker> {{aData}}</div>
<b-button class="ml-5" v-on:click="getVendite()" >Aggiorna</b-button>
</div>

<div class="align-right sb-3"><multi-select :options="optionsCategorie"
                       :selected-options="selectedCat"
                       placeholder="SELEZIONA LE CATEGORIE DA FILTRARE"
                       @select="onSelect"></multi-select></div>


</div>
</div>




<div>
  <!-- Via multiple directive modifiers -->
  <b-button v-b-toggle.collapse-tab >DATI SINGOLI</b-button>
  <!-- Via space separated string of IDs passed to directive value -->
  <!--
  <b-button class="ml-3 mr-3" v-b-toggle.collapse-b>Toggle Collapse B</b-button>
-->
  <!-- Via array of string IDs passed to directive value -->
  <b-button v-b-toggle.collapse-prod>GRUPPO PRODOTTI</b-button>

  <!-- Elements to collapse -->
  <b-collapse id="collapse-tab" class="mt-2" v-model="TABvisible" >
    Prodotti Venduti: {{nVendite}} - Valore: {{valoreVendite}}€
      <table-component :data="vendite" >
      <table-column show="data" label="Data"></table-column>
      <table-column show="cliente" label="Cliente"></table-column>
      <table-column show="titolo" label="Titolo"></table-column>
      <table-column show="descrizione" label="Desc"></table-column>
      <table-column label="Cat">
        <template slot-scope="row">
            <span v-bind:key="categoria.index"  v-for="categoria in row.categorie" >
              {{categoria}}<br>
            </span>
        </template>
      </table-column>
      <table-column show="prezzo" label="Prezzo"></table-column>
      <table-column show="note" label="Note"></table-column>

    </table-component>
  </b-collapse>
<!--  <b-collapse id="collapse-b" class="mt-2">
    <line-chart  :data="{'2017-01-01': 11, '2018-01-02': 6}"></line-chart>

  </b-collapse>-->
  <b-collapse id="collapse-prod" class="mt-2">
    <table-component :data="groupByProdotti.totali" sort-by="qnt" sort-order="desc">
    <table-column show="titolo" label="Titolo"></table-column>
    <table-column show="qnt" label="Qnt" data-type="numeric"></table-column>
    <table-column show="prezzo_unit" label="Prezzo Cad." data-type="numeric"></table-column>
    <table-column show="prezzo_totale" label="Totale" data-type="numeric"></table-column>
  </table-component>
  </b-collapse>
</div>



  </form>
  <b-alert  v-if="showAlertSuccess" variant="success" show>INSERITO!</b-alert>
  <b-alert v-if="showAlertFail" variant="warning" show>Errore! - VERIFICA CHE IL FILE EXCEL SIA CHIUSO</b-alert>
  <div v-if="showUploadingSpinner">
  <b-spinner label="Loading..."></b-spinner>
  </div>


</b-container>


</template>


<script>
import axios from "axios";
import DatePicker from 'vue2-datepicker';
import { MultiSelect } from 'vue-search-select'
import _ from 'lodash'


export default {
  data() {
    return {
      TABvisible: false,
      dashboard: false,
      vendite:[],
      groupByProdotti:[],
      daData:0,
      aData:0,
      showAlertSuccess:false,
      showAlertFail:false,
      showUploadingSpinner:false,
      nVendite:0,
      valoreVendite:0,
      isLoading: false,
      lang: {
                formatLocale: {
                  monthsShort: ['Gen', 'Feb', 'Mar', 'Apr', 'Mag', 'Giu', 'Lug', 'Ago', 'Set', 'Ott', 'Nov', 'Dec'],
                  weekdaysMin: ['Do', 'Lu', 'Ma', 'Me', 'Gi', 'Ve', 'Sa'],
                  firstDayOfWeek: 1,
                },
                monthBeforeYear: true,
      },
optionsCategorie:[],
      options: [
         { value: '1', text: 'aa' + ' - ' + '1' },
         { value: '2', text: 'ab' + ' - ' + '2' },
         { value: '3', text: 'bc' + ' - ' + '3' },
         { value: '4', text: 'cd' + ' - ' + '4' },
         { value: '5', text: 'de' + ' - ' + '5' }
       ],
       searchText: '', // If value is falsy, reset searchText & searchItem
       selectedCat: [],
       lastSelectItem: {}
    };
  },
  components: {
     DatePicker,
     MultiSelect
   },

  mounted() {
    this.getVendite();
  },
  methods: {
    onSelect (selectedCat, lastSelectItem) {
        this.selectedCat = selectedCat
        this.lastSelectItem = lastSelectItem
      },
      // deselect option
      reset () {
        this.selectedCat = [] // reset
      },
      selectFromParentComponent () {
        this.selectedCat = _.unionWith(this.selectedCat, [this.optionsCategorie[0]], _.isEqual)
      },
      // select option from parent component


getVendite(){
  this.isLoading=true;
  let catString='';
  this.selectedCat.map(function(value) {
    catString=catString+'___'+value.value;
  });

      axios
        .get(this.$store.state.settings.URL_SERVER+"API/v1.php?vendite&daData="+this.daData+"&aData="+this.aData+"&cat="+catString)
        .then(response => {
          this.vendite = response.data.vendite;
          this.groupByProdotti=response.data.stats;
          let nVendite=0;
          let valoreVendite=0;
      //    let dataArray=[];
          response.data.vendite.map(function(value) {
            nVendite++;
            valoreVendite=valoreVendite+value.prezzo;
          //  push({description: '', unitprice: '' , code: ''});
          });
          this.valoreVendite=valoreVendite;
          this.nVendite=nVendite;

          let lista=[];
          response.data.listaCategorie.map(function(value) {
                lista.push({value:value, text:value});
          });
          this.optionsCategorie=lista;

          this.isLoading=false;
        })
        .catch(err => {
          this.isLoading=false;
          console.log(err);
        });
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
