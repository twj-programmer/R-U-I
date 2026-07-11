<template>
  <doc-alert :title="t('system.sms.title')" url="https://doc.iocoder.cn/sms/" />

  <ContentWrap>
    <!-- 搜索工作栏 -->
    <el-form
      class="-mb-15px"
      :model="queryParams"
      ref="queryFormRef"
      label-width="auto"
    >
      <el-row :gutter="20">
        <el-col :span="8">
          <el-form-item :label="t('system.smsLog.mobile')" prop="mobile">
            <el-input
              v-model="queryParams.mobile"
              :placeholder="t('system.smsLog.mobilePlaceholder')"
              clearable
              @keyup.enter="handleQuery"
              class="!w-240px"
            />
          </el-form-item>
        </el-col>
        <el-col :span="8">
          <el-form-item :label="t('system.smsLog.channelId')" prop="channelId">
            <el-select
              v-model="queryParams.channelId"
              :placeholder="t('system.smsLog.channelIdPlaceholder')"
              clearable
              class="!w-240px"
            >
              <el-option
                v-for="channel in channelList"
                :key="channel.id"
                :value="channel.id"
                :label="
                  channel.signature +
                  `【 ${getDictLabel(DICT_TYPE.SYSTEM_SMS_CHANNEL_CODE, channel.code)}】`
                "
              />
            </el-select>
          </el-form-item>
        </el-col>
        <el-col :span="8">
          <el-form-item :label="t('system.smsLog.templateId')" prop="templateId">
            <el-input
              v-model="queryParams.templateId"
              :placeholder="t('system.smsLog.templateIdPlaceholder')"
              clearable
              @keyup.enter="handleQuery"
              class="!w-240px"
            />
          </el-form-item>
        </el-col>
        <el-col :span="8">
          <el-form-item :label="t('system.smsLog.sendStatus')" prop="sendStatus">
            <el-select
              v-model="queryParams.sendStatus"
              :placeholder="t('system.smsLog.sendStatusPlaceholder')"
              clearable
              class="!w-240px"
            >
              <el-option
                v-for="dict in getIntDictOptions(DICT_TYPE.SYSTEM_SMS_SEND_STATUS)"
                :key="dict.value"
                :label="dict.label"
                :value="dict.value"
              />
            </el-select>
          </el-form-item>
        </el-col>
        <el-col :span="8">
          <el-form-item :label="t('system.smsLog.sendTime')" prop="sendTime">
            <el-date-picker
              v-model="queryParams.sendTime"
              value-format="YYYY-MM-DD HH:mm:ss"
              type="daterange"
              :start-placeholder="t('common.startTime')"
              :end-placeholder="t('common.endTime')"
              class="!w-240px"
            />
          </el-form-item>
        </el-col>
        <el-col :span="8">
          <el-form-item :label="t('system.smsLog.receiveStatus')" prop="receiveStatus">
            <el-select
              v-model="queryParams.receiveStatus"
              :placeholder="t('system.smsLog.receiveStatusPlaceholder')"
              clearable
              class="!w-240px"
            >
              <el-option
                v-for="dict in getIntDictOptions(DICT_TYPE.SYSTEM_SMS_RECEIVE_STATUS)"
                :key="dict.value"
                :label="dict.label"
                :value="dict.value"
              />
            </el-select>
          </el-form-item>
        </el-col>
        <el-col :span="8">
          <el-form-item :label="t('system.smsLog.receiveTime')" prop="receiveTime">
            <el-date-picker
              v-model="queryParams.receiveTime"
              value-format="YYYY-MM-DD HH:mm:ss"
              type="daterange"
              :start-placeholder="t('common.startTime')"
              :end-placeholder="t('common.endTime')"
              class="!w-240px"
            />
          </el-form-item>
        </el-col>
      </el-row>
      <el-row>
        <el-col :span="24">
          <el-form-item>
            <el-button @click="handleQuery"><Icon icon="ep:search" class="mr-5px" /> {{ t('common.query') }}</el-button>
            <el-button @click="resetQuery"><Icon icon="ep:refresh" class="mr-5px" /> {{ t('common.reset') }}</el-button>
            <el-button
              type="success"
              plain
              @click="handleExport"
              :loading="exportLoading"
              v-hasPermi="['system:sms-log:export']"
            >
              <Icon icon="ep:download" class="mr-5px" /> {{ t('common.export') }}
            </el-button>
          </el-form-item>
        </el-col>
      </el-row>
    </el-form>
  </ContentWrap>

  <!-- 列表 -->
  <ContentWrap>
    <el-table v-loading="loading" :data="list" :table-layout="'auto'">
      <el-table-column :label="t('system.smsLog.id')" align="center" prop="id" />
      <el-table-column
        :label="t('common.createTime')"
        align="center"
        prop="createTime"
        min-width="180"
        :formatter="dateFormatter"
      />
      <el-table-column :label="t('system.smsLog.mobile')" align="center" prop="mobile" min-width="120">
        <template #default="scope">
          <div>{{ scope.row.mobile }}</div>
          <div v-if="scope.row.userType && scope.row.userId">
            <dict-tag :type="DICT_TYPE.USER_TYPE" :value="scope.row.userType" />
            {{ '(' + scope.row.userId + ')' }}
          </div>
        </template>
      </el-table-column>
      <el-table-column :label="t('system.smsLog.content')" align="center" prop="templateContent" min-width="300" />
      <el-table-column :label="t('system.smsLog.sendStatus')" align="center" min-width="180">
        <template #default="scope">
          <dict-tag :type="DICT_TYPE.SYSTEM_SMS_SEND_STATUS" :value="scope.row.sendStatus" />
          <div>{{ formatDate(scope.row.sendTime) }}</div>
        </template>
      </el-table-column>
      <el-table-column :label="t('system.smsLog.receiveStatus')" align="center" min-width="180">
        <template #default="scope">
          <dict-tag :type="DICT_TYPE.SYSTEM_SMS_RECEIVE_STATUS" :value="scope.row.receiveStatus" />
          <div>{{ formatDate(scope.row.receiveTime) }}</div>
        </template>
      </el-table-column>
      <el-table-column :label="t('system.smsLog.channelId')" align="center" min-width="120">
        <template #default="scope">
          <div>
            {{ channelList.find((channel) => channel.id === scope.row.channelId)?.signature }}
          </div>
          <dict-tag :type="DICT_TYPE.SYSTEM_SMS_CHANNEL_CODE" :value="scope.row.channelCode" />
        </template>
      </el-table-column>
      <el-table-column :label="t('system.smsLog.templateId')" align="center" prop="templateId" />
      <el-table-column :label="t('system.smsLog.templateType')" align="center" prop="templateType">
        <template #default="scope">
          <dict-tag :type="DICT_TYPE.SYSTEM_SMS_TEMPLATE_TYPE" :value="scope.row.templateType" />
        </template>
      </el-table-column>
      <el-table-column :label="t('common.operation')" align="center" fixed="right" class-name="fixed-width">
        <template #default="scope">
          <el-button
            link
            type="primary"
            @click="openDetail(scope.row)"
            v-hasPermi="['system:sms-log:query']"
          >
            {{ t('common.detail') }}
          </el-button>
        </template>
      </el-table-column>
    </el-table>
    <!-- 分页 -->
    <Pagination
      :total="total"
      v-model:page="queryParams.pageNo"
      v-model:limit="queryParams.pageSize"
      @pagination="getList"
    />
  </ContentWrap>

  <!-- 表单弹窗：详情 -->
  <SmsLogDetail ref="detailRef" />
</template>
<script lang="ts" setup>
import { DICT_TYPE, getIntDictOptions, getDictLabel } from '@/utils/dict'
import { dateFormatter, formatDate } from '@/utils/formatTime'
import download from '@/utils/download'
import * as SmsChannelApi from '@/api/system/sms/smsChannel'
import * as SmsLogApi from '@/api/system/sms/smsLog'
import SmsLogDetail from './SmsLogDetail.vue'

defineOptions({ name: 'SystemSmsLog' })

const { t } = useI18n() // 国际化
const message = useMessage() // 消息弹窗

const loading = ref(false) // 列表的加载中
const total = ref(0) // 列表的总页数
const list = ref([]) // 列表的数据
const queryFormRef = ref() // 搜索的表单
const queryParams = reactive({
  pageNo: 1,
  pageSize: 10,
  channelId: null,
  templateId: null,
  mobile: '',
  sendStatus: null,
  receiveStatus: null,
  sendTime: [],
  receiveTime: []
})
const exportLoading = ref(false) // 导出的加载中
const channelList = ref([]) // 短信渠道列表

/** 查询列表 */
const getList = async () => {
  loading.value = true
  try {
    const data = await SmsLogApi.getSmsLogPage(queryParams)
    list.value = data.list
    total.value = data.total
  } finally {
    loading.value = false
  }
}

/** 搜索按钮操作 */
const handleQuery = () => {
  queryParams.pageNo = 1
  getList()
}

/** 重置按钮操作 */
const resetQuery = () => {
  queryFormRef.value.resetFields()
  handleQuery()
}

/** 导出按钮操作 */
const handleExport = async () => {
  try {
    // 导出的二次确认
    await message.exportConfirm()
    // 发起导出
    exportLoading.value = true
    const data = await SmsLogApi.exportSmsLog(queryParams)
    download.excel(data, t('common.exportFilename.smsLog') + '.xls')
  } catch {
  } finally {
    exportLoading.value = false
  }
}

/** 详情操作 */
const detailRef = ref()
const openDetail = (data: SmsLogApi.SmsLogVO) => {
  detailRef.value.open(data)
}

/** 初始化 **/
onMounted(async () => {
  await getList()
  // 加载渠道列表
  channelList.value = await SmsChannelApi.getSimpleSmsChannelList()
})
</script>
