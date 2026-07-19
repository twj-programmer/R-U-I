package com.meession.etm.module.crm.controller.admin.statistics;

import com.meession.etm.framework.common.biz.infra.logger.ApiErrorLogCommonApi;
import com.meession.etm.framework.common.biz.system.dict.DictDataCommonApi;
import com.meession.etm.framework.dict.core.DictFrameworkUtils;
import com.meession.etm.framework.security.core.service.SecurityFrameworkService;
import com.meession.etm.framework.web.core.handler.GlobalExceptionHandler;
import com.meession.etm.module.crm.service.statistics.CrmStatisticsCustomerService;
import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.parallel.ResourceLock;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.method.configuration.EnableMethodSecurity;
import org.springframework.test.context.junit.jupiter.SpringJUnitConfig;
import org.springframework.test.web.servlet.MockMvc;

import java.util.Collections;
import java.util.concurrent.atomic.AtomicBoolean;

import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.anyString;
import static org.mockito.ArgumentMatchers.eq;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.never;
import static org.mockito.Mockito.reset;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.header;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;
import static org.springframework.test.web.servlet.setup.MockMvcBuilders.standaloneSetup;

@SpringJUnitConfig(CrmStatisticsCustomerExportSecurityTest.SecurityTestConfiguration.class)
@ResourceLock("DictFrameworkUtils")
class CrmStatisticsCustomerExportSecurityTest {

    private static final String EXPORT_PERMISSION = "crm:statistics-customer:export";

    @Autowired
    private CrmStatisticsCustomerController customerController;
    @Autowired
    private CrmStatisticsCustomerService customerService;
    @Autowired
    private AtomicBoolean exportAllowed;

    private MockMvc mockMvc;
    private DictDataCommonApi originalDictDataApi;

    @BeforeEach
    void setUp() {
        originalDictDataApi = (DictDataCommonApi) org.springframework.test.util.ReflectionTestUtils
                .getField(DictFrameworkUtils.class, "dictDataApi");
        exportAllowed.set(false);
        reset(customerService);
        when(customerService.getContractSummary(any())).thenReturn(Collections.emptyList());
        DictDataCommonApi dictDataApi = mock(DictDataCommonApi.class);
        when(dictDataApi.getDictDataList(anyString())).thenReturn(Collections.emptyList());
        DictFrameworkUtils.init(dictDataApi);
        DictFrameworkUtils.clearCache();
        mockMvc = standaloneSetup(customerController)
                .setControllerAdvice(new GlobalExceptionHandler("crm-test", mock(ApiErrorLogCommonApi.class)))
                .build();
    }

    @AfterEach
    void restoreDictDataApi() {
        DictFrameworkUtils.clearCache();
        org.springframework.test.util.ReflectionTestUtils.setField(
                DictFrameworkUtils.class, "dictDataApi", originalDictDataApi);
    }

    @Test
    void exportHttpBoundaryShouldRejectQueryOnlyPermissionThroughPreAuthorizeAop() throws Exception {
        mockMvc.perform(get("/crm/statistics-customer/export-contract-summary")
                        .param("deptId", "1"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.code").value(403));

        verify(customerService, never()).getContractSummary(any());
    }

    @Test
    void exportHttpBoundaryShouldReturnWorkbookWithExportPermission() throws Exception {
        exportAllowed.set(true);

        mockMvc.perform(get("/crm/statistics-customer/export-contract-summary")
                        .param("deptId", "1"))
                .andExpect(status().isOk())
                .andExpect(header().string("Content-Type", "application/vnd.ms-excel;charset=UTF-8"))
                .andExpect(header().exists("Content-Disposition"));

        verify(customerService).getContractSummary(any());
    }

    @Configuration
    @EnableMethodSecurity
    static class SecurityTestConfiguration {

        @Bean
        AtomicBoolean exportAllowed() {
            return new AtomicBoolean(false);
        }

        @Bean
        CrmStatisticsCustomerService customerService() {
            return mock(CrmStatisticsCustomerService.class);
        }

        @Bean(name = "ss")
        SecurityFrameworkService securityFrameworkService(AtomicBoolean exportAllowed) {
            SecurityFrameworkService service = mock(SecurityFrameworkService.class);
            when(service.hasPermission(anyString())).thenReturn(true);
            when(service.hasPermission(eq(EXPORT_PERMISSION))).thenAnswer(invocation -> exportAllowed.get());
            return service;
        }

        @Bean
        CrmStatisticsCustomerController customerController(CrmStatisticsCustomerService customerService) {
            CrmStatisticsCustomerController controller = new CrmStatisticsCustomerController();
            org.springframework.test.util.ReflectionTestUtils.setField(controller, "customerService", customerService);
            return controller;
        }
    }
}
