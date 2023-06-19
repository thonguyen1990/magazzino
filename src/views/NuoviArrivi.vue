<template>
  <div class="home">
    <Navbar />

    <NuoviArrivi />
  </div>
</template>

<script>
import Navbar from "../components/Navbar.vue";
import NuoviArrivi from "../components/NuoviArrivi.vue";

export default {
  name: "NuoviArriviView",
  components: {
    Navbar,
    NuoviArrivi,
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
