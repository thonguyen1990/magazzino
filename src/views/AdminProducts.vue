<template>
  <div class="admin">
    <NavbarAdmin />
    <AdminProductTable />
  </div>
</template>

<script>
import NavbarAdmin from "../components/NavbarAdmin.vue";
import AdminProductTable from "../components/AdminProductTable.vue";

export default {
  name: "Admin",
  components: {
    NavbarAdmin,
    AdminProductTable,
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
