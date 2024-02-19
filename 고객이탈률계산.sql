WITH	
    date_range AS (
					SELECT	DATE '2018-01-01'		AS START_DATE
						,	DATE '2019-01-01'		AS END_DATE
                )
                ,
    start_customer 
                AS (
                    SELECT	distinct df.customer_id
                    FROM	churn_dataset AS cd
                    JOIN
                            date_range AS d
                    ON		cd.first_buy_date <= d.start_date
                    AND		cd.churn_limit_date > d.start_date
                )
                ,
    end_customer 
                AS (
					SELECT	distinct cd.customer_id
					FROM	churn_dataset AS cd
					JOIN
							date_range AS d
					ON		cd.first_buy_date <= d.end_date
					AND		cd.churn_limit_date > d.end_date
                )
                ,
    churned_customer 
                AS (
                    SELECT	s.customer_id
                    FROM	start_customer AS s
                    LEFT OUTER JOIN
                            end_customer AS e
                    ON		s.customer_id = e.customer_id
                    WHERE	E.customer_id is null
                )
                , 
    start_count 
                AS (
                    SELECT	count(*)	        AS n_start
                    FROM	start_customer
                )
                ,
    churn_count 
                AS (
                    SELECT	count(*)	        AS n_churn
                    FROM	churned_customer
                )		
                    
                    SELECT	cast(n_churn AS float)/n_start			AS churn_rate
                        ,	1 - CAST(N_CHURN AS FLOAT)/n_start 		AS retention_rate
                        ,	n_start
                        ,	n_churn
                    FROM	start_count 
                        ,	churn_count
                    ;