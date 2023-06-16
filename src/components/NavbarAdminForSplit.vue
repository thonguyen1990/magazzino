<template>
    <b-navbar toggleable="lg" type="dark" variant="dark" class="navbar-admin">
        <!-- <b-navbar-brand href="#">ADMIN</b-navbar-brand>-->

        <b-navbar-toggle target="nav-collapse"></b-navbar-toggle>

        <b-collapse id="nav-collapse" is-nav class="agenda-show">
            <b-navbar-nav class="left-agenda">
                <b-nav-item href="#" to="/agenda"><span
                        :style="{ 'color': getActiveRoute('/agenda') }">CALENDARIO</span></b-nav-item>
                <b-navbar-brand to="/note" class="agenda-note"><span class="itemNB"><b-icon style="margin-left:1em"
                            icon="pencil-square" font-scale="1.5"></b-icon></span></b-navbar-brand>
                <b-navbar-brand to="/notifiche" class="agenda-noti">
                    <span v-if="nNotifiche > 0" class="itemNB badgecontainer">
                        <b-icon style="margin-left:1em" icon="chat" font-scale="1.5"></b-icon>
                        <span class="badge badge-pill badge-notifiche">{{ nNotifiche }}</span>
                    </span>
                    <span v-else class="itemNB badgecontainer">
                        <b-icon style="margin-left:1em" icon="chat" font-scale="1.5"></b-icon>
                    </span>
                </b-navbar-brand>
                <!--
          <b-nav-item href="#" to="/statsVV"><span style="color:white">VISITE & VENDITE</span></b-nav-item>
          <b-nav-item href="#" to="/conti"><span style="color:white">CONTI</span></b-nav-item>-->
            </b-navbar-nav>

            <!-- Right aligned nav items -->
            <b-navbar-nav class="ml-auto">

                <b-navbar-brand to="/split-vue"><b-icon icon="layout-split" font-scale="1"
                        style="margin-left: 2rem;"></b-icon></b-navbar-brand>
                <b-navbar-brand to="/"><b-icon icon="shop" font-scale="1"
                        style="margin-left: 2rem;"></b-icon></b-navbar-brand>


                <!-- this setting: this.$session.exists() && (this.$session.get('AUTORIZZAZIONI').db == 2) -->
                <b-navbar-brand right v-if="this.$session.exists()" href="#" to="/gestioneDB"><span
                        style="color: black;"><b-icon icon="tools" font-scale="1"
                            style="margin-left: 2em;"></b-icon></span></b-navbar-brand>


                <b-navbar-brand right v-if="this.$session.exists()" href="#" to="/logout"><span
                        style="color: black;"><b-icon icon="door-closed" font-scale="1"
                            style="margin-left: 2rem;"></b-icon></span></b-navbar-brand>
            </b-navbar-nav>
        </b-collapse>
    </b-navbar>
</template>
  
  
<script>
import axios from "axios";

export default {
    props: ['aggiornaIconaNotifiche'],
    data() {
        return {
            username: '',
            hrefBackup: '',
            nNotifiche: 0,
        };
    },
    mounted() {
        this.$session.set('tipo', 'BE');
        this.hrefBackup = this.$store.state.settings.URL_SERVER + "API/autobackup.php";
        this.getNumeroNotifiche();
        this.username = this.$session.get('USR')
    },
    methods: {
        vai(url) {
            this.$router.push({ path: url });
        },
        getNumeroNotifiche() {
            axios
                .get(this.$store.state.settings.URL_SERVER + "API/v1.php?numeroNotifiche&secret=" + this.$session.get('secret'))
                .then(response => {
                    console.log(response)
                    this.nNotifiche = response.data.numeroNotifiche;
                })
                .catch(err => {
                    console.log(err);
                });
        },
        getActiveRoute(routeName) {
            return this.$route.path == routeName ? 'orange' : 'white';
        }
    },
    watch: {
        aggiornaIconaNotifiche: function (newVal, oldVal) {
            console.log(newVal + oldVal)
            this.getNumeroNotifiche()
        }
    },
    computed: {
        activeRoute() {
            var activeRouteName = this.$route.name;
        }
    }
};
</script>
<style>
.navbar.navbar-dark.bg-dark {
    background-color: #03373a !important;
    font-family: 'GFS Didot';
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
        display: block;
    }

    .agenda-note,
    .agenda-noti {
        display: none !important;
    }

    .navbar .show .left-agenda {
        flex-direction: column;
        justify-content: flex-start;
        align-items: center;
    }

    .navbar .show .ml-auto {
        flex-direction: column;
        justify-content: flex-start;
        align-items: center;
    }
}
</style>
  