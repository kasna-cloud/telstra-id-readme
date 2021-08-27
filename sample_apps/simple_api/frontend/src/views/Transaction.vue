<template>
  <div class="customer-page">
    <div class="banner">
      <div class="container">
        <h1>{{ transaction.txn_id }}</h1>
        <RwvCustomerMeta :transaction="transaction" :actions="true"></RwvCustomerMeta>
      </div>
    </div>
    <div class="container page">
      <div class="row transaction-content">
        <div class="col-xs-12">
          <div v-html="parseMarkdown(transaction.account_number)"></div>
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
import RwvTransactionMeta from "@/components/TransactionMeta";
import { FETCH_TRANSACTION } from "@/store/actions.type";

export default {
  name: "rwv-transaction",
  props: {
    slug: {
      type: String,
      required: true
    }
  },
  components: {
    RwvTransactionMeta
  },
  beforeRouteEnter(to, from, next) {
    Promise.all([
      store.dispatch(FETCH_TRANSACTION, to.params.slug),
    ]).then(() => {
      next();
    });
  },
  computed: {
    ...mapGetters(["transaction"])
  },
  methods: {
    parseMarkdown(content) {
      return marked(content);
    }
  }
};
</script>
