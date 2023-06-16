<template>
  <div>
    <b-card>
      <template #header>
        <div>
          <b-icon icon="pencil-square"  style="font-size:30px; vertical-align: middle; float:left" @click="modificaNota(myNota)"></b-icon>
          <span style="margin-left:1em;margin-right:1em">{{myNota.titolo}}</span>
          <b-icon icon="trash"  style="font-size:30px; vertical-align: middle; float:right" @click="eliminaNota(myNota.id)"></b-icon>
        </div>
      </template>
      <b-card-text>
        {{myNota.testo | estrattoNota}}
        <b-card-text class="small text-muted">
          <b-row>
            <b-col>
              {{myNota.imgs | nImg}}
            </b-col>
            <b-col cols="6">
              {{myNota.dataOra}}
            </b-col>
            <b-col>
              <span v-if="mostraAltro(myNota.testo,myNota.imgs.length)">
                <b-icon  style="margin-left:1em;float:right"  icon="arrows-fullscreen"  font-scale="1.5" @click="showNota(myNota)"></b-icon>
              </span>
            </b-col>
          </b-row>
        </b-card-text></b-card-text>
      </b-card>
    </div>
  </template>



  <script>
  export default {
    props: ['myNota'],
    data() {
      return {


      };
    },

    mounted() {
    },
    methods: {
      modificaNota(myn){
        this.$emit('modificaNota', myn)
      },
      showNota(myn){
        this.$emit('showNota', myn)
      },
      eliminaNota(id){
        this.$emit('eliminaNota', id)
      },
      mostraAltro(nota,nImg){
        if((nota.length > 60) || (nImg>0)) {
          return true;
        }else{
          return false;
        }
      }
    },
    filters: {
      estrattoNota: function (value) {
        if(value.length > 60) {
          return value.slice(0,60)+"...";
        }
        return value;
      },
      nImg: function (value) {
        if(value.length > 0) {
          return value.length+" foto";
        }
        return "";
      },
    }
  };
  </script>
