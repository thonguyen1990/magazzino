<template>
  <div class="home">
    <NavbarAdmin :aggiornaIconaNotifiche="aggiornaN" />

    <b-container>
      <loading
        :active.sync="isLoading"
        :can-cancel="true"
        :is-full-page="true"
      ></loading>

      <b-row>
        <b-col>
          <b-alert
            v-if="showAlertSuccess"
            variant="success"
            show
            class="alertFixed"
            >Completato!</b-alert
          >
          <b-alert
            v-if="showAlertFail"
            variant="warning"
            show
            class="alertFixed"
            >Errore!</b-alert
          >
        </b-col>
      </b-row>

      <b-tabs content-class="mt-3" active-nav-item-class="active-link">
        <b-tab title="Attuali" active>
          <b-list-group class="mt-2">
            <b-list-group-item
              v-for="n in filtroInviate"
              v-bind:key="n.tipo + '' + n.id"
              href="#"
              class="flex-column align-items-start"
            >
              <div class="d-flex w-100 justify-content-between">
                <b-icon
                  icon="eye-slash"
                  style="color: red"
                  class="p-2 h2"
                  v-on:click="nascondiNotifica(n.idNotifica)"
                ></b-icon>
                <p class="mb-1">
                  {{ n.tipo }} - {{ n.titolo }}
                  <span v-if="n.tipo == 'NOTE'"> [{{ n.categoria }}]</span>
                </p>
                <small
                  ><span v-if="n.letta == 1"> Nota già Letta </span
                  ><span v-else>Data evento {{ n.data }}</span></small
                >
                <small>Data notifica: {{ n.dataNotifica }}</small>
              </div>
            </b-list-group-item>
          </b-list-group>
        </b-tab>
        <b-tab title="Prossime">
          <b-list-group class="mt-2">
            <b-list-group-item
              v-for="n in filtroNONInviate"
              v-bind:key="n.tipo + '' + n.id"
              href="#"
              class="flex-column align-items-start"
            >
              <div class="d-flex w-100 justify-content-between">
                <b-icon
                  icon="trash"
                  style="color: red"
                  class="p-2 h2"
                  v-on:click="eliminaNotifica(n.idNotifica)"
                ></b-icon>
                <p class="mb-1">
                  {{ n.tipo }} - {{ n.titolo }}
                  <span v-if="n.tipo == 'NOTE'"> [{{ n.categoria }}]</span>
                </p>
                <small
                  ><span v-if="n.letta == 1"> Nota già Letta </span
                  ><span v-else>Data evento {{ n.data }}</span></small
                >
                <small>Data notifica: {{ n.dataNotifica }}</small>
              </div>
            </b-list-group-item>
          </b-list-group>
        </b-tab>
      </b-tabs>
    </b-container>
  </div>
</template>

<script>
import NavbarAdmin from "../components/NavbarAdmin.vue";
import axios from "axios";

export default {
  name: "NotificheView",
  components: {
    NavbarAdmin,
  },
  beforeCreate: function () {
    if (!this.$session.exists()) {
      this.$router.replace("/login");
    }
    if (this.$session.get("vetrina") == "1") {
      this.$router.push({ name: "vetrina" });
    }
  },
  data() {
    return {
      isLoading: false,
      showAlertSuccess: false,
      showAlertFail: false,
      notifiche: [],
      aggiornaN: 0,
    };
  },

  mounted() {
    this.getNotifiche();
  },
  methods: {
    getNotifiche() {
      this.isLoading = true;
      axios
        .get(
          this.$store.state.settings.URL_SERVER +
            "API/v1.php?listaNotifiche&secret=" +
            this.$session.get("secret")
        )
        .then((response) => {
          console.log(response);
          if (response.status === 200 && response.data.stato == "OK") {
            this.notifiche = response.data.listaNotifiche;
          } else {
            this.sendAlert("fail");
          }
          this.isLoading = false;
        })
        .catch((err) => {
          console.log(err);
          this.sendAlert("fail");
          this.isLoading = false;
        });
    },
    nascondiNotifica(id) {
      axios
        .get(
          this.$store.state.settings.URL_SERVER +
            "API/v1.php?modificaNotifica=" +
            id +
            "&tipo=NASCONDI&secret=" +
            this.$session.get("secret")
        )
        .then((response) => {
          console.log(response);
          if (response.status === 200 && response.data.stato == "OK") {
            this.renderIcon = false;
            this.getNotifiche();
            this.sendAlert("success");
            this.aggiornaN++;
          } else {
            this.sendAlert("fail");
          }
        })
        .catch((err) => {
          console.log(err);
          this.sendAlert("fail");
        });
    },
    eliminaNotifica(id) {
      axios
        .get(
          this.$store.state.settings.URL_SERVER +
            "API/v1.php?modificaNotifica=" +
            id +
            "&tipo=ELIMINA&secret=" +
            this.$session.get("secret")
        )
        .then((response) => {
          console.log(response);
          if (response.status === 200 && response.data.stato == "OK") {
            this.getNotifiche();
            this.sendAlert("success");
          } else {
            this.sendAlert("fail");
          }
        })
        .catch((err) => {
          console.log(err);
          this.sendAlert("fail");
        });
    },
    sendAlert(state) {
      if (state == "success") {
        this.showAlertSuccess = true;
        setTimeout(() => (this.showAlertSuccess = false), 4000);
      } else if (state == "fail") {
        this.showAlertFail = true;
        setTimeout(() => (this.showAlertFail = false), 4000);
      }
    },
  },
  computed: {
    filtroInviate: function () {
      return this.notifiche.filter(function (n) {
        if (n.inviata == 1) return n;
      });
    },
    filtroNONInviate: function () {
      return this.notifiche.filter(function (n) {
        if (n.inviata == 0) return n;
      });
    },
  },
};
</script>
