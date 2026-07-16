// 23计科4班 黄金戈
package com.meession.etm.module.crm.dal.mysql.business;

import com.meession.etm.framework.common.pojo.PageResult;
import com.meession.etm.framework.mybatis.core.mapper.BaseMapperX;
import com.meession.etm.framework.mybatis.core.query.LambdaQueryWrapperX;
import com.meession.etm.framework.mybatis.core.query.MPJLambdaWrapperX;
import com.meession.etm.module.crm.controller.admin.business.vo.business.CrmBusinessPageReqVO;
import com.meession.etm.module.crm.controller.admin.statistics.vo.funnel.CrmStatisticsFunnelReqVO;
import com.meession.etm.module.crm.dal.dataobject.business.CrmBusinessDO;
import com.meession.etm.module.crm.enums.common.CrmBizTypeEnum;
import com.meession.etm.module.crm.util.CrmPermissionUtils;
import com.baomidou.mybatisplus.core.conditions.update.LambdaUpdateWrapper;
import org.apache.ibatis.annotations.Mapper;

import java.util.Collection;
import java.util.List;
import java.math.BigDecimal;

/**
 * 商机 Mapper
 *
 * @author ljlleo
 */
@Mapper
public interface CrmBusinessMapper extends BaseMapperX<CrmBusinessDO> {

    default int updateBasicByVersion(CrmBusinessDO updateObj, Integer version) {
        return update(updateObj, new LambdaUpdateWrapper<CrmBusinessDO>()
                .eq(CrmBusinessDO::getId, updateObj.getId())
                .eq(CrmBusinessDO::getVersion, version)
                .isNull(CrmBusinessDO::getEndStatus)
                .setSql("version = version + 1"));
    }

    default int updateStageByVersion(Long id, Integer version, Long statusId) {
        return update(new LambdaUpdateWrapper<CrmBusinessDO>()
                .eq(CrmBusinessDO::getId, id)
                .eq(CrmBusinessDO::getVersion, version)
                .isNull(CrmBusinessDO::getEndStatus)
                .set(CrmBusinessDO::getStatusId, statusId)
                .setSql("version = version + 1"));
    }

    default int updateEndStatusByVersion(Long id, Integer version, Integer endStatus,
                                         String loseReasonCode, String endRemark) {
        return update(new LambdaUpdateWrapper<CrmBusinessDO>()
                .eq(CrmBusinessDO::getId, id)
                .eq(CrmBusinessDO::getVersion, version)
                .isNull(CrmBusinessDO::getEndStatus)
                .set(CrmBusinessDO::getEndStatus, endStatus)
                .set(CrmBusinessDO::getLoseReasonCode, loseReasonCode)
                .set(CrmBusinessDO::getEndRemark, endRemark)
                .setSql("version = version + 1"));
    }

    default int updateQuotationByVersion(Long id, Integer version, BigDecimal totalProductPrice,
                                         BigDecimal discountPercent, BigDecimal totalPrice) {
        return update(new LambdaUpdateWrapper<CrmBusinessDO>()
                .eq(CrmBusinessDO::getId, id)
                .eq(CrmBusinessDO::getVersion, version)
                .isNull(CrmBusinessDO::getEndStatus)
                .set(CrmBusinessDO::getTotalProductPrice, totalProductPrice)
                .set(CrmBusinessDO::getDiscountPercent, discountPercent)
                .set(CrmBusinessDO::getTotalPrice, totalPrice)
                .setSql("version = version + 1"));
    }

    default int updateOwnerUserIdById(Long id, Long ownerUserId) {
        return update(new LambdaUpdateWrapper<CrmBusinessDO>()
                .eq(CrmBusinessDO::getId, id)
                .set(CrmBusinessDO::getOwnerUserId, ownerUserId));
    }

    default PageResult<CrmBusinessDO> selectPageByCustomerId(CrmBusinessPageReqVO pageReqVO) {
        return selectPage(pageReqVO, new LambdaQueryWrapperX<CrmBusinessDO>()
                .eq(CrmBusinessDO::getCustomerId, pageReqVO.getCustomerId()) // 指定客户编号
                .likeIfPresent(CrmBusinessDO::getName, pageReqVO.getName())
                .orderByDesc(CrmBusinessDO::getId));
    }

    default PageResult<CrmBusinessDO> selectPageByContactId(CrmBusinessPageReqVO pageReqVO, Collection<Long> businessIds) {
        return selectPage(pageReqVO, new LambdaQueryWrapperX<CrmBusinessDO>()
                .in(CrmBusinessDO::getId, businessIds) // 指定商机编号
                .likeIfPresent(CrmBusinessDO::getName, pageReqVO.getName())
                .orderByDesc(CrmBusinessDO::getId));
    }

    default PageResult<CrmBusinessDO> selectPage(CrmBusinessPageReqVO pageReqVO, Long userId) {
        MPJLambdaWrapperX<CrmBusinessDO> query = new MPJLambdaWrapperX<>();
        // 拼接数据权限的查询条件
        CrmPermissionUtils.appendPermissionCondition(query, CrmBizTypeEnum.CRM_BUSINESS.getType(),
                CrmBusinessDO::getId, userId, pageReqVO.getSceneType());
        // 拼接自身的查询条件
        query.selectAll(CrmBusinessDO.class)
                .likeIfPresent(CrmBusinessDO::getName, pageReqVO.getName())
                .orderByDesc(CrmBusinessDO::getId);
        return selectJoinPage(pageReqVO, CrmBusinessDO.class, query);
    }

    default Long selectCountByStatusTypeId(Long statusTypeId) {
        return selectCount(CrmBusinessDO::getStatusTypeId, statusTypeId);
    }

    default List<CrmBusinessDO> selectListByCustomerIdOwnerUserId(Long customerId, Long ownerUserId) {
        return selectList(new LambdaQueryWrapperX<CrmBusinessDO>()
                .eq(CrmBusinessDO::getCustomerId, customerId)
                .eq(CrmBusinessDO::getOwnerUserId, ownerUserId));
    }

    default PageResult<CrmBusinessDO> selectPage(CrmStatisticsFunnelReqVO pageVO) {
        return selectPage(pageVO, new LambdaQueryWrapperX<CrmBusinessDO>()
                .in(CrmBusinessDO::getOwnerUserId, pageVO.getUserIds())
                .betweenIfPresent(CrmBusinessDO::getCreateTime, pageVO.getTimes()));
    }

}
