-- SQL Command to Create Materilized View GAP_PRODUCTS.FOSS_CATCH
--
-- Created by querying records from GAP_PRODUCTS.CPUE but only using hauls 
-- with ABUNDANCE_HAUL = 'Y' from the five survey areas w/ survey_definition_id:
-- "AI" = 52, "GOA" = 47, "EBS" = 98, "BSS" = 78, "NBS" = 143
--
-- Contributors: Ned Laman (ned.laman@noaa.gov), 
--               Zack Oyafuso (zack.oyafuso@noaa.gov), 
--               Emily Markowitz (emily.markowitz@noaa.gov)
--

CREATE MATERIALIZED VIEW GAP_PRODUCTS.FOSS_CATCH AS
SELECT DISTINCT 
cp.HAULJOIN,
cp.SPECIES_CODE, 
cp.CPUE_KGKM2, 
cp.CPUE_NOKM2,
cp.AREA_SWEPT_KM2
cp.COUNT, 
cp.WEIGHT_KG, 
tc.TAXON_CONFIDENCE,
tt.SCIENTIFIC_NAME,
tt.COMMON_NAME,
tt.ID_RANK,
--tt.WORMS,
--tt.ITIS
FROM GAP_PRODUCTS.CPUE cp
LEFT JOIN GAP_PRODUCTS.TEST_SPECIES_CLASSIFICATION tt
--LEFT JOIN GAP_PRODUCTS.V_TAXONOMICS tt
ON cp.SPECIES_CODE = tt.SPECIES_CODE
LEFT JOIN GAP_PRODUCTS.AKFIN_HAUL hh
ON cp.HAULJOIN = hh.HAULJOIN
LEFT JOIN GAP_PRODUCTS.AKFIN_CRUISES cc
ON hh.CRUISEJOIN = cc.CRUISEJOIN
LEFT JOIN GAP_PRODUCTS.TAXON_CONFIDENCE tc
ON cp.SPECIES_CODE = tc.SPECIES_CODE 
AND cc.SURVEY_DEFINITION_ID = tc.SURVEY_DEFINITION_ID
AND cc.YEAR = tc.YEAR
WHERE hh.ABUNDANCE_HAUL = 'Y' 
AND hh.HAUL_TYPE = 3
AND hh.PERFORMANCE >= 0
AND cc.SURVEY_DEFINITION_ID IN (143, 98, 47, 52, 78)
AND cc.YEAR != 2020 -- no surveys happened this year because of COVID
AND (cc.YEAR >= 1982 AND cc.SURVEY_DEFINITION_ID IN (98, 143) -- EBS/NBS survey standard temporal stanza starts in 1982
OR cc.SURVEY_DEFINITION_ID = 78 -- keep all years of the BSS
OR cc.YEAR >= 1991 AND cc.SURVEY_DEFINITION_ID IN (52) -- AI survey standard temporal stanza starts in 1991
OR cc.YEAR >= 1993 AND cc.SURVEY_DEFINITION_ID IN (47)) -- GOA survey standard temporal stanza starts in 1993
