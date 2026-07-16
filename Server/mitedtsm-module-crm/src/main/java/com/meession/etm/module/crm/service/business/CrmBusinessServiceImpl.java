// 23计科4班 黄金戈
package com.meession.etm.module.crm.service.business;

import cn.hutool.core.collection.CollUtil;
import cn.hutool.core.collection.ListUtil;
import com.meession.etm.framework.common.biz.system.dict.dto.DictDataRespDTO;
import com.meession.etm.framework.common.enums.CommonStatusEnum;
import com.meession.etm.framework.common.pojo.PageResult;
import com.meession.etm.framework.common.util.object.BeanUtils;
import com.meession.etm.module.crm.controller.admin.business.vo.business.*;
import com.meession.etm.module.crm.controller.admin.contact.vo.CrmContactBusinessReqVO;
import com.meession.etm.module.crm.controller.admin.statistics.vo.funnel.CrmStatisticsFunnelReqVO;
import com.meession.etm.module.crm.dal.dataobject.business.CrmBusinessDO;
import com.meession.etm.module.crm.dal.dataobject.business.CrmBusinessProductDO;
import com.meession.etm.module.crm.dal.dataobject.business.CrmBusinessStatusDO;
import com.meession.etm.module.crm.dal.dataobject.contact.CrmContactBusinessDO;
import com.meession.etm.module.crm.dal.dataobject.product.CrmProductDO;
import com.meession.etm.module.crm.dal.mysql.business.CrmBusinessMapper;
import com.meession.etm.module.crm.dal.mysql.business.CrmBusinessProductMapper;
import com.meession.etm.module.crm.enums.common.CrmBizTypeEnum;
import com.meession.etm.module.crm.enums.business.CrmBusinessEndStatusEnum;
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
import com.meession.etm.module.system.api.user.AdminUserApi;
import com.meession.etm.module.system.api.dict.DictDataApi;
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
import static com.meession.etm.framework.common.util.collection.CollectionUtils.*;
import static com.meession.etm.module.crm.enums.ErrorCodeConstants.*;
import static com.meession.etm.module.crm.enums.LogRecordConstants.*;
import static com.meession.etm.module.crm.enums.DictTypeConstants.CRM_BUSINESS_LOSE_REASON;

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
    public Long createBusiness(CrmBusinessCreateReqVO createReqVO, Long userId) {
        // 1.1 校验产品项的有效性
        List<CrmBusinessProductDO> businessProducts = buildBusinessProductsForCreate(createReqVO.getProducts());
        // 1.2 校验关联字段
        validateCreateRelationDataExists(createReqVO);

        // 2.1 插入商机
        CrmBusinessDO business = BeanUtils.toBean(createReqVO, CrmBusinessDO.class);
        List<CrmBusinessStatusDO> statuses = businessStatusService.getBusinessStatusListByTypeId(createReqVO.getStatusTypeId());
        if (CollUtil.isEmpty(statuses)) {
            throw exception(BUSINESS_STATUS_NOT_EXISTS);
        }
        business.setStatusId(statuses.get(0).getId()); // 默认使用排序最小的有效阶段
        business.setVersion(0);
        applyQuotationAmounts(business, businessProducts, createReqVO.getDiscountPercent());
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
            contactBusinessService.createContactBusinessList(new CrmContactBusinessReqVO().setContactId(createReqVO.getContactId())
                    .setBusinessIds(Collections.singletonList(business.getId())));
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
    public Integer updateBusiness(CrmBusinessUpdateReqVO updateReqVO) {
        // 1.1 校验存在
        CrmBusinessDO oldBusiness = validateBusinessExists(updateReqVO.getId());
        if (oldBusiness.getEndStatus() != null) {
            throw exception(BUSINESS_UPDATE_STATUS_FAIL_END_STATUS);
        }
        // 1.2 校验关联字段
        validateUpdateRelationDataExists(updateReqVO);

        // 2. 使用乐观锁更新基础资料；报价字段不从本接口写入
        CrmBusinessDO updateObj = BeanUtils.toBean(updateReqVO, CrmBusinessDO.class);
        updateObj.setVersion(null);
        if (businessMapper.updateBasicByVersion(updateObj, updateReqVO.getVersion()) == 0) {
            handleOptimisticLockFailure(updateReqVO.getId(), true);
        }

        // 3. 记录操作日志上下文
        LogRecordContext.putVariable(DiffParseFunction.OLD_OBJECT, BeanUtils.toBean(oldBusiness, CrmBusinessUpdateReqVO.class));
        LogRecordContext.putVariable("businessName", oldBusiness.getName());
        return updateReqVO.getVersion() + 1;
    }

    @Override
    @LogRecord(type = CRM_BUSINESS_TYPE, subType = CRM_BUSINESS_FOLLOW_UP_SUB_TYPE, bizNo = "{{#id}}",
            success = CRM_BUSINESS_FOLLOW_UP_SUCCESS)
    @CrmPermission(bizType = CrmBizTypeEnum.CRM_BUSINESS, bizId = "#id", level = CrmPermissionLevelEnum.WRITE)
    public void updateBusinessFollowUp(Long id, LocalDateTime contactNextTime, String contactLastContent) {
        // 1. 校验存在
        CrmBusinessDO business = validateBusinessExists(id);

        // 2. 更新联系人的跟进信息
        businessMapper.updateById(new CrmBusinessDO().setId(id).setFollowUpStatus(true).setContactNextTime(contactNextTime)
                .setContactLastTime(LocalDateTime.now()));

        // 3. 记录操作日志上下文
        LogRecordContext.putVariable("businessName", business.getName());
    }

    @Override
    @CrmPermission(bizType = CrmBizTypeEnum.CRM_BUSINESS, bizId = "#ids", level = CrmPermissionLevelEnum.WRITE)
    public void updateBusinessContactNextTime(Collection<Long> ids, LocalDateTime contactNextTime) {
        businessMapper.updateBatch(convertList(ids, id -> new CrmBusinessDO().setId(id).setContactNextTime(contactNextTime)));
    }

    private void validateCreateRelationDataExists(CrmBusinessCreateReqVO saveReqVO) {
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

    private void validateUpdateRelationDataExists(CrmBusinessUpdateReqVO updateReqVO) {
        customerService.validateCustomer(updateReqVO.getCustomerId());
        if (updateReqVO.getContactId() != null) {
            contactService.validateContact(updateReqVO.getContactId());
        }
    }

    private List<CrmBusinessProductDO> buildBusinessProductsForCreate(List<CrmBusinessProductReqVO> list) {
        validateNoDuplicateProducts(list);
        Set<Long> productIds = convertSet(list, CrmBusinessProductReqVO::getProductId);
        Map<Long, CrmProductDO> productMap = convertMap(productService.validProductList(productIds), CrmProductDO::getId);
        return convertList(list, item -> buildBusinessProduct(item, productMap.get(item.getProductId()).getPrice()));
    }

    private void validateNoDuplicateProducts(List<CrmBusinessProductReqVO> list) {
        Set<Long> productIds = new HashSet<>();
        for (CrmBusinessProductReqVO item : list) {
            if (item == null || item.getProductId() == null || !productIds.add(item.getProductId())) {
                throw exception(BUSINESS_QUOTE_PRODUCT_DUPLICATE);
            }
        }
    }

    private CrmBusinessProductDO buildBusinessProduct(CrmBusinessProductReqVO item, BigDecimal productPrice) {
        validateAmount(item.getBusinessPrice(), 2);
        validateAmount(item.getCount(), 3);
        BigDecimal lineTotal = item.getBusinessPrice().multiply(item.getCount()).setScale(2, RoundingMode.HALF_UP);
        validateDatabaseAmount(lineTotal);
        return new CrmBusinessProductDO().setProductId(item.getProductId()).setProductPrice(productPrice)
                .setBusinessPrice(item.getBusinessPrice()).setCount(item.getCount()).setTotalPrice(lineTotal);
    }

    private void applyQuotationAmounts(CrmBusinessDO business, List<CrmBusinessProductDO> businessProducts,
                                       BigDecimal discountPercent) {
        validateDiscountPercent(discountPercent);
        BigDecimal totalProductPrice = getSumValue(businessProducts, CrmBusinessProductDO::getTotalPrice,
                BigDecimal::add, BigDecimal.ZERO).setScale(2, RoundingMode.HALF_UP);
        BigDecimal discountAmount = totalProductPrice.multiply(discountPercent)
                .divide(new BigDecimal("100"), 2, RoundingMode.HALF_UP);
        BigDecimal totalPrice = totalProductPrice.subtract(discountAmount).setScale(2, RoundingMode.HALF_UP);
        validateDatabaseAmount(totalProductPrice);
        validateDatabaseAmount(totalPrice);
        business.setTotalProductPrice(totalProductPrice).setDiscountPercent(discountPercent)
                .setTotalPrice(totalPrice);
    }

    private void validateDiscountPercent(BigDecimal value) {
        if (value == null || value.scale() > 2 || value.compareTo(BigDecimal.ZERO) < 0
                || value.compareTo(new BigDecimal("100")) > 0) {
            throw exception(BUSINESS_QUOTE_AMOUNT_INVALID);
        }
    }

    private void validateAmount(BigDecimal value, int maxScale) {
        if (value == null || value.scale() > maxScale || getIntegerDigits(value) > 18
                || value.compareTo(BigDecimal.ZERO) <= 0) {
            throw exception(BUSINESS_QUOTE_AMOUNT_INVALID);
        }
    }

    private void validateDatabaseAmount(BigDecimal value) {
        if (value.scale() > 6 || getIntegerDigits(value) > 18) {
            throw exception(BUSINESS_QUOTE_AMOUNT_INVALID);
        }
    }

    private int getIntegerDigits(BigDecimal value) {
        return Math.max(0, value.precision() - value.scale());
    }

    @Override
    @LogRecord(type = CRM_BUSINESS_TYPE, subType = CRM_BUSINESS_UPDATE_STATUS_SUB_TYPE, bizNo = "{{#reqVO.id}}",
            success = CRM_BUSINESS_UPDATE_STATUS_SUCCESS)
    @CrmPermission(bizType = CrmBizTypeEnum.CRM_BUSINESS, bizId = "#reqVO.id", level = CrmPermissionLevelEnum.WRITE)
    @Transactional(rollbackFor = Exception.class)
    public CrmBusinessStatusUpdateRespVO updateBusinessStatus(CrmBusinessUpdateStatusReqVO reqVO) {
        if ((reqVO.getStatusId() == null) == (reqVO.getEndStatus() == null)) {
            throw exception(BUSINESS_STATUS_REQUEST_CONFLICT);
        }
        // 1.1 校验存在
        CrmBusinessDO business = validateBusinessExists(reqVO.getId());
        // 1.2 校验商机未结束
        if (business.getEndStatus() != null) {
            throw exception(BUSINESS_UPDATE_STATUS_FAIL_END_STATUS);
        }
        CrmBusinessStatusDO currentStatus = business.getStatusId() == null ? null
                : businessStatusService.getBusinessStatus(business.getStatusId());
        if (currentStatus == null || !Objects.equals(business.getStatusTypeId(), currentStatus.getTypeId())) {
            throw exception(BUSINESS_STATUS_TRANSITION_NOT_ALLOWED);
        }
        // 1.3 校验商机状态
        CrmBusinessStatusDO status = null;
        int updateCount;
        if (reqVO.getStatusId() != null) {
            if (isNotBlank(reqVO.getLoseReasonCode()) || isNotBlank(reqVO.getEndRemark())) {
                throw exception(BUSINESS_STATUS_REQUEST_CONFLICT);
            }
            status = businessStatusService.validateBusinessStatus(business.getStatusTypeId(), reqVO.getStatusId());
            if (reqVO.getStatusId().equals(business.getStatusId())) {
                throw exception(BUSINESS_UPDATE_STATUS_FAIL_STATUS_EQUALS);
            }
            if (status.getSort() <= currentStatus.getSort()) {
                throw exception(BUSINESS_STATUS_TRANSITION_NOT_ALLOWED);
            }
            updateCount = businessMapper.updateStageByVersion(reqVO.getId(), reqVO.getVersion(), reqVO.getStatusId());
        } else {
            validateEndStatusRequest(reqVO);
            String loseReasonCode = trimToNull(reqVO.getLoseReasonCode());
            String endRemark = trimToNull(reqVO.getEndRemark());
            updateCount = businessMapper.updateEndStatusByVersion(reqVO.getId(), reqVO.getVersion(),
                    reqVO.getEndStatus(), loseReasonCode, endRemark);
        }
        if (updateCount == 0) {
            handleOptimisticLockFailure(reqVO.getId(), true);
        }

        // 3. 记录操作日志上下文
        LogRecordContext.putVariable("businessName", business.getName());
        LogRecordContext.putVariable("oldStatusName", getBusinessStatusName(business.getEndStatus(),
                currentStatus));
        LogRecordContext.putVariable("newStatusName", getBusinessStatusName(reqVO.getEndStatus(), status));
        return new CrmBusinessStatusUpdateRespVO().setId(reqVO.getId()).setVersion(reqVO.getVersion() + 1)
                .setStatusId(reqVO.getStatusId() != null ? reqVO.getStatusId() : business.getStatusId())
                .setEndStatus(reqVO.getEndStatus()).setLoseReasonCode(trimToNull(reqVO.getLoseReasonCode()))
                .setEndRemark(trimToNull(reqVO.getEndRemark()));
    }

    private void validateEndStatusRequest(CrmBusinessUpdateStatusReqVO reqVO) {
        CrmBusinessEndStatusEnum endStatus = CrmBusinessEndStatusEnum.fromStatus(reqVO.getEndStatus());
        if (endStatus == null) {
            throw exception(BUSINESS_STATUS_REQUEST_CONFLICT);
        }
        if (endStatus == CrmBusinessEndStatusEnum.LOSE) {
            String reason = trimToNull(reqVO.getLoseReasonCode());
            if (reason == null) {
                throw exception(BUSINESS_LOSE_REASON_REQUIRED);
            }
            List<DictDataRespDTO> dictDataList = dictDataApi.getDictDataList(CRM_BUSINESS_LOSE_REASON);
            boolean valid = CollUtil.isNotEmpty(dictDataList) && dictDataList.stream().anyMatch(item -> reason.equals(item.getValue())
                    && CommonStatusEnum.isEnable(item.getStatus()));
            if (!valid) {
                throw exception(BUSINESS_LOSE_REASON_INVALID);
            }
            return;
        }
        if (isNotBlank(reqVO.getLoseReasonCode())
                || (endStatus == CrmBusinessEndStatusEnum.WIN && isNotBlank(reqVO.getEndRemark()))) {
            throw exception(BUSINESS_STATUS_REQUEST_CONFLICT);
        }
    }

    private boolean isNotBlank(String value) {
        return value != null && !value.trim().isEmpty();
    }

    private String trimToNull(String value) {
        return isNotBlank(value) ? value.trim() : null;
    }

    private void handleOptimisticLockFailure(Long id, boolean requireActive) {
        CrmBusinessDO latest = businessMapper.selectById(id);
        if (latest == null) {
            throw exception(BUSINESS_NOT_EXISTS);
        }
        if (requireActive && latest.getEndStatus() != null) {
            throw exception(BUSINESS_UPDATE_STATUS_FAIL_END_STATUS);
        }
        throw exception(BUSINESS_VERSION_CONFLICT);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    @CrmPermission(bizType = CrmBizTypeEnum.CRM_BUSINESS, bizId = "#reqVO.id", level = CrmPermissionLevelEnum.WRITE)
    public CrmBusinessQuotationRespVO updateBusinessQuotation(CrmBusinessUpdateQuotationReqVO reqVO) {
        CrmBusinessDO business = validateBusinessExists(reqVO.getId());
        if (business.getEndStatus() != null) {
            throw exception(BUSINESS_UPDATE_STATUS_FAIL_END_STATUS);
        }
        List<CrmBusinessProductDO> products = buildBusinessProductsForQuotation(reqVO.getId(), reqVO.getProducts());
        CrmBusinessDO amountSnapshot = new CrmBusinessDO();
        applyQuotationAmounts(amountSnapshot, products, reqVO.getDiscountPercent());
        if (businessMapper.updateQuotationByVersion(reqVO.getId(), reqVO.getVersion(),
                amountSnapshot.getTotalProductPrice(), amountSnapshot.getDiscountPercent(),
                amountSnapshot.getTotalPrice()) == 0) {
            handleOptimisticLockFailure(reqVO.getId(), true);
        }
        businessProductMapper.deleteByBusinessId(reqVO.getId());
        if (CollUtil.isNotEmpty(products)) {
            products.forEach(product -> product.setBusinessId(reqVO.getId()));
            businessProductMapper.insertBatch(products);
        }
        BigDecimal discountAmount = amountSnapshot.getTotalProductPrice().subtract(amountSnapshot.getTotalPrice());
        return new CrmBusinessQuotationRespVO().setId(reqVO.getId()).setVersion(reqVO.getVersion() + 1)
                .setTotalProductPrice(amountSnapshot.getTotalProductPrice())
                .setDiscountPercent(amountSnapshot.getDiscountPercent()).setDiscountAmount(discountAmount)
                .setTotalPrice(amountSnapshot.getTotalPrice())
                .setProducts(BeanUtils.toBean(products, CrmBusinessQuotationRespVO.Product.class));
    }

    private List<CrmBusinessProductDO> buildBusinessProductsForQuotation(
            Long businessId, List<CrmBusinessProductReqVO> requestProducts) {
        validateNoDuplicateProducts(requestProducts);
        Map<Long, CrmBusinessProductDO> oldProductMap = convertMap(
                businessProductMapper.selectListByBusinessId(businessId), CrmBusinessProductDO::getProductId);
        Set<Long> productIds = convertSet(requestProducts, CrmBusinessProductReqVO::getProductId);
        Map<Long, CrmProductDO> currentProductMap = convertMap(productService.getProductList(productIds), CrmProductDO::getId);
        return convertList(requestProducts, item -> {
            CrmBusinessProductDO oldProduct = oldProductMap.get(item.getProductId());
            CrmProductDO currentProduct = currentProductMap.get(item.getProductId());
            if (oldProduct == null) {
                if (currentProduct == null) {
                    throw exception(PRODUCT_NOT_EXISTS);
                }
                if (CrmProductStatusEnum.isDisable(currentProduct.getStatus())) {
                    throw exception(PRODUCT_NOT_ENABLE, currentProduct.getName());
                }
                return buildBusinessProduct(item, currentProduct.getPrice());
            }
            if ((currentProduct == null || CrmProductStatusEnum.isDisable(currentProduct.getStatus()))
                    && (!sameAmount(oldProduct.getBusinessPrice(), item.getBusinessPrice())
                    || !sameAmount(oldProduct.getCount(), item.getCount()))) {
                throw exception(PRODUCT_NOT_ENABLE, currentProduct != null ? currentProduct.getName() : item.getProductId());
            }
            return buildBusinessProduct(item, oldProduct.getProductPrice());
        });
    }

    private boolean sameAmount(BigDecimal left, BigDecimal right) {
        return left != null && right != null && left.compareTo(right) == 0;
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
