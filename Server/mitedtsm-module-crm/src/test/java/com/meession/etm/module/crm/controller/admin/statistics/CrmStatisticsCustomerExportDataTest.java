package com.meession.etm.module.crm.controller.admin.statistics;

import com.meession.etm.framework.tenant.core.util.TenantUtils;
import com.meession.etm.framework.test.core.ut.BaseDbUnitTest;
import com.meession.etm.module.crm.controller.admin.statistics.vo.customer.CrmStatisticsCustomerContractSummaryRespVO;
import com.meession.etm.module.crm.controller.admin.statistics.vo.customer.CrmStatisticsCustomerReqVO;
import com.meession.etm.module.crm.dal.dataobject.contract.CrmContractDO;
import com.meession.etm.module.crm.dal.dataobject.customer.CrmCustomerDO;
import com.meession.etm.module.crm.dal.dataobject.receivable.CrmReceivableDO;
import com.meession.etm.module.crm.dal.mysql.customer.CrmCustomerMapper;
import com.meession.etm.module.crm.dal.mysql.receivable.CrmReceivableMapper;
import com.meession.etm.module.crm.dal.mysql.statistics.CrmStatisticsCustomerMapper;
import com.meession.etm.module.crm.support.CrmTestDataFactory;
import com.meession.etm.module.crm.support.TenantTestConfiguration;
import jakarta.annotation.Resource;
import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.Test;
import org.springframework.context.annotation.Import;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.Comparator;
import java.util.List;

import static org.junit.jupiter.api.Assertions.assertEquals;

@Import({CrmTestDataFactory.class, TenantTestConfiguration.class})
class CrmStatisticsCustomerExportDataTest extends BaseDbUnitTest {

    @Resource
    private CrmTestDataFactory testDataFactory;
    @Resource
    private CrmStatisticsCustomerMapper statisticsCustomerMapper;
    @Resource
    private CrmCustomerMapper customerMapper;
    @Resource
    private CrmReceivableMapper receivableMapper;

    @AfterEach
    void tearDown() {
        testDataFactory.clearAll();
    }

    @Test
    void queryRowsShouldKeepIndustrySourceAndReceivableAmounts() {
        CrmCustomerDO customer = testDataFactory.createCustomer(1L, "D2-STAT customer");
        TenantUtils.execute(1L, () -> {
            customer.setIndustryId(9876);
            customer.setSource(999);
            customerMapper.updateById(customer);
        });
        CrmContractDO noReceivable = testDataFactory.createContract(1L, customer.getId(), null, 20);
        CrmContractDO paid = testDataFactory.createContract(1L, customer.getId(), null, 20);
        testDataFactory.createReceivable(1L, paid.getId(), customer.getId(), 20);

        List<CrmStatisticsCustomerContractSummaryRespVO> rows = select(1L, List.of(1L),
                LocalDateTime.now().minusDays(1), LocalDateTime.now().plusDays(1));
        rows.sort(Comparator.comparing(CrmStatisticsCustomerContractSummaryRespVO::getReceivablePrice));

        assertEquals(2, rows.size());
        assertEquals(noReceivable.getName(), rows.get(0).getContractName());
        assertEquals(0, rows.get(0).getReceivablePrice().compareTo(new BigDecimal("0")));
        assertEquals(paid.getName(), rows.get(1).getContractName());
        assertEquals(0, rows.get(1).getReceivablePrice().compareTo(new BigDecimal("5000")));
        assertEquals(9876, rows.get(0).getIndustryId());
        assertEquals(999, rows.get(0).getSource());
    }

    @Test
    void deletedReceivableShouldNotRemoveContractRow() {
        CrmCustomerDO customer = testDataFactory.createCustomer(1L, "D2-STAT deleted receivable");
        CrmContractDO contract = testDataFactory.createContract(1L, customer.getId(), null, 20);
        CrmReceivableDO receivable = testDataFactory.createReceivable(1L, contract.getId(), customer.getId(), 20);
        TenantUtils.execute(1L, () -> receivableMapper.deleteById(receivable.getId()));

        List<CrmStatisticsCustomerContractSummaryRespVO> rows = select(1L, List.of(1L),
                LocalDateTime.now().minusDays(1), LocalDateTime.now().plusDays(1));

        assertEquals(1, rows.size());
        assertEquals(contract.getName(), rows.get(0).getContractName());
        assertEquals(0, rows.get(0).getReceivablePrice().compareTo(new BigDecimal("0")));
    }

    @Test
    void ownerTimeAndTenantFiltersShouldRemainIsolated() {
        CrmCustomerDO tenantOneCustomer = testDataFactory.createCustomer(1L, "D2-STAT tenant 1");
        testDataFactory.createContract(1L, tenantOneCustomer.getId(), null, 20);
        CrmCustomerDO tenantTwoCustomer = testDataFactory.createCustomer(2L, "D2-STAT tenant 2");
        testDataFactory.createContract(2L, tenantTwoCustomer.getId(), null, 20);

        LocalDateTime start = LocalDateTime.now().minusDays(1);
        LocalDateTime end = LocalDateTime.now().plusDays(1);
        assertEquals(1, select(1L, List.of(1L), start, end).size());
        assertEquals(1, select(2L, List.of(1L), start, end).size());
        assertEquals(0, select(1L, List.of(100L), start, end).size());
        assertEquals(0, select(1L, List.of(1L), start.minusYears(2), end.minusYears(2)).size());
    }

    private List<CrmStatisticsCustomerContractSummaryRespVO> select(Long tenantId, List<Long> userIds,
                                                                     LocalDateTime start, LocalDateTime end) {
        CrmStatisticsCustomerReqVO reqVO = new CrmStatisticsCustomerReqVO();
        reqVO.setUserIds(userIds);
        reqVO.setTimes(new LocalDateTime[]{start, end});
        return TenantUtils.execute(tenantId, () -> statisticsCustomerMapper.selectContractSummary(reqVO));
    }
}
