<template>
  <b-container>
    <loading
      :active.sync="isLoading"
      :can-cancel="true"
      :is-full-page="true"
    ></loading>
    <b-row>
      <b-col>
        <b-breadcrumb style="background-color: white">
          Ordina:
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
      </b-col>
    </b-row>
    <b-row>
      <b-col>
        <b-form-radio-group
          class="mr-1 ml-2 mt-1 trovati-nav"
          id="filtro-disponibilita"
          v-model="filtroDisponibilita"
          :options="[
            { text: 'TUTTO', value: 'TUTTO' },
            { text: 'A MAGAZZINO', value: 'MAGAZZINO' },
            { text: 'NON DISPONIBILI', value: 'NONDISPONIBILI' },
          ]"
          button-variant="outline-primary"
          name="filtro-disponibilita"
          buttons
        ></b-form-radio-group>
      </b-col>
    </b-row>
    <b-row>
      <b-col>
        <b-row
          class="btn-group btn-group-toggle mr-1 ml-2 mt-1 trovati-list"
          data-toggle="buttons"
        >
          <label
            class="btn btn-outline-primary trovati-list-label"
            v-bind:class="{ active: tipoTutto }"
          >
            <input
              type="radio"
              name="options_categoria2"
              id="tipoTutto"
              autocomplete="off"
              @click="filtroTipo1('tutto')"
            />TUTTO
          </label>
          <label
            class="btn btn-outline-primary trovati-list-label"
            v-bind:class="{ active: anelli }"
          >
            <input
              type="radio"
              name="options_categoria2"
              id="anelli"
              autocomplete="off"
              @click="filtroTipo1('anelli')"
            />ANELLI
          </label>
          <label
            class="btn btn-outline-primary trovati-list-label"
            v-bind:class="{ active: braccialetti }"
          >
            <input
              type="radio"
              name="options_categoria2"
              id="braccialetti"
              autocomplete="off"
              @click="filtroTipo1('braccialetti')"
            />BRACCIALETTI
          </label>
          <label
            class="btn btn-outline-primary trovati-list-label"
            v-bind:class="{ active: ciondoli }"
          >
            <input
              type="radio"
              name="options_categoria2"
              id="ciondoli"
              autocomplete="off"
              @click="filtroTipo1('ciondoli')"
            />CIONDOLI
          </label>
          <label
            class="btn btn-outline-primary trovati-list-label"
            v-bind:class="{ active: orecchini }"
          >
            <input
              type="radio"
              name="options_categoria2"
              id="orecchini"
              autocomplete="off"
              @click="filtroTipo1('orecchini')"
            />ORECCHINI
          </label>
          <label
            class="btn btn-outline-primary trovati-list-label"
            v-bind:class="{ active: tipoAltro }"
          >
            <input
              type="radio"
              name="options_categoria2"
              id="tipoAltro"
              autocomplete="off"
              @click="filtroTipo1('tipoAltro')"
            />ALTRO
          </label>
        </b-row>
      </b-col>
    </b-row>
    <div class="row">
      <div
        v-bind:key="data.index"
        v-for="data in orderedProducts"
        :title="data.titolo"
        class="col-md-3 col-sm-6 col-xs-6 col-6 mt-3"
        @click="navigaDettaglioo(data.id)"
      >
        <div class="card h-100">
          <div v-if="data.postazione != ''" class="postazione">
            {{ data.postazione }}
          </div>
          <div v-else class="NOpostazione">-</div>
          <b-img
            v-if="data.imgs[0] == null"
            :src="imagePlace"
            alt="Responsive image1"
            img-top
            class="img-categorie2"
          ></b-img>
          <img
            v-else
            v-img
            :src="data.imgs[0] + '?' + $session.get('secret')"
            alt="Responsive image2"
            img-top
            class="img-categorie2"
            @click.stop=""
          />

          <div class="mt-1 mb-1">
            <div>{{ data.titolo }}</div>
            <div>{{ data | showdescrizione(cat_mostrare_desc) }}</div>
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
            @click="editNotaProd(data.id)"
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

    <NotaProdotto
      ref="notaProd"
      @aggiornaProdotti="updateProductTable()"
    ></NotaProdotto>
  </b-container>
</template>

<script>
import axios from "axios";
import lodash from "lodash";
import NotaProdotto from "../components/NotaProdotto.vue";

export default {
  components: {
    NotaProdotto,
  },
  data() {
    return {
      prodotti: [],
      listaFavoriti: [],
      cat_mostrare_desc: [],
      cerca: "",
      fasciaPrezzo: 0,
      carDa: 0,
      carA: 0,
      inDebug: false,
      imagePlace: require("@/assets/daverio.jpg"),
      isLoading: false,
      anelli: false,
      braccialetti: false,
      ciondoli: false,
      orecchini: false,
      tipoAltro: false,
      tipoTutto: true,
      filtroTipoClassici: "tutto",
      filtroTipoTipo: "tutto",
      filtroTipoMateriale: "tutto",
      filtroDisponibilita: "TUTTO",
      ordina: { per: "", dir: "asc" },
    };
  },

  mounted() {
    this.categorieDaMostrare();
  },
  methods: {
    editNotaProd(id) {
      this.$refs.notaProd.editNotaProdotto(id, this.prodotti);
    },
    ordinamento(x) {
      if (x == this.ordina.per) {
        if (this.ordina.dir == "asc") this.ordina.dir = "desc";
        else if (this.ordina.dir == "desc") this.ordina.per = "";
      } else {
        this.ordina.per = x;
        this.ordina.dir = "asc";
      }
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
    categorieDaMostrare() {
      axios.get("./settings.json").then((response) => {
        this.cat_mostrare_desc = response.data.CAT_MOSTRA_DESCR;
        this.inDebug = response.data.DEBUG;
        this.updateProductTable();
      });
    },
    updateProductTable() {
      this.isLoading = true;

      this.cerca = this.$route.params.txt;
      this.fasciap1 = this.$route.params.fasciap1;
      this.fasciap2 = this.$route.params.fasciap2;
      this.fasciact1 = this.$route.params.fasciact1;
      this.fasciact2 = this.$route.params.fasciact2;
      this.filtroTipoClassici = this.$route.params.filtroTipoClassici;
      this.filtroTipoTipo = this.$route.params.filtroTipoTipo;
      this.filtroTipoMateriale = this.$route.params.filtroTipoMateriale;
      this.catAttuale = this.$route.params.catAttuale;

      this.classiciTutto = false;
      this.classici = false;
      this.classiciColorati = false;
      switch (this.filtroTipoClassici) {
        case "C":
          this.classici = true;
          break;
        case "CC":
          this.classiciColorati = true;
          break;
        default:
          this.classiciTutto = true;
      }
      this.anelli = false;
      this.braccialetti = false;
      this.ciondoli = false;
      this.orecchini = false;
      this.tipoTutto = false;
      switch (this.filtroTipoTipo) {
        case "anelli":
          this.anelli = true;
          break;
        case "braccialetti":
          this.braccialetti = true;
          break;
        case "ciondoli":
          this.ciondoli = true;
          break;
        case "orecchini":
          this.orecchini = true;
          break;
        default:
          this.tipoTutto = true;
      }
      this.oroBianco = false;
      this.oroRosa = false;
      this.oroTutto = false;
      switch (this.filtroTipoMateriale) {
        case "OB":
          this.oroBianco = true;
          break;
        case "OR":
          this.oroRosa = true;
          break;
        default:
          this.oroTutto = true;
      }
      if (this.inDebug == true) {
        alert(
          this.$store.state.settings.URL_SERVER +
            "API/v1.php?cerca=" +
            this.cerca +
            "&fasciap1=" +
            this.fasciap1 +
            "&fasciap2=" +
            this.fasciap2 +
            "&fasciact1=" +
            this.fasciact1 +
            "&fasciact2=" +
            this.fasciact2 +
            "&classici=" +
            this.classici +
            "&classiciColorati=" +
            this.classiciColorati +
            "&anelli=" +
            this.anelli +
            "&braccialetti=" +
            this.braccialetti +
            "&ciondoli=" +
            this.ciondoli +
            "&orecchini=" +
            this.orecchini +
            "&oroRosa=" +
            this.oroRosa +
            "&oroBianco=" +
            this.oroBianco
        );
      }
      axios
        .get(
          this.$store.state.settings.URL_SERVER +
            "API/v1.php?thumb=medium&cerca=" +
            this.cerca +
            "&fasciap1=" +
            this.fasciap1 +
            "&fasciap2=" +
            this.fasciap2 +
            "&fasciact1=" +
            this.fasciact1 +
            "&fasciact2=" +
            this.fasciact2 +
            "&classici=" +
            this.classici +
            "&classiciColorati=" +
            this.classiciColorati +
            "&anelli=" +
            this.anelli +
            "&braccialetti=" +
            this.braccialetti +
            "&ciondoli=" +
            this.ciondoli +
            "&orecchini=" +
            this.orecchini +
            "&oroRosa=" +
            this.oroRosa +
            "&oroBianco=" +
            this.oroBianco +
            "&catAttuale=" +
            this.catAttuale
        )
        .then((response) => {
          this.prodotti = response.data.prodotti;
          this.favoriti();
          this.isLoading = false;
        })
        .catch((err) => {
          console.log(err);
          console.log("2");
        });
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
          this.favoriti();
        })
        .catch((err) => {
          console.log(err);
        });
    },
  },
  watch: {
    "$route.params"() {
      // call the method which loads your initial state
      this.updateProductTable();
    },
  },
  computed: {
    orderedProducts: function () {
      let fDisp = this.filtroDisponibilita;

      let myOrd = this.ordina;

      let myAnelli = this.anelli;
      let myBraccialetti = this.braccialetti;
      let myCiondoli = this.ciondoli;
      let myOrecchini = this.orecchini;
      let myTipoAltro = this.tipoAltro;
      let myTipoTutto = this.tipoTutto;
      let ordinatiProdotti = lodash.orderBy(
        this.prodotti,
        [
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
        ["asc", this.ordina.dir]
      );

      if (myOrd.per == "")
        ordinatiProdotti = lodash.orderBy(
          this.prodotti,
          [
            "catPrincipale",
            "ordinamentoCharTitolo",
            function (o) {
              return new Number(o.prezzo);
            },
          ],
          ["desc", "asc", "asc"]
        );
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

        if (returnDiamante) {
          if (fDisp === "TUTTO") {
            return returnDiamante;
          } else if (fDisp === "MAGAZZINO") {
            if (diamante.disponibile == true) {
              return returnDiamante;
            }
          } else {
            if (diamante.disponibile == false) {
              return returnDiamante;
            }
          }
        }
      });
    },
  },
  filters: {
    showdescrizione(value, cmd) {
      let categoriaOk = false;

      cmd.forEach(function (item) {
        value.categorie.map(function (value) {
          if (value.nome == item) {
            categoriaOk = true;
          }
        });
      });

      if (!categoriaOk) return "";

      return value.descrizione;
    },
  },
};
</script>

<style>
.trovati-list .trovati-list-label {
  width: 11rem;
}

.trovati-nav > label {
  width: 11rem;
}
</style>
