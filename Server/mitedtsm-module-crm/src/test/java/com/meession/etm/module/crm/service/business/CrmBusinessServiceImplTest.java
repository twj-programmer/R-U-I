// 23计科4班 黄金戈
package com.meession.etm.module.crm.service.business;

import com.meession.etm.framework.common.biz.system.dict.dto.DictDataRespDTO;
import com.meession.etm.module.crm.controller.admin.business.vo.business.*;
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
import org.springframework.test.util.ReflectionTestUtils;

import java.math.BigDecimal;
import java.util.List;
import java.util.Set;

import static com.meession.etm.framework.test.core.util.AssertUtils.assertServiceException;
import static com.meession.etm.module.crm.enums.ErrorCodeConstants.*;
import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.*;
import static org.mockito.Mockito.*;

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
    void updateStatus_shouldAllowForwardJumpAndIncreaseVersion() {
        CrmBusinessDO business = activeBusiness();
        when(businessMapper.selectById(1L)).thenReturn(business);
        when(statusService.validateBusinessStatus(10L, 13L))
                .thenReturn(new CrmBusinessStatusDO().setId(13L).setTypeId(10L).setName("报价").setSort(3));
        when(statusService.getBusinessStatus(11L))
                .thenReturn(new CrmBusinessStatusDO().setId(11L).setTypeId(10L).setName("需求").setSort(1));
        when(businessMapper.updateStageByVersion(1L, 2, 13L)).thenReturn(1);

        CrmBusinessStatusUpdateRespVO result = service.updateBusinessStatus(
                new CrmBusinessUpdateStatusReqVO().setId(1L).setVersion(2).setStatusId(13L));

        assertEquals(3, result.getVersion());
        assertEquals(13L, result.getStatusId());
        verify(businessMapper).updateStageByVersion(1L, 2, 13L);
    }

    @Test
    void updateStatus_shouldRejectBackwardStage() {
        when(businessMapper.selectById(1L)).thenReturn(activeBusiness());
        when(statusService.validateBusinessStatus(10L, 12L))
                .thenReturn(new CrmBusinessStatusDO().setId(12L).setSort(0));
        when(statusService.getBusinessStatus(11L))
                .thenReturn(new CrmBusinessStatusDO().setId(11L).setTypeId(10L).setSort(1));

        assertServiceException(() -> service.updateBusinessStatus(
                new CrmBusinessUpdateStatusReqVO().setId(1L).setVersion(2).setStatusId(12L)),
                BUSINESS_STATUS_TRANSITION_NOT_ALLOWED);
        verify(businessMapper, never()).updateStageByVersion(anyLong(), anyInt(), anyLong());
    }

    @Test
    void updateStatus_shouldRejectMissingStatusTypeWithoutNullPointer() {
        when(businessMapper.selectById(1L)).thenReturn(activeBusiness().setStatusTypeId(null));
        when(statusService.getBusinessStatus(11L))
                .thenReturn(new CrmBusinessStatusDO().setId(11L).setTypeId(10L).setSort(1));

        assertServiceException(() -> service.updateBusinessStatus(
                        new CrmBusinessUpdateStatusReqVO().setId(1L).setVersion(2).setStatusId(13L)),
                BUSINESS_STATUS_TRANSITION_NOT_ALLOWED);
        verify(businessMapper, never()).updateStageByVersion(anyLong(), anyInt(), anyLong());
    }

    @Test
    void updateStatus_shouldValidateLoseReasonAndKeepLastStage() {
        when(businessMapper.selectById(1L)).thenReturn(activeBusiness());
        DictDataRespDTO reason = new DictDataRespDTO();
        reason.setValue("NO_BUDGET");
        reason.setStatus(0);
        when(dictDataApi.getDictDataList("crm_business_lose_reason")).thenReturn(List.of(reason));
        when(businessMapper.updateEndStatusByVersion(1L, 2, 2, "NO_BUDGET", "预算取消")).thenReturn(1);
        when(statusService.getBusinessStatus(11L))
                .thenReturn(new CrmBusinessStatusDO().setId(11L).setTypeId(10L).setName("需求").setSort(1));

        CrmBusinessStatusUpdateRespVO result = service.updateBusinessStatus(
                new CrmBusinessUpdateStatusReqVO().setId(1L).setVersion(2).setEndStatus(2)
                        .setLoseReasonCode(" NO_BUDGET ").setEndRemark(" 预算取消 "));

        assertEquals(11L, result.getStatusId());
        assertEquals("NO_BUDGET", result.getLoseReasonCode());
        verify(businessMapper).updateEndStatusByVersion(1L, 2, 2, "NO_BUDGET", "预算取消");
    }

    @Test
    void updateStatus_shouldRejectUnknownLoseReason() {
        when(businessMapper.selectById(1L)).thenReturn(activeBusiness());
        when(statusService.getBusinessStatus(11L))
                .thenReturn(new CrmBusinessStatusDO().setId(11L).setTypeId(10L).setName("需求").setSort(1));
        when(dictDataApi.getDictDataList("crm_business_lose_reason")).thenReturn(List.of());

        assertServiceException(() -> service.updateBusinessStatus(
                new CrmBusinessUpdateStatusReqVO().setId(1L).setVersion(2).setEndStatus(2)
                .setLoseReasonCode("UNKNOWN")), BUSINESS_LOSE_REASON_INVALID);
    }

    @Test
    void updateStatus_shouldRejectStaleVersion() {
        CrmBusinessDO current = activeBusiness();
        CrmBusinessDO latest = activeBusiness().setVersion(3);
        when(businessMapper.selectById(1L)).thenReturn(current, latest);
        when(statusService.getBusinessStatus(11L))
                .thenReturn(new CrmBusinessStatusDO().setId(11L).setTypeId(10L).setName("需求").setSort(1));
        when(statusService.validateBusinessStatus(10L, 13L))
                .thenReturn(new CrmBusinessStatusDO().setId(13L).setTypeId(10L).setName("报价").setSort(3));
        when(businessMapper.updateStageByVersion(1L, 2, 13L)).thenReturn(0);

        assertServiceException(() -> service.updateBusinessStatus(
                new CrmBusinessUpdateStatusReqVO().setId(1L).setVersion(2).setStatusId(13L)),
                BUSINESS_VERSION_CONFLICT);
    }

    @Test
    void updateQuotation_shouldUseServerSnapshotAndRoundAmounts() {
        when(businessMapper.selectById(1L)).thenReturn(activeBusiness());
        when(businessProductMapper.selectListByBusinessId(1L)).thenReturn(List.of());
        CrmProductDO product = new CrmProductDO().setId(100L).setName("软件服务")
                .setPrice(new BigDecimal("120.00")).setStatus(1);
        when(productService.getProductList(anyCollection())).thenReturn(List.of(product));
        when(businessMapper.updateQuotationByVersion(eq(1L), eq(2), any(), any(), any())).thenReturn(1);

        CrmBusinessProductReqVO item = new CrmBusinessProductReqVO().setProductId(100L)
                .setBusinessPrice(new BigDecimal("100.00")).setCount(new BigDecimal("3"));
        CrmBusinessQuotationRespVO result = service.updateBusinessQuotation(
                new CrmBusinessUpdateQuotationReqVO().setId(1L).setVersion(2)
                        .setDiscountPercent(new BigDecimal("20")).setProducts(List.of(item)));

        assertEquals(0, new BigDecimal("300.00").compareTo(result.getTotalProductPrice()));
        assertEquals(0, new BigDecimal("60.00").compareTo(result.getDiscountAmount()));
        assertEquals(0, new BigDecimal("240.00").compareTo(result.getTotalPrice()));
        assertEquals(0, new BigDecimal("120.00").compareTo(result.getProducts().get(0).getProductPrice()));
        verify(businessProductMapper).insertBatch(anyList());
    }

    @Test
    void updateQuotation_shouldRejectDuplicateProductsBeforeWrite() {
        when(businessMapper.selectById(1L)).thenReturn(activeBusiness());
        CrmBusinessProductReqVO first = new CrmBusinessProductReqVO().setProductId(100L)
                .setBusinessPrice(BigDecimal.ONE).setCount(BigDecimal.ONE);
        CrmBusinessProductReqVO second = new CrmBusinessProductReqVO().setProductId(100L)
                .setBusinessPrice(BigDecimal.TEN).setCount(BigDecimal.ONE);

        assertServiceException(() -> service.updateBusinessQuotation(
                new CrmBusinessUpdateQuotationReqVO().setId(1L).setVersion(2)
                        .setDiscountPercent(BigDecimal.ZERO).setProducts(List.of(first, second))),
                BUSINESS_QUOTE_PRODUCT_DUPLICATE);
        verify(businessMapper, never()).updateQuotationByVersion(anyLong(), anyInt(), any(), any(), any());
    }

    @Test
    void updateQuotation_shouldRejectAmountWithMoreThanEighteenIntegerDigits() {
        when(businessMapper.selectById(1L)).thenReturn(activeBusiness());
        when(businessProductMapper.selectListByBusinessId(1L)).thenReturn(List.of());
        CrmProductDO product = new CrmProductDO().setId(100L).setName("软件服务")
                .setPrice(new BigDecimal("120.00")).setStatus(1);
        when(productService.getProductList(anyCollection())).thenReturn(List.of(product));
        CrmBusinessProductReqVO item = new CrmBusinessProductReqVO().setProductId(100L)
                .setBusinessPrice(new BigDecimal("1000000000000000000.00")).setCount(BigDecimal.ONE);

        assertServiceException(() -> service.updateBusinessQuotation(
                        new CrmBusinessUpdateQuotationReqVO().setId(1L).setVersion(2)
                                .setDiscountPercent(BigDecimal.ZERO).setProducts(List.of(item))),
                BUSINESS_QUOTE_AMOUNT_INVALID);
        verify(businessMapper, never()).updateQuotationByVersion(anyLong(), anyInt(), any(), any(), any());
    }

    @Test
    void updateQuotation_shouldKeepDisabledProductWhenAmountsAreUnchanged() {
        when(businessMapper.selectById(1L)).thenReturn(activeBusiness());
        CrmBusinessProductDO old = new CrmBusinessProductDO().setBusinessId(1L).setProductId(100L)
                .setProductPrice(new BigDecimal("120.00")).setBusinessPrice(new BigDecimal("100.00"))
                .setCount(new BigDecimal("3.000")).setTotalPrice(new BigDecimal("300.00"));
        when(businessProductMapper.selectListByBusinessId(1L)).thenReturn(List.of(old));
        CrmProductDO disabled = new CrmProductDO().setId(100L).setName("停用产品").setStatus(0);
        when(productService.getProductList(anyCollection())).thenReturn(List.of(disabled));
        when(businessMapper.updateQuotationByVersion(eq(1L), eq(2), any(), any(), any())).thenReturn(1);

        CrmBusinessProductReqVO item = new CrmBusinessProductReqVO().setProductId(100L)
                .setBusinessPrice(new BigDecimal("100.0")).setCount(new BigDecimal("3"));
        CrmBusinessQuotationRespVO result = service.updateBusinessQuotation(
                new CrmBusinessUpdateQuotationReqVO().setId(1L).setVersion(2)
                        .setDiscountPercent(BigDecimal.ZERO).setProducts(List.of(item)));

        assertEquals(0, new BigDecimal("120.00").compareTo(result.getProducts().get(0).getProductPrice()));
    }

    @Test
    void updateQuotation_shouldRejectTerminalBusiness() {
        when(businessMapper.selectById(1L)).thenReturn(activeBusiness().setEndStatus(1));
        assertServiceException(() -> service.updateBusinessQuotation(
                new CrmBusinessUpdateQuotationReqVO().setId(1L).setVersion(2)
                        .setDiscountPercent(BigDecimal.ZERO).setProducts(List.of())),
                BUSINESS_UPDATE_STATUS_FAIL_END_STATUS);
    }

    @Test
    void updateBusiness_shouldRejectTerminalBusiness() {
        when(businessMapper.selectById(1L)).thenReturn(activeBusiness().setEndStatus(1));

        assertServiceException(() -> service.updateBusiness(
                        new CrmBusinessUpdateReqVO().setId(1L).setVersion(2)),
                BUSINESS_UPDATE_STATUS_FAIL_END_STATUS);
        verify(businessMapper, never()).updateBasicByVersion(any(), anyInt());
    }

    private CrmBusinessDO activeBusiness() {
        return new CrmBusinessDO().setId(1L).setName("重点商机").setStatusTypeId(10L)
                .setStatusId(11L).setVersion(2);
    }

    private static void assertHasMessage(Set<? extends ConstraintViolation<?>> violations, String expected) {
        assertTrue(violations.stream().anyMatch(item -> expected.equals(item.getMessage())),
                () -> "未找到校验消息：" + expected + "，实际：" + violations);
    }
}
