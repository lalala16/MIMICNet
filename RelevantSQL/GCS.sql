SET search_path TO mimiciii;

DROP TABLE public.GCS;
CREATE TABLE public.GCS 
AS (
  SELECT 
    var.subject_id,
    var.icustay_id,
    var.charttime - var.intime,
    var.valuenum AS value
  FROM (
    SELECT
      p.*,
      ce.row_id,
      ce.itemid,
      ce.charttime,
      ce.storetime,
      ce.cgid,
      ce.value,
      ce.valuenum,
      ce.valueuom,
      ce.warning,
      ce.error,
      ce.resultstatus,
      ce.stopped
    FROM pop p 
      LEFT JOIN chartevents ce ON p.icustay_id = ce.icustay_id
  ) var
  WHERE var.itemid IN (198, 226755)
  AND var.subject_id < 30000
  AND var.charttime BETWEEN var.intime AND var.outtime
);
\COPY public.GCS TO '../Data/GCS.csv' DELIMITER ',' CSV HEADER;