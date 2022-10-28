import Vue from 'vue'
import Router from 'vue-router'
import HelloWorld from '../components/HelloWorld.vue'
import GalaxyWorld from '../components/GalaxyWorld.vue'
Vue.use(Router)

const  routes = [
    {
      path: '/world',
      name: 'World',
      component: HelloWorld
    },
    {
      path: '/galaxy',
      name: 'Galaxy',
      component: GalaxyWorld
    },
    {
      path :'*',
      component:HelloWorld
  }
  ]

export default new Router({
    mode: 'history',
    routes
})