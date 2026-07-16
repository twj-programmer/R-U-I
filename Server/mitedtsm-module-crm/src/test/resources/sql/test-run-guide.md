# CRM 测试底座运行说明

## 1. 环境要求

- JDK 21+
- Maven 3.9+
- Redis（单元测试使用端口 16379）

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

- 每个测试方法前自动执行 `clean.sql` 清理数据
- 使用 `@AfterEach` 调用 `testDataFactory.clearAll()` 确保数据隔离
- 使用 H2 内存数据库，测试间互不影响

## 5. 测试报告解读

### 5.1 测试结果输出格式

```
[INFO] Tests run: 26, Failures: 0, Errors: 0, Skipped: 0
[INFO] BUILD SUCCESS
```

### 5.2 失败处理

- 检查 H2 表定义是否与生产代码一致
- 检查 Redis 连接是否正常（端口 16379）
- 检查 `clean.sql` 是否包含所有需要清理的表

## 6. 测试用例清单

| 测试方法 | 描述 |
|---|---|
| `testCreateCustomer` | 创建客户测试 |
| `testCreateClue` | 创建线索测试 |
| `testCreateBusiness` | 创建商机测试 |
| `testCreateContract` | 创建合同测试 |
| `testCreateContact` | 创建联系人测试 |
| `testCreateCustomerPoolConfig` | 创建客户池配置测试 |
| `testCreateContactBusiness` | 创建联系人商机关联测试 |
| `testCreateBusinessProduct` | 创建商机产品关联测试 |
| `testCreateContractProduct` | 创建合同产品关联测试 |
| `testCreateReceivablePlan` | 创建回款计划测试 |
| `testCreateProductCategory` | 创建产品分类测试 |
| `testCreateProduct` | 创建产品测试 |
| `testCreatePermission` | 创建权限测试 |
| `testCreateLoseBusiness` | 创建流失商机测试 |
| `testDataCleanup` | 数据清理测试 |
| `testDataIsolation` | 数据隔离测试 |
| `testTenantIsolation` | 租户隔离测试 |
| `testNullTenantId` | 空租户ID边界测试 |
| `testNullOwnerUserId` | 空负责人ID边界测试 |
| `testEmptyCustomerName` | 空客户名称边界测试 |
| `testEmptyClueName` | 空线索名称边界测试 |
| `testEmptyBusinessName` | 空商机名称边界测试 |
| `testEmptyContractName` | 空合同名称边界测试 |
| `testEmptyContactName` | 空联系人名称边界测试 |
| `testEmptyProductName` | 空产品名称边界测试 |
| `testClearAll` | 清空所有数据测试 |

## 7. 测试表清单

| 表名 | 用途 |
|---|---|
| `crm_customer` | 客户表 |
| `crm_clue` | 线索表 |
| `crm_business` | 商机表 |
| `crm_contract` | 合同表 |
| `crm_contact` | 联系人表 |
| `crm_customer_pool_config` | 客户池配置表 |
| `crm_contact_business` | 联系人商机关联表 |
| `crm_business_product` | 商机产品关联表 |
| `crm_contract_product` | 合同产品关联表 |
| `crm_receivable_plan` | 回款计划表 |
| `crm_product_category` | 产品分类表 |
| `crm_product` | 产品表 |
| `crm_permission` | 权限表 |
| `sys_user` | 用户表 |
| `sys_dept` | 部门表 |
| `sys_role` | 角色表 |