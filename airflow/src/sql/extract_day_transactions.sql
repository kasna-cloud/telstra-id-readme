SELECT TIMESTAMP_MILLIS(timestamp) AS trans_time,transaction_id, block_id, previous_block, merkle_root
FROM `bigquery-public-data.bitcoin_blockchain.transactions`
WHERE CAST(CONCAT(
          CAST(
              EXTRACT(
                  YEAR FROM TIMESTAMP_MILLIS(timestamp)) AS STRING),
          '-', 
          CAST(
              EXTRACT(
                  MONTH FROM TIMESTAMP_MILLIS(timestamp)) AS STRING),
          '-',
          CAST(
              EXTRACT(
                  DAY FROM TIMESTAMP_MILLIS(timestamp)) AS STRING)) 
      AS DATE) = '2018-01-01' 