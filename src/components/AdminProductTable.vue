<template>
  <b-container fluid class="main-container my-3">
    <loading :active.sync="isLoading"
    :can-cancel="true"
    :is-full-page="true"></loading>

    <b-row>
      <div class="col text-left">
        <b-form inline>
          <label class="mr-sm-12" for="inline-form-custom-select-pref">
            Aggiorna dati
            <input class="mx-2 file-upload-input" type="file" id="file" ref="file" v-on:change="handleFileUpload()"/>
          </label>
          <div v-if="showUploadingSpinner">
            <b-spinner label="Loading..."></b-spinner>
          </div>

          <b-button v-on:click="submitFile()" class="btn-outline-secondary btn-sm">Carica File</b-button>


        </b-form>
      </div>
      <b-col class="text-right">
        <b-button v-on:click="modificaCategorieBulk()" class="mr-2 btn-outline-secondary btn-sm">Assegna Categoria</b-button>
        <b-button v-on:click="stampaBulk()" class="btn-outline-secondary btn-sm">Stampa</b-button>
      </b-col>
    </b-row>
    <b-alert  v-if="showAlertSuccess" variant="success" show>Completato!</b-alert>
    <b-alert v-if="showAlertFail" variant="warning" show>Errore!</b-alert>
    <b-row class="secound-row my-2">
      <b-col cols="8" class="text-left">
        <b-button v-on:click="selezionaTutto(1)" variant="success" class="btn-outline-success btn-sm">Seleziona Tutto</b-button><b-button variant="danger" v-on:click="selezionaTutto(0)" class="ml-2 btn-outline-danger btn-sm">Deseleziona Tutto</b-button>
      </b-col>
      <b-col cols="2" class="pr-0 text-right">
        Filtra Categoria
      </b-col>
      <b-col class="text-right">
        <model-select id="filtraCat" class="form-control"   :options="optionsCategorie" v-model="filtraCat" placeholder="Filtra categoria"></model-select>
      </b-col>
    </b-row>
<b-row class="third-row mb-2">
  <b-col sm="6">
    <b-form-input
              id="filter-input"
              v-model="filter"
              type="search"
              placeholder="Type to Search" class="filter-input"
            ></b-form-input>
          </b-col>
   <b-col sm="2" class="pr-0">
        <b-form-group
          label="Mostra"
          label-for="per-page-select"
          label-cols-md
          label-cols-lg
          label-align-sm="right"
          label-size="sm"
          class="mb-0"
        >
          <b-form-select
            id="per-page-select"
            v-model="perPage"
            :options="pageOptions"
            size="sm"
          ></b-form-select>
        </b-form-group>
      </b-col>
      <b-col sm="4">
     <b-pagination
       v-model="currentPage"
       :total-rows="totalRows"
       :per-page="perPage"
       align="fill"
       size="sm"
       class="my-0"
     ></b-pagination>
   </b-col>
  </b-row>
    <b-table
     sticky-header="80vh"
      :items="prodottiFiltrati"
      :filter="filter"
      :per-page="perPage"
      :current-page="currentPage"
      @filtered="onFiltered"
      :fields="[{ key: 'x', label: 'X' },{ key: 'qr', label: 'QR' },{ key: 'titolo', label: 'Titolo', sortable: true, sortDirection: 'desc' },{ key: 'descrizione', label: 'Descrizione', sortable: true, sortDirection: 'desc' },
    { key: 'categorie', label: 'Categorie' },{ key: 'prezzo', label: 'Prezzo', sortable: true, sortDirection: 'desc' },{ key: 'ct', label: 'Carati', sortable: true, sortDirection: 'desc' },{ key: 'foto', label: 'Foto' }]"
    >
    <template #cell(x)="row">
      <b-form-checkbox
      v-model="checkProdotto[row.item.id]"
      aria-describedby="flavours"
      aria-controls="flavours"
      ></b-form-checkbox>
    </template>
    <template #cell(qr)="row">
      <a :href="'https://barcode.tec-it.com/barcode.ashx?data='+$store.state.settings.URL_WEBAPP+'%23%2Fqr%2F'+row.item.codice+'&code=Code128&translate-esc=on&quiet=1'" target="_blank" >1D <b-icon  icon="upc"  font-scale="2" ></b-icon></a><br>
      <a :href="'https://barcode.tec-it.com/barcode.ashx?data='+$store.state.settings.URL_WEBAPP+'%23%2Fqr%2F'+row.item.codice+'&code=MobileQRCode&translate-esc=on&quiet=1'" target="_blank" >QR <b-icon  icon="upc"  font-scale="2" ></b-icon></a>
    </template>
    <template #cell(categorie)="row">
      <a v-b-modal.modal-aggiungiCategoria @click="sendInfo(row.item)">Aggiungi</a>
      <p v-bind:key="categoria.index"  v-for="categoria in row.item.categorie" >
        {{categoria.nomeGenitore}} -> {{categoria.nomeCat}}
        <img class="azione" width="20" alt="Vue logo"  @click="deleteCatProd(categoria.idCat,row.item.id)" src="../assets/del.png">
      </p>
    </template>
    <template #cell(foto)="row">
      <a v-b-modal.modal-1 @click="sendInfo(row.item)">Aggiungi</a><br>
      <p v-bind:key="img.index"  v-for="img in row.item.imgs" >
        <b-img :src="img+'?'+$session.get('secret')" :alt="img" width=100></b-img>
        <img class="azione" width="20" alt="Vue logo"  @click="deleteImage(img,row.item.id)" src="../assets/del.png">
      </p>
    </template>
  </b-table>




<!-- INIZIO MODAL UPLOAD IMMAGINE-->
<div>
  <b-modal id="modal-1" hide-footer :title="'CARICA IMMAGINE: '+selectedProduct.titolo" size="xl">
    <b-form >

      <!--<input class="ml-2" type="file" id="fileImage" ref="fileImage" v-on:change="handleFileUploadImage()"/> -->
      <div class="uploaderDiv" v-cloak @drop.prevent="addFile" @dragover.prevent>
        <input type="file" name="file" ref="file" style="display: none" @change="addFileDialog">
        <p>Carica Immagini</p><button type="button" @click="$refs.file.click()">Apri finestra o Trascina</button>

        <ul>
          <li v-bind:key="filex.index" v-for="filex in files">
            {{ filex.name }} ({{ filex.size | bTokb }} kb) <img class="azione" width="20" alt="X"  @click="removeFile(filex)" src="../assets/del.png">
          </li>
        </ul>

        <!--    <button :disabled="uploadDisabled" @click="upload">Upload</button> -->
      </div>

      <br>
      <div v-if="showUploadingSpinner">
        <b-spinner label="Loading..."></b-spinner>
      </div>
      <b-button v-on:click="submitFileImage()">Carica File</b-button>
    </b-form>

  </b-modal>
</div>


<b-modal id="modal-aggiungiCategoria" hide-footer :title="'NUOVA CATEGORIA'" size="xl">
  <b-form inline>
    <label class="mr-sm-12" for="inline-form-custom-select-pref">
      Seleziona categoria
      <b-form-select id="aggiungiCatAProd" name="aggiungiCatAProd" v-model="selectedCategoria" :options="optionsCategorie"   ref="selectedCategoria"></b-form-select>
    </label>
    <br><br>
    <div v-if="showUploadingSpinner">
      <b-spinner label="Loading..."></b-spinner>
    </div>

    <b-button v-on:click="submitNewCat()" >Aggiungi</b-button>
  </b-form>
</b-modal>

<b-modal id="modal-aggiungiCategoriaBulk" hide-footer :title="'NUOVA CATEGORIA - ASSOCIAZIONE MULTIPLA'" size="xl">
  Stai modificano {{nCheck}} prodotti
  <b-form inline>
    <label class="mr-sm-12" for="inline-form-custom-select-pref">
      Seleziona categoria
      <b-form-select id="aggiungiCatAProdBulk" name="aggiungiCatAProdBulk" v-model="selectedCategoriaBulk" :options="optionsCategorie"   ref="selectedCategoriaBulk"></b-form-select>
    </label>
    <br><br>
    <div v-if="showUploadingSpinner">
      <b-spinner label="Loading..."></b-spinner>
    </div>

    <b-button v-on:click="submitNewCatBulk()" >Aggiungi</b-button>
  </b-form>
</b-modal>


<form :action="$store.state.settings.URL_SERVER+'API/zebra/'" method="post" target="_blank" ref="formCodaStampa" id="formCodaStampa">
  <input type="hidden" name="codaStampa" id="codaStampa" v-model="codaStampa" >
</form>


</b-container>




</template>




<script>
import axios from "axios";
import { ModelSelect } from 'vue-search-select'

//import Loading from 'vue-loading-overlay';
// Import stylesheet
//  import 'vue-loading-overlay/dist/vue-loading.css';
// Init plugin
export default {
  data() {
    return {
      fields: ['id', 'titolo','descrizione', '1','2', '3'],
      sortKey: 'id',
      reverse: false,
      search: '',
      prodotti: [],
      categorie: [],
      optionsCategorie:[],
      selectedCategoria:'',
      selectedCategoriaBulk:'',
      file: '',
      files:[],
      fileImage:'',
      showUploadingSpinner:false,
      showAlertSuccess:false,
      showAlertFail:false,
      selectedProduct:'',
      isLoading: false,
      fullPage: true,
      ultimaCategoria:null,
      checkProdotto:{},
      nCheck:0,
      codaStampa:null,
      filtraCat:0,


      filter:'',
      currentPage:1,
      totalRows:1,
      perPage:50,
      pageOptions: [50, 100, { value: 99999999, text: "Tutto" }],

    };
  },
  components:{
    //  Loading
    ModelSelect
  },
  mounted() {
    this.updateProductTable();
    this.updateCategoriesList();
  },
  watch: {
    prodottiFiltrati:{
      handler: function (newVal) {
        this.totalRows = newVal.length
        this.currentPage = 1
      }
    }
   /*filtraCat: {
      handler: function (newVal) {
        console.log(newVal)
        this.pagCorrente=1;
        if(newVal===0){
          this.prodottiFiltro =  this.prodotti
        } else{
          this.prodottiFiltro=this.prodotti.filter(i => {
            return i.categorie.filter(c => (c.idCat == newVal)).length>0
          });
        }
        this.nPag=Math.ceil(this.prodottiFiltro.length/this.MAXPROD);
      }
    },*/


},
  computed: {
    uploadDisabled() {
      return this.files.length === 0;
    },

    prodottiFiltrati: function () {
      this.selezionaTutto(0)

      if(this.filtraCat===0) return this.prodotti

      return this.prodotti.filter(i => {
        return i.categorie.filter(c => (c.idCat == this.filtraCat)).length>0
      })
    },
  },
  methods: {
    onFiltered(filteredItems) {
        // Trigger pagination to update the number of buttons/pages due to filtering
        this.totalRows = filteredItems.length
        this.currentPage = 1
      },
    paginaTab(n){
      this.pagCorrente=n
    },
    selezionaTutto(v){
      this.showUploadingSpinner=true;
      let lista={};
      if(v===1){
        this.prodottiFiltrati.map(function(value) {
        lista[value.id]=true
        });
      }else{
        this.prodotti.map(function(value) {
        lista[value.id]=false
        });
      }
      this.checkProdotto=lista;
      this.showUploadingSpinner=false;
    },
    stampaBulk(){
      let listaProdottiSelezionati =[]
      for (let key in this.checkProdotto) {
        if(this.checkProdotto[key]==true){
          let prodottoSelezionato = this.prodotti.filter(f => {
            if(f.id==key){
              return f
            }
          });
          listaProdottiSelezionati.push(prodottoSelezionato[0])
        }
      }
      var x = document.getElementById("formCodaStampa");
      x.innerHTML = '';
      listaProdottiSelezionati.forEach(function(item){
        let new_field_id = document.createElement("input");
        new_field_id.setAttribute("type", "text");
        new_field_id.setAttribute("name", "id[]");
        new_field_id.setAttribute("value", item.id);
        let pos = x.childElementCount;
        x.insertBefore(new_field_id, x.childNodes[pos]);
        let new_field_codice = document.createElement("input");
        new_field_codice.setAttribute("type", "text");
        new_field_codice.setAttribute("name", "codice[]");
        new_field_codice.setAttribute("value", item.titolo);
        pos = x.childElementCount;
        x.insertBefore(new_field_codice, x.childNodes[pos]);
        let new_field_descrizione = document.createElement("input");
        new_field_descrizione.setAttribute("type", "text");
        new_field_descrizione.setAttribute("name", "descrizione[]");
        new_field_descrizione.setAttribute("value", item.descrizione);
        pos = x.childElementCount;
        x.insertBefore(new_field_descrizione, x.childNodes[pos]);
        let new_field_prezzo = document.createElement("input");
        new_field_prezzo.setAttribute("type", "text");
        new_field_prezzo.setAttribute("name", "prezzo[]");
        new_field_prezzo.setAttribute("value", item.prezzo);
        pos = x.childElementCount;
        x.insertBefore(new_field_prezzo, x.childNodes[pos]);
      })

      this.$refs.formCodaStampa.submit();
      x.innerHTML = '';
      this.codaStampa=null
    },
    modificaCategorieBulk(){
      this.nCheck=0
      for (let key in this.checkProdotto) {
        if(this.checkProdotto[key]==true)
        this.nCheck=this.nCheck+1
      }
      this.$bvModal.show('modal-aggiungiCategoriaBulk')
    },
    submitNewCatBulk(){
      console.log("cat bulk")
      let idProdotti=[]
      for (let key in this.checkProdotto) {
        if(this.checkProdotto[key]==true)
        idProdotti.push(key)
      }
      this.showUploadingSpinner=true;
      let formData = new FormData();
      formData.append('idProdotto', idProdotti.join(','));
      formData.append('aggiungiCatAProdBulk', this.selectedCategoriaBulk);
      axios.post( this.$store.state.settings.URL_SERVER+'API/v1.php',
      formData,
      {
        headers: {
          'Content-Type': 'multipart/form-data'
        }
      }
    ).then(response => {

      console.log(response.data);
      console.log('SUCCESS!!');
      this.fileImage='';
      this.showUploadingSpinner=false;
      //  this.selectedCategoria='';
      this.sendAlert('success');
      this.updateProductTable();
      this.$bvModal.hide('modal-aggiungiCategoriaBulk')

    })
    .catch(err => {

      console.log(err);
      this.showUploadingSpinner=false;
      this.sendAlert('fail');
    });
  },
  updateProductTable(){

    this.isLoading = true;
    axios
    .get(this.$store.state.settings.URL_SERVER+"API/v1.php?prodotti&thumb=small")
    .then(response => {
      console.log(response)
      this.prodotti = response.data.prodotti;
      this.totalRows = this.prodotti.length
      let lista={};
      this.prodotti.map(function(value) {
        if(value.livello==2){
          lista[value.id]=0;
        }
      });
      this.checkProdotto=lista;
      this.isLoading = false;
    })
    .catch(err => {
      console.log(err);
    });
  },
  updateCategoriesList(){
    axios
    .get(this.$store.state.settings.URL_SERVER+"API/v1.php?categorie&thumb=small")
    .then(response => {
      this.categorie = response.data.categorie;
      let lista=[{value:0,text:'-'}];
      response.data.categorie.map(function(value) {
        if(value.livello==2){
          lista.push({value:value.id,text:value.genitore_nome+'->'+value.nome});
        }
      });
      this.optionsCategorie=lista;

    })
    .catch(err => {
      console.log(err);
    });
  },
  sendInfo(item) {
    console.log(item)
    this.selectedProduct = item;
  },
  handleFileUpload(){
    this.file = this.$refs.file.files[0];
  },
  submitFile(){
    this.showUploadingSpinner=true;
    let formData = new FormData();
    formData.append('file', this.file);


    axios.post(this.$store.state.settings.URL_SERVER+'API/upload.php',
    formData,
    {
      headers: {
        'Content-Type': 'multipart/form-data'
      }
    }
  ).then(() => {
    console.log('SUCCESS!!');
    this.file = '';
    this.showUploadingSpinner=false;
    this.$refs.file.value=null;
    this.sendAlert('success');
    this.updateProductTable();
  })
  .catch(err => {
    console.log(err);
    this.showUploadingSpinner=false;
    this.sendAlert('fail');
  });
},
handleFileUploadImage(){
  this.fileImage = this.$refs.fileImage.files[0];
},
submitFileImage(){

  this.showUploadingSpinner=true;
  let formData = new FormData();
  formData.append('fileImage', this.fileImage);
  formData.append('idProdotto', this.selectedProduct.id);
  formData.append('titoloProdotto', this.selectedProduct.titolo);

  //  this.files.forEach((f,x) => {
  this.files.forEach((f,x) => {
    //formData.append('fileImage', f);
    formData.append('fileImage'+(x+1), f);
  });


  axios.post( this.$store.state.settings.URL_SERVER+'API/v1.php',
  formData,
  {
    headers: {
      'Content-Type': 'multipart/form-data'
    }
  }
).then(response => {

  console.log(response);
  console.log('SUCCESS!!');
  //this.fileImage='';
  this.showUploadingSpinner=false;
  this.fileImage=[];

  //  this.$refs.fileImage.value=null;
  this.sendAlert('success');
  this.updateProductTable();

})
.catch(err => {
  alert("3");
  console.log(err);
  this.showUploadingSpinner=false;
  this.sendAlert('fail');
});
},
deleteImage(img,idP){

  axios
  .get(this.$store.state.settings.URL_SERVER+"API/v1.php?deleteImage="+img+"&idP="+idP)
  .then(() => {
    console.log("deleted");
    this.updateProductTable();
  })
  .catch(err => {
    console.log(err);
  });

},
submitNewCat(){
  this.showUploadingSpinner=true;
  let formData = new FormData();
  formData.append('idProdotto', this.selectedProduct.id);
  formData.append('aggiungiCatAProd', this.selectedCategoria);
  axios.post( this.$store.state.settings.URL_SERVER+'API/v1.php',
  formData,
  {
    headers: {
      'Content-Type': 'multipart/form-data'
    }
  }
).then(response => {

  console.log(response.data);
  console.log('SUCCESS!!');
  this.fileImage='';
  this.showUploadingSpinner=false;
  //  this.selectedCategoria='';
  this.sendAlert('success');
  this.updateProductTable();
  this.$bvModal.hide('modal-aggiungiCategoria')

})
.catch(err => {

  console.log(err);
  this.showUploadingSpinner=false;
  this.sendAlert('fail');
});
},
deleteCatProd(idCat,idProd){
  let formData = new FormData();
  formData.append('rimuoviCatAProd', idCat);
  formData.append('idProdotto', idProd);
  axios.post( this.$store.state.settings.URL_SERVER+'API/v1.php',
  formData,
  {
    headers: {
      'Content-Type': 'multipart/form-data'
    }
  }
).then(() => {
  console.log("deleted");
  this.updateProductTable();
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

sortBy: function(sortKey) {
  this.reverse = (this.sortKey == sortKey) ? ! this.reverse : false;
  alert('Sort: ' + sortKey + '!')
  this.sortKey = sortKey;
},
formatterPrezzo(value) {
  return `€ ${value}`;
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

}
};
</script>

<style>

.file-upload-input {
  border: 1px solid  #ddd;
  border-radius: 4px;
}

.main-container .btn-outline-secondary,.btn-outline-danger, .btn-outline-success {
  background-color: white !important;
}

.secound-row {
  display: flex;
  align-items: center;
}

.third-row .filter-input {
  width: 70%;
}

.btn-outline-danger:hover {
    background-color: #dc3545 !important;
}

.btn-outline-success:hover {
    background-color: #28a745 !important;
}

</style>