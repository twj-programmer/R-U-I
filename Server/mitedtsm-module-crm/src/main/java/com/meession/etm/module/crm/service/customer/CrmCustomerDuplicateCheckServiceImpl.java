package com.meession.etm.module.crm.service.customer;

import com.meession.etm.framework.mybatis.core.query.LambdaQueryWrapperX;
import com.meession.etm.module.crm.controller.admin.customer.vo.customer.CrmCustomerDuplicateCheckRespVO;
import com.meession.etm.module.crm.controller.admin.customer.vo.customer.CrmCustomerDuplicateItemVO;
import com.meession.etm.module.crm.dal.dataobject.customer.CrmCustomerDO;
import com.meession.etm.module.crm.dal.mysql.customer.CrmCustomerMapper;
import com.meession.etm.module.crm.service.customer.bo.CrmCustomerDuplicateCheckBO;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.util.Comparator;
import java.util.List;
import java.util.stream.Collectors;

@Slf4j
@Service
@RequiredArgsConstructor
public class CrmCustomerDuplicateCheckServiceImpl implements CrmCustomerDuplicateCheckService {

    private final CrmCustomerMapper customerMapper;

    @Override
    @Transactional(readOnly = true)
    public CrmCustomerDuplicateCheckRespVO checkDuplicate(CrmCustomerDuplicateCheckBO checkBO) {
        CrmCustomerDuplicateCheckRespVO respVO = new CrmCustomerDuplicateCheckRespVO();

        String normalizedName = normalizeName(checkBO.getName());
        String normalizedMobile = normalizeMobile(checkBO.getMobile());

        List<CrmCustomerDO> candidates = findCandidateCustomers(checkBO);

        List<CrmCustomerDuplicateItemVO> duplicates = candidates.stream()
                .map(customer -> buildDuplicateItem(customer, normalizedName, normalizedMobile))
                .filter(item -> item.getMatchType() != null)
                .sorted(Comparator.comparing(CrmCustomerDuplicateItemVO::getMatchType)
                        .thenComparing(CrmCustomerDuplicateItemVO::getSimilarity, Comparator.reverseOrder())
                        .thenComparing(CrmCustomerDuplicateItemVO::getId, Comparator.reverseOrder()))
                .collect(Collectors.toList());

        respVO.setHasDuplicate(!duplicates.isEmpty());
        respVO.setCandidates(duplicates);
        return respVO;
    }

    private List<CrmCustomerDO> findCandidateCustomers(CrmCustomerDuplicateCheckBO checkBO) {
        LambdaQueryWrapperX<CrmCustomerDO> query = new LambdaQueryWrapperX<>();
        query.neIfPresent(CrmCustomerDO::getId, checkBO.getExcludeId());
        query.eq(CrmCustomerDO::getDeleted, false);

        String normalizedName = normalizeName(checkBO.getName());
        String normalizedMobile = normalizeMobile(checkBO.getMobile());

        boolean hasName = normalizedName != null && !normalizedName.isEmpty();
        boolean hasMobile = normalizedMobile != null && !normalizedMobile.isEmpty();

        if (hasName && hasMobile) {
            query.and(i -> i.like(CrmCustomerDO::getName, normalizedName)
                    .or().eq(CrmCustomerDO::getMobile, normalizedMobile));
        } else if (hasName) {
            query.like(CrmCustomerDO::getName, normalizedName);
        } else if (hasMobile) {
            query.eq(CrmCustomerDO::getMobile, normalizedMobile);
        }

        return customerMapper.selectList(query);
    }

    private CrmCustomerDuplicateItemVO buildDuplicateItem(CrmCustomerDO customer, String normalizedName, String normalizedMobile) {
        CrmCustomerDuplicateItemVO item = new CrmCustomerDuplicateItemVO();
        item.setId(customer.getId());
        item.setName(customer.getName());
        item.setMobileMasked(maskMobile(customer.getMobile()));

        String candidateNormalizedName = normalizeName(customer.getName());
        String candidateNormalizedMobile = normalizeMobile(customer.getMobile());

        double rawSimilarity = calculateLevenshteinSimilarity(normalizedName, candidateNormalizedName);
        BigDecimal nameSimilarity = BigDecimal.valueOf(rawSimilarity).setScale(2, java.math.RoundingMode.HALF_UP);
        item.setSimilarity(nameSimilarity);

        if (normalizedMobile != null && !normalizedMobile.isEmpty() 
                && candidateNormalizedMobile != null && candidateNormalizedMobile.equals(normalizedMobile)) {
            item.setMatchType("STRONG");
        } else if (rawSimilarity >= 0.80) {
            item.setMatchType("SUSPECT");
        }

        return item;
    }

    private String normalizeName(String name) {
        if (name == null) {
            return null;
        }
        String normalized = name.trim().toLowerCase();
        normalized = normalized.replaceAll("\\s+", "");
        normalized = normalized.replaceAll("[\\p{Punct}\\p{Space}]", "");
        return normalized;
    }

    private String normalizeMobile(String mobile) {
        if (mobile == null) {
            return null;
        }
        return mobile.replaceAll("[^0-9]", "");
    }

    private String maskMobile(String mobile) {
        if (mobile == null || mobile.length() < 7) {
            return null;
        }
        return mobile.substring(0, 3) + "****" + mobile.substring(mobile.length() - 4);
    }

    private BigDecimal calculateLevenshteinSimilarityAsBigDecimal(String name1, String name2) {
        if (name1 == null || name2 == null || name1.isEmpty() || name2.isEmpty()) {
            return BigDecimal.ZERO;
        }
        double similarity = calculateLevenshteinSimilarity(name1, name2);
        return BigDecimal.valueOf(similarity).setScale(2, java.math.RoundingMode.HALF_UP);
    }

    private double calculateLevenshteinSimilarity(String s1, String s2) {
        int len1 = s1.length();
        int len2 = s2.length();

        int[][] dp = new int[len1 + 1][len2 + 1];

        for (int i = 0; i <= len1; i++) {
            dp[i][0] = i;
        }
        for (int j = 0; j <= len2; j++) {
            dp[0][j] = j;
        }

        for (int i = 1; i <= len1; i++) {
            for (int j = 1; j <= len2; j++) {
                int cost = s1.charAt(i - 1) == s2.charAt(j - 1) ? 0 : 1;
                dp[i][j] = Math.min(Math.min(dp[i - 1][j] + 1, dp[i][j - 1] + 1), dp[i - 1][j - 1] + cost);
            }
        }

        int distance = dp[len1][len2];
        int maxLen = Math.max(len1, len2);

        return maxLen == 0 ? 0 : 1.0 - (double) distance / maxLen;
    }

}