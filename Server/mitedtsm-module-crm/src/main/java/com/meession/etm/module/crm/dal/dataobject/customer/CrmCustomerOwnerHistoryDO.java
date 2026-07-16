package com.meession.etm.module.crm.dal.dataobject.customer;

import com.meession.etm.framework.tenant.core.db.TenantBaseDO;
import com.baomidou.mybatisplus.annotation.KeySequence;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
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
public class CrmCustomerOwnerHistoryDO extends TenantBaseDO {

    @TableId
    private Long id;

    private Long customerId;

    private String changeType;

    private Long beforeOwnerUserId;

    private Long afterOwnerUserId;

    private String reason;

    private Long operatorUserId;

    private LocalDateTime changeTime;

}