<template>
  <div style="height: 90vh" :style="backgroundLogo">
    <b-container fluid>
      <loading
        :active.sync="isLoading"
        :can-cancel="true"
        :is-full-page="true"
      ></loading>

      <div id="divPrincipale">
        <b-row>
          <b-col>
            <h2>
              <div class="txDettaglioTitolo" style="margin-top: 0.4em">
                {{ prodotti[0].postazione }}
              </div>
            </h2>
          </b-col>
        </b-row>

        <b-row style="">
          <b-col cols="5">
            <lingallery
              :responsive="true"
              :items="images.large_size"
              :addons="{ enableLargeView: true }"
            />

            <b-icon
              v-if="!isFavourite"
              @click="addFavourite()"
              style="float: right"
              icon="star"
              font-scale="2"
            ></b-icon>
            <b-icon
              v-if="isFavourite"
              @click="removeFavourite()"
              style="float: right"
              icon="star-fill"
              variant="warning"
              font-scale="2"
            ></b-icon>
          </b-col>
          <b-col style="">
            <b-row>
              <b-col>
                <div
                  @click="isVisibile.dettagli = !isVisibile.dettagli"
                  class="titoliSezioniPagProd"
                  style="margin-top: 1.9em"
                >
                  DETTAGLI
                  <b-icon
                    v-if="!isVisibile.dettagli"
                    icon="chevron-right"
                    style="margin-left: 0.5em"
                  ></b-icon>
                  <b-icon
                    v-else
                    icon="chevron-down"
                    style="margin-left: 0.5em"
                  ></b-icon>
                </div>
                <b-collapse :visible="isVisibile.dettagli">
                  <div>
                    <div class="col d-flex justify-content-center">
                      <div class="mt-auto mb-auto">
                        <h2>
                          <div class="txDettaglioTitolo">
                            {{ prodotti[0].titolo }}
                          </div>
                        </h2>
                        <br />
                        <div class="txDettaglioDescrizione">
                          {{ prodotti[0].descrizione }}
                        </div>

                        <div class="txDettaglioPrezzo">
                          {{ prodotti[0].prezzo | valuta }}
                        </div>
                      </div>
                    </div>
                  </div>
                </b-collapse>
              </b-col>
            </b-row>
            <b-row>
              <b-col>
                <div
                  @click="isVisibile.descrizione = !isVisibile.descrizione"
                  class="titoliSezioniPagProd"
                >
                  DESCRIZIONE
                  <b-icon
                    v-if="!isVisibile.descrizione"
                    icon="chevron-right"
                    style="margin-left: 0.5em"
                  ></b-icon>
                  <b-icon
                    v-else
                    icon="chevron-down"
                    style="margin-left: 0.5em"
                  ></b-icon>
                </div>
                <b-collapse :visible="isVisibile.descrizione">
                  <div>
                    <div class="col d-flex justify-content-center">
                      <div class="mt-auto mb-auto">
                        <div class="txDettaglioTitolo">
                          {{ prodotti[0].descrizione2 }}
                        </div>
                      </div>
                    </div>
                  </div>
                </b-collapse>
              </b-col>
            </b-row>
            <b-row>
              <b-col>
                <div
                  @click="isVisibile.collezione = !isVisibile.collezione"
                  class="titoliSezioniPagProd"
                >
                  LA COLLEZIONE
                  <b-icon
                    v-if="!isVisibile.collezione"
                    icon="chevron-right"
                    style="margin-left: 0.5em"
                  ></b-icon>
                  <b-icon
                    v-else
                    icon="chevron-down"
                    style="margin-left: 0.5em"
                  ></b-icon>
                </div>
                <b-collapse :visible="isVisibile.collezione">
                  <div>
                    <div class="col d-flex justify-content-center">
                      <div class="mt-auto mb-auto">
                        <div class="txDettaglioTitolo">
                          {{ prodotti[0].descrizione_categoria }}
                        </div>
                      </div>
                    </div>
                  </div>
                </b-collapse>
              </b-col>
            </b-row>
            <b-row style="margin-bottom: 4em">
              <b-col>
                <div
                  @click="
                    isVisibile.altreCategorie = !isVisibile.altreCategorie
                  "
                  class="titoliSezioniPagProd"
                >
                  ALTRE CATEGORIE
                  <b-icon
                    v-if="!isVisibile.altreCategorie"
                    icon="chevron-right"
                    style="margin-left: 0.5em"
                  ></b-icon>
                  <b-icon
                    v-else
                    icon="chevron-down"
                    style="margin-left: 0.5em"
                  ></b-icon>
                </div>
                <b-collapse :visible="isVisibile.altreCategorie">
                  <div>
                    <div class="col d-flex justify-content-center">
                      <div class="mt-auto mb-auto">
                        <div class="col">
                          <span
                            v-bind:key="categoria.index"
                            v-for="categoria in prodotti[0].categorie"
                            class="txDettaglioCategoria"
                          >
                            <span
                              v-if="categoria.nomeCat != prodotti[0].postazione"
                            >
                              {{ categoria.nomeCat }}
                            </span>
                          </span>
                        </div>
                      </div>
                    </div>
                  </div>
                </b-collapse>
              </b-col>
            </b-row>
          </b-col>
        </b-row>
      </div>
    </b-container>
    <b-container>
      <b-row>
        <b-col> </b-col>
        <b-col>
          <div class="col d-flex justify-content-center">
            <div class="mt-auto mb-auto">
              <b-img
                :src="require('../assets/daverio_bianco.png')"
                fluid
                alt="Responsive image"
                width="150"
                style=""
              ></b-img>
            </div>
          </div>
        </b-col>
      </b-row>
    </b-container>
  </div>
</template>

<script>
import axios from "axios";
export default {
  data() {
    return {
      prodotti: [],
      itemsImmagini: [],
      width: 600,
      isFavourite: false,
      idCorrente: 0,
      isLoading: false,
      isVisibile: {
        dettagli: true,
        descrizione: false,
        collezione: false,
        altreCategorie: false,
      },
      images: {
        large_size: [{ id: 0, url: "" }],
      },
      zoomerOptions: {
        zoomFactor: 3, // scale for zoomer
        pane: "container", // three type of pane ['pane', 'container-round', 'container']
        hoverDelay: 100, // how long after the zoomer take effect
        namespace: "zoomer", // add a namespace for zoomer component, useful when on page have mutiple zoomer
        move_by_click: true, // move image by click thumb image or by mouseover
        scroll_items: 4, // thumbs for scroll
        choosed_thumb_border_color: "#dd2c00",
        scroller_position: "bottom",
        zoomer_pane_position: "right",
      },
      backgroundLogo: {
        backgroundImage: `url(${require("@/assets/background0.jpeg")})`,
        backgroundRepeat: "no-repeat",
        backgroundPosition: "right center",
        backgroundSize: "contain",
      },
    };
  },
  components: {},

  mounted() {
    this.isLoading = true;
    axios
      .get(
        this.$store.state.settings.URL_SERVER +
          "API/v1.php?prodotti&condizione_prodotto=" +
          this.$route.params.genitore
      )
      .then((response) => {
        console.log(response);
        this.prodotti = response.data.prodotti;
        this.idCorrente = this.prodotti[0].id;

        let lista = [];
        this.storeRecentViewJwel(response.data.prodotti[0]);
        for (let i = 0; i < this.prodotti[0].imgs.length; i++) {
          lista.push({
            src: this.prodotti[0].imgs[i] + "?" + this.$session.get("secret"),
            thumbnail:
              this.prodotti[0].imgs[i] + "?" + this.$session.get("secret"),
          });
        }
        this.images.large_size = lista;
        this.favoriti();
        this.isLoading = false;
      })
      .catch((err) => {
        console.log(err);
      });
  },
  methods: {
    favoriti() {
      this.isLoading = true;

      axios
        .get(this.$store.state.settings.URL_SERVER + "API/v1.php?favourites")
        .then((response) => {
          let idCorrente = this.idCorrente;
          let isFavourite = false;
          response.data.favoriti.map(function (value) {
            if (value.idProdotto == idCorrente) {
              isFavourite = true;
            }
          });
          this.isFavourite = isFavourite;
          this.isLoading = false;
        })
        .catch((err) => {
          console.log(err);
        });
    },
    addFavourite() {
      axios
        .get(
          this.$store.state.settings.URL_SERVER +
            "API/v1.php?addFavourite&id=" +
            this.idCorrente
        )
        .then((response) => {
          console.log(response);
          this.favoriti();
        })
        .catch((err) => {
          console.log(err);
        });
    },
    removeFavourite() {
      axios
        .get(
          this.$store.state.settings.URL_SERVER +
            "API/v1.php?removeFavourite&id=" +
            this.idCorrente
        )
        .then((response) => {
          console.log(response);
          this.favoriti();
        })
        .catch((err) => {
          console.log(err);
        });
    },
    storeRecentViewJwel(prodotti) {
      var image = prodotti.imgs[0];
      var url =
        this.$store.state.settings.URL_SERVER +
        "API/RecentView.php?prodcut_id=" +
        prodotti.id +
        "&prezzo=" +
        prodotti.prezzo +
        "&postazione=" +
        prodotti.postazione +
        "&titolo=" +
        prodotti.titolo +
        "&descrizione=" +
        prodotti.descrizione +
        "&user_id=" +
        this.$session.get("ID_USR") +
        "&image=" +
        image;
      const data = {
        id: prodotti.id,
        prezzo: prodotti.prezzo,
        postazione: prodotti.postazione,
        titolo: prodotti.titolo,
        descrizione: prodotti.descrizione,
      };

      axios.post(url).then((response) => {
        console.log("called");
      });
    },
  },
};
</script>
