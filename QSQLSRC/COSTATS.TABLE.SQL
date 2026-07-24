-- ****************************************************************
-- The following SQL code for the creation of table:
--   COMPANY_STATS
-- was generated from the object and has been altered by
-- Aldon LM(i) to meet the requirements of one step in the process
-- by which Aldon LM(i) would create the object.
-- ****************************************************************
CREATE TABLE &LIB/COSTATS (
  NBEMP INTEGER DEFAULT NULL ,
  NBPRODUCT INTEGER DEFAULT NULL ,
  REVENUE DECIMAL(15, 0) DEFAULT NULL ) ;

COMMENT ON TABLE COSTATS
  IS 'Company Stats Table' ;
