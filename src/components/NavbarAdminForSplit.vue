<template>
  <b-navbar toggleable="lg" type="dark" variant="dark" class="navbar-admin">
    <b-navbar-toggle target="nav-collapse"></b-navbar-toggle>
    <b-collapse id="nav-collapse" is-nav class="agenda-show">
      <b-navbar-nav class="left-agenda">
        <b-nav-item href="#" to="/agenda"
          ><span :style="{ color: getActiveRoute('/agenda') }"
            >CALENDARIO</span
          ></b-nav-item
        >
        <b-nav-item-dropdown href="#" to="/adminProducts">
          <template #button-content>
            <span @click="vai('/adminProducts')"
              ><span :style="{ color: getActiveRoute('/adminProducts') }"
                >PRODOTTI<span
                  ><span
                    ><b-icon
                      icon="caret-down-fill"
                      style="margin-left: 0.2rem"
                      font-scale="0.8"
                    ></b-icon></span></span></span
            ></span>
          </template>
          <b-dropdown-item href="#" to="/adminCategories"
            >CATEGORIE</b-dropdown-item
          >
          <b-dropdown-item href="#" to="/gestioneVetrine"
            >VETRINE</b-dropdown-item
          >
        </b-nav-item-dropdown>
        <b-nav-item-dropdown href="#" class="pietre-split">
          <template #button-content>
            <span
              ><span style="color: white"
                >PIETRE<span
                  ><span
                    ><b-icon
                      icon="caret-down-fill"
                      style="margin-left: 0.2rem"
                      font-scale="0.8"
                    ></b-icon></span></span></span
            ></span>
          </template>
          <b-dropdown-item href="#" to="/diamanti/TUTTO"
            >Diamanti</b-dropdown-item
          >
          <b-dropdown-item href="#" to="/pietre/diamanti_brown/TUTTO"
            >Diamanti Brown</b-dropdown-item
          >
          <b-dropdown-item href="#" to="/pietre/diamanti_multicolor/TUTTO"
            >Diamanti Multicolor</b-dropdown-item
          >
          <b-dropdown-item href="#" to="/pietre/diamanti_neri/TUTTO"
            >Diamanti Neri</b-dropdown-item
          >

          <b-dropdown-item href="#" to="/pietre/h20/TUTTO"
            >Acqua Marina</b-dropdown-item
          >
          <b-dropdown-item href="#" to="/pietre/perle/TUTTO"
            >Perle</b-dropdown-item
          >
          <b-dropdown-item href="#" to="/pietre/quarzo/TUTTO"
            >Quarzo</b-dropdown-item
          >
          <b-dropdown-item href="#" to="/pietre/rubini/TUTTO"
            >Rubini</b-dropdown-item
          >
          <b-dropdown-item href="#" to="/pietre/smeraldi/TUTTO"
            >Smeraldi</b-dropdown-item
          >
          <b-dropdown-item href="#" to="/pietre/topazio/TUTTO"
            >Topazio</b-dropdown-item
          >
          <b-dropdown-item href="#" to="/pietre/tanzanite/TUTTO"
            >Tanzanite</b-dropdown-item
          >

          <b-dropdown-item href="#" to="/pietre/zaffiri/TUTTO"
            >Zaffiri</b-dropdown-item
          >
          <b-dropdown-item href="#" to="/pietre/zaffiri_multicolor/TUTTO"
            >Zaffiri Multicolor</b-dropdown-item
          >
          <b-dropdown-item href="#" to="/pietre/altre/TUTTO"
            >Altre Pietre</b-dropdown-item
          >
        </b-nav-item-dropdown>
        <b-nav-item-dropdown href="#" class="lavorazioni-split">
          <template #button-content>
            <span @click="vai('/riparazioni/TUTTO')"
              ><span style="color: white"
                >LAVORAZIONI<span
                  ><span
                    ><b-icon
                      icon="caret-down-fill"
                      style="margin-left: 0.2rem"
                      font-scale="0.8"
                    ></b-icon></span></span></span
            ></span>
          </template>
          <b-dropdown-item href="#" to="/riparazioni/ORDINE"
            >ORDINI</b-dropdown-item
          >
          <b-dropdown-item href="#" to="/riparazioni/RIPARAZIONE"
            >RIPARAZIONI</b-dropdown-item
          >
          <b-dropdown-item href="#" to="/riparazioni/VALUTAZIONE"
            >VALUTAZIONI</b-dropdown-item
          >
        </b-nav-item-dropdown>
        <b-nav-item href="#" to="/laboratorio" class="lab-split"
          ><span :style="{ color: getActiveRoute('/laboratorio') }"
            >LAB</span
          ></b-nav-item
        >
        <b-nav-item-dropdown href="#" class="client-split">
          <template #button-content>
            <span @click="vai('/clienti/NO')"
              ><span style="color: white"
                >CLIENTI<span
                  ><span
                    ><b-icon
                      icon="caret-down-fill"
                      style="margin-left: 0.2rem"
                      font-scale="0.8"
                    ></b-icon></span></span></span
            ></span>
          </template>
          <b-dropdown-item href="#" to="/clienti/PROMEMORIA"
            >PROMEMORIA</b-dropdown-item
          >
          <b-dropdown-item
            v-if="
              this.$session.exists() &&
              this.$session.get('AUTORIZZAZIONI').elenco_visite_vendite >= 1
            "
            href="#"
            to="/statsVV"
            >VISITE & VENDITE</b-dropdown-item
          >
          <b-dropdown-item href="#" to="/conti">CONTI</b-dropdown-item>
        </b-nav-item-dropdown>

        <b-navbar-brand to="/note" class="agenda-note"
          ><span class="itemNB"
            ><b-icon
              style="margin-left: 1em"
              icon="pencil-square"
              font-scale="1.5"
            ></b-icon></span
        ></b-navbar-brand>
        <b-navbar-brand to="/notifiche" class="agenda-noti">
          <span v-if="nNotifiche > 0" class="itemNB badgecontainer">
            <b-icon
              style="margin-left: 1em"
              icon="chat"
              font-scale="1.5"
            ></b-icon>
            <span class="badge badge-pill badge-notifiche">{{
              nNotifiche
            }}</span>
          </span>
          <span v-else class="itemNB badgecontainer">
            <b-icon
              style="margin-left: 1em"
              icon="chat"
              font-scale="1.5"
            ></b-icon>
          </span>
        </b-navbar-brand>
      </b-navbar-nav>

      <!-- Right aligned nav items -->
      <b-navbar-nav class="ml-auto">
        <b-navbar-brand to="/split-vue"
          ><b-icon icon="layout-split" font-scale="1"></b-icon
        ></b-navbar-brand>
        <b-navbar-brand to="/"
          ><b-icon icon="shop" font-scale="1"></b-icon
        ></b-navbar-brand>
        <b-navbar-brand
          right
          v-if="this.$session.exists()"
          href="#"
          to="/gestioneDB"
          ><span style="color: whitesmoke"
            ><b-icon icon="tools" font-scale="1"></b-icon></span
        ></b-navbar-brand>
        <b-navbar-brand
          right
          v-if="this.$session.exists()"
          href="#"
          to="/logout"
          ><span style="color: whitesmoke"
            ><b-icon icon="door-closed" font-scale="1"></b-icon></span
        ></b-navbar-brand>
      </b-navbar-nav>
    </b-collapse>
  </b-navbar>
</template>

<script>
import axios from "axios";

export default {
  props: ["aggiornaIconaNotifiche"],
  data() {
    return {
      username: "",
      hrefBackup: "",
      nNotifiche: 0,
    };
  },
  mounted() {
    this.$session.set("tipo", "BE");
    this.hrefBackup =
      this.$store.state.settings.URL_SERVER + "API/autobackup.php";
    this.getNumeroNotifiche();
    this.username = this.$session.get("USR");
  },
  methods: {
    vai(url) {
      this.$router.push({ path: url });
    },
    getNumeroNotifiche() {
      axios
        .get(
          this.$store.state.settings.URL_SERVER +
            "API/v1.php?numeroNotifiche&secret=" +
            this.$session.get("secret")
        )
        .then((response) => {
          console.log(response);
          this.nNotifiche = response.data.numeroNotifiche;
        })
        .catch((err) => {
          console.log(err);
        });
    },
    getActiveRoute(routeName) {
      return this.$route.path == routeName ? "orange" : "white";
    },
  },
  watch: {
    aggiornaIconaNotifiche: function (newVal, oldVal) {
      console.log(newVal + oldVal);
      this.getNumeroNotifiche();
    },
  },
  computed: {
    activeRoute() {
      var activeRouteName = this.$route.name;
    },
  },
};
</script>
<style>
.navbar.navbar-dark.bg-dark {
  background-color: #03373a !important;
  font-family: "GFS Didot";
  font-size: 15px;
  font-weight: 100 !important;
}

.router-link-exact-active {
  color: orange !important;
}

.navbar .show {
  display: flex;
}

.navbar .show .navbar-nav {
  flex-direction: row;
  justify-content: flex-start;
  align-items: center;
}

.navbar .show .navbar-nav .nav-item {
  padding: 0.25rem;
}

.navbar .show .navbar-nav .ml-auto {
  display: flex;
  align-items: center;
}

.fc-button-group {
  padding: 0 !important;
}

@media (max-width: 1100px) {
  .navbar .agenda-show {
    display: flex;
  }

  .agenda-note,
  .agenda-noti {
    display: none !important;
  }

  .navbar .show .left-agenda {
    flex-direction: row;
    justify-content: flex-start;
    align-items: center;
  }

  .navbar .show .ml-auto {
    flex-direction: row;
    justify-content: flex-start;
    align-items: center;
  }
}

@media (max-width: 1900px) {
  .client-split {
    display: none;
  }
}

@media (max-width: 1700px) {
  .lab-split {
    display: none;
  }
}

@media (max-width: 1600px) {
  .lavorazioni-split {
    display: none;
  }
}

@media (max-width: 1300px) {
  .pietre-split {
    display: none;
  }
}
</style>
