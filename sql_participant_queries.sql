--SQL Query for participant data. 
"SELECT distinct concat(p.program_id,p.program_participant_id),
                substr(p.program_id,6,2),
                substr(i.exit_status,1,10),
                decode(substr(i.exit_status,1,4),'Term',0,
                                                'Grad',1,
                                                'Disc',0,
                                                'Comp',1),                                                
                i.acceptance_date,
                i.arrest_date,
                i.referral_date,
                i.acceptance_type,
                i.exit_date,
                i.referral_source,
                p.dob,
                p.gender,
                p.race,
                p.EMP_UNSTABLE_CHRONIC,
                d.diagnosis,
                d.diagnosis_reason,
                d.diagnosis_level,
                ea.emp_assist_type,
                m.PRIMARY_DRUG_CHOICE,
                m.Secondary_DRUG_CHOICE,
                count(distinct si.SANC_INCENT_ID),
                count(distinct t.treatment_id) ,
                count(distinct dt.drug_test_id) ,
                count(distinct ea.emp_assist_id) ,
                count(distinct js_hearing_id)

FROM acctct.participant p, 
    acctct.intake i, 
    acctct.diagnosis d,
    acctct.drug_test dt,
    ACCTCT.employment_assistance ea,
    ACCTCT.judicial_status_hearing js,
    ACCTCT.sanction_incentive si,
    acctct.treatment t, acctct.monitoring m
WHERE    i.participant_id = p.participant_id
    and d.participant_id (+)= p.participant_id
    and dt.participant_id (+)= p.participant_id
    and ea.participant_id (+)= p.participant_id
    and js.participant_id (+)= p.participant_id
    and si.participant_id (+)= p.participant_id
    and t.participant_id (+)= p.participant_id
    and m.participant_id (+)= p.participant_id
    and i.exit_date > '30-JUN-2020'
GROUP BY concat(p.program_id,p.program_participant_id),
                substr(p.program_id,6,2),
                substr(i.exit_status,1,10),
                decode(substr(i.exit_status,1,4),'Term',0,
                                                'Grad',1,
                                                'Disc',0,
                                                'Comp',1),                                                
                i.acceptance_date,
                i.arrest_date,
                i.referral_date,
                i.acceptance_type,
                i.exit_date,
                i.referral_source,
                p.dob,
                p.gender,
                p.race,
                p.EMP_UNSTABLE_CHRONIC,
                d.diagnosis,
                d.diagnosis_reason,
                d.diagnosis_level,
                ea.emp_assist_type,
                m.PRIMARY_DRUG_CHOICE,
                m.Secondary_DRUG_CHOICE
ORDER BY concat(p.program_id,p.program_participant_id),
                substr(p.program_id,6,2),
                substr(i.exit_status,1,10),
                decode(substr(i.exit_status,1,4),'Term',0,
                                                'Grad',1,
                                                'Disc',0,
                                                'Comp',1),                                                
                i.acceptance_date,
                i.arrest_date,
                i.referral_date,
                i.acceptance_type,
                i.exit_date,
                i.referral_source,
                p.dob,
                p.gender,
                p.race,
                p.EMP_UNSTABLE_CHRONIC,
                d.diagnosis,
                d.diagnosis_reason,
                d.diagnosis_level,
                ea.emp_assist_type,
                m.PRIMARY_DRUG_CHOICE,
                m.Secondary_DRUG_CHOICE"
*********************************************************
--Entry data for education, employment, risk level

SELECT distinct concat(p.program_id,p.program_participant_id),
        p.EDUCATION_LEVEL,
        p.emp_status,
        p.income_level,
        p.residence_county, 
        a.risk_level
FROM acctct.participant p, acctct.intake i, acctct.assessment a
WHERE i.participant_id = p.participant_id
    and a.participant_id = p.participant_id

and p.participant_id in(select min(p.participant_id)
    from acctct.participant p
    where p.emp_status is not null
    and  p.rid in
        (select p.rid
        from acctct.participant p, acctct.intake i
        where i.participant_id=p.participant_id
        and i.exit_date > '30-JUN-2020'
        group by p.rid)
    group by p.rid)



