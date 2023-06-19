<template>
  <b-container fluid>
    <loading
      :active.sync="isLoading"
      :can-cancel="true"
      :is-full-page="true"
    ></loading>

    <b-alert v-if="showAlertSuccess" variant="success" show
      >Completato!</b-alert
    >
    <b-alert v-if="showAlertFail" variant="warning" show>Errore!</b-alert>

    <b-col>
      <b-form @submit="creaPDF" id="formPDF" enctype="multipart/form-data">
        <b-row>
          <b-col>
            <b-form-group
              v-if="!isLoading"
              label="Cliente:"
              label-for="input-cliente"
            >
              <b-row>
                <b-col>
                  <model-select
                    id="input-cliente"
                    class="form-control"
                    style="background-color: #cfd8f1"
                    :options="optionsClienti"
                    v-model="clienteSelezionato"
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
          <b-col>
            <b-form-group label="Nome:" label-for="input-nome">
              <b-form-input
                name="nome"
                id="input-nome"
                v-model="conto.nome"
                type="text"
              ></b-form-input>
            </b-form-group>
          </b-col>
          <b-col cols="2">
            <b-form-group
              label="Num. progressivo:"
              label-for="input-numerazione"
            >
              <b-form-input
                name="numerazione"
                id="input-numerazione"
                v-model="conto.numerazione"
                type="text"
              ></b-form-input>
            </b-form-group>
          </b-col>
        </b-row>
        <b-row>
          <b-col>
            <b-form-group label="Indirizzo:" label-for="input-indirizzo">
              <b-form-input
                name="indirizzo"
                id="input-indirizzo"
                v-model="conto.indirizzo"
                type="text"
              ></b-form-input>
            </b-form-group>
          </b-col>
          <b-col>
            <b-form-group label="Telefono:" label-for="input-telefono">
              <b-form-input
                name="telefono"
                id="input-telefono"
                v-model="conto.telefono"
                type="text"
              ></b-form-input>
            </b-form-group>
          </b-col>
          <b-col>
            <b-form-group label="Email:" label-for="input-email">
              <b-form-input
                name="email"
                id="input-email"
                v-model="conto.email"
                type="text"
              ></b-form-input>
            </b-form-group>
          </b-col>
        </b-row>
        <b-row>
          <b-col>
            <b-form-group label="Descrizione:" label-for="input-descrizione">
              <b-form-textarea
                name="descrizione"
                id="input-descrizione"
                v-model="conto.descrizione"
                placeholder=""
                rows="2"
                max-rows="6"
              ></b-form-textarea>
            </b-form-group>
          </b-col>
          <b-col>
            <b-form-group
              label="Caratteristiche:"
              label-for="input-caratteristiche"
            >
              <b-form-textarea
                name="caratteristiche"
                id="input-caratteristiche"
                v-model="conto.caratteristiche"
                placeholder=""
                rows="2"
                max-rows="6"
              ></b-form-textarea>
            </b-form-group>
          </b-col>
          <b-col>
            <b-form-group label="Pietre:" label-for="input-pietre">
              <b-form-textarea
                name="pietre"
                id="input-pietre"
                v-model="conto.pietre"
                placeholder=""
                rows="2"
                max-rows="6"
              ></b-form-textarea>
            </b-form-group>
          </b-col>
        </b-row>

        <b-row>
          <b-col>
            <b-form-group label="Codice:" label-for="input-codice">
              <b-form-input
                name="codice"
                id="input-codice"
                v-model="conto.codice"
                type="text"
              ></b-form-input>
            </b-form-group>
          </b-col>
          <b-col>
            <b-form-group label="Certificato:" label-for="input-certificato">
              <b-form-input
                name="cert"
                id="input-certificato"
                v-model="conto.cert"
                type="text"
              ></b-form-input>
            </b-form-group>
          </b-col>
        </b-row>
        <b-row>
          <b-col>
            <b-form-group label="Lavori da eseguire:" label-for="input-lavori">
              <b-form-textarea
                name="lavori"
                id="input-lavori"
                v-model="conto.lavori"
                placeholder=""
                rows="2"
                max-rows="6"
              ></b-form-textarea>
            </b-form-group>
          </b-col>
          <b-col>
            <b-form-group label="Note:" label-for="input-note">
              <b-form-textarea
                name="note"
                id="input-note"
                v-model="conto.note"
                placeholder=""
                rows="2"
                max-rows="6"
              ></b-form-textarea>
            </b-form-group>
          </b-col>
          <b-col>
            <div class="uploaderDiv">
              <input
                type="file"
                name="file1"
                ref="file"
                style="display: none"
                @change="addFileDialog"
              />
              <p>Carica Immagini</p>
              <button type="button" @click="$refs.file.click()">
                Apri finestra per scegliere il file
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
        <b-row>
          <b-col>
            <b-form-group
              label="Lav.Preventivati:"
              label-for="input-lavoriPreventivati"
            >
              <b-form-input
                name="lavoriPreventivati"
                id="input-lavoriPreventivati"
                v-model="conto.lavoriPreventivati"
                type="text"
              ></b-form-input>
            </b-form-group>
          </b-col>
          <b-col>
            <b-form-group label="Acconto:" label-for="input-acconto">
              <b-form-input
                name="acconto"
                id="input-acconto"
                v-model="conto.acconto"
                type="text"
              ></b-form-input>
            </b-form-group>
          </b-col>
          <b-col>
            <b-form-group
              label="Rimanenza alla consegna:"
              label-for="input-totaleNetto"
            >
              <b-form-input
                name="rimanenzaConsegna"
                id="input-rimanenzaConsegna"
                v-model="conto.rimanenzaConsegna"
                type="text"
              ></b-form-input>
            </b-form-group>
          </b-col>
          <b-col>
            <b-form-group
              label="Data di Consegna Prevista:"
              label-for="input-dataPrevista"
            >
              <b-form-datepicker
                name="dataConsegnaPrevista"
                id="input-dataPrevista"
                today-button
                reset-button
                v-model="conto.dataConsegnaPrevista"
                class="mb-2"
              ></b-form-datepicker>
            </b-form-group>
          </b-col>
          <b-col>
            <b-form-group label="Data di Consegna:" label-for="input-data">
              <b-form-datepicker
                name="dataConsegna"
                id="input-data"
                today-button
                reset-button
                v-model="conto.dataConsegna"
                class="mb-2"
              ></b-form-datepicker>
            </b-form-group>
          </b-col>
        </b-row>
        <b-button type="submit" variant="warning">STAMPA</b-button>
      </b-form>
    </b-col>

    <AddCliente @clienteAggiunto="getClienti" ref="addClient"></AddCliente>
  </b-container>
</template>

<script>
import axios from "axios";
import { ModelSelect } from "vue-search-select";
import AddCliente from "../components/AddCliente.vue";

export default {
  components: {
    ModelSelect,
    AddCliente,
  },
  data() {
    return {
      conto: {
        numerazione: "",
        nome: "",
        indirizzo: "",
        telefono: "",
        email: "",
        descrizione: "",
        caratteristiche: "",
        pietre: "",
        codice: "",
        cert: "",
        lavori: "",
        note: "",
        lavoriPreventivati: "",
        rimanenzaConsegna: "",
        acconto: "",
        dataConsegnaPrevista: "",
        dataConsegna: "",
        file: null,
      },
      optionsClienti: [],
      clienti: [],
      clienteSelezionato: "0",
      files: [],
      showAlertSuccess: false,
      showAlertFail: false,
      isLoading: false,
    };
  },
  mounted() {
    this.getClienti();
    this.getProgressivoConti();
  },
  watch: {
    clienteSelezionato: function (val) {
      let nome = "";
      let indirizzo = "";
      let tel = "";
      let email = "";
      this.clienti.forEach(function (item) {
        if (item.id == val) {
          nome = item.cognome + " " + item.nome;
          indirizzo = item.indirizzo;
          tel = item.telefono;
          email = item.email;
        }
      });
      this.conto.nome = nome;
      this.conto.indirizzo = indirizzo;
      if (this.$session.get("AUTORIZZAZIONI").numeri_telefono >= 1) {
        this.conto.telefono = tel;
      } else {
        this.conto.telefono = "";
      }

      this.conto.email = email;
    },
  },
  computed: {
    uploadDisabled() {
      return this.files.length === 0;
    },
  },
  methods: {
    getProgressivoConti() {
      axios
        .get(
          this.$store.state.settings.URL_SERVER +
            "API/v1.php?progressivoConti&secret=" +
            this.$session.get("secret")
        )
        .then((response) => {
          console.log(response.data);
          this.conto.numerazione = response.data.progressivo;
        })
        .catch((err) => {
          console.log(err);
        });
    },
    setProgressivoConti() {
      axios
        .get(
          this.$store.state.settings.URL_SERVER +
            "API/v1.php?SetProgressivoConti&secret=" +
            this.$session.get("secret") +
            "&progressivoC=" +
            this.conto.numerazione
        )
        .then((response) => {
          console.log(response.data);
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
          this.clienti = response.data.clienti;
          let lista = [];
          response.data.clienti.map(function (value) {
            lista.push({
              value: value.id,
              text: value.cognome + " " + value.nome,
            });
          });
          this.optionsClienti = lista;
          this.isLoading = false;
          this.clienteSelezionato = value.toString();
        })
        .catch((err) => {
          console.log(err);
        });
    },
    addCliente() {
      this.$refs.addClient.showModal();
    },
    addFileDialog(e) {
      let droppedFiles = e.target.files;
      if (!droppedFiles) return;
      this.files = [];

      // this tip, convert FileList to array, credit: https://www.smashingmagazine.com/2018/01/drag-drop-file-uploader-vanilla-js/
      [...droppedFiles].forEach((f) => {
        this.files.push(f);
      });
    },
    addFile(e) {
      let droppedFiles = e.dataTransfer.files;
      if (!droppedFiles) return;
      this.files = [];

      // this tip, convert FileList to array, credit: https://www.smashingmagazine.com/2018/01/drag-drop-file-uploader-vanilla-js/
      [...droppedFiles].forEach((f) => {
        this.files.push(f);
      });
    },
    removeFile(file) {
      this.file = null;
      this.files = this.files.filter((f) => {
        return f != file;
      });
    },
    creaPDF() {
      this.setProgressivoConti();
      event.preventDefault();
      let form = document.getElementById("formPDF");

      form.action =
        this.$store.state.settings.URL_SERVER + "API/printConto.php";
      form.method = "POST";
      form.target = "_blank";
      form.submit();
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
  filters: {},
};
</script>
