package com.meession.etm.module.crm.support;

import com.meession.etm.framework.common.util.json.JsonUtils;
import com.meession.etm.framework.mybatis.core.dataobject.BaseDO;
import com.meession.etm.framework.test.core.ut.BaseDbUnitTest;
import com.meession.etm.module.crm.dal.dataobject.business.CrmBusinessDO;
import com.meession.etm.module.crm.dal.dataobject.clue.CrmClueDO;
import com.meession.etm.module.crm.dal.dataobject.contact.CrmContactDO;
import com.meession.etm.module.crm.dal.dataobject.contract.CrmContractDO;
import com.meession.etm.module.crm.dal.dataobject.customer.CrmCustomerDO;
import com.meession.etm.module.crm.dal.dataobject.customer.CrmCustomerLimitConfigDO;
import com.meession.etm.module.crm.dal.dataobject.customer.CrmCustomerPoolConfigDO;
import com.meession.etm.module.crm.dal.dataobject.followup.CrmFollowUpRecordDO;
import com.meession.etm.module.crm.dal.dataobject.receivable.CrmReceivableDO;
import jakarta.annotation.Resource;
import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.Test;
import org.springframework.context.annotation.Import;

import static org.junit.jupiter.api.Assertions.*;

@Import(CrmTestDataFactory.class)
class CrmTestSupportTest extends BaseDbUnitTest {

    @Resource
    private CrmTestDataFactory testDataFactory;

    @AfterEach
    void tearDown() {
        testDataFactory.clearAll();
    }

    @Test
    void testCreateCustomer() {
        CrmCustomerDO customer = testDataFactory.createCustomer(1L, "测试客户");
        assertNotNull(customer);
        assertNotNull(customer.getId());
        assertEquals("测试客户", customer.getName());
        assertEquals(1L, customer.getOwnerUserId());
        assertNotNull(customer.getCreateTime());
        assertNotNull(customer.getCreator());
    }

    @Test
    void testCreateCustomersBatch() {
        int count = 5;
        testDataFactory.createCustomers(1L, count);
        assertEquals(count, testDataFactory.getCustomerCount(1L));
    }

    @Test
    void testCreateCustomerInPool() {
        CrmCustomerDO customer = testDataFactory.createCustomerInPool(1L);
        assertNotNull(customer);
        assertNull(customer.getOwnerUserId());
    }

    @Test
    void testCreateClue() {
        CrmClueDO clue = testDataFactory.createClue(1L, "测试线索");
        assertNotNull(clue);
        assertNotNull(clue.getId());
        assertEquals("测试线索", clue.getName());
        assertEquals(false, clue.getTransformStatus());
    }

    @Test
    void testCreateClueWithCustomer() {
        CrmCustomerDO customer = testDataFactory.createCustomer(1L);
        CrmClueDO clue = testDataFactory.createClueWithCustomer(1L, customer.getId());
        assertNotNull(clue);
        assertEquals(true, clue.getTransformStatus());
        assertEquals(customer.getId(), clue.getCustomerId());
    }

    @Test
    void testCreateBusiness() {
        CrmCustomerDO customer = testDataFactory.createCustomer(1L);
        CrmBusinessDO business = testDataFactory.createBusiness(1L, customer.getId());
        assertNotNull(business);
        assertNotNull(business.getId());
        assertEquals(customer.getId(), business.getCustomerId());
        assertNotNull(business.getStatusId());
        assertNotNull(business.getStatusTypeId());
    }

    @Test
    void testCreateWinBusiness() {
        CrmCustomerDO customer = testDataFactory.createCustomer(1L);
        CrmBusinessDO business = testDataFactory.createWinBusiness(1L, customer.getId());
        assertNotNull(business);
        assertEquals(1, business.getEndStatus());
    }

    @Test
    void testCreateLoseBusiness() {
        CrmCustomerDO customer = testDataFactory.createCustomer(1L);
        CrmBusinessDO business = testDataFactory.createLoseBusiness(1L, customer.getId(), "COMPETITOR");
        assertNotNull(business);
        assertEquals(2, business.getEndStatus());
        assertNotNull(business.getEndRemark());
    }

    @Test
    void testCreateContract() {
        CrmCustomerDO customer = testDataFactory.createCustomer(1L);
        CrmBusinessDO business = testDataFactory.createBusiness(1L, customer.getId());
        CrmContractDO contract = testDataFactory.createContract(1L, customer.getId(), business.getId());
        assertNotNull(contract);
        assertNotNull(contract.getId());
        assertEquals(customer.getId(), contract.getCustomerId());
        assertEquals(business.getId(), contract.getBusinessId());
        assertEquals(0, contract.getAuditStatus());
    }

    @Test
    void testCreateContractWithProcess() {
        CrmCustomerDO customer = testDataFactory.createCustomer(1L);
        CrmBusinessDO business = testDataFactory.createBusiness(1L, customer.getId());
        CrmContractDO contract = testDataFactory.createContractWithProcess(1L, customer.getId(), business.getId());
        assertNotNull(contract);
        assertEquals(10, contract.getAuditStatus());
        assertNotNull(contract.getProcessInstanceId());
    }

    @Test
    void testCreateReceivable() {
        CrmCustomerDO customer = testDataFactory.createCustomer(1L);
        CrmBusinessDO business = testDataFactory.createBusiness(1L, customer.getId());
        CrmContractDO contract = testDataFactory.createContract(1L, customer.getId(), business.getId());
        CrmReceivableDO receivable = testDataFactory.createReceivable(1L, contract.getId(), customer.getId());
        assertNotNull(receivable);
        assertNotNull(receivable.getId());
        assertEquals(contract.getId(), receivable.getContractId());
        assertEquals(customer.getId(), receivable.getCustomerId());
    }

    @Test
    void testCreateContact() {
        CrmCustomerDO customer = testDataFactory.createCustomer(1L);
        CrmContactDO contact = testDataFactory.createContact(1L, customer.getId());
        assertNotNull(contact);
        assertNotNull(contact.getId());
        assertEquals(customer.getId(), contact.getCustomerId());
        assertNotNull(contact.getMobile());
    }

    @Test
    void testCreateFollowUpRecord() {
        CrmCustomerDO customer = testDataFactory.createCustomer(1L);
        CrmFollowUpRecordDO record = testDataFactory.createFollowUpRecord(1L, 1, customer.getId());
        assertNotNull(record);
        assertNotNull(record.getId());
        assertEquals(1, record.getBizType());
        assertEquals(customer.getId(), record.getBizId());
    }

    @Test
    void testCreateCustomerPoolConfig() {
        CrmCustomerPoolConfigDO config = testDataFactory.createCustomerPoolConfig(1L);
        assertNotNull(config);
        assertNotNull(config.getId());
        assertEquals(true, config.getEnabled());
    }

    @Test
    void testCreateCustomerLimitConfig() {
        CrmCustomerLimitConfigDO config = testDataFactory.createCustomerLimitConfig(1L);
        assertNotNull(config);
        assertNotNull(config.getId());
        assertEquals(1, config.getType());
    }

    @Test
    void testDataIsolation() {
        CrmCustomerDO customer1 = testDataFactory.createCustomer(1L, "客户A");
        CrmCustomerDO customer2 = testDataFactory.createCustomer(2L, "客户B");
        assertNotEquals(customer1.getId(), customer2.getId());
    }

    @Test
    void testDataCleanup() {
        testDataFactory.createCustomer(1L);
        testDataFactory.createClue(1L);
        assertEquals(1, testDataFactory.getCustomerCount(1L));
        assertEquals(1, testDataFactory.getClueCount(1L));

        testDataFactory.clearAll();
        assertEquals(0, testDataFactory.getCustomerCount(1L));
        assertEquals(0, testDataFactory.getClueCount(1L));
    }

    @Test
    void testIdUniqueness() {
        CrmCustomerDO customer = testDataFactory.createCustomer(1L);
        CrmClueDO clue = testDataFactory.createClue(1L);
        CrmBusinessDO business = testDataFactory.createBusiness(1L, customer.getId());

        assertNotEquals(customer.getId(), clue.getId());
        assertNotEquals(clue.getId(), business.getId());
        assertNotEquals(customer.getId(), business.getId());
    }

    @Test
    void testDataJsonSerialization() {
        CrmCustomerDO customer = testDataFactory.createCustomer(1L);
        String json = JsonUtils.toJsonString(customer);
        assertNotNull(json);
        assertTrue(json.contains("\"name\":\""));
        assertTrue(json.contains("\"id\":"));
    }
}