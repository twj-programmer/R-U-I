package com.meession.etm.module.crm.service.customer;

import com.meession.etm.framework.common.pojo.PageResult;
import com.meession.etm.framework.common.util.object.BeanUtils;
import com.meession.etm.framework.tenant.core.context.TenantContextHolder;
import com.meession.etm.module.crm.controller.admin.customer.vo.pool.CrmHighSeasRecordPageReqVO;
import com.meession.etm.module.crm.controller.admin.customer.vo.pool.CrmHighSeasRecordRespVO;
import com.meession.etm.module.crm.dal.dataobject.customer.CrmHighSeasRecordDO;
import com.meession.etm.module.crm.dal.mysql.customer.CrmHighSeasRecordMapper;
import com.meession.etm.module.crm.enums.customer.HighSeasActionTypeEnum;
import com.meession.etm.module.crm.service.customer.bo.CrmHighSeasRecordCreateBO;
import com.meession.etm.module.system.api.user.AdminUserApi;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class CrmHighSeasRecordServiceImpl implements CrmHighSeasRecordService {

    private final CrmHighSeasRecordMapper highSeasRecordMapper;
    private final AdminUserApi adminUserApi;

    @Override
    @Transactional
    public void createRecord(CrmHighSeasRecordCreateBO createBO) {
        CrmHighSeasRecordDO recordDO = BeanUtils.toBean(createBO, CrmHighSeasRecordDO.class);
        recordDO.setActionTime(LocalDateTime.now());
        recordDO.setTenantId(TenantContextHolder.getTenantId());
        highSeasRecordMapper.insert(recordDO);
    }

    @Override
    public PageResult<CrmHighSeasRecordRespVO> getPage(CrmHighSeasRecordPageReqVO reqVO) {
        int offset = (reqVO.getPageNo() - 1) * reqVO.getPageSize();
        reqVO.setOffset(offset);
        reqVO.setSize(reqVO.getPageSize());

        List<CrmHighSeasRecordDO> list = highSeasRecordMapper.selectPageByCondition(reqVO);
        int total = highSeasRecordMapper.selectCountByCondition(reqVO);

        List<CrmHighSeasRecordRespVO> respList = list.stream()
                .map(this::buildRespVO)
                .collect(Collectors.toList());

        return new PageResult<>(respList, total);
    }

    @Override
    public CrmHighSeasRecordRespVO getById(Long id) {
        CrmHighSeasRecordDO recordDO = highSeasRecordMapper.selectById(id);
        return recordDO != null ? buildRespVO(recordDO) : null;
    }

    @Override
    public List<CrmHighSeasRecordRespVO> getByCustomerId(Long customerId) {
        List<CrmHighSeasRecordDO> list = highSeasRecordMapper.selectByCustomerId(customerId, TenantContextHolder.getTenantId());
        return list.stream()
                .map(this::buildRespVO)
                .collect(Collectors.toList());
    }

    @Override
    public Long countTodayReceived(Long userId) {
        LocalDateTime todayStart = LocalDateTime.of(LocalDate.now(), LocalTime.MIN);
        return highSeasRecordMapper.countTodayReceivedByUserId(userId, todayStart, TenantContextHolder.getTenantId());
    }

    @Override
    public boolean checkCooldown(Long userId, Long customerId, Integer cooldownDays) {
        LocalDateTime cooldownStart = LocalDateTime.now().minusDays(cooldownDays);
        Long count = highSeasRecordMapper.countReceivedInDaysByUserIdAndCustomerId(userId, customerId, cooldownStart, TenantContextHolder.getTenantId());
        return count == null || count == 0;
    }

    private CrmHighSeasRecordRespVO buildRespVO(CrmHighSeasRecordDO recordDO) {
        CrmHighSeasRecordRespVO respVO = BeanUtils.toBean(recordDO, CrmHighSeasRecordRespVO.class);
        respVO.setActionTypeDesc(HighSeasActionTypeEnum.getDesc(recordDO.getActionType()));

        if (recordDO.getBeforeOwnerUserId() != null) {
            respVO.setBeforeOwnerUserName(getUserName(recordDO.getBeforeOwnerUserId()));
        }
        if (recordDO.getAfterOwnerUserId() != null) {
            respVO.setAfterOwnerUserName(getUserName(recordDO.getAfterOwnerUserId()));
        }
        if (recordDO.getOperatorUserId() != null) {
            respVO.setOperatorUserName(getUserName(recordDO.getOperatorUserId()));
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