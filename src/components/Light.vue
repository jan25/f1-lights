<template>
  <div id="light-container">
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
#light-container {
  width: 70px;
  height: 350px;
  padding: 10px;
  border-radius: 15px;
  background-color: black;
}

.light {
  padding-top: 100%;
  border-radius: 50%;
  background-color: grey;
}

.light.on {
  background-color: red;
}
</style>
