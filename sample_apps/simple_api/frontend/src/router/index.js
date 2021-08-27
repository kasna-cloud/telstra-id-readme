import Vue from "vue";
import Router from "vue-router";

Vue.use(Router);

export default new Router({
  routes: [
    {
      path: "/",
      component: () => import("@/views/Home"),
      children: [
        {
          path: "",
          name: "home",
          component: () => import("@/views/CustomerGlobal")
        },
        {
          path: "",
          name: "transactions",
          component: () => import("@/views/TransactionGlobal")
        }
      ]
    },
    {
      name: "customer",
      path: "/customer/:slug",
      component: () => import("@/views/Customer"),
      props: true
    },
    {
      name: "transaction",
      path: "/transaction/:slug",
      component: () => import("@/views/Transaction"),
      props: true
    }
  ]
});
