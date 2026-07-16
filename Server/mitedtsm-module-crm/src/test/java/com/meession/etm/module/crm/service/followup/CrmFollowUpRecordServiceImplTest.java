// 23计科4班 黄金戈
package com.meession.etm.module.crm.service.followup;

import com.meession.etm.module.crm.controller.admin.followup.vo.CrmFollowUpRecordSaveReqVO;
import com.meession.etm.module.crm.dal.dataobject.business.CrmBusinessDO;
import com.meession.etm.module.crm.dal.dataobject.followup.CrmFollowUpRecordDO;
import com.meession.etm.module.crm.dal.mysql.followup.CrmFollowUpRecordMapper;
import com.meession.etm.module.crm.enums.common.CrmBizTypeEnum;
import com.meession.etm.module.crm.service.business.CrmBusinessService;
import com.meession.etm.module.crm.service.contact.CrmContactService;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.test.util.ReflectionTestUtils;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.List;

import static com.meession.etm.framework.test.core.util.AssertUtils.assertServiceException;
import static com.meession.etm.module.crm.enums.ErrorCodeConstants.BUSINESS_NOT_EXISTS;
import static org.junit.jupiter.api.Assertions.assertNotNull;
import static org.mockito.ArgumentMatchers.*;
import static org.mockito.Mockito.*;

class CrmFollowUpRecordServiceImplTest {

    private CrmFollowUpRecordServiceImpl service;
    private CrmFollowUpRecordMapper mapper;
    private CrmBusinessService businessService;
    private CrmContactService contactService;

    @BeforeEach
    void setUp() {
        service = new CrmFollowUpRecordServiceImpl();
        mapper = mock(CrmFollowUpRecordMapper.class);
        businessService = mock(CrmBusinessService.class);
        contactService = mock(CrmContactService.class);
        ReflectionTestUtils.setField(service, "crmFollowUpRecordMapper", mapper);
        ReflectionTestUtils.setField(service, "businessService", businessService);
        ReflectionTestUtils.setField(service, "contactService", contactService);
    }

    @Test
    void createFollowUpRecord_shouldValidateBeforeInsertAndLinkBusiness() {
        CrmFollowUpRecordSaveReqVO req = businessFollowUpReq();
        when(businessService.validateBusiness(1L)).thenReturn(new CrmBusinessDO().setId(1L));

        service.createFollowUpRecord(req);

        verify(mapper).insert(any(CrmFollowUpRecordDO.class));
        verify(businessService).updateBusinessFollowUp(eq(1L), eq(req.getNextTime()), eq(req.getContent()));
    }

    @Test
    void createFollowUpRecord_shouldRejectMissingRelatedBusinessBeforeInsert() {
        CrmFollowUpRecordSaveReqVO req = businessFollowUpReq().setBusinessIds(List.of(2L));
        when(businessService.validateBusiness(1L)).thenReturn(new CrmBusinessDO().setId(1L));
        when(businessService.getBusinessList(anyCollection())).thenReturn(List.of());

        assertServiceException(() -> service.createFollowUpRecord(req), BUSINESS_NOT_EXISTS);
        verify(mapper, never()).insert(any(CrmFollowUpRecordDO.class));
    }

    @Test
    void createFollowUpRecord_shouldBeTransactional() throws Exception {
        assertNotNull(CrmFollowUpRecordServiceImpl.class
                .getMethod("createFollowUpRecord", CrmFollowUpRecordSaveReqVO.class)
                .getAnnotation(Transactional.class));
    }

    private CrmFollowUpRecordSaveReqVO businessFollowUpReq() {
        return new CrmFollowUpRecordSaveReqVO().setBizType(CrmBizTypeEnum.CRM_BUSINESS.getType())
                .setBizId(1L).setType(1).setContent("电话确认需求")
                .setNextTime(LocalDateTime.of(2026, 7, 17, 9, 0));
    }
}
