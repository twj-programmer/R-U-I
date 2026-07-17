package com.meession.etm.module.crm.service.customer;

import cn.hutool.core.collection.CollUtil;
import cn.hutool.core.lang.Assert;
import cn.hutool.core.util.ObjUtil;
import cn.hutool.core.util.StrUtil;
import cn.hutool.extra.spring.SpringUtil;
import com.meession.etm.framework.common.exception.ServiceException;
import com.meession.etm.framework.common.pojo.PageResult;
import com.meession.etm.framework.common.util.collection.CollectionUtils;
import com.meession.etm.framework.common.util.object.BeanUtils;
import com.meession.etm.framework.tenant.core.context.TenantContextHolder;
import com.meession.etm.module.crm.controller.admin.business.vo.business.CrmBusinessTransferReqVO;
import com.meession.etm.module.crm.controller.admin.contact.vo.CrmContactTransferReqVO;
import com.meession.etm.module.crm.controller.admin.contract.vo.contract.CrmContractTransferReqVO;
import com.meession.etm.module.crm.controller.admin.customer.vo.customer.*;
import com.meession.etm.module.crm.dal.dataobject.business.CrmBusinessDO;
import com.meession.etm.module.crm.dal.dataobject.contact.CrmContactDO;
import com.meession.etm.module.crm.dal.dataobject.contract.CrmContractDO;
import com.meession.etm.module.crm.dal.dataobject.customer.CrmCustomerDO;
import com.meession.etm.module.crm.dal.dataobject.customer.CrmCustomerLimitConfigDO;
import com.meession.etm.module.crm.dal.dataobject.customer.CrmCustomerPoolConfigDO;
import com.meession.etm.module.crm.dal.mysql.customer.CrmCustomerMapper;
import com.meession.etm.module.crm.enums.common.CrmBizTypeEnum;
import com.meession.etm.module.crm.enums.common.CrmSceneTypeEnum;
import com.meession.etm.module.crm.enums.permission.CrmPermissionLevelEnum;
import com.meession.etm.module.crm.framework.permission.core.annotations.CrmPermission;
import com.meession.etm.module.crm.service.business.CrmBusinessService;
import com.meession.etm.module.crm.service.contact.CrmContactService;
import com.meession.etm.module.crm.service.contract.CrmContractService;
import com.meession.etm.module.crm.service.customer.bo.CrmCustomerCreateReqBO;
import com.meession.etm.module.crm.service.permission.CrmPermissionService;
import com.meession.etm.module.crm.service.permission.bo.CrmPermissionCreateReqBO;
import com.meession.etm.module.crm.service.permission.bo.CrmPermissionTransferReqBO;
import com.meession.etm.module.system.api.user.AdminUserApi;
import com.meession.etm.module.system.api.user.dto.AdminUserRespDTO;
import com.mzt.logapi.context.LogRecordContext;
import com.mzt.logapi.service.impl.DiffParseFunction;
import com.mzt.logapi.starter.annotation.LogRecord;
import jakarta.annotation.Resource;
import lombok.extern.slf4j.Slf4j;
import org.springframework.context.annotation.Lazy;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.validation.annotation.Validated;

import java.time.LocalDateTime;
import java.time.LocalTime;
import java.util.*;

import static com.meession.etm.framework.common.exception.util.ServiceExceptionUtil.exception;
import static com.meession.etm.framework.common.util.collection.CollectionUtils.filterList;
import static com.meession.etm.framework.security.core.util.SecurityFrameworkUtils.getLoginUserId;
import static com.meession.etm.module.crm.enums.ErrorCodeConstants.*;
import static com.meession.etm.module.crm.enums.LogRecordConstants.*;
import static com.meession.etm.module.crm.enums.customer.CrmCustomerLimitConfigTypeEnum.CUSTOMER_LOCK_LIMIT;
import static com.meession.etm.module.crm.enums.customer.CrmCustomerLimitConfigTypeEnum.CUSTOMER_OWNER_LIMIT;
import static java.util.Collections.singletonList;

/**
 * 客户 Service 实现类
 *
 * @author Wanwan
 */
@Service
@Slf4j
@Validated
public class CrmCustomerServiceImpl implements CrmCustomerService {

    @Resource
    private CrmCustomerMapper customerMapper;

    @Resource
    private CrmPermissionService permissionService;
    @Resource
    private CrmCustomerLimitConfigService customerLimitConfigService;
    @Resource
    @Lazy
    private CrmCustomerPoolConfigService customerPoolConfigService;
    @Resource
    @Lazy
    private CrmContactService contactService;
    @Resource
    @Lazy
    private CrmBusinessService businessService;
    @Resource
    @Lazy
    private CrmContractService contractService;

    @Resource
    private AdminUserApi adminUserApi;

    @Resource
    @Lazy
    private CrmHighSeasRecordService highSeasRecordService;

    @Resource
    @Lazy
    private CrmCustomerOwnerHistoryService ownerHistoryService;

    @Override
    @Transactional(rollbackFor = Exception.class)
    @LogRecord(type = CRM_CUSTOMER_TYPE, subType = CRM_CUSTOMER_CREATE_SUB_TYPE, bizNo = "{{#customer.id}}",
            success = CRM_CUSTOMER_CREATE_SUCCESS)
    public Long createCustomer(CrmCustomerSaveReqVO createReqVO, Long userId) {
        createReqVO.setId(null);
        // 1. 校验拥有客户是否到达上限
        validateCustomerExceedOwnerLimit(createReqVO.getOwnerUserId(), 1);

        // 2. 插入客户
        CrmCustomerDO customer = initCustomer(createReqVO, userId);
        customerMapper.insert(customer);

        // 3. 创建数据权限
        permissionService.createPermission(new CrmPermissionCreateReqBO().setBizType(CrmBizTypeEnum.CRM_CUSTOMER.getType())
                .setBizId(customer.getId()).setUserId(userId).setLevel(CrmPermissionLevelEnum.OWNER.getLevel())); // 设置当前操作的人为负责人

        // 4. 记录操作日志上下文
        LogRecordContext.putVariable("customer", customer);
        return customer.getId();
    }

    /**
     * 初始化客户的通用字段
     *
     * @param customer    客户信息
     * @param ownerUserId 负责人编号
     * @return 客户信息 DO
     */
    private static CrmCustomerDO initCustomer(Object customer, Long ownerUserId) {
        return BeanUtils.toBean(customer, CrmCustomerDO.class).setOwnerUserId(ownerUserId)
                .setOwnerTime(LocalDateTime.now());
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    @LogRecord(type = CRM_CUSTOMER_TYPE, subType = CRM_CUSTOMER_UPDATE_SUB_TYPE, bizNo = "{{#updateReqVO.id}}",
            success = CRM_CUSTOMER_UPDATE_SUCCESS)
    @CrmPermission(bizType = CrmBizTypeEnum.CRM_CUSTOMER, bizId = "#updateReqVO.id", level = CrmPermissionLevelEnum.WRITE)
    public void updateCustomer(CrmCustomerSaveReqVO updateReqVO) {
        Assert.notNull(updateReqVO.getId(), "客户编号不能为空");
        updateReqVO.setOwnerUserId(null);  // 更新的时候，要把 updateReqVO 负责人设置为空，避免修改
        // 1. 校验存在
        CrmCustomerDO oldCustomer = validateCustomerExists(updateReqVO.getId());

        // 2. 更新客户
        CrmCustomerDO updateObj = BeanUtils.toBean(updateReqVO, CrmCustomerDO.class);
        customerMapper.updateById(updateObj);

        // 3. 记录操作日志上下文
        updateReqVO.setOwnerUserId(oldCustomer.getOwnerUserId()); // 避免操作日志出现“删除负责人”的情况
        LogRecordContext.putVariable(DiffParseFunction.OLD_OBJECT, BeanUtils.toBean(oldCustomer, CrmCustomerSaveReqVO.class));
        LogRecordContext.putVariable("customerName", oldCustomer.getName());
    }

    @Override
    @LogRecord(type = CRM_CUSTOMER_TYPE, subType = CRM_CUSTOMER_UPDATE_DEAL_STATUS_SUB_TYPE, bizNo = "{{#id}}",
            success = CRM_CUSTOMER_UPDATE_DEAL_STATUS_SUCCESS)
    @CrmPermission(bizType = CrmBizTypeEnum.CRM_CUSTOMER, bizId = "#id", level = CrmPermissionLevelEnum.WRITE)
    public void updateCustomerDealStatus(Long id, Boolean dealStatus) {
        // 1.1 校验存在
        CrmCustomerDO customer = validateCustomerExists(id);
        // 1.2 校验是否重复操作
        if (Objects.equals(customer.getDealStatus(), dealStatus)) {
            throw exception(CUSTOMER_UPDATE_DEAL_STATUS_FAIL);
        }

        // 2. 更新客户的成交状态
        customerMapper.updateById(new CrmCustomerDO().setId(id).setDealStatus(dealStatus));

        // 3. 记录操作日志上下文
        LogRecordContext.putVariable("customerName", customer.getName());
        LogRecordContext.putVariable("dealStatus", dealStatus);
    }

    @Override
    @LogRecord(type = CRM_CUSTOMER_TYPE, subType = CRM_CUSTOMER_FOLLOW_UP_SUB_TYPE, bizNo = "{{#id}}",
            success = CRM_CUSTOMER_FOLLOW_UP_SUCCESS)
    @CrmPermission(bizType = CrmBizTypeEnum.CRM_CUSTOMER, bizId = "#id", level = CrmPermissionLevelEnum.WRITE)
    public void updateCustomerFollowUp(Long id, LocalDateTime contactNextTime, String contactLastContent) {
        // 1.1 校验存在
        CrmCustomerDO customer = validateCustomerExists(id);

        // 2. 更新客户的跟进信息
        customerMapper.updateById(new CrmCustomerDO().setId(id).setFollowUpStatus(true).setContactNextTime(contactNextTime)
                .setContactLastTime(LocalDateTime.now()).setContactLastContent(contactLastContent));

        // 3. 记录操作日志上下文
        LogRecordContext.putVariable("customerName", customer.getName());
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    @LogRecord(type = CRM_CUSTOMER_TYPE, subType = CRM_CUSTOMER_DELETE_SUB_TYPE, bizNo = "{{#id}}",
            success = CRM_CUSTOMER_DELETE_SUCCESS)
    @CrmPermission(bizType = CrmBizTypeEnum.CRM_CUSTOMER, bizId = "#id", level = CrmPermissionLevelEnum.OWNER)
    public void deleteCustomer(Long id) {
        // 1.1 校验存在
        CrmCustomerDO customer = validateCustomerExists(id);
        // 1.2 检查引用
        validateCustomerReference(id);

        // 2. 删除客户
        customerMapper.deleteById(id);
        // 3. 删除数据权限
        permissionService.deletePermission(CrmBizTypeEnum.CRM_CUSTOMER.getType(), id);

        // 4. 记录操作日志上下文
        LogRecordContext.putVariable("customerName", customer.getName());
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    @LogRecord(type = CRM_CUSTOMER_TYPE, subType = CRM_CUSTOMER_TRANSFER_SUB_TYPE, bizNo = "{{#reqVO.id}}",
            success = CRM_CUSTOMER_TRANSFER_SUCCESS)
    @CrmPermission(bizType = CrmBizTypeEnum.CRM_CUSTOMER, bizId = "#reqVO.id", level = CrmPermissionLevelEnum.OWNER)
    public void transferCustomer(CrmCustomerTransferReqVO reqVO, Long userId) {
        // 1.1 校验客户是否存在
        CrmCustomerDO customer = validateCustomerExists(reqVO.getId());
        // 1.2 校验拥有客户是否到达上限
        validateCustomerExceedOwnerLimit(reqVO.getNewOwnerUserId(), 1);
        // 2.1 数据权限转移
        permissionService.transferPermission(new CrmPermissionTransferReqBO(userId, CrmBizTypeEnum.CRM_CUSTOMER.getType(),
                reqVO.getId(), reqVO.getNewOwnerUserId(), reqVO.getOldOwnerPermissionLevel()));
        // 2.2 转移后重新设置负责人
        customerMapper.updateById(new CrmCustomerDO().setId(reqVO.getId())
                .setOwnerUserId(reqVO.getNewOwnerUserId()).setOwnerTime(LocalDateTime.now()));

        ownerHistoryService.insertHistory(customer.getId(), "TRANSFER", customer.getOwnerUserId(),
                reqVO.getNewOwnerUserId(), "客户负责人转移", userId, LocalDateTime.now());

        // 2.3 同时转移
        if (CollUtil.isNotEmpty(reqVO.getToBizTypes())) {
            transfer(reqVO, userId);
        }

        // 3. 记录转移日志
        LogRecordContext.putVariable("customer", customer);
    }

    /**
     * 转移客户时，需要额外有【联系人】【商机】【合同】
     *
     * @param reqVO  请求
     * @param userId 用户编号
     */
    private void transfer(CrmCustomerTransferReqVO reqVO, Long userId) {
        if (reqVO.getToBizTypes().contains(CrmBizTypeEnum.CRM_CONTACT.getType())) {
            List<CrmContactDO> contactList = contactService.getContactListByCustomerIdOwnerUserId(reqVO.getId(), userId);
            contactList.forEach(item -> contactService.transferContact(new CrmContactTransferReqVO(item.getId(), reqVO.getNewOwnerUserId(),
                    reqVO.getOldOwnerPermissionLevel()), userId));
        }
        if (reqVO.getToBizTypes().contains(CrmBizTypeEnum.CRM_BUSINESS.getType())) {
            List<CrmBusinessDO> businessList = businessService.getBusinessListByCustomerIdOwnerUserId(reqVO.getId(), userId);
            businessList.forEach(item -> businessService.transferBusiness(new CrmBusinessTransferReqVO(item.getId(), reqVO.getNewOwnerUserId(),
                    reqVO.getOldOwnerPermissionLevel()), userId));
        }
        if (reqVO.getToBizTypes().contains(CrmBizTypeEnum.CRM_CONTRACT.getType())) {
            List<CrmContractDO> contractList = contractService.getContractListByCustomerIdOwnerUserId(reqVO.getId(), userId);
            contractList.forEach(item -> contractService.transferContract(new CrmContractTransferReqVO(item.getId(), reqVO.getNewOwnerUserId(),
                    reqVO.getOldOwnerPermissionLevel()), userId));
        }
    }

    @Override
    @LogRecord(type = CRM_CUSTOMER_TYPE, subType = CRM_CUSTOMER_LOCK_SUB_TYPE, bizNo = "{{#lockReqVO.id}}",
            success = CRM_CUSTOMER_LOCK_SUCCESS)
    @CrmPermission(bizType = CrmBizTypeEnum.CRM_CUSTOMER, bizId = "#lockReqVO.id", level = CrmPermissionLevelEnum.OWNER)
    public void lockCustomer(CrmCustomerLockReqVO lockReqVO, Long userId) {
        // 1.1 校验当前客户是否存在
        CrmCustomerDO customer = validateCustomerExists(lockReqVO.getId());
        // 1.2 校验当前是否重复操作锁定/解锁状态
        if (customer.getLockStatus().equals(lockReqVO.getLockStatus())) {
            throw exception(customer.getLockStatus() ? CUSTOMER_LOCK_FAIL_IS_LOCK : CUSTOMER_UNLOCK_FAIL_IS_UNLOCK);
        }
        // 1.3 校验锁定上限
        if (lockReqVO.getLockStatus()) {
            validateCustomerExceedLockLimit(userId);
        }

        // 2. 更新锁定状态
        customerMapper.updateById(BeanUtils.toBean(lockReqVO, CrmCustomerDO.class));

        // 3. 记录操作日志上下文
        // tips: 因为这里使用的是老的状态所以记录时反着记录，也就是 lockStatus 为 true 那么就是解锁反之为锁定
        LogRecordContext.putVariable("customer", customer);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    @LogRecord(type = CRM_CUSTOMER_TYPE, subType = CRM_CUSTOMER_CREATE_SUB_TYPE, bizNo = "{{#customer.id}}",
            success = CRM_CUSTOMER_CREATE_SUCCESS)
    public Long createCustomer(CrmCustomerCreateReqBO createReqBO, Long userId) {
        // 1. 插入客户
        CrmCustomerDO customer = initCustomer(createReqBO, userId);
        customerMapper.insert(customer);

        // 2. 创建数据权限
        permissionService.createPermission(new CrmPermissionCreateReqBO().setBizType(CrmBizTypeEnum.CRM_CUSTOMER.getType())
                .setBizId(customer.getId()).setUserId(userId).setLevel(CrmPermissionLevelEnum.OWNER.getLevel())); // 设置当前操作的人为负责人

        // 3. 记录操作日志上下文
        LogRecordContext.putVariable("customer", customer);
        return customer.getId();
    }

    @Override
    public CrmCustomerImportRespVO importCustomerList(List<CrmCustomerImportExcelVO> importCustomers,
                                                      CrmCustomerImportReqVO importReqVO) {
        // 校验非空
        importCustomers = filterList(importCustomers, item -> Objects.nonNull(item.getName()));
        if (CollUtil.isEmpty(importCustomers)) {
            throw exception(CUSTOMER_IMPORT_LIST_IS_EMPTY);
        }

        // 逐条处理
        CrmCustomerImportRespVO respVO = CrmCustomerImportRespVO.builder().createCustomerNames(new ArrayList<>())
                .updateCustomerNames(new ArrayList<>()).failureCustomerNames(new LinkedHashMap<>()).build();
        importCustomers.forEach(importCustomer -> {
            // 校验，判断是否有不符合的原因
            try {
                validateCustomerForCreate(importCustomer);
            } catch (ServiceException ex) {
                respVO.getFailureCustomerNames().put(importCustomer.getName(), ex.getMessage());
                return;
            }
            // 情况一：判断如果不存在，在进行插入
            CrmCustomerDO existCustomer = customerMapper.selectByCustomerName(importCustomer.getName());
            if (existCustomer == null) {
                // 1.1 插入客户信息
                CrmCustomerDO customer = initCustomer(importCustomer, importReqVO.getOwnerUserId());
                customerMapper.insert(customer);
                respVO.getCreateCustomerNames().add(importCustomer.getName());
                // 1.2 创建数据权限
                if (importReqVO.getOwnerUserId() != null) {
                    permissionService.createPermission(new CrmPermissionCreateReqBO().setBizType(CrmBizTypeEnum.CRM_CUSTOMER.getType())
                            .setBizId(customer.getId()).setUserId(importReqVO.getOwnerUserId()).setLevel(CrmPermissionLevelEnum.OWNER.getLevel()));
                }
                // 1.3 记录操作日志
                getSelf().importCustomerLog(customer, false);
                return;
            }

            // 情况二：如果存在，判断是否允许更新
            if (!importReqVO.getUpdateSupport()) {
                respVO.getFailureCustomerNames().put(importCustomer.getName(),
                        StrUtil.format(CUSTOMER_NAME_EXISTS.getMsg(), importCustomer.getName()));
                return;
            }
            // 2.1 更新客户信息
            CrmCustomerDO updateCustomer = BeanUtils.toBean(importCustomer, CrmCustomerDO.class)
                    .setId(existCustomer.getId());
            customerMapper.updateById(updateCustomer);
            respVO.getUpdateCustomerNames().add(importCustomer.getName());
            // 2.2 记录操作日志
            getSelf().importCustomerLog(updateCustomer, true);
        });
        return respVO;
    }

    /**
     * 记录导入客户时的操作日志
     *
     * @param customer 客户信息
     * @param isUpdate 是否更新；true - 更新，false - 新增
     */
    @LogRecord(type = CRM_CUSTOMER_TYPE, subType = CRM_CUSTOMER_IMPORT_SUB_TYPE, bizNo = "{{#customer.id}}",
            success = CRM_CUSTOMER_IMPORT_SUCCESS)
    public void importCustomerLog(CrmCustomerDO customer, boolean isUpdate) {
        LogRecordContext.putVariable("customer", customer);
        LogRecordContext.putVariable("isUpdate", isUpdate);
    }

    // ==================== 公海相关操作 ====================

    @Override
    @Transactional(rollbackFor = Exception.class)
    @LogRecord(type = CRM_CUSTOMER_TYPE, subType = CRM_CUSTOMER_POOL_SUB_TYPE, bizNo = "{{#id}}",
            success = CRM_CUSTOMER_POOL_SUCCESS)
    @CrmPermission(bizType = CrmBizTypeEnum.CRM_CUSTOMER, bizId = "#id", level = CrmPermissionLevelEnum.OWNER)
    public void putCustomerPool(Long id) {
        // 1. 校验存在
        CrmCustomerDO customer = customerMapper.selectById(id);
        if (customer == null) {
            throw exception(CUSTOMER_NOT_EXISTS);
        }
        // 1.2. 校验是否为公海数据
        validateCustomerOwnerExists(customer, true);
        // 1.3. 校验客户是否锁定
        validateCustomerIsLocked(customer, true);

        // 2. 客户放入公海
        putCustomerPool(customer, "MANUAL_PUT", getLoginUserId(), "手动移入公海");

        // 记录操作日志上下文
        LogRecordContext.putVariable("customerName", customer.getName());
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void receiveCustomer(List<Long> ids, Long ownerUserId, Boolean isReceive) {
        // 1.1 校验存在
        List<CrmCustomerDO> customers = customerMapper.selectByIds(ids);
        if (customers.size() != ids.size()) {
            throw exception(CUSTOMER_NOT_EXISTS);
        }
        // 1.2 校验负责人是否存在
        adminUserApi.validateUserList(singletonList(ownerUserId));
        // 1.3 校验状态
        customers.forEach(customer -> {
            validateCustomerOwnerExists(customer, false);
            validateCustomerIsLocked(customer, false);
            validateCustomerDeal(customer);
        });
        // 1.4 校验负责人是否到达上限
        validateCustomerExceedOwnerLimit(ownerUserId, customers.size());

        CrmCustomerPoolConfigDO poolConfig = customerPoolConfigService.getOrCreateCustomerPoolConfigForUpdate();
        Long tenantId = TenantContextHolder.getTenantId();
        LocalDateTime now = LocalDateTime.now();
        if (Boolean.TRUE.equals(isReceive)) {
            LocalDateTime dayStart = now.toLocalDate().atStartOfDay();
            LocalDateTime nextDayStart = dayStart.plusDays(1);
            long receivedToday = highSeasRecordService.getReceiveCountByUserIdAndDateRange(
                    tenantId, ownerUserId, dayStart, nextDayStart);
            if (receivedToday + customers.size() > poolConfig.getReceiveLimitPerDay()) {
                throw exception(CUSTOMER_RECEIVE_EXCEED_DAILY_LIMIT);
            }
            LocalDateTime cooldownStart = now.minusDays(poolConfig.getReceiveCooldownDays());
            for (CrmCustomerDO customer : customers) {
                if (highSeasRecordService.getReceiveCountByCustomerIdAndTimeRange(
                        tenantId, customer.getId(), ownerUserId, cooldownStart, now) > 0) {
                    throw exception(CUSTOMER_RECEIVE_COOLDOWN);
                }
            }
        }

        // 2. 领取公海数据（逐条处理，确保并发安全）
        List<CrmCustomerDO> successCustomers = new ArrayList<>();
        Long operatorUserId = isReceive ? ownerUserId : getLoginUserId();
        AdminUserRespDTO operatorUser = adminUserApi.getUser(operatorUserId);
        String operatorUserName = operatorUser != null ? operatorUser.getNickname() : "";

        for (CrmCustomerDO customer : customers) {
            int updateCount = customerMapper.updateOwnerUserIdByIdAndNull(customer.getId(), ownerUserId);
            if (updateCount == 0) {
                throw exception(CUSTOMER_RECEIVE_CONCURRENT_CONFLICT);
            }
            successCustomers.add(customer);

            // 2.2 创建负责人数据权限
            permissionService.createPermission(new CrmPermissionCreateReqBO()
                    .setBizType(CrmBizTypeEnum.CRM_CUSTOMER.getType())
                    .setBizId(customer.getId())
                    .setUserId(ownerUserId)
                    .setLevel(CrmPermissionLevelEnum.OWNER.getLevel()));

            // 2.3 联系人负责人同步
            contactService.updateOwnerUserIdByCustomerId(customer.getId(), ownerUserId);

            // 2.4 写入历史记录
            if (isReceive) {
                highSeasRecordService.insertRecord(customer.getId(), "RECEIVE",
                        null, ownerUserId, "领取公海客户", operatorUserId, now);
            }
            ownerHistoryService.insertHistory(customer.getId(), isReceive ? "RECEIVE" : "ASSIGN",
                    null, ownerUserId, isReceive ? "领取公海客户" : "分配公海客户", operatorUserId, now);
        }

        // 3. 记录操作日志
        AdminUserRespDTO user = null;
        if (!isReceive) {
            user = adminUserApi.getUser(ownerUserId);
        }
        for (CrmCustomerDO customer : successCustomers) {
            getSelf().receiveCustomerLog(customer, user == null ? null : user.getNickname());
        }
    }

    @Override
    public int autoPutCustomerPool() {
        CrmCustomerPoolConfigDO poolConfig = customerPoolConfigService.getCustomerPoolConfig();
        if (poolConfig == null || !poolConfig.getEnabled()) {
            return 0;
        }
        List<CrmCustomerDO> customerList = customerMapper.selectListByAutoPool(poolConfig);
        int count = 0;
        for (CrmCustomerDO customer : customerList) {
            try {
                getSelf().putCustomerPool(customer, "AUTO_PUT", 0L, "自动移入公海");
                count++;
            } catch (Exception e) {
                log.error("[autoPutCustomerPool][客户({}) 放入公海异常]", customer.getId(), e);
            }
        }
        return count;
    }

    @Transactional(rollbackFor = Exception.class)
    protected void putCustomerPool(CrmCustomerDO customer, String actionType, Long operatorUserId, String reason) {
        int updateOwnerUserIncr = customerMapper.updateOwnerUserIdById(customer.getId(), null);
        if (updateOwnerUserIncr == 0) {
            throw exception(CUSTOMER_UPDATE_OWNER_USER_FAIL);
        }

        contactService.updateOwnerUserIdByCustomerId(customer.getId(), null);

        permissionService.deletePermission(CrmBizTypeEnum.CRM_CUSTOMER.getType(), customer.getId(),
                CrmPermissionLevelEnum.OWNER.getLevel());

        LocalDateTime now = LocalDateTime.now();
        highSeasRecordService.insertRecord(customer.getId(), actionType, customer.getOwnerUserId(), null,
                reason, operatorUserId, now);
        ownerHistoryService.insertHistory(customer.getId(), actionType, customer.getOwnerUserId(), null,
                reason, operatorUserId, now);
    }

    @LogRecord(type = CRM_CUSTOMER_TYPE, subType = CRM_CUSTOMER_RECEIVE_SUB_TYPE, bizNo = "{{#customer.id}}",
            success = CRM_CUSTOMER_RECEIVE_SUCCESS)
    public void receiveCustomerLog(CrmCustomerDO customer, String ownerUserName) {
        // 记录操作日志上下文
        LogRecordContext.putVariable("customer", customer);
        LogRecordContext.putVariable("ownerUserName", ownerUserName);
    }

    //======================= 查询相关 =======================

    @Override
    @CrmPermission(bizType = CrmBizTypeEnum.CRM_CUSTOMER, bizId = "#id", level = CrmPermissionLevelEnum.READ)
    public CrmCustomerDO getCustomer(Long id) {
        return customerMapper.selectById(id);
    }

    @Override
    public List<CrmCustomerDO> getCustomerList(Collection<Long> ids) {
        if (CollUtil.isEmpty(ids)) {
            return Collections.emptyList();
        }
        return customerMapper.selectByIds(ids);
    }

    @Override
    public PageResult<CrmCustomerDO> getCustomerPage(CrmCustomerPageReqVO pageReqVO, Long userId) {
        return customerMapper.selectPage(pageReqVO, userId);
    }

    @Override
    public PageResult<CrmCustomerDO> getPutPoolRemindCustomerPage(CrmCustomerPageReqVO pageVO, Long userId) {
        CrmCustomerPoolConfigDO poolConfig = customerPoolConfigService.getCustomerPoolConfig();
        if (ObjUtil.isNull(poolConfig)
                || Boolean.FALSE.equals(poolConfig.getEnabled())
                || Boolean.FALSE.equals(poolConfig.getNotifyEnabled())) {
            return PageResult.empty();
        }
        return customerMapper.selectPutPoolRemindCustomerPage(pageVO, poolConfig, userId);
    }

    @Override
    public Long getPutPoolRemindCustomerCount(Long userId) {
        CrmCustomerPoolConfigDO poolConfig = customerPoolConfigService.getCustomerPoolConfig();
        if (ObjUtil.isNull(poolConfig)
                || Boolean.FALSE.equals(poolConfig.getEnabled())
                || Boolean.FALSE.equals(poolConfig.getNotifyEnabled())) {
            return 0L;
        }
        CrmCustomerPageReqVO pageVO = new CrmCustomerPageReqVO()
                .setPool(null)
                .setContactStatus(CrmCustomerPageReqVO.CONTACT_TODAY)
                .setSceneType(CrmSceneTypeEnum.OWNER.getType());
        return customerMapper.selectPutPoolRemindCustomerCount(pageVO, poolConfig, userId);
    }

    @Override
    public Long getTodayContactCustomerCount(Long userId) {
        return customerMapper.selectCountByTodayContact(userId);
    }

    @Override
    public Long getFollowCustomerCount(Long userId) {
        return customerMapper.selectCountByFollow(userId);
    }

    // ======================= 校验相关 =======================

    private void validateCustomerForCreate(CrmCustomerImportExcelVO importCustomer) {
        // 校验客户名称不能为空
        if (StrUtil.isEmptyIfStr(importCustomer.getName())) {
            throw exception(CUSTOMER_CREATE_NAME_NOT_NULL);
        }
    }

    /**
     * 校验客户是否被引用
     *
     * @param id 客户编号
     */
    private void validateCustomerReference(Long id) {
        if (contactService.getContactCountByCustomerId(id) > 0) {
            throw exception(CUSTOMER_DELETE_FAIL_HAVE_REFERENCE, CrmBizTypeEnum.CRM_CONTACT.getName());
        }
        if (businessService.getBusinessCountByCustomerId(id) > 0) {
            throw exception(CUSTOMER_DELETE_FAIL_HAVE_REFERENCE, CrmBizTypeEnum.CRM_BUSINESS.getName());
        }
        if (contractService.getContractCountByCustomerId(id) > 0) {
            throw exception(CUSTOMER_DELETE_FAIL_HAVE_REFERENCE, CrmBizTypeEnum.CRM_CONTRACT.getName());
        }
    }

    /**
     * 校验客户是否存在
     *
     * @param id 客户 id
     */
    @Override
    public void validateCustomer(Long id) {
        validateCustomerExists(id);
    }

    private void validateCustomerOwnerExists(CrmCustomerDO customer, Boolean pool) {
        if (customer == null) { // 防御一下
            throw exception(CUSTOMER_NOT_EXISTS);
        }
        // 校验是否为公海数据
        if (pool && customer.getOwnerUserId() == null) {
            throw exception(CUSTOMER_IN_POOL, customer.getName());
        }
        // 负责人已存在
        if (!pool && customer.getOwnerUserId() != null) {
            throw exception(CUSTOMER_OWNER_EXISTS, customer.getName());
        }
    }

    private CrmCustomerDO validateCustomerExists(Long id) {
        CrmCustomerDO customerDO = customerMapper.selectById(id);
        if (customerDO == null) {
            throw exception(CUSTOMER_NOT_EXISTS);
        }
        return customerDO;
    }

    private void validateCustomerIsLocked(CrmCustomerDO customer, Boolean pool) {
        if (customer.getLockStatus()) {
            throw exception(pool ? CUSTOMER_LOCKED_PUT_POOL_FAIL : CUSTOMER_LOCKED, customer.getName());
        }
    }

    private void validateCustomerDeal(CrmCustomerDO customer) {
        if (customer.getDealStatus()) {
            throw exception(CUSTOMER_ALREADY_DEAL);
        }
    }

    /**
     * 校验用户拥有的客户数量，是否到达上限
     *
     * @param userId   用户编号
     * @param newCount 附加数量
     */
    private void validateCustomerExceedOwnerLimit(Long userId, int newCount) {
        List<CrmCustomerLimitConfigDO> limitConfigs = customerLimitConfigService.getCustomerLimitConfigListByUserId(
                CUSTOMER_OWNER_LIMIT.getType(), userId);
        if (CollUtil.isEmpty(limitConfigs)) {
            return;
        }
        Long ownerCount = customerMapper.selectCountByDealStatusAndOwnerUserId(null, userId);
        Long dealOwnerCount = customerMapper.selectCountByDealStatusAndOwnerUserId(true, userId);
        limitConfigs.forEach(limitConfig -> {
            long nowCount = limitConfig.getDealCountEnabled() ? ownerCount : ownerCount - dealOwnerCount;
            if (nowCount + newCount > limitConfig.getMaxCount()) {
                throw exception(CUSTOMER_OWNER_EXCEED_LIMIT);
            }
        });
    }

    /**
     * 校验用户锁定的客户数量，是否到达上限
     *
     * @param userId 用户编号
     */
    private void validateCustomerExceedLockLimit(Long userId) {
        List<CrmCustomerLimitConfigDO> limitConfigs = customerLimitConfigService.getCustomerLimitConfigListByUserId(
                CUSTOMER_LOCK_LIMIT.getType(), userId);
        if (CollUtil.isEmpty(limitConfigs)) {
            return;
        }
        Long lockCount = customerMapper.selectCountByLockStatusAndOwnerUserId(true, userId);
        Integer maxCount = CollectionUtils.getMaxValue(limitConfigs, CrmCustomerLimitConfigDO::getMaxCount);
        assert maxCount != null;
        if (lockCount >= maxCount) {
            throw exception(CUSTOMER_LOCK_EXCEED_LIMIT);
        }
    }

    /**
     * 获得自身的代理对象，解决 AOP 生效问题
     *
     * @return 自己
     */
    private CrmCustomerServiceImpl getSelf() {
        return SpringUtil.getBean(getClass());
    }

}
