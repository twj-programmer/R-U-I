<template>
  <el-tabs>
    <el-tab-pane :label="t('crm.customer.history.highSeasTab')">
      <el-table :data="highSeasRecords" v-loading="loading" stripe>
        <el-table-column :label="t('crm.customer.history.action')" min-width="120">
          <template #default="scope">{{ getActionLabel(scope.row.actionType) }}</template>
        </el-table-column>
        <el-table-column :label="t('crm.customer.history.oldOwner')" min-width="120">
          <template #default="scope">
            {{ scope.row.beforeOwnerUserName || scope.row.beforeOwnerUserId || '-' }}
          </template>
        </el-table-column>
        <el-table-column :label="t('crm.customer.history.newOwner')" min-width="120">
          <template #default="scope">
            {{ scope.row.afterOwnerUserName || scope.row.afterOwnerUserId || '-' }}
          </template>
        </el-table-column>
        <el-table-column prop="operatorUserName" :label="t('crm.customer.history.operator')" min-width="120" />
        <el-table-column prop="reason" :label="t('crm.customer.history.reason')" min-width="180" />
        <el-table-column prop="actionTime" :label="t('crm.customer.history.operationTime')" min-width="180" />
      </el-table>
    </el-tab-pane>
    <el-tab-pane :label="t('crm.customer.history.ownerHistoryTab')">
      <el-table :data="ownerHistories" v-loading="loading" stripe>
        <el-table-column :label="t('crm.customer.history.changeType')" min-width="120">
          <template #default="scope">{{ getActionLabel(scope.row.changeType) }}</template>
        </el-table-column>
        <el-table-column :label="t('crm.customer.history.oldOwner')" min-width="120">
          <template #default="scope">
            {{ scope.row.oldOwnerUserName || scope.row.oldOwnerUserId || '-' }}
          </template>
        </el-table-column>
        <el-table-column :label="t('crm.customer.history.newOwner')" min-width="120">
          <template #default="scope">
            {{ scope.row.newOwnerUserName || scope.row.newOwnerUserId || '-' }}
          </template>
        </el-table-column>
        <el-table-column prop="operatorUserName" :label="t('crm.customer.history.operator')" min-width="120" />
        <el-table-column prop="reason" :label="t('crm.customer.history.reason')" min-width="180" />
        <el-table-column prop="changeTime" :label="t('crm.customer.history.changeTime')" min-width="180" />
      </el-table>
    </el-tab-pane>
  </el-tabs>
</template>

<script lang="ts" setup>
import * as CustomerHistoryApi from '@/api/crm/customer/history'

const props = defineProps<{ customerId: number }>()
const { t } = useI18n()
const loading = ref(false)
const highSeasRecords = ref<CustomerHistoryApi.HighSeasRecordVO[]>([])
const ownerHistories = ref<CustomerHistoryApi.CustomerOwnerHistoryVO[]>([])

const actionLocaleKeys: Record<string, string> = {
  MANUAL_PUT: 'crm.customer.history.manualPut',
  AUTO_PUT: 'crm.customer.history.autoPut',
  RECEIVE: 'crm.customer.history.receive',
  ASSIGN: 'crm.customer.history.assign',
  TRANSFER: 'crm.customer.history.transfer'
}

const getActionLabel = (value?: string) => {
  const localeKey = value ? actionLocaleKeys[value] : undefined
  return localeKey ? t(localeKey) : value || '-'
}

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
