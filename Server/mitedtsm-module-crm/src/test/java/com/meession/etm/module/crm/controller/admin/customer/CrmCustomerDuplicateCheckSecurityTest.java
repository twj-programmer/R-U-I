package com.meession.etm.module.crm.controller.admin.customer;

import com.meession.etm.framework.common.biz.infra.logger.ApiErrorLogCommonApi;
import com.meession.etm.framework.security.core.service.SecurityFrameworkService;
import com.meession.etm.framework.web.core.handler.GlobalExceptionHandler;
import com.meession.etm.module.crm.service.customer.CrmCustomerDuplicateCheckService;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.method.configuration.EnableMethodSecurity;
import org.springframework.test.context.junit.jupiter.SpringJUnitConfig;
import org.springframework.test.web.servlet.MockMvc;

import java.util.concurrent.atomic.AtomicBoolean;

import static org.mockito.ArgumentMatchers.anyString;
import static org.mockito.ArgumentMatchers.eq;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.never;
import static org.mockito.Mockito.reset;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;
import static org.springframework.test.web.servlet.setup.MockMvcBuilders.standaloneSetup;

@SpringJUnitConfig(CrmCustomerDuplicateCheckSecurityTest.SecurityTestConfiguration.class)
class CrmCustomerDuplicateCheckSecurityTest {

    private static final String PERMISSION = "crm:customer:check-duplicate";

    @Autowired private CrmCustomerDuplicateCheckController controller;
    @Autowired private CrmCustomerDuplicateCheckService service;
    @Autowired private AtomicBoolean allowed;
    private MockMvc mockMvc;

    @BeforeEach
    void setUp() {
        allowed.set(false);
        reset(service);
        mockMvc = standaloneSetup(controller)
                .setControllerAdvice(new GlobalExceptionHandler("crm-test", mock(ApiErrorLogCommonApi.class)))
                .build();
    }

    @Test
    void checkDuplicateHttpBoundary_shouldRejectWithoutPermission() throws Exception {
        mockMvc.perform(post("/crm/customer/check-duplicate").contentType("application/json")
                        .content("{\"name\":\"客户A\"}"))
                .andExpect(status().isOk()).andExpect(jsonPath("$.code").value(403));
        verify(service, never()).checkDuplicate(org.mockito.ArgumentMatchers.any());
    }

    @Test
    void checkDuplicateHttpBoundary_shouldAcceptWithPermission() throws Exception {
        allowed.set(true);
        mockMvc.perform(post("/crm/customer/check-duplicate").contentType("application/json")
                        .content("{\"name\":\"客户A\",\"mobile\":\"13800138000\"}"))
                .andExpect(status().isOk()).andExpect(jsonPath("$.code").value(0));
        verify(service).checkDuplicate(org.mockito.ArgumentMatchers.any());
    }

    @Configuration @EnableMethodSecurity
    static class SecurityTestConfiguration {
        @Bean AtomicBoolean allowed() { return new AtomicBoolean(false); }
        @Bean CrmCustomerDuplicateCheckService duplicateCheckService() { return mock(CrmCustomerDuplicateCheckService.class); }
        @Bean(name = "ss") SecurityFrameworkService securityFrameworkService(AtomicBoolean allowed) {
            SecurityFrameworkService security = mock(SecurityFrameworkService.class);
            when(security.hasPermission(anyString())).thenReturn(true);
            when(security.hasPermission(eq(PERMISSION))).thenAnswer(invocation -> allowed.get());
            return security;
        }
        @Bean CrmCustomerDuplicateCheckController controller(CrmCustomerDuplicateCheckService service) {
            CrmCustomerDuplicateCheckController controller = new CrmCustomerDuplicateCheckController();
            org.springframework.test.util.ReflectionTestUtils.setField(controller, "duplicateCheckService", service);
            return controller;
        }
    }
}
