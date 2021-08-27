<template>
  <div class="transaction-global"><RwvTransactionList type="all" /></div>
</template>
<script>
import RwvTransactionList from "@/components/TransactionList";

export default {
  name: "rwv-transaction-global",
  components: {
    RwvTransactionList
  }
};
</script>
