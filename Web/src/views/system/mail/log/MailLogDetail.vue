<template>
  <Dialog v-model="dialogVisible" :max-height="500" :scroll="true" :title="t('system.mail.detail')" width="800">
    <el-descriptions :column="1" border>
      <el-descriptions-item :label="t('system.mail.logPrimaryKey')" min-width="120">
        {{ detailData.id }}
      </el-descriptions-item>
      <el-descriptions-item :label="t('system.mail.accountId')">
        {{ accountList.find((account) => account.id === detailData.accountId)?.mail }}
      </el-descriptions-item>
      <el-descriptions-item :label="t('system.mail.mailTemplate')">
        {{ detailData.templateId }} | {{ detailData.templateCode }}
      </el-descriptions-item>
      <el-descriptions-item :label="t('system.mail.templateNickname')">
        {{ detailData.templateNickname }}
      </el-descriptions-item>
      <el-descriptions-item :label="t('system.mail.receiveUser')">
        <span v-if="detailData.userType && detailData.userId">
          <dict-tag :type="DICT_TYPE.USER_TYPE" :value="detailData.userType" />
          ({{ detailData.userId }})
        </span>
        <span v-else>{{ t('system.mail.none') }}</span>
      </el-descriptions-item>
      <el-descriptions-item :label="t('system.mail.receiveInfo')">
        <div>
          <div v-if="detailData.toMails && detailData.toMails.length > 0">
            {{ t('system.mail.toMails') }}：
            <span v-for="(mail, index) in detailData.toMails" :key="mail">
              {{ mail }}<span v-if="index < detailData.toMails.length - 1">、</span>
            </span>
          </div>
          <div v-if="detailData.ccMails && detailData.ccMails.length > 0">
            {{ t('system.mail.ccMails') }}：
            <span v-for="(mail, index) in detailData.ccMails" :key="mail">
              {{ mail }}<span v-if="index < detailData.ccMails.length - 1">、</span>
            </span>
          </div>
          <div v-if="detailData.bccMails && detailData.bccMails.length > 0">
            {{ t('system.mail.bccMails') }}：
            <span v-for="(mail, index) in detailData.bccMails" :key="mail">
              {{ mail }}<span v-if="index < detailData.bccMails.length - 1">、</span>
            </span>
          </div>
        </div>
      </el-descriptions-item>
      <el-descriptions-item :label="t('system.mail.templateTitle')">
        {{ detailData.templateTitle }}
      </el-descriptions-item>
      <el-descriptions-item :label="t('system.mail.templateContent')">
        <div v-dompurify-html="detailData.templateContent"></div>
      </el-descriptions-item>
      <el-descriptions-item :label="t('system.mail.templateParams')">
        {{ detailData.templateParams }}
      </el-descriptions-item>
      <el-descriptions-item :label="t('common.createTime')">
        {{ formatDate(detailData.createTime) }}
      </el-descriptions-item>
      <el-descriptions-item :label="t('system.mail.sendStatus')">
        <dict-tag :type="DICT_TYPE.SYSTEM_MAIL_SEND_STATUS" :value="detailData.sendStatus" />
      </el-descriptions-item>
      <el-descriptions-item :label="t('system.mail.sendTime')">
        {{ formatDate(detailData.sendTime) }}
      </el-descriptions-item>
      <el-descriptions-item :label="t('system.mail.sendMessageId')">
        {{ detailData.sendMessageId }}
      </el-descriptions-item>
      <el-descriptions-item :label="t('system.mail.sendException')">
        {{ detailData.sendException }}
      </el-descriptions-item>
    </el-descriptions>
  </Dialog>
</template>
<script lang="ts" setup>
import { DICT_TYPE } from '@/utils/dict'
import { formatDate } from '@/utils/formatTime'
import * as MailLogApi from '@/api/system/mail/log'
import * as MailAccountApi from '@/api/system/mail/account'

defineOptions({ name: 'SystemMailLogDetail' })

const { t } = useI18n() // 国际化

const dialogVisible = ref(false) // 弹窗的是否展示
const detailLoading = ref(false) // 表单的加载中
const detailData = ref() // 详情数据
const accountList = ref<MailAccountApi.MailAccountVO[]>([]) // 邮箱账号列表

/** 打开弹窗 */
const open = async (data: MailLogApi.MailLogVO) => {
  dialogVisible.value = true
  // 设置数据
  detailLoading.value = true
  try {
    detailData.value = data
  } finally {
    detailLoading.value = false
  }
  // 加载邮箱账号列表
  accountList.value = await MailAccountApi.getSimpleMailAccountList()
}
defineExpose({ open }) // 提供 open 方法，用于打开弹窗
</script>