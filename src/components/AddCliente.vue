<template>
  <b-modal id="modal-nuovoCliente" hide-footer :title="titoloCliente" size="xl">
    <b-form @submit="onSubmitNuovoCliente">
      <b-row>
        <b-col>
          <b-form-group label="Nome:" label-for="input-nome">
            <b-form-input
              id="input-nome"
              v-model="formNuovoCliente.nome"
              type="text"
            ></b-form-input>
          </b-form-group>
        </b-col>
        <b-col>
          <b-form-group label="Cognome:" label-for="input-cognome">
            <b-form-input
              id="input-cognome"
              v-model="formNuovoCliente.cognome"
              type="text"
            ></b-form-input>
          </b-form-group>
        </b-col>
      </b-row>

      <b-form-group
        label="Telefono:"
        label-for="input-telefono"
        v-if="
          this.$session.exists() &&
          this.$session.get('AUTORIZZAZIONI').numeri_telefono >= 1
        "
      >
        <b-form-input
          id="input-telefono"
          v-model="formNuovoCliente.telefono"
          type="text"
        ></b-form-input>
      </b-form-group>
      <b-form-group label="Email:" label-for="input-email">
        <b-form-input
          id="input-email"
          v-model="formNuovoCliente.email"
          type="email"
        ></b-form-input>
      </b-form-group>
      <b-form-group label="Indirizzo:" label-for="input-indirizzo">
        <b-form-input
          id="input-indirizzo"
          v-model="formNuovoCliente.indirizzo"
          type="text"
        ></b-form-input>
      </b-form-group>
      <b-form-group label="Sconto(%):" label-for="input-sconto">
        <b-form-input
          id="input-sconto"
          v-model="formNuovoCliente.sconto"
          type="number"
          step=".01"
        ></b-form-input>
      </b-form-group>
      <b-row>
        <b-col>
          <b-form-group label="Fascia Prezzo:" label-for="input-fasciaPrezzo">
            <b-form-select
              id="input-fasciaPrezzo"
              v-model="formNuovoCliente.fasciaPrezzo"
              :options="optionsFasciaPrezzo"
            ></b-form-select>
          </b-form-group>
        </b-col>
        <b-col>
          <b-form-group
            label="Tipologia di gioielli richiesta:"
            label-for="input-tipologiaRichiesta"
          >
            <b-form-input
              id="input-tipologiaRichiesta"
              v-model="formNuovoCliente.tipologiaRichiesta"
              type="text"
            ></b-form-input>
          </b-form-group>
        </b-col>
        <b-col>
          <b-form-group label="Misura Anello:" label-for="input-misuraAnello">
            <b-form-input
              id="input-misuraAnello"
              v-model="formNuovoCliente.misuraAnello"
              type="text"
            ></b-form-input>
          </b-form-group>
        </b-col>
      </b-row>
      <b-row>
        <b-col>
          <b-form-group label="Data di nascita:" label-for="input-dataNascita">
            <b-form-datepicker
              id="input-dataNascita"
              today-button
              reset-button
              v-model="formNuovoCliente.dataNascita"
              class="mb-2"
            ></b-form-datepicker>
          </b-form-group>
        </b-col>
        <b-col>
          <b-form-group label="Fascia Età:" label-for="input-fasciaEta">
            <b-form-select
              id="input-fasciaEta"
              v-model="formNuovoCliente.fasciaEta"
              :options="optionsFasciaEta"
            ></b-form-select>
          </b-form-group>
        </b-col>
      </b-row>
      <b-row>
        <b-col>
          <b-form-group label="Fonte Visita:" label-for="input-fonte">
            <model-select
              class="form-control"
              id="input-fonte"
              :options="optionsFonte"
              v-model="formNuovoCliente.fonte"
              placeholder="Seleziona la fonte"
            ></model-select>
          </b-form-group>
        </b-col>
        <b-col>
          <b-form-group
            label="Dettaglio fonte:"
            label-for="input-dettaglioFonte"
          >
            <b-form-input
              id="input-dettaglioFonte"
              v-model="formNuovoCliente.fonte_dettaglio"
              type="text"
            ></b-form-input>
          </b-form-group>
        </b-col>
      </b-row>
      <b-form-group label="Hobbies:" label-for="input-hobbies">
        <b-form-input
          id="input-hobbies"
          v-model="formNuovoCliente.hobbies"
          type="text"
        ></b-form-input>
      </b-form-group>
      <b-form-group label="Note:" label-for="input-note">
        <b-form-input
          id="input-note"
          v-model="formNuovoCliente.note"
          type="text"
        ></b-form-input>
      </b-form-group>
      <b-row>
        <b-col>
          <b-form-group label="Cliente collegto (1):" label-for="input-coll1">
            <model-select
              id="input-coll1"
              class="form-control"
              :options="optionsClienti"
              v-model="formNuovoCliente.idCollegamento1"
              placeholder="Seleziona il cliente"
            ></model-select>
          </b-form-group>
        </b-col>
        <b-col>
          <b-form-group label="Relazione" label-for="input-relazione1">
            <b-form-input
              id="input-relazione1"
              v-model="formNuovoCliente.relazione1"
              type="text"
            ></b-form-input>
          </b-form-group>
        </b-col>
      </b-row>
      <hr />
      <b-row>
        <b-col>
          <b-form-group label="Cliente collegto (2):" label-for="input-coll2">
            <model-select
              id="input-coll1"
              class="form-control"
              :options="optionsClienti"
              v-model="formNuovoCliente.idCollegamento2"
              placeholder="Seleziona il cliente"
            ></model-select>
          </b-form-group>
        </b-col>
        <b-col>
          <b-form-group label="Relazione" label-for="input-relazione2">
            <b-form-input
              id="input-relazione2"
              v-model="formNuovoCliente.relazione2"
              type="text"
            ></b-form-input>
          </b-form-group>
        </b-col>
      </b-row>
      <b-form-checkbox
        style="margin-bottom: 3em"
        v-model="formNuovoCliente.tagAttivo"
        name="input-tag"
        id="input-tag"
        switch
      >
        TAG:
        <b>
          <span v-if="formNuovoCliente.tagAttivo == true"
            ><b-icon
              icon="bookmarks-fill"
              variant="success"
              font-scale="1.5"
              style="margin-left: 0.5em"
            ></b-icon
            >SI</span
          >
          <span v-else
            ><b-icon
              icon="bookmarks"
              variant="success"
              font-scale="1.5"
              style="margin-left: 0.5em"
            ></b-icon>
            NO</span
          >
        </b>
      </b-form-checkbox>
      <hr />
      <b-form-checkbox
        style="margin-bottom: 3em; float: right"
        v-model="formNuovoCliente.isAttivo"
        name="input-attivo"
        id="input-attivo"
        switch
      >
        Attivo:
        <b>
          <span v-if="formNuovoCliente.isAttivo == true">SI</span>
          <span v-else>NO</span>
        </b>
      </b-form-checkbox>

      <b-button type="submit" variant="primary">SALVA</b-button>
    </b-form>
  </b-modal>
</template>

<script>
import axios from "axios";
import { ModelSelect } from "vue-search-select";

export default {
  data() {
    return {
      clienti: [],
      formNuovoCliente: {
        id: 0,
        cognome: "",
        nome: "",
        indirizzo: "",
        telefono: "",
        email: "",
        sconto: 0,
        tipologiaRichiesta: "",
        fasciaPrezzo: "Tutto",
        hobbies: "",
        dataNascita: null,
        note: "",
        attivo: 1,
        idCollegamento1: null,
        idCollegamento2: null,
        relazione1: "",
        relazione2: "",
        isAttivo: true,
        tagAttivo: false,
        misuraAnello: "",
        fasciaEta: "",
        fonte: "",
        fonte_dettaglio: "",
      },
      titoloCliente: "",
      showUploadingSpinner: false,
      showAlertSuccess: false,
      showAlertFail: false,
      optionsClienti: [],
      optionsFonte: [
        { value: "Online", text: "Online" },
        { value: "Vetrine", text: "Vetrine" },
        { value: "Da cliente", text: "Da cliente" },
        { value: "Altro", text: "Altro" },
      ],
      optionsFasciaEta: [
        { value: "18-35", text: "18-35" },
        { value: "36-44", text: "36-44" },
        { value: "45-60", text: "45-60" },
        { value: "60+", text: "60+" },
      ],
      optionsFasciaPrezzo: [
        { value: "Tutto", text: "Tutto" },
        { value: "<500", text: "<500" },
        { value: "500-1000", text: "500-1000" },
        { value: "1000-2000", text: "1000-2000" },
        { value: "2000-3000", text: "2000-3000" },
        { value: "3000-6000", text: "3000-6000" },
        { value: ">6000", text: ">6000" },
      ],
    };
  },
  components: {
    ModelSelect,
  },
  mounted() {
    this.getListaClienti();
  },
  methods: {
    showModal() {
      this.$bvModal.show("modal-nuovoCliente");
    },

    modificaCliente(row) {
      this.clearFormNuovoCliente();
      this.titoloCliente = "Modifica Cliente";
      this.formNuovoCliente.cognome = row.cognome;
      this.formNuovoCliente.nome = row.nome;
      this.formNuovoCliente.telefono = row.telefono;
      this.formNuovoCliente.email = row.email;
      this.formNuovoCliente.indirizzo = row.indirizzo;
      this.formNuovoCliente.sconto = row.sconto;
      this.formNuovoCliente.attivo = row.attivo;
      this.formNuovoCliente.misuraAnello = row.misuraAnello;
      if (this.formNuovoCliente.attivo == 1) {
        this.formNuovoCliente.isAttivo = true;
      } else {
        this.formNuovoCliente.isAttivo = false;
      }
      this.formNuovoCliente.tagAttivo = row.tagAttivo;
      if (this.formNuovoCliente.tagAttivo == 1) {
        this.formNuovoCliente.tagAttivo = true;
      } else {
        this.formNuovoCliente.tagAttivo = false;
      }
      this.formNuovoCliente.dataNascita = row.dataNascita;
      this.formNuovoCliente.note = row.note;
      this.formNuovoCliente.id = row.id;
      this.formNuovoCliente.tipologiaRichiesta = row.tipologiaRichiesta;
      this.formNuovoCliente.fasciaPrezzo = row.fasciaPrezzo;
      this.formNuovoCliente.fasciaEta = row.fasciaEta;

      this.formNuovoCliente.hobbies = row.hobbies;
      this.formNuovoCliente.idCollegamento1 = row.idCollegamento1;
      this.formNuovoCliente.idCollegamento2 = row.idCollegamento2;
      this.formNuovoCliente.relazione1 = row.relazione1;
      this.formNuovoCliente.relazione2 = row.relazione2;
      this.formNuovoCliente.fonte = row.fonte;
      this.formNuovoCliente.fonte_dettaglio = row.fonte_dettaglio;

      this.$bvModal.show("modal-nuovoCliente");
    },

    clearFormNuovoCliente() {
      this.titoloCliente = "Nuovo Cliente";
      this.formNuovoCliente.cognome = "";
      this.formNuovoCliente.nome = "";
      this.formNuovoCliente.telefono = "";
      this.formNuovoCliente.misuraAnello = "";
      this.formNuovoCliente.email = "";
      this.formNuovoCliente.indirizzo = "";
      this.formNuovoCliente.sconto = 0;
      this.formNuovoCliente.attivo = 1;
      this.formNuovoCliente.isAttivo = true;
      this.formNuovoCliente.tagAttivo = false;
      this.formNuovoCliente.id = 0;
      this.formNuovoCliente.dataNascita = null;
      this.formNuovoCliente.note = "";
      this.formNuovoCliente.tipologiaRichiesta = "";
      this.formNuovoCliente.fasciaPrezzo = "Tutto";
      this.formNuovoCliente.fasciaEta = "";
      this.formNuovoCliente.hobbies = "";
      this.formNuovoCliente.idCollegamento1 = null;
      this.formNuovoCliente.idCollegamento2 = null;
      this.formNuovoCliente.relazione1 = "";
      this.formNuovoCliente.relazione2 = "";
      this.formNuovoCliente.fonte = "";
      this.formNuovoCliente.fonte_dettaglio = "";
    },
    getListaClienti() {
      axios
        .get(
          this.$store.state.settings.URL_SERVER +
            "API/v1.php?clienti&attivi&secret=" +
            this.$session.get("secret")
        )
        .then((response) => {
          console.log(response);
          let lista = [{ value: 0, text: "-" }];
          response.data.clienti.map(function (value) {
            lista.push({
              value: value.id,
              text: value.cognome + " " + value.nome,
            });
          });
          this.optionsClienti = lista;
        })
        .catch((err) => {
          console.log(err);
        });
    },
    onSubmitNuovoCliente() {
      event.preventDefault();
      this.$set(this.formNuovoCliente, "azione", "nuovoCliente");
      this.$set(this.formNuovoCliente, "secret", this.$session.get("secret"));
      this.formNuovoCliente.attivo =
        this.formNuovoCliente.isAttivo == true ? 1 : 0;
      this.formNuovoCliente.tagAttivo =
        this.formNuovoCliente.tagAttivo == true ? 1 : 0;

      axios
        .post(
          this.$store.state.settings.URL_SERVER + "API/v1.php",
          this.toFormData(this.formNuovoCliente),
          {
            headers: {
              "Content-Type": "application/json",
            },
          }
        )
        .then((response) => {
          console.log(response);
          if (response.status === 200 && response.data.result == "OK") {
            this.sendAlert("success");
            this.clearFormNuovoCliente();
            this.$emit("clienteAggiunto", response.data.id);
          } else {
            this.sendAlert("success");
          }
        })
        .catch((err) => {
          console.log(err);
          this.sendAlert("fail");
        });

      this.clearFormNuovoCliente();
      this.$bvModal.hide("modal-nuovoCliente");
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
