<template>
  <div class="container-fluid my-3">
    <div class="row mx-2">
      <div class="col-md-12 item-viewed-title">
        <h6>RECENT JEWELS VIEWED</h6>
      </div>

      <div class="col-md-12 all-item--sections">
        <a href="#" class="previous">&laquo;</a>
        <div class="row">
          <div
            class="col-md-3 col-sections"
            v-for="recentlyViewedItem in recentlyViewedItems"
          >
            <div class="row mx-0">
              <div class="col-md-4 main-img-section">
                <img
                  :src="recentlyViewedItem.image"
                  width="67px"
                  height="75px"
                  alt=""
                />
              </div>
              <div class="col-md-8 main-content-right pl-0">
                <h6>{{ recentlyViewedItem.postazione }}</h6>

                <div class="content-section-2">
                  <p>{{ recentlyViewedItem.titolo }}</p>
                  <span>{{ recentlyViewedItem.descrizione }}</span>
                  <p>{{ recentlyViewedItem.prezzo }} $</p>
                </div>
              </div>
            </div>
          </div>
        </div>
        <a href="#" class="next">&raquo;</a>
      </div>
    </div>
  </div>
</template>
<
<script>
import axios from "axios";

export default {
  data() {
    return {
      recentlyViewedItems: [],
    };
  },
  mounted() {
    var url =
      this.$store.state.settings.URL_SERVER +
      "API/RecentView.php?get_user_id=" +
      this.$session.get("ID_USR");
    axios
      .get(url, {
        headers: {
          "Content-Type": "application/json",
        },
      })
      .then((response) => {
        this.recentlyViewedItems = response.data;
      })
      .catch((error) => {
        console.log({ error });
      });
  },
};
</script>

<style>
.item-viewed-title {
  color: #500d00;
}

.all-item--sections {
  border: 1px solid #500d00;
  border-radius: 2px;
}

.col-sections {
  padding: 10px;
}

.main-img-section {
  border: 2px solid #500d00;
  display: flex;
  align-items: end;
  border-radius: 6px;
}

.main-content-right H6 {
  color: #500d00;
  font-weight: 600;
}

.content-section-2 {
  margin-top: 25px;
}

.content-section-2 p {
  font-size: 13px;
  font-weight: 600;
  margin: 0;
}

.content-section-2 span {
  font-size: 11px;
}

.previous {
  position: absolute;
  left: -10px;
  bottom: 36%;
  color: #111;
  font-size: 18px;
  background: white;
  padding: 4px;
}

.next {
  position: absolute;
  right: -10px;
  bottom: 36%;
  color: #111;
  font-size: 18px;
  background: white;
  padding: 4px;
}
</style>
