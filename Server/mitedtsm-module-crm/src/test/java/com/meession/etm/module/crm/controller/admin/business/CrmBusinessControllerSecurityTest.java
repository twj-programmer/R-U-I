package com.meession.etm.module.crm.controller.admin.business;

import com.meession.etm.framework.security.core.service.SecurityFrameworkService;
import com.meession.etm.module.crm.controller.admin.business.vo.business.CrmBusinessUpdateStatusReqVO;
import com.meession.etm.module.crm.service.business.CrmBusinessService;
import com.meession.etm.module.crm.service.business.CrmBusinessStatusService;
import com.meession.etm.module.crm.service.customer.CrmCustomerService;
import com.meession.etm.module.crm.service.product.CrmProductService;
import com.meession.etm.module.system.api.dept.DeptApi;
import com.meession.etm.module.system.api.user.AdminUserApi;
import org.junit.jupiter.api.Test;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.access.AccessDeniedException;
import org.springframework.security.config.annotation.method.configuration.EnableMethodSecurity;
import org.springframework.test.context.junit.jupiter.SpringJUnitConfig;
import org.springframework.beans.factory.annotation.Autowired;

import static org.junit.jupiter.api.Assertions.assertThrows;
import static org.mockito.ArgumentMatchers.anyString;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.never;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

@SpringJUnitConfig(CrmBusinessControllerSecurityTest.SecurityTestConfiguration.class)
class CrmBusinessControllerSecurityTest {

    @Autowired
    private CrmBusinessController businessController;
    @Autowired
    private CrmBusinessService businessService;

    @Test
    void updateBusinessStatus_shouldRejectWithoutBusinessUpdatePermission() {
        assertThrows(AccessDeniedException.class, () -> businessController.updateBusinessStatus(
                new CrmBusinessUpdateStatusReqVO().setId(1L).setVersion(0).setStatusId(2L)));
        verify(businessService, never()).updateBusinessStatus(org.mockito.ArgumentMatchers.any());
    }

    @Configuration
    @EnableMethodSecurity
    static class SecurityTestConfiguration {

        @Bean
        CrmBusinessService businessService() {
            return mock(CrmBusinessService.class);
        }

        @Bean CrmCustomerService customerService() { return mock(CrmCustomerService.class); }
        @Bean CrmBusinessStatusService businessStatusTypeService() { return mock(CrmBusinessStatusService.class); }
        @Bean CrmBusinessStatusService businessStatusService() { return mock(CrmBusinessStatusService.class); }
        @Bean CrmProductService productService() { return mock(CrmProductService.class); }
        @Bean AdminUserApi adminUserApi() { return mock(AdminUserApi.class); }
        @Bean DeptApi deptApi() { return mock(DeptApi.class); }

        @Bean(name = "ss")
        SecurityFrameworkService securityFrameworkService() {
            SecurityFrameworkService service = mock(SecurityFrameworkService.class);
            when(service.hasPermission(anyString())).thenReturn(false);
            return service;
        }

        @Bean
        CrmBusinessController businessController(CrmBusinessService businessService) {
            CrmBusinessController controller = new CrmBusinessController();
            org.springframework.test.util.ReflectionTestUtils.setField(controller, "businessService", businessService);
            return controller;
        }
    }
}
