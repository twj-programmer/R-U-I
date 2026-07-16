// 23计科4班 黄金戈
package com.meession.etm.module.crm.dal.mysql.business;

import com.baomidou.mybatisplus.extension.plugins.MybatisPlusInterceptor;
import com.baomidou.mybatisplus.extension.plugins.inner.TenantLineInnerInterceptor;
import com.meession.etm.framework.mybatis.core.util.MyBatisUtils;
import com.meession.etm.framework.tenant.config.TenantProperties;
import com.meession.etm.framework.tenant.core.db.TenantDatabaseInterceptor;
import com.meession.etm.framework.tenant.core.util.TenantUtils;
import com.meession.etm.framework.test.core.ut.BaseDbUnitTest;
import jakarta.annotation.Resource;
import org.junit.jupiter.api.Test;
import org.springframework.boot.test.context.TestConfiguration;
import org.springframework.beans.factory.config.BeanPostProcessor;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Import;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.test.context.jdbc.Sql;
import org.springframework.transaction.PlatformTransactionManager;
import org.springframework.transaction.support.TransactionTemplate;

import javax.sql.DataSource;
import java.util.List;
import java.util.concurrent.CountDownLatch;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.concurrent.Future;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertThrows;

@Import(CrmBusinessMapperDbTest.TenantSqlConfiguration.class)
@Sql(scripts = "classpath:sql/d2-business-state-machine-test.sql")
class CrmBusinessMapperDbTest extends BaseDbUnitTest {

    private static final Long TENANT_A = 1001L;
    private static final Long TENANT_B = 1002L;

    @Resource
    private CrmBusinessMapper businessMapper;
    @Resource
    private JdbcTemplate jdbcTemplate;
    @Resource
    private TransactionTemplate transactionTemplate;

    @Test
    void updateStageByVersion_shouldMatchIdTenantAndVersion() {
        insertBusiness(1L, TENANT_A, 2, 11L);
        insertBusiness(2L, TENANT_B, 2, 11L);

        assertEquals(1, TenantUtils.execute(TENANT_A,
                () -> businessMapper.updateStageByVersion(1L, 2, 13L)));
        assertEquals(0, TenantUtils.execute(TENANT_A,
                () -> businessMapper.updateStageByVersion(2L, 2, 13L)));
        assertEquals(0, TenantUtils.execute(TENANT_A,
                () -> businessMapper.updateStageByVersion(1L, 2, 14L)));

        assertEquals(List.of(13L, 3), readStageAndVersion(1L));
        assertEquals(List.of(11L, 2), readStageAndVersion(2L));
    }

    @Test
    void updateStageByVersion_shouldAllowOnlyOneConcurrentWinner() throws Exception {
        insertBusiness(3L, TENANT_A, 0, 11L);
        ExecutorService executor = Executors.newFixedThreadPool(2);
        CountDownLatch ready = new CountDownLatch(2);
        CountDownLatch start = new CountDownLatch(1);
        try {
            Future<Integer> first = executor.submit(() -> concurrentUpdate(ready, start, 12L));
            Future<Integer> second = executor.submit(() -> concurrentUpdate(ready, start, 13L));
            ready.await();
            start.countDown();

            assertEquals(1, first.get() + second.get());
            assertEquals(1, readStageAndVersion(3L).get(1));
        } finally {
            executor.shutdownNow();
        }
    }

    @Test
    void updateStageByVersion_shouldRollbackRealSqlTransaction() {
        insertBusiness(4L, TENANT_A, 0, 11L);

        assertThrows(IllegalStateException.class, () -> TenantUtils.execute(TENANT_A, () ->
                transactionTemplate.executeWithoutResult(status -> {
                    assertEquals(1, businessMapper.updateStageByVersion(4L, 0, 12L));
                    throw new IllegalStateException("force rollback");
                })));

        assertEquals(List.of(11L, 0), readStageAndVersion(4L));
    }

    private int concurrentUpdate(CountDownLatch ready, CountDownLatch start, Long statusId) throws Exception {
        ready.countDown();
        start.await();
        return TenantUtils.execute(TENANT_A,
                () -> businessMapper.updateStageByVersion(3L, 0, statusId));
    }

    private void insertBusiness(Long id, Long tenantId, Integer version, Long statusId) {
        jdbcTemplate.update("INSERT INTO crm_business " +
                        "(id, name, customer_id, status_type_id, status_id, version, deleted, tenant_id) " +
                        "VALUES (?, ?, ?, ?, ?, ?, FALSE, ?)",
                id, "business-" + id, 1L, 10L, statusId, version, tenantId);
    }

    private List<Object> readStageAndVersion(Long id) {
        return jdbcTemplate.queryForObject(
                "SELECT status_id, version FROM crm_business WHERE id = ?",
                (rs, rowNum) -> List.of(rs.getLong("status_id"), rs.getInt("version")), id);
    }

    @TestConfiguration
    static class TenantSqlConfiguration {

        @Bean
        JdbcTemplate jdbcTemplate(DataSource dataSource) {
            return new JdbcTemplate(dataSource);
        }

        @Bean
        TransactionTemplate transactionTemplate(PlatformTransactionManager transactionManager) {
            return new TransactionTemplate(transactionManager);
        }

        @Bean
        static BeanPostProcessor tenantSqlInterceptorCustomizer() {
            return new BeanPostProcessor() {
                @Override
                public Object postProcessAfterInitialization(Object bean, String beanName) {
                    if (bean instanceof MybatisPlusInterceptor interceptor) {
                        TenantLineInnerInterceptor inner = new TenantLineInnerInterceptor(
                                new TenantDatabaseInterceptor(new TenantProperties()));
                        MyBatisUtils.addInterceptor(interceptor, inner, 0);
                    }
                    return bean;
                }
            };
        }
    }
}
