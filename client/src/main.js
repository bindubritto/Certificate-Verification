import Vue from 'vue'
import App from './App.vue'
import router from './router'
import vSelect from 'vue-select'
import 'vue-select/dist/vue-select.css';
import 'vue-loaders/dist/vue-loaders.css';
import VueLoaders from 'vue-loaders';
import Notifications from 'vue-notification'

Vue.config.productionTip = false;

Vue.component('v-select', vSelect);
Vue.use(VueLoaders);
Vue.use(Notifications);

new Vue({
  router,
  render: h => h(App),
}).$mount('#app')
