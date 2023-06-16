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
          <label class="btn btn-outline-primary"  v-bind:class="{ active: materialeTutto }">
            <input type="radio" name="options_materiale" id="materialeTutto" autocomplete="off" @click="filtroMateriale('tutto')">Tutto
          </label>
          <label class="btn btn-outline-primary"  v-bind:class="{ active: ob }">
            <input type="radio" name="options_materiale" id="ob" autocomplete="off" @click="filtroMateriale('ob')">Oro Bianco
          </label>
          <label class="btn btn-outline-primary"  v-bind:class="{ active: or }">
            <input type="radio" name="options_materiale" id="or" autocomplete="off" @click="filtroMateriale('or')" >Oro Rosa
          </label>
          <label class="btn btn-outline-primary"  v-bind:class="{ active: tit }">
            <input type="radio" name="options_materiale" id="tit" autocomplete="off" @click="filtroMateriale('tit')" >Titanio
          </label>
        </b-row >
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
          <label class="btn btn-outline-primary"  v-bind:class="{ active: bracciali }">
            <input type="radio" name="options_categoria2" id="bracciali" autocomplete="off" @click="filtroTipo('bracciali')" >BRACCIALETTI
          </label>
          <label class="btn btn-outline-primary"  v-bind:class="{ active: anelli }">
            <input type="radio" name="options_categoria2" id="anelli" autocomplete="off" @click="filtroTipo('anelli')" >ANELLI
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
        <template #cell(img)="data">
          <img v-if="data.value" v-img :src="data.value+'?'+$session.get('secret')" alt="Pietra image" img-top  />
        </template>

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
          { key: 'titolo', sortable: true },{ key: 'descrizione', sortable: true },
          { key: 'postazione', sortable: true },
          { key: 'ct', sortable: true },
          { key: 'colore', sortable: true },
          { key: 'purezza', sortable: true },
          { key: 'taglio', sortable: true },
          { key: 'prezzo', sortable: true },
          { key: 'img', sortable: false }
      ],
      filterTable:'',
      filterOn: [
        'titolo','descrizione','postazione','ct','colore','purezza','taglio','prezzo'
      ],
      diamanti: [],
      pietre:[],
      tipoTutto:true,
      anelli:false,
      ciondoli:false,
      orecchini:false,
      bracciali:false,

      materialeTutto:true,
      or:false,
      ob:false,
      tit:false,

      showAlertSuccess:false,
      showAlertFail:false,
      isLoading: false,
      filtroDisponibilita:'TUTTO',
      pietra: ''
    };
  },

  mounted() {
    this.filtroTipo('tutto')

    if(this.$route.params.disponibilita!=undefined){
      this.filtroDisponibilita=this.$route.params.disponibilita;
    }
    if(this.$route.params.pietra!=undefined){
      this.pietra=this.$route.params.pietra;
    }
    this.updateDiamantiTable();

  },
  watch:{
    $route (){
      if(this.$route.params.disponibilita!=undefined){
        this.filtroDisponibilita=this.$route.params.disponibilita;
      }else{
        this.filtroDisponibilita='TUTTO'
      }

      if(this.$route.params.pietra!=undefined){
        this.pietra=this.$route.params.pietra;
          this.updateDiamantiTable();
      }else{
        this.pietra=''
      }
    },
  },

  computed: {

    filtroDisponibilitaArray: function () {
      let fDisp=this.filtroDisponibilita;

      let myCiondoli=this.ciondoli;
      let myOrecchini=this.orecchini;
      let myBraccialetti=this.bracciali;
      let myAnelli=this.anelli;
      let myTipoTutto=this.tipoTutto;

      let myTit=this.tit;
      let myOb=this.ob;
      let myOr=this.or;
      let myMaterialeTutto=this.materialeTutto;

      return this.pietre.filter(function (diamante) {
        let returnDiamante=false;
        let returnDiamanteMateriale=false;
        if(myTipoTutto){
          returnDiamante=true;
        }
        if(myCiondoli){
          if(diamante.ciondoli){
            returnDiamante=true;
          }
        }
        if(myOrecchini){
          if(diamante.orecchini){
            returnDiamante=true;
          }
        }
        if(myBraccialetti){
          if(diamante.braccialetti){
            returnDiamante=true;
          }
        }
        if(myAnelli){
          if(diamante.anelli){
            returnDiamante=true;
          }
        }

        if(myMaterialeTutto){
          returnDiamanteMateriale=true;
        }
        if(myOb){
          if(diamante.oroBianco){
            returnDiamanteMateriale=true;
          }
        }
        if(myOr){
          if(diamante.oroRosa){
            returnDiamanteMateriale=true;
          }
        }
        if(myTit){
          if(diamante.titanio){
            returnDiamanteMateriale=true;
          }
        }


        if(returnDiamante && returnDiamanteMateriale)
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
      this.tipoTutto = false;
      this.anelli = false;
      this.orecchini = false;
      this.bracciali = false;
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
      if(t=='bracciali'){
        this.bracciali = true;
      }
      if(t=='ciondoli'){
        this.ciondoli = true;
      }
    },
    filtroMateriale(t){
      this.materialeTutto = false;
      this.or = false;
      this.ob = false;
      this.tit = false;
      if(t=='tutto'){
        this.materialeTutto = true;
      }
      if(t=='or'){
        this.or = true;
      }
      if(t=='ob'){
        this.ob = true;
      }
      if(t=='tit'){
        this.tit = true;
      }
    },
    formatter(value, rowProperties) {
      if(rowProperties.disponibile=='false')
      return '<div class="nonDisp">Hi, I am ${value}</div>';
    },
    updateDiamantiTable(){
      this.isLoading=true;
      axios
      .get(this.$store.state.settings.URL_SERVER+"API/v1.php?pietre="+this.pietra+"&secret="+this.$session.get('secret'))
      .then(response => {
        console.log(response);
        this.pietre = response.data.pietre;
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
