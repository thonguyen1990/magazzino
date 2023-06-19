<template>
  <div>
    <Login />
  </div>
</template>

<script>
import Login from "../components/Login.vue";

export default {
  name: "LoginView",
  components: {
    Login,
  },
  beforeCreate: function () {
    if (this.$session.exists()) {
      this.$router.replace("/");
    }
  },
};
</script>
