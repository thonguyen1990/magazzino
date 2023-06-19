<template>
  <div class="home">
    <Navbar />

    <Favoriti />
  </div>
</template>

<script>
import Navbar from "../components/Navbar.vue";
import Favoriti from "../components/Favoriti.vue";

export default {
  name: "FavoritiView",
  components: {
    Navbar,
    Favoriti,
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
