package com.meession.etm.module.crm.support;

import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

@Mapper
public interface CrmTestMapper {

    @Insert("INSERT INTO crm_customer (id, name, follow_up_status, owner_user_id, owner_time, lock_status, deal_status, mobile, telephone, email, industry_id, level, source, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (#{id}, #{name}, #{followUpStatus}, #{ownerUserId}, #{ownerTime}, #{lockStatus}, #{dealStatus}, #{mobile}, #{telephone}, #{email}, #{industryId}, #{level}, #{source}, #{creator}, #{createTime}, #{updater}, #{updateTime}, #{deleted}, #{tenantId})")
    void insertCustomer(@Param("id") Long id, @Param("name") String name,
                        @Param("followUpStatus") Boolean followUpStatus,
                        @Param("ownerUserId") Long ownerUserId, @Param("ownerTime") java.time.LocalDateTime ownerTime,
                        @Param("lockStatus") Boolean lockStatus, @Param("dealStatus") Boolean dealStatus,
                        @Param("mobile") String mobile, @Param("telephone") String telephone,
                        @Param("email") String email, @Param("industryId") Integer industryId,
                        @Param("level") Integer level, @Param("source") Integer source,
                        @Param("creator") String creator, @Param("createTime") java.time.LocalDateTime createTime,
                        @Param("updater") String updater, @Param("updateTime") java.time.LocalDateTime updateTime,
                        @Param("deleted") Boolean deleted, @Param("tenantId") Long tenantId);

    @Insert("INSERT INTO crm_clue (id, name, follow_up_status, owner_user_id, transform_status, mobile, telephone, email, industry_id, level, source, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (#{id}, #{name}, #{followUpStatus}, #{ownerUserId}, #{transformStatus}, #{mobile}, #{telephone}, #{email}, #{industryId}, #{level}, #{source}, #{creator}, #{createTime}, #{updater}, #{updateTime}, #{deleted}, #{tenantId})")
    void insertClue(@Param("id") Long id, @Param("name") String name,
                    @Param("followUpStatus") Boolean followUpStatus, @Param("ownerUserId") Long ownerUserId,
                    @Param("transformStatus") Boolean transformStatus,
                    @Param("mobile") String mobile, @Param("telephone") String telephone,
                    @Param("email") String email, @Param("industryId") Integer industryId,
                    @Param("level") Integer level, @Param("source") Integer source,
                    @Param("creator") String creator, @Param("createTime") java.time.LocalDateTime createTime,
                    @Param("updater") String updater, @Param("updateTime") java.time.LocalDateTime updateTime,
                    @Param("deleted") Boolean deleted, @Param("tenantId") Long tenantId);
}