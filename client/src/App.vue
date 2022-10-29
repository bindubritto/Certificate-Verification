<template>
  <div id="app">
    <router-view></router-view>
    <notifications group="foo" />
  </div>
</template>

<script>

export default {
  name: 'App',
}
</script>

<style src="./assets/tailwind.css" />
