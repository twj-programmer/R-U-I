// 23计科4班 黄金戈
package com.meession.etm.module.crm.service.business;

import cn.hutool.core.collection.CollUtil;
import cn.hutool.core.collection.ListUtil;
import com.meession.etm.framework.common.pojo.PageResult;
import com.meession.etm.framework.common.util.number.MoneyUtils;
import com.meession.etm.framework.common.util.object.BeanUtils;
import com.meession.etm.module.crm.controller.admin.business.vo.business.CrmBusinessPageReqVO;
import com.meession.etm.module.crm.controller.admin.business.vo.business.CrmBusinessSaveReqVO;
import com.meession.etm.module.crm.controller.admin.business.vo.business.CrmBusinessTransferReqVO;
import com.meession.etm.module.crm.controller.admin.business.vo.business.CrmBusinessUpdateStatusReqVO;
import com.meession.etm.module.crm.controller.admin.contact.vo.CrmContactBusinessReqVO;
import com.meession.etm.module.crm.controller.admin.statistics.vo.funnel.CrmStatisticsFunnelReqVO;
import com.meession.etm.module.crm.dal.dataobject.business.CrmBusinessDO;
import com.meession.etm.module.crm.dal.dataobject.business.CrmBusinessProductDO;
import com.meession.etm.module.crm.dal.dataobject.business.CrmBusinessStatusDO;
import com.meession.etm.module.crm.dal.dataobject.contact.CrmContactBusinessDO;
import com.meession.etm.module.crm.dal.dataobject.product.CrmProductDO;
import com.meession.etm.module.crm.dal.mysql.business.CrmBusinessMapper;
import com.meession.etm.module.crm.dal.mysql.business.CrmBusinessProductMapper;
import com.meession.etm.module.crm.enums.business.CrmBusinessEndStatusEnum;
import com.meession.etm.module.crm.enums.common.CrmBizTypeEnum;
import com.meession.etm.module.crm.enums.permission.CrmPermissionLevelEnum;
import com.meession.etm.module.crm.enums.product.CrmProductStatusEnum;
import com.meession.etm.module.crm.framework.permission.core.annotations.CrmPermission;
import com.meession.etm.module.crm.service.contact.CrmContactBusinessService;
import com.meession.etm.module.crm.service.contact.CrmContactService;
import com.meession.etm.module.crm.service.contract.CrmContractService;
import com.meession.etm.module.crm.service.customer.CrmCustomerService;
import com.meession.etm.module.crm.service.permission.CrmPermissionService;
import com.meession.etm.module.crm.service.permission.bo.CrmPermissionCreateReqBO;
import com.meession.etm.module.crm.service.permission.bo.CrmPermissionTransferReqBO;
import com.meession.etm.module.crm.service.product.CrmProductService;
import com.meession.etm.module.system.api.dict.DictDataApi;
import com.meession.etm.module.system.api.user.AdminUserApi;
import com.mzt.logapi.context.LogRecordContext;
import com.mzt.logapi.service.impl.DiffParseFunction;
import com.mzt.logapi.starter.annotation.LogRecord;
import jakarta.annotation.Resource;
import org.springframework.context.annotation.Lazy;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.validation.annotation.Validated;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.time.LocalDateTime;
import java.util.Collection;
import java.util.Collections;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Objects;
import java.util.Set;

import static com.meession.etm.framework.common.exception.util.ServiceExceptionUtil.exception;
import static com.meession.etm.framework.common.exception.util.ServiceExceptionUtil.invalidParamException;
import static com.meession.etm.framework.common.util.collection.CollectionUtils.*;
import static com.meession.etm.module.crm.enums.ErrorCodeConstants.*;
import static com.meession.etm.module.crm.enums.LogRecordConstants.*;

/**
 * 商机 Service 实现类
 *
 * @author ljlleo
 */
@Service
@Validated
public class CrmBusinessServiceImpl implements CrmBusinessService {

    @Resource
    private CrmBusinessMapper businessMapper;
    @Resource
    private CrmBusinessProductMapper businessProductMapper;

    @Resource
    private CrmBusinessStatusService businessStatusService;
    @Resource
    @Lazy // 延迟加载，避免循环依赖
    private CrmContractService contractService;
    @Resource
    private CrmCustomerService customerService;
    @Resource
    @Lazy // 延迟加载，避免循环依赖
    private CrmContactService contactService;
    @Resource
    private CrmPermissionService permissionService;
    @Resource
    private CrmContactBusinessService contactBusinessService;
    @Resource
    private CrmProductService productService;
    @Resource
    private DictDataApi dictDataApi;

    @Resource
    private AdminUserApi adminUserApi;

    @Override
    @Transactional(rollbackFor = Exception.class)
    @LogRecord(type = CRM_BUSINESS_TYPE, subType = CRM_BUSINESS_CREATE_SUB_TYPE, bizNo = "{{#business.id}}",
            success = CRM_BUSINESS_CREATE_SUCCESS)
    public Long createBusiness(CrmBusinessSaveReqVO createReqVO, Long userId) {
        // 1.1 校验产品项的有效性
        List<CrmBusinessProductDO> businessProducts = buildBusinessProducts(null, createReqVO.getProducts());
        // 1.2 校验关联字段
        validateRelationDataExists(createReqVO);

        // 2.1 插入商机
        CrmBusinessDO business = BeanUtils.toBean(createReqVO, CrmBusinessDO.class);
        List<CrmBusinessStatusDO> statuses = businessStatusService.getBusinessStatusListByTypeId(
                createReqVO.getStatusTypeId());
        if (CollUtil.isEmpty(statuses)) {
            throw exception(BUSINESS_STATUS_NOT_EXISTS);
        }
        business.setStatusId(statuses.get(0).getId());
        business.setVersion(0);
        calculateTotalPrice(business, businessProducts);
        businessMapper.insert(business);
        // 2.2 插入商机关联商品
        if (CollUtil.isNotEmpty(businessProducts)) {
            businessProducts.forEach(item -> item.setBusinessId(business.getId()));
            businessProductMapper.insertBatch(businessProducts);
        }

        // 3. 创建数据权限
        permissionService.createPermission(new CrmPermissionCreateReqBO().setUserId(business.getOwnerUserId())
                .setBizType(CrmBizTypeEnum.CRM_BUSINESS.getType()).setBizId(business.getId())
                .setLevel(CrmPermissionLevelEnum.OWNER.getLevel()));

        // 4. 在联系人的详情页，如果直接【新建商机】，则需要关联下
        if (createReqVO.getContactId() != null) {
            contactBusinessService.createContactBusinessList(new CrmContactBusinessReqVO()
                    .setContactId(createReqVO.getContactId()).setBusinessIds(Collections.singletonList(business.getId())));
        }

        // 5. 记录操作日志上下文
        LogRecordContext.putVariable("business", business);
        return business.getId();
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    @LogRecord(type = CRM_BUSINESS_TYPE, subType = CRM_BUSINESS_UPDATE_SUB_TYPE, bizNo = "{{#updateReqVO.id}}",
            success = CRM_BUSINESS_UPDATE_SUCCESS)
    @CrmPermission(bizType = CrmBizTypeEnum.CRM_BUSINESS, bizId = "#updateReqVO.id", level = CrmPermissionLevelEnum.WRITE)
    public void updateBusiness(CrmBusinessSaveReqVO updateReqVO) {
        updateReqVO.setOwnerUserId(null).setStatusTypeId(null); // 不允许更新的字段
        // 1.1 校验存在和终态
        CrmBusinessDO oldBusiness = validateBusinessExists(updateReqVO.getId());
        if (oldBusiness.getEndStatus() != null) {
            throw exception(BUSINESS_UPDATE_STATUS_FAIL_END_STATUS);
        }
        if (updateReqVO.getVersion() == null) {
            throw invalidParamException("版本号不能为空");
        }
        // 1.2 校验产品项和关联字段
        List<CrmBusinessProductDO> businessProducts = buildBusinessProducts(
                updateReqVO.getId(), updateReqVO.getProducts());
        validateRelationDataExists(updateReqVO);

        // 2.1 使用乐观锁更新商机和汇总金额
        CrmBusinessDO updateObj = BeanUtils.toBean(updateReqVO, CrmBusinessDO.class);
        calculateTotalPrice(updateObj, businessProducts);
        if (businessMapper.updateBusinessByVersion(updateObj, updateReqVO.getVersion()) == 0) {
            throwVersionConflict();
        }
        // 2.2 在同一事务内更新关联商品
        updateBusinessProduct(updateObj.getId(), businessProducts);

        // 3. 记录操作日志上下文
        updateReqVO.setOwnerUserId(oldBusiness.getOwnerUserId()); // 避免操作日志出现“删除负责人”的情况
        LogRecordContext.putVariable(DiffParseFunction.OLD_OBJECT,
                BeanUtils.toBean(oldBusiness, CrmBusinessSaveReqVO.class));
        LogRecordContext.putVariable("businessName", oldBusiness.getName());
    }

    @Override
    @LogRecord(type = CRM_BUSINESS_TYPE, subType = CRM_BUSINESS_FOLLOW_UP_SUB_TYPE, bizNo = "{{#id}}",
            success = CRM_BUSINESS_FOLLOW_UP_SUCCESS)
    @CrmPermission(bizType = CrmBizTypeEnum.CRM_BUSINESS, bizId = "#id", level = CrmPermissionLevelEnum.WRITE)
    public void updateBusinessFollowUp(Long id, LocalDateTime contactNextTime, String contactLastContent) {
        // 1. 校验存在
        CrmBusinessDO business = validateBusinessExists(id);
        // 2. 更新商机的跟进信息
        businessMapper.updateById(new CrmBusinessDO().setId(id).setFollowUpStatus(true)
                .setContactNextTime(contactNextTime).setContactLastTime(LocalDateTime.now()));
        // 3. 记录操作日志上下文
        LogRecordContext.putVariable("businessName", business.getName());
    }

    @Override
    @CrmPermission(bizType = CrmBizTypeEnum.CRM_BUSINESS, bizId = "#ids", level = CrmPermissionLevelEnum.WRITE)
    public void updateBusinessContactNextTime(Collection<Long> ids, LocalDateTime contactNextTime) {
        businessMapper.updateBatch(convertList(ids, id -> new CrmBusinessDO().setId(id).setContactNextTime(contactNextTime)));
    }

    private void updateBusinessProduct(Long id, List<CrmBusinessProductDO> newList) {
        List<CrmBusinessProductDO> oldList = businessProductMapper.selectListByBusinessId(id);
        List<List<CrmBusinessProductDO>> diffList = diffList(oldList, newList, // id 不同，就认为是不同的记录
                (oldVal, newVal) -> oldVal.getId().equals(newVal.getId()));
        if (CollUtil.isNotEmpty(diffList.get(0))) {
            diffList.get(0).forEach(item -> item.setBusinessId(id));
            businessProductMapper.insertBatch(diffList.get(0));
        }
        if (CollUtil.isNotEmpty(diffList.get(1))) {
            businessProductMapper.updateBatch(diffList.get(1));
        }
        if (CollUtil.isNotEmpty(diffList.get(2))) {
            businessProductMapper.deleteByIds(convertSet(diffList.get(2), CrmBusinessProductDO::getId));
        }
    }

    private void validateRelationDataExists(CrmBusinessSaveReqVO saveReqVO) {
        // 校验商机状态
        if (saveReqVO.getStatusTypeId() != null) {
            businessStatusService.validateBusinessStatusType(saveReqVO.getStatusTypeId());
        }
        // 校验客户
        if (saveReqVO.getCustomerId() != null) {
            customerService.validateCustomer(saveReqVO.getCustomerId());
        }
        // 校验联系人
        if (saveReqVO.getContactId() != null) {
            contactService.validateContact(saveReqVO.getContactId());
        }
        // 校验负责人
        if (saveReqVO.getOwnerUserId() != null) {
            adminUserApi.validateUser(saveReqVO.getOwnerUserId());
        }
    }

    private List<CrmBusinessProductDO> buildBusinessProducts(
            Long businessId, List<CrmBusinessSaveReqVO.BusinessProduct> requestProducts) {
        List<CrmBusinessSaveReqVO.BusinessProduct> products =
                requestProducts == null ? Collections.emptyList() : requestProducts;
        validateNoDuplicateProducts(products);
        if (products.isEmpty()) {
            return Collections.emptyList();
        }

        Map<Long, CrmBusinessProductDO> oldProductMap = businessId == null ? Collections.emptyMap()
                : convertMap(businessProductMapper.selectListByBusinessId(businessId), CrmBusinessProductDO::getId);
        Set<Long> productIds = convertSet(products, CrmBusinessSaveReqVO.BusinessProduct::getProductId);
        Map<Long, CrmProductDO> currentProductMap = convertMap(
                productService.getProductList(productIds), CrmProductDO::getId);

        return convertList(products, item -> {
            CrmBusinessProductDO oldProduct = item.getId() == null ? null : oldProductMap.get(item.getId());
            if (item.getId() != null && (oldProduct == null
                    || !Objects.equals(oldProduct.getProductId(), item.getProductId()))) {
                throw invalidParamException("商机产品行不存在或不属于当前商机");
            }
            CrmProductDO currentProduct = currentProductMap.get(item.getProductId());
            if (oldProduct == null && currentProduct == null) {
                throw exception(PRODUCT_NOT_EXISTS);
            }
            if (oldProduct == null && CrmProductStatusEnum.isDisable(currentProduct.getStatus())) {
                throw exception(PRODUCT_NOT_ENABLE, currentProduct.getName());
            }
            if (oldProduct != null && (currentProduct == null || CrmProductStatusEnum.isDisable(currentProduct.getStatus()))
                    && (!sameAmount(oldProduct.getBusinessPrice(), item.getBusinessPrice())
                    || !sameAmount(oldProduct.getCount(), item.getCount()))) {
                throw exception(PRODUCT_NOT_ENABLE,
                        currentProduct != null ? currentProduct.getName() : item.getProductId());
            }
            BigDecimal productPrice = oldProduct != null ? oldProduct.getProductPrice() : currentProduct.getPrice();
            return buildBusinessProduct(item, productPrice);
        });
    }

    private void validateNoDuplicateProducts(List<CrmBusinessSaveReqVO.BusinessProduct> products) {
        Set<Long> productIds = new HashSet<>();
        for (CrmBusinessSaveReqVO.BusinessProduct item : products) {
            if (item == null || item.getProductId() == null || !productIds.add(item.getProductId())) {
                throw invalidParamException("同一商机不得重复选择同一产品");
            }
        }
    }

    private CrmBusinessProductDO buildBusinessProduct(
            CrmBusinessSaveReqVO.BusinessProduct item, BigDecimal productPrice) {
        validateAmount(item.getBusinessPrice(), 2, "商机价格");
        validateAmount(item.getCount(), 3, "产品数量");
        BigDecimal lineTotal = item.getBusinessPrice().multiply(item.getCount())
                .setScale(2, RoundingMode.HALF_UP);
        validateDatabaseAmount(lineTotal);
        return new CrmBusinessProductDO().setId(item.getId()).setProductId(item.getProductId())
                .setProductPrice(productPrice).setBusinessPrice(item.getBusinessPrice())
                .setCount(item.getCount()).setTotalPrice(lineTotal);
    }

    private void calculateTotalPrice(CrmBusinessDO business, List<CrmBusinessProductDO> businessProducts) {
        validateDiscountPercent(business.getDiscountPercent());
        BigDecimal totalProductPrice = getSumValue(businessProducts, CrmBusinessProductDO::getTotalPrice,
                BigDecimal::add, BigDecimal.ZERO).setScale(2, RoundingMode.HALF_UP);
        BigDecimal discountPrice = MoneyUtils.priceMultiplyPercent(
                totalProductPrice, business.getDiscountPercent()).setScale(2, RoundingMode.HALF_UP);
        BigDecimal totalPrice = totalProductPrice.subtract(discountPrice).setScale(2, RoundingMode.HALF_UP);
        validateDatabaseAmount(totalProductPrice);
        validateDatabaseAmount(totalPrice);
        business.setTotalProductPrice(totalProductPrice).setTotalPrice(totalPrice);
    }

    private void validateDiscountPercent(BigDecimal value) {
        if (value == null || value.scale() > 2 || value.compareTo(BigDecimal.ZERO) < 0
                || value.compareTo(new BigDecimal("100")) > 0) {
            throw invalidParamException("整单折扣必须在 0 到 100 之间且最多 2 位小数");
        }
    }

    private void validateAmount(BigDecimal value, int maxScale, String fieldName) {
        if (value == null || value.scale() > maxScale || getIntegerDigits(value) > 18
                || value.compareTo(BigDecimal.ZERO) <= 0) {
            throw invalidParamException(fieldName + "必须大于 0、整数最多 18 位且最多 " + maxScale + " 位小数");
        }
    }

    private int getIntegerDigits(BigDecimal value) {
        return Math.max(value.precision() - value.scale(), 0);
    }

    private void validateDatabaseAmount(BigDecimal value) {
        if (getIntegerDigits(value) > 18) {
            throw invalidParamException("报价金额超出数据库可保存范围");
        }
    }

    private boolean sameAmount(BigDecimal left, BigDecimal right) {
        return left != null && right != null && left.compareTo(right) == 0;
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    @LogRecord(type = CRM_BUSINESS_TYPE, subType = CRM_BUSINESS_UPDATE_STATUS_SUB_TYPE, bizNo = "{{#reqVO.id}}",
            success = CRM_BUSINESS_UPDATE_STATUS_SUCCESS)
    @CrmPermission(bizType = CrmBizTypeEnum.CRM_BUSINESS, bizId = "#reqVO.id", level = CrmPermissionLevelEnum.WRITE)
    public void updateBusinessStatus(CrmBusinessUpdateStatusReqVO reqVO) {
        if ((reqVO.getStatusId() == null) == (reqVO.getEndStatus() == null)) {
            throw invalidParamException("商机阶段和结束状态必须且只能选择一项");
        }
        CrmBusinessDO business = validateBusinessExists(reqVO.getId());
        if (business.getEndStatus() != null) {
            throw exception(BUSINESS_UPDATE_STATUS_FAIL_END_STATUS);
        }
        CrmBusinessStatusDO currentStatus = business.getStatusId() == null ? null
                : businessStatusService.getBusinessStatus(business.getStatusId());
        if (currentStatus == null || !Objects.equals(business.getStatusTypeId(), currentStatus.getTypeId())) {
            throw invalidParamException("当前商机阶段数据异常，请先核验阶段配置");
        }

        CrmBusinessStatusDO targetStatus = null;
        int updateCount;
        if (reqVO.getStatusId() != null) {
            if (isNotBlank(reqVO.getLoseReasonCode()) || isNotBlank(reqVO.getEndRemark())) {
                throw invalidParamException("进行中阶段不得携带终态原因或说明");
            }
            targetStatus = businessStatusService.validateBusinessStatus(
                    business.getStatusTypeId(), reqVO.getStatusId());
            if (reqVO.getStatusId().equals(business.getStatusId())) {
                throw exception(BUSINESS_UPDATE_STATUS_FAIL_STATUS_EQUALS);
            }
            if (targetStatus.getSort() <= currentStatus.getSort()) {
                throw invalidParamException("商机阶段只能在同一状态组内向前流转");
            }
            updateCount = businessMapper.updateStageByVersion(
                    reqVO.getId(), reqVO.getVersion(), reqVO.getStatusId());
        } else {
            validateEndStatusRequest(reqVO);
            updateCount = businessMapper.updateEndStatusByVersion(reqVO.getId(), reqVO.getVersion(),
                    reqVO.getEndStatus(), trimToNull(reqVO.getLoseReasonCode()), trimToNull(reqVO.getEndRemark()));
        }
        if (updateCount == 0) {
            throwVersionConflict();
        }

        LogRecordContext.putVariable("businessName", business.getName());
        LogRecordContext.putVariable("oldStatusName", getBusinessStatusName(business.getEndStatus(), currentStatus));
        LogRecordContext.putVariable("newStatusName", getBusinessStatusName(reqVO.getEndStatus(), targetStatus));
    }

    private void validateEndStatusRequest(CrmBusinessUpdateStatusReqVO reqVO) {
        CrmBusinessEndStatusEnum endStatus = CrmBusinessEndStatusEnum.fromStatus(reqVO.getEndStatus());
        if (endStatus == null) {
            throw invalidParamException("商机结束状态不正确");
        }
        if (endStatus == CrmBusinessEndStatusEnum.LOSE) {
            String reason = trimToNull(reqVO.getLoseReasonCode());
            if (reason == null) {
                throw invalidParamException("输单原因不能为空");
            }
            dictDataApi.validateDictDataList("crm_business_lose_reason", List.of(reason));
        } else if (isNotBlank(reqVO.getLoseReasonCode())) {
            throw invalidParamException("赢单或无效状态不得携带输单原因");
        }
    }

    private void throwVersionConflict() {
        throw exception(BUSINESS_UPDATE_VERSION_CONFLICT);
    }

    private boolean isNotBlank(String value) {
        return value != null && !value.trim().isEmpty();
    }

    private String trimToNull(String value) {
        return isNotBlank(value) ? value.trim() : null;
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    @LogRecord(type = CRM_BUSINESS_TYPE, subType = CRM_BUSINESS_DELETE_SUB_TYPE, bizNo = "{{#id}}",
            success = CRM_BUSINESS_DELETE_SUCCESS)
    @CrmPermission(bizType = CrmBizTypeEnum.CRM_BUSINESS, bizId = "#id", level = CrmPermissionLevelEnum.OWNER)
    public void deleteBusiness(Long id) {
        // 1.1 校验存在
        CrmBusinessDO business = validateBusinessExists(id);
        // 1.2 校验是否关联合同
        validateContractExists(id);

        // 删除商机
        businessMapper.deleteById(id);
        // 删除数据权限
        permissionService.deletePermission(CrmBizTypeEnum.CRM_BUSINESS.getType(), id);

        // 记录操作日志上下文
        LogRecordContext.putVariable("businessName", business.getName());
    }

    /**
     * 删除校验合同是关联合同
     *
     * @param businessId 商机id
     * @author lzxhqs
     */
    private void validateContractExists(Long businessId) {
        if (contractService.getContractCountByBusinessId(businessId) > 0) {
            throw exception(BUSINESS_DELETE_FAIL_CONTRACT_EXISTS);
        }
    }

    private CrmBusinessDO validateBusinessExists(Long id) {
        CrmBusinessDO crmBusiness = businessMapper.selectById(id);
        if (crmBusiness == null) {
            throw exception(BUSINESS_NOT_EXISTS);
        }
        return crmBusiness;
    }


    @Override
    @Transactional(rollbackFor = Exception.class)
    @LogRecord(type = CRM_BUSINESS_TYPE, subType = CRM_BUSINESS_TRANSFER_SUB_TYPE, bizNo = "{{#reqVO.id}}",
            success = CRM_BUSINESS_TRANSFER_SUCCESS)
    @CrmPermission(bizType = CrmBizTypeEnum.CRM_BUSINESS, bizId = "#reqVO.id", level = CrmPermissionLevelEnum.OWNER)
    public void transferBusiness(CrmBusinessTransferReqVO reqVO, Long userId) {
        // 1 校验商机是否存在
        CrmBusinessDO business = validateBusinessExists(reqVO.getId());

        // 2.1 数据权限转移
        permissionService.transferPermission(new CrmPermissionTransferReqBO(userId, CrmBizTypeEnum.CRM_BUSINESS.getType(),
                reqVO.getId(), reqVO.getNewOwnerUserId(), reqVO.getOldOwnerPermissionLevel()));
        // 2.2 设置新的负责人
        businessMapper.updateOwnerUserIdById(reqVO.getId(), reqVO.getNewOwnerUserId());

        // 记录操作日志上下文
        LogRecordContext.putVariable("business", business);
    }

    //======================= 查询相关 =======================

    @Override
    @CrmPermission(bizType = CrmBizTypeEnum.CRM_BUSINESS, bizId = "#id", level = CrmPermissionLevelEnum.READ)
    public CrmBusinessDO getBusiness(Long id) {
        return businessMapper.selectById(id);
    }

    @Override
    public CrmBusinessDO validateBusiness(Long id) {
        return validateBusinessExists(id);
    }

    @Override
    public List<CrmBusinessDO> getBusinessList(Collection<Long> ids) {
        if (CollUtil.isEmpty(ids)) {
            return ListUtil.empty();
        }
        return businessMapper.selectByIds(ids);
    }

    @Override
    public List<CrmBusinessProductDO> getBusinessProductListByBusinessId(Long businessId) {
        return businessProductMapper.selectListByBusinessId(businessId);
    }

    @Override
    public PageResult<CrmBusinessDO> getBusinessPage(CrmBusinessPageReqVO pageReqVO, Long userId) {
        return businessMapper.selectPage(pageReqVO, userId);
    }

    @Override
    @CrmPermission(bizType = CrmBizTypeEnum.CRM_CUSTOMER, bizId = "#pageReqVO.customerId", level = CrmPermissionLevelEnum.READ)
    public PageResult<CrmBusinessDO> getBusinessPageByCustomerId(CrmBusinessPageReqVO pageReqVO) {
        return businessMapper.selectPageByCustomerId(pageReqVO);
    }

    @Override
    @CrmPermission(bizType = CrmBizTypeEnum.CRM_CONTACT, bizId = "#pageReqVO.contactId", level = CrmPermissionLevelEnum.READ)
    public PageResult<CrmBusinessDO> getBusinessPageByContact(CrmBusinessPageReqVO pageReqVO) {
        // 1. 查询关联的商机编号
        List<CrmContactBusinessDO> contactBusinessList = contactBusinessService.getContactBusinessListByContactId(
                pageReqVO.getContactId());
        if (CollUtil.isEmpty(contactBusinessList)) {
            return PageResult.empty();
        }
        // 2. 查询商机分页
        return businessMapper.selectPageByContactId(pageReqVO,
                convertSet(contactBusinessList, CrmContactBusinessDO::getBusinessId));
    }

    @Override
    public Long getBusinessCountByCustomerId(Long customerId) {
        return businessMapper.selectCount(CrmBusinessDO::getCustomerId, customerId);
    }

    @Override
    public Long getActiveBusinessCountByCustomerId(Long customerId) {
        return businessMapper.selectActiveCountByCustomerId(customerId);
    }

    @Override
    public Long getBusinessCountByStatusTypeId(Long statusTypeId) {
        return businessMapper.selectCountByStatusTypeId(statusTypeId);
    }

    @Override
    public List<CrmBusinessDO> getBusinessListByCustomerIdOwnerUserId(Long customerId, Long ownerUserId) {
        return businessMapper.selectListByCustomerIdOwnerUserId(customerId, ownerUserId);
    }

    @Override
    public PageResult<CrmBusinessDO> getBusinessPageByDate(CrmStatisticsFunnelReqVO pageVO) {
        return businessMapper.selectPage(pageVO);
    }

}
