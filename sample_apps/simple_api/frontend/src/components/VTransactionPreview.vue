<template>
  <div class="transaction-preview">
    <RwvTransactionMeta isPreview :transaction="transaction" />
    <br>
    <tr>
    <router-link :to="transactionLink" class="preview-link">
      <td v-text="transaction.txn_id" />
    </router-link>
    </tr>
  </div>
</template>

<script>
import RwvTransactionMeta from "./TransactionMeta";

export default {
  name: "RwvTransactionPreview",
  components: {
    RwvTransactionMeta
  },
  props: {
    transaction: { type: Object, required: true }
  },
  computed: {
    transactionLink() {
      return {
        name: "transaction",
        params: {
          slug: this.transaction.txn_id
        }
      };
    }
  }
};
</script>
