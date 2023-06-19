<template>
  <b-container>
    <loading
      :active.sync="isLoading"
      :can-cancel="true"
      :is-full-page="true"
    ></loading>
    <div>
      <b-row>
        <b-breadcrumb style="background-color: white">
          Ordina Per:
          <b-breadcrumb-item
            href="#"
            @click="ordinamento('titolo')"
            style="margin-left: 1em"
          >
            Titolo
            <b-icon
              v-if="ordina.per == 'titolo' && ordina.dir == 'asc'"
              icon="arrow-up"
            ></b-icon>
            <b-icon
              v-if="ordina.per == 'titolo' && ordina.dir == 'desc'"
              icon="arrow-down"
            ></b-icon>
          </b-breadcrumb-item>
          <b-breadcrumb-item href="#" @click="ordinamento('prezzo')">
            Prezzo
            <b-icon
              v-if="ordina.per == 'prezzo' && ordina.dir == 'asc'"
              icon="arrow-up"
            ></b-icon>
            <b-icon
              v-if="ordina.per == 'prezzo' && ordina.dir == 'desc'"
              icon="arrow-down"
            ></b-icon>
          </b-breadcrumb-item>
          <b-breadcrumb-item href="#" @click="ordinamento('ct')">
            Carati
            <b-icon
              v-if="ordina.per == 'ct' && ordina.dir == 'asc'"
              icon="arrow-up"
            ></b-icon>
            <b-icon
              v-if="ordina.per == 'ct' && ordina.dir == 'desc'"
              icon="arrow-down"
            ></b-icon>
          </b-breadcrumb-item>
        </b-breadcrumb>
        <b-col>
          <b-row
            v-if="filtroPietre"
            class="btn-group btn-group-toggle mr-1 ml-2 mt-1"
            data-toggle="buttons"
          >
            <label
              class="btn btn-outline-primary"
              v-bind:class="{ active: pietraZaffiro }"
            >
              <input
                type="radio"
                name="options_categoria2"
                id="ciondoli"
                autocomplete="off"
                @click="pietraZaffiro = !pietraZaffiro"
              />Zaffiro
            </label>
            <label
              class="btn btn-outline-primary"
              v-bind:class="{ active: pietraSmeraldo }"
            >
              <input
                type="radio"
                name="options_categoria2"
                id="orecchini"
                autocomplete="off"
                @click="pietraSmeraldo = !pietraSmeraldo"
              />Smeraldo
            </label>
            <label
              class="btn btn-outline-primary"
              v-bind:class="{ active: pietraAcquamarina }"
            >
              <input
                type="radio"
                name="options_categoria2"
                id="fedine"
                autocomplete="off"
                @click="pietraAcquamarina = !pietraAcquamarina"
              />Acquamarina
            </label>
            <label
              class="btn btn-outline-primary"
              v-bind:class="{ active: pietraRubino }"
            >
              <input
                type="radio"
                name="options_categoria2"
                id="fedine"
                autocomplete="off"
                @click="pietraRubino = !pietraRubino"
              />Rubino
            </label>
            <label
              class="btn btn-outline-primary"
              v-bind:class="{ active: pietraAltro }"
            >
              <input
                type="radio"
                name="options_categoria2"
                id="fedine"
                autocomplete="off"
                @click="pietraAltro = !pietraAltro"
              />Altro
            </label>
          </b-row>

          <b-row
            class="btn-group btn-group-toggle mr-1 ml-2 mt-1"
            data-toggle="buttons"
          >
            <label
              class="btn btn-outline-primary"
              v-bind:class="{ active: tipoTutto }"
            >
              <input
                type="radio"
                name="options_categoria2"
                id="tipoTutto"
                autocomplete="off"
                @click="filtroTipo1('tutto')"
              />Tutto
            </label>
            <label
              class="btn btn-outline-primary"
              v-bind:class="{ active: anelli }"
            >
              <input
                type="radio"
                name="options_categoria2"
                id="anelli"
                autocomplete="off"
                @click="filtroTipo1('anelli')"
              />Anelli
            </label>
            <label
              class="btn btn-outline-primary"
              v-bind:class="{ active: braccialetti }"
            >
              <input
                type="radio"
                name="options_categoria2"
                id="braccialetti"
                autocomplete="off"
                @click="filtroTipo1('braccialetti')"
              />Braccialetti
            </label>
            <label
              class="btn btn-outline-primary"
              v-bind:class="{ active: ciondoli }"
            >
              <input
                type="radio"
                name="options_categoria2"
                id="ciondoli"
                autocomplete="off"
                @click="filtroTipo1('ciondoli')"
              />Ciondoli
            </label>
            <label
              class="btn btn-outline-primary"
              v-bind:class="{ active: orecchini }"
            >
              <input
                type="radio"
                name="options_categoria2"
                id="orecchini"
                autocomplete="off"
                @click="filtroTipo1('orecchini')"
              />Orecchini
            </label>
            <label
              class="btn btn-outline-primary"
              v-bind:class="{ active: tipoAltro }"
            >
              <input
                type="radio"
                name="options_categoria2"
                id="tipoAltro"
                autocomplete="off"
                @click="filtroTipo1('tipoAltro')"
              />Altro
            </label>
          </b-row>
        </b-col>
      </b-row>
      <div class="row">
        <div
          v-bind:key="data.index"
          v-for="data in orderedProducts"
          :title="data.nome"
          @click="navigaDettaglioo(data.id)"
          class="col-md-3 col-sm-6 col-xs-6 col-6 mt-3"
        >
          <div class="card h-100">
            <div v-if="data.postazione != ''" class="postazione">
              {{ data.postazione | rimuoviVetrina }}
            </div>
            <div v-else class="NOpostazione">-</div>
            <img
              v-img
              :src="data.imgs[0] + '?' + $session.get('secret')"
              alt="Responsive image"
              img-top
              class="img-categorie2"
              @click.stop=""
            />

            <div class="mt-1 mb-1">
              <div>{{ data.titolo }}</div>
              <div>{{ data.descrizione | estrattoDescr }}</div>
              <div>{{ data.ct | toCT }}</div>
              <div>{{ data.prezzo | valuta }}</div>
            </div>
            <div v-bind:key="cat.index" v-for="cat in data.categorie">
              <b-icon
                v-if="cat.nomeCat == 'INVENTARIO'"
                style="position: absolute; bottom: 0.1em; left: 1em"
                icon="info"
                font-scale="1.5"
              ></b-icon>
            </div>
            <div v-bind:key="cat.index" v-for="cat in data.categorie">
              <b-icon
                v-if="cat.nomeCat == 'ORDINATI'"
                style="position: absolute; bottom: 0.1em; left: 1em"
                icon="truck"
                font-scale="1.5"
              ></b-icon>
            </div>
            <b-icon
              v-on:click.stop
              @click="editNotaProdotto(data.id)"
              style="position: absolute; bottom: 0.1em"
              icon="pencil-square"
              font-scale="1.5"
            ></b-icon>

            <b-icon
              v-if="!data.favorito"
              v-on:click.stop
              @click="addFavourite(data.id)"
              style="position: absolute; bottom: 0.1em; right: 0.4em"
              icon="star"
              font-scale="1.5"
            ></b-icon>
            <b-icon
              v-if="data.favorito"
              v-on:click.stop
              @click="removeFavourite(data.id)"
              style="position: absolute; bottom: 0.1em; right: 0.4em"
              variant="warning"
              icon="star-fill"
              font-scale="1.5"
            ></b-icon>
          </div>
        </div>
      </div>
    </div>

    <b-modal
      id="modal-notaProdotto"
      hide-footer
      :title="'Nota prodotto: ' + notaProdotto.titolo"
      size="xl"
      @close="clearFormNotaProdotto()"
    >
      <b-form @submit="onSubmitNotaProdotto">
        <b-container>
          <b-form-textarea
            id="textarea"
            v-model="notaProdotto.notePannello"
            placeholder="Inserisci la nota..."
            rows="3"
            max-rows="6"
          ></b-form-textarea>
          <b-button
            type="submit"
            style="float: right; margin-left: 2em; margin-top: 1em"
            variant="success"
            ><b-icon icon="plus"></b-icon>Salva e Chiudi</b-button
          >
        </b-container>
      </b-form>
    </b-modal>
  </b-container>
</template>

<script>
import axios from "axios";
import lodash from "lodash";
export default {
  data() {
    return {
      prodotti: [],
      listaFavoriti: [],
      isLoading: false,
      ordina: { per: "titolo", dir: "asc" },
      pietraZaffiro: true,
      pietraSmeraldo: true,
      pietraAcquamarina: true,
      pietraRubino: true,
      pietraAltro: true,
      filtroPietre: false,
      tipoTutto: true,
      anelli: false,
      braccialetti: false,
      ciondoli: false,
      orecchini: false,
      tipoAltro: false,
      notaProdotto: { titolo: "", id: 0, testo: "" },
    };
  },
  mounted() {
    axios
      .get(
        this.$store.state.settings.URL_SERVER +
          "API/v1.php?isCategoriaConFiltroPietre=" +
          this.$route.params.genitore
      )
      .then((response) => {
        console.log(this.response);

        this.filtroPietre = response.data.filtroPietre;
      })
      .catch((err) => {
        console.log(err);
      });

    this.aggiornaProdotti();
  },
  methods: {
    editNotaProdotto(id) {
      this.notaProdotto = this.prodotti.filter((prod) => prod.id == id)[0];
      this.$bvModal.show("modal-notaProdotto");
    },
    clearFormNotaProdotto() {},
    onSubmitNotaProdotto() {
      event.preventDefault();
      this.$set(this.notaProdotto, "azione", "aggiornaNotaProdotto");
      this.$set(this.notaProdotto, "secret", this.$session.get("secret"));

      axios
        .post(
          this.$store.state.settings.URL_SERVER + "API/v1.php",
          this.toFormData(this.notaProdotto),
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

            this.clearFormNotaProdotto();
            this.aggiornaProdotti();
            this.$bvModal.hide("modal-notaProdotto");
          } else {
            console.log(response);
            this.sendAlert("fail");
          }
        })
        .catch((err) => {
          console.log(err);
          this.sendAlert("fail");
        });
    },

    filtroTipo1(t) {
      this.anelli = false;
      this.orecchini = false;
      this.tipoTutto = false;
      this.ciondoli = false;
      this.braccialetti = false;
      this.tipoAltro = false;

      if (t == "tutto") {
        this.tipoTutto = true;
      }
      if (t == "anelli") {
        this.anelli = true;
      }
      if (t == "orecchini") {
        this.orecchini = true;
      }
      if (t == "braccialetti") {
        this.braccialetti = true;
      }
      if (t == "tipoAltro") {
        this.tipoAltro = true;
      }
      if (t == "ciondoli") {
        this.ciondoli = true;
      }
    },
    aggiornaProdotti() {
      this.isLoading = true;
      axios
        .get(
          this.$store.state.settings.URL_SERVER +
            "API/v1.php?prodotti&thumb=medium&condizione_categoria=" +
            this.$route.params.genitore +
            "&ordinaPer=" +
            this.ordina.per +
            "&ordinaDir=" +
            this.ordina.dir
        )
        .then((response) => {
          this.prodotti = response.data.prodotti;
          console.log(this.prodotti);
          this.favoriti();
          this.isLoading = false;
        })
        .catch((err) => {
          console.log(err);
        });
    },
    ordinamento(x) {
      if (x == this.ordina.per) {
        this.ordina.dir = this.ordina.dir == "asc" ? "desc" : "asc";
      } else {
        this.ordina.per = x;
        this.ordina.dir = "asc";
      }
    },
    navigaDettaglioo(id) {
      this.$router.push({
        name: "categorie",
        params: { livello: "4", genitore: id },
      });
    },
    favoriti() {
      this.isLoading = true;
      axios
        .get(this.$store.state.settings.URL_SERVER + "API/v1.php?favourites")
        .then((response) => {
          let myProd = [];

          this.prodotti.forEach(function (prodotto) {
            prodotto.favorito = false;
            response.data.favoriti.map(function (fav) {
              if (fav.idProdotto == prodotto.id) {
                prodotto.favorito = true;
              }
            });
            myProd.push(prodotto);
          });
          this.prodotti = myProd;
          this.isLoading = false;
        })
        .catch((err) => {
          console.log(err);
        });
    },
    addFavourite(id) {
      axios
        .get(
          this.$store.state.settings.URL_SERVER +
            "API/v1.php?addFavourite&id=" +
            id
        )
        .then((response) => {
          console.log(response);
          this.favoriti();
        })
        .catch((err) => {
          console.log(err);
        });
    },
    removeFavourite(id) {
      axios
        .get(
          this.$store.state.settings.URL_SERVER +
            "API/v1.php?removeFavourite&id=" +
            id
        )
        .then((response) => {
          console.log(response);
          this.favoriti();
        })
        .catch((err) => {
          console.log(err);
        });
    },
    toFormData: function (obj) {
      let formData = new FormData();
      for (let key in obj) {
        formData.append(key, obj[key]);
      }
      return formData;
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
  computed: {
    orderedProducts: function () {
      let myOrd = this.ordina;

      let myZaffiro = this.pietraZaffiro;
      let mySmeraldo = this.pietraSmeraldo;
      let myAcquaM = this.pietraAcquamarina;
      let myRubino = this.pietraRubino;
      let myAltro = this.pietraAltro;

      let myAnelli = this.anelli;
      let myBraccialetti = this.braccialetti;
      let myCiondoli = this.ciondoli;
      let myOrecchini = this.orecchini;
      let myTipoAltro = this.tipoAltro;
      let myTipoTutto = this.tipoTutto;
      let ordinatiProdotti = lodash.orderBy(
        this.prodotti,
        [
          "catOrdinamento",
          "ordinamentoCharTitolo",
          function (o) {
            if (myOrd.per == "ct") {
              return new Number(o.ct);
            }
            if (myOrd.per == "titolo") {
              return new Number(o.titolo);
            }

            return new Number(o.prezzo);
          },
        ],
        ["desc", "asc", this.ordina.dir]
      );

      if (this.filtroPietre) {
        return ordinatiProdotti.filter(function (diamante) {
          let returnDiamante = false;

          if (myZaffiro) {
            if (diamante.descrizione.indexOf("Z.") != -1) {
              returnDiamante = true;
            }
          }
          if (mySmeraldo) {
            if (diamante.descrizione.indexOf("S.") != -1) {
              returnDiamante = true;
            }
          }
          if (myAcquaM) {
            if (diamante.descrizione.indexOf("H2O") != -1) {
              returnDiamante = true;
            }
          }
          if (myRubino) {
            if (diamante.descrizione.indexOf(" R.") != -1) {
              returnDiamante = true;
            }
          }
          if (
            myAltro &&
            diamante.descrizione.indexOf("Z.") == -1 &&
            diamante.descrizione.indexOf("S.") == -1 &&
            diamante.descrizione.indexOf("H2O") == -1 &&
            diamante.descrizione.indexOf(" R.") == -1
          ) {
            returnDiamante = true;
          }
          return returnDiamante;
        });
      }

      return ordinatiProdotti.filter(function (diamante) {
        let returnDiamante = false;
        if (myTipoTutto) {
          returnDiamante = true;
        }

        if (myAnelli) {
          if (diamante.tipoProdotto == "ANELLI") {
            returnDiamante = true;
          }
        }
        if (myBraccialetti) {
          if (diamante.tipoProdotto == "BRACCIALETTI") {
            returnDiamante = true;
          }
        }
        if (myCiondoli) {
          if (diamante.tipoProdotto == "CIONDOLI") {
            returnDiamante = true;
          }
        }
        if (myOrecchini) {
          if (diamante.tipoProdotto == "ORECCHINI") {
            returnDiamante = true;
          }
        }
        if (
          myTipoAltro &&
          diamante.tipoProdotto != "ANELLI" &&
          diamante.tipoProdotto != "BRACCIALETTI" &&
          diamante.tipoProdotto != "CIONDOLI" &&
          diamante.tipoProdotto != "ORECCHINI"
        ) {
          returnDiamante = true;
        }
        return returnDiamante;
      });
    },
  },
  filters: {
    estrattoDescr: function (value) {
      if (value.length > 30) {
        return value.slice(0, 30) + "..";
      }
      return value;
    },
  },
};
</script>
