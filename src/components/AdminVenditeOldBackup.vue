<template>
  <b-container>
    <form>
      <div class="form-group">
        <div class="align-left"><label>CLIENTE</label></div>
        <model-select
          class="form-control"
          :options="optionsClienti"
          v-model="cliente"
          placeholder="Seleziona il cliente"
        ></model-select>
      </div>

      <div class="form-group">
        <div class="align-left"><label>PRODOTTO 1 </label></div>
        <model-select
          class="form-control"
          :options="optionsProdotti"
          v-model="prodotto1"
          placeholder="Seleziona il prodotto"
        ></model-select>
      </div>
      <div class="form-group">
        <div class="align-left"><label>PRODOTTO 2 </label></div>
        <model-select
          class="form-control"
          :options="optionsProdotti"
          v-model="prodotto2"
          placeholder="Seleziona il prodotto"
        ></model-select>
      </div>
      <div class="form-group">
        <div class="align-left"><label>PRODOTTO 3 </label></div>
        <model-select
          class="form-control"
          :options="optionsProdotti"
          v-model="prodotto3"
          placeholder="Seleziona il prodotto"
        ></model-select>
      </div>
      <div class="form-group">
        <div class="container">
          <div class="row">
            <div class="col">
              <div class="align-left"><label>DATA VENDITA</label></div>
              <div class="align-left">
                <date-picker
                  :lang="lang"
                  :default-value="dataVendita"
                  v-model="dataVendita"
                  valueType="DD/MM/YYYY"
                ></date-picker>
                {{ dataVendita }}
              </div>
            </div>
            <div class="col-8">
              <textarea
                placeholder="Inserisci una nota..."
                class="form-control"
                id="note"
                v-model="note"
                rows="3"
              ></textarea>
            </div>
          </div>
        </div>
      </div>

      <div class="form-group">
        <b-button v-on:click="submitVendita()">SALVA</b-button>
      </div>
    </form>
    <b-alert v-if="showAlertSuccess" variant="success" show>INSERITO!</b-alert>
    <b-alert v-if="showAlertFail" variant="warning" show
      >Errore! - VERIFICA CHE IL FILE EXCEL SIA CHIUSO</b-alert
    >
    <div v-if="showUploadingSpinner">
      <b-spinner label="Loading..."></b-spinner>
    </div>
  </b-container>
</template>

<script>
import axios from "axios";
import { ModelSelect } from "vue-search-select";
import moment from "moment";
import DatePicker from "vue2-datepicker";

export default {
  data() {
    return {
      optionsClienti: [],
      optionsProdotti: [],
      clienti: [],
      prodotti: [],
      note: "",
      dataVendita: moment(String(new Date())).format("DD/MM/YYYY"),
      lang: {
        formatLocale: {
          monthsShort: [
            "Gen",
            "Feb",
            "Mar",
            "Apr",
            "Mag",
            "Giu",
            "Lug",
            "Ago",
            "Set",
            "Ott",
            "Nov",
            "Dec",
          ],
          weekdaysMin: ["Do", "Lu", "Ma", "Me", "Gi", "Ve", "Sa"],
          firstDayOfWeek: 1,
        },
        monthBeforeYear: true,
      },
      cliente: {
        value: "",
        text: "",
      },
      prodotto1: {
        value: "",
        text: "",
      },
      prodotto2: {
        value: "",
        text: "",
      },
      prodotto3: {
        value: "",
        text: "",
      },
      showAlertSuccess: false,
      showAlertFail: false,
      showUploadingSpinner: false,
    };
  },
  components: {
    ModelSelect,
    DatePicker,
  },

  mounted() {
    this.getListaClienti();
    this.getListaProdotti();
  },
  methods: {
    formatDate(date) {
      return moment(date).format("DD-MM-YYYY");
    },
    getListaClienti() {
      axios
        .get(this.$store.state.settings.URL_SERVER + "api/v1.php?listaClienti")
        .then((response) => {
          this.clienti = response.data.clienti;
          let lista = [{ value: 0, text: "OSPITE" }];
          response.data.clienti.map(function (value) {
            lista.push({ value: value.nome, text: value.nome });
          });
          this.optionsClienti = lista;
        })
        .catch((err) => {
          console.log(err);
        });
    },
    getListaProdotti() {
      axios
        .get(this.$store.state.settings.URL_SERVER + "api/v1.php?prodotti")
        .then((response) => {
          this.prodotti = response.data.prodotti;
          let lista = [{ value: 0, text: "-" }];
          response.data.prodotti.map(function (value) {
            lista.push({
              value: value.id,
              text: value.titolo + " - " + value.descrizione,
            });
          });
          this.optionsProdotti = lista;
        })
        .catch((err) => {
          console.log(err);
        });
    },
    submitVendita() {
      this.showUploadingSpinner = true;
      let formData = new FormData();
      formData.append("prodotto1", this.prodotto1.value);
      formData.append("prodotto2", this.prodotto2.value);
      formData.append("prodotto3", this.prodotto3.value);
      formData.append("dataVendita", this.dataVendita);
      formData.append("cliente", this.cliente.value);
      formData.append("note", this.note);
      axios
        .post(this.$store.state.settings.URL_SERVER + "api/v1.php", formData, {
          headers: {
            "Content-Type": "multipart/form-data",
          },
        })
        .then((response) => {
          this.showUploadingSpinner = false;
          if (response.data.stato == "successo") {
            this.note = "";
            this.sendAlert("success");
          } else {
            this.sendAlert("fail");
          }
        })
        .catch((err) => {
          console.log(err);
          this.showUploadingSpinner = false;
          this.sendAlert("fail");
        });
    },
    reset() {
      this.item = {};
    },
    selectFromParentComponent1() {
      // select option from parent component
      this.item = this.options[0];
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
  },
};
</script>
