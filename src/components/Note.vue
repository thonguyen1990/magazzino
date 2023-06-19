<template>
  <b-container>
    <loading
      :active.sync="isLoading"
      :can-cancel="true"
      :is-full-page="true"
    ></loading>

    <b-row>
      <b-col>
        <div class="mx-auto mb-3 mt-1">
          <b-row>
            <b-col>
              <b-alert
                v-if="showAlertSuccess"
                variant="success"
                show
                class="alertFixed"
                >Completato!</b-alert
              >
              <b-alert
                v-if="showAlertFail"
                variant="warning"
                show
                class="alertFixed"
                >Errore!</b-alert
              >
            </b-col>
          </b-row>
          <b-row>
            <b-col
              ><b-form-input
                id="serach-nota"
                v-model="searchNota"
                type="text"
                placeholder="Cerca tra le note"
              ></b-form-input
            ></b-col>
            <b-col
              ><b-button
                v-if="currentCat > 0"
                v-b-modal.modal-nuovoPost
                style="float: left; margin-left: 0em; margin-bottom: 1em"
                variant="success"
                @click="clearFormNota()"
                ><b-icon icon="plus"></b-icon>NOTA</b-button
              ></b-col
            >
            <b-col
              ><b-button
                style="float: right; margin-left: 2em; margin-bottom: 1em"
                variant="success"
                @click="nuovaCategoria()"
                ><b-icon icon="plus"></b-icon>CATEGORIA</b-button
              ></b-col
            >
            <b-col
              ><b-button
                style="float: right; margin-left: 1em; margin-bottom: 1em"
                variant="danger"
                @click="eliminaCategoria()"
                ><b-icon icon="trash"></b-icon>CATEGORIA</b-button
              ></b-col
            >
          </b-row>
        </div>
      </b-col>
    </b-row>
    <div class="row">
      <div>
        <b-tabs content-class="mt-3" active-nav-item-class="active-link">
          <b-tab
            v-bind:key="cat.index"
            v-for="cat in categorie"
            :title="cat.nome + ' (' + cat.n + ')'"
            @click="currentCat = cat.id"
          >
            <b-card-group columns>
              <Nota
                v-bind:key="mynota.index"
                v-for="mynota in filteredNote"
                @showNota="updateShowNota"
                @modificaNota="updateModificaNota"
                @eliminaNota="updateEliminaNota"
                v-bind:myNota="mynota"
              />
            </b-card-group>
          </b-tab>
        </b-tabs>
      </div>
    </div>

    <b-modal
      id="modal-nuovoPost"
      hide-footer
      title="Nuova Nota"
      size="xl"
      @close="clearFormNota()"
    >
      <b-form @submit="onSubmitNota">
        <b-container>
          <b-form-group label="Titolo:" label-for="input-cognome">
            <b-row>
              <b-col cols="8"
                ><b-form-input
                  id="titolo"
                  v-model="nota.titolo"
                  type="text"
                ></b-form-input
              ></b-col>

              <b-col
                ><model-select
                  required
                  class="form-control"
                  :options="optionsCategorie"
                  v-model="nota.categoria"
                  placeholder="Seleziona la categoria"
                ></model-select
              ></b-col>
            </b-row>
          </b-form-group>

          <b-form-textarea
            id="textarea"
            v-model="nota.testo"
            placeholder="Inserisci la nota..."
            rows="3"
            max-rows="6"
          ></b-form-textarea>
          <b-row>
            <b-col>
              <b-form-checkbox
                style="margin-bottom: 3em; float: ledt"
                v-model="nota.isNotifica"
                name="input-notifica"
                id="input-notifica"
                switch
              >
                Notifica:
                <b>
                  <span v-if="nota.isNotifica == true">SI</span>
                  <span v-else>NO</span>
                </b>
              </b-form-checkbox>
            </b-col>
            <b-col>
              <b-form-checkbox
                style="margin-bottom: 3em; float: right"
                v-model="nota.isLetta"
                name="input-letta"
                id="input-letta"
                switch
              >
                Letta:
                <b>
                  <span v-if="nota.isLetta == true">SI</span>
                  <span v-else>NO</span>
                </b>
              </b-form-checkbox>
            </b-col>
          </b-row>

          <b-container>
            <p v-bind:key="img.index" v-for="img in nota.imgs">
              <b-img
                :src="img.src + '?' + $session.get('secret')"
                :alt="img"
                width="100"
              ></b-img>
              <img
                class="azione"
                width="20"
                alt="Vue logo"
                @click="deleteFile(img.id, nota.id)"
                src="../assets/del.png"
              />
            </p>
          </b-container>

          <div
            v-if="nota.id > 0"
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
              <li v-bind:key="filex.index" v-for="filex in files">
                {{ filex.name }} ({{ filex.size | bTokb }} kb)
                <img
                  class="azione"
                  width="20"
                  alt="X"
                  @click="removeFile(filex)"
                  src="../assets/del.png"
                />
              </li>
            </ul>
          </div>
          <br />
          <div v-if="showUploadingSpinner">
            <b-spinner label="Loading..."></b-spinner>
          </div>
          <b-button v-on:click="submitFileImage()">Carica File</b-button>
          <b-button
            type="button"
            style="float: right; margin-left: 2em; margin-top: 1em"
            variant="success"
            @click="salvaNota()"
            ><b-icon icon="plus"></b-icon>Salva</b-button
          >
          <b-button
            type="submit"
            style="float: right; margin-left: 2em; margin-top: 1em"
            variant="success"
            ><b-icon icon="plus"></b-icon>Salva e Chiudi</b-button
          >
        </b-container>
      </b-form>
    </b-modal>

    <b-modal
      id="modal-showPost"
      hide-footer
      no-close-on-backdrop
      :title="nota.titolo"
      size="xl"
      @close="clearFormNota()"
    >
      <b-container>
        {{ nota.testo }}
        <b-row>
          <b-col v-bind:key="img.index" v-for="img in nota.imgs">
            <b-img
              :src="img.src + '?' + $session.get('secret')"
              :alt="img"
              fluid
              @click="zoom(img.src)"
            ></b-img>
          </b-col>
        </b-row>
      </b-container>
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
  </b-container>
</template>

<script>
import axios from "axios";
import Nota from "../components/Note_singoloPost.vue";
import { ModelSelect } from "vue-search-select";

export default {
  components: {
    Nota,
    ModelSelect,
  },
  data() {
    return {
      nota: {
        id: 0,
        titolo: "t1",
        testo: "test1",
        dataOra: "19/1/1111 22:22",
        categoria: 0,
        letta: 0,
        isLetta: false,
        notifica: 0,
        isNotifica: false,
      },
      note: [],
      files: [],
      optionsCategorie: [],
      categorie: [],
      currentCat: 0,
      selectedImage: null,
      showUploadingSpinner: false,
      showAlertSuccess: false,
      showAlertFail: false,
      isLoading: false,
      searchNota: "",
      filteredNote: [],
      optionsNotifica: [
        { value: 0, text: "NO" },
        { value: 1, text: "Stessi giorno" },
        { value: 2, text: "1 Giorno prima" },
        { value: 3, text: "2 Giorni prima" },
        { value: 4, text: "3 Giorni prima" },
        { value: 5, text: "4 Giorni prima" },
        { value: 6, text: "5 Giorni prima" },
        { value: 7, text: "6 Giorni prima" },
        { value: 8, text: "7 Giorni prima" },
      ],
    };
  },

  mounted() {
    this.getCategorie();
    this.updateListaNote(0, this.currentCat);
  },
  methods: {
    getCategorie(cat = 0) {
      axios
        .get(
          this.$store.state.settings.URL_SERVER +
            "API/v1.php?listaCategorieNote&searchNota=" +
            this.searchNota +
            "&secret=" +
            this.$session.get("secret")
        )
        .then((response) => {
          console.log(response);
          if (response.status === 200 && response.data.stato == "OK") {
            let lista = [];
            this.categorie = response.data.categorie;
            response.data.categorie.map(function (value) {
              lista.push({ value: value.id, text: value.nome });
            });
            this.currentCat = cat == 0 ? this.categorie[0].id : cat;
            this.optionsCategorie = lista;
          } else {
            console.log("no 200 / ok");
            this.sendAlert("fail");
          }
        })
        .catch((err) => {
          console.log(err);
          this.sendAlert("fail");
        });
    },
    eliminaCategoria() {
      let nCar = this.categorie.filter((item) => {
        return item.id == this.currentCat;
      });

      this.$confirm({
        message:
          'Sicuro di voler eliminare la categoria: "' +
          nCar[0].nome +
          '" - TUTTE LE NOTE DELLA CATEGORIA VERRANNO ELIMINATE?',
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
            axios
              .get(
                this.$store.state.settings.URL_SERVER +
                  "API/v1.php?eliminaCategoriaNote=" +
                  this.currentCat
              )
              .then((response) => {
                console.log(response);
                if (response.status === 200 && response.data.stato == "OK") {
                  this.sendAlert("success");
                  this.updateListaNote(0, this.currentCat);

                  this.getCategorie();
                } else {
                  this.sendAlert("fail");
                }
              })
              .catch((err) => {
                this.sendAlert("fail");
                console.log(err);
              });
          }
        },
      });
    },
    nuovaCategoria() {
      var cat = prompt("Come vuoi chiamare la nuova categoria");
      if (cat != null) {
        this.isLoading = true;
        axios
          .get(
            this.$store.state.settings.URL_SERVER +
              "API/v1.php?nuovaCategoriaNote=" +
              cat +
              "&secret=" +
              this.$session.get("secret")
          )
          .then((response) => {
            console.log(response);
            if (response.status === 200 && response.data.stato == "OK") {
              this.sendAlert("success");
              this.getCategorie();
              this.updateListaNote(0, this.currentCat);
            } else {
              this.sendAlert("fail");
            }
            this.isLoading = false;
          })
          .catch((err) => {
            console.log(err);
            this.sendAlert("fail");
            this.isLoading = false;
          });
      }
    },
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
    submitFileImage() {
      this.showUploadingSpinner = true;
      let formData = new FormData();
      formData.append("fileImageNote", this.fileImage);
      formData.append("idNota", this.nota.id);

      this.files.forEach((f, x) => {
        formData.append("fileImageNote" + (x + 1), f);
      });

      axios
        .post(this.$store.state.settings.URL_SERVER + "API/v1.php", formData, {
          headers: {
            "Content-Type": "multipart/form-data",
          },
        })
        .then((response) => {
          this.showUploadingSpinner = false;
          this.files = [];

          this.updateListaNote(this.nota.id, this.currentCat);
        })
        .catch((err) => {
          alert("3");
          console.log(err);
          this.showUploadingSpinner = false;
          this.sendAlert("fail");
        });
    },
    removeFile(file) {
      this.files = this.files.filter((f) => {
        return f != file;
      });
    },
    deleteFile(id, idNota) {
      axios
        .get(
          this.$store.state.settings.URL_SERVER + "API/v1.php?deleteFile=" + id
        )
        .then(() => {
          console.log("deleted");
          this.updateListaNote(idNota, this.currentCat);
        })
        .catch((err) => {
          console.log(err);
        });
    },
    updateListaNote(reload = 0, cat = 0) {
      this.isLoading = true;
      axios
        .get(
          this.$store.state.settings.URL_SERVER +
            "API/v1.php?note&cat=" +
            cat +
            "&secret=" +
            this.$session.get("secret")
        )
        .then((response) => {
          this.note = response.data.note;
          if (reload > 0) {
            this.nota = this.note.find(({ id }) => id == reload);
          }
          console.log(response);
          this.isLoading = false;
          this.filtraNote(this.searchNota);
        })
        .catch((err) => {
          console.log(err);
          this.isLoading = false;
        });
    },
    updateModificaNota(mn) {
      this.nota.imgs = mn.imgs;
      this.nota.id = mn.id;
      this.nota.categoria = mn.categoria;
      this.nota.titolo = mn.titolo;
      this.nota.testo = mn.testo;
      if (mn.notifica == 1) {
        this.nota.isNotifica = true;
      } else {
        this.nota.isNotifica = false;
      }
      if (mn.letta == 1) {
        this.nota.isLetta = true;
      } else {
        this.nota.isLetta = false;
      }
      this.$bvModal.show("modal-nuovoPost");
    },
    updateShowNota(mn) {
      this.nota.imgs = mn.imgs;
      this.nota.id = mn.id;
      this.nota.categoria = mn.categoria;
      this.nota.titolo = mn.titolo;
      this.nota.testo = mn.testo;
      if (mn.notifica == 1) {
        this.nota.isNotifica = true;
      } else {
        this.nota.isNotifica = false;
      }
      if (mn.letta == 1) {
        this.nota.isLetta = true;
      } else {
        this.nota.isLetta = false;
      }
      this.$bvModal.show("modal-showPost");
    },

    updateEliminaNota(id) {
      this.isLoading = true;
      axios
        .get(
          this.$store.state.settings.URL_SERVER +
            "API/v1.php?eliminaNota&id=" +
            id +
            "&secret=" +
            this.$session.get("secret")
        )
        .then((response) => {
          console.log(response);
          if (response.status === 200 && response.data.result == "OK") {
            this.sendAlert("success");
            this.updateListaNote(0, this.currentCat);
          } else {
            this.sendAlert("success");
          }
          this.isLoading = false;
        })
        .catch((err) => {
          console.log(err);
          this.sendAlert("fail");
          this.isLoading = false;
        });
    },
    salvaNota() {
      if (this.nota.categoria == 0) {
        alert("seleziona la categoria");
        return;
      }
      this.isLoading = true;
      this.$set(this.nota, "azione", "nuovaNota");
      this.$set(this.nota, "secret", this.$session.get("secret"));
      console.log(this.nota);
      axios
        .post(
          this.$store.state.settings.URL_SERVER + "API/v1.php",
          this.toFormData(this.nota),
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
            this.nota.id = response.data.id;
            this.currentCat = this.nota.categoria;
            this.getCategorie(this.currentCat);
            this.updateListaNote(0, this.currentCat);
          } else {
            this.sendAlert("fail");
          }
          this.isLoading = false;
        })
        .catch((err) => {
          console.log(err);
          this.sendAlert("fail");
          this.isLoading = false;
        });
    },
    onSubmitNota() {
      if (this.nota.categoria == 0) {
        alert("seleziona la categoria");
        return;
      }
      this.isLoading = true;
      event.preventDefault();
      this.$set(this.nota, "azione", "nuovaNota");
      this.$set(this.nota, "secret", this.$session.get("secret"));

      axios
        .post(
          this.$store.state.settings.URL_SERVER + "API/v1.php",
          this.toFormData(this.nota),
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
            this.getCategorie(this.currentCat);
            this.updateListaNote(0, this.currentCat);
            this.clearFormNota();
          } else {
            this.sendAlert("fail");
          }
          this.isLoading = false;
        })
        .catch((err) => {
          console.log(err);
          this.sendAlert("fail");
          this.isLoading = false;
        });
      this.$bvModal.hide("modal-nuovoPost");
    },
    clearFormNota() {
      this.updateListaNote(0, this.currentCat);

      this.nota.id = 0;
      this.nota.titolo = "";
      this.nota.categoria = 0;
      this.nota.testo = "";
      this.nota.imgs = null;
      this.sfiles = [];
      this.nota.notifica = 0;
      this.nota.isNotifica = false;
      this.nota.letta = 0;
      this.nota.isLetta = false;
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
    filtraNote(val) {
      this.getCategorie(this.currentCat);
      this.filteredNote = this.note.filter(function (n) {
        if (n.testo.includes(val) || n.titolo.includes(val)) {
          return n;
        }
      });
    },
  },
  watch: {
    currentCat: function (val) {
      console.log("ricerco cat " + val);
      this.updateListaNote(0, val);
    },
    searchNota: function (val) {
      this.filtraNote(val);
    },
  },
  computed: {},
};
</script>
