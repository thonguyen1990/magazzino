<template>
<div>
</div>
</template>

<script>
// @ is an alias to /src
export default {
  name: 'LogoutPage',
  components: {

  },
  mounted() {
  this.$session.destroy()
   this.$router.push('/login')
  },
}
</script>
