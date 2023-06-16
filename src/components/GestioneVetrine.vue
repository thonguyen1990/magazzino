<template>
  <b-container fluid>
    <loading :active.sync="isLoading"
    :can-cancel="true"
    :is-full-page="true"></loading>

    <div class="mx-auto mb-3 mt-1">
      <b-button v-b-modal.modal-nuova  >CREA NUOVA VETRINA</b-button>
    </div>


    <b-table striped hover
    :fields="fields"
    :items="vetrine"
    >
    <template #cell(immagine)="row">
      <b-img :src="row.item.img+'?'+$session.get('secret')"  width=100></b-img>
    </template>

    <template #cell(nome)="row">
      {{ row.item.nome }}
    </template>
    <template #cell(nomeCat)="row">
      {{ row.item.nomeCat }}
    </template>

    <template #cell(nProdottiAssociati)="row">
      {{ row.item.nProdottiAssociati }}
    </template>

    <template #cell(azione)="row">
      <b-button size="sm" class="mr-1" variant="primary" @click="modificaVetrina(row.item)">Modifica Prodotti</b-button>
      <b-button size="sm" class="ml-1" variant="outline-danger" @click="eliminaProdotti(row.item.id)">Rimuovi tutti i prodotti</b-button>
      <b-button size="sm" class="ml-2" variant="warning" @click="modificaFotoVetrina(row.item)">Modifica Foto</b-button>
      <b-button size="sm" class="ml-2" variant="danger" @click="eliminaVetrina(row.item.id)">Elimina</b-button>
    </template>

  </b-table>

  <b-modal id="modifica-vetrina" hide-footer :title="inModifica.nome" size="xl">
    <div class="insideWrapper" id="canvas-wrapper">
      <b-img :src="inModifica.img+'?'+$session.get('secret')" fluid @load="creaCanvas" id="immagineVetrina"></b-img>
      <canvas  id='myCanvas' class="canvas-overlay"  v-on:click="clickVetrina"></canvas>
    </div>
  </b-modal>

  <b-modal id="modal-prodotto-vetrina" hide-footer :title="titoloModalPunto" size="xl">
    <div class="form-group">
      <b-row>
        <b-col>
          <model-select class="form-control"   :options="optionsProdotti" v-model="puntoSelezionato.puntoProdottoVetrina"
          placeholder="Seleziona il prodotto"></model-select>
        </b-col>

        <b-button v-if="puntoSelezionato.id == null" type="button" @click="salvaPunto()" variant="success">SALVA</b-button>
        <b-button v-if="puntoSelezionato.id != null" type="button" @click="eliminaPunto(puntoSelezionato.id)" variant="danger" class="ml-1">ELIMINA</b-button>
      </b-row>
    </div>
  </b-modal>


  <b-modal id="modal-nuova" hide-footer :title="'NUOVA VETRINA'" size="xl">
    <b-form inline>
      <b-col>
        <b-row>
          <b-col>
            <label class="mr-sm-12" for="inline-form-custom-select-pref">
              Nome vetrina
              <b-form-input id="nomeNuovaVetrina" name="nomeNuovaVetrina" v-model="nomeNuovaVetrina" ref="nomeNuovaVetrina"></b-form-input>
            </label>
          </b-col>
          <b-col>
            <label class="mr-sm-12" for="inline-form-custom-select-pref">
              Categoria
              <model-select class="form-control"   :options="optionsCategorie" v-model="categoriaNuovaVetrina"
              placeholder="Seleziona la categoria"></model-select>
            </label>
          </b-col>
        </b-row>

        <div class="uploaderDiv" v-cloak @drop.prevent="addFile" @dragover.prevent>
          <input type="file" name="file" ref="file" style="display: none" @change="addFileDialog">
          <p>Carica Immagini</p><button type="button" @click="$refs.file.click()">Apri finestra o Trascina</button>
          <ul>
            <li v-bind:key="filex.index" v-for="filex in files">
              {{ filex.name }} ({{ filex.size | bTokb }} kb) <img class="azione" width="20" alt="X"  @click="removeFile(filex)" src="../assets/del.png">
            </li>
          </ul>
        </div>
      </b-col>
      <div v-if="isLoading">
        <b-spinner label="Loading..."></b-spinner>
      </div>
      <br>
      <b-button v-on:click="submitNewVetrina()" >SALVA</b-button>
    </b-form>
  </b-modal>


</b-container>




</template>




<script>
import axios from "axios";
import { ModelSelect } from 'vue-search-select'


export default {
  components: {
    ModelSelect,
  },
  data() {
    return {
      inModifica:{nome:'',larghezza:0,altezza:0},
      fields:[  { key: 'immagine', sortable: false },{ key: 'nome', sortable: true },{ key: 'nomeCat', sortable: true },{ key: 'nProdottiAssociati', sortable: true },{ key: 'azione', sortable: false }],
      vetrine:[],
      file: '',
      files:[],
      fileImage:'',
      idNuovaVetrina:0,
      nomeNuovaVetrina:'',
      categoriaNuovaVetrina:null,
      showAlertSuccess:false,
      showAlertFail:false,
      isLoading: false,
      VetrinaDim:{maxX:0,maxY:0,xPerc:0,yPerc:0},
      ctx:null,
      raggioPunto:10,
      optionsProdotti:[],
      optionsCategorie:[],
      prodotti:[],
      vetrinaProdotti:[],
      puntoSelezionato:{id:null,x:null,y:null,idVetrina:null,puntoProdottoVetrina:null},
      titoloModalPunto:'NUOVO PUNTO',
    };
  },

  mounted() {
    this.getListaCategorie()
    this.listaVetrine()
    this.getListaProdotti()
  },
  watch:{
  },
  computed: {
  },
  methods: {

    creaCanvas(){
      console.log("Creo Canvas");
      let c = document.getElementById('myCanvas');
      this.VetrinaDim.maxX=document.getElementById('immagineVetrina').clientWidth;
      this.VetrinaDim.maxY=document.getElementById('immagineVetrina').clientHeight;
      this.ctx = c.getContext("2d");
      this.ctx.canvas.width  = this.VetrinaDim.maxX;
      this.ctx.canvas.height = this.VetrinaDim.maxY;
      console.log("ctx:" +this.ctx.canvas.width+","+  this.ctx.canvas.height);
      this.VetrinaDim.xPerc=this.VetrinaDim.maxX/this.inModifica.larghezza;
      this.VetrinaDim.yPerc=this.VetrinaDim.maxY/this.inModifica.altezza;

      this.listaProdottiVetrina(this.inModifica.id)
    },
    clickVetrina(){
      var x,y;
      if(event.offsetX) {
        x = event.offsetX;
        y = event.offsetY;
      }
      else if(event.layerX) {
        x = event.layerX;
        y = event.layerY;
      }
      this.puntoSelezionato.x = x / this.VetrinaDim.maxX
      this.puntoSelezionato.y = y / this.VetrinaDim.maxY
      this.puntoSelezionato.idVetrina=this.inModifica.id

      //Controllo se esiste già un punto creato
      this.titoloModalPunto='NUOVO PUNTO'
      for (let i = 0; i < this.vetrinaProdotti.length; i++) {
        let dx = this.puntoSelezionato.x-this.vetrinaProdotti[i].x
        let dy = this.puntoSelezionato.y-this.vetrinaProdotti[i].y
        if( (dx*dx+dy*dy) <= ((this.raggioPunto/this.VetrinaDim.maxX) * (this.raggioPunto/this.VetrinaDim.maxX))) {
          //  this.puntoSelezionato=this.vetrinaProdotti[i]
          this.puntoSelezionato.puntoProdottoVetrina=this.vetrinaProdotti[i].idProdotto
          this.puntoSelezionato.id=this.vetrinaProdotti[i].id
          this.titoloModalPunto='MODIFICA PUNTO'
          break;
        }
      }
      console.log(this.puntoSelezionato)


      this.$bvModal.show('modal-prodotto-vetrina')
    },
    salvaPunto(){
      if (this.puntoSelezionato.puntoProdottoVetrina==null){
        alert("Seleziona un prodotto")
        return 0;
      }
      this.isLoading=true;
      axios.post( this.$store.state.settings.URL_SERVER+'API/v1.php',
      this.toFormData(this.puntoSelezionato),
      {
        headers: {
          'Content-Type': 'multipart/form-data'
        }
      }
    ).then(() => {
      this.isLoading=false;
      this.creaCanvas()
      this.puntoSelezionato={id:null,x:null,y:null,idVetrina:null,puntoProdottoVetrina:null},
      this.$bvModal.hide('modal-prodotto-vetrina')
      this.sendAlert('success');
    })
    .catch(err => {
      console.log(err);
      this.isLoading=false;
      this.sendAlert('fail');
    });
  },
  eliminaPunto(idPunto){
    this.isLoading=true;
    axios
    .get(this.$store.state.settings.URL_SERVER+"API/v1.php?eliminaPuntoVetrina="+idPunto+"&secret="+this.$session.get('secret'))
    .then(response => {
      console.log(response);
      this.$bvModal.hide('modal-prodotto-vetrina')
      this.isLoading=false;
      this.creaCanvas()
      this.puntoSelezionato={id:null,x:null,y:null,idVetrina:null,puntoProdottoVetrina:null}
    })
    .catch(err => {
      console.log(err);
    });
  },
  disegnaAreaProdotto(p){
    this.ctx.lineWidth = 5;
    this.ctx.strokeStyle = '#e9af42';
    //this.ctx.fillStyle = '#e9af42';
    this.ctx.setLineDash([5,5]);
    this.ctx.beginPath();
    this.ctx.arc(p.x*this.VetrinaDim.maxX, p.y*this.VetrinaDim.maxY, this.raggioPunto, 0, 2 * Math.PI, false);
    this.ctx.stroke();
  },
  modificaVetrina(r){
    this.inModifica=r
    this.$bvModal.show('modifica-vetrina')
  },
  modificaFotoVetrina(i){
    this.fileImage=[];
    this.files=[];
    this.nomeNuovaVetrina=i.nome;
    this.categoriaNuovaVetrina=i.idCategoria;
    this.idNuovaVetrina=i.id;
    this.$bvModal.show('modal-nuova')
  },
  listaVetrine(){
    this.isLoading=true;
    axios
    .get(this.$store.state.settings.URL_SERVER+"API/v1.php?listaVetrine&secret="+this.$session.get('secret'))
    .then(response => {
      this.vetrine = response.data.listaVetrine;
      this.isLoading=false;
    })
    .catch(err => {
      console.log(err);
    });
  },
  listaProdottiVetrina(idVetrina){
    this.isLoading=true;
    axios
    .get(this.$store.state.settings.URL_SERVER+"API/v1.php?listaVetrinaProdotti="+idVetrina+"&secret="+this.$session.get('secret'))
    .then(response => {
      console.log(response);
      this.vetrinaProdotti = response.data.listaVetrinaProdotti;
      for (let i = 0; i < this.vetrinaProdotti.length; i++) {
        this.disegnaAreaProdotto(this.vetrinaProdotti[i])
      }
      this.isLoading=false;
    })
    .catch(err => {
      console.log(err);
    });
  },
  getListaCategorie(){
    this.isLoading=true;
    axios
    .get(this.$store.state.settings.URL_SERVER+"API/v1.php?categorieLivello=2&thumb=medium")
    .then(response => {
      console.log(response);
      let lista=[];
      response.data.categorie.map(function(value) {
        lista.push({value:value.id, text:'['+ value.genitore_nome+'] - '+value.nome});
      });
      this.optionsCategorie=lista;
    })
    .catch(err => {
      this.isLoading=false;
      console.log(err);
    });
  },
  getListaProdotti(){
    axios
    .get(this.$store.state.settings.URL_SERVER+"API/v1.php?prodotti")
    .then(response => {
      this.prodotti = response.data.prodotti;
      //  let lista=[{value:0,text:'-CUSTOM-'}];
      let lista=[];
      response.data.prodotti.map(function(value) {
        lista.push({value:value.id, text:value.titolo+' - '+value.descrizione});
      });
      this.optionsProdotti=lista;

    })
    .catch(err => {
      console.log(err);
    });
  },
  submitNewVetrina(){
    this.isLoading=true;
    let formData = new FormData();
    //formData.append('fileImageVetrina', this.fileImage);

    formData.append('IDnuovaVetrina', this.idNuovaVetrina);
    formData.append('nuovaVetrina', this.nomeNuovaVetrina);
    formData.append('categoriaNuovaVetrina', this.categoriaNuovaVetrina);

    this.files.forEach((f,x) => {
      formData.append('fileImageVetrina'+(x+1), f);
    });

    axios.post( this.$store.state.settings.URL_SERVER+'API/v1.php',
    formData,
    {
      headers: {
        'Content-Type': 'multipart/form-data'
      }
    }
  ).then((response) => {
    this.isLoading=false;
    this.resetNuovaVetrina();
    if(response.data.result=="FAIL"){
      this.sendAlert('fail');
      alert(response.data.errore)
    }else{
      this.sendAlert('success');
    }
    this.$bvModal.hide('modal-nuova')

    this.listaVetrine();
    console.log(response)
  })
  .catch(err => {
    console.log(err);
    this.isLoading=false;
    this.sendAlert('fail');
  });
},
eliminaProdotti(idVetrina){
  this.$confirm(
    {
      message: `Sicuro di voler disassociare tutti i prodotti da questa vetrina?`,
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
          .get(this.$store.state.settings.URL_SERVER+"API/v1.php?eliminaProdottiVetrina="+idVetrina+"&secret="+this.$session.get('secret'))
          .then(response => {
            console.log(response);
            this.listaVetrine();
            this.isLoading=false;
          })
          .catch(err => {
            console.log(err);
          });
        }
      }
    }
  )
},
eliminaVetrina(idVetrina){
  this.$confirm(
    {
      message: `Sicuro di voler eliminare la vetrina?`,
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
          .get(this.$store.state.settings.URL_SERVER+"API/v1.php?eliminaVetrina="+idVetrina+"&secret="+this.$session.get('secret'))
          .then(response => {
            console.log(response);
            this.listaVetrine();
            this.isLoading=false;
          })
          .catch(err => {
            console.log(err);
          });
        }
      }
    }
  )
},
resetNuovaVetrina(){
  this.files=[];
  this.fileImage=[];
  this.nomeNuovaVetrina='';
  this.categoriaNuovaVetrina=0;
  this.idNuovaVetrina=0;
},
addFileDialog(e){

  let droppedFiles = e.target.files;
  if(!droppedFiles) return;
  ([...droppedFiles]).forEach(f => {
    this.files.push(f);
  });
},
addFile(e) {
  let droppedFiles = e.dataTransfer.files;
  if(!droppedFiles) return;
  ([...droppedFiles]).forEach(f => {
    this.files.push(f);
  });
},
removeFile(file){
  this.files = this.files.filter(f => {
    return f != file;
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
