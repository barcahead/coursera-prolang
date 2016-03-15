is_older((2010,1,2), (2010,1,2))
is_older((2010,1,2), (2011,1,1))
is_older((2010,1,2), (2010,2,1))

number_in_month([(2010,1,2),(2010,2,3),(2010,1,32)], 1)

number_in_months([(2010,1,2),(2010,2,3),(2010,1,32)], [1,2,3])

dates_in_month([(2010,1,2),(2010,2,3),(2010,1,32)], 1)

dates_in_months([(2010,1,2),(2010,2,3),(2010,1,32)], [1,2,3])

get_nth(["a", "b", "c"], 1)
get_nth(["a", "b", "c"], 2)
get_nth(["a", "b", "c"], 3)

date_to_string((2010,3,25))

number_before_reaching_sum(3,[1,1,1,1,1])
number_before_reaching_sum(5,[1,1,1,1,1])

what_month(334)
what_month(335)

month_range((30,32))
month_range((30,30))

oldest([(2011,1,31),(2011,2,1),(2010,12,31)])
oldest([(2011,1,311),(2011,2,111),(2010,12,311)])
oldest([])

number_in_months_challenge([(2010,1,2),(2010,2,3),(2010,1,32)], [1,2,3,2,3])

dates_in_months_challenge([(2010,1,2),(2010,2,3),(2010,1,32)], [1,2,3,2,3])

reasonable_date((2000,2,29))
reasonable_date((2000,2,28))