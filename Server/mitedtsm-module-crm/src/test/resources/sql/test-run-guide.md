# CRM 测试底座运行说明

## 1. 环境要求

- JDK 17
- Maven 3.9+

## 2. 运行命令

### 2.1 运行测试底座验证

```bash
cd Server/mitedtsm-module-crm
mvn test -Dtest=CrmTestSupportTest
```

### 2.2 连续运行两次验证稳定性

```bash
mvn test -Dtest=CrmTestSupportTest
mvn test -Dtest=CrmTestSupportTest
```

### 2.3 运行所有 CRM 测试

```bash
mvn test
```

## 3. 测试数据工厂使用方式

各业务任务在自己的测试类中注入 `CrmTestDataFactory`：

```java
@Resource
private CrmTestDataFactory testDataFactory;

@Test
void testMyFeature() {
    CrmCustomerDO customer = testDataFactory.createCustomer(1L);
    // 使用测试数据...
}
```

## 4. 测试隔离机制

- 每个测试方法后自动执行 `clean.sql` 清理数据
- 使用 `@AfterEach` 调用 `testDataFactory.clearAll()` 确保数据隔离
- 使用 H2 内存数据库，测试间互不影响
- 使用 `BaseDbUnitTest` 统一测试基类，不依赖外部数据库或网络服务

## 5. 测试报告解读

### 5.1 测试结果输出格式

```
[INFO] Tests run: 31, Failures: 0, Errors: 0, Skipped: 0
[INFO] BUILD SUCCESS
```

### 5.2 失败处理

- 检查 H2 表定义是否与生产代码一致
- 检查 `clean.sql` 是否包含所有需要清理的表
- 检查测试数据工厂的 tenantId 设置是否正确

## 6. 测试用例清单

| 测试方法 | 描述 |
|---|---|
| `testCreateCustomer` | 创建客户测试 |
| `testCreateCustomersBatch` | 批量创建客户测试 |
| `testCreateCustomerInPool` | 创建公海客户测试 |
| `testCreateClue` | 创建线索测试 |
| `testCreateClueWithCustomer` | 创建关联客户的线索测试 |
| `testCreateBusiness` | 创建商机测试 |
| `testCreateWinBusiness` | 创建赢单商机测试 |
| `testCreateLoseBusiness` | 创建输单商机测试 |
| `testCreateContract` | 创建合同测试 |
| `testCreateContractWithProcess` | 创建带流程实例的合同测试 |
| `testCreateReceivable` | 创建回款测试 |
| `testCreateContact` | 创建联系人测试 |
| `testCreateFollowUpRecord` | 创建跟进记录测试 |
| `testCreateCustomerPoolConfig` | 创建客户池配置测试 |
| `testCreateCustomerLimitConfig` | 创建客户限制配置测试 |
| `testCreateProductCategory` | 创建产品分类测试 |
| `testCreateProduct` | 创建产品测试 |
| `testCreateBusinessProduct` | 创建商机产品关联测试 |
| `testCreateContractProduct` | 创建合同产品关联测试 |
| `testCreateReceivablePlan` | 创建回款计划测试 |
| `testCreateContactBusiness` | 创建联系人商机关联测试 |
| `testCreatePermission` | 创建权限测试 |
| `testTenantIsolation` | 租户隔离测试 |
| `testTenantIsolationAcrossMultipleEntities` | 多实体租户隔离测试 |
| `testNullTenantId` | 空租户ID边界测试 |
| `testEmptyCustomerName` | 空客户名称边界测试 |
| `testNullCustomerName` | 空客户名称默认值测试 |
| `testEmptyClueName` | 空线索名称边界测试 |
| `testDataCleanup` | 数据清理测试 |
| `testIdUniqueness` | ID唯一性测试 |
| `testDataJsonSerialization` | JSON序列化测试 |

## 7. 测试表清单

| 表名 | 用途 |
|---|---|
| `crm_customer` | 客户表 |
| `crm_clue` | 线索表 |
| `crm_business` | 商机表 |
| `crm_business_status_type` | 商机状态类型表 |
| `crm_business_status` | 商机状态表 |
| `crm_contract` | 合同表 |
| `crm_receivable` | 回款表 |
| `crm_contact` | 联系人表 |
| `crm_follow_up_record` | 跟进记录表 |
| `crm_customer_pool_config` | 客户池配置表 |
| `crm_customer_limit_config` | 客户限制配置表 |
| `crm_contact_business` | 联系人商机关联表 |
| `crm_business_product` | 商机产品关联表 |
| `crm_contract_product` | 合同产品关联表 |
| `crm_receivable_plan` | 回款计划表 |
| `crm_product_category` | 产品分类表 |
| `crm_product` | 产品表 |
| `crm_permission` | 权限表 |

## 8. 租户隔离说明

测试数据工厂支持租户隔离：

1. 创建数据时传入 `tenantId` 参数，数据会自动关联到对应租户
2. 计数方法（`getCustomerCount`、`getClueCount` 等）会按租户过滤
3. 不同租户的数据互相隔离，查询时只能看到本租户的数据