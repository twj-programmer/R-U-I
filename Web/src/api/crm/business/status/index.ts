// 23计科4班 黄金戈
import request from '@/config/axios'

export interface BusinessStatusVO {
  id: number
  name: string
  percent: number
  sort: number
}

export interface BusinessStatusTypeVO {
  id: number
  name: string
  deptIds: number[]
  statuses?: BusinessStatusVO[]
}

export const DEFAULT_STATUSES = [
  { endStatus: 1, key: 'end', name: '赢单', percent: 100 },
  { endStatus: 2, key: 'end', name: '输单', percent: 0 },
  { endStatus: 3, key: 'end', name: '无效', percent: 0 }
]

export const getBusinessStatusPage = async (params: any) => {
  return await request.get({ url: `/crm/business-status/page`, params })
}

export const createBusinessStatus = async (data: BusinessStatusTypeVO) => {
  return await request.post({ url: `/crm/business-status/create`, data })
}

export const updateBusinessStatus = async (data: BusinessStatusTypeVO) => {
  return await request.put({ url: `/crm/business-status/update`, data })
}

export const getBusinessStatus = async (id: number) => {
  return await request.get({ url: `/crm/business-status/get?id=` + id })
}

export const deleteBusinessStatus = async (id: number) => {
  return await request.delete({ url: `/crm/business-status/delete?id=` + id })
}

export const getBusinessStatusTypeSimpleList = async () => {
  return await request.get({ url: `/crm/business-status/type-simple-list` })
}

export const getBusinessStatusSimpleList = async (
  typeId: number
): Promise<BusinessStatusVO[]> => {
  return await request.get({ url: `/crm/business-status/status-simple-list`, params: { typeId } })
}
