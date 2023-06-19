<template>
  <div style="">
    <b-navbar class="navmenu navbar-custom" toggleable="lg">
      <b-button v-b-modal.modal-filtro size="sm" class="itemHOME"
        ><span> FILTRI</span></b-button
      >
      <b-navbar-brand v-if="$route.params.livello > 1" @click="$router.go(-1)"
        ><span class="itemNB">INDIETRO</span></b-navbar-brand
      >
      <b-navbar-brand v-if="$route.name == 'search'" @click="$router.go(-1)"
        ><span class="itemNB">INDIETRO</span></b-navbar-brand
      >
      <b-navbar-toggle target="nav-collapse"></b-navbar-toggle>
      <b-collapse id="nav-collapse" is-nav style="padding: 0.5rem; width: 100%">
        <b-nav-item-dropdown href="#" style="display: flex; width: 5rem">
          <template #button-content>
            <span
              ><span class="itemNB"
                ><b-icon icon="gem" font-scale="1.3"></b-icon
                ><span
                  ><span
                    ><b-icon
                      icon="caret-down-fill"
                      font-scale="0.8"
                    ></b-icon></span></span></span
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
        <b-form class="search">
          <span style="display: flex; cursor: pointer" @click="search"
            ><span class="itemNB" style="display: flex; align-items: center"
              ><b-icon icon="search" font-scale="1.3"></b-icon></span
          ></span>
          <b-form-input
            size="sm"
            class="mr-sm-2 ml-2 seach_input"
            v-model="prodotto"
            ref="searchInput"
          ></b-form-input>
        </b-form>
        <router-link to="/">
          <b-img
            :src="require('../assets/soloLogo_b.png')"
            fluid
            alt="Responsive image"
            width="30"
            style="margin: 0.5rem; position: absolute; left: 49%; top: 0.4rem"
          ></b-img>
        </router-link>

        <!-- Right aligned nav items -->
        <b-navbar-nav class="ml-auto">
          <b-nav-form>
            <b-navbar-brand to="/note"
              ><span class="itemNB pencil"
                ><b-icon
                  style="margin-right: 1em"
                  icon="pencil-square"
                  font-scale="1.3"
                ></b-icon></span
            ></b-navbar-brand>
            <b-navbar-brand to="/nuoviarrivi"
              ><span class="itemNB clock"
                ><b-icon
                  icon="clock"
                  style="margin-right: 1em"
                  font-scale="1.3"
                ></b-icon></span
            ></b-navbar-brand>

            <b-icon
              style="color: whitesmoke; margin-right: 1rem"
              icon="calculator"
              font-scale="1.3"
              @click="toggleCalCulator()"
              class="calculator"
            ></b-icon>
            <Calculator v-if="calc"></Calculator>
            <b-navbar-brand
              v-if="goldPrice"
              style="color: whitesmoke"
              class="gold-price"
              >{{ goldPrice }} €/gr</b-navbar-brand
            >
            <b-navbar-brand
              v-else="goldPrice"
              style="color: whitesmoke"
              class="gold-price"
              >0 €/gr</b-navbar-brand
            >
            <b-navbar-brand to="/agenda" style="color: gray"
              ><b-icon
                icon="gear-fill"
                font-scale="1.3"
                style="margin-left: 2em"
              ></b-icon
            ></b-navbar-brand>
          </b-nav-form>
        </b-navbar-nav>
      </b-collapse>
    </b-navbar>

    <b-modal
      id="modal-filtro"
      size="xl"
      class="modal-filtro"
      hide-footer
      :title="'IMPOSTA FILTRI'"
      button-size="lg"
      @hide="chiusuraModale"
    >
      <b-form style="font-family: GFS Didot">
        <div class="row option-section-row">
          <div class="col-md-2 label-col">
            <label for="Carati">MATERIALE:</label>
            <div>
              <a
                class="clickable-options btn label-clickable-options"
                href="#"
                v-bind:class="{ active: Maeriale }"
                @click="maerialeAll"
              >
                <label> SELEZIONA TUTTO </label>
              </a>
            </div>
          </div>
          <div class="col-md-10">
            <nav class="nav nav-pills nav-justified btn-group-toggle">
              <a
                class="nav-item clickable-options btn nav-link p-0"
                href="#"
                v-bind:class="{ active: oroBlanco }"
              >
                <label>
                  <input
                    type="checkbox"
                    name="options_materiale"
                    id="oroBianco"
                    @click="setMaeriale('oroBlanco')"
                  />ORO BIANCO
                </label>
              </a>
              <a
                class="nav-item clickable-options btn nav-link p-0"
                href="#"
                v-bind:class="{ active: oroRosa }"
              >
                <label>
                  <input
                    type="checkbox"
                    name="options_materiale"
                    id="oroBianco"
                    @click="setMaeriale('oroRosa')"
                  />ORO ROSA
                </label>
              </a>
              <a
                class="nav-item clickable-options btn nav-link p-0"
                href="#"
                v-bind:class="{ active: oroGiallo }"
              >
                <label>
                  <input
                    type="checkbox"
                    name="options_materiale"
                    id="oroRosa"
                    @click="setMaeriale('oroGiallo')"
                  />ORO GIALLO
                </label>
              </a>
              <a
                class="nav-item clickable-options btn nav-link p-0"
                href="#"
                v-bind:class="{ active: Argento }"
              >
                <label>
                  <input
                    type="checkbox"
                    name="options_materiale"
                    id="oroRosa"
                    @click="setMaeriale('Argento')"
                  />ARGENTO
                </label>
              </a>
              <a
                class="nav-item clickable-options btn nav-link p-0"
                href="#"
                v-bind:class="{ active: Titanio }"
              >
                <label>
                  <input
                    type="checkbox"
                    name="options_materiale"
                    id="oroRosa"
                    @click="setMaeriale('Titanio')"
                  />TITANIO
                </label>
              </a>
            </nav>
          </div>
        </div>

        <div class="row option-section-row">
          <div class="col-md-2 label-col">
            <label for="Carati">PIETRA:</label>
            <div>
              <a
                class="clickable-options btn label-clickable-options"
                href="#"
                v-bind:class="{ active: Pietra }"
                @click="pietraAll"
              >
                <label> SELEZIONA TUTTO </label>
              </a>
            </div>
          </div>
          <div class="col-md-10">
            <nav class="nav nav-pills nav-justified btn-group-toggle">
              <a
                class="nav-item clickable-options btn nav-link p-0"
                href="#"
                v-bind:class="{ active: Diamante }"
              >
                <label class="active">
                  <input
                    type="checkbox"
                    name="options_materiale"
                    id="oroBianco"
                    @click="setPietra('Diamante')"
                  />DIAMANTE
                </label>
              </a>
              <a
                class="nav-item clickable-options btn nav-link p-0"
                href="#"
                v-bind:class="{ active: Rubino }"
              >
                <label>
                  <input
                    type="checkbox"
                    name="options_materiale"
                    id="oroBianco"
                    @click="setPietra('Rubino')"
                  />RUBINO
                </label>
              </a>
              <a
                class="nav-item clickable-options btn nav-link p-0"
                href="#"
                v-bind:class="{ active: Zaffiro }"
              >
                <label>
                  <input
                    type="checkbox"
                    name="options_materiale"
                    id="oroRosa"
                    @click="setPietra('Zaffiro')"
                  />ZAFFIRO
                </label>
              </a>
              <a
                class="nav-item clickable-options btn nav-link p-0"
                href="#"
                v-bind:class="{ active: Smeraldo }"
              >
                <label>
                  <input
                    type="checkbox"
                    name="options_materiale"
                    id="oroRosa"
                    @click="setPietra('Smeraldo')"
                  />SMERALDO
                </label>
              </a>
              <a
                class="nav-item clickable-options btn nav-link p-0"
                href="#"
                v-bind:class="{ active: Acquamarina }"
              >
                <label>
                  <input
                    type="checkbox"
                    name="options_materiale"
                    id="oroRosa"
                    @click="setPietra('Acquamarina')"
                  />ACQUAMARINA
                </label>
              </a>
            </nav>
            <nav class="nav nav-pills nav-justified btn-group-toggle mt-1">
              <a
                class="nav-item clickable-options btn nav-link p-0"
                href="#"
                v-bind:class="{ active: Tanzanite }"
              >
                <label>
                  <input
                    type="checkbox"
                    name="options_materiale"
                    id="oroBianco"
                    @click="setPietra('Tanzanite')"
                  />TANZANITE
                </label>
              </a>
              <a
                class="nav-item clickable-options btn nav-link p-0"
                href="#"
                v-bind:class="{ active: Ametista }"
              >
                <label>
                  <input
                    type="checkbox"
                    name="options_materiale"
                    id="oroBianco"
                    @click="setPietra('Ametista')"
                  />AMETISTA
                </label>
              </a>
              <a
                class="nav-item clickable-options btn nav-link p-0"
                href="#"
                v-bind:class="{ active: Peridoto }"
              >
                <label>
                  <input
                    type="checkbox"
                    name="options_materiale"
                    id="oroRosa"
                    @click="setPietra('Peridoto')"
                  />PERIDOTO
                </label>
              </a>
              <a
                class="nav-item clickable-options btn nav-link p-0"
                href="#"
                v-bind:class="{ active: Perle }"
              >
                <label>
                  <input
                    type="checkbox"
                    name="options_materiale"
                    id="oroRosa"
                    @click="setPietra('Perle')"
                  />PERLE
                </label>
              </a>
              <a
                class="nav-item clickable-options btn nav-link p-0"
                href="#"
                v-bind:class="{ active: Altre }"
              >
                <label>
                  <input
                    type="checkbox"
                    name="options_materiale"
                    id="oroRosa"
                    @click="setPietra('Altre')"
                  />ALTRE PIETRE
                </label>
              </a>
            </nav>
          </div>
        </div>

        <div class="row option-section-row">
          <div class="col-md-2 label-col">
            <label for="Carati">TIPOLOGIA:</label>
            <div>
              <a
                class="clickable-options btn label-clickable-options"
                href="#"
                v-bind:class="{ active: Tipologia }"
                @click="tipologiaAll"
              >
                <label> SELEZIONA TUTTO </label>
              </a>
            </div>
          </div>
          <div class="col-md-10">
            <nav class="nav nav-pills nav-justified btn-group-toggle">
              <a
                class="nav-item clickable-options btn nav-link p-0"
                href="#"
                v-bind:class="{ active: Anelli }"
              >
                <label class="active">
                  <input
                    type="checkbox"
                    name="options_materiale"
                    id="oroBianco"
                    @click="setTipologia('Anelli')"
                  />ANELLI
                </label>
              </a>

              <a
                class="nav-item clickable-options btn nav-link p-0"
                href="#"
                v-bind:class="{ active: Braccialetti }"
              >
                <label>
                  <input
                    type="checkbox"
                    name="options_materiale"
                    id="oroBianco"
                    @click="setTipologia('Braccialetti')"
                  />BRACCIALETTI
                </label>
              </a>
              <a
                class="nav-item clickable-options btn nav-link p-0"
                href="#"
                v-bind:class="{ active: Ciondoli }"
              >
                <label>
                  <input
                    type="checkbox"
                    name="options_materiale"
                    id="oroRosa"
                    @click="setTipologia('Ciondoli')"
                  />CIONDOLI
                </label>
              </a>
              <a
                class="nav-item clickable-options btn nav-link p-0"
                href="#"
                v-bind:class="{ active: Oreccchini }"
              >
                <label>
                  <input
                    type="checkbox"
                    name="options_materiale"
                    id="oroRosa"
                    @click="setTipologia('Oreccchini')"
                  />ORECCCHINI
                </label>
              </a>
              <a
                class="nav-item clickable-options btn nav-link p-0"
                href="#"
                v-bind:class="{ active: Altro }"
              >
                <label>
                  <input
                    type="checkbox"
                    name="options_materiale"
                    id="oroRosa"
                    @click="setTipologia('Altro')"
                  />ALTRO
                </label>
              </a>
            </nav>
          </div>
        </div>

        <div class="row option-section-row">
          <div class="col-md-2 label-col">
            <label for="Carati">COLLEZIONE:</label>
            <div>
              <a
                class="clickable-options btn label-clickable-options"
                href="#"
                v-bind:class="{ active: Collezione }"
                @click="collezioneAll"
              >
                <label> SELEZIONA TUTTO </label>
              </a>
            </div>
          </div>
          <div class="col-md-10">
            <nav class="nav nav-pills nav-justified btn-group-toggle">
              <a
                class="nav-item clickable-options btn nav-link p-0"
                href="#"
                v-bind:class="{ active: Blackwood }"
              >
                <label>
                  <input
                    type="checkbox"
                    name="options_materiale"
                    id="oroBianco"
                    @click="setCollezione('Blackwood')"
                  />BLACKWOOD
                </label>
              </a>

              <a
                class="nav-item clickable-options btn nav-link p-0"
                href="#"
                v-bind:class="{ active: Dreambox }"
              >
                <label>
                  <input
                    type="checkbox"
                    name="options_materiale"
                    id="oroBianco"
                    @click="setCollezione('Dreambox')"
                  />DREAMBOX
                </label>
              </a>
              <a
                class="nav-item clickable-options btn nav-link p-0"
                href="#"
                v-bind:class="{ active: Essentials }"
              >
                <label>
                  <input
                    type="checkbox"
                    name="options_materiale"
                    id="oroRosa"
                    @click="setCollezione('Essentials')"
                  />ESSENTIALS
                </label>
              </a>
              <a
                class="nav-item clickable-options btn nav-link p-0"
                href="#"
                v-bind:class="{ active: Fancy }"
              >
                <label>
                  <input
                    type="checkbox"
                    name="options_materiale"
                    id="oroRosa"
                    @click="setCollezione('Fancy')"
                  />FANCY COLOR
                </label>
              </a>
              <a
                class="nav-item clickable-options btn nav-link p-0"
                href="#"
                v-bind:class="{ active: Fehm }"
              >
                <label>
                  <input
                    type="checkbox"
                    name="options_materiale"
                    id="oroRosa"
                    @click="setCollezione('Fehm')"
                  />FEHM
                </label>
              </a>
            </nav>

            <nav class="nav nav-pills nav-justified btn-group-toggle mt-1">
              <a
                class="nav-item clickable-options btn nav-link p-0"
                href="#"
                v-bind:class="{ active: Uomo }"
              >
                <label>
                  <input
                    type="checkbox"
                    name="options_materiale"
                    id="oroBianco"
                    @click="setCollezione('Uomo')"
                  />UOMO
                </label>
              </a>
              <a
                class="nav-item clickable-options btn nav-link p-0"
                href="#"
                v-bind:class="{ active: Heritage }"
              >
                <label>
                  <input
                    type="checkbox"
                    name="options_materiale"
                    id="oroBianco"
                    @click="setCollezione('Heritage')"
                  />HERITAGE
                </label>
              </a>
              <a
                class="nav-item clickable-options btn nav-link p-0"
                href="#"
                v-bind:class="{ active: Masterpeices }"
              >
                <label>
                  <input
                    type="checkbox"
                    name="options_materiale"
                    id="oroRosa"
                    @click="setCollezione('Masterpeices')"
                  />MASTERPEICES
                </label>
              </a>
              <a
                class="nav-item clickable-options btn nav-link p-0"
                href="#"
                v-bind:class="{ active: PureBlack }"
              >
                <label>
                  <input
                    type="checkbox"
                    name="options_materiale"
                    id="oroRosa"
                    @click="setCollezione('PureBlack')"
                  />PURE BLACK
                </label>
              </a>
              <a
                class="nav-item clickable-options btn nav-link p-0"
                href="#"
                v-bind:class="{ active: Ricci }"
              >
                <label>
                  <input
                    type="checkbox"
                    name="options_materiale"
                    id="oroRosa"
                    @click="setCollezione('Ricci')"
                  />RICCI
                </label>
              </a>
            </nav>

            <nav class="nav nav-pills nav-justified btn-group-toggle mt-1">
              <a
                class="nav-item clickable-options btn nav-link p-0"
                href="#"
                v-bind:class="{ active: SoulSpaces }"
              >
                <label>
                  <input
                    type="checkbox"
                    name="options_materiale"
                    id="oroBianco"
                    @click="setCollezione('SoulSpaces')"
                  />SOUL SPACES
                </label>
              </a>
              <a
                class="nav-item clickable-options btn nav-link p-0"
                href="#"
                v-bind:class="{ active: Sidereum }"
              >
                <label>
                  <input
                    type="checkbox"
                    name="options_materiale"
                    id="oroBianco"
                    @click="setCollezione('Sidereum')"
                  />SIDEREUM
                </label>
              </a>
              <a
                class="nav-item clickable-options btn nav-link p-0"
                href="#"
                v-bind:class="{ active: Spirali }"
              >
                <label>
                  <input
                    type="checkbox"
                    name="options_materiale"
                    id="oroRosa"
                    @click="setCollezione('Spirali')"
                  />SPIRALI
                </label>
              </a>
              <a
                class="nav-item clickable-options btn nav-link p-0"
                href="#"
                v-bind:class="{ active: AltroCollezione }"
              >
                <label>
                  <input
                    type="checkbox"
                    name="options_materiale"
                    id="oroRosa"
                    @click="setCollezione('AltroCollezione')"
                  />ALTRO
                </label>
              </a>
              <a
                class="nav-item p-0"
                href="#"
                style="
                  border: none !important;
                  border-left: 1px #f2a93b solid;
                  cursor: auto;
                "
              >
              </a>
            </nav>
          </div>
        </div>

        <div class="row option-section-row price-range">
          <div class="col-md-2 label-col" style="bottom: 4rem">PREZZO:</div>
          <div
            class="col-md-3 label-col price-range-controller"
            style="margin-left: 1rem"
          >
            <div class="price-sign">
              <span
                ><span><b-icon icon="dash-lg"></b-icon></span>
              </span>
            </div>
            <CustomMinMaxSlider ref="UpdateMaxMinvalue" />
          </div>
        </div>
        <div class="row mt-4">
          <div class="col-md-6">
            <b-button
              @click="$bvModal.hide('modal-filtro')"
              class="btn-options-other"
              >Chiudi</b-button
            >
            <b-button
              variant=""
              @click="resetFiltri()"
              style="margin-left: 1em"
              class="btn-options-other"
              >Reset</b-button
            >
          </div>
          <div class="col-md-6">
            <b-button
              @click="cercaProdotto(prodotto)"
              style="float: right"
              variant=""
              class="btn-options-save"
              >Cerca</b-button
            >
          </div>
        </div>
      </b-form>
    </b-modal>
  </div>
</template>
<script>
import axios from "axios";
import Calculator from "../components/Calculator.vue";
import CustomMinMaxSlider from "../components/CustomMinMaxSlider.vue";

export default {
  props: ["idCategoria"],
  components: { Calculator, CustomMinMaxSlider },
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
      oroBianco: false,
      catAttuale: 0,
      filtroTipoClassici: "tutto",
      filtroTipoTipo: "tutto",
      filtroTipoMateriale: "tutto",

      maxCT: 0,

      Maeriale: false,
      oroBlanco: false,
      oroRosa: false,
      oroGiallo: false,
      Argento: false,
      Titanio: false,

      Pietra: false,
      Diamante: false,
      Rubino: false,
      Zaffiro: false,
      Smeraldo: false,
      Acquamarina: false,
      Tanzanite: false,
      Ametista: false,
      Peridoto: false,
      Perle: false,
      Altre: false,

      Tipologia: false,
      Anelli: false,
      Braccialetti: false,
      Ciondoli: false,
      Oreccchini: false,
      Altro: false,

      Collezione: false,
      Blackwood: false,
      Dreambox: false,
      Essentials: false,
      Fancy: false,
      Fehm: false,
      Uomo: false,
      Heritage: false,
      Masterpeices: false,
      PureBlack: false,
      Ricci: false,
      SoulSpaces: false,
      Sidereum: false,
      Spirali: false,
      AltroCollezione: false,
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
    maerialeAll() {
      this.Maeriale = !this.Maeriale;
      if (this.Maeriale) {
        this.oroBlanco = true;
        this.oroRosa = true;
        this.oroGiallo = true;
        this.Argento = true;
        this.Titanio = true;
      } else {
        this.oroBlanco = false;
        this.oroRosa = false;
        this.oroGiallo = false;
        this.Argento = false;
        this.Titanio = false;
      }
    },
    setMaeriale(act) {
      if (act === "oroBlanco") {
        this.oroBlanco = !this.oroBlanco;
      } else if (act === "oroRosa") {
        this.oroRosa = !this.oroRosa;
      } else if (act === "oroGiallo") {
        this.oroGiallo = !this.oroGiallo;
      } else if (act === "Argento") {
        this.Argento = !this.Argento;
      } else if (act === "Titanio") {
        this.Titanio = !this.Titanio;
      }

      if (
        this.oroBlanco &&
        this.oroRosa &&
        this.oroGiallo &&
        this.Argento &&
        this.Titanio
      ) {
        this.Maeriale = true;
      } else {
        this.Maeriale = false;
      }
    },
    pietraAll() {
      this.Pietra = !this.Pietra;
      if (this.Pietra) {
        this.Diamante = true;
        this.Rubino = true;
        this.Zaffiro = true;
        this.Smeraldo = true;
        this.Acquamarina = true;
        this.Tanzanite = true;
        this.Ametista = true;
        this.Peridoto = true;
        this.Perle = true;
        this.Altre = true;
      } else {
        this.Diamante = false;
        this.Rubino = false;
        this.Zaffiro = false;
        this.Smeraldo = false;
        this.Acquamarina = false;
        this.Tanzanite = false;
        this.Ametista = false;
        this.Peridoto = false;
        this.Perle = false;
        this.Altre = false;
      }
    },
    setPietra(act) {
      if (act === "Diamante") {
        this.Diamante = !this.Diamante;
      } else if (act === "Rubino") {
        this.Rubino = !this.Rubino;
      } else if (act === "Zaffiro") {
        this.Zaffiro = !this.Zaffiro;
      } else if (act === "Smeraldo") {
        this.Smeraldo = !this.Smeraldo;
      } else if (act === "Acquamarina") {
        this.Acquamarina = !this.Acquamarina;
      } else if (act === "Tanzanite") {
        this.Tanzanite = !this.Tanzanite;
      } else if (act === "Ametista") {
        this.Ametista = !this.Ametista;
      } else if (act === "Peridoto") {
        this.Peridoto = !this.Peridoto;
      } else if (act === "Perle") {
        this.Perle = !this.Perle;
      } else if (act === "Altre") {
        this.Altre = !this.Altre;
      }
      if (
        this.Diamante &&
        this.Rubino &&
        this.Zaffiro &&
        this.Smeraldo &&
        this.Acquamarina &&
        this.Tanzanite &&
        this.Ametista &&
        this.Peridoto &&
        this.Perle &&
        this.Altre
      ) {
        this.Pietra = true;
      } else {
        this.Pietra = false;
      }
    },
    tipologiaAll() {
      this.Tipologia = !this.Tipologia;
      if (this.Tipologia) {
        this.Anelli = true;
        this.Braccialetti = true;
        this.Ciondoli = true;
        this.Oreccchini = true;
        this.Altro = true;
      } else {
        this.Anelli = false;
        this.Braccialetti = false;
        this.Ciondoli = false;
        this.Oreccchini = false;
        this.Altro = false;
      }
    },
    setTipologia(act) {
      if (act === "Anelli") {
        this.Anelli = !this.Anelli;
      } else if (act === "Braccialetti") {
        this.Braccialetti = !this.Braccialetti;
      } else if (act === "Ciondoli") {
        this.Ciondoli = !this.Ciondoli;
      } else if (act === "Oreccchini") {
        this.Oreccchini = !this.Oreccchini;
      } else if (act === "Altro") {
        this.Altro = !this.Altro;
      }
      if (
        this.Anelli &&
        this.Braccialetti &&
        this.Ciondoli &&
        this.Oreccchini &&
        this.Altro
      ) {
        this.Tipologia = true;
      } else {
        this.Tipologia = false;
      }
    },
    collezioneAll() {
      this.Collezione = !this.Collezione;
      if (this.Collezione) {
        this.Blackwood = true;
        this.Dreambox = true;
        this.Essentials = true;
        this.Fancy = true;
        this.Fehm = true;
        this.Uomo = true;
        this.Heritage = true;
        this.Masterpeices = true;
        this.PureBlack = true;
        this.Ricci = true;
        this.SoulSpaces = true;
        this.Sidereum = true;
        this.Spirali = true;
        this.AltroCollezione = true;
      } else {
        this.Blackwood = false;
        this.Dreambox = false;
        this.Essentials = false;
        this.Fancy = false;
        this.Fehm = false;
        this.Uomo = false;
        this.Heritage = false;
        this.Masterpeices = false;
        this.PureBlack = false;
        this.Ricci = false;
        this.SoulSpaces = false;
        this.Sidereum = false;
        this.Spirali = false;
        this.AltroCollezione = false;
      }
    },
    setCollezione(act) {
      if (act === "Blackwood") {
        this.Blackwood = !this.Blackwood;
      } else if (act === "Dreambox") {
        this.Dreambox = !this.Dreambox;
      } else if (act === "Essentials") {
        this.Essentials = !this.Essentials;
      } else if (act === "Fancy") {
        this.Fancy = !this.Fancy;
      } else if (act === "Fehm") {
        this.Fehm = !this.Fehm;
      } else if (act === "Uomo") {
        this.Uomo = !this.Uomo;
      } else if (act === "Heritage") {
        this.Heritage = !this.Heritage;
      } else if (act === "Masterpeices") {
        this.Masterpeices = !this.Masterpeices;
      } else if (act === "PureBlack") {
        this.PureBlack = !this.PureBlack;
      } else if (act === "Ricci") {
        this.Ricci = !this.Ricci;
      } else if (act === "SoulSpaces") {
        this.SoulSpaces = !this.SoulSpaces;
      } else if (act === "Sidereum") {
        this.Sidereum = !this.Sidereum;
      } else if (act === "Spirali") {
        this.Spirali = !this.Spirali;
      } else if (act === "AltroCollezione") {
        this.AltroCollezione = !this.AltroCollezione;
      }
      if (
        this.Blackwood &&
        this.Dreambox &&
        this.Essentials &&
        this.Fancy &&
        this.Fehm &&
        this.Uomo &&
        this.Heritage &&
        this.Masterpeices &&
        this.PureBlack &&
        this.Ricci &&
        this.SoulSpaces &&
        this.Sidereum &&
        this.Spirali &&
        this.AltroCollezione
      ) {
        this.Collezione = true;
      } else {
        this.Collezione = false;
      }
    },
    search() {
      this.$refs.searchInput.focus();
    },
    chiusuraModale() {
      this.isFiltriAttivi();
    },
    resetFiltri() {
      this.$refs.UpdateMaxMinvalue.resetMaxMinValue();
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
      // this.oroRosa = false;
      this.oroBianco = false;

      this.Maeriale = false;
      this.oroBlanco = false;
      this.oroRosa = false;
      this.oroGiallo = false;
      this.Argento = false;
      this.Titanio = false;

      this.Pietra = false;
      this.Diamante = false;
      this.Rubino = false;
      this.Zaffiro = false;
      this.Smeraldo = false;
      this.Acquamarina = false;
      this.Tanzanite = false;
      this.Ametista = false;
      this.Peridoto = false;
      this.Perle = false;
      this.Altre = false;

      this.Tipologia = false;
      this.Anelli = false;
      this.Braccialetti = false;
      this.Ciondoli = false;
      this.Oreccchini = false;
      this.Altro = false;

      this.Collezione = false;
      this.Blackwood = false;
      this.Dreambox = false;
      this.Essentials = false;
      this.Fancy = false;
      this.Fehm = false;
      this.Uomo = false;
      this.Heritage = false;
      this.Masterpeices = false;
      this.PureBlack = false;
      this.Ricci = false;
      this.SoulSpaces = false;
      this.Sidereum = false;
      this.Spirali = false;
      this.AltroCollezione = false;
    },
    isFiltriAttivi() {
      let nFiltri = 0;

      if (this.classici || this.classiciColorati) nFiltri++;
      //  if(this.anelli || this.braccialetti || this.ciondoli ) nFiltri++;
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
      //  this.$router.replace({ name: 'search', params: { txt:p,fascia:this.fascia,carDa:this.carDa,carA:this.carA }, force: true});
      /*  this.$router.replace({ name: 'search', params: { txt:p,fasciap1:this.fasciap1,fasciap2:this.fasciap2,fasciact1:this.fasciact1,fasciact2:this.fasciact2,
          classici:this.classici,classiciColorati:this.classiciColorati,
          anelli:this.Fanelli,braccialetti:this.Fbraccialetti,ciondoli:this.Fciondoli,orecchini:this.Forecchini,
          oroRosa:this.oroRosa,oroBianco:this.oroBianco,catAttuale:this.catAttuale }, force: true});*/

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
      //this.$bvModal.hide('modal-filtro')
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
.option-section-row {
  padding: 5px;
  margin-bottom: 6px;
}

.option-section-row .label-col label {
  margin-bottom: 0 !important;
}

.label-col label {
  font-size: 1.3rem;
}

.label-col div label {
  font-size: 0.6rem;
}

.clickable-options {
  color: #111 !important;
  text-align: center !important;
  border-width: 1px 0px 1px 1px !important;
  border-radius: 0 !important;
  border-color: #f2a93b !important;
  border-style: solid !important;
  margin-bottom: 0 !important;
  cursor: pointer !important;
}

.clickable-options label {
  margin-bottom: 0;
  cursor: pointer !important;
}

.label-clickable-options {
  padding: 0 2px !important;
  border-radius: 2px !important;
  font-size: 12px !important;
}

.clickable-options.active,
.clickable-options:hover,
.clickable-options:active,
.btn-options-save {
  color: #fff !important;
  background-color: #f2a93b !important;
  border-color: #f2a93b !important;
}

.btn-options-other {
  border: 1px solid #f2a93b !important;
  border-radius: 2px !important;
  background-color: #fff !important;
  color: #212529 !important;
}

.clickable-options:focus {
  box-shadow: none !important;
}

.clickable-options:first-child {
  border-bottom-left-radius: 4px !important;
  border-top-left-radius: 4px !important;
}

.clickable-options:last-child {
  border-left: 1px solid #f2a93b !important;
  border-right: 1px solid #f2a93b !important;
  border-top-right-radius: 4px !important;
  border-bottom-right-radius: 4px !important;
}

.dropdown-toggle::after {
  border-top: 0 !important;
}

.navbar .show.dropdown-menu {
  display: block !important;
}

@media (max-width: 750px) {
  .ml-auto .gold-price,
  .ml-auto .calculator {
    display: none !important;
  }
}

@media (max-width: 600px) {
  .ml-auto .pencil,
  .ml-auto .clock {
    display: none !important;
  }
}
</style>
