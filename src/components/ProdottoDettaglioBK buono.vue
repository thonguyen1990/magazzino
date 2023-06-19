<template>
  <b-container fluid style="background-color: red; height: 100%">
    <loading
      :active.sync="isLoading"
      :can-cancel="true"
      :is-full-page="true"
    ></loading>
    <div style="background-color: blue; height: 100%">
      <b-row>
        <b-col> Titolo Principale </b-col>
      </b-row>

      <b-row style="background-color: blue; height: 100%">
        <b-col>
          <ProductZoomer
            v-if="!isLoading"
            :base-images="images"
            :base-zoomer-options="zoomerOptions"
          />
        </b-col>
        <b-col style="background-color: yellow; height: 100%">
          <b-row>
            <b-col>
              <div
                @click="isVisibile.dettagli = !isVisibile.dettagli"
                class="titoliSezioniPagProd"
              >
                Dettagli
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
                Descrizione
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
                La Collezione
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
                @click="isVisibile.altreCategorie = !isVisibile.altreCategorie"
                class="titoliSezioniPagProd"
              >
                Altre Categorie
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
                          >{{ categoria.nomeCat }}</span
                        >
                      </div>
                    </div>
                  </div>
                </div>
              </b-collapse>
            </b-col>
          </b-row>

          <div class="col d-flex justify-content-center">
            <div class="mt-auto mb-auto">
              <div class="col">
                <b-img
                  :src="require('../assets/daverio_bianco.jpeg')"
                  fluid
                  alt="Responsive image"
                  width="150"
                ></b-img>
              </div>
            </div>
          </div>
        </b-col>
      </b-row>

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
    </div>
  </b-container>
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
        thumbs: [
          {
            id: 0,
            url: "https://interactive-examples.mdn.mozilla.net/media/cc0-images/grapefruit-slice-332-332.jpg",
          },
        ],
        normal_size: [
          {
            id: 0,
            url: "https://interactive-examples.mdn.mozilla.net/media/cc0-images/grapefruit-slice-332-332.jpg",
          },
        ],
        large_size: [
          {
            id: 0,
            url: "https://interactive-examples.mdn.mozilla.net/media/cc0-images/grapefruit-slice-332-332.jpg",
          },
        ],
      },
      zoomerOptions: {
        zoomFactor: 3, // scale for zoomer
        pane: "container-round", // three type of pane ['pane', 'container-round', 'container']
        hoverDelay: 100, // how long after the zoomer take effect
        namespace: "zoomer", // add a namespace for zoomer component, useful when on page have mutiple zoomer
        move_by_click: true, // move image by click thumb image or by mouseover
        scroll_items: 4, // thumbs for scroll
        choosed_thumb_border_color: "#dd2c00",
        scroller_position: "bottom",
        zoomer_pane_position: "right",
      },
    };
  },
  components: {
    //  Lingallery
  },

  mounted() {
    this.isLoading = true;
    axios
      .get(
        this.$store.state.settings.URL_SERVER +
          "API/v1.php?prodotti&thumb=gallery&condizione_prodotto=" +
          this.$route.params.genitore
      )
      .then((response) => {
        console.log(response);
        this.prodotti = response.data.prodotti;
        this.idCorrente = this.prodotti[0].id;

        let lista = [];
        let listaThumbs = [];
        let listaNormal = [];
        for (let i = 0; i < this.prodotti[0].imgs.length; i++) {
          lista.push({ id: i, url: this.prodotti[0].imgs[i] });
        }
        for (let i = 0; i < this.prodotti[0].thumbs.length; i++) {
          listaThumbs.push({ id: i, url: this.prodotti[0].thumbs[i] });
        }
        for (let i = 0; i < this.prodotti[0].galleryNormal.length; i++) {
          listaNormal.push({ id: i, url: this.prodotti[0].galleryNormal[i] });
        }
        this.images.large_size = lista;
        this.images.normal_size = listaNormal;
        this.images.thumbs = listaNormal;

        this.favoriti();
        this.isLoading = false;
      })
      .catch((err) => {
        console.log(err);
      });
    false;
  },
  methods: {
    favoriti() {
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
          this.favoriti();
        })
        .catch((err) => {
          console.log(err);
        });
    },
  },
};
</script>
