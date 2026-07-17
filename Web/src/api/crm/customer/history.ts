import request from '@/config/axios'

export interface HighSeasRecordVO {
  id: number
  customerId: number
  actionType: string
  beforeOwnerUserId?: number
  afterOwnerUserId?: number
  reason?: string
  operatorUserId: number
  actionTime: string
}

export interface CustomerOwnerHistoryVO {
  id: number
  customerId: number
  changeType: string
  oldOwnerUserId?: number
  newOwnerUserId?: number
  reason?: string
  operatorUserId: number
  changeTime: string
}

export const getHighSeasRecordListByCustomer = (customerId: number) =>
  request.get<HighSeasRecordVO[]>({ url: '/crm/high-seas-record/list-by-customer', params: { customerId } })

export const getCustomerOwnerHistoryList = (customerId: number) =>
  request.get<CustomerOwnerHistoryVO[]>({ url: '/crm/customer-owner-history/list', params: { customerId } })
