<template>
  <div>
    <b-table striped hover responsive :items="this.prodotti" :fields="fields">
    </b-table>
  </div>
</template>

<script>
export default {
  props: {
    prodotti: Array,
  },
  data() {
    return {
      fields: [
        {
          key: "titolo",
          sortable: true,
        },
        {
          key: "postazione",
          sortable: true,
        },
        {
          key: "ct",
          sortable: true,
        },
        {
          key: "colore",
          sortable: true,
        },
        {
          key: "purezza",
          sortable: true,
        },
        {
          key: "taglio",
          sortable: true,
        },
        {
          key: "prezzo",
          sortable: true,
        },
      ],
    };
  },
};
</script>
