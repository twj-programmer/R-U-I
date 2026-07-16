<template>
  <el-table :data="historyList" v-loading="loading" class="w-full">
    <el-table-column :label="t('changeType')" prop="changeTypeDesc" />
    <el-table-column :label="t('oldOwner')" prop="oldOwnerUserName" />
    <el-table-column :label="t('newOwner')" prop="newOwnerUserName" />
    <el-table-column :label="t('reason')" prop="reason" />
    <el-table-column :label="t('operator')" prop="operatorUserName" />
    <el-table-column :label="t('changeTime')" prop="changeTime">
      <template #default="{ row }">
        <span>{{ formatDate(row.changeTime) }}</span>
      </template>
    </el-table-column>
  </el-table>
</template>
<script lang="ts" setup>
import { ref, onMounted, watch } from 'vue'
import * as CustomerApi from '@/api/crm/customer'
import { formatDate } from '@/utils/formatTime'

defineOptions({ name: 'CustomerOwnerHistoryList' })

const props = defineProps<{
  customerId: number
}>()

const { t } = useI18n('crm.customer')
const loading = ref(false)
const historyList = ref<CustomerApi.CustomerOwnerHistoryVO[]>([])

const getHistoryList = async () => {
  loading.value = true
  try {
    historyList.value = await CustomerApi.getCustomerOwnerHistoryList(props.customerId)
  } finally {
    loading.value = false
  }
}

onMounted(() => {
  getHistoryList()
})

watch(() => props.customerId, () => {
  getHistoryList()
})
</script>