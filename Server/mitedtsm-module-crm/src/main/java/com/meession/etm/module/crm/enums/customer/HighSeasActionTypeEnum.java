package com.meession.etm.module.crm.enums.customer;

import lombok.AllArgsConstructor;
import lombok.Getter;

@Getter
@AllArgsConstructor
public enum HighSeasActionTypeEnum {

    MANUAL_PUT("MANUAL_PUT", "手动移入公海"),
    AUTO_PUT("AUTO_PUT", "自动移入公海"),
    RECEIVE("RECEIVE", "领取公海客户"),
    ASSIGN("ASSIGN", "分配"),
    TRANSFER("TRANSFER", "转移");

    private final String type;

    private final String desc;

    public static String getDesc(String type) {
        for (HighSeasActionTypeEnum e : values()) {
            if (e.type.equals(type)) {
                return e.desc;
            }
        }
        return type;
    }

}