package com.meession.etm.module.crm.service.receivable;

import com.meession.etm.framework.common.exception.ServiceException;
import com.meession.etm.module.crm.controller.admin.receivable.vo.receivable.CrmReceivableSaveReqVO;
import com.meession.etm.module.crm.dal.dataobject.contract.CrmContractDO;
import com.meession.etm.module.crm.dal.dataobject.receivable.CrmReceivableDO;
import com.meession.etm.module.crm.dal.mysql.receivable.CrmReceivableMapper;
import com.meession.etm.module.crm.dal.redis.no.CrmNoRedisDAO;
import com.meession.etm.module.crm.enums.common.CrmAuditStatusEnum;
import com.meession.etm.module.crm.service.contract.CrmContractService;
import com.meession.etm.module.crm.service.permission.CrmPermissionService;
import com.meession.etm.module.system.api.user.AdminUserApi;
import com.meession.etm.module.bpm.api.task.BpmProcessInstanceApi;
import com.meession.etm.module.bpm.api.task.dto.BpmProcessInstanceCreateReqDTO;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Disabled;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Nested;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.Mockito;
import org.mockito.junit.jupiter.MockitoExtension;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.Collections;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.*;
import static org.mockito.Mockito.*;

/**
 * D2-REC-01 回款审批五态回归 & 状态流转单元测试
 *
 * <p>覆盖 V1.5 §2.1 的五态模型（0-草稿/10-审批中/20-审批通过/30-审核不通过/40-已取消）
 * 和 V1.5 §3 D2-REC-01 的回款口径整理要求。
 *
 * <p>当前使用纯 Mockito 单元测试，不依赖 Spring 容器或 H2 数据库。
 * D2-QA-01 合入后，可扩展为 BaseDbUnitTest 集成测试。
 *
 * @author 唐文军
 */
@ExtendWith(MockitoExtension.class)
@DisplayName("D2-REC-01 回款审批五态流转单元测试")
class CrmReceivableServiceTest {

    @Mock
    private CrmReceivableMapper receivableMapper;
    @Mock
    private CrmNoRedisDAO noRedisDAO;
    @Mock
    private CrmContractService contractService;
    @Mock
    private CrmReceivablePlanService receivablePlanService;
    @Mock
    private CrmPermissionService permissionService;
    @Mock
    private AdminUserApi adminUserApi;
    @Mock
    private BpmProcessInstanceApi bpmProcessInstanceApi;

    @InjectMocks
    private CrmReceivableServiceImpl receivableService;

    private static final Long RECEIVABLE_ID = 1L;
    private static final Long CONTRACT_ID = 100L;
    private static final Long USER_ID = 10L;
    private static final String RECEIVABLE_NO = "REC-20260716-001";

    // ==================== 五态枚举核验 ====================

    @Nested
    @DisplayName("审批五态枚举核验（V1.5 §2.1）")
    class FiveStateEnumTest {

        @Test
        @DisplayName("草稿状态值为 0")
        void testDraftStatus() {
            assertEquals(0, CrmAuditStatusEnum.DRAFT.getStatus());
        }

        @Test
        @DisplayName("审批中状态值为 10")
        void testProcessStatus() {
            assertEquals(10, CrmAuditStatusEnum.PROCESS.getStatus());
        }

        @Test
        @DisplayName("审批通过状态值为 20")
        void testApproveStatus() {
            assertEquals(20, CrmAuditStatusEnum.APPROVE.getStatus());
        }

        @Test
        @DisplayName("审核不通过状态值为 30")
        void testRejectStatus() {
            assertEquals(30, CrmAuditStatusEnum.REJECT.getStatus());
        }

        @Test
        @DisplayName("已取消状态值为 40")
        void testCancelStatus() {
            assertEquals(40, CrmAuditStatusEnum.CANCEL.getStatus());
        }

        @Test
        @DisplayName("不存在状态 5（V1.5 §2.1 明确废弃）")
        void testNoStatusFive() {
            for (Integer status : CrmAuditStatusEnum.ARRAYS) {
                assertNotEquals(5, status, "V1.5 明确废弃状态 5，不应出现在枚举中");
            }
        }

        @Test
        @DisplayName("审批状态 Array 不含 4（防止 BPM 原始值污染）")
        void testNoBpmRawValue() {
            for (Integer status : CrmAuditStatusEnum.ARRAYS) {
                assertNotEquals(4, status,
                        "BPM CANCEL 原始值 4 不应出现在 CRM 审批枚举中，应使用 40");
            }
        }
    }

    // ==================== 状态流转规则测试 ====================

    @Nested
    @DisplayName("回款创建 → 初始状态为草稿(0)")
    class CreateReceivableTest {

        @Test
        @DisplayName("创建回款时 auditStatus 应为 DRAFT(0)")
        void testCreateReceivableSetsDraftStatus() {
            // Given
            CrmReceivableSaveReqVO createReqVO = buildCreateReqVO();
            CrmContractDO contract = buildApprovedContract();
            when(contractService.validateContract(CONTRACT_ID)).thenReturn(contract);
            when(receivableMapper.selectListByContractIdAndStatus(anyLong(), anyList()))
                    .thenReturn(Collections.emptyList());
            when(noRedisDAO.generate(CrmNoRedisDAO.RECEIVABLE_PREFIX)).thenReturn(RECEIVABLE_NO);
            when(receivableMapper.selectByNo(RECEIVABLE_NO)).thenReturn(null);
            when(receivableMapper.insert(Mockito.<CrmReceivableDO>any())).thenReturn(1);
            when(permissionService.createPermission(any())).thenReturn(null);

            // When
            Long id = receivableService.createReceivable(createReqVO);

            // Then — 验证插入的 auditStatus 为 DRAFT(0)
            verify(receivableMapper).insert(Mockito.<CrmReceivableDO>argThat(do_ ->
                    do_ != null &&
                            CrmAuditStatusEnum.DRAFT.getStatus().equals(do_.getAuditStatus())));
        }
    }

    @Nested
    @DisplayName("提交审批 → 从草稿(0)到审批中(10)")
    class SubmitReceivableTest {

        @Test
        @DisplayName("草稿状态可提交审批 → audit_status=10, process_instance_id 非空")
        void testSubmitFromDraft() {
            CrmReceivableDO draftReceivable = buildReceivable(CrmAuditStatusEnum.DRAFT);
            when(receivableMapper.selectById(RECEIVABLE_ID)).thenReturn(draftReceivable);
            String mockProcessInstanceId = "proc-001";
            when(bpmProcessInstanceApi.createProcessInstance(eq(USER_ID), any(BpmProcessInstanceCreateReqDTO.class)))
                    .thenReturn(mockProcessInstanceId);
            when(receivableMapper.updateById(Mockito.<CrmReceivableDO>any())).thenReturn(1);

            receivableService.submitReceivable(RECEIVABLE_ID, USER_ID);

            // 验证 BPM 被调用
            verify(bpmProcessInstanceApi).createProcessInstance(eq(USER_ID), any(BpmProcessInstanceCreateReqDTO.class));
            // 验证状态更新为 PROCESS(10) 且 processInstanceId 已写入
            verify(receivableMapper).updateById(Mockito.<CrmReceivableDO>argThat(do_ ->
                    do_ != null
                            && CrmAuditStatusEnum.PROCESS.getStatus().equals(do_.getAuditStatus())
                            && mockProcessInstanceId.equals(do_.getProcessInstanceId())));
        }

        @Test
        @DisplayName("审批中状态不可再次提交")
        void testSubmitFromProcess() {
            CrmReceivableDO processReceivable = buildReceivable(CrmAuditStatusEnum.PROCESS);
            when(receivableMapper.selectById(RECEIVABLE_ID)).thenReturn(processReceivable);

            ServiceException ex = assertThrows(ServiceException.class, () ->
                    receivableService.submitReceivable(RECEIVABLE_ID, USER_ID));
            assertTrue(ex.getMessage().contains("非草稿") || ex.getMessage().contains("提交"),
                    "应提示非草稿状态不可提交");
        }

        @Test
        @DisplayName("审批通过状态不可再次提交")
        void testSubmitFromApprove() {
            CrmReceivableDO approveReceivable = buildReceivable(CrmAuditStatusEnum.APPROVE);
            when(receivableMapper.selectById(RECEIVABLE_ID)).thenReturn(approveReceivable);

            assertThrows(ServiceException.class, () ->
                    receivableService.submitReceivable(RECEIVABLE_ID, USER_ID));
        }

        @Test
        @DisplayName("已取消状态不可提交")
        void testSubmitFromCancel() {
            CrmReceivableDO cancelReceivable = buildReceivable(CrmAuditStatusEnum.CANCEL);
            when(receivableMapper.selectById(RECEIVABLE_ID)).thenReturn(cancelReceivable);

            assertThrows(ServiceException.class, () ->
                    receivableService.submitReceivable(RECEIVABLE_ID, USER_ID));
        }
    }

    @Nested
    @DisplayName("删除约束 → 审批通过(20)不可删除")
    class DeleteReceivableTest {

        @Test
        @DisplayName("草稿状态可删除")
        void testDeleteDraft() {
            CrmReceivableDO draft = buildReceivable(CrmAuditStatusEnum.DRAFT);
            when(receivableMapper.selectById(RECEIVABLE_ID)).thenReturn(draft);
            when(receivableMapper.deleteById(RECEIVABLE_ID)).thenReturn(1);
            doNothing().when(permissionService).deletePermission(anyInt(), eq(RECEIVABLE_ID));

            assertDoesNotThrow(() -> receivableService.deleteReceivable(RECEIVABLE_ID));
        }

        @Test
        @DisplayName("审批中状态可删除")
        void testDeleteProcess() {
            CrmReceivableDO process = buildReceivable(CrmAuditStatusEnum.PROCESS);
            when(receivableMapper.selectById(RECEIVABLE_ID)).thenReturn(process);
            when(receivableMapper.deleteById(RECEIVABLE_ID)).thenReturn(1);
            doNothing().when(permissionService).deletePermission(anyInt(), eq(RECEIVABLE_ID));

            assertDoesNotThrow(() -> receivableService.deleteReceivable(RECEIVABLE_ID));
        }

        @Test
        @DisplayName("审批通过状态不可删除（V1.5 §2.1 终态保护）")
        void testDeleteApprove() {
            CrmReceivableDO approve = buildReceivable(CrmAuditStatusEnum.APPROVE);
            when(receivableMapper.selectById(RECEIVABLE_ID)).thenReturn(approve);

            assertThrows(ServiceException.class, () ->
                    receivableService.deleteReceivable(RECEIVABLE_ID));
        }

        @Test
        @DisplayName("已取消状态可删除")
        void testDeleteCancel() {
            CrmReceivableDO cancel = buildReceivable(CrmAuditStatusEnum.CANCEL);
            when(receivableMapper.selectById(RECEIVABLE_ID)).thenReturn(cancel);
            when(receivableMapper.deleteById(RECEIVABLE_ID)).thenReturn(1);
            doNothing().when(permissionService).deletePermission(anyInt(), eq(RECEIVABLE_ID));

            assertDoesNotThrow(() -> receivableService.deleteReceivable(RECEIVABLE_ID));
        }
    }

    @Nested
    @DisplayName("更新约束 → 仅草稿(0)和审批中(10)可编辑")
    class UpdateReceivableTest {

        @Test
        @DisplayName("草稿状态可编辑")
        void testUpdateDraft() {
            CrmReceivableSaveReqVO updateReqVO = buildUpdateReqVO();
            CrmReceivableDO draft = buildReceivable(CrmAuditStatusEnum.DRAFT);
            when(receivableMapper.selectById(RECEIVABLE_ID)).thenReturn(draft);
            CrmContractDO contract = buildApprovedContract();
            when(contractService.validateContract(CONTRACT_ID)).thenReturn(contract);
            when(receivableMapper.selectListByContractIdAndStatus(anyLong(), anyList()))
                    .thenReturn(Collections.emptyList());
            when(receivableMapper.updateById(Mockito.<CrmReceivableDO>any())).thenReturn(1);

            assertDoesNotThrow(() -> receivableService.updateReceivable(updateReqVO));
        }

        @Test
        @DisplayName("审批中状态可编辑")
        void testUpdateProcess() {
            CrmReceivableSaveReqVO updateReqVO = buildUpdateReqVO();
            CrmReceivableDO process = buildReceivable(CrmAuditStatusEnum.PROCESS);
            when(receivableMapper.selectById(RECEIVABLE_ID)).thenReturn(process);
            CrmContractDO contract = buildApprovedContract();
            when(contractService.validateContract(CONTRACT_ID)).thenReturn(contract);
            when(receivableMapper.selectListByContractIdAndStatus(anyLong(), anyList()))
                    .thenReturn(Collections.emptyList());
            when(receivableMapper.updateById(Mockito.<CrmReceivableDO>any())).thenReturn(1);

            assertDoesNotThrow(() -> receivableService.updateReceivable(updateReqVO));
        }

        @Test
        @DisplayName("审批通过状态不可编辑")
        void testUpdateApprove() {
            CrmReceivableSaveReqVO updateReqVO = buildUpdateReqVO();
            CrmReceivableDO approve = buildReceivable(CrmAuditStatusEnum.APPROVE);
            when(receivableMapper.selectById(RECEIVABLE_ID)).thenReturn(approve);
            CrmContractDO contract = buildApprovedContract();
            when(contractService.validateContract(CONTRACT_ID)).thenReturn(contract);
            when(receivableMapper.selectListByContractIdAndStatus(anyLong(), anyList()))
                    .thenReturn(Collections.emptyList());

            assertThrows(ServiceException.class, () ->
                    receivableService.updateReceivable(updateReqVO));
        }
    }

    // ==================== BPM 回调状态更新测试 ====================

    @Nested
    @DisplayName("BPM 审批回调 → 状态更新（V1.5 §11.2 映射规则）")
    class AuditStatusCallbackTest {

        @Test
        @DisplayName("仅审批中(10)状态可被 BPM 回调更新")
        void testCallbackOnlyFromProcess() {
            CrmReceivableDO process = buildReceivable(CrmAuditStatusEnum.PROCESS);
            when(receivableMapper.selectById(RECEIVABLE_ID)).thenReturn(process);
            when(receivableMapper.updateById(Mockito.<CrmReceivableDO>any())).thenReturn(1);

            // BPM APPROVE (2) → CRM APPROVE (20)
            assertDoesNotThrow(() ->
                    receivableService.updateReceivableAuditStatus(RECEIVABLE_ID, 2));
        }

        @Test
        @DisplayName("非审批中状态拒绝 BPM 回调")
        void testCallbackRejectedForNonProcess() {
            CrmReceivableDO draft = buildReceivable(CrmAuditStatusEnum.DRAFT);
            when(receivableMapper.selectById(RECEIVABLE_ID)).thenReturn(draft);

            assertThrows(ServiceException.class, () ->
                    receivableService.updateReceivableAuditStatus(RECEIVABLE_ID, 2));
        }

        @Test
        @DisplayName("BPM 审批通过(2) → CRM 审批通过(20)")
        void testBpmApproveMapsToCrmApprove() {
            CrmReceivableDO process = buildReceivable(CrmAuditStatusEnum.PROCESS);
            when(receivableMapper.selectById(RECEIVABLE_ID)).thenReturn(process);
            when(receivableMapper.updateById(Mockito.<CrmReceivableDO>any())).thenReturn(1);

            receivableService.updateReceivableAuditStatus(RECEIVABLE_ID, 2);

            verify(receivableMapper).updateById(Mockito.<CrmReceivableDO>argThat(do_ ->
                    CrmAuditStatusEnum.APPROVE.getStatus().equals(do_.getAuditStatus())));
        }

        @Test
        @DisplayName("BPM 审批驳回(3) → CRM 审核不通过(30)")
        void testBpmRejectMapsToCrmReject() {
            CrmReceivableDO process = buildReceivable(CrmAuditStatusEnum.PROCESS);
            when(receivableMapper.selectById(RECEIVABLE_ID)).thenReturn(process);
            when(receivableMapper.updateById(Mockito.<CrmReceivableDO>any())).thenReturn(1);

            receivableService.updateReceivableAuditStatus(RECEIVABLE_ID, 3);

            verify(receivableMapper).updateById(Mockito.<CrmReceivableDO>argThat(do_ ->
                    CrmAuditStatusEnum.REJECT.getStatus().equals(do_.getAuditStatus())));
        }

        @Test
        @Disabled("依赖 D2-APR-01 修复 CrmAuditStatusUtils BPM CANCEL→40 映射，修复后启用")
        @DisplayName("BPM 取消(4) → CRM 已取消(40)（V1.5 §11.2: BPM 4→40）")
        void testBpmCancelMapsToCrmCancel() {
            // D2-APR-01 需修复 CrmAuditStatusUtils 中 BPM CANCEL 映射
            // 此处验证最终 auditStatus 必须为 40，不接受 4
            CrmReceivableDO process = buildReceivable(CrmAuditStatusEnum.PROCESS);
            when(receivableMapper.selectById(RECEIVABLE_ID)).thenReturn(process);
            when(receivableMapper.updateById(Mockito.<CrmReceivableDO>any())).thenReturn(1);

            receivableService.updateReceivableAuditStatus(RECEIVABLE_ID, 4);

            verify(receivableMapper).updateById(Mockito.<CrmReceivableDO>argThat(do_ -> {
                Integer status = do_.getAuditStatus();
                assertEquals(CrmAuditStatusEnum.CANCEL.getStatus(), status,
                        "V1.5 §11.2: BPM CANCEL(4) 必须映射为 CRM 40，不得为 4");
                return true;
            }));
        }
    }

    // ==================== 边界 & 异常场景 ====================

    @Nested
    @DisplayName("边界与异常场景：重复回调、空参数、BPM异常")
    class BoundaryAndErrorTest {

        @Test
        @DisplayName("重复 BPM 审批通过回调：PROCESS 已变更为 APPROVE 后再次回调应拒绝")
        void testDuplicateApproveCallback() {
            // 第一次回调通过后状态已变为 APPROVE
            CrmReceivableDO approved = buildReceivable(CrmAuditStatusEnum.APPROVE);
            when(receivableMapper.selectById(RECEIVABLE_ID)).thenReturn(approved);

            // 第二次 BPM APPROVE 回调 → 应拒绝（仅 PROCESS 可被回调）
            assertThrows(ServiceException.class, () ->
                    receivableService.updateReceivableAuditStatus(RECEIVABLE_ID, 2));
        }

        @Test
        @DisplayName("重复 BPM 取消回调：已取消状态拒绝再次回调")
        void testDuplicateCancelCallback() {
            CrmReceivableDO cancelled = buildReceivable(CrmAuditStatusEnum.CANCEL);
            when(receivableMapper.selectById(RECEIVABLE_ID)).thenReturn(cancelled);

            assertThrows(ServiceException.class, () ->
                    receivableService.updateReceivableAuditStatus(RECEIVABLE_ID, 4));
        }

        @Test
        @DisplayName("BPM 创建流程异常 → 不写入 process_instance_id，保留草稿")
        void testBpmCreateProcessFails() {
            CrmReceivableDO draft = buildReceivable(CrmAuditStatusEnum.DRAFT);
            when(receivableMapper.selectById(RECEIVABLE_ID)).thenReturn(draft);
            when(bpmProcessInstanceApi.createProcessInstance(eq(USER_ID), any(BpmProcessInstanceCreateReqDTO.class)))
                    .thenThrow(new RuntimeException("BPM service unavailable"));

            assertThrows(RuntimeException.class, () ->
                    receivableService.submitReceivable(RECEIVABLE_ID, USER_ID));

            // BPM 异常后不得写入 process_instance_id 或修改 audit_status
            verify(receivableMapper, never()).updateById(Mockito.<CrmReceivableDO>any());
        }

        @Test
        @DisplayName("提交时 receivable 不存在 → 明确错误")
        void testSubmitNonExistent() {
            when(receivableMapper.selectById(RECEIVABLE_ID)).thenReturn(null);

            assertThrows(ServiceException.class, () ->
                    receivableService.submitReceivable(RECEIVABLE_ID, USER_ID));
        }
    }

    // ==================== 辅助方法 ====================

    private CrmReceivableSaveReqVO buildCreateReqVO() {
        CrmReceivableSaveReqVO vo = new CrmReceivableSaveReqVO();
        vo.setContractId(CONTRACT_ID);
        vo.setCustomerId(200L);
        vo.setOwnerUserId(USER_ID);
        vo.setPrice(new BigDecimal("10000.00"));
        vo.setReturnTime(LocalDateTime.now());
        vo.setReturnType(1); // 电汇
        return vo;
    }

    private CrmReceivableSaveReqVO buildUpdateReqVO() {
        CrmReceivableSaveReqVO vo = new CrmReceivableSaveReqVO();
        vo.setId(RECEIVABLE_ID);
        vo.setPrice(new BigDecimal("20000.00"));
        vo.setReturnTime(LocalDateTime.now());
        vo.setReturnType(1);
        return vo;
    }

    private CrmReceivableDO buildReceivable(CrmAuditStatusEnum status) {
        CrmReceivableDO receivable = new CrmReceivableDO();
        receivable.setId(RECEIVABLE_ID);
        receivable.setNo(RECEIVABLE_NO);
        receivable.setContractId(CONTRACT_ID);
        receivable.setCustomerId(200L);
        receivable.setOwnerUserId(USER_ID);
        receivable.setAuditStatus(status.getStatus());
        receivable.setPrice(new BigDecimal("10000.00"));
        receivable.setReturnTime(LocalDateTime.now());
        return receivable;
    }

    private CrmContractDO buildApprovedContract() {
        CrmContractDO contract = new CrmContractDO();
        contract.setId(CONTRACT_ID);
        contract.setTotalPrice(new BigDecimal("50000.00"));
        contract.setCustomerId(200L);
        contract.setAuditStatus(CrmAuditStatusEnum.APPROVE.getStatus());
        return contract;
    }
}
