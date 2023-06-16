<template>
  <b-container>

    <loading :active.sync="isLoading"
    :can-cancel="true"
    :is-full-page="true"></loading>

    <div class="mx-auto mb-3 mt-1">
      <b-button v-b-modal.modal-nuova  >CREA NUOVA CATEGORIA</b-button>
    </div>
    <b-alert  v-if="showAlertSuccess" variant="success" show>Completato!</b-alert>
    <b-alert v-if="showAlertFail" variant="warning" show>Errore!</b-alert>


    <table-component :data="categorie" sort-by="id" sort-order="asc">
      <table-column  label="Azioni" :sortable="false" :filterable="false">
        <template slot-scope="row">
          <img class="azione" width="20" alt="x"  @click="deleteCat(row.id)" src="../assets/del.png" />
          <img  v-b-modal.modal-genitore width="20" alt="EditN"  @click="sendInfo(row)" src="../assets/edit.png" style="margin-left:1.5em"/>
        </template>
      </table-column>
      <table-column show="id" label="ID"></table-column>
      <table-column show="pos" label="Pos"></table-column>
      <table-column show="nome" label="Nome"></table-column>
      <table-column show="genitore_nome" label="Cat.Genitore"></table-column>
      <table-column show="nProdotti" label="Num.Prodotti"></table-column>

      <table-column label="Immagine" :sortable="false" :filterable="false">
        <template slot-scope="row">
          <b-img v-if="row.img != ''" :src="row.img+'?'+$session.get('secret')" width=100></b-img>
        </template>
      </table-column>
      <table-column label="Associa">
        <template slot-scope="row">
          <b-button @click="associaProdotti(row.id)">Prodotti</b-button>
        </template>
      </table-column>
      <table-column label="Svuota Categoria">
        <template slot-scope="row">
          <b-button @click="svuotaCategoria(row.id)">Svuota</b-button>
        </template>
      </table-column>
    </table-component>

    <!--
    <thead>
    <tr>
    <th scope="col" >Elimina</th>
    <th scope="col" >Modifica</th>
    <th scope="col" ><sort-link name="id">ID</sort-link></th>
    <th scope="col" >POS</th>
    <th scope="col" ><sort-link name="nome">NOME CATEGORIA</sort-link></th>
    <th scope="col">CAT. GENITORE</th>
    <th scope="col">IMMAGINE</th>
  </tr>
</thead>
<template #body="sort">
<tbody >

<tr :key="data.id" v-for="data in sort.categorie">
<td>  <img width="20" alt="x"  @click="deleteCat(data.id)" src="../assets/del.png" /></td>
<td> <img  v-b-modal.modal-genitore width="20" alt="EditN"  @click="sendInfo(data)" src="../assets/edit.png" /></td>
<td>{{data.id}}</td>
<td>{{data.pos}}</td>
<td>{{data.nome}}</td>
<td>{{data.genitore_nome}}</td>
<td><b-img v-if="data.img != ''" :src="data.img" width=100></b-img></td>


</tr>
</tbody>
</template>
</sorted-table>-->
<!-- INIZIO MODAL UPLOAD IMMAGINE-->
<div>

</div>

<div>
  <b-modal id="modal-genitore" hide-footer :title="'MODIFICA CATEGORIA: '+selectedCategory.nome"  size="xl">
    <b-form>
      <label class="mr-sm-12" for="inline-form-custom-select-pref">
        Nome categoria
        <b-form-input id="editNameCat" name="editNameCat" v-model="nameEdit"></b-form-input>
      </label><br>
      <label class="mr-sm-12" for="inline-form-custom-select-pref">
        Categoria genitore
        <b-form-select id="editGen" name="editGen" v-model="selectedGenitore" :options="optionsGenitore"  ></b-form-select>
      </label>
      <br>
      <label class="mr-sm-12" for="inline-form-custom-select-pref">
        Posizione (numero intero)
        <b-form-input id="posEdit" name="posEdit" v-model="posEdit" ref="posEdit"></b-form-input>
      </label>
      <br>
      <label class="" for="">
        Descrizione
        <b-form-textarea cols="100" id="ediDescCat" name="ediDescCat" v-model="descrizioneEdit"></b-form-textarea>
      </label>
      <br>
      <label class="mr-sm-12" for="inline-form-custom-select-pref">
        Nuova immagine
        <input class="ml-2" type="file" id="fileImageCat" ref="fileImageCat" v-on:change="handleFileUploadImage()"/>
      </label>
      <div v-if="showUploadingSpinner">
        <b-spinner label="Loading..."></b-spinner>
      </div>
      <br><br>
      <b-button v-on:click="submitUpdateCat()" >Aggiorna</b-button>
    </b-form>
  </b-modal>

  <b-modal id="modal-nuova" hide-footer :title="'NUOVA CATEGORIA'">
    <b-form inline>
      <label class="mr-sm-12" for="inline-form-custom-select-pref">
        Nome categoria
        <b-form-input id="nomeCatNew" name="nomeCatNew" v-model="nameNew" ref="nameNew"></b-form-input>
      </label>
      <label class="mr-sm-12" for="inline-form-custom-select-pref">
        Categoria genitore
        <b-form-select id="genitoreCatNew" name="genitoreCatNew" v-model="selectedGenitoreNew" :options="optionsGenitore"   ref="selectedGenitoreNew"></b-form-select>
      </label>
      <br><br>
      <label class="mr-sm-12" for="inline-form-custom-select-pref">
        Posizione (numero intero)
        <b-form-input id="posNew" name="posNew" v-model="posNew" ref="posNew"></b-form-input>
      </label>
      <label class="mr-sm-12" for="inline-form-custom-select-pref">
        Descrizione
        <b-form-input id="descNew" name="descNew" v-model="descrizioneNew"></b-form-input>
      </label>
      <label class="mr-sm-12" for="inline-form-custom-select-pref">
        Nuova immagine
        <input class="ml-2" type="file" id="fileImageCatNew" ref="fileImageCat" v-on:change="handleFileUploadImage()"/>
      </label>
      <div v-if="showUploadingSpinner">
        <b-spinner label="Loading..."></b-spinner>
      </div>

      <b-button v-on:click="submitNewCat()" >Aggiorna</b-button>
    </b-form>
  </b-modal>
</div>


<b-modal id="modal-prodott-categoria" hide-footer :title="'Associa Prodotti'" size="xl">
  <div class="form-group">
    <b-row>
      <b-col>
        <multi-select class="form-control"   :options="optionsProdotti" :selected-options="prodottiSelzionati"  @select="onSelectProdotto"
        placeholder="Seleziona il prodotto"></multi-select>
      </b-col>
    </b-row>
  </div>
</b-modal>


</b-container>


</template>




<script>
import axios from "axios";
import { MultiSelect } from 'vue-search-select'
import _ from 'lodash'

export default {
  components: {
    MultiSelect,
  },
  data() {
    return {
      prodotti:[],
      optionsProdotti:null,
      prodottiAssociati:null,
      prodottiSelzionati: [],
      ultimoProdottoSelezionato: {},
      idCategoriaSelezionata:0,


      categorie: [],
      optionsGenitore:[],
      selectedGenitore:'',
      file: '',
      fileImage:'',
      showUploadingSpinner:false,
      showAlertSuccess:false,
      showAlertFail:false,
      selectedCategory:'',
      nameEdit:'',
      selectedGenitoreNew:0,
      nameNew:'',
      descrizioneNew:'',
      descrizioneEdit:'',
      posNew:'',
      posEdit:'',
      isLoading: false,

    };
  },

  mounted() {
    this.updateProductTable();
  },
  methods: {


  onSelectProdotto (items, lastSelectItem) {

    let formData = new FormData();
    formData.append('idProdotto', lastSelectItem.value);
    formData.append('aggiungiCatAProd', this.idCategoriaSelezionata);

    axios.post( this.$store.state.settings.URL_SERVER+'API/v1.php',
    formData,
    {
      headers: {
        'Content-Type': 'multipart/form-data'
      }
    }
  ).then(response => {
    console.log(response.data);
    this.sendAlert('success');
  })
  .catch(err => {
    console.log(err);
    this.sendAlert('fail');
  });


  this.prodottiSelzionati = items
  this.ultimoProdottoSelezionato = lastSelectItem
},
// deselect option
reset () {
  this.prodottiSelzionati = [] // reset
},
// select option from parent component
selectFromParentComponent () {
  this.prodottiSelzionati = _.unionWith(this.prodottiSelzionati, [this.optionsProdotti[0]], _.isEqual)
},

updateProductTable(){
  this.isLoading=true;

  axios
  .get(this.$store.state.settings.URL_SERVER+"API/v1.php?categorie&thumb=small")
  .then(response => {
    //console.log(response)
    this.categorie = response.data.categorie;
    let lista=[{value:0,text:'-'}];
    response.data.categorie.map(function(value) {
      if(value.livello==1){
        lista.push({value:value.id,text:value.nome});
      }
    });
    this.optionsGenitore=lista;
    this.isLoading=false;
  })
  .catch(err => {
    console.log(err);
  });
},
sendInfo(item) {
  this.selectedGenitore=item.genitore;
  this.nameEdit=item.nome;
  this.posEdit=item.pos;
  this.descrizioneEdit=item.descrizioneCat;
  this.selectedCategory = item;
},

handleFileUploadImage(){
  this.fileImage = this.$refs.fileImageCat.files[0];
},
submitUpdateCat(){
  this.isLoading=true;
  this.showUploadingSpinner=true;
  let formData = new FormData();
  formData.append('fileImageCat', this.fileImage);
  formData.append('idCatUpdate', this.selectedCategory.id);
  formData.append('nomeCatUpdate', this.nameEdit);
  formData.append('descrizioneCatUpdate', this.descrizioneEdit);
  formData.append('posCatUpdate', this.posEdit);
  formData.append('genitoreCatUpdate', this.selectedGenitore);
  axios.post( this.$store.state.settings.URL_SERVER+"API/v1.php",
  formData,
  {
    headers: {
      'Content-Type': 'multipart/form-data'
    }
  }
).then(response => {

  console.log(response);
  console.log('SUCCESS!!');
  this.fileImage='';

  this.showUploadingSpinner=false;
  this.$refs.fileImageCat.value=null;
  this.isLoading=false;
  this.sendAlert('success');

  setTimeout(()=>this.updateProductTable(),1000);
  this.$bvModal.hide('modal-genitore')

})
.catch(err => {
  this.isLoading=false;
  console.log(err);
  this.showUploadingSpinner=false;
  this.sendAlert('fail');
});
},
submitNewCat(){
  this.isLoading=true;
  this.showUploadingSpinner=true;
  let formData = new FormData();
  formData.append('fileImageCat', this.fileImage);
  formData.append('nomeCatNew', this.nameNew);
  formData.append('posCatNew', this.posNew);
  formData.append('descrizioneCatNew', this.descrizioneNew);
  formData.append('genitoreCatNew', this.selectedGenitoreNew);
  axios.post( this.$store.state.settings.URL_SERVER+"API/v1.php",
  formData,
  {
    headers: {
      'Content-Type': 'multipart/form-data'
    }
  }
).then(response => {

  console.log(response);
  console.log('SUCCESS!!');
  this.fileImage='';
  this.showUploadingSpinner=false;
  this.isLoading=false;
  this.$refs.fileImageCat.value=null;
  this.nameNew='';
  this.posNew='';
  this.descrizioneNew='';

  this.selectedGenitoreNew=0;
  this.sendAlert('success');
  this.updateProductTable();
  this.$bvModal.hide('modal-nuova')

})
.catch(err => {

  console.log(err);
  this.showUploadingSpinner=false;
  this.isLoading=false;
  this.sendAlert('fail');
});
},
deleteCat(id){
  this.$confirm(
    {
      message: 'Sicuro di voler eliminare la categoria?',
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
          axios
          .get(this.$store.state.settings.URL_SERVER+"API/v1.php?deleteCategory="+id)
          .then(() => {
            console.log("deleted");
            this.sendAlert('success');
            this.updateProductTable();
          })
          .catch(err => {
            this.sendAlert('fail');
            console.log(err);
          });
        }
      }
    }
  )

},
associaProdotti(id){
  this.idCategoriaSelezionata=0;
  this.prodottiSelzionati= []
  this.ultimoProdottoSelezionato= {}

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

    this.idCategoriaSelezionata=id;



      axios
      .get(this.$store.state.settings.URL_SERVER+"API/v1.php?prodotti&thumb=medium&condizione_categoria="+id)
      .then(response => {
        this.prodotti = response.data.prodotti;
      })
      .catch(err => {
        console.log(err);
      });


    this.$bvModal.show('modal-prodott-categoria')
  })
  .catch(err => {
    console.log(err);
  });
},
svuotaCategoria(id){
  this.$confirm(
    {
      message: `Confermi di voler disassociare tutti i prodotti da questa categoria?`,
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
          .get(this.$store.state.settings.URL_SERVER+"API/v1.php?svuotaCategoria&id="+id+"&secret="+this.$session.get('secret'))
          .then(response => {
            if (response.status === 200 && response.data.result=="OK") {
              this.sendAlert('success')
            }else{
              this.sendAlert('fail')
            }
            this.isLoading=false;
          })
          .catch(err => {
            console.log(err);
            this.sendAlert('fail');
            this.isLoading=false;
          });
        }
      }
    }
  )
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
