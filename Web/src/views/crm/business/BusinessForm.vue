<!-- 23计科4班 黄金戈 -->
<template>
  <Dialog :title="dialogTitle" v-model="dialogVisible" width="1280">
    <el-form
      ref="formRef"
      :model="formData"
      :rules="formRules"
      label-width="auto"
      v-loading="formLoading"
      :disabled="isTerminal"
    >
      <el-alert
        v-if="formType === 'update'"
        title="基础资料与报价需分别保存，两个按钮不会连续调用接口"
        type="info"
        :closable="false"
        class="mb-4"
      />
      <el-row :gutter="20">
        <el-col :span="12">
          <el-form-item :label="t('crm.business.name')" prop="name">
            <el-input v-model="formData.name" :placeholder="t('crm.business.namePlaceholder')" />
          </el-form-item>
        </el-col>
        <el-col :span="12">
          <el-form-item :label="t('crm.business.ownerUserId')" prop="ownerUserId">
            <el-select
              v-model="formData.ownerUserId"
              :disabled="formType !== 'create'"
              class="w-1/1"
            >
              <el-option
                v-for="item in userOptions"
                :key="item.id"
                :label="item.nickname"
                :value="item.id"
              />
            </el-select>
          </el-form-item>
        </el-col>
      </el-row>
      <el-row :gutter="20">
        <el-col :span="12">
          <el-form-item :label="t('crm.business.customerName')" prop="customerId">
            <el-select
              v-model="formData.customerId"
              :disabled="formData.customerDefault"
              :placeholder="t('crm.business.customerIdPlaceholder')"
              class="w-1/1"
            >
              <el-option
                v-for="item in customerList"
                :key="item.id"
                :label="item.name"
                :value="item.id"
              />
            </el-select>
          </el-form-item>
        </el-col>
        <el-col :span="12">
          <el-form-item :label="t('crm.business.statusTypeId')" prop="statusTypeId">
            <el-select
              v-model="formData.statusTypeId"
              :placeholder="t('crm.business.statusTypePlaceholder')"
              clearable
              class="w-1/1"
              :disabled="formType !== 'create'"
            >
              <el-option
                v-for="item in statusTypeList"
                :key="item.id"
                :label="item.name"
                :value="item.id"
              />
            </el-select>
          </el-form-item>
        </el-col>
      </el-row>
      <el-row :gutter="20">
        <el-col :span="12">
          <el-form-item :label="t('crm.business.dealTime')" prop="dealTime">
            <el-date-picker
              v-model="formData.dealTime"
              type="date"
              value-format="x"
              :placeholder="t('crm.business.dealTimePlaceholder')"
              class="!w-1/1"
            />
          </el-form-item>
        </el-col>
        <el-col :span="12">
          <el-form-item :label="t('crm.business.remark')" prop="remark">
            <el-input
              type="textarea"
              v-model="formData.remark"
              :placeholder="t('crm.business.remarkPlaceholder')"
            />
          </el-form-item>
        </el-col>
      </el-row>

      <ContentWrap>
        <el-tabs v-model="subTabsName" class="-mt-15px -mb-10px">
          <el-tab-pane :label="t('crm.business.productList')" name="product">
            <BusinessProductForm
              ref="productFormRef"
              :products="formData.products"
              :disabled="isTerminal"
            />
          </el-tab-pane>
        </el-tabs>
      </ContentWrap>
      <el-row :gutter="20">
        <el-col :span="12">
          <el-form-item :label="t('crm.business.totalProductPrice')">
            <el-input
              disabled
              v-model="formData.totalProductPrice"
              :formatter="erpPriceInputFormatter"
            />
          </el-form-item>
        </el-col>
        <el-col :span="12">
          <el-form-item :label="t('crm.business.discountPercent')" prop="discountPercent">
            <el-input-number
              v-model="formData.discountPercent"
              :placeholder="t('crm.business.discountPercent')"
              controls-position="right"
              :min="0"
              :max="100"
              :precision="2"
              :disabled="isTerminal"
              class="!w-1/1"
            />
          </el-form-item>
        </el-col>
      </el-row>
      <el-row :gutter="20">
        <el-col :span="12">
          <el-form-item :label="t('crm.business.price')">
            <el-input
              disabled
              v-model="formData.totalPrice"
              :formatter="erpPriceInputFormatter"
            />
          </el-form-item>
        </el-col>
      </el-row>
    </el-form>
    <template #footer>
      <el-button
        v-if="formType === 'create'"
        @click="createForm"
        type="primary"
        :disabled="formLoading"
      >
        {{ t('common.confirm') }}
      </el-button>
      <template v-else-if="!isTerminal">
        <el-button @click="saveBasicForm" type="primary" :disabled="formLoading">
          保存基础资料
        </el-button>
        <el-button @click="saveQuotation" type="success" :disabled="formLoading">
          保存报价
        </el-button>
      </template>
      <el-button @click="dialogVisible = false">{{ t('common.cancel') }}</el-button>
    </template>
  </Dialog>
</template>

<script setup lang="ts">
import * as BusinessApi from '@/api/crm/business'
import * as BusinessStatusApi from '@/api/crm/business/status'
import * as CustomerApi from '@/api/crm/customer'
import * as UserApi from '@/api/system/user'
import { useUserStore } from '@/store/modules/user'
import BusinessProductForm from './components/BusinessProductForm.vue'
import { erpPriceMultiply, erpPriceInputFormatter } from '@/utils'

interface BusinessFormData {
  id?: number
  version?: number
  name?: string
  customerId?: number
  ownerUserId?: number
  statusTypeId?: number
  dealTime?: Date
  contactNextTime?: Date
  discountPercent: number
  totalProductPrice?: number
  totalPrice?: number
  remark?: string
  products: BusinessApi.BusinessProductVO[]
  contactId?: number
  customerDefault: boolean
  endStatus?: number
}

const { t } = useI18n()
const message = useMessage()

const dialogVisible = ref(false)
const dialogTitle = ref('')
const formLoading = ref(false)
const formType = ref<'create' | 'update'>('create')
const createEmptyForm = (): BusinessFormData => ({
  discountPercent: 0,
  products: [],
  customerDefault: false
})
const formData = ref<BusinessFormData>(createEmptyForm())
const formRules = reactive({
  name: [{ required: true, message: t('crm.business.nameRequired'), trigger: 'blur' }],
  customerId: [
    { required: true, message: t('crm.business.customerIdRequired'), trigger: 'change' }
  ],
  ownerUserId: [
    { required: true, message: t('crm.business.ownerUserRequired'), trigger: 'change' }
  ],
  statusTypeId: [
    { required: true, message: t('crm.business.statusTypeRequired'), trigger: 'change' }
  ],
  discountPercent: [
    { required: true, message: t('crm.business.discountPercent'), trigger: 'blur' }
  ]
})
const formRef = ref()
const userOptions = ref<UserApi.UserVO[]>([])
const statusTypeList = ref<BusinessStatusApi.BusinessStatusTypeVO[]>([])
const customerList = ref<CustomerApi.CustomerVO[]>([])
const isTerminal = computed(() => formData.value.endStatus != null)

const subTabsName = ref('product')
const productFormRef = ref()

watch(
  () => [formData.value.products, formData.value.discountPercent] as const,
  ([products, discountPercent]) => {
    const totalProductPrice = products.reduce(
      (sum, item) => sum + Number(item.totalPrice || 0),
      0
    )
    const discountAmount =
      erpPriceMultiply(totalProductPrice, Number(discountPercent || 0) / 100) ?? 0
    formData.value.totalProductPrice = totalProductPrice
    formData.value.totalPrice = totalProductPrice - discountAmount
  },
  { deep: true }
)

const open = async (type: 'create' | 'update', id?: number, customerId?: number, contactId?: number) => {
  dialogVisible.value = true
  dialogTitle.value = t('action.' + type)
  formType.value = type
  resetForm()
  if (id) {
    formLoading.value = true
    try {
      const business = await BusinessApi.getBusiness(id)
      formData.value = {
        ...createEmptyForm(),
        ...business,
        products: business.products || []
      }
    } finally {
      formLoading.value = false
    }
  } else {
    if (customerId) {
      formData.value.customerId = customerId
      formData.value.customerDefault = true
    }
    if (contactId) {
      formData.value.contactId = contactId
    }
  }
  customerList.value = await CustomerApi.getCustomerSimpleList()
  statusTypeList.value = await BusinessStatusApi.getBusinessStatusTypeSimpleList()
  userOptions.value = await UserApi.getSimpleUserList()
  if (formType.value === 'create') {
    formData.value.ownerUserId = useUserStore().getUser.id
  }
}
defineExpose({ open })

const emit = defineEmits(['success'])
const buildProductPayload = (): BusinessApi.BusinessProductReqVO[] =>
  formData.value.products.map(({ productId, businessPrice, count }) => ({
    productId,
    businessPrice,
    count
  }))

const createForm = async () => {
  if (!formRef.value) return
  const valid = await formRef.value.validate()
  if (!valid) return
  await productFormRef.value?.validate()
  const data = formData.value
  formLoading.value = true
  try {
    await BusinessApi.createBusiness({
      name: data.name!,
      customerId: data.customerId!,
      ownerUserId: data.ownerUserId!,
      statusTypeId: data.statusTypeId!,
      dealTime: data.dealTime,
      discountPercent: data.discountPercent,
      remark: data.remark,
      contactId: data.contactId,
      products: buildProductPayload()
    })
    message.success(t('common.createSuccess'))
    dialogVisible.value = false
    emit('success')
  } finally {
    formLoading.value = false
  }
}

const saveBasicForm = async () => {
  const id = formData.value.id
  const version = formData.value.version
  if (!formRef.value || !id || version === undefined) return
  const valid = await formRef.value.validate()
  if (!valid) return
  const data = formData.value
  formLoading.value = true
  try {
    data.version = await BusinessApi.updateBusiness({
      id,
      version,
      name: data.name!,
      customerId: data.customerId!,
      contactNextTime: data.contactNextTime,
      dealTime: data.dealTime,
      remark: data.remark,
      contactId: data.contactId
    })
    message.success(t('common.updateSuccess'))
    emit('success')
  } finally {
    formLoading.value = false
  }
}

const saveQuotation = async () => {
  const data = formData.value
  if (!data.id || data.version === undefined || isTerminal.value) return
  await productFormRef.value?.validate()
  formLoading.value = true
  try {
    const previousProducts = new Map(data.products.map((item) => [item.productId, item]))
    const result = await BusinessApi.updateBusinessQuotation({
      id: data.id,
      version: data.version,
      discountPercent: data.discountPercent,
      products: buildProductPayload()
    })
    data.version = result.version
    data.totalProductPrice = result.totalProductPrice
    data.discountPercent = result.discountPercent
    data.totalPrice = result.totalPrice
    data.products = result.products.map((item) => ({
      ...previousProducts.get(item.productId),
      ...item
    }))
    message.success('报价保存成功')
    emit('success')
  } finally {
    formLoading.value = false
  }
}

const resetForm = () => {
  formData.value = createEmptyForm()
  formRef.value?.resetFields()
}
</script>
