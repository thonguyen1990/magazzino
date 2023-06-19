<template>
  <div class="admin">
    <NavbarAdmin />
    <AdminCategories />
  </div>
</template>

<script>
import NavbarAdmin from "../components/NavbarAdmin.vue";
import AdminCategories from "../components/AdminCategories.vue";

export default {
  name: "Admin",
  components: {
    NavbarAdmin,
    AdminCategories,
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
