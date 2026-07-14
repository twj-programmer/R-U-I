# GAP-007 阶段1：合同/订单映射与BPM审批集成 - API方案

> **任务来源**: 全CRM差异补齐任务分工与Git协同开发计划  
> **GAP编号**: GAP-007  
> **责任人**: 李祖豪（技术专员）  
> **设计日期**: 2026-07-14  
> **阶段**: S1 AISDD设计

---

## 一、API设计原则

| 原则 | 说明 |
|:---|:---|
| RESTful | 使用标准RESTful风格 |
| 统一响应 | 统一响应格式，包含code、data、msg |
| 版本控制 | API版本通过路径标识 |
| 权限控制 | 所有API需进行权限校验 |
| 参数校验 | 输入参数需进行校验 |
| 错误处理 | 统一错误码和错误信息 |

---

## 二、合同管理API

### 2.1 创建合同

| 项目 | 内容 |
|:---|:---|
| 路径 | `POST /crm/contract/create` |
| 权限 | `crm:contract:create` |
| 描述 | 创建合同/订单 |

**请求体**:
```json
{
    "name": "销售合同2026001",
    "no": "HT-2026-001",
    "customerId": 1,
    "businessId": 1,
    "ownerUserId": 1,
    "signContactId": 1,
    "signUserId": 1,
    "contractType": 1,
    "orderDate": "2026-07-14T10:00:00",
    "startTime": "2026-07-15T00:00:00",
    "endTime": "2026-12-31T23:59:59",
    "totalProductPrice": 10000.00,
    "discountPercent": 0.9,
    "totalPrice": 9000.00,
    "remark": "备注",
    "products": [
        {
            "productId": 1,
            "productPrice": 5000.00,
            "contractPrice": 4500.00,
            "count": 2,
            "totalPrice": 9000.00
        }
    ]
}
```

**响应体**:
```json
{
    "code": 0,
    "data": {
        "id": 1,
        "name": "销售合同2026001",
        "no": "HT-2026-001",
        "auditStatus": 0
    },
    "msg": "创建成功"
}
```

### 2.2 更新合同

| 项目 | 内容 |
|:---|:---|
| 路径 | `PUT /crm/contract/update` |
| 权限 | `crm:contract:update` |
| 描述 | 更新合同/订单 |

**请求体**:
```json
{
    "id": 1,
    "name": "销售合同2026001-修改",
    "customerId": 1,
    "contractType": 1
}
```

### 2.3 删除合同

| 项目 | 内容 |
|:---|:---|
| 路径 | `DELETE /crm/contract/delete` |
| 权限 | `crm:contract:delete` |
| 描述 | 删除合同/订单 |

**请求参数**:
| 参数 | 类型 | 必填 | 说明 |
|:---|:---|:---|:---|
| id | Long | 是 | 合同ID |

### 2.4 查询合同详情

| 项目 | 内容 |
|:---|:---|
| 路径 | `GET /crm/contract/get` |
| 权限 | `crm:contract:query` |
| 描述 | 查询合同详情 |

**请求参数**:
| 参数 | 类型 | 必填 | 说明 |
|:---|:---|:---|:---|
| id | Long | 是 | 合同ID |

**响应体**:
```json
{
    "code": 0,
    "data": {
        "id": 1,
        "name": "销售合同2026001",
        "no": "HT-2026-001",
        "customerId": 1,
        "customerName": "客户A",
        "businessId": 1,
        "businessName": "商机A",
        "ownerUserId": 1,
        "ownerUserName": "张三",
        "contractType": 1,
        "contractTypeName": "销售合同",
        "orderDate": "2026-07-14T10:00:00",
        "startTime": "2026-07-15T00:00:00",
        "endTime": "2026-12-31T23:59:59",
        "totalPrice": 9000.00,
        "auditStatus": 0,
        "auditStatusName": "草稿",
        "products": []
    },
    "msg": "成功"
}
```

### 2.5 分页查询合同

| 项目 | 内容 |
|:---|:---|
| 路径 | `GET /crm/contract/page` |
| 权限 | `crm:contract:query` |
| 描述 | 分页查询合同列表 |

**请求参数**:
| 参数 | 类型 | 必填 | 说明 |
|:---|:---|:---|:---|
| pageNo | Integer | 否 | 页码，默认1 |
| pageSize | Integer | 否 | 每页数量，默认10 |
| name | String | 否 | 合同名称（模糊查询） |
| no | String | 否 | 合同编号（模糊查询） |
| customerId | Long | 否 | 客户ID |
| contractType | Integer | 否 | 合同类型 |
| auditStatus | Integer | 否 | 审批状态 |
| ownerUserId | Long | 否 | 负责人ID |

---

## 三、合同审批API

### 3.1 提交审批

| 项目 | 内容 |
|:---|:---|
| 路径 | `PUT /crm/contract/submit` |
| 权限 | `crm:contract:update` |
| 描述 | 提交合同审批 |

**请求参数**:
| 参数 | 类型 | 必填 | 说明 |
|:---|:---|:---|:---|
| id | Long | 是 | 合同ID |

**响应体**:
```json
{
    "code": 0,
    "data": {
        "id": 1,
        "auditStatus": 10,
        "processInstanceId": "bpm-2026-001"
    },
    "msg": "提交成功"
}
```

### 3.2 撤回审批

| 项目 | 内容 |
|:---|:---|
| 路径 | `PUT /crm/contract/revoke` |
| 权限 | `crm:contract:update` |
| 描述 | 撤回合同审批 |

**请求参数**:
| 参数 | 类型 | 必填 | 说明 |
|:---|:---|:---|:---|
| id | Long | 是 | 合同ID |

### 3.3 查询审批进度

| 项目 | 内容 |
|:---|:---|
| 路径 | `GET /crm/contract/approval-progress` |
| 权限 | `crm:contract:query` |
| 描述 | 查询合同审批进度 |

**请求参数**:
| 参数 | 类型 | 必填 | 说明 |
|:---|:---|:---|:---|
| id | Long | 是 | 合同ID |

**响应体**:
```json
{
    "code": 0,
    "data": {
        "contractId": 1,
        "contractName": "销售合同2026001",
        "auditStatus": 10,
        "auditStatusName": "审批中",
        "processInstanceId": "bpm-2026-001",
        "steps": [
            {
                "step": 1,
                "name": "部门审批",
                "assignee": "李四",
                "status": "completed",
                "auditTime": "2026-07-14T11:00:00",
                "auditRemark": "同意"
            },
            {
                "step": 2,
                "name": "财务审批",
                "assignee": "王五",
                "status": "pending"
            }
        ]
    },
    "msg": "成功"
}
```

### 3.4 BPM回调更新审批状态

| 项目 | 内容 |
|:---|:---|
| 路径 | `POST /crm/contract/update-audit-status` |
| 权限 | 内部调用 |
| 描述 | BPM流程结束后回调更新合同审批状态 |

**请求体**:
```json
{
    "businessKey": "1",
    "processInstanceId": "bpm-2026-001",
    "result": 1,
    "remark": "审批通过",
    "auditTime": "2026-07-14T14:00:00"
}
```

**响应体**:
```json
{
    "code": 0,
    "data": null,
    "msg": "更新成功"
}
```

---

## 四、合同产品API

### 4.1 添加产品

| 项目 | 内容 |
|:---|:---|
| 路径 | `POST /crm/contract/product/add` |
| 权限 | `crm:contract:update` |
| 描述 | 为合同添加产品 |

**请求体**:
```json
{
    "contractId": 1,
    "productId": 1,
    "productPrice": 5000.00,
    "contractPrice": 4500.00,
    "count": 2,
    "totalPrice": 9000.00
}
```

### 4.2 删除产品

| 项目 | 内容 |
|:---|:---|
| 路径 | `DELETE /crm/contract/product/delete` |
| 权限 | `crm:contract:update` |
| 描述 | 删除合同产品 |

**请求参数**:
| 参数 | 类型 | 必填 | 说明 |
|:---|:---|:---|:---|
| id | Long | 是 | 产品ID |

---

## 五、API错误码

| 错误码 | 说明 |
|:---|:---|
| 1020005001 | 合同不存在 |
| 1020005002 | 合同已删除 |
| 1020005003 | 合同编号已存在 |
| 1020005004 | 客户不存在 |
| 1020005005 | 商机不存在 |
| 1020005006 | 负责人不存在 |
| 1020005007 | 产品不存在 |
| 1020005008 | 合同不是草稿状态，无法提交审批 |
| 1020005009 | 合同不在审批流程中，无法撤回 |
| 1020005010 | 合同不在审批流程中，无法更新审批结果 |
| 1020005011 | BPM流程创建失败 |
| 1020005012 | BPM流程取消失败 |

---

## 六、API权限矩阵

| API路径 | 方法 | 创建 | 查询 | 更新 | 删除 |
|:---|:---|:---|:---|:---|:---|
| `/crm/contract/create` | POST | ✅ | - | - | - |
| `/crm/contract/update` | PUT | - | - | ✅ | - |
| `/crm/contract/delete` | DELETE | - | - | - | ✅ |
| `/crm/contract/get` | GET | - | ✅ | - | - |
| `/crm/contract/page` | GET | - | ✅ | - | - |
| `/crm/contract/submit` | PUT | - | - | ✅ | - |
| `/crm/contract/revoke` | PUT | - | - | ✅ | - |
| `/crm/contract/approval-progress` | GET | - | ✅ | - | - |
| `/crm/contract/update-audit-status` | POST | - | - | ✅（内部） | - |
| `/crm/contract/product/add` | POST | - | - | ✅ | - |
| `/crm/contract/product/delete` | DELETE | - | - | - | ✅ |

---

**文档版本**: V1.0  
**创建日期**: 2026-07-14  
**责任人**: 李祖豪