<template>
  <div class="split-main-div d-flex w-100">
    <b-navbar class="navmenu navbar-custom" toggleable="lg">
      <b-img
        :src="require('../assets/soloLogo_b.png')"
        fluid
        alt="Responsive image"
        width="16"
      ></b-img>
      <b-navbar-brand class="navitem-custom" to="/"
        ><span class="itemNB ms-1">HOME</span></b-navbar-brand
      >
      <b-navbar-brand v-if="$route.params.livello > 1" @click="$router.go(-1)"
        ><span class="itemNB">INDIETRO</span></b-navbar-brand
      >
      <b-navbar-brand v-if="$route.name == 'search'" @click="$router.go(-1)"
        ><span class="itemNB">INDIETRO</span></b-navbar-brand
      >
      <b-navbar-toggle target="nav-collapse"></b-navbar-toggle>

      <b-collapse id="nav-collapse" is-nav>
        <!-- Right aligned nav items -->
        <b-navbar-nav class="ml-auto">
          <b-nav-form>
            <b-nav-item-dropdown href="#">
              <template #button-content>
                <span
                  ><span class="itemNB"
                    ><b-icon
                      style="margin-right: 1em"
                      icon="gem"
                      font-scale="1.3"
                    ></b-icon></span
                ></span>
              </template>
              <b-dropdown-item href="#" to="/diamanti/TUTTO"
                >Diamanti</b-dropdown-item
              >
              <b-dropdown-item href="#" to="/pietre/diamanti_brown/TUTTO"
                >Diamanti Brown</b-dropdown-item
              >
              <b-dropdown-item href="#" to="/pietre/diamanti_multicolor/TUTTO"
                >Diamanti Multicolor</b-dropdown-item
              >
              <b-dropdown-item href="#" to="/pietre/diamanti_neri/TUTTO"
                >Diamanti Neri</b-dropdown-item
              >

              <b-dropdown-item href="#" to="/pietre/h20/TUTTO"
                >Acqua Marina</b-dropdown-item
              >
              <b-dropdown-item href="#" to="/pietre/perle/TUTTO"
                >Perle</b-dropdown-item
              >
              <b-dropdown-item href="#" to="/pietre/quarzo/TUTTO"
                >Quarzo</b-dropdown-item
              >
              <b-dropdown-item href="#" to="/pietre/rubini/TUTTO"
                >Rubini</b-dropdown-item
              >
              <b-dropdown-item href="#" to="/pietre/smeraldi/TUTTO"
                >Smeraldi</b-dropdown-item
              >
              <b-dropdown-item href="#" to="/pietre/topazio/TUTTO"
                >Topazio</b-dropdown-item
              >
              <b-dropdown-item href="#" to="/pietre/tanzanite/TUTTO"
                >Tanzanite</b-dropdown-item
              >

              <b-dropdown-item href="#" to="/pietre/zaffiri/TUTTO"
                >Zaffiri</b-dropdown-item
              >
              <b-dropdown-item href="#" to="/pietre/altre/TUTTO"
                >Altre Pietre</b-dropdown-item
              >
            </b-nav-item-dropdown>
            <b-b-nav-item to="/favoriti"
              ><span class="itemNB"
                ><b-icon
                  style="margin-right: 1em"
                  icon="heart-fill"
                  font-scale="1.3"
                ></b-icon></span
            ></b-b-nav-item>
            <b-b-nav-item to="/note"
              ><span class="itemNB"
                ><b-icon
                  style="margin-right: 1em"
                  icon="pencil-square"
                  font-scale="1.3"
                ></b-icon></span
            ></b-b-nav-item>
            <b-b-nav-item to="/nuoviarrivi" class="mr-2"
              ><span class="itemNB"
                ><b-icon icon="clock" font-scale="1.3"></b-icon></span
            ></b-b-nav-item>

            <b-button v-b-modal.modal-filtro size="sm" class="">
              <b-icon icon="funnel-fill" font-scale="1.3"></b-icon>
              <span class="buttonNB">{{ this.altriFiltri }}</span></b-button
            >
            <div class="ml-1 mr-1">
              {{ this.prezzoTxt }}
              <span v-if="this.prezzoTxt != ''"><br /></span>{{ this.carTxt }}
            </div>
            <b-form-input
              size="sm"
              class="mr-sm-2"
              placeholder="Cerca un prodotto"
              v-model="prodotto"
            >
            </b-form-input>
            <b-button
              size="sm"
              class="my-1 buttonNB"
              @click="cercaProdotto(prodotto)"
              ><span size="sm" class="buttonNB">Cerca</span></b-button
            >
          </b-nav-form>
        </b-navbar-nav>
        <b-b-nav-item to="/agenda"
          ><b-icon
            icon="gear-fill"
            font-scale="1.3"
            style="margin-left: 2em"
          ></b-icon
        ></b-b-nav-item>
        <b-b-nav-item class="navitem-custom">
          <span class="itemNB">
            <b-icon
              style="margin-right: 1em"
              icon="calculator"
              font-scale="1.3"
              @click="toggleCalCulator()"
            ></b-icon>

            <Calculator v-if="calc"></Calculator>
          </span>
        </b-b-nav-item>
        <b-b-nav-item v-if="goldPrice">{{ goldPrice }} €/gr</b-b-nav-item>
      </b-collapse>
    </b-navbar>
  </div>
</template>
<script>
import axios from "axios";
import Calculator from "../components/Calculator.vue";

export default {
  props: ["idCategoria"],
  components: { Calculator },
  data() {
    return {
      goldPrice: null,
      calc: false,
      prodotto: "",
      prezzoTxt: "",
      carTxt: "",
      altriFiltri: "",
      carDa: 0,
      carA: 0,
      carNO: true,
      fascia: 0,
      fasciap1: 0,
      fasciap2: 0,
      fasciaAttiva0: true,
      fasciaAttiva1: false,
      fasciaAttiva2: false,
      fasciaAttiva3: false,
      fasciaAttiva4: false,
      fasciaAttiva5: false,
      fasciaAttiva6: false,
      fasciact1: 0,
      fasciact2: 0,
      ct_fasciaAttiva0: true,
      ct_fasciaAttiva1: false,
      ct_fasciaAttiva2: false,
      ct_fasciaAttiva3: false,
      ct_fasciaAttiva4: false,
      ct_fasciaAttiva5: false,
      ct_fasciaAttiva6: false,
      ct_fasciaAttiva7: false,
      ct_fasciaAttiva8: false,
      classiciTutto: true,
      classici: false,
      classiciColorati: false,
      Fanelli: false,
      Fbraccialetti: false,
      Fciondoli: false,
      Forecchini: false,
      FtipoTutto: true,
      oroTutto: true,
      oroRosa: false,
      oroBianco: false,
      catAttuale: 0,
      filtroTipoClassici: "tutto",
      filtroTipoTipo: "tutto",
      filtroTipoMateriale: "tutto",

      maxCT: 0,
    };
  },
  mounted() {
    this.$session.set("tipo", "FE");

    this.getGoldPrice();
    this.getMaxCT();
    if (this.idCategoria != undefined) {
      this.catAttuale = this.idCategoria;
    } else {
      if (this.$route.params.catAttuale > 0) {
        this.catAttuale = this.$route.params.catAttuale;
      }
    }

    if (this.$route.params.txt != undefined) {
      this.cerca = this.$route.params.txt;
    }
    if (this.$route.params.fasciap1 != undefined) {
      this.fasciap1 = this.$route.params.fasciap1;
    }
    if (this.$route.params.fasciap2 != undefined) {
      this.fasciap2 = this.$route.params.fasciap2;
    }
    if (this.$route.params.fasciact1 != undefined) {
      this.fasciact1 = this.$route.params.fasciact1;
    }
    if (this.$route.params.fasciact2 != undefined) {
      this.fasciact2 = this.$route.params.fasciact2;
    }
    if (this.$route.params.filtroTipoClassici != undefined) {
      this.classiciTutto = false;
      this.classici = false;
      this.classiciColorati = false;
      this.filtroTipoClassici = this.$route.params.filtroTipoClassici;
      switch (this.filtroTipoClassici) {
        case "C":
          this.classici = true;
          break;
        case "CC":
          this.classiciColorati = true;
          break;
        default:
          this.classiciTutto = true;
      }
    }
    if (this.$route.params.filtroTipoTipo != undefined) {
      this.filtroTipoTipo = this.$route.params.filtroTipoTipo;
      this.Fanelli = false;
      this.Fbraccialetti = false;
      this.Fciondoli = false;
      this.Forecchini = false;
      this.FtipoTutto = false;
      switch (this.filtroTipoTipo) {
        case "anelli":
          this.Fanelli = true;
          break;
        case "braccialetti":
          this.Fbraccialetti = true;
          break;
        case "ciondoli":
          this.Fciondoli = true;
          break;
        case "orecchini":
          this.Forecchini = true;
          break;
        default:
          this.FtipoTutto = true;
      }
    }
    if (this.$route.params.filtroTipoMateriale != undefined) {
      this.filtroTipoMateriale = this.$route.params.filtroTipoMateriale;
      this.oroBianco = false;
      this.oroRosa = false;
      this.oroTutto = false;
      switch (this.filtroTipoMateriale) {
        case "OB":
          this.oroBianco = true;
          break;
        case "OR":
          this.oroRosa = true;
          break;
        default:
          this.oroTutto = true;
      }
    }
    if (this.$route.params.catAttuale != undefined) {
      this.catAttuale = this.$route.params.catAttuale;
    }
    this.isFiltriAttivi();
  },
  methods: {
    chiusuraModale() {
      this.isFiltriAttivi();
    },
    resetFiltri() {
      (this.carTxt = ""), (this.altriFiltri = ""), (this.fascia = 0);
      this.fasciap1 = 0;
      this.fasciap2 = 0;
      this.fasciaAttiva0 = true;
      this.fasciaAttiva1 = false;
      this.fasciaAttiva3 = false;
      this.fasciaAttiva2 = false;
      this.fasciaAttiva4 = false;
      this.fasciaAttiva5 = false;
      this.fasciaAttiva6 = false;
      this.fasciact2 = 0;
      this.fasciact1 = 0;
      this.ct_fasciaAttiva0 = true;
      this.ct_fasciaAttiva1 = false;
      this.ct_fasciaAttiva3 = false;
      this.ct_fasciaAttiva2 = false;
      this.ct_fasciaAttiva4 = false;
      this.ct_fasciaAttiva5 = false;
      this.ct_fasciaAttiva6 = false;
      this.ct_fasciaAttiva7 = false;
      this.ct_fasciaAttiva8 = false;
      this.classiciTutto = true;
      this.classiciColorati = false;
      this.classici = false;
      this.Fanelli = false;
      this.Fbraccialetti = false;
      this.Fciondoli = false;
      this.Forecchini = false;
      this.FtipoTutto = true;
      this.oroTutto = true;
      this.oroRosa = false;
      this.oroBianco = false;
    },
    isFiltriAttivi() {
      let nFiltri = 0;

      if (this.classici || this.classiciColorati) nFiltri++;
      if (this.oroRosa || this.oroBianco) nFiltri++;
      if (this.fasciap1 > 0 || this.fasciap2 > 0) nFiltri++;
      if (this.fasciact1 > 0 || this.fasciact2 > 0) nFiltri++;

      if (nFiltri > 0) {
        this.altriFiltri = "(" + nFiltri + ")";
      } else {
        this.altriFiltri = "";
      }
    },
    getGoldPrice() {
      axios
        .get(this.$store.state.settings.URL_SERVER + "API/v1.php?sole24Gold")
        .then((response) => {
          if (response.status === 200 && response.data.stato == "OK") {
            this.goldPrice = response.data.prezzo;
          } else {
            this.goldPrice = null;
          }
        })
        .catch((err) => {
          console.log(err);
        });
    },
    getMaxCT() {
      axios
        .get(this.$store.state.settings.URL_SERVER + "API/v1.php?maxCT")
        .then((response) => {
          this.maxCT = response.data.maxCT;
        })
        .catch((err) => {
          console.log(err);
        });
    },
    cercaProdotto(p) {
      if (p == "") {
        p = "ALLPRODUCTS";
      }

      this.$router.replace({
        name: "search",
        params: {
          txt: p,
          fasciap1: this.fasciap1,
          fasciap2: this.fasciap2,
          fasciact1: this.fasciact1,
          fasciact2: this.fasciact2,
          filtroTipoClassici: this.filtroTipoClassici,
          filtroTipoTipo: this.filtroTipoTipo,
          filtroTipoMateriale: this.filtroTipoMateriale,
          catAttuale: this.catAttuale,
        },
        force: true,
      });
    },
    filtroClassici(t) {
      this.classici = false;
      this.classiciColorati = false;
      this.classiciTutto = false;
      if (t == "tutto") {
        this.classiciTutto = true;
        this.filtroTipoClassici = "tutto";
      }
      if (t == "classici") {
        this.classici = true;
        this.filtroTipoClassici = "C";
      }
      if (t == "classiciColorati") {
        this.classiciColorati = true;
        this.filtroTipoClassici = "CC";
      }
    },
    selezionaMateriale(t) {
      this.oroBianco = false;
      this.oroRosa = false;
      this.oroTutto = false;
      if (t == "tutto") {
        this.oroTutto = true;
        this.filtroTipoMateriale = "tutto";
      }
      if (t == "oroBianco") {
        this.oroBianco = true;
        this.filtroTipoMateriale = "OB";
      }
      if (t == "oroRosa") {
        this.oroRosa = true;
        this.filtroTipoMateriale = "OR";
      }
    },
    filtroFTipo(t) {
      this.Fanelli = false;
      this.Fbraccialetti = false;
      this.Fciondoli = false;
      this.Forecchini = false;
      this.FtipoTutto = false;

      if (t == "tutto") {
        this.FtipoTutto = true;
        this.filtroTipoTipo = "tutto";
      }
      if (t == "anelli") {
        this.Fanelli = true;
        this.filtroTipoTipo = "anelli";
      }
      if (t == "braccialetti") {
        this.Fbraccialetti = true;
        this.filtroTipoTipo = "braccialetti";
      }
      if (t == "ciondoli") {
        this.Fciondoli = true;
        this.filtroTipoTipo = "ciondoli";
      }
      if (t == "orecchini") {
        this.Forecchini = true;
        this.filtroTipoTipo = "orecchini";
      }
    },
    selezionaFasciaPrezzo(idFascia) {
      this.fasciap1 = idFascia;
      this.fasciaAttiva0 = false;

      this.fasciaAttiva0 = false;
      this.fasciaAttiva1 = false;
      this.fasciaAttiva2 = false;
      this.fasciaAttiva3 = false;
      this.fasciaAttiva4 = false;
      this.fasciaAttiva5 = false;
      this.fasciaAttiva6 = false;
      this.prezzoTxt = "Prezzo: ";
      switch (this.fasciap1) {
        case 0:
          this.fasciaAttiva0 = true;
          this.prezzoTxt = "";
          break;
        case 1:
          this.fasciaAttiva1 = true;
          this.prezzoTxt = this.prezzoTxt + " <500€";
          break;
        case 2:
          this.fasciaAttiva2 = true;
          this.prezzoTxt = this.prezzoTxt + " 500-1000€";
          break;
        case 3:
          this.fasciaAttiva3 = true;
          this.prezzoTxt = this.prezzoTxt + " 1000-2000€";
          break;
        case 4:
          this.fasciaAttiva4 = true;
          this.prezzoTxt = this.prezzoTxt + " 2000-3000€";
          break;
        case 5:
          this.fasciaAttiva5 = true;
          this.prezzoTxt = this.prezzoTxt + " 3000-6000€";
          break;
        case 6:
          this.fasciaAttiva6 = true;
          this.prezzoTxt = this.prezzoTxt + " >6000€";
          break;
      }
    },
    selezionaFasciaCt(idFascia) {
      this.fasciact1 = idFascia;
      this.ct_fasciaAttiva0 = false;
      this.ct_fasciaAttiva1 = false;
      this.ct_fasciaAttiva2 = false;
      this.ct_fasciaAttiva3 = false;
      this.ct_fasciaAttiva4 = false;
      this.ct_fasciaAttiva5 = false;
      this.ct_fasciaAttiva6 = false;
      this.carTxt = "Ct: ";
      switch (this.fasciact1) {
        case 0:
          this.ct_fasciaAttiva0 = true;
          this.carTxt = "";
          break;
        case 1:
          this.ct_fasciaAttiva1 = true;
          this.carTxt = this.carTxt + " ---";
          break;
        case 2:
          this.ct_fasciaAttiva2 = true;
          this.carTxt = this.carTxt + " 0,10-0,30";
          break;
        case 3:
          this.ct_fasciaAttiva3 = true;
          this.carTxt = this.carTxt + " 0,30-0,50";
          break;
        case 4:
          this.ct_fasciaAttiva4 = true;
          this.carTxt = this.carTxt + " 0,60-0,70";
          break;
        case 5:
          this.ct_fasciaAttiva5 = true;
          this.carTxt = this.carTxt + " 0,70-0,90";
          break;
        case 6:
          this.ct_fasciaAttiva6 = true;
          this.carTxt = this.carTxt + " 0,90 -1,00";
          break;
        case 7:
          this.ct_fasciaAttiva7 = true;
          this.carTxt = this.carTxt + " 1,00 - 1,50";
          break;
        case 8:
          this.ct_fasciaAttiva8 = true;
          this.carTxt = this.carTxt + " > 1,50";
          break;
      }
    },
    disattivaCar(oldValue) {
      if (!oldValue) {
        this.carDa = 0.0;
        this.carA = 0.0;
        this.carTxt = "";
      }
    },
    modifcaCar() {
      this.carNO = false;
      if (this.carDa != 0 || this.carA != 0) {
        this.carTxt = "Carati: Da " + this.carDa + " a " + this.carA;
      } else {
        this.carTxt = "";
      }
    },
    toggleCalCulator() {
      return (this.calc = !this.calc);
    },
  },
};
</script>
<style>
.itemNB {
  font-size: 15px;
}
</style>
