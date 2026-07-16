// 23计科4班 黄金戈
package com.meession.etm.module.crm.service.followup;

import com.meession.etm.module.crm.controller.admin.followup.vo.CrmFollowUpRecordSaveReqVO;
import com.meession.etm.module.crm.dal.dataobject.followup.CrmFollowUpRecordDO;
import com.meession.etm.module.crm.dal.mysql.followup.CrmFollowUpRecordMapper;
import com.meession.etm.module.crm.enums.common.CrmBizTypeEnum;
import com.meession.etm.module.crm.service.business.CrmBusinessService;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.test.util.ReflectionTestUtils;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;

import static org.junit.jupiter.api.Assertions.assertNotNull;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.eq;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.verify;

class CrmFollowUpRecordServiceImplTest {

    private CrmFollowUpRecordServiceImpl service;
    private CrmFollowUpRecordMapper mapper;
    private CrmBusinessService businessService;

    @BeforeEach
    void setUp() {
        service = new CrmFollowUpRecordServiceImpl();
        mapper = mock(CrmFollowUpRecordMapper.class);
        businessService = mock(CrmBusinessService.class);
        ReflectionTestUtils.setField(service, "crmFollowUpRecordMapper", mapper);
        ReflectionTestUtils.setField(service, "businessService", businessService);
    }

    @Test
    void createFollowUpRecord_shouldInsertAndLinkBusiness() {
        CrmFollowUpRecordSaveReqVO req = new CrmFollowUpRecordSaveReqVO()
                .setBizType(CrmBizTypeEnum.CRM_BUSINESS.getType()).setBizId(1L)
                .setType(1).setContent("电话确认需求")
                .setNextTime(LocalDateTime.of(2026, 7, 17, 9, 0));

        service.createFollowUpRecord(req);

        verify(mapper).insert(any(CrmFollowUpRecordDO.class));
        verify(businessService).updateBusinessFollowUp(eq(1L), eq(req.getNextTime()), eq(req.getContent()));
    }

    @Test
    void createFollowUpRecord_shouldBeTransactional() throws Exception {
        assertNotNull(CrmFollowUpRecordServiceImpl.class
                .getMethod("createFollowUpRecord", CrmFollowUpRecordSaveReqVO.class)
                .getAnnotation(Transactional.class));
    }
}
