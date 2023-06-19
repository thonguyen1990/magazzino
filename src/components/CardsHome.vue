<template>
  <b-container>
    <loading
      :active.sync="isLoading"
      :can-cancel="true"
      :is-full-page="true"
    ></loading>
    <RecentView></RecentView>

    <div>
      <div class="row">
        <div
          v-bind:key="data.index"
          v-for="data in categorie"
          :title="data.nome"
          @click="navigaLivello1(data.id)"
          class="col-md-6 col-sm-12 mt-4"
        >
          <div class="card h-100">
            <b-img
              :src="data.img + '?' + $session.get('secret') + '&' + timestamp"
              alt="Responsive image"
              img-top
              class="img-categorie"
            ></b-img>
            <div class="txtCategoria mt-3 mb-3">
              {{ data.nome }}
            </div>
          </div>
        </div>
      </div>
    </div>
  </b-container>
</template>

<script>
import axios from "axios";
import RecentView from "../views/RecentView.vue";
export default {
  components: {
    RecentView,
  },
  data() {
    return {
      categorie: [],
      isLoading: false,
      timestamp: Date.now(),
    };
  },
  mounted() {
    this.isLoading = true;
    axios
      .get(
        this.$store.state.settings.URL_SERVER +
          "API/v1.php?categorieLivello=1&thumb=medium"
      )
      .then((response) => {
        console.log(response);
        this.categorie = response.data.categorie;
        this.isLoading = false;
      })
      .catch((err) => {
        console.log(err);
      });
  },
  methods: {
    navigaLivello1(id) {
      this.$router.push({
        name: "categorie",
        params: { livello: "2", genitore: id },
      });
    },
  },
  filters: {
    prodottOI(n) {
      if (n == 1) {
        return "1 Prodotto";
      } else {
        return n + " Prodotti";
      }
    },
  },
};
</script>
