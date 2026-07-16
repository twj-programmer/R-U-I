package com.meession.etm.module.crm.support;

import com.meession.etm.framework.tenant.core.context.TenantContextHolder;
import com.meession.etm.framework.mybatis.core.util.MyBatisUtils;
import com.baomidou.mybatisplus.extension.plugins.MybatisPlusInterceptor;
import com.baomidou.mybatisplus.extension.plugins.inner.TenantLineInnerInterceptor;
import com.baomidou.mybatisplus.extension.plugins.handler.TenantLineHandler;
import com.baomidou.mybatisplus.extension.toolkit.SqlParserUtils;
import net.sf.jsqlparser.expression.Expression;
import net.sf.jsqlparser.expression.LongValue;
import org.springframework.beans.BeansException;
import org.springframework.beans.factory.config.BeanPostProcessor;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
public class TenantTestConfiguration {

    @Bean
    public BeanPostProcessor mybatisPlusInterceptorPostProcessor() {
        return new BeanPostProcessor() {
            @Override
            public Object postProcessAfterInitialization(Object bean, String beanName) throws BeansException {
                if (bean instanceof MybatisPlusInterceptor) {
                    MybatisPlusInterceptor interceptor = (MybatisPlusInterceptor) bean;
                    TenantLineInnerInterceptor testInterceptor = new TenantLineInnerInterceptor(new TenantLineHandler() {
                        @Override
                        public Expression getTenantId() {
                            return new LongValue(TenantContextHolder.getRequiredTenantId());
                        }

                        @Override
                        public boolean ignoreTable(String tableName) {
                            if (TenantContextHolder.isIgnore()) {
                                return true;
                            }
                            String cleanTableName = SqlParserUtils.removeWrapperSymbol(tableName);
                            return !cleanTableName.toLowerCase().startsWith("crm_");
                        }
                    });
                    MyBatisUtils.addInterceptor(interceptor, testInterceptor, 0);
                }
                return bean;
            }
        };
    }
}