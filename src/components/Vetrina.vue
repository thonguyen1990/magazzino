<template>
  <b-container style="height:10vh; background-color-red">
    <loading :active.sync="isLoading"
    :can-cancel="true"
    :is-full-page="true"></loading>

    <b-row  style="">
      <b-col cols>


        <lingallery v-if="build" :responsive="true" :items="imgNow" :showThumbnails="false" :addons="{ enableLargeView: true }" />
      </b-col>
    </b-row>

    <b-row>
      <b-col>
        <b-icon @click="cambiaFoto(-1)" icon="chevron-double-left" font-scale="3" style="float:left; margin-left:1em"></b-icon>
      </b-col>
      <b-col>
        <b-icon v-if="play" @click="cambiaFoto(0)" icon="pause" font-scale="3" style=""></b-icon>
        <b-icon v-if="!play" @click="cambiaFoto(100)" icon="play" font-scale="3" style=""></b-icon>
      </b-col>
      <b-col>
        <b-icon @click="cambiaFoto(1)" icon="chevron-double-right" font-scale="3" style="float:right; margin-right:1em"></b-icon>
      </b-col>
    </b-row>






  </b-container>


</template>

<script>
import axios from "axios";
export default {
  data() {
    return {
      imgs: [],
      imgNow:[],
      conta:0,
      isLoading: false,
      build:false,
      timeUpdate:null,
      play:true,
      timestamp:Date.now()

    };
  },
  mounted() {
    this.isLoading=true;
    axios
    .get(this.$store.state.settings.URL_SERVER+"API/v1.php?vetrina")
    .then(response => {
      console.log(response);
      let lista=[];
      for (let i = 0; i < response.data.img.length; i++) {
        lista.push({id:'s'+i, src: response.data.img[i]+'?'+this.$session.get('secret')+'&'+this.timestamp,thumbnail:response.data.img[i]+'?'+this.$session.get('secret')+'&'+this.timestamp});
      }
      this.imgs=lista;
      this.imgNow.push(lista[0]);
      console.log(lista)
      this.isLoading=false;
      this.currentId=null;
      clearInterval(this.timeUpdate);
      this.timeUpdate=setInterval(this.aggiornaVetrina, 5000);
      this.build=true

    })
    .catch(err => {
      console.log(err);
    });



  },
  methods: {
    cambiaFoto(dir){



      if(dir==0){
          clearInterval(this.timeUpdate);
          console.log("ORA: stop")
          this.play=false;

      }else if(dir==100){
        this.play=true;
        clearInterval(this.timeUpdate);
        this.timeUpdate=setInterval(this.aggiornaVetrina, 5000);
      }else{
        this.play=true;
        this.conta=this.conta+dir;

        if(this.conta>=this.imgs.length){
          this.conta=0;
        }
        if(this.conta<0){
          this.conta=this.imgs.length-1;
        }
        console.log("ORA: "+this.conta)
        this.imgNow=[];
        this.imgNow.push(this.imgs[this.conta]);
      }



    },
    aggiornaVetrina(){
      this.play=true;
      clearInterval(this.timeUpdate);
      this.timeUpdate=setInterval(this.aggiornaVetrina, 5000);
      console.log("aggiorno")
    //  this.build=false
      if(this.conta>=this.imgs.length-1){
          console.log("0")
        this.conta=0;
      }else{
        this.conta++;
          console.log(this.conta)
      }
      this.imgNow=[];
      this.imgNow.push(this.imgs[this.conta]);
    //  this.build=true
    }

  }
};
</script>
