<template>
  <b-container fluid>
    <NavbarAdmin />
    <Riparazioni />
  </b-container>
</template>

<script>
import NavbarAdmin from "../components/NavbarAdmin.vue";
import Riparazioni from "../components/Riparazioni.vue";

export default {
  name: "RiparazioniView",
  components: {
    NavbarAdmin,
    Riparazioni,
  },
  beforeCreate: function () {
    if (!this.$session.exists()) {
      this.$router.replace("/login");
    }
    if (this.$session.get("vetrina") == "1") {
      this.$router.push({ name: "vetrina" });
    }
  },
};
</script>
