import request from '@/config/axios'

export interface HighSeasRecordVO {
  id: number
  customerId: number
  actionType: string
  beforeOwnerUserId?: number
  beforeOwnerUserName?: string
  afterOwnerUserId?: number
  afterOwnerUserName?: string
  reason?: string
  operatorUserId: number
  operatorUserName?: string
  actionTime: string
}

export interface CustomerOwnerHistoryVO {
  id: number
  customerId: number
  changeType: string
  oldOwnerUserId?: number
  oldOwnerUserName?: string
  newOwnerUserId?: number
  newOwnerUserName?: string
  reason?: string
  operatorUserId: number
  operatorUserName?: string
  changeTime: string
}

export const getHighSeasRecordListByCustomer = (customerId: number) =>
  request.get<HighSeasRecordVO[]>({ url: '/crm/high-seas-record/list-by-customer', params: { customerId } })

export const getCustomerOwnerHistoryList = (customerId: number) =>
  request.get<CustomerOwnerHistoryVO[]>({ url: '/crm/customer-owner-history/list', params: { customerId } })
