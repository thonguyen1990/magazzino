<template>
  <b-container fluid>
    <loading
      :active.sync="isLoading"
      :can-cancel="true"
      :is-full-page="true"
    ></loading>
    <b-form @submit="onSubmitAggiornaStat">
      <b-row>
        <b-col>
          <b-form-datepicker
            placeholder="Da"
            id="input-dataIniziale"
            today-button
            reset-button
            v-model="filtro.dataIniziale"
            class="mb-2"
          ></b-form-datepicker>
        </b-col>
        <b-col>
          <b-form-datepicker
            placeholder="A"
            id="input-dataFinale"
            today-button
            reset-button
            v-model="filtro.dataFinale"
            class="mb-2"
          ></b-form-datepicker>
        </b-col>
      </b-row>
      <b-row>
        <b-col>
          <multi-select
            :options="optionsCat"
            :selected-options="selectedCat"
            placeholder="SELEZIONA LE CATEGORIE DA FILTRARE"
            @select="onSelect"
          ></multi-select>
        </b-col>
        <b-col>
          <b-button type="submit" variant="primary">AGGIORNA</b-button>
        </b-col>

        <a
          style="float: right"
          v-bind:href="
            $store.state.settings.URL_SERVER +
            'API/esportaXLSX.php?esportaVendite&secret=' +
            $session.get('secret')
          "
          target="_blank"
        >
          <img
            class="azione"
            width="60"
            alt="downloadXLSX"
            src="../assets/xlsx.png"
          />
        </a>
      </b-row>
    </b-form>
    <b-row>
      <b-col>
        <b-card-group
          deck
          v-if="this.$session.get('AUTORIZZAZIONI').totContabilita == 1"
        >
          <b-card :title="datiSintesi.totaleVisite" header-tag="header">
            <template #header>
              <h6 class="mb-0">N.Visite/Vendite</h6>
            </template>
          </b-card>
          <b-card :title="datiSintesi.visiteAcquistoSI" header-tag="header">
            <template #header>
              <h6 class="mb-0">N.Visite con acquisti</h6>
            </template>
          </b-card>

          <b-card :title="datiSintesi.totaleNoggetti" header-tag="header">
            <template #header>
              <h6 class="mb-0">Oggetti Venuti</h6>
            </template>
          </b-card>

          <b-card :title="datiSintesi.totaleValoreVenduto" header-tag="header">
            <template #header>
              <h6 class="mb-0">Valore vendite</h6>
            </template>
          </b-card>
        </b-card-group>
      </b-col>
    </b-row>
    <b-row style="margin-top: 0.3em">
      <b-col>
        <b-tabs content-class="mt-3" active-nav-item-class="active-link">
          <b-tab title="Elenco Visite" active>
            <b-row>
              <b-form-group
                label="Filter"
                label-for="filter-input"
                label-cols-sm="3"
                label-align-sm="right"
                label-size="sm"
                class="mb-0"
              >
                <b-input-group size="sm">
                  <b-form-input
                    id="filter-input"
                    v-model="filter"
                    type="search"
                    placeholder="Scrivi per cercare.."
                  ></b-form-input>

                  <b-input-group-append>
                    <b-button :disabled="!filter" @click="filter = ''"
                      >Clear</b-button
                    >
                  </b-input-group-append>
                </b-input-group>
              </b-form-group>
            </b-row>

            <b-table
              striped
              hover
              :items="soloVisite"
              :fields="elencoVisiteFields"
              :sort-compare="sortCompare"
              :filter="filter"
              :sort-by.sync="sortBy"
              :sort-desc.sync="sortDesc"
              :sortByFormatted="true"
            >
              <template #head(action)>
                <span> Azioni </span>
              </template>
              <template #cell(action)="data">
                <img
                  class="azione"
                  width="20"
                  alt="x"
                  @click.stop="eliminaVV(data.item.id, 'VISITA')"
                  src="../assets/del.png"
                  style="margin-left: 1em"
                />
                <b-icon
                  class="azione"
                  @click.stop="dettagliVendita(data.item)"
                  icon="search"
                  font-scale="1.5"
                  style="margin-left: 1em"
                ></b-icon>
              </template>
              <template #cell(Nominativo)="data">
                <span
                  style="color: blue"
                  @click="infoCliente(data.item.idCliente)"
                  >{{ data.item.nomeCognome }}</span
                >
              </template>

              <template #cell(Data)="data">
                {{ data.item.data | dataITA }}
                <span v-if="data.item.gift == 1">
                  <b-icon
                    icon="gift-fill"
                    variant="success"
                    font-scale="1.5"
                    style="margin-left: 0.5em"
                  ></b-icon
                ></span>
              </template>
            </b-table>
          </b-tab>
          <b-tab title="Elenco Vendite">
            <table-component :data="oggettiVenduti" style="width: 100%">
              <table-column show="dataVendita" label="Data">
                <template slot-scope="row">
                  <img
                    class="azione"
                    width="20"
                    alt="x"
                    @click.stop="eliminaVV(row.id, 'VENDITA')"
                    src="../assets/del.png"
                    style="margin-left: 1em"
                  />
                  <img
                    class="azione"
                    width="20"
                    alt="x"
                    @click.stop="modificaVisita(row.idVisita)"
                    src="../assets/edit.png"
                    style="margin-left: 1em"
                  />
                  {{ row.dataVendita | dataITA }}
                  <span v-if="row.gift == 1">
                    <b-icon
                      icon="gift-fill"
                      variant="success"
                      font-scale="1.5"
                      style="margin-left: 0.5em"
                    ></b-icon
                  ></span>
                </template>
              </table-column>
              <table-column show="nomeCognome" label="Nome">
                <template slot-scope="row">
                  <span style="color: blue" @click="infoCliente(row.idCliente)">
                    {{ row.nomeCognome }}</span
                  >
                </template>
              </table-column>
              <table-column show="itemTitolo" label="Titolo"></table-column>
              <table-column show="itemDesc" label="Desc"></table-column>
              <table-column show="cat" label="Categoria"></table-column>
              <table-column show="sottocat" label="S.Categoria"></table-column>

              <table-column show="fotoThumb" label="Img">
                <template slot-scope="row">
                  <img
                    v-if="row.fotoThumb"
                    v-img
                    :src="row.fotoThumb + '?' + $session.get('secret')"
                    alt="image"
                    img-top
                  />
                </template>
              </table-column>
            </table-component>
          </b-tab>
        </b-tabs>
      </b-col>
    </b-row>

    <b-modal id="modal-dettaglioVendita" hide-footer size="xl">
      <template #modal-title>
        {{ dettaglioSingolo.titolo }}
        <span
          style="color: blue"
          @click="
            infoCliente(dettaglioSingolo.dettaglioVenditeVisita[0].idCliente)
          "
          >[Info Cliente]</span
        >
        <span style=""
          ><b-icon
            v-on:click.stop
            @click="
              modificaVisita(
                dettaglioSingolo.dettaglioVenditeVisita[0].idVisita
              )
            "
            style="float: right"
            icon="pencil-square"
            variant="warning"
            font-scale="1.5"
          ></b-icon
        ></span>
      </template>

      <b-list-group>
        <b-row
          v-for="vendita in dettaglioSingolo.dettaglioVenditeVisita"
          :key="vendita.id"
          class=""
        >
          <b-col cols="10">
            <span
              v-if="vendita.cat != '' || vendita.sottocat != ''"
              class="grassetto1"
              >{{ vendita.cat }} {{ vendita.sottocat }}<br
            /></span>
            {{ vendita.itemTitolo }} {{ vendita.itemDesc }} [{{
              vendita.itemPrezzo
            }}€ - Sc. {{ vendita.sconto | noDecimali }}%] <br />{{
              vendita.note
            }}
            <br />{{ vendita.vetrina }}
          </b-col>
          <b-col>
            <b-img
              v-if="vendita.foto != ''"
              :src="vendita.foto + '?' + $session.get('secret')"
              alt=""
              fluid
              class="img-vendite"
            ></b-img>
          </b-col>
        </b-row>
      </b-list-group>
      <div>Note:{{ dettaglioSingolo.note }}</div>
    </b-modal>

    <DettaglioCliente ref="dettagliCliente"></DettaglioCliente>
    <AddVisita
      v-if="!isLoading"
      @visitaAggiunta="onSubmitNuovaVisita()"
      ref="addVisita"
    ></AddVisita>
  </b-container>
</template>

<script>
import axios from "axios";
import { MultiSelect } from "vue-search-select";
import _ from "lodash";
import DettaglioCliente from "../components/DettaglioCliente.vue";
import AddVisita from "../components/AddVisita.vue";

export default {
  components: {
    MultiSelect,
    DettaglioCliente,
    AddVisita,
  },
  data() {
    return {
      filtro: {
        dataIniziale: null,
        dataFinale: null,
      },
      searchText: "",
      optionsCat: [
        { value: "Classici", text: "Classici" },
        { value: "Classici Colorati", text: "Classici Colorati" },
        { value: "Fantasia", text: "Fantasia" },
        { value: "Gioiello su misura", text: "Gioiello su misura" },
      ],
      selectedCat: [],
      lastSelectItem: {},
      elencoVisite: [],
      elencoVisiteFields: [
        { isActive: true, key: "action", sortable: false },
        { isActive: true, key: "Nominativo", sortable: true },
        { isActive: true, key: "Data", sortable: true },
      ],
      filter: "",
      sortBy: "Data",
      sortDesc: true,
      dettaglioSingolo: { titolo: "", note: "", dettaglioVenditeVisita: [] },
      oggettiVenduti: [],
      datiSintesi: {
        visiteAcquistoSI: null,
        visiteAcquistoNO: null,
        totaleVisite: null,
        totaleNoggetti: null,
        totaleValoreVenduto: null,
      },

      showUploadingSpinner: false,
      showAlertSuccess: false,
      showAlertFail: false,
      isLoading: false,

      clienti: [],
    };
  },

  mounted() {
    this.onSubmitAggiornaStat();
    this.getClienti();
  },

  methods: {
    modificaVisita(idVisita) {
      console.log(idVisita);
      this.$refs.addVisita.modificaVisita(idVisita);
    },
    onSubmitNuovaVisita() {
      this.sendAlert("success");
    },
    infoCliente(id) {
      let dettagliInfoCliente = null;
      this.clienti.map(function (cliente) {
        if (cliente.id == id) {
          dettagliInfoCliente = cliente;
        }
      });

      if (dettagliInfoCliente != null)
        this.$refs.dettagliCliente.dettaglioCliente(dettagliInfoCliente);
    },
    getClienti() {
      this.isLoading = true;
      axios
        .get(
          this.$store.state.settings.URL_SERVER +
            "API/v1.php?clienti&secret=" +
            this.$session.get("secret")
        )
        .then((response) => {
          this.clienti = response.data.clienti;
          console.log(response);
          this.isLoading = false;
        })
        .catch((err) => {
          console.log(err);
        });
    },
    sortCompare(
      aRow,
      bRow,
      key,
      sortDesc,
      formatter,
      compareOptions,
      compareLocale
    ) {
      let realK = "";
      if (key == "Nominativo") realK = "nomeCognome";
      if (key == "Data") realK = "data";
      if (key == "Valore") realK = "valoreVenduto";
      if (key == "Oggetti") realK = "nOggettiVenduti";
      const a = aRow[realK]; // or use Lodash `_.get()`
      const b = bRow[realK];
      console.log(
        a +
          "-" +
          b +
          "-" +
          key +
          "-" +
          formatter +
          "-" +
          compareOptions +
          "-" +
          compareLocale
      );

      if (
        (typeof a === "number" && typeof b === "number") ||
        (a instanceof Date && b instanceof Date)
      ) {
        // If both compared fields are native numbers or both are native dates
        return a < b ? -1 : a > b ? 1 : 0;
      } else {
        // Otherwise stringify the field data and use String.prototype.localeCompare
        console.log(this.toString(a).localeCompare(this.toString(b)));
        return this.toString(a).localeCompare(this.toString(b));
      }
    },

    // Helper function to stringify the values of an Object
    toString(value) {
      if (value === null || typeof value === "undefined") {
        return "";
      } else if (value instanceof Object) {
        return Object.keys(value)
          .sort()
          .map((key) => toString(value[key]))
          .join(" ");
      } else {
        return String(value);
      }
    },

    dettagliVendita(row) {
      this.dettaglioSingolo.titolo =
        row.nomeCognome + " " + this.$options.filters.dataITA(row.data);
      this.dettaglioSingolo.note = row.note;
      this.dettaglioSingolo.dettaglioVenditeVisita = row.vendite;
      this.$bvModal.show("modal-dettaglioVendita");
    },
    eliminaVV(id, tipo) {
      let messaggio = "";
      alert(id);
      if (tipo == "VISITA") {
        messaggio = `Sicuro di voler eliminare la visita e tutte le vendite associate?`;
      }
      if (tipo == "VENDITA") {
        messaggio = `Sicuro di voler eliminare la vendita?`;
      }

      this.$confirm({
        message: messaggio,
        button: {
          no: "No",
          yes: "Si",
        },
        /**
         * Callback Function
         * @param {Boolean} confirm
         */
        callback: (confirm) => {
          if (confirm) {
            this.isLoading = true;

            let tipologia = "";
            if (tipo == "VISITA") {
              tipologia = "eliminaVisita";
            }
            if (tipo == "VENDITA") {
              tipologia = "eliminaVendita";
            }

            axios
              .get(
                this.$store.state.settings.URL_SERVER +
                  "API/v1.php?" +
                  tipologia +
                  "&id=" +
                  id +
                  "&secret=" +
                  this.$session.get("secret")
              )
              .then((response) => {
                if (response.status === 200 && response.data.result == "OK") {
                  this.sendAlert("success");
                  this.onSubmitAggiornaStat();
                } else {
                  this.sendAlert("success");
                }
                this.isLoading = false;
              })
              .catch((err) => {
                console.log(err);
                this.sendAlert("fail");
              });
          }
        },
      });
    },
    onSubmitAggiornaStat() {
      this.isLoading = true;
      event.preventDefault();
      let catString = "";
      this.selectedCat.map(function (value) {
        catString = catString + "___" + value.value;
      });

      this.$set(this.filtro, "azione", "elencoVisite");
      this.$set(this.filtro, "cat", catString);
      this.$set(this.filtro, "secret", this.$session.get("secret"));
      console.log(this.filtro);

      axios
        .post(
          this.$store.state.settings.URL_SERVER + "API/v1.php",
          this.toFormData(this.filtro),
          {
            headers: {
              "Content-Type": "application/json",
            },
          }
        )
        .then((response) => {
          this.elencoVisite = response.data.visite;
          this.datiSintesi.visiteAcquistoSI =
            response.data.visiteAcquistoSI.toString();
          this.datiSintesi.visiteAcquistoNO =
            response.data.visiteAcquistoNO.toString();
          this.datiSintesi.totaleVisite = response.data.totaleVisite.toString();
          this.datiSintesi.totaleNoggetti =
            response.data.totaleNoggetti.toString();
          this.datiSintesi.totaleValoreVenduto =
            response.data.totaleValoreVenduto + " €";
          let lista = [];

          response.data.visite.map(function (value) {
            if (value.isVendita === "1") {
              value.vendite.map(function (vendite) {
                vendite.gift = value.gift;
                lista.push(vendite);
              });
            }
          });
          this.oggettiVenduti = lista;
          this.isLoading = false;
        })
        .catch((err) => {
          console.log(err);
          this.sendAlert("fail");
        });
    },

    onSelect(selectedCat, lastSelectItem) {
      this.selectedCat = selectedCat;
      this.lastSelectItem = lastSelectItem;
    },
    // deselect option
    reset() {
      this.selectedCat = []; // reset
    },
    selectFromParentComponent() {
      this.selectedCat = _.unionWith(
        this.selectedCat,
        [this.optionsCat[0]],
        _.isEqual
      );
    },
    sendAlert(state) {
      if (state == "success") {
        this.showAlertSuccess = true;
        setTimeout(() => (this.showAlertSuccess = false), 4000);
      } else if (state == "fail") {
        this.showAlertFail = true;
        setTimeout(() => (this.showAlertFail = false), 4000);
      }
    },
    toFormData: function (obj) {
      let formData = new FormData();
      for (let key in obj) {
        formData.append(key, obj[key]);
      }
      return formData;
    },
  },
  filters: {
    elementoND: function (value) {
      if (value == "" || value == "null" || value == null) {
        return "N/D";
      }
      return value;
    },
  },
  computed: {
    soloVisite: function () {
      return this.elencoVisite.filter((i) => i.isVendita === "0");
    },
    soloVendite: function () {
      return this.elencoVisite.filter((i) => i.isVendita === "1");
    },
  },
};
</script>
