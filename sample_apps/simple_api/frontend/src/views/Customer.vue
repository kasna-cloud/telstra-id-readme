<template>
  <div class="customer-page">
    <div class="banner">
      <div class="container">
        <h1>{{ customer.customer_id }}</h1>
        <RwvCustomerMeta :customer="customer" :actions="true"></RwvCustomerMeta>
      </div>
    </div>
    <div class="container page">
      <div class="row customer-content">
        <div class="col-xs-12">
          <div v-html="parseMarkdown(customer.first_name)"></div>
        </div>
      </div>
      <hr />
    </div>
  </div>
</template>

<script>
import { mapGetters } from "vuex";
import marked from "marked";
import store from "@/store";
import RwvCustomerMeta from "@/components/CustomerMeta";
import { FETCH_CUSTOMER } from "@/store/actions.type";

export default {
  name: "rwv-customer",
  props: {
    slug: {
      type: String,
      required: true
    }
  },
  components: {
    RwvCustomerMeta
  },
  beforeRouteEnter(to, from, next) {
    Promise.all([
      store.dispatch(FETCH_CUSTOMER, to.params.slug),
    ]).then(() => {
      next();
    });
  },
  computed: {
    ...mapGetters(["customer"])
  },
  methods: {
    parseMarkdown(content) {
      return marked(content);
    }
  }
};
</script>
