package com.meession.etm.module.crm.enums.customer;

import lombok.AllArgsConstructor;
import lombok.Getter;

@Getter
@AllArgsConstructor
public enum OwnerChangeTypeEnum {

    RECEIVE("RECEIVE", "领取"),
    ASSIGN("ASSIGN", "分配"),
    TRANSFER("TRANSFER", "转移"),
    PUT_POOL("PUT_POOL", "移入公海");

    private final String type;

    private final String desc;

    public static String getDesc(String type) {
        for (OwnerChangeTypeEnum e : values()) {
            if (e.type.equals(type)) {
                return e.desc;
            }
        }
        return type;
    }

}