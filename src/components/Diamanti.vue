<template>
  <b-container fluid>
    <loading :active.sync="isLoading"
    :can-cancel="true"
    :is-full-page="true"></loading>
    <b-col>
      <b-row style="margin-top:0.3em; margin-bottom:0.1em">
<b-col>
        <b-form-radio-group
        id="filtro-disponibilita"
        v-model="filtroDisponibilita"
        :options="[
        { text: 'Tutto', value: 'TUTTO' },
        { text: 'A Magazzino', value: 'MAGAZZINO' },
        { text: 'Non Disponibili', value: 'NONDISPONIBILI' }]"
        button-variant="outline-primary"
        name="filtro-disponibilita"
        buttons
        ></b-form-radio-group>
</b-col>
<b-col>
        <b-row class="btn-group btn-group-toggle mr-1 ml-2 mt-1" data-toggle="buttons">
          <label class="btn btn-outline-primary"  v-bind:class="{ active: tipoTutto }">
            <input type="radio" name="options_categoria2" id="tutto" autocomplete="off" @click="filtroTipo('tutto')">Tutto
          </label>
          <label class="btn btn-outline-primary"  v-bind:class="{ active: ciondoli }">
            <input type="radio" name="options_categoria2" id="ciondoli" autocomplete="off" @click="filtroTipo('ciondoli')">CIONDOLI
          </label>
          <label class="btn btn-outline-primary"  v-bind:class="{ active: orecchini }">
            <input type="radio" name="options_categoria2" id="orecchini" autocomplete="off" @click="filtroTipo('orecchini')" >ORECCHINI
          </label>
          <label class="btn btn-outline-primary"  v-bind:class="{ active: fedine }">
            <input type="radio" name="options_categoria2" id="fedine" autocomplete="off" @click="filtroTipo('fedine')" >FEDINE
          </label>
          <label class="btn btn-outline-primary"  v-bind:class="{ active: anelliSolitari }">
            <input type="radio" name="options_categoria2" id="anelliSolitari" autocomplete="off" @click="filtroTipo('anelliSolitari')" >ANELLI SOLITARI
          </label>
          <label class="btn btn-outline-primary"  v-bind:class="{ active: tennis }">
            <input type="radio" name="options_categoria2" id="tennis" autocomplete="off" @click="filtroTipo('tennis')" >TENNIS
          </label>
        </b-row >
        </b-col>
      </b-row>

            <b-input-group class="mt-1">
              <b-form-input
                id="filter-input"
                v-model="filterTable"
                type="search"
                placeholder="Scrivi per filtrare"
              ></b-form-input>
            </b-input-group>


      <b-table striped hover
        :fields="fields"
        :items="filtroDisponibilitaArray"
        :filter="filterTable"
        :filter-included-fields="filterOn"
        :tbody-tr-class="rowClass"
        >


      </b-table>


    </b-col>




  </b-container>



</template>




<script>
import axios from "axios";



export default {
  components: {

  },
  data() {
    return {
      fields: [
          { key: 'titolo', sortable: true },
          { key: 'postazione', sortable: true },
          { key: 'ct', sortable: true },
          { key: 'colore', sortable: true },
          { key: 'purezza', sortable: true },
          { key: 'taglio', sortable: true },
          { key: 'prezzo', sortable: true }
      ],
      filterTable:'',
      filterOn: [
        'titolo','postazione','ct','colore','purezza','taglio','prezzo'
      ],
      diamanti: [],
      tipoTutto:true,
      anelli:false,
      ciondoli:false,
      orecchini:false,
      fedine:false,
      anelliSolitari:false,
      tennis:false,
      showAlertSuccess:false,
      showAlertFail:false,
      isLoading: false,
      filtroDisponibilita:'TUTTO'
    };
  },

  mounted() {
    this.filtroTipo('tutto')

    this.updateDiamantiTable();
    if(this.$route.params.disponibilita!=undefined){
      this.filtroDisponibilita=this.$route.params.disponibilita;
    }
  },
  watch:{
    $route (){
      if(this.$route.params.disponibilita!=undefined){
        this.filtroDisponibilita=this.$route.params.disponibilita;
      }else{
        this.filtroDisponibilita='TUTTO'
      }
    },
  },

  computed: {

    filtroDisponibilitaArray: function () {
      let fDisp=this.filtroDisponibilita;
      let myA=this.anelli;
      let myC=this.ciondoli;
      let myO=this.orecchini;
      let myFedine=this.fedine;
      let myanelliSolitari=this.anelliSolitari;
      let myTennis=this.tennis;
      let myTUTTO=this.tipoTutto;

      return this.diamanti.filter(function (diamante) {
        let returnDiamante=false;
        if(myTUTTO){
          returnDiamante=true;
        }
        if(myA){
          if(diamante.titolo.search("CL A")!=-1){
            returnDiamante=true;
          }
        }
        if(myC){
          if(diamante.titolo.search("CL C")!=-1){
            returnDiamante=true;
          }
        }
        if(myO){
          if(diamante.titolo.search("CL O")!=-1){
            returnDiamante=true;
          }
        }
        if(myFedine){
          if(diamante.fedina){
            returnDiamante=true;
          }
        }
        if(myanelliSolitari){
          if(diamante.anelloSolitario){
            returnDiamante=true;
          }
        }
        if(myTennis){
          if(diamante.tennis){
            returnDiamante=true;
          }
        }

        if(returnDiamante)
        {
          if(fDisp==='TUTTO'){
            return diamante;
          }else if(fDisp==='MAGAZZINO'){
            if(diamante.disponibile==true){
              return diamante;
            }
          }else{
            if(diamante.disponibile==false){
              return diamante;
            }
          }
        }

      }).sort((a, b) => a.ordineDescrizione - b.ordineDescrizione);



    },

  },
  methods: {
    rowClass(item, type) {
        if (!item || type !== 'row') return
        if (!item.disponibile) return 'table-secondary'
      },
    filtroTipo(t){
      this.anelli = false;
      this.orecchini = false;
      this.fedine = false;
      this.anelliSolitari = false;
      this.tennis = false;
      this.tipoTutto = false;
      this.ciondoli = false;
      if(t=='tutto'){
        this.tipoTutto = true;
      }
      if(t=='anelli'){
        this.anelli = true;
      }
      if(t=='orecchini'){
        this.orecchini = true;
      }
      if(t=='fedine'){
        this.fedine = true;
      }
      if(t=='anelliSolitari'){
        this.anelliSolitari = true;
      }
      if(t=='ciondoli'){
        this.ciondoli = true;
      }
      if(t=='tennis'){
        this.tennis = true;
      }

    },
    formatter(value, rowProperties) {
      if(rowProperties.disponibile=='false')
      return '<div class="nonDisp">Hi, I am ${value}</div>';
    },
    updateDiamantiTable(){
      this.isLoading=true;
      axios
      .get(this.$store.state.settings.URL_SERVER+"API/v1.php?diamanti&secret="+this.$session.get('secret'))
      .then(response => {
        console.log(response);
        this.diamanti = response.data.diamanti;
        this.isLoading=false;
      })
      .catch(err => {
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
    toFormData: function(obj) {
      let formData = new FormData();
      for(let key in obj) {
        formData.append(key, obj[key]);
      }
      return formData;
    },

  },
  filters: {

  }
};
</script>
