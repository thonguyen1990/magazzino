<template>
  <div>
    <Navbar />
    <LoginAdm />
  </div>
</template>

<script>
import Navbar from "../components/Navbar.vue";
import LoginAdm from "../components/LoginAdm.vue";

export default {
  name: "LoginAdmin",
  components: {
    Navbar,
    LoginAdm,
  },
};
</script>
