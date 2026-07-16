package com.meession.etm.module.crm.controller.admin.customer;

import com.meession.etm.framework.common.pojo.CommonResult;
import com.meession.etm.framework.test.core.ut.BaseMockitoUnitTest;
import com.meession.etm.module.crm.controller.admin.customer.vo.customer.CrmCustomerDuplicateCheckRespVO;
import com.meession.etm.module.crm.controller.admin.customer.vo.ownerhistory.CrmCustomerOwnerHistoryRespVO;
import com.meession.etm.module.crm.controller.admin.customer.vo.pool.CrmHighSeasRecordRespVO;
import com.meession.etm.module.crm.service.customer.CrmCustomerDuplicateCheckService;
import com.meession.etm.module.crm.service.customer.CrmCustomerOwnerHistoryService;
import com.meession.etm.module.crm.service.customer.CrmHighSeasRecordService;
import com.meession.etm.module.crm.service.customer.bo.CrmCustomerDuplicateCheckBO;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.BeforeEach;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.springframework.http.MediaType;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.validation.beanvalidation.LocalValidatorFactoryBean;

import java.util.Collections;

import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.when;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;
import static org.springframework.test.web.servlet.setup.MockMvcBuilders.standaloneSetup;

class CrmCustomerControllerHttpIntegrationTest extends BaseMockitoUnitTest {

    @InjectMocks
    private CrmCustomerDuplicateCheckController duplicateCheckController;
    @InjectMocks
    private CrmCustomerOwnerHistoryController ownerHistoryController;
    @InjectMocks
    private CrmHighSeasRecordController highSeasRecordController;
    @Mock
    private CrmCustomerDuplicateCheckService duplicateCheckService;
    @Mock
    private CrmCustomerOwnerHistoryService ownerHistoryService;
    @Mock
    private CrmHighSeasRecordService highSeasRecordService;
    private MockMvc mockMvc;

    @Test
    void checkDuplicate_shouldReturnBadRequestWhenNameIsNull() throws Exception {
        mockMvc = standaloneSetup(duplicateCheckController).setValidator(new LocalValidatorFactoryBean()).build();
        mockMvc.perform(post("/crm/customer/check-duplicate")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content("{\"mobile\":\"13800138000\"}"))
                .andExpect(status().isBadRequest());
    }

    @Test
    void checkDuplicate_shouldReturnBadRequestWhenNameIsEmpty() throws Exception {
        mockMvc = standaloneSetup(duplicateCheckController).setValidator(new LocalValidatorFactoryBean()).build();
        mockMvc.perform(post("/crm/customer/check-duplicate")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content("{\"name\":\"\",\"mobile\":\"13800138000\"}"))
                .andExpect(status().isBadRequest());
    }

    @Test
    void checkDuplicate_shouldReturnSuccessWhenNameIsValid() throws Exception {
        when(duplicateCheckService.checkDuplicate(any(CrmCustomerDuplicateCheckBO.class)))
                .thenReturn(new CrmCustomerDuplicateCheckRespVO());

        mockMvc = standaloneSetup(duplicateCheckController).setValidator(new LocalValidatorFactoryBean()).build();
        mockMvc.perform(post("/crm/customer/check-duplicate")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content("{\"name\":\"测试客户\",\"mobile\":\"13800138000\"}"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.code").value(0));
    }

    @Test
    void getCustomerOwnerHistoryList_shouldReturnSuccess() throws Exception {
        when(ownerHistoryService.getByCustomerId(any(Long.class)))
                .thenReturn(Collections.emptyList());

        mockMvc = standaloneSetup(ownerHistoryController).build();
        mockMvc.perform(get("/crm/customer-owner-history/list")
                        .param("customerId", "1"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.code").value(0));
    }

    @Test
    void getCustomerOwnerHistoryList_shouldReturnBadRequestWhenCustomerIdIsNull() throws Exception {
        mockMvc = standaloneSetup(ownerHistoryController).build();
        mockMvc.perform(get("/crm/customer-owner-history/list"))
                .andExpect(status().isBadRequest());
    }

    @Test
    void getHighSeasRecordList_shouldReturnSuccess() throws Exception {
        when(highSeasRecordService.getByCustomerId(any(Long.class)))
                .thenReturn(Collections.emptyList());

        mockMvc = standaloneSetup(highSeasRecordController).build();
        mockMvc.perform(get("/crm/high-seas-record/list-by-customer")
                        .param("customerId", "1"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.code").value(0));
    }

    @Test
    void getHighSeasRecordList_shouldReturnBadRequestWhenCustomerIdIsNull() throws Exception {
        mockMvc = standaloneSetup(highSeasRecordController).build();
        mockMvc.perform(get("/crm/high-seas-record/list-by-customer"))
                .andExpect(status().isBadRequest());
    }
}