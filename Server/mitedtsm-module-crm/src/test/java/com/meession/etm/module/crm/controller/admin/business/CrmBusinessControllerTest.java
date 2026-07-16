package com.meession.etm.module.crm.controller.admin.business;

import com.meession.etm.framework.common.pojo.CommonResult;
import com.meession.etm.framework.test.core.ut.BaseMockitoUnitTest;
import com.meession.etm.module.crm.controller.admin.business.vo.business.CrmBusinessUpdateStatusReqVO;
import com.meession.etm.module.crm.service.business.CrmBusinessService;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.BeforeEach;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.http.MediaType;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.validation.beanvalidation.LocalValidatorFactoryBean;
import org.springframework.web.bind.annotation.PutMapping;

import java.lang.reflect.Method;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertNotNull;
import static org.mockito.Mockito.verify;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.put;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;
import static org.springframework.test.web.servlet.setup.MockMvcBuilders.standaloneSetup;

class CrmBusinessControllerTest extends BaseMockitoUnitTest {

    @InjectMocks
    private CrmBusinessController businessController;
    @Mock
    private CrmBusinessService businessService;
    private MockMvc mockMvc;

    @BeforeEach
    void setUpMockMvc() {
        LocalValidatorFactoryBean validator = new LocalValidatorFactoryBean();
        validator.afterPropertiesSet();
        mockMvc = standaloneSetup(businessController).setValidator(validator).build();
    }

    @Test
    void updateBusinessStatus_shouldKeepUnifiedHttpAndPermissionContract() throws Exception {
        CrmBusinessUpdateStatusReqVO request = new CrmBusinessUpdateStatusReqVO()
                .setId(1L).setVersion(0).setStatusId(2L);

        CommonResult<Boolean> result = businessController.updateBusinessStatus(request);

        assertEquals(0, result.getCode());
        assertEquals(Boolean.TRUE, result.getData());
        verify(businessService).updateBusinessStatus(request);

        Method method = CrmBusinessController.class.getMethod(
                "updateBusinessStatus", CrmBusinessUpdateStatusReqVO.class);
        assertEquals("/update-status", method.getAnnotation(PutMapping.class).value()[0]);
        assertEquals("@ss.hasPermission('crm:business:update')",
                method.getAnnotation(PreAuthorize.class).value());
        assertNotNull(method.getAnnotation(PreAuthorize.class));
    }

    @Test
    void updateBusinessStatus_shouldExposeHttpEndpointAndRejectBothTargets() throws Exception {
        mockMvc.perform(put("/crm/business/update-status")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content("{\"id\":1,\"version\":0,\"statusId\":2}"))
                .andExpect(status().isOk());
        mockMvc.perform(put("/crm/business/update-status")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content("{\"id\":1,\"version\":0,\"statusId\":2,\"endStatus\":1}"))
                .andExpect(status().isBadRequest());
    }
}
