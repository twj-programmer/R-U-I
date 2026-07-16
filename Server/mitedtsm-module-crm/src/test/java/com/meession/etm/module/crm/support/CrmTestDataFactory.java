package com.meession.etm.module.crm.support;

import com.meession.etm.framework.mybatis.core.dataobject.BaseDO;
import com.meession.etm.module.crm.dal.dataobject.business.CrmBusinessDO;
import com.meession.etm.module.crm.dal.dataobject.business.CrmBusinessStatusDO;
import com.meession.etm.module.crm.dal.dataobject.business.CrmBusinessStatusTypeDO;
import com.meession.etm.module.crm.dal.dataobject.clue.CrmClueDO;
import com.meession.etm.module.crm.dal.dataobject.contact.CrmContactDO;
import com.meession.etm.module.crm.dal.dataobject.contract.CrmContractDO;
import com.meession.etm.module.crm.dal.dataobject.customer.CrmCustomerDO;
import com.meession.etm.module.crm.dal.dataobject.customer.CrmCustomerLimitConfigDO;
import com.meession.etm.module.crm.dal.dataobject.customer.CrmCustomerPoolConfigDO;
import com.meession.etm.module.crm.dal.dataobject.followup.CrmFollowUpRecordDO;
import com.meession.etm.module.crm.dal.dataobject.receivable.CrmReceivableDO;
import com.meession.etm.module.crm.dal.mysql.business.CrmBusinessMapper;
import com.meession.etm.module.crm.dal.mysql.business.CrmBusinessStatusMapper;
import com.meession.etm.module.crm.dal.mysql.business.CrmBusinessStatusTypeMapper;
import com.meession.etm.module.crm.dal.mysql.clue.CrmClueMapper;
import com.meession.etm.module.crm.dal.mysql.contact.CrmContactMapper;
import com.meession.etm.module.crm.dal.mysql.contract.CrmContractMapper;
import com.meession.etm.module.crm.dal.mysql.customer.CrmCustomerLimitConfigMapper;
import com.meession.etm.module.crm.dal.mysql.customer.CrmCustomerPoolConfigMapper;
import com.meession.etm.module.crm.dal.mysql.customer.CrmCustomerMapper;
import com.meession.etm.module.crm.dal.mysql.followup.CrmFollowUpRecordMapper;
import com.meession.etm.module.crm.dal.mysql.receivable.CrmReceivableMapper;
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
    private CrmCustomerMapper customerMapper;
    @Resource
    private CrmClueMapper clueMapper;
    @Resource
    private CrmBusinessMapper businessMapper;
    @Resource
    private CrmBusinessStatusTypeMapper businessStatusTypeMapper;
    @Resource
    private CrmBusinessStatusMapper businessStatusMapper;
    @Resource
    private CrmContractMapper contractMapper;
    @Resource
    private CrmReceivableMapper receivableMapper;
    @Resource
    private CrmContactMapper contactMapper;
    @Resource
    private CrmFollowUpRecordMapper followUpRecordMapper;
    @Resource
    private CrmCustomerPoolConfigMapper customerPoolConfigMapper;
    @Resource
    private CrmCustomerLimitConfigMapper customerLimitConfigMapper;

    private static final AtomicLong ID_GENERATOR = new AtomicLong(1000);
    private static final String TEST_CREATOR = "1";

    private Long nextId() {
        return ID_GENERATOR.incrementAndGet();
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
        CrmCustomerDO customer = CrmCustomerDO.builder()
                .id(nextId())
                .name(name != null ? name : "测试客户" + System.currentTimeMillis())
                .followUpStatus(false)
                .ownerUserId(1L)
                .ownerTime(LocalDateTime.now())
                .lockStatus(false)
                .dealStatus(false)
                .mobile("13800138000")
                .telephone("021-88888888")
                .email("test@example.com")
                .industryId(1)
                .level(1)
                .source(1)
                .build();
        setBaseFields(customer);
        customerMapper.insert(customer);
        return customer;
    }

    public CrmCustomerDO createCustomerInPool(Long tenantId) {
        CrmCustomerDO customer = createCustomer(tenantId);
        customer.setOwnerUserId(null);
        customerMapper.updateById(customer);
        return customer;
    }

    public List<CrmCustomerDO> createCustomers(Long tenantId, int count) {
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
        CrmClueDO clue = CrmClueDO.builder()
                .id(nextId())
                .name(name != null ? name : "测试线索" + System.currentTimeMillis())
                .followUpStatus(false)
                .ownerUserId(1L)
                .transformStatus(false)
                .mobile("13900139000")
                .telephone("021-99999999")
                .email("clue@example.com")
                .industryId(1)
                .level(1)
                .source(1)
                .build();
        setBaseFields(clue);
        clueMapper.insert(clue);
        return clue;
    }

    public CrmClueDO createClueWithCustomer(Long tenantId, Long customerId) {
        CrmClueDO clue = createClue(tenantId);
        clue.setTransformStatus(true);
        clue.setCustomerId(customerId);
        clueMapper.updateById(clue);
        return clue;
    }

    public CrmBusinessStatusTypeDO createBusinessStatusType(Long tenantId) {
        CrmBusinessStatusTypeDO type = CrmBusinessStatusTypeDO.builder()
                .id(nextId())
                .name("测试状态组")
                .deptIds(new java.util.ArrayList<>())
                .build();
        setBaseFields(type);
        businessStatusTypeMapper.insert(type);
        return type;
    }

    public CrmBusinessStatusDO createBusinessStatus(Long tenantId, Long typeId) {
        CrmBusinessStatusDO status = CrmBusinessStatusDO.builder()
                .id(nextId())
                .typeId(typeId)
                .name("测试状态")
                .percent(20)
                .sort(1)
                .build();
        setBaseFields(status);
        businessStatusMapper.insert(status);
        return status;
    }

    public CrmBusinessDO createBusiness(Long tenantId, Long customerId) {
        return createBusiness(tenantId, customerId, null);
    }

    public CrmBusinessDO createBusiness(Long tenantId, Long customerId, Integer endStatus) {
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
        businessMapper.insert(business);
        return business;
    }

    public CrmBusinessDO createWinBusiness(Long tenantId, Long customerId) {
        return createBusiness(tenantId, customerId, 1);
    }

    public CrmBusinessDO createLoseBusiness(Long tenantId, Long customerId, String loseReasonCode) {
        CrmBusinessDO business = createBusiness(tenantId, customerId, 2);
        business.setEndRemark("输单原因测试");
        businessMapper.updateById(business);
        return business;
    }

    public CrmContractDO createContract(Long tenantId, Long customerId, Long businessId) {
        return createContract(tenantId, customerId, businessId, 0);
    }

    public CrmContractDO createContract(Long tenantId, Long customerId, Long businessId, Integer auditStatus) {
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
        contractMapper.insert(contract);
        return contract;
    }

    public CrmContractDO createContractWithProcess(Long tenantId, Long customerId, Long businessId) {
        CrmContractDO contract = createContract(tenantId, customerId, businessId, 10);
        contract.setProcessInstanceId("test-process-id-" + System.currentTimeMillis());
        contractMapper.updateById(contract);
        return contract;
    }

    public CrmReceivableDO createReceivable(Long tenantId, Long contractId, Long customerId) {
        return createReceivable(tenantId, contractId, customerId, 0);
    }

    public CrmReceivableDO createReceivable(Long tenantId, Long contractId, Long customerId, Integer auditStatus) {
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
        receivableMapper.insert(receivable);
        return receivable;
    }

    public CrmContactDO createContact(Long tenantId, Long customerId) {
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
        contactMapper.insert(contact);
        return contact;
    }

    public CrmFollowUpRecordDO createFollowUpRecord(Long tenantId, Integer bizType, Long bizId) {
        CrmFollowUpRecordDO record = CrmFollowUpRecordDO.builder()
                .id(nextId())
                .bizType(bizType)
                .bizId(bizId)
                .type(1)
                .content("测试跟进内容")
                .nextTime(LocalDateTime.now().plusDays(7))
                .build();
        setBaseFields(record);
        followUpRecordMapper.insert(record);
        return record;
    }

    public CrmCustomerPoolConfigDO createCustomerPoolConfig(Long tenantId) {
        CrmCustomerPoolConfigDO config = CrmCustomerPoolConfigDO.builder()
                .id(nextId())
                .enabled(true)
                .contactExpireDays(30)
                .dealExpireDays(60)
                .notifyEnabled(true)
                .notifyDays(3)
                .build();
        setBaseFields(config);
        customerPoolConfigMapper.insert(config);
        return config;
    }

    public CrmCustomerLimitConfigDO createCustomerLimitConfig(Long tenantId) {
        CrmCustomerLimitConfigDO config = CrmCustomerLimitConfigDO.builder()
                .id(nextId())
                .type(1)
                .maxCount(100)
                .dealCountEnabled(false)
                .build();
        setBaseFields(config);
        customerLimitConfigMapper.insert(config);
        return config;
    }

    public void clearAll() {
        followUpRecordMapper.delete(null);
        contactMapper.delete(null);
        receivableMapper.delete(null);
        contractMapper.delete(null);
        businessMapper.delete(null);
        businessStatusMapper.delete(null);
        businessStatusTypeMapper.delete(null);
        clueMapper.delete(null);
        customerMapper.delete(null);
        customerPoolConfigMapper.delete(null);
        customerLimitConfigMapper.delete(null);
    }

    public long getCustomerCount(Long tenantId) {
        return customerMapper.selectCount(null);
    }

    public long getClueCount(Long tenantId) {
        return clueMapper.selectCount(null);
    }

    public long getBusinessCount(Long tenantId) {
        return businessMapper.selectCount(null);
    }

    public long getContractCount(Long tenantId) {
        return contractMapper.selectCount(null);
    }

    public long getReceivableCount(Long tenantId) {
        return receivableMapper.selectCount(null);
    }
}