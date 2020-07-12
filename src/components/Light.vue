<template>
  <div class="light-container">
    <div
      v-for="light in lights"
      :key="light.id"
      class="light"
      v-bind:class="{ on: light.on, off: !light.on }"
    ></div>
  </div>
</template>

<script>
export default {
  data() {
    return {
      lights: [
        { id: 0, on: false },
        { id: 1, on: false },
        { id: 2, on: this.on },
        { id: 3, on: this.on },
      ],
    };
  },
  methods: {
    switchOn(on) {
      this.lights[2].on = on;
      this.lights[3].on = on;
    },
  },
};
</script>

<style scoped>
@media only screen and (min-width: 600px) {
  .light-container {
    width: 100px;
    padding: 0 10px;
    border-radius: 15px;
    background: black;
    margin: 0 5px;
  }

  .light {
    padding-top: 100%;
    border-radius: 50%;
    background: #8080805c;
    margin-bottom: 10px;
    margin-top: 10px;
  }

  .light.on {
    background-color: #ff1801;
  }
}

@media only screen and (max-width: 600px) {
  .light-container {
    width: 60px;
    padding: 0 5px;
    border-radius: 8px;
    background-color: black;
    margin: 0 3px;
  }

  .light {
    padding-top: 100%;
    border-radius: 50%;
    background-color: #8080805c;
    margin-bottom: 5px;
    margin-top: 5px;
  }

  .light.on {
    background-color: #ff1801;
  }
}
</style>
