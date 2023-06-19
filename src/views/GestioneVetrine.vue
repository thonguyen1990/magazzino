<template>
  <div class="admin">
    <NavbarAdmin />

    <GestioneVetrine />
  </div>
</template>

<script>
import NavbarAdmin from "../components/NavbarAdmin.vue";
import GestioneVetrine from "../components/GestioneVetrine.vue";

export default {
  name: "GestioneVetrineView",
  components: {
    NavbarAdmin,
    GestioneVetrine,
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
