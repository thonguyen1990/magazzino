<template>
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
</template>

<script>
import axios from "axios";

export default {
  data() {
    return {
      notaProdotto: { titolo: "", id: 0, testo: "" },
      prodotti: [],
    };
  },
  components: {},
  mounted() {},
  methods: {
    editNotaProdotto(id, prods) {
      this.prodotti = prods;
      this.notaProdotto = this.prodotti.filter((prod) => prod.id == id)[0];
      console.log(this.notaProdotto);
      this.$bvModal.show("modal-notaProdotto");
    },
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
            this.$bvModal.hide("modal-notaProdotto");
            this.$emit("aggiornaProdotti");
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
    clearFormNotaProdotto() {
      console.log("clear");
    },
  },
};
</script>
