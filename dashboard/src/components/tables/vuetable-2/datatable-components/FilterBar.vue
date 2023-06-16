<template>
  <div class="form-group with-icon-left">
    <div class="input-group">

      <form class="form-inline">
        <input type="text" placeholder="Search Name"  aria-label="Search" class="form-control mr-sm-2" id="input-icon-left" name="input-icon-left" @keyup="doFilter()" v-model="filterText" required/>
        <button type="submit" class="btn btn-outline-success my-2 my-sm-0"><i class="fa fa fa-search"></i></button>
      </form>

    </div>
  </div>
</template>

<script>
  export default {
    name: 'filterBar',
    data () {
      return {
        filterText: ''
      }
    },
    methods: {
      doFilter () {
        this.$emit('filter', this.filterText)
      }
    }
  }
</script>

<style lang="scss" scoped>
  .search-icon {
    transform: rotate(90deg);
  }

  .form-group {
    min-width: 7rem;
  }

  @media (max-width: 768px) {
    .form-group {
      width: 80%;
    }
  }

</style>
