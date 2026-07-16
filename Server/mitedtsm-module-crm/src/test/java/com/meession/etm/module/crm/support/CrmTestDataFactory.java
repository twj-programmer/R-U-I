package com.meession.etm.module.crm.support;

import com.meession.etm.framework.mybatis.core.dataobject.BaseDO;
import com.meession.etm.framework.tenant.core.util.TenantUtils;
import com.meession.etm.module.crm.dal.dataobject.business.CrmBusinessDO;
import com.meession.etm.module.crm.dal.dataobject.business.CrmBusinessProductDO;
import com.meession.etm.module.crm.dal.dataobject.business.CrmBusinessStatusDO;
import com.meession.etm.module.crm.dal.dataobject.business.CrmBusinessStatusTypeDO;
import com.meession.etm.module.crm.dal.dataobject.clue.CrmClueDO;
import com.meession.etm.module.crm.dal.dataobject.contact.CrmContactBusinessDO;
import com.meession.etm.module.crm.dal.dataobject.contact.CrmContactDO;
import com.meession.etm.module.crm.dal.dataobject.contract.CrmContractDO;
import com.meession.etm.module.crm.dal.dataobject.contract.CrmContractProductDO;
import com.meession.etm.module.crm.dal.dataobject.customer.CrmCustomerDO;
import com.meession.etm.module.crm.dal.dataobject.customer.CrmCustomerLimitConfigDO;
import com.meession.etm.module.crm.dal.dataobject.customer.CrmCustomerPoolConfigDO;
import com.meession.etm.module.crm.dal.dataobject.followup.CrmFollowUpRecordDO;
import com.meession.etm.module.crm.dal.dataobject.permission.CrmPermissionDO;
import com.meession.etm.module.crm.dal.dataobject.product.CrmProductCategoryDO;
import com.meession.etm.module.crm.dal.dataobject.product.CrmProductDO;
import com.meession.etm.module.crm.dal.dataobject.receivable.CrmReceivableDO;
import com.meession.etm.module.crm.dal.dataobject.receivable.CrmReceivablePlanDO;
import com.meession.etm.module.crm.dal.mysql.business.CrmBusinessMapper;
import com.meession.etm.module.crm.dal.mysql.business.CrmBusinessProductMapper;
import com.meession.etm.module.crm.dal.mysql.business.CrmBusinessStatusMapper;
import com.meession.etm.module.crm.dal.mysql.business.CrmBusinessStatusTypeMapper;
import com.meession.etm.module.crm.dal.mysql.clue.CrmClueMapper;
import com.meession.etm.module.crm.dal.mysql.contact.CrmContactBusinessMapper;
import com.meession.etm.module.crm.dal.mysql.contact.CrmContactMapper;
import com.meession.etm.module.crm.dal.mysql.contract.CrmContractMapper;
import com.meession.etm.module.crm.dal.mysql.contract.CrmContractProductMapper;
import com.meession.etm.module.crm.dal.mysql.customer.CrmCustomerLimitConfigMapper;
import com.meession.etm.module.crm.dal.mysql.customer.CrmCustomerPoolConfigMapper;
import com.meession.etm.module.crm.dal.mysql.customer.CrmCustomerMapper;
import com.meession.etm.module.crm.dal.mysql.followup.CrmFollowUpRecordMapper;
import com.meession.etm.module.crm.dal.mysql.permission.CrmPermissionMapper;
import com.meession.etm.module.crm.dal.mysql.product.CrmProductCategoryMapper;
import com.meession.etm.module.crm.dal.mysql.product.CrmProductMapper;
import com.meession.etm.module.crm.dal.mysql.receivable.CrmReceivableMapper;
import com.meession.etm.module.crm.dal.mysql.receivable.CrmReceivablePlanMapper;
import jakarta.annotation.Resource;
import org.springframework.stereotype.Component;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.concurrent.atomic.AtomicLong;

@Component
public class CrmTestDataFactory {

    @Resource
    private CrmTestMapper testMapper;
    @Resource
    private CrmCustomerMapper customerMapper;
    @Resource
    private CrmClueMapper clueMapper;
    @Resource
    private CrmBusinessMapper businessMapper;
    @Resource
    private CrmBusinessProductMapper businessProductMapper;
    @Resource
    private CrmBusinessStatusTypeMapper businessStatusTypeMapper;
    @Resource
    private CrmBusinessStatusMapper businessStatusMapper;
    @Resource
    private CrmContractMapper contractMapper;
    @Resource
    private CrmContractProductMapper contractProductMapper;
    @Resource
    private CrmReceivableMapper receivableMapper;
    @Resource
    private CrmReceivablePlanMapper receivablePlanMapper;
    @Resource
    private CrmContactMapper contactMapper;
    @Resource
    private CrmContactBusinessMapper contactBusinessMapper;
    @Resource
    private CrmFollowUpRecordMapper followUpRecordMapper;
    @Resource
    private CrmCustomerPoolConfigMapper customerPoolConfigMapper;
    @Resource
    private CrmCustomerLimitConfigMapper customerLimitConfigMapper;
    @Resource
    private CrmProductCategoryMapper productCategoryMapper;
    @Resource
    private CrmProductMapper productMapper;
    @Resource
    private CrmPermissionMapper permissionMapper;

    private static final AtomicLong ID_GENERATOR = new AtomicLong(1000);
    private static final String TEST_CREATOR = "1";

    private Long nextId() {
        return ID_GENERATOR.incrementAndGet();
    }

    private void validateTenantId(Long tenantId) {
        if (tenantId == null) {
            throw new IllegalArgumentException("tenantId cannot be null");
        }
    }

    private void setBaseFields(BaseDO baseDO) {
        LocalDateTime now = LocalDateTime.now();
        baseDO.setCreateTime(now);
        baseDO.setUpdateTime(now);
        baseDO.setCreator(TEST_CREATOR);
        baseDO.setUpdater(TEST_CREATOR);
    }

    public CrmCustomerDO createCustomer(Long tenantId) {
        return createCustomer(tenantId, null);
    }

    public CrmCustomerDO createCustomer(Long tenantId, String name) {
        validateTenantId(tenantId);
        Long id = nextId();
        String customerName = name != null ? name : "测试客户" + System.currentTimeMillis();
        LocalDateTime now = LocalDateTime.now();
        return TenantUtils.execute(tenantId, () -> {
            testMapper.insertCustomer(id, customerName, false, 1L, now, false, false,
                    "13800138000", "021-88888888", "test@example.com", 1, 1, 1,
                    TEST_CREATOR, now, TEST_CREATOR, now, false, tenantId);
            return customerMapper.selectById(id);
        });
    }

    public CrmCustomerDO createCustomerInPool(Long tenantId) {
        validateTenantId(tenantId);
        CrmCustomerDO customer = createCustomer(tenantId);
        return TenantUtils.execute(tenantId, () -> {
            customer.setOwnerUserId(null);
            customerMapper.updateById(customer);
            return customer;
        });
    }

    public List<CrmCustomerDO> createCustomers(Long tenantId, int count) {
        validateTenantId(tenantId);
        List<CrmCustomerDO> customers = new ArrayList<>();
        for (int i = 0; i < count; i++) {
            customers.add(createCustomer(tenantId, "测试客户" + i));
        }
        return customers;
    }

    public CrmClueDO createClue(Long tenantId) {
        return createClue(tenantId, null);
    }

    public CrmClueDO createClue(Long tenantId, String name) {
        validateTenantId(tenantId);
        Long id = nextId();
        String clueName = name != null ? name : "测试线索" + System.currentTimeMillis();
        LocalDateTime now = LocalDateTime.now();
        return TenantUtils.execute(tenantId, () -> {
            testMapper.insertClue(id, clueName, false, 1L, false,
                    "13900139000", "021-99999999", "clue@example.com", 1, 1, 1,
                    TEST_CREATOR, now, TEST_CREATOR, now, false, tenantId);
            return clueMapper.selectById(id);
        });
    }

    public CrmClueDO createClueWithCustomer(Long tenantId, Long customerId) {
        validateTenantId(tenantId);
        CrmClueDO clue = createClue(tenantId);
        return TenantUtils.execute(tenantId, () -> {
            clue.setTransformStatus(true);
            clue.setCustomerId(customerId);
            clueMapper.updateById(clue);
            return clue;
        });
    }

    public CrmBusinessStatusTypeDO createBusinessStatusType(Long tenantId) {
        validateTenantId(tenantId);
        CrmBusinessStatusTypeDO type = CrmBusinessStatusTypeDO.builder()
                .id(nextId())
                .name("测试状态组")
                .deptIds(new java.util.ArrayList<>())
                .build();
        setBaseFields(type);
        return TenantUtils.execute(tenantId, () -> {
            businessStatusTypeMapper.insert(type);
            return type;
        });
    }

    public CrmBusinessStatusDO createBusinessStatus(Long tenantId, Long typeId) {
        validateTenantId(tenantId);
        CrmBusinessStatusDO status = CrmBusinessStatusDO.builder()
                .id(nextId())
                .typeId(typeId)
                .name("测试状态")
                .percent(20)
                .sort(1)
                .build();
        setBaseFields(status);
        return TenantUtils.execute(tenantId, () -> {
            businessStatusMapper.insert(status);
            return status;
        });
    }

    public CrmBusinessDO createBusiness(Long tenantId, Long customerId) {
        return createBusiness(tenantId, customerId, null);
    }

    public CrmBusinessDO createBusiness(Long tenantId, Long customerId, Integer endStatus) {
        validateTenantId(tenantId);
        CrmBusinessStatusTypeDO type = createBusinessStatusType(tenantId);
        CrmBusinessStatusDO status = createBusinessStatus(tenantId, type.getId());

        CrmBusinessDO business = CrmBusinessDO.builder()
                .id(nextId())
                .name("测试商机" + System.currentTimeMillis())
                .customerId(customerId)
                .followUpStatus(false)
                .ownerUserId(1L)
                .statusTypeId(type.getId())
                .statusId(status.getId())
                .endStatus(endStatus)
                .dealTime(LocalDateTime.now().plusDays(30))
                .totalProductPrice(BigDecimal.valueOf(10000))
                .discountPercent(BigDecimal.valueOf(0))
                .totalPrice(BigDecimal.valueOf(10000))
                .build();
        setBaseFields(business);
        return TenantUtils.execute(tenantId, () -> {
            businessMapper.insert(business);
            return business;
        });
    }

    public CrmBusinessDO createWinBusiness(Long tenantId, Long customerId) {
        validateTenantId(tenantId);
        return createBusiness(tenantId, customerId, 1);
    }

    public CrmBusinessDO createLoseBusiness(Long tenantId, Long customerId) {
        validateTenantId(tenantId);
        CrmBusinessDO business = createBusiness(tenantId, customerId, 2);
        return TenantUtils.execute(tenantId, () -> {
            business.setEndRemark("输单原因测试");
            businessMapper.updateById(business);
            return business;
        });
    }

    public CrmContractDO createContract(Long tenantId, Long customerId, Long businessId) {
        return createContract(tenantId, customerId, businessId, 0);
    }

    public CrmContractDO createContract(Long tenantId, Long customerId, Long businessId, Integer auditStatus) {
        validateTenantId(tenantId);
        CrmContractDO contract = CrmContractDO.builder()
                .id(nextId())
                .name("测试合同" + System.currentTimeMillis())
                .no("HT" + System.currentTimeMillis())
                .customerId(customerId)
                .businessId(businessId)
                .ownerUserId(1L)
                .auditStatus(auditStatus)
                .totalProductPrice(BigDecimal.valueOf(10000))
                .discountPercent(BigDecimal.valueOf(0))
                .totalPrice(BigDecimal.valueOf(10000))
                .build();
        setBaseFields(contract);
        return TenantUtils.execute(tenantId, () -> {
            contractMapper.insert(contract);
            return contract;
        });
    }

    public CrmContractDO createContractWithProcess(Long tenantId, Long customerId, Long businessId) {
        validateTenantId(tenantId);
        CrmContractDO contract = createContract(tenantId, customerId, businessId, 10);
        return TenantUtils.execute(tenantId, () -> {
            contract.setProcessInstanceId("test-process-id-" + System.currentTimeMillis());
            contractMapper.updateById(contract);
            return contract;
        });
    }

    public CrmReceivableDO createReceivable(Long tenantId, Long contractId, Long customerId) {
        return createReceivable(tenantId, contractId, customerId, 0);
    }

    public CrmReceivableDO createReceivable(Long tenantId, Long contractId, Long customerId, Integer auditStatus) {
        validateTenantId(tenantId);
        CrmReceivableDO receivable = CrmReceivableDO.builder()
                .id(nextId())
                .no("HK" + System.currentTimeMillis())
                .contractId(contractId)
                .customerId(customerId)
                .ownerUserId(1L)
                .auditStatus(auditStatus)
                .returnTime(LocalDateTime.now())
                .returnType(1)
                .price(BigDecimal.valueOf(5000))
                .build();
        setBaseFields(receivable);
        return TenantUtils.execute(tenantId, () -> {
            receivableMapper.insert(receivable);
            return receivable;
        });
    }

    public CrmContactDO createContact(Long tenantId, Long customerId) {
        validateTenantId(tenantId);
        CrmContactDO contact = CrmContactDO.builder()
                .id(nextId())
                .name("测试联系人" + System.currentTimeMillis())
                .customerId(customerId)
                .ownerUserId(1L)
                .mobile("13700137000")
                .telephone("021-77777777")
                .email("contact@example.com")
                .sex(1)
                .master(false)
                .post("经理")
                .build();
        setBaseFields(contact);
        return TenantUtils.execute(tenantId, () -> {
            contactMapper.insert(contact);
            return contact;
        });
    }

    public CrmFollowUpRecordDO createFollowUpRecord(Long tenantId, Integer bizType, Long bizId) {
        validateTenantId(tenantId);
        CrmFollowUpRecordDO record = CrmFollowUpRecordDO.builder()
                .id(nextId())
                .bizType(bizType)
                .bizId(bizId)
                .type(1)
                .content("测试跟进内容")
                .nextTime(LocalDateTime.now().plusDays(7))
                .build();
        setBaseFields(record);
        return TenantUtils.execute(tenantId, () -> {
            followUpRecordMapper.insert(record);
            return record;
        });
    }

    public CrmCustomerPoolConfigDO createCustomerPoolConfig(Long tenantId) {
        validateTenantId(tenantId);
        CrmCustomerPoolConfigDO config = CrmCustomerPoolConfigDO.builder()
                .id(nextId())
                .enabled(true)
                .contactExpireDays(30)
                .dealExpireDays(60)
                .notifyEnabled(true)
                .notifyDays(3)
                .build();
        setBaseFields(config);
        return TenantUtils.execute(tenantId, () -> {
            customerPoolConfigMapper.insert(config);
            return config;
        });
    }

    public CrmCustomerLimitConfigDO createCustomerLimitConfig(Long tenantId) {
        validateTenantId(tenantId);
        CrmCustomerLimitConfigDO config = CrmCustomerLimitConfigDO.builder()
                .id(nextId())
                .type(1)
                .maxCount(100)
                .dealCountEnabled(false)
                .build();
        setBaseFields(config);
        return TenantUtils.execute(tenantId, () -> {
            customerLimitConfigMapper.insert(config);
            return config;
        });
    }

    public CrmProductCategoryDO createProductCategory(Long tenantId) {
        validateTenantId(tenantId);
        CrmProductCategoryDO category = CrmProductCategoryDO.builder()
                .id(nextId())
                .name("测试分类")
                .parentId(0L)
                .build();
        setBaseFields(category);
        return TenantUtils.execute(tenantId, () -> {
            productCategoryMapper.insert(category);
            return category;
        });
    }

    public CrmProductDO createProduct(Long tenantId, Long categoryId) {
        validateTenantId(tenantId);
        CrmProductDO product = CrmProductDO.builder()
                .id(nextId())
                .name("测试产品" + System.currentTimeMillis())
                .no("PRD" + System.currentTimeMillis())
                .unit(1)
                .price(BigDecimal.valueOf(100))
                .status(1)
                .categoryId(categoryId)
                .ownerUserId(1L)
                .build();
        setBaseFields(product);
        return TenantUtils.execute(tenantId, () -> {
            productMapper.insert(product);
            return product;
        });
    }

    public CrmBusinessProductDO createBusinessProduct(Long tenantId, Long businessId, Long productId) {
        validateTenantId(tenantId);
        CrmBusinessProductDO bp = CrmBusinessProductDO.builder()
                .id(nextId())
                .businessId(businessId)
                .productId(productId)
                .productPrice(BigDecimal.valueOf(100))
                .businessPrice(BigDecimal.valueOf(90))
                .count(BigDecimal.valueOf(10))
                .totalPrice(BigDecimal.valueOf(900))
                .build();
        setBaseFields(bp);
        return TenantUtils.execute(tenantId, () -> {
            businessProductMapper.insert(bp);
            return bp;
        });
    }

    public CrmContractProductDO createContractProduct(Long tenantId, Long contractId, Long productId) {
        validateTenantId(tenantId);
        CrmContractProductDO cp = CrmContractProductDO.builder()
                .id(nextId())
                .contractId(contractId)
                .productId(productId)
                .productPrice(BigDecimal.valueOf(100))
                .contractPrice(BigDecimal.valueOf(80))
                .count(BigDecimal.valueOf(10))
                .totalPrice(BigDecimal.valueOf(800))
                .build();
        setBaseFields(cp);
        return TenantUtils.execute(tenantId, () -> {
            contractProductMapper.insert(cp);
            return cp;
        });
    }

    public CrmReceivablePlanDO createReceivablePlan(Long tenantId, Long contractId, Long customerId) {
        validateTenantId(tenantId);
        CrmReceivablePlanDO plan = CrmReceivablePlanDO.builder()
                .id(nextId())
                .period(1)
                .customerId(customerId)
                .contractId(contractId)
                .ownerUserId(1L)
                .returnTime(LocalDateTime.now().plusDays(30))
                .returnType(1)
                .price(BigDecimal.valueOf(5000))
                .remindDays(3)
                .build();
        setBaseFields(plan);
        return TenantUtils.execute(tenantId, () -> {
            receivablePlanMapper.insert(plan);
            return plan;
        });
    }

    public CrmContactBusinessDO createContactBusiness(Long tenantId, Long contactId, Long businessId) {
        validateTenantId(tenantId);
        CrmContactBusinessDO cb = CrmContactBusinessDO.builder()
                .id(nextId())
                .contactId(contactId)
                .businessId(businessId)
                .build();
        setBaseFields(cb);
        return TenantUtils.execute(tenantId, () -> {
            contactBusinessMapper.insert(cb);
            return cb;
        });
    }

    public CrmPermissionDO createPermission(Long tenantId, Integer bizType, Long bizId, Long userId) {
        validateTenantId(tenantId);
        CrmPermissionDO permission = CrmPermissionDO.builder()
                .id(nextId())
                .bizType(bizType)
                .bizId(bizId)
                .userId(userId)
                .level(1)
                .build();
        setBaseFields(permission);
        return TenantUtils.execute(tenantId, () -> {
            permissionMapper.insert(permission);
            return permission;
        });
    }

    public void clearAll() {
        TenantUtils.executeIgnore(() -> {
            followUpRecordMapper.delete(null);
            contactBusinessMapper.delete(null);
            businessProductMapper.delete(null);
            contractProductMapper.delete(null);
            receivablePlanMapper.delete(null);
            receivableMapper.delete(null);
            contractMapper.delete(null);
            businessMapper.delete(null);
            businessStatusMapper.delete(null);
            businessStatusTypeMapper.delete(null);
            contactMapper.delete(null);
            clueMapper.delete(null);
            productMapper.delete(null);
            productCategoryMapper.delete(null);
            permissionMapper.delete(null);
            customerMapper.delete(null);
            customerPoolConfigMapper.delete(null);
            customerLimitConfigMapper.delete(null);
        });
    }

    public long getCustomerCount(Long tenantId) {
        return TenantUtils.execute(tenantId, () -> customerMapper.selectCount(null));
    }

    public long getClueCount(Long tenantId) {
        return TenantUtils.execute(tenantId, () -> clueMapper.selectCount(null));
    }

    public long getBusinessCount(Long tenantId) {
        return TenantUtils.execute(tenantId, () -> businessMapper.selectCount(null));
    }

    public long getContractCount(Long tenantId) {
        return TenantUtils.execute(tenantId, () -> contractMapper.selectCount(null));
    }

    public long getReceivableCount(Long tenantId) {
        return TenantUtils.execute(tenantId, () -> receivableMapper.selectCount(null));
    }
}