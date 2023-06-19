<template>
  <div class="admin">
    <NavbarAdmin />
    <Clienti />
  </div>
</template>

<script>
import NavbarAdmin from "../components/NavbarAdmin.vue";
import Clienti from "../components/Clienti.vue";

export default {
  name: "Admin",
  components: {
    NavbarAdmin,
    Clienti,
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
