<!-- 23计科4班 黄金戈 -->
<template>
  <el-form
    ref="formRef"
    :model="formData"
    :rules="formRules"
    v-loading="formLoading"
    label-width="0px"
    :inline-message="true"
    :disabled="disabled"
  >
    <el-table :data="formData" class="-mt-10px" table-layout="auto">
      <el-table-column :label="t('crm.business.index')" type="index" align="center" width="60" />
      <el-table-column :label="t('crm.business.product')" min-width="190">
        <template #default="{ row, $index }">
          <el-form-item :prop="`${$index}.productId`" :rules="formRules.productId" class="mb-0px!">
            <el-select
              v-model="row.productId"
              clearable
              filterable
              :disabled="isHistoricalUnavailable(row)"
              @change="onChangeProduct($event, row)"
              :placeholder="t('common.select')"
            >
              <el-option
                v-if="isHistoricalUnavailable(row)"
                :key="row.productId"
                :label="
                  t('crm.business.disabledProductLabel', {
                    name: row.productName || row.productId
                  })
                "
                :value="row.productId"
                disabled
              />
              <el-option
                v-for="item in availableProductList"
                :key="item.id"
                :label="item.name"
                :value="item.id"
                :disabled="isProductSelected(item.id, row)"
              />
            </el-select>
          </el-form-item>
          <div v-if="isHistoricalUnavailable(row)" class="text-xs text-warning mt-1">
            {{ t('crm.business.disabledProductHint') }}
          </div>
        </template>
      </el-table-column>
      <el-table-column :label="t('crm.business.productNo')" min-width="150">
        <template #default="{ row }">
          <el-input disabled v-model="row.productNo" />
        </template>
      </el-table-column>
      <el-table-column :label="t('crm.business.productUnit')" min-width="80">
        <template #default="{ row }">
          <dict-tag v-if="row.productUnit !== undefined" :type="DICT_TYPE.CRM_PRODUCT_UNIT" :value="row.productUnit" />
        </template>
      </el-table-column>
      <el-table-column :label="t('crm.business.productPrice')" min-width="120">
        <template #default="{ row }">
          <el-input disabled v-model="row.productPrice" :formatter="erpPriceInputFormatter" />
        </template>
      </el-table-column>
      <el-table-column :label="t('crm.business.businessPrice')" fixed="right" min-width="140">
        <template #default="{ row, $index }">
          <el-form-item
            :prop="`${$index}.businessPrice`"
            :rules="formRules.businessPrice"
            class="mb-0px!"
          >
            <el-input-number
              v-model="row.businessPrice"
              controls-position="right"
              :min="0.01"
              :precision="2"
              :disabled="isHistoricalUnavailable(row)"
              class="!w-100%"
            />
          </el-form-item>
        </template>
      </el-table-column>
      <el-table-column :label="t('crm.business.count')" prop="count" fixed="right" min-width="120">
        <template #default="{ row, $index }">
          <el-form-item :prop="`${$index}.count`" :rules="formRules.count" class="mb-0px!">
            <el-input-number
              v-model="row.count"
              controls-position="right"
              :min="0.001"
              :precision="3"
              :disabled="isHistoricalUnavailable(row)"
              class="!w-100%"
            />
          </el-form-item>
        </template>
      </el-table-column>
      <el-table-column :label="t('crm.business.total')" prop="totalPrice" fixed="right" min-width="140">
        <template #default="{ row }">
          <el-input disabled v-model="row.totalPrice" :formatter="erpPriceInputFormatter" />
        </template>
      </el-table-column>
      <el-table-column align="center" fixed="right" :label="t('common.action')" min-width="100">
        <template #default="{ $index }">
          <el-button @click="handleDelete($index)" link type="danger">
            {{ t('common.delete') }}
          </el-button>
        </template>
      </el-table-column>
    </el-table>
  </el-form>
  <el-row justify="center" class="mt-3" v-if="!disabled">
    <el-button @click="handleAdd" round>+ {{ t('crm.business.addProduct') }}</el-button>
  </el-row>
</template>

<script setup lang="ts">
import * as BusinessApi from '@/api/crm/business'
import * as ProductApi from '@/api/crm/product'
import { erpPriceInputFormatter, erpPriceMultiply } from '@/utils'
import { DICT_TYPE } from '@/utils/dict'

const { t } = useI18n()
const message = useMessage()

const props = withDefaults(
  defineProps<{
    products?: BusinessApi.BusinessProductVO[]
    disabled?: boolean
  }>(),
  { products: () => [], disabled: false }
)
const formLoading = ref(false)
const productsLoaded = ref(false)
const formData = ref<BusinessApi.BusinessProductVO[]>([])
const formRules = reactive({
  productId: [{ required: true, message: t('crm.business.productRequired'), trigger: 'change' }],
  businessPrice: [
    { required: true, message: t('crm.business.businessPriceRequired'), trigger: 'blur' }
  ],
  count: [{ required: true, message: t('crm.business.countRequired'), trigger: 'blur' }]
})
const formRef = ref()
const productList = ref<ProductApi.ProductVO[]>([])
// simple-list 后端只返回已启用产品，不在前端重复解释状态枚举值。
const availableProductList = computed(() => productList.value)

watch(
  () => props.products,
  (val) => {
    formData.value = val || []
  },
  { immediate: true }
)

watch(
  () => formData.value,
  (val) => {
    val.forEach((item) => {
      item.totalPrice =
        item.businessPrice != null && item.count != null
          ? erpPriceMultiply(item.businessPrice, item.count)
          : undefined
    })
  },
  { deep: true }
)

const isHistoricalUnavailable = (row: BusinessApi.BusinessProductVO) => {
  if (!productsLoaded.value || !row.productId || !row.id) return false
  return !availableProductList.value.some((item) => item.id === row.productId)
}

const isProductSelected = (productId: number, currentRow: BusinessApi.BusinessProductVO) =>
  formData.value.some((row) => row !== currentRow && row.productId === productId)

const handleAdd = () => {
  formData.value.push({
    productId: undefined as unknown as number,
    businessPrice: undefined as unknown as number,
    count: 1
  })
}

const handleDelete = (index: number) => {
  formData.value.splice(index, 1)
}

const clearProductSnapshot = (row: BusinessApi.BusinessProductVO) => {
  row.productId = undefined as unknown as number
  row.productName = undefined
  row.productUnit = undefined
  row.productNo = undefined
  row.productPrice = undefined
  row.businessPrice = undefined as unknown as number
  row.totalPrice = undefined
}

const onChangeProduct = (productId: number | undefined, row: BusinessApi.BusinessProductVO) => {
  if (!productId) {
    clearProductSnapshot(row)
    return
  }
  if (isProductSelected(productId, row)) {
    message.warning(t('crm.business.duplicateProduct'))
    clearProductSnapshot(row)
    return
  }
  const product = availableProductList.value.find((item) => item.id === productId)
  if (product) {
    row.productName = product.name
    row.productUnit = product.unit
    row.productNo = product.no
    row.productPrice = product.price
    row.businessPrice = product.price
  }
}

const validate = async () => {
  const ids = formData.value.map((item) => item.productId).filter(Boolean)
  if (new Set(ids).size !== ids.length) {
    message.warning(t('crm.business.duplicateProduct'))
    throw new Error('duplicate business product')
  }
  return await formRef.value?.validate()
}
defineExpose({ validate })

onMounted(async () => {
  formLoading.value = true
  try {
    productList.value = await ProductApi.getProductSimpleList()
  } finally {
    productsLoaded.value = true
    formLoading.value = false
  }
})
</script>
