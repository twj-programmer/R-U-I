// 23计科4班 黄金戈
import request from '@/config/axios'
import { TransferReqVO } from '@/api/crm/permission'

export interface BusinessProductVO {
  id?: number
  productId: number
  productName?: string
  productNo?: string
  productUnit?: number
  productPrice?: number
  businessPrice: number
  count: number
  totalPrice?: number
}

export interface BusinessVO {
  id: number
  name: string
  customerId: number
  customerName?: string
  followUpStatus: boolean
  contactLastTime: Date
  contactNextTime: Date
  ownerUserId: number
  ownerUserName?: string
  ownerUserDept?: string
  statusTypeId: number
  statusTypeName?: string
  statusId: number
  statusName?: string
  endStatus?: number
  loseReasonCode?: string
  endRemark?: string
  version: number
  dealTime: Date
  totalProductPrice: number
  totalPrice: number
  discountPercent: number
  remark: string
  creator: string
  creatorName?: string
  createTime: Date
  updateTime: Date
  products?: BusinessProductVO[]
}

export interface BusinessProductReqVO {
  productId: number
  businessPrice: number
  count: number
}

export interface BusinessCreateReqVO {
  name: string
  customerId: number
  ownerUserId: number
  statusTypeId: number
  dealTime?: Date
  discountPercent: number
  remark?: string
  contactId?: number
  products: BusinessProductReqVO[]
}

export interface BusinessUpdateReqVO {
  id: number
  version: number
  name: string
  customerId: number
  contactNextTime?: Date
  dealTime?: Date
  remark?: string
  contactId?: number
}

export interface BusinessUpdateStatusReqVO {
  id: number
  version: number
  statusId?: number
  endStatus?: number
  loseReasonCode?: string
  endRemark?: string
}

export interface BusinessStatusUpdateRespVO extends BusinessUpdateStatusReqVO {
  version: number
}

export interface BusinessUpdateQuotationReqVO {
  id: number
  version: number
  discountPercent: number
  products: BusinessProductReqVO[]
}

export interface BusinessQuotationRespVO {
  id: number
  version: number
  totalProductPrice: number
  discountPercent: number
  discountAmount: number
  totalPrice: number
  products: BusinessProductVO[]
}

export const getBusinessPage = async (params) => {
  return await request.get({ url: `/crm/business/page`, params })
}

export const getBusinessPageByCustomer = async (params) => {
  return await request.get({ url: `/crm/business/page-by-customer`, params })
}

export const getBusiness = async (id: number) => {
  return await request.get({ url: `/crm/business/get?id=` + id })
}

export const getSimpleBusinessList = async () => {
  return await request.get({ url: `/crm/business/simple-all-list` })
}

export const createBusiness = async (data: BusinessCreateReqVO) => {
  return await request.post({ url: `/crm/business/create`, data })
}

export const updateBusiness = async (data: BusinessUpdateReqVO) => {
  return await request.put({ url: `/crm/business/update`, data })
}

export const updateBusinessStatus = async (
  data: BusinessUpdateStatusReqVO
): Promise<BusinessStatusUpdateRespVO> => {
  return await request.put({ url: `/crm/business/update-status`, data })
}

export const updateBusinessQuotation = async (
  data: BusinessUpdateQuotationReqVO
): Promise<BusinessQuotationRespVO> => {
  return await request.put({ url: `/crm/business/update-quotation`, data })
}

export const deleteBusiness = async (id: number) => {
  return await request.delete({ url: `/crm/business/delete?id=` + id })
}

export const exportBusiness = async (params) => {
  return await request.download({ url: `/crm/business/export-excel`, params })
}

export const getBusinessPageByContact = async (params) => {
  return await request.get({ url: `/crm/business/page-by-contact`, params })
}

export const transferBusiness = async (data: TransferReqVO) => {
  return await request.put({ url: '/crm/business/transfer', data })
}
