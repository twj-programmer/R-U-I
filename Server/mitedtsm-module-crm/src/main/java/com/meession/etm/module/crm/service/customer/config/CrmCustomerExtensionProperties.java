package com.meession.etm.module.crm.service.customer.config;

import lombok.Data;
import org.springframework.boot.context.properties.ConfigurationProperties;

@Data
@ConfigurationProperties(prefix = "crm.customer.extension")
public class CrmCustomerExtensionProperties {

    private Pool pool = new Pool();

    @Data
    public static class Pool {
        private Integer dailyReceiveLimit = 10;
        private Integer receiveCooldownDays = 30;
    }

}