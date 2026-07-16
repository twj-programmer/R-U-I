package com.meession.etm.module.crm.service.customer;

import com.meession.etm.framework.common.pojo.PageResult;
import com.meession.etm.framework.common.util.object.BeanUtils;
import com.meession.etm.framework.tenant.core.context.TenantContextHolder;
import com.meession.etm.module.crm.controller.admin.customer.vo.ownerhistory.CrmCustomerOwnerHistoryPageReqVO;
import com.meession.etm.module.crm.controller.admin.customer.vo.ownerhistory.CrmCustomerOwnerHistoryRespVO;
import com.meession.etm.module.crm.dal.dataobject.customer.CrmCustomerOwnerHistoryDO;
import com.meession.etm.module.crm.dal.mysql.customer.CrmCustomerOwnerHistoryMapper;
import com.meession.etm.module.crm.enums.customer.OwnerChangeTypeEnum;
import com.meession.etm.module.crm.service.customer.bo.CrmCustomerOwnerHistoryCreateBO;
import com.meession.etm.module.system.api.user.AdminUserApi;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class CrmCustomerOwnerHistoryServiceImpl implements CrmCustomerOwnerHistoryService {

    private final CrmCustomerOwnerHistoryMapper ownerHistoryMapper;
    private final AdminUserApi adminUserApi;

    @Override
    @Transactional
    public void createHistory(CrmCustomerOwnerHistoryCreateBO createBO) {
        CrmCustomerOwnerHistoryDO historyDO = BeanUtils.toBean(createBO, CrmCustomerOwnerHistoryDO.class);
        historyDO.setChangeTime(LocalDateTime.now());
        historyDO.setTenantId(TenantContextHolder.getTenantId());
        ownerHistoryMapper.insert(historyDO);
    }

    @Override
    public PageResult<CrmCustomerOwnerHistoryRespVO> getPage(CrmCustomerOwnerHistoryPageReqVO reqVO) {
        int offset = (reqVO.getPageNo() - 1) * reqVO.getPageSize();
        reqVO.setOffset(offset);
        reqVO.setSize(reqVO.getPageSize());

        List<CrmCustomerOwnerHistoryDO> list = ownerHistoryMapper.selectPageByCondition(reqVO);
        int total = ownerHistoryMapper.selectCountByCondition(reqVO);

        List<CrmCustomerOwnerHistoryRespVO> respList = list.stream()
                .map(this::buildRespVO)
                .collect(Collectors.toList());

        return new PageResult<>(respList, (long) total);
    }

    @Override
    public List<CrmCustomerOwnerHistoryRespVO> getByCustomerId(Long customerId) {
        List<CrmCustomerOwnerHistoryDO> list = ownerHistoryMapper.selectByCustomerId(customerId, TenantContextHolder.getTenantId());
        return list.stream()
                .map(this::buildRespVO)
                .collect(Collectors.toList());
    }

    private CrmCustomerOwnerHistoryRespVO buildRespVO(CrmCustomerOwnerHistoryDO historyDO) {
        CrmCustomerOwnerHistoryRespVO respVO = BeanUtils.toBean(historyDO, CrmCustomerOwnerHistoryRespVO.class);
        respVO.setChangeTypeDesc(OwnerChangeTypeEnum.getDesc(historyDO.getChangeType()));

        if (historyDO.getBeforeOwnerUserId() != null) {
            respVO.setBeforeOwnerUserName(getUserName(historyDO.getBeforeOwnerUserId()));
        }
        if (historyDO.getAfterOwnerUserId() != null) {
            respVO.setAfterOwnerUserName(getUserName(historyDO.getAfterOwnerUserId()));
        }
        if (historyDO.getOperatorUserId() != null) {
            respVO.setOperatorUserName(getUserName(historyDO.getOperatorUserId()));
        }

        return respVO;
    }

    private String getUserName(Long userId) {
        try {
            return adminUserApi.getUser(userId).getNickname();
        } catch (Exception e) {
            return userId == 0 ? "系统" : String.valueOf(userId);
        }
    }

}