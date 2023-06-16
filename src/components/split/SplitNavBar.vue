<template>
    <div class="d-flex row">
        <div class="col-md-6 pr-0">
            <b-navbar class="navmenu navbar-custom" toggleable="lg">
                <b-button v-b-modal.modal-filtro size="sm" class="itemHOME"><span>
                        FILTRI</span></b-button>
                <b-navbar-brand v-if="$route.params.livello > 1" @click="$router.go(-1)"><span
                        class="itemNB">INDIETRO</span></b-navbar-brand>
                <b-navbar-brand v-if="$route.name == 'search'" @click="$router.go(-1)"><span
                        class="itemNB">INDIETRO</span></b-navbar-brand>
                <b-navbar-toggle target="nav-collapse"></b-navbar-toggle>
                <b-collapse id="nav-collapse" is-nav style="padding: 0.5rem">

                    <b-nav-item-dropdown href="#" style="display: flex;">
                        <template #button-content>
                            <span><span class="itemNB"><b-icon icon="gem" font-scale="1.3"></b-icon><span><span><b-icon
                                                icon="caret-down-fill"
                                                font-scale="0.8"></b-icon></span></span></span></span>
                        </template>
                        <b-dropdown-item href="#" to="/diamanti/TUTTO">Diamanti</b-dropdown-item>
                        <b-dropdown-item href="#" to="/pietre/diamanti_brown/TUTTO">Diamanti Brown</b-dropdown-item>
                        <b-dropdown-item href="#" to="/pietre/diamanti_multicolor/TUTTO">Diamanti
                            Multicolor</b-dropdown-item>
                        <b-dropdown-item href="#" to="/pietre/diamanti_neri/TUTTO">Diamanti Neri</b-dropdown-item>

                        <b-dropdown-item href="#" to="/pietre/h20/TUTTO">Acqua Marina</b-dropdown-item>
                        <b-dropdown-item href="#" to="/pietre/perle/TUTTO">Perle</b-dropdown-item>
                        <b-dropdown-item href="#" to="/pietre/quarzo/TUTTO">Quarzo</b-dropdown-item>
                        <b-dropdown-item href="#" to="/pietre/rubini/TUTTO">Rubini</b-dropdown-item>
                        <b-dropdown-item href="#" to="/pietre/smeraldi/TUTTO">Smeraldi</b-dropdown-item>
                        <b-dropdown-item href="#" to="/pietre/topazio/TUTTO">Topazio</b-dropdown-item>
                        <b-dropdown-item href="#" to="/pietre/tanzanite/TUTTO">Tanzanite</b-dropdown-item>

                        <b-dropdown-item href="#" to="/pietre/zaffiri/TUTTO">Zaffiri</b-dropdown-item>
                        <b-dropdown-item href="#" to="/pietre/altre/TUTTO">Altre Pietre</b-dropdown-item>
                    </b-nav-item-dropdown>
                    <b-form class="search" style="width: 10%;">
                        <span style="display: flex;"><span class="itemNB"
                                style="display: flex; align-items: center;"><b-icon icon="search"
                                    font-scale="1.3"></b-icon></span></span>
                        <b-form-input size="sm" class="mr-sm-2 seach_input" v-model="prodotto"></b-form-input>
                    </b-form>
                    <b-img :src="require('../../assets/soloLogo_b.png')" fluid alt="Responsive image" width=30
                        style="margin: auto;"></b-img>

                    <!-- Right aligned nav items -->
                    <b-navbar-nav class="ml-auto">
                        <b-nav-form>
                            <!-- <b-navbar-brand to="/note"><span class="itemNB"><b-icon icon="pencil-square"
                                        font-scale="1.3"></b-icon></span></b-navbar-brand> -->
                            <!-- <b-navbar-brand to="/nuoviarrivi"><span class="itemNB"><b-icon icon="clock"
                                        font-scale="1.3"></b-icon></span></b-navbar-brand> -->

                            <b-icon style="color: whitesmoke; margin-right: 1rem;" icon="calculator" font-scale="1.3"
                                @click="toggleCalCulator()"></b-icon>
                            <Calculator v-if="calc"></Calculator>
                            <b-navbar-brand v-if="goldPrice" style="color:whitesmoke">{{ goldPrice }} €/gr</b-navbar-brand>
                            <b-navbar-brand v-else="goldPrice" style="color: whitesmoke">0 €/gr</b-navbar-brand>
                            <b-navbar-brand to="/agenda" style="color: gray;"><b-icon icon="gear-fill" font-scale="1.3"
                                    style="margin-left:2em;"></b-icon></b-navbar-brand>
                        </b-nav-form>

                    </b-navbar-nav>
                </b-collapse>
            </b-navbar>
            <b-modal id="modal-filtro" size="xl" class="modal-filtro" hide-footer :title="'IMPOSTA FILTRI'" button-size="lg"
                @hide="chiusuraModale">
                <b-form>
                    <div class="row option-section-row">
                        <div class="col-md-2 label-col">
                            <label for="Carati">MAERIALE:</label>
                            <div>
                                <a class="clickable-options btn active label-clickable-options" href="#">
                                    <label v-bind:class="{ active: oroTutto }">
                                        SELEZIONA TUTTO
                                    </label>
                                </a>
                            </div>
                        </div>
                        <div class="col-md-10">
                            <nav class="nav nav-pills nav-justified btn-group-toggle">
                                <a class="nav-item clickable-options btn active nav-link p-0" href="#">
                                    <label v-bind:class="{ active: oroTutto }">
                                        <input type="checkbox" name="options_materiale" id="oroBianco"
                                            @click="selezionaMateriale('oroblanco')">ORO BLANCO
                                    </label>
                                </a>

                                <a class="nav-item clickable-options btn nav-link p-0" href="#">
                                    <label class="" v-bind:class="{ active: oroBianco }">
                                        <input type="checkbox" name="options_materiale" id="oroBianco"
                                            @click="selezionaMateriale('oroBianco')">ORO ROSA
                                    </label>
                                </a>
                                <a class="nav-item clickable-options btn nav-link p-0" href="#">
                                    <label class="" v-bind:class="{ active: oroRosa }">
                                        <input type="checkbox" name="options_materiale" id="oroRosa"
                                            @click="selezionaMateriale('oroRosa')">ORO BIANCO
                                    </label>
                                </a>
                                <a class="nav-item clickable-options btn nav-link p-0" href="#">
                                    <label class="" v-bind:class="{ active: oroRosa }">
                                        <input type="checkbox" name="options_materiale" id="oroRosa"
                                            @click="selezionaMateriale('oroRosa')">ORO GIALLO
                                    </label>
                                </a>
                                <a class="nav-item clickable-options btn nav-link p-0" href="#">
                                    <label class="" v-bind:class="{ active: oroRosa }">
                                        <input type="checkbox" name="options_materiale" id="oroRosa"
                                            @click="selezionaMateriale('oroRosa')">ARGENTO
                                    </label>
                                </a>
                                <a class="nav-item clickable-options btn nav-link p-0" href="#">
                                    <label class="" v-bind:class="{ active: oroRosa }">
                                        <input type="checkbox" name="options_materiale" id="oroRosa"
                                            @click="selezionaMateriale('oroRosa')">TITANIO
                                    </label>
                                </a>
                            </nav>
                        </div>
                    </div>

                    <div class="row option-section-row">
                        <div class="col-md-2 label-col">
                            <label for="Carati">PIETRA:</label>
                            <div>
                                <a class="clickable-options btn label-clickable-options" href="#">
                                    <label v-bind:class="{ active: oroTutto }">
                                        SELEZIONA TUTTO
                                    </label>
                                </a>
                            </div>
                        </div>
                        <div class="col-md-10">
                            <nav class="nav nav-pills nav-justified btn-group-toggle">
                                <a class="nav-item clickable-options btn active nav-link p-0" href="#">
                                    <label class="active" v-bind:class="{ active: oroTutto }">
                                        <input type="checkbox" name="options_materiale" id="oroBianco"
                                            @click="selezionaMateriale('tutto')">DEAMANTO
                                    </label>
                                </a>

                                <a class="nav-item clickable-options btn nav-link p-0" href="#">
                                    <label v-bind:class="{ active: oroBianco }">
                                        <input type="checkbox" name="options_materiale" id="oroBianco"
                                            @click="selezionaMateriale('oroBianco')">RUBINO
                                    </label>
                                </a>
                                <a class="nav-item clickable-options btn nav-link p-0" href="#">
                                    <label v-bind:class="{ active: oroRosa }">
                                        <input type="checkbox" name="options_materiale" id="oroRosa"
                                            @click="selezionaMateriale('oroRosa')">ZAFFIRO
                                    </label>
                                </a>
                                <a class="nav-item clickable-options btn nav-link p-0" href="#">
                                    <label v-bind:class="{ active: oroRosa }">
                                        <input type="checkbox" name="options_materiale" id="oroRosa"
                                            @click="selezionaMateriale('oroRosa')">SMERALDO
                                    </label>
                                </a>
                                <a class="nav-item clickable-options btn nav-link p-0" href="#">
                                    <label v-bind:class="{ active: oroRosa }">
                                        <input type="checkbox" name="options_materiale" id="oroRosa"
                                            @click="selezionaMateriale('oroRosa')">ACQUMAINA
                                    </label>
                                </a>
                            </nav>
                            <nav class="nav nav-pills nav-justified btn-group-toggle mt-1">
                                <a class="nav-item clickable-options btn active nav-link p-0" href="#">
                                    <label class="active" v-bind:class="{ active: oroTutto }">
                                        <input type="checkbox" name="options_materiale" id="oroBianco"
                                            @click="selezionaMateriale('tutto')">TANZANITE
                                    </label>
                                </a>

                                <a class="nav-item clickable-options btn nav-link p-0" href="#">
                                    <label v-bind:class="{ active: oroBianco }">
                                        <input type="checkbox" name="options_materiale" id="oroBianco"
                                            @click="selezionaMateriale('oroBianco')">AMETISTA
                                    </label>
                                </a>
                                <a class="nav-item clickable-options btn nav-link p-0" href="#">
                                    <label v-bind:class="{ active: oroRosa }">
                                        <input type="checkbox" name="options_materiale" id="oroRosa"
                                            @click="selezionaMateriale('oroRosa')">PERIDOTO
                                    </label>
                                </a>
                                <a class="nav-item clickable-options btn nav-link p-0" href="#">
                                    <label v-bind:class="{ active: oroRosa }">
                                        <input type="checkbox" name="options_materiale" id="oroRosa"
                                            @click="selezionaMateriale('oroRosa')">PERLE
                                    </label>
                                </a>
                                <a class="nav-item clickable-options btn nav-link p-0" href="#">
                                    <label v-bind:class="{ active: oroRosa }">
                                        <input type="checkbox" name="options_materiale" id="oroRosa"
                                            @click="selezionaMateriale('oroRosa')">ALTRE PIETRE
                                    </label>
                                </a>
                            </nav>
                        </div>
                    </div>

                    <div class="row option-section-row">
                        <div class="col-md-2 label-col">
                            <label for="Carati">TIPOLOGIA:</label>
                            <div>
                                <a class="clickable-options btn active label-clickable-options" href="#">
                                    <label v-bind:class="{ active: oroTutto }">
                                        SELEZIONA TUTTO
                                    </label>
                                </a>
                            </div>
                        </div>
                        <div class="col-md-10">
                            <nav class="nav nav-pills nav-justified btn-group-toggle">
                                <a class="nav-item clickable-options btn active nav-link p-0" href="#">
                                    <label class="active" v-bind:class="{ active: oroTutto }">
                                        <input type="checkbox" name="options_materiale" id="oroBianco"
                                            @click="selezionaMateriale('tutto')">ANELLI
                                    </label>
                                </a>

                                <a class="nav-item clickable-options btn nav-link p-0" href="#">
                                    <label v-bind:class="{ active: oroBianco }">
                                        <input type="checkbox" name="options_materiale" id="oroBianco"
                                            @click="selezionaMateriale('oroBianco')">BRACCIALETTI
                                    </label>
                                </a>
                                <a class="nav-item clickable-options btn nav-link p-0" href="#">
                                    <label v-bind:class="{ active: oroRosa }">
                                        <input type="checkbox" name="options_materiale" id="oroRosa"
                                            @click="selezionaMateriale('oroRosa')">CIONDOLI
                                    </label>
                                </a>
                                <a class="nav-item clickable-options btn nav-link p-0" href="#">
                                    <label v-bind:class="{ active: oroRosa }">
                                        <input type="checkbox" name="options_materiale" id="oroRosa"
                                            @click="selezionaMateriale('oroRosa')">ORECCCHINI
                                    </label>
                                </a>
                                <a class="nav-item clickable-options btn nav-link p-0" href="#">
                                    <label v-bind:class="{ active: oroRosa }">
                                        <input type="checkbox" name="options_materiale" id="oroRosa"
                                            @click="selezionaMateriale('oroRosa')">ALTRO
                                    </label>
                                </a>
                            </nav>
                        </div>
                    </div>

                    <div class="row option-section-row">
                        <div class="col-md-2 label-col">
                            <label for="Carati">COLLEZIONE:</label>
                            <div>
                                <a class="clickable-options btn active label-clickable-options" href="#">
                                    <label v-bind:class="{ active: oroTutto }">
                                        SELEZIONA TUTTO
                                    </label>
                                </a>
                            </div>
                        </div>
                        <div class="col-md-10">
                            <nav class="nav nav-pills nav-justified btn-group-toggle">
                                <a class="nav-item clickable-options btn active nav-link p-0" href="#">
                                    <label class="active" v-bind:class="{ active: oroTutto }">
                                        <input type="checkbox" name="options_materiale" id="oroBianco"
                                            @click="selezionaMateriale('tutto')">BLACKWOOD
                                    </label>
                                </a>

                                <a class="nav-item clickable-options btn nav-link p-0" href="#">
                                    <label v-bind:class="{ active: oroBianco }">
                                        <input type="checkbox" name="options_materiale" id="oroBianco"
                                            @click="selezionaMateriale('oroBianco')">DREAMBOX
                                    </label>
                                </a>
                                <a class="nav-item clickable-options btn nav-link p-0" href="#">
                                    <label v-bind:class="{ active: oroRosa }">
                                        <input type="checkbox" name="options_materiale" id="oroRosa"
                                            @click="selezionaMateriale('oroRosa')">ESSENTIAL
                                    </label>
                                </a>
                                <a class="nav-item clickable-options btn nav-link p-0" href="#">
                                    <label v-bind:class="{ active: oroRosa }">
                                        <input type="checkbox" name="options_materiale" id="oroRosa"
                                            @click="selezionaMateriale('oroRosa')">FENCY COLOR
                                    </label>
                                </a>
                                <a class="nav-item clickable-options btn nav-link p-0" href="#">
                                    <label v-bind:class="{ active: oroRosa }">
                                        <input type="checkbox" name="options_materiale" id="oroRosa"
                                            @click="selezionaMateriale('oroRosa')">FEHM
                                    </label>
                                </a>
                            </nav>

                            <nav class="nav nav-pills nav-justified btn-group-toggle mt-1">
                                <a class="nav-item clickable-options btn active nav-link p-0" href="#">
                                    <label class="active" v-bind:class="{ active: oroTutto }">
                                        <input type="checkbox" name="options_materiale" id="oroBianco"
                                            @click="selezionaMateriale('tutto')">GUOMO
                                    </label>
                                </a>

                                <a class="nav-item clickable-options btn nav-link p-0" href="#">
                                    <label v-bind:class="{ active: oroBianco }">
                                        <input type="checkbox" name="options_materiale" id="oroBianco"
                                            @click="selezionaMateriale('oroBianco')">HERITAGE
                                    </label>
                                </a>
                                <a class="nav-item clickable-options btn nav-link p-0" href="#">
                                    <label v-bind:class="{ active: oroRosa }">
                                        <input type="checkbox" name="options_materiale" id="oroRosa"
                                            @click="selezionaMateriale('oroRosa')">MASTERPEICES
                                    </label>
                                </a>
                                <a class="nav-item clickable-options btn nav-link p-0" href="#">
                                    <label v-bind:class="{ active: oroRosa }">
                                        <input type="checkbox" name="options_materiale" id="oroRosa"
                                            @click="selezionaMateriale('oroRosa')">PURE BLACK
                                    </label>
                                </a>
                                <a class="nav-item clickable-options btn nav-link p-0" href="#">
                                    <label v-bind:class="{ active: oroRosa }">
                                        <input type="checkbox" name="options_materiale" id="oroRosa"
                                            @click="selezionaMateriale('oroRosa')">RICCI
                                    </label>
                                </a>
                            </nav>

                            <nav class="nav nav-pills nav-justified btn-group-toggle mt-1">
                                <a class="nav-item clickable-options btn active nav-link p-0" href="#">
                                    <label class="active" v-bind:class="{ active: oroTutto }">
                                        <input type="checkbox" name="options_materiale" id="oroBianco"
                                            @click="selezionaMateriale('tutto')">SOUL SPACES
                                    </label>
                                </a>

                                <a class="nav-item clickable-options btn nav-link p-0" href="#">
                                    <label v-bind:class="{ active: oroBianco }">
                                        <input type="checkbox" name="options_materiale" id="oroBianco"
                                            @click="selezionaMateriale('oroBianco')">SIDEREUM
                                    </label>
                                </a>
                                <a class="nav-item clickable-options btn nav-link p-0" href="#">
                                    <label v-bind:class="{ active: oroRosa }">
                                        <input type="checkbox" name="options_materiale" id="oroRosa"
                                            @click="selezionaMateriale('oroRosa')">SPIRALI
                                    </label>
                                </a>
                                <a class="nav-item clickable-options btn nav-link p-0" href="#">
                                    <label v-bind:class="{ active: oroRosa }">
                                        <input type="checkbox" name="options_materiale" id="oroRosa"
                                            @click="selezionaMateriale('oroRosa')">ALTRO
                                    </label>
                                </a>
                            </nav>
                        </div>
                    </div>

                    <div class="row option-section-row">
                        <div class="col-md-2 label-col">
                            <label for="Carati">PIETRA</label>
                        </div>
                        <div class="col-md-10">
                            <nav class="nav nav-pills nav-justified btn-group-toggle">
                                <a class="nav-item clickable-options btn active nav-link p-0" href="#">
                                    <label class="active" v-bind:class="{ active: oroTutto }">
                                        <input type="checkbox" name="options_materiale" id="oroBianco"
                                            @click="selezionaMateriale('tutto')">DEAMANTO
                                    </label>
                                </a>

                                <a class="nav-item clickable-options btn nav-link p-0" href="#">
                                    <label v-bind:class="{ active: oroBianco }">
                                        <input type="checkbox" name="options_materiale" id="oroBianco"
                                            @click="selezionaMateriale('oroBianco')">RUBINO
                                    </label>
                                </a>
                                <a class="nav-item clickable-options btn nav-link p-0" href="#">
                                    <label v-bind:class="{ active: oroRosa }">
                                        <input type="checkbox" name="options_materiale" id="oroRosa"
                                            @click="selezionaMateriale('oroRosa')">ZAFFIRO
                                    </label>
                                </a>
                                <a class="nav-item clickable-options btn nav-link p-0" href="#">
                                    <label v-bind:class="{ active: oroRosa }">
                                        <input type="checkbox" name="options_materiale" id="oroRosa"
                                            @click="selezionaMateriale('oroRosa')">SMERALDO
                                    </label>
                                </a>
                                <a class="nav-item clickable-options btn nav-link p-0" href="#">
                                    <label v-bind:class="{ active: oroRosa }">
                                        <input type="checkbox" name="options_materiale" id="oroRosa"
                                            @click="selezionaMateriale('oroRosa')">ACQUMAINA
                                    </label>
                                </a>
                            </nav>
                        </div>
                    </div>

                    <div class="row option-section-row price-range">
                        <div class="col-md-2 label-col" style="bottom: 4rem;">PREZZO: </div>
                        <div class="col-md-3 label-col price-range-controller" style="margin-left: 1rem">
                            <div class="price-sign">
                                <span><span><b-icon icon="dash-lg"></b-icon></span>
                                </span>
                            </div>
                            <CustomMinMaxSlider />
                        </div>
                    </div>

                    <div class="row mt-4">
                        <div class="col-md-6">
                            <b-button @click="$bvModal.hide('modal-filtro')" class="btn-options-other">Chiudi</b-button>
                            <b-button variant="" @click="resetFiltri()" style="margin-left:1em"
                                class="btn-options-other">Reset</b-button>
                        </div>
                        <div class="col-md-6">
                            <b-button @click="cercaProdotto(prodotto)" style="float:right" variant=""
                                class="btn-options-save">Cerca</b-button>
                        </div>
                    </div>


                </b-form>
            </b-modal>
        </div>
        <div class="col-md-6 pl-0">
            <!-- <NavBarAdmin></NavBarAdmin> -->
            <NavbarAdminForSplit />
        </div>

    </div>
</template>
<script>
import axios from "axios";
// import VueInputCalculator from "vue-input-calculator";
import Calculator from "../../components/Calculator.vue";
import NavBarAdmin from '../../components/NavbarAdmin.vue';
import NavbarAdminForSplit from "../NavbarAdminForSplit.vue";
import CustomMinMaxSlider from "../../components/CustomMinMaxSlider.vue";

export default {
    props: ['idCategoria'],
    components: { Calculator, NavBarAdmin, CustomMinMaxSlider, NavbarAdminForSplit },
    data() {
        return {
            goldPrice: null,
            calc: false,
            prodotto: '',
            prezzoTxt: '',
            carTxt: '',
            altriFiltri: '',
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
            filtroTipoClassici: 'tutto',
            filtroTipoTipo: 'tutto',
            filtroTipoMateriale: 'tutto',

            maxCT: 0,
        }
    },
    mounted() {
        this.$session.set('tipo', 'FE');

        this.getGoldPrice();
        this.getMaxCT();
        if (this.idCategoria != undefined) {
            this.catAttuale = this.idCategoria
        } else {
            if (this.$route.params.catAttuale > 0) {
                this.catAttuale = this.$route.params.catAttuale
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
            this.classiciTutto = false
            this.classici = false
            this.classiciColorati = false
            this.filtroTipoClassici = this.$route.params.filtroTipoClassici;
            switch (this.filtroTipoClassici) {
                case 'C':
                    this.classici = true;
                    break;
                case 'CC':
                    this.classiciColorati = true;
                    break;
                default:
                    this.classiciTutto = true;
            }
        }
        if (this.$route.params.filtroTipoTipo != undefined) {
            this.filtroTipoTipo = this.$route.params.filtroTipoTipo;
            this.Fanelli = false
            this.Fbraccialetti = false
            this.Fciondoli = false
            this.Forecchini = false
            this.FtipoTutto = false
            switch (this.filtroTipoTipo) {
                case 'anelli':
                    this.Fanelli = true;
                    break;
                case 'braccialetti':
                    this.Fbraccialetti = true;
                    break;
                case 'ciondoli':
                    this.Fciondoli = true;
                    break;
                case 'orecchini':
                    this.Forecchini = true;
                    break;
                default:
                    this.FtipoTutto = true;
            }
        }
        if (this.$route.params.filtroTipoMateriale != undefined) {
            this.filtroTipoMateriale = this.$route.params.filtroTipoMateriale;
            this.oroBianco = false
            this.oroRosa = false
            this.oroTutto = false
            switch (this.filtroTipoMateriale) {
                case 'OB':
                    this.oroBianco = true;
                    break;
                case 'OR':
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
            this.carTxt = '',
                this.altriFiltri = '',
                this.fascia = 0
            this.fasciap1 = 0
            this.fasciap2 = 0
            this.fasciaAttiva0 = true
            this.fasciaAttiva1 = false
            this.fasciaAttiva3 = false
            this.fasciaAttiva2 = false
            this.fasciaAttiva4 = false
            this.fasciaAttiva5 = false
            this.fasciaAttiva6 = false
            this.fasciact2 = 0
            this.fasciact1 = 0
            this.ct_fasciaAttiva0 = true
            this.ct_fasciaAttiva1 = false
            this.ct_fasciaAttiva3 = false
            this.ct_fasciaAttiva2 = false
            this.ct_fasciaAttiva4 = false
            this.ct_fasciaAttiva5 = false
            this.ct_fasciaAttiva6 = false
            this.ct_fasciaAttiva7 = false
            this.ct_fasciaAttiva8 = false
            this.classiciTutto = true
            this.classiciColorati = false
            this.classici = false
            this.Fanelli = false
            this.Fbraccialetti = false
            this.Fciondoli = false
            this.Forecchini = false
            this.FtipoTutto = true
            this.oroTutto = true
            this.oroRosa = false
            this.oroBianco = false
        },
        isFiltriAttivi() {

            let nFiltri = 0;

            if (this.classici || this.classiciColorati) nFiltri++;
            //  if(this.anelli || this.braccialetti || this.ciondoli ) nFiltri++;
            if (this.oroRosa || this.oroBianco) nFiltri++;
            if ((this.fasciap1 > 0) || (this.fasciap2 > 0)) nFiltri++;
            if ((this.fasciact1 > 0) || (this.fasciact2 > 0)) nFiltri++;



            if (nFiltri > 0) {
                this.altriFiltri = "(" + nFiltri + ")";
            } else {
                this.altriFiltri = "";
            }

        },
        getGoldPrice() {
            axios
                .get(this.$store.state.settings.URL_SERVER + "API/v1.php?sole24Gold")
                .then(response => {
                    if (response.status === 200 && response.data.stato == "OK") {
                        this.goldPrice = response.data.prezzo;
                    } else {
                        this.goldPrice = null;
                    }
                })
                .catch(err => {
                    console.log(err);
                });
        },
        getMaxCT() {
            axios
                .get(this.$store.state.settings.URL_SERVER + "API/v1.php?maxCT")
                .then(response => {
                    this.maxCT = response.data.maxCT;
                })
                .catch(err => {
                    console.log(err);
                });
        },
        cercaProdotto(p) {

            if (p == '') {
                p = "ALLPRODUCTS";
            }
            //  this.$router.replace({ name: 'search', params: { txt:p,fascia:this.fascia,carDa:this.carDa,carA:this.carA }, force: true});
            /*  this.$router.replace({ name: 'search', params: { txt:p,fasciap1:this.fasciap1,fasciap2:this.fasciap2,fasciact1:this.fasciact1,fasciact2:this.fasciact2,
                classici:this.classici,classiciColorati:this.classiciColorati,
                anelli:this.Fanelli,braccialetti:this.Fbraccialetti,ciondoli:this.Fciondoli,orecchini:this.Forecchini,
                oroRosa:this.oroRosa,oroBianco:this.oroBianco,catAttuale:this.catAttuale }, force: true});*/

            this.$router.replace({
                name: 'search', params: {
                    txt: p, fasciap1: this.fasciap1, fasciap2: this.fasciap2, fasciact1: this.fasciact1, fasciact2: this.fasciact2,
                    filtroTipoClassici: this.filtroTipoClassici, filtroTipoTipo: this.filtroTipoTipo,
                    filtroTipoMateriale: this.filtroTipoMateriale, catAttuale: this.catAttuale
                }, force: true
            });
            //this.$bvModal.hide('modal-filtro')
        },
        filtroClassici(t) {
            this.classici = false;
            this.classiciColorati = false;
            this.classiciTutto = false;
            if (t == 'tutto') {
                this.classiciTutto = true;
                this.filtroTipoClassici = 'tutto';
            }
            if (t == 'classici') {
                this.classici = true;
                this.filtroTipoClassici = 'C';
            }
            if (t == 'classiciColorati') {
                this.classiciColorati = true;
                this.filtroTipoClassici = 'CC';
            }
        },
        selezionaMateriale(t) {
            this.oroBianco = false;
            this.oroRosa = false;
            this.oroTutto = false;
            if (t == 'tutto') {
                this.oroTutto = true;
                this.filtroTipoMateriale = 'tutto'
            }
            if (t == 'oroBianco') {
                this.oroBianco = true;
                this.filtroTipoMateriale = 'OB'
            }
            if (t == 'oroRosa') {
                this.oroRosa = true;
                this.filtroTipoMateriale = 'OR'
            }
        },
        filtroFTipo(t) {
            this.Fanelli = false;
            this.Fbraccialetti = false;
            this.Fciondoli = false;
            this.Forecchini = false;
            this.FtipoTutto = false;

            if (t == 'tutto') {
                this.FtipoTutto = true;
                this.filtroTipoTipo = 'tutto'
            }
            if (t == 'anelli') {
                this.Fanelli = true;
                this.filtroTipoTipo = 'anelli'
            }
            if (t == 'braccialetti') {
                this.Fbraccialetti = true;
                this.filtroTipoTipo = 'braccialetti'
            }
            if (t == 'ciondoli') {
                this.Fciondoli = true;
                this.filtroTipoTipo = 'ciondoli'
            }
            if (t == 'orecchini') {
                this.Forecchini = true;
                this.filtroTipoTipo = 'orecchini'
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
            this.prezzoTxt = 'Prezzo: ';
            switch (this.fasciap1) {
                case 0:
                    this.fasciaAttiva0 = true;
                    this.prezzoTxt = '';
                    break;
                case 1:
                    this.fasciaAttiva1 = true;
                    this.prezzoTxt = this.prezzoTxt + " <500€"
                    break;
                case 2:
                    this.fasciaAttiva2 = true;
                    this.prezzoTxt = this.prezzoTxt + " 500-1000€"
                    break;
                case 3:
                    this.fasciaAttiva3 = true;
                    this.prezzoTxt = this.prezzoTxt + " 1000-2000€"
                    break;
                case 4:
                    this.fasciaAttiva4 = true;
                    this.prezzoTxt = this.prezzoTxt + " 2000-3000€"
                    break;
                case 5:
                    this.fasciaAttiva5 = true;
                    this.prezzoTxt = this.prezzoTxt + " 3000-6000€"
                    break;
                case 6:
                    this.fasciaAttiva6 = true;
                    this.prezzoTxt = this.prezzoTxt + " >6000€"
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
            this.carTxt = 'Ct: ';
            switch (this.fasciact1) {
                case 0:
                    this.ct_fasciaAttiva0 = true;
                    this.carTxt = '';
                    break;
                case 1:
                    this.ct_fasciaAttiva1 = true;
                    this.carTxt = this.carTxt + " ---"
                    break;
                case 2:
                    this.ct_fasciaAttiva2 = true;
                    this.carTxt = this.carTxt + " 0,10-0,30"
                    break;
                case 3:
                    this.ct_fasciaAttiva3 = true;
                    this.carTxt = this.carTxt + " 0,30-0,50"
                    break;
                case 4:
                    this.ct_fasciaAttiva4 = true;
                    this.carTxt = this.carTxt + " 0,60-0,70"
                    break;
                case 5:
                    this.ct_fasciaAttiva5 = true;
                    this.carTxt = this.carTxt + " 0,70-0,90"
                    break;
                case 6:
                    this.ct_fasciaAttiva6 = true;
                    this.carTxt = this.carTxt + " 0,90 -1,00"
                    break;
                case 7:
                    this.ct_fasciaAttiva7 = true;
                    this.carTxt = this.carTxt + " 1,00 - 1,50"
                    break;
                case 8:
                    this.ct_fasciaAttiva8 = true;
                    this.carTxt = this.carTxt + " > 1,50"
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
            if ((this.carDa != 0) || (this.carA != 0)) {
                this.carTxt = "Carati: Da " + this.carDa + " a " + this.carA;
            } else {
                this.carTxt = "";
            }
        },
        toggleCalCulator() {
            return this.calc = !this.calc;
        }
    }
}
</script>
<style>
.itemNB {
    font-size: 15px;
}

.search-input {
    width: 175px !important;
}
</style>