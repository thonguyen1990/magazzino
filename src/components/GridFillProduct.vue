<template>
  <div style="width: 100%" class="row">
    <div
      v-bind:key="data.index"
      v-for="data in this.prodotti"
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
</template>

<script>
export default {
  props: {
    prodotti: Array,
  },
  data() {
    return {
      cat_mostrare_desc: [],
    };
  },
  methods: {
    editNotaProd(id) {
      this.$refs.notaProd.editNotaProdotto(id, this.prodotti);
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
    navigaDettaglioo(id) {
      this.$router.push({
        name: "categorie",
        params: { livello: "4", genitore: id },
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
