package com.meession.etm.module.crm.dal.dataobject.customer;

import com.meession.etm.framework.mybatis.core.dataobject.BaseDO;
import com.baomidou.mybatisplus.annotation.*;
import lombok.*;

import java.time.LocalDateTime;

@TableName(value = "crm_customer_owner_history")
@KeySequence("crm_customer_owner_history_seq")
@Data
@EqualsAndHashCode(callSuper = true)
@ToString(callSuper = true)
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class CrmCustomerOwnerHistoryDO extends BaseDO {

    @TableId
    private Long id;

    private Long customerId;

    private String changeType;

    private Long oldOwnerUserId;

    private Long newOwnerUserId;

    private String reason;

    private Long operatorUserId;

    private LocalDateTime changeTime;

}