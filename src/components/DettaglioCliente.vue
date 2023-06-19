<template>
  <div>
    <b-modal
      id="modal-dettagliCliente"
      hide-footer
      :title="dettagliCliente.titoloCliente"
      size="xl"
    >
      <b-tabs content-class="mt-3" active-nav-item-class="active-link">
        <b-tab title="Info Cliente" active>
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
          title="Storico visite"
          @click="getVisiteCliente(dettagliCliente.id)"
        >
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
  </div>
</template>

<script>
import axios from "axios";

export default {
  components: {},
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
    };
  },

  mounted() {},
  watch: {},
  computed: {},
  methods: {
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

    clearFormNuovoCliente() {
      this.$refs.addClient.clearFormNuovoCliente();
    },

    dettaglioCliente(row) {
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
