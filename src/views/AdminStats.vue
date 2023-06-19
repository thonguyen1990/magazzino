<template>
  <div class="admin">
    <NavbarAdmin />
    <AdminStats />
  </div>
</template>

<script>
import NavbarAdmin from "../components/NavbarAdmin.vue";
import AdminStats from "../components/AdminStats.vue";

export default {
  name: "Admin",
  components: {
    NavbarAdmin,
    AdminStats,
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
