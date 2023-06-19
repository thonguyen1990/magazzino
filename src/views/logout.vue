<template>
  <div></div>
</template>

<script>
export default {
  name: "LogoutPage",
  components: {},
  mounted() {
    this.$session.destroy();
    this.$router.push("/login");
  },
};
</script>
