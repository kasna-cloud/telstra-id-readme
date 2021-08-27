import Vue from "vue";
import axios from "axios";
import VueAxios from "vue-axios";

const ApiService = {
  init() {
    Vue.use(VueAxios, axios);
    Vue.axios.defaults.baseURL = "http://${PROJECT_ID}-api.lab.kasna.cloud";
  },

  query(resource, params) {
    return Vue.axios.get(resource, params).catch(error => {
      throw new Error(`[RWV] ApiService ${error}`);
    });
  },

  get(resource, slug = "") {
    return Vue.axios.get(`${resource}/${slug}`).catch(error => {
      throw new Error(`[RWV] ApiService ${error}`);
    });
  },
};

export default ApiService;


export const CustomersService = {
  query(type, params) {
    return ApiService.query("api/customers", {
      params: params
    });
  },
  get(slug) {
    return ApiService.get("api/customers", slug);
  }
};

export const TransactionsService = {
  query(type, params) {
    return ApiService.query("transactions", {
      params: params
    });
  },
  get(slug) {
    return ApiService.get("transactions", slug);
  }
};

