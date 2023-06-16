<template>
  <b-container >
    <loading :active.sync="isLoading"
    :can-cancel="true"
    :is-full-page="true"></loading>
    <!--  <b-card-group deck>

    <b-card  v-bind:key="data.index" v-for="data in categorie"  :title="data.nome" img-src="https://picsum.photos/300/300/?image=41" img-alt="Image" img-top class="mb-2">
    <b-card-text>
  </b-card-text>
</b-card>

</b-card-group> -->
<div class="row">
  <div v-bind:key="data.index" v-for="data in prodotti"  :title="data.nome"  class="col-md-12 col-sm-12 mt-12">
    <div class="row">
      <div class="col">
        <span v-bind:key="categoria.index" v-for="categoria in data.categorie" class="txDettaglioCategoria">{{categoria.nomeCat}}</span>
      </div>
      <div class="col">

      </div>
    </div>
    <div class="row">
      <div class="col col-md-6 col-sm-12 mt-6">

        <!--      <lingallery  :responsive="true" :items="itemsImmagini"/>-->
          <ProductZoomer
          :base-images="images"
          :base-zoomer-options="zoomerOptions"
          />
        <!--     <b-img :src="data.imgs[0]" thumbnail fluid alt="Responsive image" img-top class="mt-3"></b-img>-->
      </div>
      <div class="col d-flex justify-content-center">
        <div class="mt-auto mb-auto">
          <h2>
            <div class="txDettaglioTitolo">{{data.titolo}} </div>

          </h2>
          <br><div class="txDettaglioDescrizione">{{data.descrizione}}</div>

          <div class="txDettaglioDescrizione2">
            {{data.descrizione2}}
          </div>
        </div>


      </div>
    </div>
    <div class="row">
      <div class="col col-md-6 col-sm-12 mt-6">
        <div class="txDettaglioPrezzo">
          {{data.prezzo | valuta}}

        </div>
      </div>
    </div>
  </div>
</div>

<b-icon  v-if="!isFavourite" @click="addFavourite()" style="float:right" icon="star" font-scale="2"></b-icon>
<b-icon v-if="isFavourite"  @click="removeFavourite()" style="float:right" icon="star-fill" variant="warning" font-scale="2"></b-icon>





<b-img  :src="require('../assets/daverio_bianco.jpeg')"  fluid alt="Responsive image" width=200 style="position:absolute;bottom:1em; left: 50%;
transform: translate(-50%);"></b-img>

</b-container>


</template>

<script>
//import Lingallery from 'lingallery';

import axios from "axios";
export default {
  data() {
    return {
      prodotti: [],
      itemsImmagini:[],
      width: 600,
      isFavourite:false,
      idCorrente:0,
      isLoading: false,
      images:{
        thumbs:[{id:0,url:'https://interactive-examples.mdn.mozilla.net/media/cc0-images/grapefruit-slice-332-332.jpg'}],
        normal_size:[{id:0,url:'https://interactive-examples.mdn.mozilla.net/media/cc0-images/grapefruit-slice-332-332.jpg'}],
        large_size:[{id:0,url:'https://interactive-examples.mdn.mozilla.net/media/cc0-images/grapefruit-slice-332-332.jpg'}]
      },
      zoomerOptions: {
        zoomFactor: 3, // scale for zoomer
       pane: 'pane', // three type of pane ['pane', 'container-round', 'container']
       hoverDelay: 300, // how long after the zoomer take effect
       namespace: 'zoomer', // add a namespace for zoomer component, useful when on page have mutiple zoomer
       move_by_click:false, // move image by click thumb image or by mouseover
       scroll_items: 5, // thumbs for scroll
       choosed_thumb_border_color: "#bbdefb", // choosed thumb border color
       scroller_position: "bottom",
       zoomer_pane_position: "right"



      },

    };
  },
  components: {
    //  Lingallery
  },

  mounted() {
    this.isLoading=true;
    axios
    .get(this.$store.state.settings.URL_SERVER+"API/v1.php?prodotti&thumb=gallery&condizione_prodotto="+this.$route.params.genitore)
    .then(response => {
      console.log(response)
      this.prodotti = response.data.prodotti;
      this.idCorrente=this.prodotti[0].id;

      let lista=[];
      let listaThumbs=[];
      let listaNormal=[];
      for (let i = 0; i < this.prodotti[0].imgs.length; i++) {
        console.log(this.prodotti[0].imgs[i]);  // <------ ... IT WORKS
        //  lista.push({src:this.prodotti[0].imgs[i],thumbnail:this.prodotti[0].imgs[i]});
        lista.push({id:i,url:this.prodotti[0].imgs[i]});
      }
      for (let i = 0; i < this.prodotti[0].thumbs.length; i++) {
        console.log(this.prodotti[0].thumbs[i]);  // <------ ... IT WORKS
        listaThumbs.push({id:i,url:this.prodotti[0].thumbs[i]});
      }
      for (let i = 0; i < this.prodotti[0].galleryNormal.length; i++) {
        listaNormal.push({id:i,url:this.prodotti[0].galleryNormal[i]});
      }
      //            this.itemsImmagini=lista;
      this.images.large_size=lista;
      this.images.normal_size=listaNormal;
      this.images.thumbs=listaNormal;


      this.favoriti();
      this.isLoading=false;

    })
    .catch(err => {
      console.log(err);
    });
    false;

  },
  methods: {
    favoriti(){
      axios
      .get(this.$store.state.settings.URL_SERVER+"API/v1.php?favourites")
      .then(response => {
        let idCorrente=this.idCorrente;
        let isFavourite=false;
        response.data.favoriti.map(function(value) {
          if(value.idProdotto==idCorrente){
            isFavourite=true;
          }
        });
        this.isFavourite=isFavourite;
      })
      .catch(err => {
        console.log(err);
      });
    },
    addFavourite(){
      axios
      .get(this.$store.state.settings.URL_SERVER+"API/v1.php?addFavourite&id="+this.idCorrente)
      .then(response => {
        console.log(response);
        this.favoriti();

      })
      .catch(err => {
        console.log(err);
      });
    },
    removeFavourite(){
      axios
      .get(this.$store.state.settings.URL_SERVER+"API/v1.php?removeFavourite&id="+this.idCorrente)
      .then(response => {
        console.log(response);
        this.favoriti();
      })
      .catch(err => {
        console.log(err);
      });
    }
  }
};
</script>
