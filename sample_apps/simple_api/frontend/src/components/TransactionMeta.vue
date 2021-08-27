<template>
  <div class="transaction-meta">
  </div>
</template>

<script>
import { mapGetters } from "vuex";

export default {
  name: "RwvTransactionMeta",
  props: {
    transaction: {
      type: Object,
      required: true
    }
  }
};
</script>
