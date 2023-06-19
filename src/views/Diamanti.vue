<template>
  <div class="admin">
    <NavbarAdmin v-if="$session.get('tipo') == 'BE'" />
    <Navbar v-else />
    <Diamanti />
  </div>
</template>

<script>
import NavbarAdmin from "../components/NavbarAdmin.vue";
import Navbar from "../components/Navbar.vue";

import Diamanti from "../components/Diamanti.vue";

export default {
  name: "DiamantiView",
  components: {
    NavbarAdmin,
    Navbar,
    Diamanti,
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
