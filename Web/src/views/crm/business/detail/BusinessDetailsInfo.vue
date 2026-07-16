<!-- 23计科4班 黄金戈 -->
<template>
  <ContentWrap>
    <el-collapse v-model="activeNames">
      <el-collapse-item name="basicInfo">
        <template #title>
          <span class="text-base font-bold">{{ t('crm.customer.basicInfoTab') }}</span>
        </template>
        <el-descriptions :column="4">
          <el-descriptions-item :label="t('crm.business.name')">{{ business.name }}</el-descriptions-item>
          <el-descriptions-item :label="t('crm.business.customerName')">{{ business.customerName }}</el-descriptions-item>
          <el-descriptions-item :label="t('crm.business.price') + '（元）'">
            {{ erpPriceInputFormatter(business.totalPrice) }}
          </el-descriptions-item>
          <el-descriptions-item :label="t('crm.business.dealTime')">
            {{ formatDate(business.dealTime) }}
          </el-descriptions-item>
          <el-descriptions-item :label="t('crm.business.contactNextTime')">
            {{ formatDate(business.contactNextTime) }}
          </el-descriptions-item>
          <el-descriptions-item :label="t('crm.business.statusTypeId')">
            {{ business.statusTypeName }}
          </el-descriptions-item>
          <el-descriptions-item :label="t('crm.business.statusName')">{{ business.statusName }}</el-descriptions-item>
          <el-descriptions-item :label="t('crm.business.remark')">{{ business.remark }}</el-descriptions-item>
          <el-descriptions-item v-if="business.endStatus" :label="t('crm.business.terminalStatus')">
            <dict-tag :type="DICT_TYPE.CRM_BUSINESS_END_STATUS_TYPE" :value="business.endStatus" />
          </el-descriptions-item>
          <el-descriptions-item
            v-if="business.endStatus === 2"
            :label="t('crm.business.loseReason')"
          >
            <dict-tag type="crm_business_lose_reason" :value="business.loseReasonCode || ''" />
          </el-descriptions-item>
          <el-descriptions-item
            v-if="business.endRemark"
            :label="t('crm.business.endDescription')"
          >
            {{ business.endRemark }}
          </el-descriptions-item>
        </el-descriptions>
      </el-collapse-item>
      <el-collapse-item name="systemInfo">
        <template #title>
          <span class="text-base font-bold">{{ t('common.systemInfo') }}</span>
        </template>
        <el-descriptions :column="4">
          <el-descriptions-item :label="t('crm.business.ownerUserName')">{{ business.ownerUserName }}</el-descriptions-item>
          <el-descriptions-item :label="t('crm.business.contactLastTime')">
            {{ formatDate(business.contactLastTime) }}
          </el-descriptions-item>
          <el-descriptions-item :label="''">&nbsp;</el-descriptions-item>
          <el-descriptions-item :label="''">&nbsp;</el-descriptions-item>
          <el-descriptions-item :label="t('crm.business.creatorName')">{{ business.creatorName }}</el-descriptions-item>
          <el-descriptions-item :label="t('crm.business.createTime')">
            {{ formatDate(business.createTime) }}
          </el-descriptions-item>
          <el-descriptions-item :label="t('crm.business.updateTime')">
            {{ formatDate(business.updateTime) }}
          </el-descriptions-item>
        </el-descriptions>
      </el-collapse-item>
    </el-collapse>
  </ContentWrap>
</template>
<script setup lang="ts">
import { ref } from 'vue'
import * as BusinessApi from '@/api/crm/business'
import { formatDate } from '@/utils/formatTime'
import { erpPriceInputFormatter } from '@/utils'
import { DICT_TYPE } from '@/utils/dict'
import { useI18n } from '@/hooks/web/useI18n'

const { t } = useI18n() // 国际化

const { business } = defineProps<{
  business: BusinessApi.BusinessVO
}>()

// 展示的折叠面板
const activeNames = ref(['basicInfo', 'systemInfo'])
</script>
