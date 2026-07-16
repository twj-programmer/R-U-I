package com.meession.etm.module.crm.service.customer;

import com.meession.etm.framework.tenant.core.util.TenantUtils;
import com.meession.etm.framework.test.core.ut.BaseDbUnitTest;
import com.meession.etm.module.crm.controller.admin.customer.vo.customer.CrmCustomerDuplicateCheckRespVO;
import com.meession.etm.module.crm.dal.dataobject.customer.CrmCustomerDO;
import com.meession.etm.module.crm.dal.mysql.customer.CrmCustomerMapper;
import com.meession.etm.module.crm.service.customer.bo.CrmCustomerDuplicateCheckBO;
import com.meession.etm.module.crm.support.CrmTestDataFactory;
import com.meession.etm.module.crm.support.TenantTestConfiguration;
import jakarta.annotation.Resource;
import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.Test;
import org.springframework.context.annotation.Import;

import java.util.concurrent.Callable;
import java.util.concurrent.Executors;

import static org.junit.jupiter.api.Assertions.assertFalse;
import static org.junit.jupiter.api.Assertions.assertTrue;

@Import({CrmTestDataFactory.class, TenantTestConfiguration.class, CrmCustomerDuplicateCheckServiceImpl.class})
class CrmCustomerDuplicateCheckDbTest extends BaseDbUnitTest {
    @Resource private CrmTestDataFactory factory;
    @Resource private CrmCustomerMapper customerMapper;
    @Resource private CrmCustomerDuplicateCheckService service;

    @AfterEach void tearDown() { factory.clearAll(); }

    @Test
    void checkDuplicate_shouldMatchFormattedMobileAndIsolateTenantsUnderConcurrentReads() throws Exception {
        CrmCustomerDO customer = factory.createCustomer(1L, "客户A");
        TenantUtils.execute(1L, () -> { customer.setMobile("138-0013-8000"); customerMapper.updateById(customer); });
        Callable<CrmCustomerDuplicateCheckRespVO> tenantOne = () -> TenantUtils.execute(1L, () -> check("客户A", "13800138000"));
        Callable<CrmCustomerDuplicateCheckRespVO> tenantTwo = () -> TenantUtils.execute(2L, () -> check("客户A", "13800138000"));
        var executor = Executors.newFixedThreadPool(2);
        try {
            assertTrue(executor.submit(tenantOne).get().getHasDuplicate());
            assertFalse(executor.submit(tenantTwo).get().getHasDuplicate());
        } finally { executor.shutdownNow(); }
    }

    private CrmCustomerDuplicateCheckRespVO check(String name, String mobile) {
        CrmCustomerDuplicateCheckBO request = new CrmCustomerDuplicateCheckBO();
        request.setName(name); request.setMobile(mobile);
        return service.checkDuplicate(request);
    }
}
