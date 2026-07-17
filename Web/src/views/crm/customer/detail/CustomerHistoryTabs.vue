<template>
  <el-tabs>
    <el-tab-pane label="公海记录">
      <el-table :data="highSeasRecords" v-loading="loading" stripe>
        <el-table-column prop="actionType" label="动作" min-width="120" />
        <el-table-column prop="beforeOwnerUserId" label="原负责人" min-width="100" />
        <el-table-column prop="afterOwnerUserId" label="新负责人" min-width="100" />
        <el-table-column prop="reason" label="原因" min-width="180" />
        <el-table-column prop="actionTime" label="操作时间" min-width="180" />
      </el-table>
    </el-tab-pane>
    <el-tab-pane label="负责人历史">
      <el-table :data="ownerHistories" v-loading="loading" stripe>
        <el-table-column prop="changeType" label="变更类型" min-width="120" />
        <el-table-column prop="oldOwnerUserId" label="原负责人" min-width="100" />
        <el-table-column prop="newOwnerUserId" label="新负责人" min-width="100" />
        <el-table-column prop="reason" label="原因" min-width="180" />
        <el-table-column prop="changeTime" label="变更时间" min-width="180" />
      </el-table>
    </el-tab-pane>
  </el-tabs>
</template>

<script lang="ts" setup>
import * as CustomerHistoryApi from '@/api/crm/customer/history'

const props = defineProps<{ customerId: number }>()
const loading = ref(false)
const highSeasRecords = ref<CustomerHistoryApi.HighSeasRecordVO[]>([])
const ownerHistories = ref<CustomerHistoryApi.CustomerOwnerHistoryVO[]>([])

const load = async () => {
  if (!props.customerId) return
  loading.value = true
  try {
    ;[highSeasRecords.value, ownerHistories.value] = await Promise.all([
      CustomerHistoryApi.getHighSeasRecordListByCustomer(props.customerId),
      CustomerHistoryApi.getCustomerOwnerHistoryList(props.customerId)
    ])
  } finally {
    loading.value = false
  }
}

watch(() => props.customerId, load, { immediate: true })
</script>
