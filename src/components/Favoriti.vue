<template>
  <b-container>
    <loading :active.sync="isLoading"
    :can-cancel="true"
    :is-full-page="true"></loading>

<div class="row">
    <b-button  style="float:right; margin-left:1em;margin-bottom:0.1em; margin-top:0.4em"  variant="outline-primary"   @click="rimuoviTutti()"><b-icon icon="trash"></b-icon>Rimuovi tutti</b-button>
</div>
      <div class="row">
      <div v-bind:key="data.index" v-for="data in orderedProducts"  :title="data.titolo"  class="col-md-3 col-sm-6 mt-3" @click="navigaDettaglioo(data.id)">
        <div  class="card h-100" >
          <div v-if="data.postazione!=''" class="postazione"> {{data.postazione}}</div>
          <div v-else class="NOpostazione"> - </div>
           <b-img v-if="data.imgs[0]==null" :src="imagePlace" alt="Responsive image1" img-top class="img-categorie2 "></b-img>
           <b-img v-else :src="data.imgs[0]+'?'+$session.get('secret')" alt="Responsive image2" img-top class="img-categorie2 "></b-img>
           <div class="mt-1 mb-1">

            <div>{{data.titolo}}</div>
            <div>{{data | showdescrizione(cat_mostrare_desc)}}</div>
            <div> {{data.ct | toCT}}</div>
            <div> {{data.prezzo | valuta}}</div>
           </div>
           <b-icon v-if="!data.favorito" v-on:click.stop @click="addFavourite(data.id)" style="position:absolute; bottom:0.1em;right:0.4em" icon="star" font-scale="1.5"></b-icon>
           <b-icon v-if="data.favorito" v-on:click.stop @click="removeFavourite(data.id)" style="position:absolute; bottom:0.1em;right:0.4em" variant="warning" icon="star-fill" font-scale="1.5"></b-icon>

        </div>
      </div>
     </div>
  </b-container>


</template>



<script>
import axios from "axios";
import lodash from 'lodash'
export default {
  data() {
    return {
      prodotti:[],
      listaFavoriti:[],
      cat_mostrare_desc:[],
      cerca:'',
      fasciaPrezzo:0,
      carDa:0,
      carA:0,
      inDebug:false,
      imagePlace: require('@/assets/daverio.jpg'),
      isLoading: false,


    };
  },

  mounted() {
    this.updateProductTable();
  },
  methods: {
    updateProductTable(){
      this.isLoading=true;
      axios
        .get(this.$store.state.settings.URL_SERVER+"API/v1.php?cerca&filtraFavoriti")
        .then(response => {
          this.prodotti = response.data.prodotti;
          this.favoriti();
          this.isLoading=false;
        })
        .catch(err => {
          console.log(err);
        });
    },
    rimuoviTutti(){

      axios
        .get(this.$store.state.settings.URL_SERVER+"API/v1.php?removeAllFavourite")
        .then(response => {
          console.log(response)
          this.updateProductTable();
        })
        .catch(err => {
          console.log(err);
        });
    },
    navigaDettaglioo(id){
      this.$router.push({ name: 'categorie', params: { livello: '4', genitore:id } });
    },
    favoriti(){
      this.isLoading=true;
      axios
      .get(this.$store.state.settings.URL_SERVER+"API/v1.php?favourites")
      .then(response => {
        let myProd=[];

        this.prodotti.forEach(function(prodotto) {
          console.log(prodotto)
          prodotto.favorito=false;
          response.data.favoriti.map(function(fav) {
            if(fav.idProdotto==prodotto.id){
              prodotto.favorito=true;
            }
          });
          myProd.push(prodotto);
        });
        this.prodotti=myProd;
        console.log(this.prodotti)
        this.isLoading=false;
      })
      .catch(err => {
        console.log(err);
      });
    },
    removeFavourite(id){
      axios
      .get(this.$store.state.settings.URL_SERVER+"API/v1.php?removeFavourite&id="+id)
      .then(response => {
        console.log(response);
        this.updateProductTable();
      })
      .catch(err => {
        console.log(err);
      });
    }
  },
computed: {
  orderedProducts: function () {
    return lodash.orderBy(this.prodotti, ['catPrincipale',function (o) { return new Number(o.prezzo); }], ['desc','asc']);
  //  return lodash.sortBy(this.prodotti, ['catPrincipale', 'prezzo'], ['desc', 'asc']);
  }
},
  filters: {
showdescrizione(value, cmd) {

  let categoriaOk=false;

  cmd.forEach(function(item){
    value.categorie.map(function(value) {
        if(value.nome==item){
            categoriaOk=true;
        }
      });
  });



  if (!categoriaOk) return '';

  return value.descrizione;
  }
}
};
</script>
