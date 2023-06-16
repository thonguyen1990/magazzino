<template>
  <b-container>
    <loading :active.sync="isLoading"
    :can-cancel="true"
    :is-full-page="true"></loading>

    <div>
      <!--  <b-card-group deck>

      <b-card  v-bind:key="data.index" v-for="data in categorie"  :title="data.nome" img-src="https://picsum.photos/300/300/?image=41" img-alt="Image" img-top class="mb-2">
      <b-card-text>
    </b-card-text>
  </b-card>

</b-card-group> -->
<div class="row">
  <div v-bind:key="data.index" v-for="data in categorie"  :title="data.nome"  @click="navigaProdotti(data.id)" class="col-md-3 col-sm-6 mt-3">
    <div  class="card h-100" >
      <!-- <b-img :src="data.img+'?'+$session.get('secret')" alt="Responsive image" img-top class="img-categorie2 "></b-img> -->

      <img v-if="data.vetrineInterattive.length==0" v-img :src="data.img+'?'+$session.get('secret')+'&'+timestamp" alt="Responsive image" img-top class="img-categorie2 " @click.stop="">
      <img v-else :src="data.img+'?'+$session.get('secret')+'&'+timestamp" alt="Responsive image" img-top class="img-categorie2 " @click="showInterattiva(data)">
      <div class="txtCategoria mt-3 mb-3">
        {{data.nome}}
      </div>
      <p class="card-text text-right" style="position:absolute;bottom:0;right:1em"><small class="text-muted">{{data.nProdotti | prodottOI}}</small></p>
    </div>
  </div>
</div>
</div>


<b-modal id="vetrina-interattiva" size="xl" hide-footer modal-class="modal-fullscreen2">
  <template #modal-header="{ close }">
    <!-- Emulate built in modal header close button action -->
    <b-button size="sm" variant="outline-danger" @click="close()">Chiudi</b-button>
    <b-button v-if="nascondiTuttiTagButton" href="#" variant="outline-warning" @click="nascondiTuttiTag(vetrinaVisualizzata)"><b-icon icon="eye-slash" variant="outline-warning"></b-icon>Nascondi TAG</b-button>
    <b-button v-else href="#" variant="outline-warning" @click="ripristinaTag(vetrinaVisualizzata)"><b-icon icon="eye" variant="outline-warning"></b-icon>Visualizza TAG</b-button>
    <!-- <b-button v-if="vetrinaTagNascosti.length>0" href="#" variant="outline-warning" @click="ripristinaTagNascosti()">Ripristina TAG</b-button>-->
    <b-button v-if="currentVetrineInterattive.length>1" size="sm" variant="primary" @click="nextVetrina()">
      Prossima >
    </b-button>
    <h5>{{currentVetrineInterattive[nVetrinaSelezionata].nome}}</h5>
  </template>
  <b-row>
    <b-col>
      <div  style="margin:auto" class="insideWrapper" id="canvas-wrapper">
        <span v-bind:key="myVetrina.index" v-for="myVetrina in currentVetrineInterattive">
          <div v-if="myVetrina.id==currentVetrineInterattive[nVetrinaSelezionata].id" class="insideWrapper" id="canvas-wrapper">
            <b-img :src="myVetrina.img+'?'+$session.get('secret')+'&'+timestamp" fluid  @load="creaCanvas(myVetrina)" :id="'immagineVetrina'+ myVetrina.id" class="immagine-vetrina"></b-img>
            <canvas  :id="'myCanvas' + myVetrina.id" class="canvas-overlay"  v-on:click="clickVetrina(myVetrina)"></canvas>
          </div>
        </span>
      </div>
    </b-col>
    <b-col cols="3" class="overflow-auto" >
      <div style="max-height: 60vh">
        Prodotti Selezionati
        <b-card
        v-for="it in prodottiSelezionati.slice().reverse()"
        v-bind:key="it.index"
        :title="it.titolo"
        :img-src="it.imgs[0]+'?'+$session.get('secret')"
        img-alt="Image"
        img-top
        tag="article"
        style="max-width: 20rem;"
        class="mb-2"
        >
        <b-card-text>
          {{it.descrizione}}
          {{it.prezzo}}
        </b-card-text>
        <b-button href="#" variant="outline-warning" @click="nascondiTag(it)"><b-icon icon="eye-slash" variant="outline-warning"></b-icon></b-button>
        <b-button href="#" variant="outline-primary" @click="nascondiProdotto(it)">Rimuovi</b-button>
        <b-button href="#" variant="primary" style="float:right" @click="navigaDettaglioProdotto(it.id)">Vai</b-button>
      </b-card>
    </div>
  </b-col>
</b-row>
</b-modal>
<!--
<div v-if="displayVetrina" class="immagine-vetrina">
<div v-bind:key="myVetrina.index" v-for="myVetrina in currentVetrineInterattive" class="insideWrapper" id="canvas-wrapper">
<b-img :src="myVetrina.img+'?'+$session.get('secret')" fluid @load="creaCanvas" id="immagineVetrina"></b-img>
<canvas  id='myCanvas' class="canvas-overlay"  v-on:click="clickVetrina"></canvas>
</div>
</div>-->





</b-container>


</template>

<script>
import axios from "axios";
export default {
  data() {
    return {
      categorie: [],
      vetrine:[],
      currentVetrineInterattive:[],
      vetrinaVisualizzata:null,
      isLoading: false,
      displayVetrina:false,
      vetrineCanvas:[],
      //VetrinaDim:{maxX:0,maxY:0,xPerc:0,yPerc:0,ctx:null},
      ctx:null,
      raggioPunto:10,
      puntoSelezionato:{id:null,x:null,y:null,idVetrina:null,puntoProdottoVetrina:null},
      vetrinaProdotti:[],
      vetrinaTagNascosti:[],
      prodottiSelezionati:[],
      nVetrinaSelezionata:0,
      timestamp:Date.now(),
      nascondiTuttiTagButton:true,


    };
  },
  mounted() {
    this.listaVetrine();
  },
  methods: {
    nascondiTuttiTag(vet){
      this.nascondiTuttiTagButton=false
      this.clearVetrina(vet)
    },
    ripristinaTag(vet){
      console.log(vet.idCategoria)
      this.$bvModal.hide('vetrina-interattiva')
      var thisCat = this.categorie.filter(c => vet.idCategoria == c.id)[0];

      this.showInterattiva(thisCat)
    },
    caricaProdotti(){
      this.isLoading=true;
      axios
      .get(this.$store.state.settings.URL_SERVER+"API/v1.php?categorieLivello=2&thumb=medium&genitore="+this.$route.params.genitore)
      .then(response => {
        console.log(response);

        this.categorie = response.data.categorie;
        //Aggiungio Le vetrine interattive
        for (let i = 0; i < this.categorie.length; i++) {
          this.categorie[i].vetrineInterattive=[];
          for (let k = 0; k < this.vetrine.length; k++) {
            if(this.vetrine[k].idCategoria==this.categorie[i].id){
              this.categorie[i].vetrineInterattive.push(this.vetrine[k].id)
            }
          }

        }
        console.log("a")
        console.log(this.categorie)
        this.isLoading=false;
      })
      .catch(err => {
        this.isLoading=false;
        console.log(err);
      });
    },
    navigaProdotti(id){
      this.$router.push({ name: 'categorie', params: { livello: '3', genitore:id } });
    },
    navigaDettaglioProdotto(id){
      this.$router.push({ name: 'categorie', params: { livello: '4', genitore:id } });
    },
    nextVetrina(){
      if(this.nVetrinaSelezionata>=(this.currentVetrineInterattive.length-1)){
        this.nVetrinaSelezionata=0;
      }else{
        this.nVetrinaSelezionata++;
      }
    },
    creaCanvas(myV){
      this.nascondiTuttiTagButton=true
console.log("old")
console.log(this.vetrineCanvas)
      //NEWWWWWWWWWWWWWWWWW****************************
      this.vetrineCanvas = this.vetrineCanvas.filter(item => item.id != myV.id)
      //*********************************************
      console.log(this.vetrineCanvas)
      console.log("Creo Canvas");
      let c = document.getElementById('myCanvas' + myV.id);
      let vt = {id:0, maxX:0,maxY:0,xPerc:0,yPerc:0,ctx:null};
      console.log('immagineVetrina'+ myV.id);
      vt.maxX=document.getElementById('immagineVetrina'+ myV.id).clientWidth;
      vt.maxY=document.getElementById('immagineVetrina'+ myV.id).clientHeight;
      vt.ctx = c.getContext("2d");
      vt.ctx.canvas.width  = vt.maxX;
      vt.ctx.canvas.height = vt.maxY;
      vt.xPerc=vt.maxX/myV.larghezza;
      vt.yPerc=vt.maxY/myV.altezza;
      vt.id=myV.id
      this.vetrineCanvas.push(vt)
      this.listaProdottiVetrina(myV.id)

    },
    clickVetrina(myV){
      var x,y;
      if(event.offsetX) {
        x = event.offsetX;
        y = event.offsetY;
      }
      else if(event.layerX) {
        x = event.layerX;
        y = event.layerY;
      }
      console.log("Selezionato0: "+x +" "+ y)

      let canvasCorrente = this.vetrineCanvas.filter(item => item.id == myV.id)[0]
console.log(canvasCorrente)
      this.puntoSelezionato.x = x / canvasCorrente.maxX
      this.puntoSelezionato.y = y / canvasCorrente.maxY
      this.puntoSelezionato.idVetrina=canvasCorrente.id

      console.log("Selezionato: "+this.puntoSelezionato.x +" "+ this.puntoSelezionato.y)
      //Controllo se esiste già un punto creato
      for (let i = 0; i < this.vetrinaProdotti.length; i++) {
        console.log("Controllo: "+this.vetrinaProdotti[i].x +" "+ this.vetrinaProdotti[i].y)
        if(canvasCorrente.id==this.vetrinaProdotti[i].idVetrina){
          console.log("Stessa vetrina")
          let dx = this.puntoSelezionato.x-this.vetrinaProdotti[i].x
          let dy = this.puntoSelezionato.y-this.vetrinaProdotti[i].y
          if( (dx*dx+dy*dy) <= ((this.raggioPunto/canvasCorrente.maxX) * (this.raggioPunto/canvasCorrente.maxX))) {
            console.log("Coincide")
            this.infoProdotto(this.vetrinaProdotti[i].idProdotto)
            break;
          }
        }
      }


      this.$bvModal.show('modal-prodotto-vetrina')
    },
    listaProdottiVetrina(idVetrina){
      this.isLoading=true;
      axios
      .get(this.$store.state.settings.URL_SERVER+"API/v1.php?listaVetrinaProdotti="+idVetrina+"&secret="+this.$session.get('secret'))
      .then(response => {
        console.log("Vetrina prodotti");
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
    infoProdotto(idP){
      this.isLoading=true;
      axios
      .get(this.$store.state.settings.URL_SERVER+"API/v1.php?prodotti&condizione_prodotto="+idP)
      .then(response => {
        this.prodottiSelezionati.push(response.data.prodotti[0]);
        this.isLoading=false;

      })
      .catch(err => {
        this.isLoading=false;
        console.log(err);
      });

    },
    nascondiProdotto(p){
      this.prodottiSelezionati = this.prodottiSelezionati.filter(item => item !== p)
    },
    nascondiTag(p){
      console.log("rebuild")
      this.vetrinaTagNascosti.push(p.id)
      console.log(this.vetrinaVisualizzata)

      this.clearVetrina(this.vetrinaVisualizzata)
      this.creaCanvas(this.vetrinaVisualizzata)
      this.nascondiProdotto(p)
    },
    clearVetrina(clearVt){
      this.vetrineCanvas.forEach(vt => {
        if(vt.id==clearVt.id)
            vt.ctx.clearRect(0, 0, vt.ctx.canvas.width, vt.ctx.canvas.height);
      });

    },
    disegnaAreaProdotto(p){
      let draw=true
      this.vetrinaTagNascosti.forEach(tagId => {
        console.log(tagId)
        if(tagId==p.idProdotto){
          draw=false
          console.log("Insdie")
        }

      });
      console.log(draw)
      if (draw){
        let i=0
        for (let k=0 ; k < this.vetrineCanvas.length; k++){
          if(p.idVetrina== this.vetrineCanvas[k].id) i=k;
        }
        this.vetrineCanvas[i].ctx.lineWidth = 5;
        this.vetrineCanvas[i].ctx.strokeStyle = '#e9af42';
        //this.ctx.fillStyle = '#e9af42';
        this.vetrineCanvas[i].ctx.setLineDash([5,5]);
        this.vetrineCanvas[i].ctx.beginPath();
        this.vetrineCanvas[i].ctx.arc(p.x*this.vetrineCanvas[i].maxX, p.y*this.vetrineCanvas[i].maxY, this.raggioPunto, 0, 2 * Math.PI, false);
        this.vetrineCanvas[i].ctx.stroke();
      }

    },
    showInterattiva(cat){
      this.vetrinaTagNascosti=[]

      event.stopPropagation();
      //this.currentVetrinaInterattiva=cat
      this.displayVetrina=true
      this.currentVetrineInterattive = this.vetrine.filter(v => v.idCategoria == cat.id);
      this.vetrinaVisualizzata = this.currentVetrineInterattive[0]

      this.$bvModal.show('vetrina-interattiva')

    },
    listaVetrine(){
      this.isLoading=true;
      axios
      .get(this.$store.state.settings.URL_SERVER+"API/v1.php?listaVetrine&secret="+this.$session.get('secret'))
      .then(response => {
        console.log(response);
        this.vetrine = response.data.listaVetrine;
        this.isLoading=false;
        this.caricaProdotti();
      })
      .catch(err => {
        console.log(err);
      });
    },
  },
  filters:{
    prodottOI(n){
      if(n==1){
        return "1 Prodotto";
      }else{
        return n+" Prodotti";
      }
    }
  }
};
</script>
