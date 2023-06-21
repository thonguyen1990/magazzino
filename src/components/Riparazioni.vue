<template>
  <b-container fluid>
    <loading
      :active.sync="isLoading"
      :can-cancel="true"
      :is-full-page="true"
    ></loading>
    <b-col>
      <b-row>
        <b-col
          ><b-form-radio-group
            style="margin-top: 0.1em"
            id="filtro-tipoLavorazione"
            v-model="filtroTipoLavorazione"
            :options="[
              { text: 'Tutto', value: 'TUTTO' },
              { text: 'Ordine', value: 'ORDINE' },
              { text: 'Riparazione', value: 'RIPARAZIONE' },
              { text: 'Valutazione', value: 'VALUTAZIONE' },
            ]"
            button-variant="outline-primary"
            name="filtro-tipoLavorazione"
            buttons
          ></b-form-radio-group>
        </b-col>
        <b-col
          ><b-form-radio-group
            style="margin-top: 0.1em"
            id="filtro-statoLavorazione"
            v-model="filtroStatoLavorazione"
            :options="[
              { text: 'Tutto', value: 'TUTTO' },
              { text: 'In lavorazione', value: 'LAVORAZIONE' },
              { text: 'Consegnato', value: 'CONSEGNATO' },
            ]"
            button-variant="outline-primary"
            name="filtro-statoLavorazione"
            buttons
          ></b-form-radio-group>
        </b-col>
        <b-col>
          <div class="mx-auto mb-3 mt-1">
            <b-button
              v-b-modal.modal-nuovaRiparazione
              style="float: right; margin-left: 2em; margin-bottom: 1em"
              variant="success"
              @click="clearformNuovaLavorazione()"
              ><b-icon icon="plus"></b-icon>NUOVA LAVORAZIONE</b-button
            >
          </div>
        </b-col>
      </b-row>
      <b-alert v-if="showAlertSuccess" variant="success" show
        >Completato!</b-alert
      >
      <b-alert v-if="showAlertFail" variant="warning" show>Errore!</b-alert>

      <table-component
        :data="filtroTipoLavorazioneArray"
        responsive
        @rowClick="dettaglioRiparazione"
        filter-input-class="classeFiltro"
      >
        <table-column header-class="w-5" label="">
          <template slot-scope="row">
            <img
              class="azione"
              width="20"
              alt="EditN"
              @click.stop="modificaRiparazione(row)"
              src="../assets/edit.png"
            />

            <img
              class="azione"
              width="20"
              alt="x"
              @click.stop="eliminaRiparazione(row.id)"
              src="../assets/del.png"
              style="margin-left: 1em"
            />
          </template>
        </table-column>
        <table-column show="tipo" label="Tipo"></table-column>
        <table-column show="dataRicezione" label="Ricevuto il">
          <template slot-scope="row">
            {{ row.dataRicezione | dataITA }}
          </template>
        </table-column>
        <table-column
          show="cognomeNome"
          label="Cliente"
          v-if="this.$session.get('AUTORIZZAZIONI').numeri_telefono >= 1"
        >
          <template slot-scope="row">
            {{ row.cognomeNome }}

            <a v-bind:href="row.wappLink" target="_blank"
              ><img width="20" alt="Wapp" src="../assets/wapp.png"
            /></a>
          </template>
        </table-column>
        <table-column show="cognomeNome" label="Cliente" v-else>
          <template slot-scope="row">
            {{ row.cognomeNome }}
          </template>
        </table-column>
        <table-column show="oggetto" label="Art.Richiesto"></table-column>
        <table-column show="descrizione" label="Descrizione"></table-column>
        <table-column show="dataConsegnaPrevista" label="Consegna prevista">
          <template slot-scope="row">
            {{ row.dataConsegnaPrevista | dataITA }}
          </template>
        </table-column>
        <table-column show="dataConsegnaEffettiva" label="Consegnato il">
          <template slot-scope="row">
            {{ row.dataConsegnaEffettiva | dataITA }}
          </template>
        </table-column>
        <table-column show="stato" label="Stato">
          <template slot-scope="row">
            {{ row.stato }}
          </template>
        </table-column>
      </table-component>
    </b-col>

    <b-modal
      id="modal-nuovaRiparazione"
      hide-footer
      :title="titoloRiparazione"
      size="xl"
    >
      <b-form @submit="onSubmitNuovaRiparazione">
        <b-tabs content-class="mt-3" active-nav-item-class="active-link">
          <b-tab title="Info Lavorazione" active>
            <b-row
              ><b-col>
                <b-form-radio-group
                  style="float: right"
                  id="input-tipoLavorazione"
                  v-model="formNuovaLavorazione.tipoLavorazione"
                  :options="[
                    { text: 'Ordine', value: 'ORDINE' },
                    { text: 'Riparazione', value: 'RIPARAZIONE' },
                    { text: 'Valutazione', value: 'VALUTAZIONE' },
                  ]"
                  button-variant="outline-primary"
                  name="input-tipoLavorazione"
                  buttons
                ></b-form-radio-group>
              </b-col>
            </b-row>

            <b-row>
              <b-col>
                <b-form-group
                  label="Articolo Richiesto:"
                  label-for="input-oggetto"
                >
                  <b-form-input
                    id="input-oggetto"
                    v-model="formNuovaLavorazione.oggetto"
                    type="text"
                  ></b-form-input>
                </b-form-group>
              </b-col>
              <b-col>
                <b-form-group
                  label="Descrizione:"
                  label-for="input-descrizione"
                >
                  <b-form-input
                    id="input-descrizione"
                    v-model="formNuovaLavorazione.descrizione"
                    type="text"
                  ></b-form-input>
                </b-form-group>
              </b-col>
            </b-row>

            <b-row>
              <b-col>
                <b-form-group label="Cliente:" label-for="input-cliente">
                  <b-row>
                    <b-col>
                      <model-select
                        id="input-cliente"
                        class="form-control"
                        :options="optionsClienti"
                        v-model="formNuovaLavorazione.idCliente"
                        placeholder="Seleziona il cliente"
                      ></model-select>
                    </b-col>
                    <b-col cols="1" style="padding-left: 0">
                      <b-icon
                        icon="plus-circle-fill"
                        variant="success"
                        font-scale="2"
                        shift-h="-5"
                        @click="addCliente()"
                      ></b-icon>
                    </b-col>
                  </b-row>
                </b-form-group>
              </b-col>
              <b-col cols="4"> </b-col>
            </b-row>

            <b-row>
              <b-col>
                <b-form-group label="Preventivo:" label-for="input-preventivo">
                  <b-form-input
                    @focus.native="$event.target.select()"
                    id="input-preventivo"
                    v-model="formNuovaLavorazione.preventivo"
                    type="number"
                    step=".01"
                  ></b-form-input>
                </b-form-group>
              </b-col>
              <b-col>
                <b-form-group label="Acconto:" label-for="input-acconto">
                  <b-form-input
                    @focus.native="$event.target.select()"
                    id="input-acconto"
                    v-model="formNuovaLavorazione.acconto"
                    type="number"
                    step=".01"
                  ></b-form-input>
                </b-form-group>
              </b-col>
              <b-col>
                <b-form-group
                  label="Costo:"
                  label-for="input-costo"
                  v-if="formNuovaLavorazione.showCosto"
                >
                  <b-form-input
                    @focus.native="$event.target.select()"
                    id="input-costo"
                    v-model="formNuovaLavorazione.costo"
                    type="number"
                    step=".01"
                  ></b-form-input>
                </b-form-group>
              </b-col>
              <b-col cols="2">
                <b-icon
                  v-if="!formNuovaLavorazione.showCosto"
                  icon="eye"
                  font-scale="1.6"
                  style="float: right"
                  @click="
                    formNuovaLavorazione.showCosto =
                      !formNuovaLavorazione.showCosto
                  "
                ></b-icon>
                <b-icon
                  v-else
                  icon="eye-slash"
                  font-scale="1.6"
                  style="float: right"
                  @click="
                    formNuovaLavorazione.showCosto =
                      !formNuovaLavorazione.showCosto
                  "
                ></b-icon>
              </b-col>
            </b-row>

            <b-row>
              <b-col>
                <b-form-group label="Ricevuto:" label-for="input-dataRicezione">
                  <b-form-datepicker
                    id="input-dataRicezione"
                    today-button
                    reset-button
                    v-model="formNuovaLavorazione.dataRicezione"
                    class="mb-2"
                  ></b-form-datepicker>
                </b-form-group>
              </b-col>
              <b-col>
                <b-form-group
                  label="Consegna Prevista:"
                  label-for="input-dataConsegnaPrevista"
                >
                  <b-form-datepicker
                    id="input-dataConsegnaPrevista"
                    today-button
                    reset-button
                    v-model="formNuovaLavorazione.dataConsegnaPrevista"
                    class="mb-2"
                  ></b-form-datepicker>
                </b-form-group>
              </b-col>
              <b-col>
                <b-form-group
                  label="Consegna Effettiva:"
                  label-for="input-dataConsegnaEffettiva"
                >
                  <b-form-datepicker
                    id="input-dataConsegnaEffettiva"
                    today-button
                    reset-button
                    v-model="formNuovaLavorazione.dataConsegnaEffettiva"
                    class="mb-2"
                  ></b-form-datepicker>
                </b-form-group>
              </b-col>
            </b-row>

            <b-form-group
              label="Stato/Fornitore da contattare:"
              label-for="input-stato"
            >
              <b-form-select
                id="input-stato"
                v-model="formNuovaLavorazione.stato"
                :options="optionsStato"
                required
              >
                <template #first>
                  <b-form-select-option :value="null" disabled
                    >-- Seleziona un'opzione --</b-form-select-option
                  >
                </template>
              </b-form-select>
            </b-form-group>
          </b-tab>
          <b-tab title="Foto">
            <b-container>
              <b-row>
                <b-col
                  v-bind:key="file.index"
                  v-for="file in formNuovaLavorazione.fileCaricati"
                >
                  <b-img
                    :src="file.src + '?' + $session.get('secret')"
                    :alt="file.nome"
                    fluid
                    @click="zoom(file.src)"
                  ></b-img>
                  <img
                    class="azione"
                    width="20"
                    alt="X"
                    @click="removeFileCaricato(file.id)"
                    src="../assets/del.png"
                  />
                </b-col>
              </b-row>
            </b-container>
            <b-row>
              <b-col>
                <div
                  class="uploaderDiv"
                  v-cloak
                  @drop.prevent="addFile"
                  @dragover.prevent
                >
                  <input
                    type="file"
                    name="file"
                    ref="file"
                    style="display: none"
                    @change="addFileDialog"
                  />
                  <p>Carica Immagini</p>
                  <button type="button" @click="$refs.file.click()">
                    Apri finestra o Trascina
                  </button>

                  <ul>
                    <li v-bind:key="file.index" v-for="file in files">
                      {{ file.name }} ({{ file.size | bTokb }} kb)
                      <img
                        class="azione"
                        width="20"
                        alt="X"
                        @click="removeFile(file)"
                        src="../assets/del.png"
                      />
                    </li>
                  </ul>
                </div>
              </b-col>
            </b-row>
          </b-tab>
        </b-tabs>

        <b-button type="submit" variant="primary">SALVA</b-button>
      </b-form>
    </b-modal>
    <b-modal id="modal-dettaglioFoto" hide-footer size="xl">
      <b-container>
        <b-img
          :src="selectedImage + '?' + $session.get('secret')"
          alt="dett"
          fluid
          style="
            display: block;
            margin-left: auto;
            margin-right: auto;
            width: 100%;
          "
        ></b-img>
      </b-container>
    </b-modal>

    <AddCliente @clienteAggiunto="getClienti" ref="addClient"></AddCliente>
  </b-container>
</template>

<script>
import axios from "axios";
import AddCliente from "../components/AddCliente.vue";
import { ModelSelect } from "vue-search-select";

export default {
  components: {
    AddCliente,
    ModelSelect,
  },

  data() {
    return {
      riparazioni: [],
      formNuovaLavorazione: {
        id: 0,
        tipoLavorazione: "ORDINE",
        idCliente: 0,
        oggetto: "",
        descrizione: "",
        costo: 0,
        acconto: 0,
        preventivo: 0,
        stato: "",
        dataRicezione: "",
        dataConsegnaPrevista: "",
        dataConsegnaEffettiva: "",
        showCosto: false,
        fileCaricati: [],
      },

      formNuovoCliente: {
        id: 0,
        cognome: "",
        nome: "",
        indirizzo: "",
        telefono: "",
        email: "",
        sconto: 0,
        note: "",
        attivo: 1,
        isAttivo: true,
      },
      titoloRiparazione: "",
      showUploadingSpinner: false,
      showAlertSuccess: false,
      showAlertFail: false,
      optionsClienti: null,
      optionsStato: [
        { value: "Negozio", text: "Negozio" },
        { value: "In sospeso", text: "In sospeso" },
        { value: "In progettazione 3D", text: "In progettazione 3D" },
        { value: "Da consegnare ad Antonio", text: "Da consegnare ad Antonio" },
        {
          value: "In lavorazione da Antonio",
          text: "In lavorazione da Antonio",
        },
        { value: "Da consegnare ad Daniel", text: "Da consegnare ad Daniel" },
        { value: "In lavorazione da Daniel", text: "In lavorazione da Daniel" },
        { value: "Da consegnare ad EuroGem", text: "Da consegnare ad EuroGem" },
        {
          value: "In lavorazione da EuroGem",
          text: "In lavorazione da EuroGem",
        },
        {
          value: "Da consegnare ad Fabrizia",
          text: "Da consegnare ad Fabrizia",
        },
        {
          value: "In lavorazione da Fabrizia",
          text: "In lavorazione da Fabrizia",
        },
        {
          value: "Da consegnare ad Moraglione",
          text: "Da consegnare ad Moraglione",
        },
        {
          value: "In lavorazione da Moraglione",
          text: "In lavorazione da Moraglione",
        },
        { value: "Consegnato", text: "Consegnato" },
      ],
      isLoading: false,
      files: [],
      selectedImage: null,
      filtroTipoLavorazione: "TUTTO",
      filtroStatoLavorazione: "TUTTO",
    };
  },

  mounted() {
    this.updateRiparazioniTable();
    if (this.$route.params.tipo != undefined) {
      this.filtroTipoLavorazione = this.$route.params.tipo;
    }
  },
  watch: {
    $route() {
      if (this.$route.params.tipo != undefined) {
        this.filtroTipoLavorazione = this.$route.params.tipo;
      } else {
        this.filtroTipoLavorazione = "TUTTO";
      }
    },
  },
  computed: {
    uploadDisabled() {
      return this.files.length === 0;
    },
    filtroTipoLavorazioneArray: function () {
      let fTipo = this.filtroTipoLavorazione;
      let fStato = this.filtroStatoLavorazione;
      return this.riparazioni.filter(function (lavorazione) {
        if (fTipo === "TUTTO") {
          if (fStato == "TUTTO") {
            return lavorazione;
          }
          if (fStato == "LAVORAZIONE") {
            if (lavorazione.stato != "Consegnato") return lavorazione;
          }
          if (fStato == "CONSEGNATO") {
            if (lavorazione.stato == "Consegnato") return lavorazione;
          }
        } else {
          if (fTipo == lavorazione.tipo) {
            if (fStato == "TUTTO") {
              return lavorazione;
            }
            if (fStato == "LAVORAZIONE") {
              if (lavorazione.stato != "Consegnato") return lavorazione;
            }
            if (fStato == "CONSEGNATO") {
              if (lavorazione.stato == "Consegnato") return lavorazione;
            }
          }
        }
      });
    },
  },
  methods: {
    zoom(url) {
      this.selectedImage = url;
      this.$bvModal.show("modal-dettaglioFoto");
    },
    addFileDialog(e) {
      let droppedFiles = e.target.files;
      if (!droppedFiles) return;
      // this tip, convert FileList to array, credit: https://www.smashingmagazine.com/2018/01/drag-drop-file-uploader-vanilla-js/
      [...droppedFiles].forEach((f) => {
        this.files.push(f);
      });
    },
    addFile(e) {
      let droppedFiles = e.dataTransfer.files;
      if (!droppedFiles) return;
      // this tip, convert FileList to array, credit: https://www.smashingmagazine.com/2018/01/drag-drop-file-uploader-vanilla-js/
      [...droppedFiles].forEach((f) => {
        this.files.push(f);
      });
    },
    removeFile(file) {
      this.files = this.files.filter((f) => {
        return f != file;
      });
    },
    upload() {},
    removeFileCaricato(id) {
      axios
        .get(
          this.$store.state.settings.URL_SERVER + "API/v1.php?deleteFile=" + id
        )
        .then(() => {
          this.updateRiparazioniTable();

          var filtered = this.formNuovaLavorazione.fileCaricati.filter(
            function (value) {
              if (value.id != id) return value;
            }
          );
          this.formNuovaLavorazione.fileCaricati = filtered;
        })
        .catch((err) => {
          console.log(err);
        });
    },
    updateRiparazioniTable() {
      this.isLoading = true;
      axios
        .get(
          this.$store.state.settings.URL_SERVER +
            "API/v1.php?riparazioni&secret=" +
            this.$session.get("secret")
        )
        .then((response) => {
          this.riparazioni = response.data.riparazioni;
          this.getClienti();
        })
        .catch((err) => {
          console.log(err);
        });
    },
    getClienti(value = 0) {
      this.isLoading = true;

      axios
        .get(
          this.$store.state.settings.URL_SERVER +
            "API/v1.php?clienti&attivi&secret=" +
            this.$session.get("secret")
        )
        .then((response) => {
          let lista = [];
          response.data.clienti.map(function (value) {
            lista.push({
              value: value.id,
              text: value.cognome + " " + value.nome,
            });
          });
          this.optionsClienti = lista;
          if (value > 0) this.formNuovaLavorazione.idCliente = value;
          this.isLoading = false;
        })
        .catch((err) => {
          console.log(err);
        });
    },
    addCliente() {
      this.$refs.addClient.showModal();
    },
    dettaglioRiparazione(payload) {
      let row = payload.data;
      this.modificaRiparazione(row);
    },
    modificaRiparazione(row) {
      this.clearformNuovaLavorazione();
      this.formNuovaLavorazione.id = row.id;
      this.formNuovaLavorazione.idCliente = row.idCliente;
      this.formNuovaLavorazione.tipoLavorazione = row.tipo;
      this.formNuovaLavorazione.oggetto = row.oggetto;
      this.formNuovaLavorazione.descrizione = row.descrizione;
      this.formNuovaLavorazione.acconto = row.acconto;
      this.formNuovaLavorazione.preventivo = row.preventivo;
      this.formNuovaLavorazione.costo = row.costo;
      this.formNuovaLavorazione.stato = row.stato;
      this.formNuovaLavorazione.dataRicezione = row.dataRicezione;
      this.formNuovaLavorazione.dataConsegnaPrevista = row.dataConsegnaPrevista;
      this.formNuovaLavorazione.dataConsegnaEffettiva =
        row.dataConsegnaEffettiva;
      this.formNuovaLavorazione.fileCaricati = row.imgs;
      this.titoloRiparazione = "Modifica";
      this.$bvModal.show("modal-nuovaRiparazione");
    },
    eliminaRiparazione(id) {
      this.$confirm({
        message: `Sicuro di voler eliminare la riparazione?`,
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
            axios
              .get(
                this.$store.state.settings.URL_SERVER +
                  "API/v1.php?eliminaRiparazione&id=" +
                  id +
                  "&secret=" +
                  this.$session.get("secret")
              )
              .then((response) => {
                if (response.status === 200 && response.data.result == "OK") {
                  this.sendAlert("success");
                  this.updateRiparazioniTable();
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
    clearformNuovaLavorazione() {
      this.formNuovaLavorazione.showCosto = false;
      this.titoloRiparazione = "Nuovo";
      this.formNuovaLavorazione.id = 0;
      this.formNuovaLavorazione.tipoLavorazione = "ORDINE";
      this.formNuovaLavorazione.idCliente = null;
      this.formNuovaLavorazione.oggetto = "";
      this.formNuovaLavorazione.descrizione = "";
      this.formNuovaLavorazione.costo = 0;
      this.formNuovaLavorazione.acconto = 0;
      this.formNuovaLavorazione.preventivo = 0;
      this.formNuovaLavorazione.stato = "IN RIPARAZIONE";
      this.formNuovaLavorazione.dataRicezione = "";
      this.formNuovaLavorazione.dataConsegnaPrevista = "";
      this.formNuovaLavorazione.dataConsegnaEffettiva = "";
      this.files = [];
    },
    onSubmitNuovaRiparazione() {
      this.isLoading = true;
      event.preventDefault();
      this.$set(this.formNuovaLavorazione, "azione", "nuovaRiparazione");
      this.$set(
        this.formNuovaLavorazione,
        "secret",
        this.$session.get("secret")
      );
      let myFormData = this.toFormData(this.formNuovaLavorazione);
      this.files.forEach((f, x) => {
        myFormData.append("file" + (x + 1), f);
      });

      axios
        .post(
          this.$store.state.settings.URL_SERVER + "API/v1.php",
          myFormData,
          {
            headers: {
              "Content-Type": "multipart/form-data",
            },
          }
        )
        .then((response) => {
          if (response.status === 200 && response.data.result == "OK") {
            this.sendAlert("success");
            this.clearformNuovaLavorazione();
            this.updateRiparazioniTable();
            this.$bvModal.hide("modal-nuovaRiparazione");
            this.isLoading = false;
          } else {
            this.sendAlert("fail");
          }
        })
        .catch((err) => {
          console.log(err);
          this.sendAlert("fail");
        });

      this.clearformNuovaLavorazione();
      this.$bvModal.hide("modal-nuovaRiparazione");
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
};
</script>
