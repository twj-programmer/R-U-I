package com.meession.etm.module.crm.support;

import com.meession.etm.framework.common.util.json.JsonUtils;
import com.meession.etm.framework.mybatis.core.dataobject.BaseDO;
import com.meession.etm.framework.test.core.ut.BaseDbUnitTest;
import com.meession.etm.module.crm.dal.dataobject.business.CrmBusinessDO;
import com.meession.etm.module.crm.dal.dataobject.business.CrmBusinessProductDO;
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
        assertEquals(0, testDataFactory.getCustomerCount(2L));
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
        CrmBusinessDO business = testDataFactory.createLoseBusiness(1L, customer.getId());
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
    void testCreateProductCategory() {
        CrmProductCategoryDO category = testDataFactory.createProductCategory(1L);
        assertNotNull(category);
        assertNotNull(category.getId());
        assertEquals("测试分类", category.getName());
        assertEquals(0L, category.getParentId());
    }

    @Test
    void testCreateProduct() {
        CrmProductCategoryDO category = testDataFactory.createProductCategory(1L);
        CrmProductDO product = testDataFactory.createProduct(1L, category.getId());
        assertNotNull(product);
        assertNotNull(product.getId());
        assertEquals(category.getId(), product.getCategoryId());
        assertNotNull(product.getPrice());
    }

    @Test
    void testCreateBusinessProduct() {
        CrmCustomerDO customer = testDataFactory.createCustomer(1L);
        CrmBusinessDO business = testDataFactory.createBusiness(1L, customer.getId());
        CrmProductCategoryDO category = testDataFactory.createProductCategory(1L);
        CrmProductDO product = testDataFactory.createProduct(1L, category.getId());
        CrmBusinessProductDO bp = testDataFactory.createBusinessProduct(1L, business.getId(), product.getId());
        assertNotNull(bp);
        assertNotNull(bp.getId());
        assertEquals(business.getId(), bp.getBusinessId());
        assertEquals(product.getId(), bp.getProductId());
    }

    @Test
    void testCreateContractProduct() {
        CrmCustomerDO customer = testDataFactory.createCustomer(1L);
        CrmBusinessDO business = testDataFactory.createBusiness(1L, customer.getId());
        CrmContractDO contract = testDataFactory.createContract(1L, customer.getId(), business.getId());
        CrmProductCategoryDO category = testDataFactory.createProductCategory(1L);
        CrmProductDO product = testDataFactory.createProduct(1L, category.getId());
        CrmContractProductDO cp = testDataFactory.createContractProduct(1L, contract.getId(), product.getId());
        assertNotNull(cp);
        assertNotNull(cp.getId());
        assertEquals(contract.getId(), cp.getContractId());
        assertEquals(product.getId(), cp.getProductId());
    }

    @Test
    void testCreateReceivablePlan() {
        CrmCustomerDO customer = testDataFactory.createCustomer(1L);
        CrmBusinessDO business = testDataFactory.createBusiness(1L, customer.getId());
        CrmContractDO contract = testDataFactory.createContract(1L, customer.getId(), business.getId());
        CrmReceivablePlanDO plan = testDataFactory.createReceivablePlan(1L, contract.getId(), customer.getId());
        assertNotNull(plan);
        assertNotNull(plan.getId());
        assertEquals(contract.getId(), plan.getContractId());
        assertEquals(customer.getId(), plan.getCustomerId());
    }

    @Test
    void testCreateContactBusiness() {
        CrmCustomerDO customer = testDataFactory.createCustomer(1L);
        CrmBusinessDO business = testDataFactory.createBusiness(1L, customer.getId());
        CrmContactDO contact = testDataFactory.createContact(1L, customer.getId());
        CrmContactBusinessDO cb = testDataFactory.createContactBusiness(1L, contact.getId(), business.getId());
        assertNotNull(cb);
        assertNotNull(cb.getId());
        assertEquals(contact.getId(), cb.getContactId());
        assertEquals(business.getId(), cb.getBusinessId());
    }

    @Test
    void testCreatePermission() {
        CrmCustomerDO customer = testDataFactory.createCustomer(1L);
        CrmPermissionDO permission = testDataFactory.createPermission(1L, 1, customer.getId(), 1L);
        assertNotNull(permission);
        assertNotNull(permission.getId());
        assertEquals(customer.getId(), permission.getBizId());
        assertEquals(1L, permission.getUserId());
    }

    @Test
    void testTenantIsolation() {
        testDataFactory.createCustomer(1L, "租户1客户");
        testDataFactory.createCustomer(1L, "租户1客户2");
        testDataFactory.createCustomer(2L, "租户2客户");

        assertEquals(2, testDataFactory.getCustomerCount(1L));
        assertEquals(1, testDataFactory.getCustomerCount(2L));
        assertEquals(0, testDataFactory.getCustomerCount(3L));
    }

    @Test
    void testTenantIsolationAcrossMultipleEntities() {
        testDataFactory.createCustomer(1L, "租户1客户");
        testDataFactory.createClue(1L, "租户1线索");
        testDataFactory.createCustomer(2L, "租户2客户");
        testDataFactory.createClue(2L, "租户2线索");

        assertEquals(1, testDataFactory.getCustomerCount(1L));
        assertEquals(1, testDataFactory.getClueCount(1L));
        assertEquals(1, testDataFactory.getCustomerCount(2L));
        assertEquals(1, testDataFactory.getClueCount(2L));
    }

    @Test
    void testNullTenantId() {
        CrmCustomerDO customer = testDataFactory.createCustomer(null, "无租户客户");
        assertNotNull(customer);
        assertNotNull(customer.getId());
        assertNotNull(customer.getName());
    }

    @Test
    void testEmptyCustomerName() {
        CrmCustomerDO customer = testDataFactory.createCustomer(1L, "");
        assertNotNull(customer);
        assertEquals("", customer.getName());
    }

    @Test
    void testNullCustomerName() {
        CrmCustomerDO customer = testDataFactory.createCustomer(1L, null);
        assertNotNull(customer);
        assertNotNull(customer.getName());
        assertTrue(customer.getName().contains("测试客户"));
    }

    @Test
    void testEmptyClueName() {
        CrmClueDO clue = testDataFactory.createClue(1L, "");
        assertNotNull(clue);
        assertEquals("", clue.getName());
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