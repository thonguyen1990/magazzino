<template>
  <b-container fluid>
    <loading
      :active.sync="isLoading"
      :can-cancel="true"
      :is-full-page="true"
    ></loading>
    <b-col>
      <div class="mx-auto mb-3 mt-1">
        <b-button
          v-b-modal.modal-nuovoCliente
          variant="success"
          @click="clearFormNuovoCliente()"
          class="btn-sm btn-outline-success"
          >NUOVO CLIENTE</b-button
        >
        <a
          v-if="this.$session.get('AUTORIZZAZIONI').numeri_telefono >= 1"
          style="float: right"
          v-bind:href="
            $store.state.settings.URL_SERVER +
            'API/esportaXLSX.php?esportaClienti&secret=' +
            $session.get('secret')
          "
          target="_blank"
        >
          <img width="60" alt="downloadXLSX" src="../assets/xlsx.png" />
        </a>
      </div>
      <b-alert v-if="showAlertSuccess" variant="success" show
        >Completato!</b-alert
      >
      <b-alert v-if="showAlertFail" variant="warning" show>Errore!</b-alert>
      <table-component
        :data="filtroPromemoriaArray"
        @rowClick="dettaglioCliente"
        style="width: 100%"
      >
        <table-column header-class="w-5" label="">
          <template slot-scope="row">
            <img
              width="20"
              alt="EditN"
              @click.stop="modificaCliente(row)"
              src="../assets/edit.png"
            />
            <img
              width="20"
              alt="x"
              @click.stop="eliminaCliente(row.id)"
              src="../assets/del.png"
              style="margin-left: 1em"
            />
            <b-icon
              @click.stop="nuovaVisita(row)"
              icon="shop"
              font-scale="1.5"
              style="margin-left: 1em"
            ></b-icon>
          </template>
        </table-column>
        <table-column header-class="w-1" label="">
          <template slot-scope="row">
            <b-icon
              v-if="row.tagAttivo == '1'"
              icon="bookmarks-fill"
              variant="success"
              font-scale="1.5"
              style="margin-left: 0.5em"
            ></b-icon>
          </template>
        </table-column>
        <table-column show="nomeCognome" label="Nominativo"></table-column>
        <table-column
          v-if="
            this.$session.exists() &&
            this.$session.get('AUTORIZZAZIONI').numeri_telefono >= 1
          "
          header-class="w-5"
          label="Tel."
        >
          <template slot-scope="row">
            <span v-if="row.telefono != ''">
              <a v-bind:href="row.wappLink" target="_blank"
                ><img width="20" alt="Wapp" src="../assets/wapp.png" />{{
                  row.telefono
                }}</a
              >
            </span>
          </template>
        </table-column>
        <table-column show="email" label="Email"></table-column>
        <table-column show="ultimaVisita" label="Ultima Visita">
          <template slot-scope="row">
            {{ row.ultimaVisita | dataITA }}
          </template>
        </table-column>
      </table-component>
    </b-col>
    <AddCliente
      @clienteAggiunto="onSubmitNuovoCliente()"
      ref="addClient"
    ></AddCliente>
    <AddVisita
      v-if="!isLoading"
      @visitaAggiunta="onSubmitNuovaVisita()"
      ref="addVisita"
    ></AddVisita>
    <b-modal
      id="modal-dettagliCliente"
      hide-footer
      :title="dettagliCliente.titoloCliente"
      size="xl"
    >
      <b-tabs
        content-class="mt-3"
        active-class="my-active-class"
        active-nav-item-class="active-link"
      >
        <b-tab title="INFO CLIENTE" active>
          <b-container fluid>
            <b-row>
              <b-col cols
                ><span class="dettagliClienteCampo">EMAIL: </span
                ><span>{{ dettagliCliente.email | elementoND }}</span></b-col
              >
              <b-col cols
                ><span class="dettagliClienteCampo">TELEFONO: </span
                ><span>{{ dettagliCliente.telefono | elementoND }}</span></b-col
              >
            </b-row>
            <hr />
            <b-row>
              <b-col cols
                ><span class="dettagliClienteCampo">SCONTO: </span
                ><span>{{ dettagliCliente.sconto | elementoND }}</span></b-col
              >
              <b-col cols
                ><span class="dettagliClienteCampo">FASCIA PREZZO: </span
                ><span>{{
                  dettagliCliente.fasciaPrezzo | elementoND
                }}</span></b-col
              >
            </b-row>
            <hr />
            <b-row>
              <b-col cols
                ><span class="dettagliClienteCampo">TIPOLOGIA RICHIESTA: </span
                ><span>{{
                  dettagliCliente.tipologiaRichiesta | elementoND
                }}</span></b-col
              >
              <b-col cols
                ><span class="dettagliClienteCampo">MISURA ANELLO: </span
                ><span>{{
                  dettagliCliente.misuraAnello | elementoND
                }}</span></b-col
              >
            </b-row>
            <hr />
            <b-row>
              <b-col cols
                ><span class="dettagliClienteCampo">HOBBIES: </span
                ><span>{{ dettagliCliente.hobbies | elementoND }}</span></b-col
              >
              <b-col cols
                ><span class="dettagliClienteCampo">FASCIA ETÀ: </span
                ><span>{{
                  dettagliCliente.fasciaEta | elementoND
                }}</span></b-col
              >
            </b-row>
            <hr />
            <b-row>
              <b-col cols
                ><span class="dettagliClienteCampo">NOTE: </span
                ><span>{{ dettagliCliente.note | elementoND }}</span></b-col
              >
            </b-row>
            <hr />
            <b-row>
              <b-col cols
                ><span class="dettagliClienteCampo">CLIENTI COLLEGATI: </span>
                <br />
                <span
                  >{{ dettagliCliente.nomeCollegamento1 }}
                  {{ dettagliCliente.relazione1 }}</span
                ><br />
                <span
                  >{{ dettagliCliente.nomeCollegamento2 }}
                  {{ dettagliCliente.relazione2 }}</span
                >
              </b-col>
            </b-row>
          </b-container>
        </b-tab>
        <b-tab
          title="STORICO VISITE"
          @click="getVisiteCliente(dettagliCliente.id)"
        >
          <b-navbar toggleable="lg" class="storico-navbar">
            <b-navbar-brand>Tutto</b-navbar-brand>
            <b-navbar-brand>Vendite</b-navbar-brand>
            <b-navbar-brand>Visite</b-navbar-brand>
            <b-navbar-brand>Lavorazioni</b-navbar-brand>
            <b-navbar-brand>Ordinazioni</b-navbar-brand>
          </b-navbar>

          <b-list-group>
            <b-list-group-item
              v-for="visita in visiteCliente"
              :key="visita.data"
              class="d-flex justify-content-start align-items-center"
            >
              <span v-if="visita.venduto" class="visitaVenduto">{{
                visita.data | dataITA
              }}</span>
              <span v-else>{{ visita.data | dataITA }}</span>
              <span v-if="visita.isGift == 1">
                <b-icon
                  icon="gift-fill"
                  variant="success"
                  font-scale="1.5"
                  style="margin-left: 0.5em"
                ></b-icon
              ></span>
              <b-list-group style="margin-left: 2em">
                <b-row
                  v-for="vendita in visita.vendite"
                  :key="vendita.id"
                  class=""
                >
                  <b-col cols="11">
                    <span
                      v-if="vendita.cat != '' || vendita.sottocat != ''"
                      class="grassetto1"
                      >{{ vendita.cat }} {{ vendita.sottocat }}<br
                    /></span>
                    {{ vendita.itemTitolo }} {{ vendita.itemDesc }} [{{
                      vendita.itemPrezzo
                    }}€ - Sc. {{ vendita.sconto | noDecimali }}%] <br /><span
                      @click="
                        modificaNotaModaleShow(
                          vendita.note,
                          vendita.id,
                          dettagliCliente.id
                        )
                      "
                    >
                      <img
                        v-b-modal.modal-genitore
                        width="20"
                        alt="EDIT"
                        src="../assets/edit.png"
                      />{{ vendita.note }}
                    </span>
                  </b-col>
                  <b-col>
                    <b-img
                      v-if="vendita.foto != ''"
                      :src="vendita.foto + '?' + $session.get('secret')"
                      alt="Responsive image"
                      img-top
                      class="img-vendite"
                    ></b-img>
                  </b-col>
                </b-row>
              </b-list-group>
            </b-list-group-item>
          </b-list-group>
        </b-tab>
      </b-tabs>
    </b-modal>
    <b-modal
      id="modal-modificaNotaModale"
      hide-footer
      title="Modifica Nota"
      size="xl"
    >
      <b-row>
        <b-col>
          <textarea
            placeholder="Inserisci una nota..."
            class="form-control"
            id="nota_edita"
            v-model="modificaNota.nota"
            rows="1"
          ></textarea>
        </b-col>
      </b-row>
      <p style="marigin-top: 1em; padding-top: 1em">
        <b-button type="button" variant="primary" @click="aggiornaNota()"
          >SALVA</b-button
        >
      </p>
    </b-modal>
  </b-container>
</template>

<script>
import axios from "axios";
import AddCliente from "../components/AddCliente.vue";
import AddVisita from "../components/AddVisita.vue";

export default {
  components: {
    AddCliente,
    AddVisita,
  },
  data() {
    return {
      clienti: [],
      visiteCliente: [],
      dettagliCliente: {
        id: 0,
        titoloCliente: "",
        cognome: "",
        nome: "",
        indirizzo: "",
        telefono: "",
        email: "",
        sconto: 0,
        tipologiaRichiesta: "",
        fasciaPrezzo: "",
        hobbies: "",
        dataNascita: null,
        note: "",
        attivo: 1,
        isAttivo: true,
        nomeCollegamento1: "",
        nomeCollegamento2: "",
        relazione1: "",
        relazione2: "",
        fasciaEta: "",
      },
      titoloCliente: "",
      showUploadingSpinner: false,
      showAlertSuccess: false,
      showAlertFail: false,
      isLoading: false,
      modificaNota: { nota: "", id: 0, idCliente: 0 },
      filtroPromemoria: "NO",
      isActiveTab: true,
    };
  },

  mounted() {
    this.updateClientiTable();
    if (this.$route.params.promemoria != undefined) {
      this.filtroPromemoria = this.$route.params.promemoria;
    }
  },
  watch: {
    $route() {
      if (this.$route.params.promemoria != undefined) {
        this.filtroPromemoria = this.$route.params.promemoria;
      } else {
        this.filtroPromemoria = "NO";
      }
    },
  },
  computed: {
    filtroPromemoriaArray: function () {
      let filtroP = this.filtroPromemoria;
      return this.clienti.filter(function (cliente) {
        if (filtroP == "PROMEMORIA") {
          if (cliente.tagAttivo == "1") return cliente;
        } else {
          return cliente;
        }
      });
    },
    tabClasses() {
      return {
        "active-tab": this.isActiveTab,
      };
    },
  },
  methods: {
    updateClientiTable() {
      this.isLoading = true;
      axios
        .get(
          this.$store.state.settings.URL_SERVER +
            "API/v1.php?clienti&secret=j4njwnk4543f4211ddwqc6j6jtvop002f"
        )
        .then((response) => {
          this.clienti = response.data.clienti;
          this.isLoading = false;
        })
        .catch((err) => {
          console.log(err);
        });
    },
    modificaCliente(row) {
      this.$refs.addClient.modificaCliente(row);
    },
    modificaNotaModaleShow(nota, id, idCliente) {
      this.modificaNota.nota = nota;
      this.modificaNota.id = id;
      this.modificaNota.idCliente = idCliente;

      this.$bvModal.show("modal-modificaNotaModale");
    },
    aggiornaNota() {
      this.isLoading = true;
      let formData = new FormData();
      formData.append("modificaNotaVendita", this.modificaNota.id);
      formData.append("nota", this.modificaNota.nota);

      axios
        .post(this.$store.state.settings.URL_SERVER + "API/v1.php", formData, {
          headers: {
            "Content-Type": "multipart/form-data",
          },
        })
        .then((response) => {
          console.log(response);
          this.modificaNota.nota = "";
          this.modificaNota.id = 0;

          this.getVisiteCliente(0);
          this.getVisiteCliente(this.modificaNota.idCliente);

          this.modificaNota.idCliente = 0;
          this.$bvModal.hide("modal-modificaNotaModale");
          this.isLoading = false;
        })
        .catch((err) => {
          this.isLoading = false;
          console.log(err);
          this.showUploadingSpinner = false;
          this.sendAlert("fail");
        });
    },
    eliminaCliente(id) {
      this.$confirm({
        message: `Sicuro di voler eliminare il cliente?`,
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
                  "API/v1.php?eliminaCliente&id=" +
                  id +
                  "&secret=" +
                  this.$session.get("secret")
              )
              .then((response) => {
                if (response.status === 200 && response.data.result == "OK") {
                  this.sendAlert("success");
                  this.updateClientiTable();
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
    nuovaVisita(row) {
      this.$refs.addVisita.showModal(row);
    },
    clearFormNuovoCliente() {
      this.$refs.addClient.clearFormNuovoCliente();
    },
    onSubmitNuovoCliente() {
      this.sendAlert("success");
      this.updateClientiTable();
    },
    onSubmitNuovaVisita() {
      this.sendAlert("success");
    },

    dettaglioCliente(payload) {
      let row = payload.data;
      this.dettagliCliente.titoloCliente =
        "Dettagli: " +
        row.cognome +
        " " +
        row.nome +
        "    | Ultima visita: " +
        this.$options.filters.dataITA(row.ultimaVisita);
      this.dettagliCliente.cognome = row.cognome;
      this.dettagliCliente.nome = row.nome;
      this.dettagliCliente.telefono = row.telefono;
      this.dettagliCliente.email = row.email;
      this.dettagliCliente.indirizzo = row.indirizzo;
      this.dettagliCliente.sconto = row.sconto;
      this.dettagliCliente.attivo = row.attivo;
      this.dettagliCliente.dataNascita = row.dataNascita;
      this.dettagliCliente.note = row.note;
      this.dettagliCliente.id = row.id;
      this.dettagliCliente.tipologiaRichiesta = row.tipologiaRichiesta;
      this.dettagliCliente.fasciaPrezzo = row.fasciaPrezzo;
      this.dettagliCliente.hobbies = row.hobbies;
      this.dettagliCliente.nomeCollegamento1 = row.nomeCollegamento1;
      this.dettagliCliente.nomeCollegamento2 = row.nomeCollegamento2;
      this.dettagliCliente.relazione1 = row.relazione1;
      this.dettagliCliente.relazione2 = row.relazione2;
      this.dettagliCliente.misuraAnello = row.misuraAnello;
      this.dettagliCliente.fasciaEta = row.fasciaEta;
      this.$bvModal.show("modal-dettagliCliente");
    },
    getVisiteCliente(id) {
      this.isLoading = true;
      axios
        .get(
          this.$store.state.settings.URL_SERVER +
            "API/v1.php?visiteCliente&id=" +
            id +
            "&secret=" +
            this.$session.get("secret")
        )
        .then((response) => {
          console.log(response);
          this.visiteCliente = response.data.visite;
          this.isLoading = false;
        })
        .catch((err) => {
          console.log(err);
        });
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
};
</script>

<style>
.table th,
.table td {
  text-align: left;
}

.table td img {
  margin-right: 4px;
}

.table-component__table-wrapper {
  margin-top: 10px;
}

.btn-outline-danger:hover {
  background-color: #dc3545 !important;
}

.btn-outline-success:hover {
  background-color: #28a745 !important;
}

.my-active-class {
  background-color: orange;
  /* Change this to the desired background color */
}

.storico-navbar {
  font-family: GFS Didot;
  justify-content: center !important;
}

.storico-navbar .navbar-brand:not(:last-child) {
  border-right: 2px gray solid;
  padding: 0 1rem 0 0;
}

.active-link {
  background-color: rgba(255, 143, 0, 255) !important;
  color: black !important;
}
</style>
