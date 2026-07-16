package com.meession.etm.module.crm.controller.admin.business;

import com.meession.etm.framework.common.pojo.CommonResult;
import com.meession.etm.framework.test.core.ut.BaseMockitoUnitTest;
import com.meession.etm.module.crm.controller.admin.business.vo.business.CrmBusinessUpdateStatusReqVO;
import com.meession.etm.module.crm.service.business.CrmBusinessService;
import org.junit.jupiter.api.Test;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.PutMapping;

import java.lang.reflect.Method;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertNotNull;
import static org.mockito.Mockito.verify;

class CrmBusinessControllerTest extends BaseMockitoUnitTest {

    @InjectMocks
    private CrmBusinessController businessController;
    @Mock
    private CrmBusinessService businessService;

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
}
