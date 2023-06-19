<template>
  <div id="app">
    <vue-confirm-dialog></vue-confirm-dialog>
    <router-view />
  </div>
</template>
<script>
import axios from "axios";

export default {
  beforeMount() {
    if (this.$session.get("BasicAuth")) {
      console.log("SESSION is: " + this.$session.get("BasicAuth"));
      axios.defaults.headers.common["Authorization"] =
        this.$session.get("BasicAuth");
      axios.defaults.headers.common["Access-Control-Allow-Origin"] =
        this.$store.state.settings.URL_WEBAPP;
    } else {
      console.log("NO SESSIONE");
      this.$router.replace({ name: "Logout" });
    }
  },
  mounted() {
    if (this.$session.get("vetrina") == "1") {
      this.$router.push({ name: "vetrina" });
    }
  },
};
</script>
<style>
@import "./assets/styles.css";
</style>
