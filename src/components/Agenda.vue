<template>
  <div>
    <loading
      :active.sync="isLoading"
      :can-cancel="true"
      :is-full-page="true"
    ></loading>

    <div class="container">
      <FullCalendar :options="calendarOptions" />
    </div>
    <b-modal id="modal-nuovoEvento" hide-footer title="Evento" size="xl">
      <b-form @submit="onSubmitNuovoEvento">
        <b-row>
          <b-col>
            <b-form-group label="Titolo:" label-for="input-titolo">
              <b-form-input
                id="input-titolo"
                v-model="nuovoEvento.title"
                type="text"
                :disabled="nuovoEvento.disabilitato"
              ></b-form-input>
            </b-form-group>
            <b-form-group label="Descrizione:" label-for="input-descrizione">
              <b-form-textarea
                id="input-descrizione"
                rows="3"
                v-model="nuovoEvento.description"
                type="text"
                :disabled="nuovoEvento.disabilitato"
              ></b-form-textarea>
            </b-form-group>
          </b-col>
        </b-row>
        <b-row>
          <b-col>
            <b-form-group label="Da:" label-for="input-inizio">
              <b-form-datepicker
                id="input-inizio"
                :max="nuovoEvento.dayEnd"
                :disabled="nuovoEvento.disabilitato"
                today-button
                reset-button
                v-model="nuovoEvento.dayStart"
                class="mb-2"
                :state="validaForm.dayStart"
              ></b-form-datepicker>
            </b-form-group>
          </b-col>
          <b-col>
            <b-form-group label="A:" label-for="input-fine">
              <b-form-datepicker
                id="input-fine"
                :min="nuovoEvento.dayStart"
                :disabled="nuovoEvento.disabilitato"
                today-button
                reset-button
                v-model="nuovoEvento.dayEnd"
                class="mb-2"
                :state="validaForm.dayEnd"
              ></b-form-datepicker>
            </b-form-group>
          </b-col>
          <b-col>
            <b-form-group label="Notifica:" label-for="notifica">
              <model-select
                id="notifica"
                class="form-control"
                :options="optionsNotifica"
                v-model="nuovoEvento.notifica"
              >
              </model-select>
            </b-form-group>
          </b-col>
        </b-row>
        <span v-if="!nuovoEvento.disabilitato">
          <b-button
            v-if="nuovoEvento.id > 0"
            style="float: right"
            type="button"
            variant="danger"
            @click="eliminaEvento(nuovoEvento.id)"
            >ELIMINA</b-button
          >
          <b-button type="submit" variant="primary">SALVA</b-button>
        </span>
      </b-form>
    </b-modal>
  </div>
</template>

<script>
import FullCalendar from "@fullcalendar/vue";
import dayGridPlugin from "@fullcalendar/daygrid";
import timeGridPlugin from "@fullcalendar/timegrid";
import interactionPlugin from "@fullcalendar/interaction";
import listPlugin from "@fullcalendar/list";
import axios from "axios";
import { ModelSelect } from "vue-search-select";

export default {
  components: {
    FullCalendar,
    ModelSelect,
  },
  data() {
    var self = this;

    return {
      calendarOptions: {
        plugins: [dayGridPlugin, interactionPlugin, timeGridPlugin, listPlugin],
        initialView: "dayGridMonth",
        locale: "it",
        headerToolbar: {
          start: "title",
          center: "nuovoEventoBtn",
          end: "timeGridWeek,dayGridMonth,nextYear prev today next",
        },
        buttonText: {
          today: "Oggi",
          dayGridMonth: "Mese",
          timeGridWeek: "Settimana",
          timeGridDay: "Giorno",
          listWeek: "Lista",
          nextYear: "ANNO",
        },
        customButtons: {
          nuovoEventoBtn: {
            text: "Nuovo evento",
            click: function () {
              self.handleSelect(null);
            },
          },
        },
        height: "auto",
        weekends: true,
        selectable: true,
        dateClick: this.handleSelect,
        eventClick: this.handleClickEvent,
        events: [],
        displayEventEnd: true,
        selectable: true,
        dayRender: function (date, cell) {
          var today = $.fullCalendar.moment();
          var end = $.fullCalendar.moment().add(7, "days");

          if (date.get("date") == today.get("date")) {
            cell.css("background-color", "#bdf8bd8a");
          }
          if (date.get("date") < today.get("date")) {
            cell.css("background-color", "#bdf8bd8a !important");
          }
        },
      },
      nuovoEvento: {
        id: 0,
        dayStart: null,
        dayEnd: null,
        title: "",
        description: "",
        allDay: true,
        tipo: "AGENDA",
        idRelativo: 0,
        disabilitato: false,
        notifica: 0,
      },
      validaForm: { dayStart: null, dayEnd: null },
      optionsNotifica: [
        { value: 0, text: "NO" },
        { value: 1, text: "Adesso" },
        { value: 2, text: "Stesso giorno" },
        { value: 3, text: "1 Giorno prima" },
        { value: 4, text: "2 Giorni prima" },
        { value: 5, text: "3 Giorni prima" },
        { value: 6, text: "4 Giorni prima" },
        { value: 7, text: "5 Giorni prima" },
        { value: 8, text: "6 Giorni prima" },
        { value: 9, text: "7 Giorni prima" },
      ],
      isLoading: false,
    };
  },
  mounted() {
    this.getEventi();
  },
  methods: {
    getEventi() {
      this.isLoading = true;
      axios
        .get(
          this.$store.state.settings.URL_SERVER +
            "API/v1.php?listaEventi&secret=" +
            this.$session.get("secret")
        )
        .then((response) => {
          console.log(response);
          let lista = [];
          response.data.eventi.map(function (value) {
            let dateEnd = new Date(value.dayEnd);
            dateEnd.setDate(dateEnd.getDate() + 1);
            lista.push({
              id: value.id,
              title: value.title,
              description: value.description,
              start: value.dayStart,
              end: dateEnd,
              allDay: true,
              tipo: value.tipo,
              color: "#03373a",
              notifica: value.notifica,
            });
          });
          this.calendarOptions.events = lista;
          this.isLoading = false;
        })
        .catch((err) => {
          this.isLoading = false;
          console.log(err);
        });
    },
    handleSelect(arg) {
      this.clearModalEvento();
      if (arg != null) {
        console.log(arg);
        this.nuovoEvento.dayStart = arg.dateStr;
      }
      this.$bvModal.show("modal-nuovoEvento");
    },
    handleClickEvent(arg) {
      this.clearModalEvento();
      console.log(arg);
      this.nuovoEvento.id = arg.event.id;
      this.nuovoEvento.title = arg.event.title;
      this.nuovoEvento.description = arg.event.extendedProps.description;
      this.nuovoEvento.dayStart = arg.event.startStr;

      let dateEnd = new Date(arg.event.endStr);
      dateEnd.setDate(dateEnd.getDate() - 1);
      this.nuovoEvento.dayEnd = dateEnd;

      this.nuovoEvento.disabilitato =
        arg.event.extendedProps.tipo == "AGENDA" ? false : true;
      this.nuovoEvento.notifica = parseInt(arg.event.extendedProps.notifica);

      this.$bvModal.show("modal-nuovoEvento");
    },
    clearModalEvento() {
      this.nuovoEvento.id = 0;
      this.nuovoEvento.title = "";
      this.nuovoEvento.description = "";
      this.nuovoEvento.dayStart = null;
      this.nuovoEvento.dayEnd = null;
      this.nuovoEvento.disabilitato = false;
      this.nuovoEvento.notifica = 0;
    },
    eliminaEvento(id) {
      this.$confirm({
        message: `Sicuro di voler eliminare l'evento?`,
        button: {
          no: "No",
          yes: "Si",
        },
        /**
         * Callback Function
         * @param {Boolean} confirm
         */
        callback: (confirm) => {
          if (confirm) {
            axios
              .get(
                this.$store.state.settings.URL_SERVER +
                  "API/v1.php?eliminaEvento&id=" +
                  id +
                  "&secret=" +
                  this.$session.get("secret")
              )
              .then((response) => {
                if (response.status === 200 && response.data.result == "OK") {
                  this.$bvModal.hide("modal-nuovoEvento");
                  this.getEventi();
                } else {
                  //this.sendAlert('success')
                  console.log("ERRORE");
                }
              })
              .catch((err) => {
                console.log(err);
                this.sendAlert("fail");
              });
          }
        },
      });
    },
    onSubmitNuovoEvento() {
      event.preventDefault();
      this.validaForm.dayStart = null;
      if (this.nuovoEvento.dayStart == null) {
        this.validaForm.dayStart = false;
        return 0;
      }
      this.$set(this.nuovoEvento, "azione", "nuovoEvento");
      this.$set(this.nuovoEvento, "secret", this.$session.get("secret"));
      this.isLoading = true;

      axios
        .post(
          this.$store.state.settings.URL_SERVER + "API/v1.php",
          this.toFormData(this.nuovoEvento),
          {
            headers: {
              "Content-Type": "application/json",
            },
          }
        )
        .then((response) => {
          console.log(response);
          if (response.status === 200 && response.data.result == "OK") {
            //      this.sendAlert('success')
            this.getEventi();
            this.$bvModal.hide("modal-nuovoEvento");
          } else {
          }
          this.isLoading = false;
        })
        .catch((err) => {
          console.log(err);
          this.isLoading = false;
        });

      this.clearModalEvento();
      this.$bvModal.hide("modal-nuovoEvento");
    },
    toFormData: function (obj) {
      let formData = new FormData();
      for (let key in obj) {
        formData.append(key, obj[key]);
      }
      return formData;
    },
  },
};
</script>

<style lang="css">
.fc-daygrid-day-number {
  color: brown !important;
}

.fc-bgevent {
  background-color: aqua !important;
}

.fc-day-today {
  background: #d5fed595 !important;
}

.fc-day-past {
  background-color: rgba(225, 225, 225, 0.448);
}

.fc-toolbar,
.fc-col-header-cell {
  text-transform: uppercase;
  font-family: "GFS Didot";
  color: brown;
}

.fc-col-header-cell-cushion {
  color: #03373a;
}

.fc-toolbar {
  margin-top: 12px;
}

.fc-header-toolbar {
  border-top: 3px solid #03373a;
  padding-top: 5px;
}

.fc-toolbar-chunk {
  padding-top: 1px;
  color: #03373a;
}

.fc-nuovoEventoBtn-button:hover {
  color: #fff !important;
  background-color: #1e2b37 !important;
  border-color: #03373a !important;
}

.fc-nuovoEventoBtn-button {
  background-color: white !important;
  border-color: #03373a !important;
  color: #03373a !important;
}

.fc-timeGridWeek-button,
.fc-dayGridMonth-button,
.fc-nextYear-button {
  background-color: #fff !important;
  color: #03373a !important;
  border: 0 !important;
  border-right: 3px solid #03373a !important;
}

.fc-prev-button,
.fc-next-button,
.fc-today-button,
.fc-nextYear-button {
  background-color: #fff !important;
  color: #03373a !important;
  border: 0 !important;
  border-radius: 0 !important;
}

.fc-prev-button,
.fc-next-button,
.fc-nextYear-button {
  padding: 0% !important;
  margin: 0% !important;
}

.fc-dayGridMonth-button,
.fc-nextYear-button {
  padding-left: 12px !important;
}

.fc-timeGridWeek-button,
.fc-dayGridMonth-button,
.fc-nextYear-button {
  text-transform: uppercase !important;
}

.fc-icon-chevron-left,
.fc-icon-chevron-right {
  font-weight: 900 !important;
}

.fc-button-group {
  padding-right: 250px;
}

/* 30 march 2023 */
.fc-direction-ltr .fc-daygrid-event.fc-event-end:hover,
.fc-direction-rtl .fc-daygrid-event.fc-event-start:hover {
  border-color: #ffa50061 !important;
  background-color: #ffa5007a !important;
}

.fc-daygrid-event.fc-event-start:hover .fc-event-title-container {
  color: white !important;
  font-weight: 500;
  letter-spacing: 0.3px;
}

.fc-button.fc-button-active {
  color: orange !important;
  box-shadow: none !important;
}

.fc-h-event .fc-event-main {
  padding: 2px 0px 0px 4px;
}

.fc .fc-button-group > .fc-button:focus,
.fc .fc-button-group > .fc-button:active,
.fc .fc-button-group > .fc-button.fc-button-active {
  box-shadow: none !important;
}

@media (max-width: 500px) {
  .fc-header-toolbar {
    display: block !important;
  }
}
</style>
