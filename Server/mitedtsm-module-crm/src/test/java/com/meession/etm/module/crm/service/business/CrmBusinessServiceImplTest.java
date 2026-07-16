// 23计科4班 黄金戈
package com.meession.etm.module.crm.service.business;

import com.meession.etm.framework.common.exception.ServiceException;
import com.meession.etm.module.crm.controller.admin.business.vo.business.CrmBusinessSaveReqVO;
import com.meession.etm.module.crm.controller.admin.business.vo.business.CrmBusinessUpdateStatusReqVO;
import com.meession.etm.module.crm.dal.dataobject.business.CrmBusinessDO;
import com.meession.etm.module.crm.dal.dataobject.business.CrmBusinessProductDO;
import com.meession.etm.module.crm.dal.dataobject.business.CrmBusinessStatusDO;
import com.meession.etm.module.crm.dal.dataobject.product.CrmProductDO;
import com.meession.etm.module.crm.dal.mysql.business.CrmBusinessMapper;
import com.meession.etm.module.crm.dal.mysql.business.CrmBusinessProductMapper;
import com.meession.etm.module.crm.enums.business.CrmBusinessEndStatusEnum;
import com.meession.etm.module.crm.service.product.CrmProductService;
import com.meession.etm.module.system.api.dict.DictDataApi;
import jakarta.validation.ConstraintViolation;
import jakarta.validation.Validation;
import jakarta.validation.Validator;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.mockito.ArgumentCaptor;
import org.springframework.test.util.ReflectionTestUtils;

import java.math.BigDecimal;
import java.util.List;
import java.util.Set;

import static com.meession.etm.framework.test.core.util.AssertUtils.assertServiceException;
import static com.meession.etm.module.crm.enums.ErrorCodeConstants.BUSINESS_UPDATE_STATUS_FAIL_END_STATUS;
import static com.meession.etm.module.crm.enums.ErrorCodeConstants.BUSINESS_UPDATE_VERSION_CONFLICT;
import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertThrows;
import static org.junit.jupiter.api.Assertions.assertTrue;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.anyInt;
import static org.mockito.ArgumentMatchers.anyLong;
import static org.mockito.ArgumentMatchers.eq;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.never;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

class CrmBusinessServiceImplTest {

    private final Validator validator = Validation.buildDefaultValidatorFactory().getValidator();
    private CrmBusinessServiceImpl service;
    private CrmBusinessMapper businessMapper;
    private CrmBusinessProductMapper businessProductMapper;
    private CrmBusinessStatusService statusService;
    private CrmProductService productService;
    private DictDataApi dictDataApi;

    @BeforeEach
    void setUp() {
        service = new CrmBusinessServiceImpl();
        businessMapper = mock(CrmBusinessMapper.class);
        businessProductMapper = mock(CrmBusinessProductMapper.class);
        statusService = mock(CrmBusinessStatusService.class);
        productService = mock(CrmProductService.class);
        dictDataApi = mock(DictDataApi.class);
        ReflectionTestUtils.setField(service, "businessMapper", businessMapper);
        ReflectionTestUtils.setField(service, "businessProductMapper", businessProductMapper);
        ReflectionTestUtils.setField(service, "businessStatusService", statusService);
        ReflectionTestUtils.setField(service, "productService", productService);
        ReflectionTestUtils.setField(service, "dictDataApi", dictDataApi);
    }

    @Test
    void updateStatusRequest_shouldRequireExactlyOneTargetAndVersion() {
        CrmBusinessUpdateStatusReqVO empty = new CrmBusinessUpdateStatusReqVO().setId(1L);
        assertHasMessage(validator.validate(empty), "变更状态不正确");
        assertHasMessage(validator.validate(empty), "版本号不能为空");

        CrmBusinessUpdateStatusReqVO both = new CrmBusinessUpdateStatusReqVO().setId(1L).setVersion(0)
                .setStatusId(2L).setEndStatus(CrmBusinessEndStatusEnum.WIN.getStatus());
        assertHasMessage(validator.validate(both), "变更状态不正确");
    }

    @Test
    void updateStatus_shouldAllowForwardStage() {
        when(businessMapper.selectById(1L)).thenReturn(activeBusiness());
        when(statusService.getBusinessStatus(11L)).thenReturn(status(11L, 1));
        when(statusService.validateBusinessStatus(10L, 13L)).thenReturn(status(13L, 3));
        when(businessMapper.updateStageByVersion(1L, 2, 13L)).thenReturn(1);

        service.updateBusinessStatus(new CrmBusinessUpdateStatusReqVO()
                .setId(1L).setVersion(2).setStatusId(13L));

        verify(businessMapper).updateStageByVersion(1L, 2, 13L);
    }

    @Test
    void updateStatus_shouldRejectBackwardStage() {
        when(businessMapper.selectById(1L)).thenReturn(activeBusiness());
        when(statusService.getBusinessStatus(11L)).thenReturn(status(11L, 1));
        when(statusService.validateBusinessStatus(10L, 12L)).thenReturn(status(12L, 0));

        ServiceException exception = assertThrows(ServiceException.class, () -> service.updateBusinessStatus(
                new CrmBusinessUpdateStatusReqVO().setId(1L).setVersion(2).setStatusId(12L)));
        assertEquals(400, exception.getCode());
        verify(businessMapper, never()).updateStageByVersion(anyLong(), anyInt(), anyLong());
    }

    @Test
    void updateStatus_shouldUseFixedDictValidationBoundary() {
        when(businessMapper.selectById(1L)).thenReturn(activeBusiness());
        when(statusService.getBusinessStatus(11L)).thenReturn(status(11L, 1));
        when(businessMapper.updateEndStatusByVersion(1L, 2, 2, "BUDGET", "预算不足")).thenReturn(1);

        service.updateBusinessStatus(new CrmBusinessUpdateStatusReqVO().setId(1L).setVersion(2)
                .setEndStatus(2).setLoseReasonCode(" BUDGET ").setEndRemark(" 预算不足 "));

        verify(dictDataApi).validateDictDataList("crm_business_lose_reason", List.of("BUDGET"));
        verify(businessMapper).updateEndStatusByVersion(1L, 2, 2, "BUDGET", "预算不足");
    }

    @Test
    void updateStatus_shouldReturnFrozenVersionConflictCode() {
        when(businessMapper.selectById(1L)).thenReturn(activeBusiness(), activeBusiness().setVersion(3));
        when(statusService.getBusinessStatus(11L)).thenReturn(status(11L, 1));
        when(statusService.validateBusinessStatus(10L, 13L)).thenReturn(status(13L, 3));
        when(businessMapper.updateStageByVersion(1L, 2, 13L)).thenReturn(0);

        assertServiceException(() -> service.updateBusinessStatus(
                new CrmBusinessUpdateStatusReqVO().setId(1L).setVersion(2).setStatusId(13L)),
                BUSINESS_UPDATE_VERSION_CONFLICT);
    }

    @Test
    void updateBusiness_shouldRejectTerminalBusinessBeforeProductWrite() {
        when(businessMapper.selectById(1L)).thenReturn(activeBusiness().setEndStatus(1));

        assertServiceException(() -> service.updateBusiness(new CrmBusinessSaveReqVO().setId(1L)),
                BUSINESS_UPDATE_STATUS_FAIL_END_STATUS);
        verify(businessProductMapper, never()).insertBatch(any());
    }

    @Test
    void updateBusiness_shouldRequireVersionOnExistingBoundary() {
        when(businessMapper.selectById(1L)).thenReturn(activeBusiness());

        ServiceException exception = assertThrows(ServiceException.class, () -> service.updateBusiness(
                new CrmBusinessSaveReqVO().setId(1L)));

        assertEquals(400, exception.getCode());
        verify(businessMapper, never()).updateBusinessByVersion(any(), anyInt());
    }

    @Test
    void updateBusiness_shouldReturnFrozenVersionConflictCode() {
        when(businessMapper.selectById(1L)).thenReturn(activeBusiness(), activeBusiness().setVersion(3));
        when(businessMapper.updateBusinessByVersion(any(), eq(2))).thenReturn(0);

        CrmBusinessSaveReqVO reqVO = new CrmBusinessSaveReqVO().setId(1L).setVersion(2)
                .setDiscountPercent(BigDecimal.ZERO).setProducts(List.of());

        assertServiceException(() -> service.updateBusiness(reqVO), BUSINESS_UPDATE_VERSION_CONFLICT);
    }

    @Test
    void updateBusiness_shouldKeepProductRowAndServerSnapshotOnExistingBoundary() {
        CrmBusinessProductDO oldProduct = new CrmBusinessProductDO().setId(101L).setBusinessId(1L)
                .setProductId(201L).setProductPrice(new BigDecimal("50.00"))
                .setBusinessPrice(new BigDecimal("9.00")).setCount(BigDecimal.ONE);
        when(businessMapper.selectById(1L)).thenReturn(activeBusiness());
        when(businessProductMapper.selectListByBusinessId(1L)).thenReturn(List.of(oldProduct));
        when(productService.getProductList(Set.of(201L))).thenReturn(List.of(new CrmProductDO()
                .setId(201L).setName("产品 A").setPrice(new BigDecimal("60.00")).setStatus(1)));
        when(businessMapper.updateBusinessByVersion(any(), eq(2))).thenReturn(1);

        CrmBusinessSaveReqVO.BusinessProduct product = new CrmBusinessSaveReqVO.BusinessProduct()
                .setId(101L).setProductId(201L).setProductPrice(new BigDecimal("999.00"))
                .setBusinessPrice(new BigDecimal("10.00")).setCount(new BigDecimal("2.000"));
        service.updateBusiness(new CrmBusinessSaveReqVO().setId(1L).setVersion(2)
                .setDiscountPercent(new BigDecimal("10.00")).setProducts(List.of(product)));

        ArgumentCaptor<CrmBusinessDO> businessCaptor = ArgumentCaptor.forClass(CrmBusinessDO.class);
        verify(businessMapper).updateBusinessByVersion(businessCaptor.capture(), eq(2));
        assertEquals(new BigDecimal("20.00"), businessCaptor.getValue().getTotalProductPrice());
        assertEquals(new BigDecimal("18.00"), businessCaptor.getValue().getTotalPrice());

        @SuppressWarnings("unchecked")
        ArgumentCaptor<List<CrmBusinessProductDO>> productCaptor = ArgumentCaptor.forClass(List.class);
        verify(businessProductMapper).updateBatch(productCaptor.capture());
        CrmBusinessProductDO savedProduct = productCaptor.getValue().get(0);
        assertEquals(101L, savedProduct.getId());
        assertEquals(new BigDecimal("50.00"), savedProduct.getProductPrice());
        assertEquals(new BigDecimal("20.00"), savedProduct.getTotalPrice());
    }

    private CrmBusinessDO activeBusiness() {
        return new CrmBusinessDO().setId(1L).setName("重点商机").setStatusTypeId(10L)
                .setStatusId(11L).setVersion(2);
    }

    private CrmBusinessStatusDO status(Long id, int sort) {
        return new CrmBusinessStatusDO().setId(id).setTypeId(10L).setName("阶段" + id).setSort(sort);
    }

    private static void assertHasMessage(Set<? extends ConstraintViolation<?>> violations, String expected) {
        assertTrue(violations.stream().anyMatch(item -> expected.equals(item.getMessage())),
                () -> "未找到校验消息：" + expected + "，实际：" + violations);
    }
}
