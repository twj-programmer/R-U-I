<template>
  <el-table :data="recordList" v-loading="loading" class="w-full">
    <el-table-column :label="t('actionType')" prop="actionTypeDesc" />
    <el-table-column :label="t('beforeOwner')" prop="beforeOwnerUserName" />
    <el-table-column :label="t('afterOwner')" prop="afterOwnerUserName" />
    <el-table-column :label="t('reason')" prop="reason" />
    <el-table-column :label="t('operator')" prop="operatorUserName" />
    <el-table-column :label="t('actionTime')" prop="actionTime">
      <template #default="{ row }">
        <span>{{ formatDateTime(row.actionTime) }}</span>
      </template>
    </el-table-column>
  </el-table>
</template>
<script lang="ts" setup>
import { ref, onMounted, watch } from 'vue'
import * as CustomerApi from '@/api/crm/customer'
import { formatDateTime } from '@/utils/dateUtils'

defineOptions({ name: 'CustomerHighSeasRecordList' })

const props = defineProps<{
  customerId: number
}>()

const { t } = useI18n('crm.customer')
const loading = ref(false)
const recordList = ref<CustomerApi.HighSeasRecordVO[]>([])

const getRecordList = async () => {
  loading.value = true
  try {
    recordList.value = await CustomerApi.getHighSeasRecordList(props.customerId)
  } finally {
    loading.value = false
  }
}

onMounted(() => {
  getRecordList()
})

watch(() => props.customerId, () => {
  getRecordList()
})
</script>