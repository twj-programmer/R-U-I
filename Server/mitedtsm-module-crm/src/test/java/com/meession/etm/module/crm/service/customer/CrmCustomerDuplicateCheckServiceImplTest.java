package com.meession.etm.module.crm.service.customer;

import com.meession.etm.module.crm.controller.admin.customer.vo.customer.CrmCustomerDuplicateCheckRespVO;
import com.meession.etm.module.crm.dal.dataobject.customer.CrmCustomerDO;
import com.meession.etm.module.crm.dal.mysql.customer.CrmCustomerMapper;
import com.meession.etm.module.crm.service.customer.bo.CrmCustomerDuplicateCheckBO;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.test.util.ReflectionTestUtils;

import java.util.ArrayList;
import java.util.List;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.when;

class CrmCustomerDuplicateCheckServiceImplTest {

    private CrmCustomerDuplicateCheckServiceImpl service;
    private CrmCustomerMapper customerMapper;

    @BeforeEach
    void setUp() {
        customerMapper = mock(CrmCustomerMapper.class);
        service = new CrmCustomerDuplicateCheckServiceImpl(customerMapper);
    }

    @Test
    void checkDuplicate_shouldReturnNoDuplicateWhenNoCandidates() {
        when(customerMapper.selectList(any())).thenReturn(new ArrayList<>());

        CrmCustomerDuplicateCheckBO checkBO = new CrmCustomerDuplicateCheckBO();
        checkBO.setName("张三");
        checkBO.setMobile("13800138000");

        CrmCustomerDuplicateCheckRespVO result = service.checkDuplicate(checkBO);

        assertFalse(result.getHasDuplicate());
        assertTrue(result.getCandidates().isEmpty());
    }

    @Test
    void checkDuplicate_shouldReturnStrongMatchWhenMobileMatches() {
        CrmCustomerDO customer = new CrmCustomerDO();
        customer.setId(1L);
        customer.setName("张三");
        customer.setMobile("13800138000");
        customer.setDeleted(false);

        when(customerMapper.selectList(any())).thenReturn(List.of(customer));

        CrmCustomerDuplicateCheckBO checkBO = new CrmCustomerDuplicateCheckBO();
        checkBO.setName("张三");
        checkBO.setMobile("13800138000");

        CrmCustomerDuplicateCheckRespVO result = service.checkDuplicate(checkBO);

        assertTrue(result.getHasDuplicate());
        assertEquals(1, result.getCandidates().size());
        assertEquals("STRONG", result.getCandidates().get(0).getMatchType());
    }

    @Test
    void checkDuplicate_shouldReturnSuspectMatchWhenNameSimilar() {
        CrmCustomerDO customer = new CrmCustomerDO();
        customer.setId(1L);
        customer.setName("张三");
        customer.setMobile("13900139000");
        customer.setDeleted(false);

        when(customerMapper.selectList(any())).thenReturn(List.of(customer));

        CrmCustomerDuplicateCheckBO checkBO = new CrmCustomerDuplicateCheckBO();
        checkBO.setName("张三");
        checkBO.setMobile("13800138000");

        CrmCustomerDuplicateCheckRespVO result = service.checkDuplicate(checkBO);

        assertTrue(result.getHasDuplicate());
    }

    @Test
    void checkDuplicate_shouldExcludeSpecifiedCustomer() {
        CrmCustomerDO customer = new CrmCustomerDO();
        customer.setId(1L);
        customer.setName("张三");
        customer.setMobile("13800138000");
        customer.setDeleted(false);

        when(customerMapper.selectList(any())).thenReturn(new ArrayList<>());

        CrmCustomerDuplicateCheckBO checkBO = new CrmCustomerDuplicateCheckBO();
        checkBO.setName("张三");
        checkBO.setMobile("13800138000");
        checkBO.setExcludeId(1L);

        CrmCustomerDuplicateCheckRespVO result = service.checkDuplicate(checkBO);

        assertFalse(result.getHasDuplicate());
    }

    @Test
    void checkDuplicate_shouldDetectDuplicateAtSimilarityBoundary080() {
        CrmCustomerDO customer = new CrmCustomerDO();
        customer.setId(1L);
        customer.setName("测试客户ABC");
        customer.setMobile("13800138001");
        customer.setDeleted(false);

        when(customerMapper.selectList(any())).thenReturn(List.of(customer));

        CrmCustomerDuplicateCheckBO checkBO = new CrmCustomerDuplicateCheckBO();
        checkBO.setName("测试客户ABD");
        checkBO.setMobile("13800138002");

        CrmCustomerDuplicateCheckRespVO result = service.checkDuplicate(checkBO);

        assertTrue(result.getHasDuplicate());
    }

    @Test
    void checkDuplicate_shouldNormalizeFullWidthCharacters() {
        CrmCustomerDO customer = new CrmCustomerDO();
        customer.setId(1L);
        customer.setName("张三");
        customer.setMobile("13800138000");
        customer.setDeleted(false);

        when(customerMapper.selectList(any())).thenReturn(List.of(customer));

        CrmCustomerDuplicateCheckBO checkBO = new CrmCustomerDuplicateCheckBO();
        checkBO.setName("张三");
        checkBO.setMobile("13800138000");

        CrmCustomerDuplicateCheckRespVO result = service.checkDuplicate(checkBO);

        assertTrue(result.getHasDuplicate());
    }

    @Test
    void checkDuplicate_shouldNormalizePunctuationAndSpaces() {
        CrmCustomerDO customer = new CrmCustomerDO();
        customer.setId(1L);
        customer.setName("张三科技有限公司");
        customer.setMobile("13800138000");
        customer.setDeleted(false);

        when(customerMapper.selectList(any())).thenReturn(List.of(customer));

        CrmCustomerDuplicateCheckBO checkBO = new CrmCustomerDuplicateCheckBO();
        checkBO.setName("张三科技有限公司");
        checkBO.setMobile("138-0013-8000");

        CrmCustomerDuplicateCheckRespVO result = service.checkDuplicate(checkBO);

        assertTrue(result.getHasDuplicate());
    }

    @Test
    void normalizeName_shouldPreserveNumbers() {
        String result = (String) ReflectionTestUtils.invokeMethod(service, "normalizeName", "张三科技123有限公司");
        assertTrue(result.contains("123"), "名称标准化不应删除数字");
    }

}