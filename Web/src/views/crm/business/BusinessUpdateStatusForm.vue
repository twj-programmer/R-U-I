<!-- 23计科4班 黄金戈 -->
<template>
  <Dialog :title="t('crm.business.changeStatus')" v-model="dialogVisible" width="460">
    <el-form
      ref="formRef"
      :model="formData"
      :rules="formRules"
      label-width="100px"
      v-loading="formLoading"
    >
      <el-form-item :label="t('crm.business.statusName')" prop="target">
        <el-select
          v-model="formData.target"
          :placeholder="t('crm.business.statusPlaceholder')"
          class="w-1/1"
        >
          <el-option
            v-for="item in statusList"
            :key="`stage:${item.id}`"
            :label="`${item.name} (${t('crm.business.winRate')}：${item.percent}%)`"
            :value="`stage:${item.id}`"
            :disabled="!currentStageFound || item.sort <= currentSort"
          />
          <el-option
            v-for="item in BusinessStatusApi.DEFAULT_STATUSES"
            :key="`end:${item.endStatus}`"
            :label="`${t(item.nameKey)} (${t('crm.business.winRate')}：${item.percent}%)`"
            :value="`end:${item.endStatus}`"
            :disabled="!currentStageFound"
          />
        </el-select>
        <div class="text-xs text-gray-500 mt-1">{{ t('crm.business.stageForwardOnly') }}</div>
      </el-form-item>

      <el-form-item
        v-if="selectedEndStatus === 2"
        :label="t('crm.business.loseReason')"
        prop="loseReasonCode"
        :rules="[
          { required: true, message: t('crm.business.loseReasonRequired'), trigger: 'change' }
        ]"
      >
        <el-select
          v-model="formData.loseReasonCode"
          :placeholder="t('crm.business.loseReasonPlaceholder')"
          class="w-1/1"
        >
          <el-option
            v-for="item in loseReasonOptions"
            :key="item.value"
            :label="item.label"
            :value="item.value"
          />
        </el-select>
        <el-alert
          v-if="loseReasonOptions.length === 0"
          :title="t('crm.business.loseReasonUnconfigured')"
          type="warning"
          :closable="false"
          class="mt-2"
        />
      </el-form-item>

      <el-form-item
        v-if="selectedEndStatus === 2 || selectedEndStatus === 3"
        :label="
          selectedEndStatus === 2
            ? t('crm.business.loseRemark')
            : t('crm.business.invalidRemark')
        "
        prop="endRemark"
      >
        <el-input
          v-model="formData.endRemark"
          type="textarea"
          :rows="3"
          maxlength="500"
          show-word-limit
          :placeholder="t('crm.business.endRemarkPlaceholder')"
        />
      </el-form-item>
    </el-form>
    <template #footer>
      <el-button
        @click="submitForm"
        type="primary"
        :disabled="formLoading || (selectedEndStatus === 2 && loseReasonOptions.length === 0)"
      >
        {{ t('common.confirm') }}
      </el-button>
      <el-button @click="dialogVisible = false">{{ t('common.cancel') }}</el-button>
    </template>
  </Dialog>
</template>

<script setup lang="ts">
import { computed, nextTick, reactive, ref, watch } from 'vue'
import * as BusinessApi from '@/api/crm/business'
import * as BusinessStatusApi from '@/api/crm/business/status'
import { getStrDictOptions } from '@/utils/dict'
import { useI18n } from '@/hooks/web/useI18n'
import { useMessage } from '@/hooks/web/useMessage'

interface StatusFormData {
  id?: number
  version?: number
  target?: string
  loseReasonCode?: string
  endRemark?: string
}

const LOSE_REASON_DICT_TYPE = 'crm_business_lose_reason'
const { t } = useI18n()
const message = useMessage()

const dialogVisible = ref(false)
const formLoading = ref(false)
const formData = ref<StatusFormData>({})
const formRules = reactive({
  target: [{ required: true, message: t('crm.business.statusRequired'), trigger: 'change' }]
})
const formRef = ref()
const statusList = ref<BusinessStatusApi.BusinessStatusVO[]>([])
const currentSort = ref(-1)
const currentStageFound = ref(false)
const loseReasonOptions = computed(() => getStrDictOptions(LOSE_REASON_DICT_TYPE))
const selectedEndStatus = computed(() => {
  const target = formData.value.target
  return target?.startsWith('end:') ? Number(target.substring(4)) : undefined
})

watch(
  () => formData.value.target,
  () => {
    if (selectedEndStatus.value !== 2) {
      formData.value.loseReasonCode = undefined
    }
    if (selectedEndStatus.value !== 2 && selectedEndStatus.value !== 3) {
      formData.value.endRemark = undefined
    }
    nextTick(() => formRef.value?.clearValidate(['loseReasonCode', 'endRemark']))
  }
)

const open = async (business: BusinessApi.BusinessVO) => {
  dialogVisible.value = true
  resetForm()
  formData.value.id = business.id
  formData.value.version = business.version
  formLoading.value = true
  try {
    statusList.value = await BusinessStatusApi.getBusinessStatusSimpleList(business.statusTypeId)
    const currentStatus = statusList.value.find((item) => item.id === business.statusId)
    currentStageFound.value = currentStatus !== undefined
    currentSort.value = currentStatus?.sort ?? -1
    if (!currentStatus) {
      message.warning(t('crm.business.invalidCurrentStage'))
    }
  } finally {
    formLoading.value = false
  }
}
defineExpose({ open })

const emit = defineEmits(['success'])
const submitForm = async () => {
  if (!formRef.value) return
  const valid = await formRef.value.validate()
  if (!valid || !formData.value.id || formData.value.version === undefined) return

  const target = formData.value.target!
  const payload: BusinessApi.BusinessUpdateStatusReqVO = {
    id: formData.value.id,
    version: formData.value.version
  }
  if (target.startsWith('stage:')) {
    payload.statusId = Number(target.substring(6))
  } else {
    payload.endStatus = Number(target.substring(4))
    if (payload.endStatus === 2) {
      payload.loseReasonCode = formData.value.loseReasonCode
      payload.endRemark = formData.value.endRemark?.trim() || undefined
    } else if (payload.endStatus === 3) {
      payload.endRemark = formData.value.endRemark?.trim() || undefined
    }
  }

  const targetName = target.startsWith('stage:')
    ? statusList.value.find((item) => item.id === payload.statusId)?.name
    : t(
        BusinessStatusApi.DEFAULT_STATUSES.find((item) => item.endStatus === payload.endStatus)
          ?.nameKey || 'crm.business.targetStatus'
      )
  await message.confirm(
    t('crm.business.changeStatusConfirm', {
      target: targetName || t('crm.business.targetStatus')
    })
  )

  formLoading.value = true
  try {
    await BusinessApi.updateBusinessStatus(payload)
    message.success(t('crm.business.updateStatusSuccess'))
    dialogVisible.value = false
    emit('success')
  } finally {
    formLoading.value = false
  }
}

const resetForm = () => {
  formData.value = {}
  statusList.value = []
  currentSort.value = -1
  currentStageFound.value = false
  formRef.value?.resetFields()
}
</script>
